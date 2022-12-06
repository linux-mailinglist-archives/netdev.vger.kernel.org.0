Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CDC644CB9
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiLFT66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLFT65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:58:57 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5833A36C77;
        Tue,  6 Dec 2022 11:58:56 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 62so14315112pgb.13;
        Tue, 06 Dec 2022 11:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uuc7EOQNm3m0fM0NZaP/ssBis1lnqAeLq79CsrgKNvM=;
        b=TivfglRv0lhb4gUWkknmc+xmdpIc02HU8XZV6d9madJDomc9t0zxInhbgh369R8bw6
         olF/8SrhJ8Gp26gdc7OXtnzHF717ILKYzlSS6jcuqGcXSYI/UY5TP0l5ICRJzSJD9Wk5
         nXyem2cbr3fSGINxSkl4CESrhG6jUI96/NnkQ5Sq1JlcmbSodpFySe6lRuKe5PlOrllG
         ZDXDyGSwUjD0o8DRPr8hClQg4vyYomrEACzJNZCobumi7cXEsp5K+OHSPj4P0fRFHhCy
         VJGTVtHkD9JzHLAoW1rDEJK2t30BhtpB0Ms1eWoxIyL4sUJ3/oxwNOJoJyqhR/xQHgD3
         P6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uuc7EOQNm3m0fM0NZaP/ssBis1lnqAeLq79CsrgKNvM=;
        b=nxwXRjBLyNgDG+8HY8A/h6ZtsnBCvRIWiMeAEFlqm6AB5aEN0enD6nsJ+sdLlwYkhW
         2TvWKcUgiF6yxBUO6z6QQWM4pe3bsYB1Vu2T/VlsCtwAyRAN/qUpWeIGq7gqJpkzmFjx
         A4dafQ6j5Bs2S+iawKJOYV/egVYOmSUK5TMIpHBHynLzJtmn3oMrA2+DbHetzkipnZwA
         vTzZ+Hf9LIK31fvTMRNVwOHSs0FsREq758AJFiYBBpXJ1QVf8vK4ocmpZOh3rQnkwJad
         vz3JxC711eTL/nrTYr3c+08SBEqNWNvZ9zXLV0o5AP10tcLEHQortMjWbeMQEAUxxeMC
         XQJg==
X-Gm-Message-State: ANoB5pl75WazmIVJTZE2rq+sj8KRwOEUPzLO5+0FmII7JCrzDO93J9EP
        XNdteWisJ3RnKVjMlSuB8ik=
X-Google-Smtp-Source: AA0mqf7EJSsqc13oIo5o62SD71z5c1unzW3J+MB+co/LKrFE/43Pb3BOMH2PyPFusrhdfRLpYdFwjA==
X-Received: by 2002:aa7:8207:0:b0:576:7440:2478 with SMTP id k7-20020aa78207000000b0057674402478mr20213575pfi.51.1670356735763;
        Tue, 06 Dec 2022 11:58:55 -0800 (PST)
Received: from localhost ([129.95.247.247])
        by smtp.gmail.com with ESMTPSA id y69-20020a62ce48000000b00571bdf45888sm8551394pfg.154.2022.12.06.11.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 11:58:55 -0800 (PST)
Date:   Tue, 06 Dec 2022 11:58:53 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        syzkaller-bugs@googlegroups.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, shaozhengchao@huawei.com
Message-ID: <638f9efdab7bb_8a9120824@john.notmuch>
In-Reply-To: <20221129042644.231816-1-shaozhengchao@huawei.com>
References: <20221129042644.231816-1-shaozhengchao@huawei.com>
Subject: RE: [PATCH bpf-next] bpf, test_run: fix alignment problem in
 bpf_test_init()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao wrote:
> The problem reported by syz is as follows:
> BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x230/0x330
> Write of size 32 at addr ffff88807ec6b2c0 by task bpf_repo/6711
> Call Trace:
> <TASK>
> dump_stack_lvl+0x8e/0xd1
> print_report+0x155/0x454
> kasan_report+0xba/0x1f0
> kasan_check_range+0x35/0x1b0
> memset+0x20/0x40
> __build_skb_around+0x230/0x330
> build_skb+0x4c/0x260
> bpf_prog_test_run_skb+0x2fc/0x1ce0
> __sys_bpf+0x1798/0x4b60
> __x64_sys_bpf+0x75/0xb0
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> </TASK>
> 
> Allocated by task 6711:
> kasan_save_stack+0x1e/0x40
> kasan_set_track+0x21/0x30
> __kasan_kmalloc+0xa1/0xb0
> __kmalloc+0x4e/0xb0
> bpf_test_init.isra.0+0x77/0x100
> bpf_prog_test_run_skb+0x219/0x1ce0
> __sys_bpf+0x1798/0x4b60
> __x64_sys_bpf+0x75/0xb0
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> The process is as follows:
> bpf_prog_test_run_skb()
> 	bpf_test_init()
> 		data = kzalloc()	//The length of input is 576.
> 					//The actual allocated memory
> 					//size is 1024.
> 	build_skb()
> 		__build_skb_around()
> 			size = ksize(data)//size = 1024
> 			size -= SKB_DATA_ALIGN(
> 					sizeof(struct skb_shared_info));
> 					//size = 704
> 			skb_set_end_offset(skb, size);
> 			shinfo = skb_shinfo(skb);//shinfo = data + 704
> 			memset(shinfo...)	//Write out of bounds
> 
> In bpf_test_init(), the accessible space allocated to data is 576 bytes,
> and the memory allocated to data is 1024 bytes. In __build_skb_around(),
> shinfo indicates the offset of 704 bytes of data, which triggers the issue
> of writing out of bounds.
> 
> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
> Reported-by: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/bpf/test_run.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index fcb3e6c5e03c..fbd5337b8f68 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -766,6 +766,8 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
>  			   u32 size, u32 headroom, u32 tailroom)
>  {
>  	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
> +	unsigned int true_size;
> +	void *true_data;
>  	void *data;
>  
>  	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
> @@ -779,6 +781,14 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
>  	if (!data)
>  		return ERR_PTR(-ENOMEM);
>  
> +	true_size = ksize(data);
> +	if (size + headroom + tailroom < true_size) {
> +		true_data = krealloc(data, true_size, GFP_USER | __GFP_ZERO);

This comes from a kzalloc, should we zero realloc'd memory as well?

> +			if (!true_data)
> +				return ERR_PTR(-ENOMEM);

I think its worth fixing the extra tab here.

> +		data = true_data;
> +	}
> +
>  	if (copy_from_user(data + headroom, data_in, user_size)) {
>  		kfree(data);
>  		return ERR_PTR(-EFAULT);
> -- 
> 2.17.1
> 
