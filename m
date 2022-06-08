Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB991543762
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243812AbiFHPay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245261AbiFHP27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:28:59 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189034A3D5
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:25:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id r82so37026955ybc.13
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xKEZM3T6Cl7AFVjSSOtW8PGdwlrdWJAcI+Dp8+iwpY=;
        b=A8iTpdRNZJZUNAQRqKil5G5nj0QS+7OlHhgwOUrfIE4xk2461qi/C0eFyPuPYLiNAW
         bPjfabEMiQ++U1/sbhj8sNjDB0mBT0cN3zIV4CJYAeSTCVEih1sJvlXtll9dR1OgCgyi
         MuynF8hpslZrRHpXYjp6QKV4s/Hk3k9HVwzJ52mAjc+VCLA7YtrRDtf4Rw614gqaqID1
         EJqwh68KFB5j+XLM9jEyFjMZdDVCH6ol4BzVRYj9soAVl/tslWjWFHh9Pf/F9eRcCBDw
         fgdjyywXvVfptd4M67SvSMZ29XHRBYeny3E/zx1Hbs3P8/Q+TP5FVoMZ1PEL8cpPHp/M
         NwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xKEZM3T6Cl7AFVjSSOtW8PGdwlrdWJAcI+Dp8+iwpY=;
        b=NPzLhGRrARxmXbDZrA/Ca9ChUR8CA9lX70oCMA/xO7H7HFc0oI96MZC+tugWpFS42J
         aIQ1V00AFPN8VCHgJtOXCKS1rdgdPTvelB+jyxVOaF7CHvSZkoYLfd663GrHwma1tDEb
         RbkNUYnYNeHIeOHQjpQrGrjYziQIckEOSsOjAFXte87GoYnYNzWWT7D6GcAUVM/Jl430
         +LXtkQIJSuFG5MQ1BAXE+4wjfQpGMpjPI7aknpWwOOhEG1xPJ5ZTjzY9NL317oYeoV1p
         2vmoJNNiaAlVTjxQGWT6Iu5OJQrHaTYIS93E+CyR9Xi2bVn+3/xLoxA0KRsSmHmlOi4H
         4FzA==
X-Gm-Message-State: AOAM531LMiT7BEx/fnlNAHpuy6B2xnU4cM0fwmHKdPWpLbzCXGvznI8r
        v5iIYgx3s/vfPXQ9d6M1JN9z3sZhqIjkjxkkI4ho2g==
X-Google-Smtp-Source: ABdhPJwDxk9ZQtigwuGnUiKGaGbAf5M49x+gXBM0yoOCIb5zfe2sfZde3v+UGTkez7Ph7u70EyM//rK3H5HYn+YkbZE=
X-Received: by 2002:a25:aa32:0:b0:65c:af6a:3502 with SMTP id
 s47-20020a25aa32000000b0065caf6a3502mr35639790ybi.598.1654701946574; Wed, 08
 Jun 2022 08:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
 <20220607171732.21191-5-eric.dumazet@gmail.com> <20220607211023.33a139b2@kernel.org>
 <b3dda032cac1feafeffa89bb71c5b574d9e88845.camel@redhat.com>
In-Reply-To: <b3dda032cac1feafeffa89bb71c5b574d9e88845.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Jun 2022 08:25:32 -0700
Message-ID: <CANn89iJ2n8D+0UbbcQVyTyNqhrtaYQBSoFM0fvo85RD2VPkTCQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] net: use DEBUG_NET_WARN_ON_ONCE() in sk_stream_kill_queues()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 1:11 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-06-07 at 21:10 -0700, Jakub Kicinski wrote:
> > On Tue,  7 Jun 2022 10:17:28 -0700 Eric Dumazet wrote:
> > > sk_stream_kill_queues() has three checks which have been
> > > useful to detect kernel bugs in the past.
> > >
> > > However they are potentially a problem because they
> > > could flood the syslog, and really only a developper
> > > can make sense of them.
> > >
> > > Keep the checks for CONFIG_DEBUG_NET=y builds,
> > > and issue them once only.
> >
> > I feel like 3 & 4 had caught plenty of bugs which triggered only
> > in production / at scale.
> >
> I have a somewhat similar experience: I hit a few races spotted by the
> warnings in patches 3 and 4 observable only in non-debug build.
>
> The checks in patch 4 are almost rendundant with the ones in patch 3 -
> at least in my experience I could not trigger the first without hitting
> the latter. Perhaps we could use WARN_ON_ONCE only in patch 3?
>

Well, I certainly can stick to WARN_ON_ONCE().

For syzbot it is really the same thing.
