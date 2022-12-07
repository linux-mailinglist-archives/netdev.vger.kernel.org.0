Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3DD645435
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 07:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLGGpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 01:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiLGGpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 01:45:40 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CE2DF47;
        Tue,  6 Dec 2022 22:45:38 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m4so9248426pls.4;
        Tue, 06 Dec 2022 22:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6kzi63xN7XK3kRS3b2uv68JVSdEfB3M9mpMlNN2OUE=;
        b=KM70K8qN+0Y+fGdrFKLgoEtquxvOr7m1sYc613ZrroNtDHEOd0uM7ywK9ya2uJ9FeZ
         kn/YaKxQKP1r3IOtV3ZTdSs56HVZC8lM98EGzTSvPlY2qHTgKBp/kN+ZA/VAuShsYPIh
         uEoTatJXnCz/BnPkaKR5q2fnvTGYzPjEWy2ypYOImukQl+yUkaFpINToZ9T+K5iLrUCe
         yLXafJ8dlYDSYxuZH7kqiYkcC1HwQbr/S7/TXbf9F6KeGOk9w3rTpID+VQBoEZ/AZoTj
         7B49wg7V8MTnRTLQA8Jo5sHtLmk2EDK0HxflkpmlhOetbG5JRE9df620naCjR+DXBdZt
         +e1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=a6kzi63xN7XK3kRS3b2uv68JVSdEfB3M9mpMlNN2OUE=;
        b=33QSe0aD5ztt2wE6fO18d5u3StkRyrYuCrKelEiR3wRg6rHubvxYhjOlx2iIjGxWWP
         FwWS6UFwKQaQUbfD2xQvoRhKJnLzFmNjflQjQzU7bELv/tT7NFl+LErN/B4xo7xkCqre
         x3PLy+DNwkldv6flHa3/2xZ3gTaRXHuMLWqtTEiQUlErunqYUoVex3i2kGSMie7F6i1e
         Ks3Jib/z/ZC77fFLRy57UZb0PvfVhUo1DhYyHiaudIHeoLXsbMrcG6rvrAJHiOPY6hjr
         jc8ETFKQzARwVYGvs3GljD3HcCHbZ7emPz8rokB7rJkeGuLSAbgBrKSJ3+7iMjlIR2pE
         D9Tw==
X-Gm-Message-State: ANoB5pnfV9LkJZPc3cTgcz14PNMHr+yUmWykEdilWDqRKyuQTTkxVsMT
        ZWWHKKXWHb2XhKKlcb2WD60=
X-Google-Smtp-Source: AA0mqf6JAOI251vjixBUuDfbKOOQToq6OsCQficqdUh1y2V+q62CR6qVvaPpl399g/EbZfeST/bl+g==
X-Received: by 2002:a17:903:2c2:b0:182:631a:ef28 with SMTP id s2-20020a17090302c200b00182631aef28mr71538279plk.46.1670395520007;
        Tue, 06 Dec 2022 22:45:20 -0800 (PST)
Received: from localhost ([98.97.38.190])
        by smtp.gmail.com with ESMTPSA id z15-20020a655a4f000000b0046faefad8a1sm10857722pgs.79.2022.12.06.22.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 22:45:19 -0800 (PST)
Date:   Tue, 06 Dec 2022 22:45:18 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     shaozhengchao <shaozhengchao@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, syzkaller-bugs@googlegroups.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Message-ID: <6390367e16292_bb362082e@john.notmuch>
In-Reply-To: <cb69ed14-6d14-f5c9-21c5-0b725256a5bf@huawei.com>
References: <20221129042644.231816-1-shaozhengchao@huawei.com>
 <638f9efdab7bb_8a9120824@john.notmuch>
 <cb69ed14-6d14-f5c9-21c5-0b725256a5bf@huawei.com>
Subject: Re: [PATCH bpf-next] bpf, test_run: fix alignment problem in
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

