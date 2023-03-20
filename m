Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2DA6C090A
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 03:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCTCzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 22:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCTCzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 22:55:09 -0400
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C603B767;
        Sun, 19 Mar 2023 19:55:05 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-05 (Coremail) with SMTP id zQCowACXn8_1yhdkQAdvBg--.527S2;
        Mon, 20 Mar 2023 10:54:47 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     simon.horman@corigine.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: Re: [PATCH v2] Bluetooth: 6LoWPAN: Add missing check for skb_clone
Date:   Mon, 20 Mar 2023 10:54:44 +0800
Message-Id: <20230320025444.18428-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowACXn8_1yhdkQAdvBg--.527S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4xCr13uw4rJFyrJw4Dtwb_yoWfWwc_Wr
        n5Z3s2k3yFkr4xu3ZFyrW2yFs5K3sxGF9agwn0van8A3s5ArZ7KrWkKryftr1xGay0vFnI
        9FW2yFZ5Xr9rujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbx8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
        DUUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 18, 2023 at 05:03:21AM +0800, Simon Horman wrote:
> On Wed, Mar 15, 2023 at 03:06:21PM +0800, Jiasheng Jiang wrote:
>> Add the check for the return value of skb_clone since it may return NULL
>> pointer and cause NULL pointer dereference in send_pkt.
>> 
>> Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>> ---
>> Changelog:
>> 
>> v1 -> v2:
>> 
>> 1. Modify the error handling in the loop.
> 
> I think that at a minimum this needs to be included in the patch description.
> Or better, in it's own patch with it's own fixes tag.
> It seems like a fundamental change to the error handling to me.

I will submit a separate patch to modify the error handling in the loop.
You can directly review the v1.
Link:https://lore.kernel.org/all/20230313090346.48778-1-jiasheng@iscas.ac.cn/

Thanks,
Jiang

