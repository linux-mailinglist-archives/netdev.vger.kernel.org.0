Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8EB4D58CF
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345794AbiCKDWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345775AbiCKDWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:22:18 -0500
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9216E1A8067;
        Thu, 10 Mar 2022 19:21:15 -0800 (PST)
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-01 (Coremail) with SMTP id qwCowAA3PvocwCpieagEAw--.41793S2;
        Fri, 11 Mar 2022 11:21:00 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     stephen@networkplumber.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH] hv_netvsc: Add check for kvmalloc_array
Date:   Fri, 11 Mar 2022 11:20:59 +0800
Message-Id: <20220311032059.2038014-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowAA3PvocwCpieagEAw--.41793S2
X-Coremail-Antispam: 1UD129KBjvdXoWrCFWfZF17Aw4rKF15ZrW5KFg_yoWxGFbEgr
        9agr1kCa98XryYva1UZr4jvr4IyFy5Zr1I9a1kX3sxZ34rA3y7Wr1kKrsY9FWxWrWFkFs7
        KFyay3yvq3Z0vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
        1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
        8cxan2IY04v7MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r4j6FyUMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUg4SrUUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 11:00:24 +0800
Stephen Hemminger <stephen@networkplumber.org> wrote:
>> +	if (!pcpu_sum) {
>> +		for (j = 0; j < i; j++)
>> +			data[j] = 0;
>> +		return
> 
> Why is unrolled zero (memset) needed? The data area comes from
> ethtool_get_stats and is already zeroed (vzalloc).
> 
> 
> There does look like at TOCTOU error here with on the number of stats.
> Code doesn't look hotplug safe.
> Not sure, but that issue might have been raised during review.

I unrolled the 'data area' since the three 'for loops' before
have already assigned the value to the data area.
And I have not found any review about it.

Thanks,
Jiang

