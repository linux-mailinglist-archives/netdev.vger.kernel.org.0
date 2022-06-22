Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B14D554BFB
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbiFVOAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiFVOAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:00:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A60DFFB;
        Wed, 22 Jun 2022 07:00:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso16918563pjk.0;
        Wed, 22 Jun 2022 07:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jMfRNowffh2x6wk/J5xqgLbxW9Lz6r0CEXzo6NLbuck=;
        b=BckNQCpYniAL4k07wuBej0VNGpVjdSqwgSx+xuoB0Zhytstlm78fAXFnTH0CUHVN0e
         ceL4faHfH2HGjGBSJRUpHUUQqwuQ3TkrNvu3+5jrvnRjnQPPGU7pyiZ6pjaucR1z8j5n
         m461vp2yhukPUdhzSWM4b6HEBzyrNYopnrKnR8DivvEgJ5AjJTS5tt0NDl+sU8vquIxv
         zpdQidZI1rM3qZF2ItrsfRGzkp405CyZatb1U+nrJQ5Jykl9VGJmwJGA4oshTTKCfL7K
         cQ+D5e0vQfwy0AUS2Sfy5UzrIxQnyqXNG+xtTmmIz5uIJKIErkKaTWTxS4QUHgdkxiuG
         W4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jMfRNowffh2x6wk/J5xqgLbxW9Lz6r0CEXzo6NLbuck=;
        b=tcHf+6EWmsKkFiYaqvz7uVZ+VWh5s3lcFttxsfQTVQXoG2ImNLVhglKx3HF1lbMaVn
         YpHNwyx7EJtQjOQSvqiWhjgE6LkJC/OAWvrDkLEvOFKAlPblkXz/kEbmFFixjyF0H8SW
         g0CN8Jyo0BDY0HKCU870C5dpNtM0uPdW0uva/vY3m0di1N7EBGzmXoY5qB8gi5Q32Jfm
         V3pJCfa/+MyhWcdFAgjbGSAQKjMua1ru0i7Rkr3bmta+XgZ+cs2Ew6jrZyBkL0txp2+y
         yu5Nc2GQyUyPC4WfpTf9joE3vYv2YT0C+bYuU1tnzTltcW8THuPPU+FNy/yvQa8vrL3O
         hn1Q==
X-Gm-Message-State: AJIora8FM4DLNl4KDA/Ge1IzXSVT7nkfpxiPWyNjucnESESGFQatsbwd
        7djDADHMgltFUVhid7+C5WpFGnBvSCJ90Q==
X-Google-Smtp-Source: AGRyM1v+ZQ5Daek8Xl+cwW+Hwo7a2xnaG+3bwwPfEO0l4/dCkVM8/n9fLsjxEwXsvEK0CvnJUZ6jeg==
X-Received: by 2002:a17:90b:1bc5:b0:1e3:3c67:37bf with SMTP id oa5-20020a17090b1bc500b001e33c6737bfmr3818941pjb.87.1655906411950;
        Wed, 22 Jun 2022 07:00:11 -0700 (PDT)
Received: from localhost ([98.97.116.244])
        by smtp.gmail.com with ESMTPSA id 135-20020a62178d000000b0050dc762817esm13615864pfx.88.2022.06.22.07.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 07:00:11 -0700 (PDT)
Date:   Wed, 22 Jun 2022 07:00:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, john.fastabend@gmail.com,
        jakub@cloudflare.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, borisp@nvidia.com, cong.wang@bytedance.com,
        bpf@vger.kernel.org
Message-ID: <62b3206a15bc4_3937b2085a@john.notmuch>
In-Reply-To: <20220620191353.1184629-2-kuba@kernel.org>
References: <20220620191353.1184629-1-kuba@kernel.org>
 <20220620191353.1184629-2-kuba@kernel.org>
Subject: RE: [PATCH net 2/2] sock: redo the psock vs ULP protection check
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

Jakub Kicinski wrote:
> Commit 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
> has moved the inet_csk_has_ulp(sk) check from sk_psock_init() to
> the new tcp_bpf_update_proto() function. I'm guessing that this
> was done to allow creating psocks for non-inet sockets.
> 
> Unfortunately the destruction path for psock includes the ULP
> unwind, so we need to fail the sk_psock_init() itself.
> Otherwise if ULP is already present we'll notice that later,
> and call tcp_update_ulp() with the sk_proto of the ULP
> itself, which will most likely result in the ULP looping
> its callbacks.
> 
> Fixes: 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: john.fastabend@gmail.com
> CC: jakub@cloudflare.com
> CC: yoshfuji@linux-ipv6.org
> CC: dsahern@kernel.org
> CC: ast@kernel.org
> CC: daniel@iogearbox.net
> CC: andrii@kernel.org
> CC: kafai@fb.com
> CC: songliubraving@fb.com
> CC: yhs@fb.com
> CC: kpsingh@kernel.org
> CC: borisp@nvidia.com
> CC: cong.wang@bytedance.com
> CC: bpf@vger.kernel.org
> ---
>  include/net/inet_sock.h | 5 +++++
>  net/core/skmsg.c        | 5 +++++
>  net/ipv4/tcp_bpf.c      | 3 ---
>  net/tls/tls_main.c      | 2 ++
>  4 files changed, 12 insertions(+), 3 deletions(-)

Thanks Jakub this looks correct to me. I can't remember at the moment
or dig up in the email or git why it was originally moved into the
update logic.  Maybe Cong can comment seeing it was his original patch?
I seemed to have missed the error path on original review :(

From my side though,

Reviewed-by: John Fastabend <john.fastabend@gmail.com>
