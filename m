Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6346C0933
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 04:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjCTDJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 23:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCTDJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 23:09:04 -0400
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AE03EC5D;
        Sun, 19 Mar 2023 20:09:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-05 (Coremail) with SMTP id zQCowADn7c0_zhdkk6pwBg--.2300S2;
        Mon, 20 Mar 2023 11:08:47 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     simon.horman@corigine.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: Re: [PATCH v2] Bluetooth: 6LoWPAN: Add missing check for skb_clone
Date:   Mon, 20 Mar 2023 11:08:46 +0800
Message-Id: <20230320030846.18481-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowADn7c0_zhdkk6pwBg--.2300S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZFyfCr4UWr47Ww4UJr4DCFg_yoWDCrX_Wr
        n5A3s7C3y0kF4xu3ZxJrW7tFs5Kr9rGF1Fgwn0qws8A3s5AFWkKrWktrWftr1fGay0qFnI
        9FWIyFWkXry29jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUn2-eDUUUU
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 10:54:40AM +0800, Jiasheng Jiang wrote:
> On Sat, Mar 18, 2023 at 05:03:21AM +0800, Simon Horman wrote:
>> On Wed, Mar 15, 2023 at 03:06:21PM +0800, Jiasheng Jiang wrote:
>>> Add the check for the return value of skb_clone since it may return NULL
>>> pointer and cause NULL pointer dereference in send_pkt.
>>> 
>>> Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
>>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>>> ---
>>> Changelog:
>>> 
>>> v1 -> v2:
>>> 
>>> 1. Modify the error handling in the loop.
>> 
>> I think that at a minimum this needs to be included in the patch description.
>> Or better, in it's own patch with it's own fixes tag.
>> It seems like a fundamental change to the error handling to me.
> 
> I will submit a separate patch to modify the error handling in the loop.
> You can directly review the v1.
> Link:https://lore.kernel.org/all/20230313090346.48778-1-jiasheng@iscas.ac.cn/

I think it would be better to send a patch series.

Thanks,
Jiang

