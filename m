Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97D16C3D71
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 23:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCUWLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 18:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCUWLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 18:11:21 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5696156515;
        Tue, 21 Mar 2023 15:11:20 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id bc12so16945991plb.0;
        Tue, 21 Mar 2023 15:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679436680;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dtHAlMTiH5m4w1buEnQY6ZSBR0PaMNWm/8JBkfYuWQ=;
        b=MmD+NiR6kn1LjfxQm9UDPepAaBwcb8HIanx8PoAV3/tvN5EknZmOI0Vc1tlfIKV4F8
         +2FaMmvlfduSpVaEHdJsBcQWvmEDRt4dCcoiiQrSQ1M6KSmCfB7DmN4nQoh7hlHLRfMm
         unDD0HCSMOO6DgqMAbBLiS3YXkXZW0eUNZbsuvPUi+iujF5mp8djSUbGYGi9+she24qb
         M5I9Yo/+HLYNEPGDvCtiUh5fhtjFDpz83HcdxZKDsVxy490/6g7q5gkOWCD88FtP4+mr
         3r/z/QMlDQb6zw4hqH0c+2JMsdOVibN8541jw5iiI0395cIqOAQ1wyZKFLa+I12pl2vD
         WNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436680;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2dtHAlMTiH5m4w1buEnQY6ZSBR0PaMNWm/8JBkfYuWQ=;
        b=Htbjb1zzY93xS1lx6vnK5EJM/2Aa9HcqXzC6rRXi9j5Myu4Qe7MVPuwQo//tmF73Mt
         fj4tuUNdtUVXcDn+EKyW34OwTKkv3CAn6Sn5SrzlORsZ6wzRWL5WJRkoJKjcfo++ZQAJ
         9xj6eInhJlPaLFrUSo9sbs5FLMrgBG4A56xi2rJ1QWb24T3Y5bZydNEJjGv9ie2eJfRi
         +D/eBcJKEUmMGv0neK0pI8oNAZ9VNOksN51xZhGKtoyol/NJWTumYbLAR0bnwclOtBhI
         +aKuvcm5zabzB0AvVP2ih6PQaLpVHLZ/nQRTbvrw35A139vzsL8Exv/7+H1TiJMWy2j6
         SHsg==
X-Gm-Message-State: AO0yUKUNizB02tNJSQeIFicvTyHefaHMsEsbUMi4XDMZ0mOYPtjkaj5o
        ZtOliYnbyZxvUurJcFjR41g=
X-Google-Smtp-Source: AK7set9pqBZ+PD97wq4EeSPck9XJbm239dNXBgOkicRZRu5aOsAWfZLUMfssTsoAConeQ7dlWAU93Q==
X-Received: by 2002:a17:90a:e7cb:b0:234:b8cb:512b with SMTP id kb11-20020a17090ae7cb00b00234b8cb512bmr1256372pjb.30.1679436679851;
        Tue, 21 Mar 2023 15:11:19 -0700 (PDT)
Received: from localhost ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902b7c300b0019fcece6847sm9219876plz.227.2023.03.21.15.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 15:11:19 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:11:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Message-ID: <641a2b86c449_80a2420866@john.notmuch>
In-Reply-To: <20230321215212.525630-11-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
 <20230321215212.525630-11-john.fastabend@gmail.com>
Subject: RE: [PATCH bpf 10/11] bpf: sockmap, test shutdown() correctly exits
 epoll and recv()=0
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> When session gracefully shutdowns epoll needs to wake up and any recv()
> readers should return 0 not the -EAGAIN they previously returned.
> 
> Note we use epoll instead of select to test the epoll wake on shutdown
> event as well.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_basic.c  | 71 ++++++++++++++++++-
>  .../bpf/progs/test_sockmap_pass_prog.c        | 32 +++++++++
>  2 files changed, 100 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index 0aa088900699..38a22c71b8dd 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -2,6 +2,7 @@
>  // Copyright (c) 2020 Cloudflare
>  #include <error.h>
>  #include <netinet/tcp.h>
> +#include <sys/epoll.h>
>  
>  #include "test_progs.h"
>  #include "test_skmsg_load_helpers.skel.h"
> @@ -9,8 +10,11 @@
>  #include "test_sockmap_invalid_update.skel.h"
>  #include "test_sockmap_skb_verdict_attach.skel.h"
>  #include "test_sockmap_progs_query.skel.h"
> +#include "test_sockmap_pass_prog.skel.h"
>  #include "bpf_iter_sockmap.skel.h"
>  
> +#include "sockmap_helpers.h"
> +
>  #define TCP_REPAIR		19	/* TCP sock is under repair right now */
>  
>  #define TCP_REPAIR_ON		1
> @@ -286,9 +290,6 @@ static void test_sockmap_skb_verdict_attach(enum bpf_attach_type first,
>  	err = bpf_prog_attach(verdict, map, second, 0);
>  	ASSERT_EQ(err, -EBUSY, "prog_attach_fail");
>  
> -	err = bpf_prog_detach2(verdict, map, first);
> -	if (!ASSERT_OK(err, "bpf_prog_detach2"))
> -		goto out;

Also shouldn't have cut these will add this back in v2.
