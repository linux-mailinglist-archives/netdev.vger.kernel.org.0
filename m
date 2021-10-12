Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668DB429D1C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 07:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhJLF3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 01:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhJLF3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 01:29:11 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D18C061570;
        Mon, 11 Oct 2021 22:27:10 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id e144so22344364iof.3;
        Mon, 11 Oct 2021 22:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=M7oS7ey6ejmlM7K3nuYivAp1SkOERckXi+zgz60GagA=;
        b=N+NTFJqUSbbZ4E8N9vg84NUtOD0UgLKUKdhXXJgTJgK0ntSm7cFoClKO3Oa+glyZ44
         iU4z7mdfVxO7w5gMJaj9q6Y6VFhzxgGHVy2BSArVGYHiVilVkThmF7Culc4CU7Q6bnug
         4jkYC8NIgboVo0LbevjR0Z5rL6MoYGyTLp/oCR+Pss4yrvvbz777EyzkWitba7/3cgHE
         SElGcKjLP0fDnsIumvPNSluJ+Lsj14F1sjiHeuKmAEHgbPn8ieVjQSajtTiIk9zJNVE+
         yR19FEqqIciFfDg/qv1sv/Tu1G0YEYZYlG6/VvQTzt11yU2O91csoPjf6Fd30MTnJBWY
         f3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=M7oS7ey6ejmlM7K3nuYivAp1SkOERckXi+zgz60GagA=;
        b=nVqBbGH1pIyD2O6pCkFKBjvxV2BiYDMgbHtxqqVCw6+ePsKYcwZnWpo4ysF6VeEArY
         mBS1VgXuPJ5OBQIu4EQay52auHglNdOyDWbu4K2amVLH5a+wXOtSsOBOwr7CIK4+HpQT
         AVoc6U+7VItJyzVAGIXHe+7xusf7W+1Ucn5CvLOpZNAqJWNMFvDe3i+QTutmQo3BNE3y
         Ck3mte7fxvwIbOsL9qnAaqclPFQWb7pg+GbjkC6bSgFYQrzYv4A7vA77QLAsNtptsh/s
         4CNHKvXUbx5qgwYiOnTbMNlbfz9Y7Ak+wsRWDuqq5A6SYkcDXtnDw5ZzQeOZCsajvWHI
         Xi3w==
X-Gm-Message-State: AOAM533UeBVkKXNxASKRuyk7DV2rU4mTerjAo31LW9hFvEs2WbvJL5uO
        wticHMgwvTE9DI5m9sFNucI=
X-Google-Smtp-Source: ABdhPJzxfydZW/gJ28q8YqUVrkTRTCdPZqNUbk2Lxw5F8+9Ct9YOmIA/nHyHkrhxf17cboR7QDP1Ng==
X-Received: by 2002:a05:6638:2405:: with SMTP id z5mr21857674jat.124.1634016429706;
        Mon, 11 Oct 2021 22:27:09 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id a4sm5087406ild.52.2021.10.11.22.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 22:27:09 -0700 (PDT)
Date:   Mon, 11 Oct 2021 22:27:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     "liujian (CE)" <liujian56@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "lmb@cloudflare.com" <lmb@cloudflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Message-ID: <61651ca5cbf46_2215c2088b@john-XPS-13-9370.notmuch>
In-Reply-To: <e60cf9bd85924ead98bb5bfd5b7e4919@huawei.com>
References: <20210929020642.206454-1-liujian56@huawei.com>
 <61563ebaf2fe0_6c4e420813@john-XPS-13-9370.notmuch>
 <e60cf9bd85924ead98bb5bfd5b7e4919@huawei.com>
Subject: RE: [PATCH v4] skmsg: lose offset info in sk_psock_skb_ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]

> > > Thanks. Please add Fixes tags so we can track these I've added it here.
> > >
> > > This has been broken from the initial patches and after a quick glance
> > > I suspect this will need manual backports if we need it. Also all the
> > > I use and all the selftests set parser to a nop by returning skb->len.
> > >
> > > Can you also create a test so we can ensure we don't break this again?
> > Okay, I will do this after the holiday.
> 
> 
> Hi John, 
> I checked selftests, there are have one test case named " test_txmsg_ingress_parser".
> But with this patch and ktls, the test failed, this because ktls parser(tls_read_size) return value is 285 not 256.
> the case like this: 
> tls_sk1 --> redir_sk --> tls_sk2
> tls_sk1 sent out 512 bytes data, after tls related processing redir_sk recved 570 btyes data,
> and redirect 512 (skb_use_parser) bytes data to tls_sk2; but tls_sk2 needs 285 * 2 bytes data, receive timeout occurred.
> I fix this as below:

