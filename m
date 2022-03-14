Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0974D7932
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 02:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiCNB5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 21:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiCNB52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 21:57:28 -0400
Received: from cstnet.cn (smtp23.cstnet.cn [159.226.251.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 174C93EF1C;
        Sun, 13 Mar 2022 18:56:18 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-03 (Coremail) with SMTP id rQCowAA3P8O0oC5iprG+Ag--.41815S2;
        Mon, 14 Mar 2022 09:56:04 +0800 (CST)
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
Date:   Mon, 14 Mar 2022 09:56:03 +0800
Message-Id: <20220314015603.2364882-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowAA3P8O0oC5iprG+Ag--.41815S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKFW3Ar1ftF1rWF15uFWruFg_yoWxArg_WF
        1qvFnxCrZ5JF4ftF45Z343Xryftwn8tF1kJF90q3ykAw1YkrW5tFy8Wr95XFW7WrZakr9x
        KF17C3ySv3Z0qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3kFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
        628vn2kIc2xKxwCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1U
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUmQ6LUUUUU=
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Mar 2022 01:25:38 +0800
Stephen Hemminger <stephen@networkplumber.org> wrote:

>> +	if (!pcpu_sum) {
>> +		for (j = 0; j < i; j++)
>> +			data[j] = 0;
>> +		return;
>> +	}
> 
> I don't think you understood what my comment was.
> 
> The zeroing here is not necessary. Just do:
>         if (!pcpu_sum)
>                return;
> 
> The data pointer is to buffer allocated here:
> 
> static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
> {
> ...
> 	if (n_stats) {
> 		data = vzalloc(array_size(n_stats, sizeof(u64)));  <<<<< is already zeroed.
> 		if (!data)
> 			return -ENOMEM;
> 		ops->get_ethtool_stats(dev, &stats, data);

OK, I will submit a v2 to remove them.

Jiang

