Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E80E6451EE
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLGCUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiLGCU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:20:26 -0500
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B7DD4E432;
        Tue,  6 Dec 2022 18:20:24 -0800 (PST)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-05 (Coremail) with SMTP id zQCowADX+M1S+I9j2FxvBQ--.64308S2;
        Wed, 07 Dec 2022 10:20:03 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     jiri@resnulli.us
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH net] ice: Add check for kzalloc
Date:   Wed,  7 Dec 2022 10:20:00 +0800
Message-Id: <20221207022000.44043-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowADX+M1S+I9j2FxvBQ--.64308S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF13tr17Jw1UKFy8Gr1DAwb_yoWDurcEkF
        yDZrn7X3W7Jr1xZ3WayrnrWFn3urW8ZFyIga4Yqr4ay34DJrZIyFnFqry3A3yIgF409Fnx
        JryDAa4Y9rnxujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
        8cxan2IY04v7MxkIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUDDGOUUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:47:01PM +0800, Jiri Pirko wrote:
>>As kzalloc may fail and return NULL pointer,
>>it should be better to check the return value
>>in order to avoid the NULL pointer dereference.
> 
> Okay, so? Be imperative to the code base, tell it what to do in your
> patch description.

OK, I will describe the changes by the patch in more details.

>>@@ -462,6 +462,17 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
>> 					       GFP_KERNEL);
>> 		pf->gnss_serial[i] = NULL;
>> 
>>+		if (!pf->gnss_tty_port[i]) {
>>+			for (j = 0; j < i; j++) {
>>+				tty_port_destroy(pf->gnss_tty_port[j]);
> 
> You are destroying port which you didn't call (pf->gnss_tty_port[i])
> for. Also, you are introducing a code duplication here with the error
> path couple of lines below. Please convert this to goto-label error
> path so the cleanup code is shared.

I will convert this to goto-label in v2.
But I have a question that the j is from 0 to (i - 1), and therefore only
the initialized port will be destroyed.
Is there any wrong?

Thanks,
Jiang