Ah good catch.

> --- a/tools/testing/selftests/bpf/test_sockmap.c
> +++ b/tools/testing/selftests/bpf/test_sockmap.c
> @@ -1680,6 +1680,8 @@ static void test_txmsg_ingress_parser(int cgrp, struct sockmap_options *opt)
>  {
>         txmsg_pass = 1;
>         skb_use_parser = 512;
> +       if (ktls == 1)
> +               skb_use_parser = 570;
>         opt->iov_length = 256;
>         opt->iov_count = 1;
>         opt->rate = 2;
> 
> 
> And i add one new test as below, is it ok?


Yes looks good to me.

> 
> --- a/tools/testing/selftests/bpf/test_sockmap.c
> +++ b/tools/testing/selftests/bpf/test_sockmap.c
> @@ -139,6 +139,7 @@ struct sockmap_options {
>         bool sendpage;
>         bool data_test;
>         bool drop_expected;
> +       bool check_recved_len;
>         int iov_count;
>         int iov_length;
>         int rate;
> @@ -556,8 +557,12 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
>         int err, i, flags = MSG_NOSIGNAL;
>         bool drop = opt->drop_expected;
>         bool data = opt->data_test;
> +       int iov_alloc_length = iov_length;
>  
> -       err = msg_alloc_iov(&msg, iov_count, iov_length, data, tx);
> +       if (!tx && opt->check_recved_len)
> +               iov_alloc_length *= 2;
> +
> +       err = msg_alloc_iov(&msg, iov_count, iov_alloc_length, data, tx);
>         if (err)
>                 goto out_errno;
>         if (peek_flag) {
> @@ -665,6 +670,13 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
>  
>                         s->bytes_recvd += recv;
>  
> +                       if (opt->check_recved_len && s->bytes_recvd > total_bytes) {
> +                               errno = EMSGSIZE;
> +                               fprintf(stderr, "recv failed(), bytes_recvd:%zd, total_bytes:%f\n",
> +                                               s->bytes_recvd, total_bytes);
> +                               goto out_errno;
> +                       }
> +
>                         if (data) {
>                                 int chunk_sz = opt->sendpage ?
>                                                 iov_length * cnt :
> @@ -744,7 +756,8 @@ static int sendmsg_test(struct sockmap_options *opt)
>  
>         rxpid = fork();
>         if (rxpid == 0) {
> -               iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
> +               if (txmsg_pop || txmsg_start_pop)
> +                       iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
>                 if (opt->drop_expected || txmsg_ktls_skb_drop)
>                         _exit(0);
>  
> @@ -1688,6 +1701,19 @@ static void test_txmsg_ingress_parser(int cgrp, struct sockmap_options *opt)
>         test_exec(cgrp, opt);
>  }
>  
> +static void test_txmsg_ingress_parser2(int cgrp, struct sockmap_options *opt)
> +{
> +       if (ktls == 1)
> +               return;
> +       skb_use_parser = 10;
> +       opt->iov_length = 20;
> +       opt->iov_count = 1;
> +       opt->rate = 1;
> +       opt->check_recved_len = true;
> +       test_exec(cgrp, opt);
> +       opt->check_recved_len = false;
> +}
> +
>  char *map_names[] = {
>         "sock_map",
>         "sock_map_txmsg",
> @@ -1786,7 +1812,8 @@ struct _test test[] = {
>         {"txmsg test pull-data", test_txmsg_pull},
>         {"txmsg test pop-data", test_txmsg_pop},
>         {"txmsg test push/pop data", test_txmsg_push_pop},
> -       {"txmsg text ingress parser", test_txmsg_ingress_parser},
> +       {"txmsg test ingress parser", test_txmsg_ingress_parser},
> +       {"txmsg test ingress parser2", test_txmsg_ingress_parser2},
>  };
> 

Great, please post as a series.
