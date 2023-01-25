Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C2967A9FB
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 06:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjAYF21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 00:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAYF20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 00:28:26 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEF83A86;
        Tue, 24 Jan 2023 21:28:25 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso916850pjp.3;
        Tue, 24 Jan 2023 21:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9dTsBzB881E1M2fTbfgy/sXd8SVlUbmiX5kQp9uEBTg=;
        b=KHyOUCG4VPg/INz1nUHlpx47dBWeDgjiKYkJLp1LyPX+78Wt5AKcO2b2ZnuD4JzuDy
         lyQF28ihVCgm5207FlaPSljCaIUTYBojPqiFwDxin0AF6ZKsRW+h7Wc8vCEncwlZnUXs
         7x9gr6HhnzjmmYXhoixTg/v3ktQpY9Fwvz3xiucVEsB6tMSdls7q0XZFRUv2G7L0H5Jk
         yWSpIu8TLBXgr6ZLtlUfU7YmiG0M97Ej4vZO7SBAqL4mq4fdb3hc7qw9fs0LwNW2i7bX
         Ufg/NJEcWoxEXkGwL4sz9VCTK0ypGXSokhyxiczSQt2U9KMtCiau1PGgYecNIzczGPY1
         kKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9dTsBzB881E1M2fTbfgy/sXd8SVlUbmiX5kQp9uEBTg=;
        b=DYvko1xvXgfWgr/H5gEij2lvWRgKOlQwwI3mer6nXup38e4cEd4hJPJCGfEAs2dldo
         NJWieWlScmepZ89geF1Fek2jznvNjL7t3orVdijzAaFiXiCr386Ge/iG0KcBNUcjvZGO
         2zD+FJJSPwOs+ByJfwJ9BoAiEp77bWwP5Ohg41s/xwOVjaanVRHuEkZV/rlDlCEW1ozq
         GDpbFNOJEwM5xIfMSvkgzeZYV0zrqpuVsGhj0CMQ+MoQPZWb0otXkdXH2EAvl7PkKGiI
         Q1Oc3hoXD+a25+mI0b/gEQHjfeQvDnc3YHUk7jlc1IPBKY3a/kFSkQtInJGdJXqOa5zd
         l/qw==
X-Gm-Message-State: AFqh2kr09aZ7soMkxryp67mtcCSetcdEBEkcr5hml4cGBZ3Hpb4RFFLF
        Krs6Wr3NfNXgt2fpbWWx16U=
X-Google-Smtp-Source: AMrXdXtvHhsDkpV+5aXlJ9Sax5RSsMSfbtEeybIbYpaQARRLr7+D7miab63UOJWjev9R0maOaHCXPA==
X-Received: by 2002:a17:902:8498:b0:194:4724:806d with SMTP id c24-20020a170902849800b001944724806dmr29207957plo.33.1674624504975;
        Tue, 24 Jan 2023 21:28:24 -0800 (PST)
Received: from localhost ([98.97.33.45])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c20600b00186acb14c4asm2618710pll.67.2023.01.24.21.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 21:28:24 -0800 (PST)
Date:   Tue, 24 Jan 2023 21:28:22 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Message-ID: <63d0bdf6f395f_641f20827@john.notmuch>
In-Reply-To: <20230113-sockmap-fix-v2-4-1e0ee7ac2f90@cloudflare.com>
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
 <20230113-sockmap-fix-v2-4-1e0ee7ac2f90@cloudflare.com>
Subject: RE: [PATCH bpf v2 4/4] selftests/bpf: Cover listener cloning with
 progs attached to sockmap
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

Jakub Sitnicki wrote:
> Today we test if a child socket is cloned properly from a listening socket
> inside a sockmap only when there are no BPF programs attached to the map.
> 
> A bug has been reported [1] for the case when sockmap has a verdict program
> attached. So cover this case as well to prevent regressions.
> 
> [1]: https://lore.kernel.org/r/00000000000073b14905ef2e7401@google.com
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
