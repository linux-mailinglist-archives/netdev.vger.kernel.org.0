Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3E351E05E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443907AbiEFU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346231AbiEFU4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:56:13 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7926D868;
        Fri,  6 May 2022 13:52:29 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d3so5537340ilr.10;
        Fri, 06 May 2022 13:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9xPGIlmt+FCGNXEvj1MOSv96z0C4C+W3xdxDnwzXgQk=;
        b=qd/RTGT4cvHjjNKKdU66WSlVV7H62ZBoSTXe8fsJd8Naqd+UjqYP0eyksu6UbAR3dH
         4vEoAmScldQv4EEts+780Eo/jhcy2WjAa9ZXIEH7TS3KkHAok4ss21kluk5AfPNeIfOH
         Wnl36b8JUOpGTSM9EAlL2ok3mH2DdVdJZhg3Y0odCDE4nSSKY/MuA++j19lDo4eFJkwO
         wYgXqJcpjONjJ0F4ASLDab7Yxb1k/O0pKZ0NtSHKYbAtXvtd2fho+S8SQn5zXtQEH5fR
         SUJmA64PQzelMWmflFPKn2pQ3G5C1w4g9eSXhvbBC9HVD4n/qmO1rhTyXUnJgRyIbURg
         XU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9xPGIlmt+FCGNXEvj1MOSv96z0C4C+W3xdxDnwzXgQk=;
        b=dNvvjmfNgcrNl8q5GDHxSego/P2RIEw1jZFsqjw+CtxAfnYx6xgJSNqxB15AwNaqtW
         DNUWPCCPfX0/kPlF4kVfSwjcRCyZaVjXP7gO6D82JyYZjq611D5PdxZhV9i95STTrKj7
         RRiFLv8Oxyqzv4aOggPYacddyz1I57K3vEv0R0pwVUd7rtN//idnGExTU8WDrE5/noLL
         AaqrG10wcEyxvO3dYVXkxzcR3hU3SkQmKJAcnsY/vrUkhDE9kSW5rYid8qo8PaYWiXM8
         l2jM8d2giwCRW/iH1MquwEsOvNQh33gt3h7ictgARsUs6qyJ8Jp1qCgz6saT60i2cbys
         zAzg==
X-Gm-Message-State: AOAM533Rkxe27C4ChqZRET930/Ha0n/o7hyrB84eet2zWPAuU+BIETjA
        J4nWwT01V98DM8bZ3r6zhyEcXY8anQrJnw==
X-Google-Smtp-Source: ABdhPJxUDZbbJgYJBeV6AACgxuY7K30lobb69PEkOZ6zGK4shihN0gM71h+yUJD5dNpVB+Fzgbk40w==
X-Received: by 2002:a05:6e02:20e1:b0:2cf:63de:22f7 with SMTP id q1-20020a056e0220e100b002cf63de22f7mr1927645ilv.24.1651870349197;
        Fri, 06 May 2022 13:52:29 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id z15-20020a6b5c0f000000b0065a47e16f53sm1580551ioh.37.2022.05.06.13.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:52:28 -0700 (PDT)
Date:   Fri, 06 May 2022 13:52:19 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pu Lehui <pulehui@huawei.com>, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Lehui <pulehui@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Message-ID: <62758a83b512a_18fd5208b5@john.notmuch>
In-Reply-To: <20220429014240.3434866-2-pulehui@huawei.com>
References: <20220429014240.3434866-1-pulehui@huawei.com>
 <20220429014240.3434866-2-pulehui@huawei.com>
Subject: RE: [PATCH bpf-next v2 1/2] bpf: Unify data extension operation of
 jited_ksyms and jited_linfo
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pu Lehui wrote:
> We found that 32-bit environment can not print bpf line info due
> to data inconsistency between jited_ksyms[0] and jited_linfo[0].
> 
> For example:
> jited_kyms[0] = 0xb800067c, jited_linfo[0] = 0xffffffffb800067c
> 
> We know that both of them store bpf func address, but due to the
> different data extension operations when extended to u64, they may
> not be the same. We need to unify the data extension operations of
> them.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>  kernel/bpf/syscall.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index e9e3e49c0eb7..18137ea5190d 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3871,13 +3871,16 @@ static int bpf_prog_get_info_by_fd(struct file *file,
>  		info.nr_jited_line_info = 0;
>  	if (info.nr_jited_line_info && ulen) {
>  		if (bpf_dump_raw_ok(file->f_cred)) {
> +			unsigned long jited_linfo_addr;
>  			__u64 __user *user_linfo;
>  			u32 i;
>  
>  			user_linfo = u64_to_user_ptr(info.jited_line_info);
>  			ulen = min_t(u32, info.nr_jited_line_info, ulen);
>  			for (i = 0; i < ulen; i++) {
> -				if (put_user((__u64)(long)prog->aux->jited_linfo[i],
> +				jited_linfo_addr = (unsigned long)
> +					prog->aux->jited_linfo[i];
> +				if (put_user((__u64) jited_linfo_addr,
>  					     &user_linfo[i]))

the logic is fine but i'm going to nitpick a bit this 4 lines is ugly
just make it slightly longer than 80chars or use a shoarter name? For
example,

			for (i = 0; i < ulen; i++) {
				unsigned long l;

				l = (unsigned long) prog->aux->jited_linfo[i];
				if (put_user((__u64) l, &user_linfo[i]))

is much nicer -- no reason to smash single assignment across multiple
lines. My $.02.

Thanks,
John
