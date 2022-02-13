Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBE44B3D20
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiBMT3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:29:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBMT3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:29:38 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A4C56C11
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 11:29:32 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id y129so40201722ybe.7
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 11:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/FYPRIHSVVAqvWLMwZyuPAS2V3IB8OFYjvi3nCWsq+Y=;
        b=Qs8m3NQSpqdgHIzKp6jbtVCFWFlFvfB4BXMCmgM+0s//4ZX4ithiRzoY4u+tiRlBKi
         P2XQQH7JqpD5b74/4ArCcOg0TNdVXiQdaXJyxamTq6rA5GvvUhE1e1xlHmLveLzlW79+
         YSfUi6JGcNfmmGHEmBwDBAiIBtuwfUuQQT3WFjPKZ9HbY3fLxyu6nkRBImBBiEhb03y1
         6GAjKDnPMTL0Rriva+mCVS9Yt2w52Iz8jqAh7cVs+Wo5MPuFKc0xiPiB5Dkb79Dvu4tk
         eS2knGtfvzi4j77JmjC/4z3p250sYg/dO019QnGtytuvOc3sVHNeAUfUjY0s7rNE5lij
         y9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/FYPRIHSVVAqvWLMwZyuPAS2V3IB8OFYjvi3nCWsq+Y=;
        b=3t3s4W9Ubs/rN5BDDNLHAFOEiCgQwO2ErBTUNFvYBBidZuos+I0L0JOkkgFkbUKRBu
         GzTr5VxmNUHmN+Ih7Ro62c71GFLk4BwgynkWsjYPKOJoKN/vVC5mDePeXJe5VJ2nCTEw
         ISInNf+/ZeWBmqY7hjYLDqr7LTLX4QHgEWTPxXDHi6bFSSDsUieQmX+SCjdYRD8GDJZn
         fC2RWrbSEfMb1KJxk+ASi/47/HsXgbxI6plfUSUC+u1RxDvlUsAQISRn1Ofa3Q9vjxbV
         2S5j1YY4sG9Pxr0VBi5llEt5PzLeI0v0y206iNWFyKhzyG0zdHY5FAhGCuz5tlz3IFmz
         R8rQ==
X-Gm-Message-State: AOAM530pEcZXYUXmXy43VWtK3jr5sGICzNUPHxTvqEUC9HPrjeY/g/FT
        yOvqx4S+Y5JwsyLYSJHWCJI1qsJay5JMOMQN+yfrjA==
X-Google-Smtp-Source: ABdhPJzsmKVldQVRodRrPSIHwFdqrhhWTTt6yY2T7adhw7lG8nkf2joQQAxOE54l/OfAYDgDqbfN9cZDQhjTdvthv10=
X-Received: by 2002:a81:ff05:: with SMTP id k5mr9797809ywn.474.1644780571527;
 Sun, 13 Feb 2022 11:29:31 -0800 (PST)
MIME-Version: 1.0
References: <20220213040545.365600-1-tilan7663@gmail.com> <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
 <101663cb4d7d43e9b6bfa946f6b8036b@exmbdft6.ad.twosigma.com>
 <CANn89iKDzgHk_gk9+56xumy9M40br-aEoUXJ13KtFgxZRQJVOw@mail.gmail.com>
 <dd7f3fd1b08a44328d59116cd64f483a@exmbdft6.ad.twosigma.com>
 <CANn89iLdcy4qbUUNSpLKoegh8+Nc=edC3WshQ=OasKyWJQ256A@mail.gmail.com> <746fd1ba6d994ecf8d6e9854abb75409@exmbdft6.ad.twosigma.com>
In-Reply-To: <746fd1ba6d994ecf8d6e9854abb75409@exmbdft6.ad.twosigma.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 13 Feb 2022 11:29:20 -0800
Message-ID: <CANn89i+1aPNwGCP1Y+-nPxh4A_+t0JdOWorZHvXpRD_2OhjTMQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: allow the initial receive window to be greater than 64KiB
To:     Tian Lan <Tian.Lan@twosigma.com>
Cc:     Tian Lan <tilan7663@gmail.com>, netdev <netdev@vger.kernel.org>,
        Andrew Chester <Andrew.Chester@twosigma.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Sun, Feb 13, 2022 at 11:26 AM Tian Lan <Tian.Lan@twosigma.com> wrote:
>
> > I suggest that you do not interpret things as " BPF_SOCK_OPS_RWND_INIT =
could exceed 64KiB"  because it can not.
>
> > If you really need to send more than 64KB in the first RTT, TCP is not =
a proper protocol.
>
> > 13d3b1ebe287 commit message should have been very clear about the 64K l=
imitation.
>
> I'm not trying to make the sender to send more than 64Kib in the first RT=
T. The change will only make the sender to send more starting on the second=
 RTT(after first ack received on the data). Instead of having the rcv_wnd t=
o grow from 64Kib, the rcv_wnd can start from a much larger base value.
>
> Without the patch:
>
> RTT:                                1,                   2,              =
   3,  ...
> rcv_wnd:                64KiB,        192KiB,         576KiB,  ...

This is just fine, in accordance with what we expect.

>
> With the patch (assume rcv_wnd is set to 512KiB):
>
> RTT:                                1,                    2,             =
   3,   ...
> rcv_wnd:                64KiB,    1.536MiB,    4.608MiB,  ...

This is not needed, unless you want to blast MB of data in the second RTT.

Please get IETF approval first.