shaozhengchao wrote:
> 
> 
> On 2022/12/7 3:58, John Fastabend wrote:
> > Zhengchao Shao wrote:
> >> The problem reported by syz is as follows:
> >> BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x230/0x330
> >> Write of size 32 at addr ffff88807ec6b2c0 by task bpf_repo/6711
> >> Call Trace:
> >> <TASK>
> >> dump_stack_lvl+0x8e/0xd1
> >> print_report+0x155/0x454
> >> kasan_report+0xba/0x1f0
> >> kasan_check_range+0x35/0x1b0
> >> memset+0x20/0x40
> >> __build_skb_around+0x230/0x330
> >> build_skb+0x4c/0x260
> >> bpf_prog_test_run_skb+0x2fc/0x1ce0
> >> __sys_bpf+0x1798/0x4b60
> >> __x64_sys_bpf+0x75/0xb0
> >> do_syscall_64+0x35/0x80
> >> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >> </TASK>
> >>
> >> Allocated by task 6711:
> >> kasan_save_stack+0x1e/0x40
> >> kasan_set_track+0x21/0x30
> >> __kasan_kmalloc+0xa1/0xb0
> >> __kmalloc+0x4e/0xb0
> >> bpf_test_init.isra.0+0x77/0x100
> >> bpf_prog_test_run_skb+0x219/0x1ce0
> >> __sys_bpf+0x1798/0x4b60
> >> __x64_sys_bpf+0x75/0xb0
> >> do_syscall_64+0x35/0x80
> >> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >>
> >> The process is as follows:
> >> bpf_prog_test_run_skb()
> >> 	bpf_test_init()
> >> 		data = kzalloc()	//The length of input is 576.
> >> 					//The actual allocated memory
> >> 					//size is 1024.
> >> 	build_skb()
> >> 		__build_skb_around()
> >> 			size = ksize(data)//size = 1024
> >> 			size -= SKB_DATA_ALIGN(
> >> 					sizeof(struct skb_shared_info));
> >> 					//size = 704
> >> 			skb_set_end_offset(skb, size);
> >> 			shinfo = skb_shinfo(skb);//shinfo = data + 704
> >> 			memset(shinfo...)	//Write out of bounds
> >>
> >> In bpf_test_init(), the accessible space allocated to data is 576 bytes,
> >> and the memory allocated to data is 1024 bytes. In __build_skb_around(),
> >> shinfo indicates the offset of 704 bytes of data, which triggers the issue
> >> of writing out of bounds.
> >>
> >> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
> >> Reported-by: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
> >> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> >> ---
> >>   net/bpf/test_run.c | 10 ++++++++++
> >>   1 file changed, 10 insertions(+)
> >>
> >> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> >> index fcb3e6c5e03c..fbd5337b8f68 100644
> >> --- a/net/bpf/test_run.c
> >> +++ b/net/bpf/test_run.c
> >> @@ -766,6 +766,8 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
> >>   			   u32 size, u32 headroom, u32 tailroom)
> >>   {
> >>   	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
> >> +	unsigned int true_size;
> >> +	void *true_data;
> >>   	void *data;
> >>   
> >>   	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
> >> @@ -779,6 +781,14 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
> >>   	if (!data)
> >>   		return ERR_PTR(-ENOMEM);
> >>   
> >> +	true_size = ksize(data);
> >> +	if (size + headroom + tailroom < true_size) {
> >> +		true_data = krealloc(data, true_size, GFP_USER | __GFP_ZERO);
> > 
> > This comes from a kzalloc, should we zero realloc'd memory as well?
> > 
> >> +			if (!true_data)
> >> +				return ERR_PTR(-ENOMEM);
> > 
> > I think its worth fixing the extra tab here.
> > 
> 
> Hi John:
> 	Thank you for your review. Your suggestion looks good to me. And I 
> found Kees Cook also focus on this issue.
> https://patchwork.kernel.org/project/netdevbpf/patch/20221206231659.never.929-kees@kernel.org/
> Perhaps his solution will be more common?

Maybe, seems ksize should not be used either.
