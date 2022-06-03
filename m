Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9438953D18B
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiFCSeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347315AbiFCSdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:33:44 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67912666B9;
        Fri,  3 Jun 2022 11:20:05 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a2so13881866lfc.2;
        Fri, 03 Jun 2022 11:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RlH4HZM0GOqehDVq13X1kPLT+UzzEP8AsxwqPXI0mFY=;
        b=bX//7ZiM/H5LhAkbNcM8/xvoODjgfNAHEhkyyI4yEL5mstgwWA+J3Bf0SS40+tDU+7
         N9ikUcNaLvA2IWal7UZUsg2+rOiJ0A/g8b6WCWlucj5LRv/vFTwX70YGK89jvx5B+bId
         93Sm8LkTanpXKOl90Rm+0Gz6ekRjFqlQW5A6jvYiAViz/9Lpix2m9VsgONUbbe2s5CXI
         c5y9NartHaqWvzkKHl6/UIZGKeCbQGdh7hUSEVi4PbWxYNTtX/rBYRl+1+evWnrIYI8u
         yvLwB0wj6ND5okCP1TW0YLVNANMrfIRfXC+DEqEBC6Ax159TkX6Vn0oWaeOSHkALE58d
         9/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RlH4HZM0GOqehDVq13X1kPLT+UzzEP8AsxwqPXI0mFY=;
        b=5Fi29qONkuLeMCS8J8kBssTsS5pEz6SN5u8/E7I2rXfvznackLetPtNT3f3hh/Ue/B
         ZODz7lL2Msp0ss3xtbxOO0tTkqyfbkI+ISS9s/vW3VnXEjqajeFGI1HbQ+VsZB2meXZ9
         u/3dsEKhoMhTxcLAwfVMd/Fa+GWpLIhvCJP4qxrND+TRZAyJ6c7t1LYjsqooGD2txo8p
         0piHcByL3K7xLTpUDIOFKfZdSzqQ6h8LeInLKY00Bq+P0D1+eFjRo7pFB3WgZKx3+U1L
         +AabhlmulalA0JA6Rneg6wcHG7AMdkxHFqSXoZs5RnPQ4VG2e4PvfP3xurv0OBd1K4du
         FArQ==
X-Gm-Message-State: AOAM532E90rIhJohurdZnDyzgr8aGPd3Ry7wHWt/a8o4rylnF0hpD52B
        uE1dyNE9uxtBHHdejitX7uh/b948JzV3JVAvCcG5TDbc
X-Google-Smtp-Source: ABdhPJzsvLh0e0D18yiwXAEhbgT+zhG9khAkdXCw2/0TgwFPWS7jbqZ8EdMLwCo6xJnPcMmAeOWLMX7JyrgwCrzXXWc=
X-Received: by 2002:a05:6512:b2a:b0:479:12f5:91ba with SMTP id
 w42-20020a0565120b2a00b0047912f591bamr5371166lfu.443.1654280402791; Fri, 03
 Jun 2022 11:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220603055156.2830463-1-irogers@google.com> <CAP-5=fVhVLWg+c=WJyOD8FByg_4n6V0SLSLnaw7K0J=-oNnuaA@mail.gmail.com>
 <495f2924138069abaf49269b2c3bd1e4f5f4362e.camel@perches.com>
In-Reply-To: <495f2924138069abaf49269b2c3bd1e4f5f4362e.camel@perches.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 11:19:51 -0700
Message-ID: <CAEf4Bzbwp0pgfDf-xUpWKzD2Eo=6JP0S-QrFKUZZffq49X=FQg@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Fix is_pow_of_2
To:     Joe Perches <joe@perches.com>
Cc:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Yuze Chi <chiyuze@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 9:58 AM Joe Perches <joe@perches.com> wrote:
>
> On Thu, 2022-06-02 at 22:57 -0700, Ian Rogers wrote:
> > On Thu, Jun 2, 2022 at 10:52 PM Ian Rogers <irogers@google.com> wrote:
> > > From: Yuze Chi <chiyuze@google.com>
> []
> > > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> []
> > > @@ -580,4 +580,9 @@ struct bpf_link * usdt_manager_attach_usdt(struct usdt_manager *man,
> > >                                            const char *usdt_provider, const char *usdt_name,
> > >                                            __u64 usdt_cookie);
> > >
> > > +static inline bool is_pow_of_2(size_t x)
> > > +{
> > > +       return x && (x & (x - 1)) == 0;
> > > +}
> > > +
> > >  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
>
> If speed of execution is a potential issue, maybe:

It's not, as it's not in any sort of high-frequency hot path. But even
if it was, we should be careful with __builtin_popcount() because
depending on target CPU architecture __builtin_popcount() can be
turned into a helper function call instead of using hardware
instruction. But either way, keeping it simple is prefereable.

>
> #if __has_builtin(__builtin_popcount)
>         return __builtin_popcount(x) == 1;
> #else
>         return x && (x & (x-1)) == 0;
> #endif
>
