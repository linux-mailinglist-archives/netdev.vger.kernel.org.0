Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DC73D7B32
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhG0Qis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhG0Qir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:38:47 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1572BC061757;
        Tue, 27 Jul 2021 09:38:46 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y9so16745133iox.2;
        Tue, 27 Jul 2021 09:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=E4iT6quIbPFGiyn2ncXsgUZJtBiPEHD08D8THSVjCCY=;
        b=QnErqvUbb7AQ5PCUHTL2jU3Yc23Gd9qlvV6cCrG7uxP2pzN1lrqGqqMOQ6s/9gmGQq
         gc+ENvMYssIAOhpGYc0NYDRzbQGmjZhSFt7JUET/KqD3BtVwpTK1MSO3al3X68SPvhUH
         dkIOhfCNl+9J0DRdbPvNv9KEQmc0hWfVMDk/7Cf05z24VWCHc1TlikykBVTQuWrzqB4K
         leliSD8gX7IaWvzcSSYW5SewfIE5/jd+UA5n/QjdXOkP7553MMZvLfqk8CHVR2XhiTdy
         L7lSVfV5fpD0SNT44cut/hewih0dmCsAjVboy1VKSKWx3UvBR0H05f4aOA0aQQjHdWWt
         tHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=E4iT6quIbPFGiyn2ncXsgUZJtBiPEHD08D8THSVjCCY=;
        b=mZEtglJQVmYliSwWLgbkj7rwBJvMk+vI5EPzh2uAHueiQzqdEs5yQXfbIG+xHqjwL9
         GXMaTHOxr9aUITB4qFvoqDLTxd8Mfo3LFFbsirMTsZvKWUfeZDlHDbvsYqhEhJFclMZj
         TmffPdljev+CH1tDugJIPKEDkETK+RY7gcckYxsrhUwe+v83fYPgdtIaJLL9Yc9S1Wjt
         bFC2ZvwFOsnk0AibGaiCUirP5SsN35CpzOwZW0vgQgJNby+jikBT9xojLSujl81jRltf
         QPdXW5fIvbhNhoXI/YU9KQwLDnW9wKPZLBqq7jO8w3P7J3oFq9jPdm9kthjhgrD11ATI
         tbEw==
X-Gm-Message-State: AOAM531wmOrnsJXL1MkDDJmujAaBhYNAF0FMXN+s2KUIRErzY6qsD9fz
        k/ixSMGOAmKWfDeFM2e/w60=
X-Google-Smtp-Source: ABdhPJwfjEkID8gptinvAz/jKdO9oQqS6ZJeOX0Nr4jNkI/8MZDuNcAwIcNvxtAspsX1ePYolBvInw==
X-Received: by 2002:a05:6638:35aa:: with SMTP id v42mr16972541jal.21.1627403925615;
        Tue, 27 Jul 2021 09:38:45 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id j20sm2433032ile.17.2021.07.27.09.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:38:45 -0700 (PDT)
Date:   Tue, 27 Jul 2021 09:38:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Message-ID: <6100368f625b_199a41208ab@john-XPS-13-9370.notmuch>
In-Reply-To: <20210727001252.1287673-4-jiang.wang@bytedance.com>
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
 <20210727001252.1287673-4-jiang.wang@bytedance.com>
Subject: RE: [PATCH bpf-next v1 3/5] selftest/bpf: add tests for sockmap with
 unix stream type.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiang Wang wrote:
> Add two tests for unix stream to unix stream redirection
> in sockmap tests.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>.
> ---
>  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> index a9f1bf9d5..7a976d432 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> @@ -2020,11 +2020,13 @@ void test_sockmap_listen(void)
>  	run_tests(skel, skel->maps.sock_map, AF_INET);
>  	run_tests(skel, skel->maps.sock_map, AF_INET6);
>  	test_unix_redir(skel, skel->maps.sock_map, SOCK_DGRAM);
> +	test_unix_redir(skel, skel->maps.sock_map, SOCK_STREAM);
>  
>  	skel->bss->test_sockmap = false;
>  	run_tests(skel, skel->maps.sock_hash, AF_INET);
>  	run_tests(skel, skel->maps.sock_hash, AF_INET6);
>  	test_unix_redir(skel, skel->maps.sock_hash, SOCK_DGRAM);
> +	test_unix_redir(skel, skel->maps.sock_hash, SOCK_STREAM);
>  
>  	test_sockmap_listen__destroy(skel);
>  }
> -- 
> 2.20.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
