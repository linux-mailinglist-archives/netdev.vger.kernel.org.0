Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF8D4B3D05
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 19:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbiBMS6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 13:58:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBMS6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 13:58:17 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CE558392
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:58:11 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id y129so40071641ybe.7
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 10:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ew8PqPEbZBWzfevB3NEWGS2Lkb8y3iyHOCrxvYETz2Y=;
        b=eQ3Z+RdSqFFntOL6rYj11u8827UREQn0Ycl8veJ995UBdJqbfP56yLwlreplYSd23M
         hAmb0FVu90xNF4vHh32cykCnEOsyk9sVsailAWnYYZ93wrMvqUduAH7oePGEXABQA7Lx
         8nDR/nWFmLf/oYHdr7RS2cbgAG40HEWiL06bS+jVdnSjYnII8WgwEGM4DGtoV4VX5BtX
         S5eGOBB/mUu4BEAYSh1D7VQijcvo5UTgd36kyFx7bfjn2hzLmdeFDKyxw/9tSkAS7s/Z
         V/x+N/PxS7gJ1xSpSER2xYIa7rK2qclo2XpWDuQi0AsRKAVS3p9LJfjkehRvRUeSUJbr
         7GdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ew8PqPEbZBWzfevB3NEWGS2Lkb8y3iyHOCrxvYETz2Y=;
        b=XNuwvceq/J82bqz39l0B+6w/q3j9TNGay+8Ad6n1FNOIlFWm5u0P8l5+YMCUl/cmBE
         9X19P6dUluxbJcpufAxama0N7BALa1UgvTdE8g2qy4dDzIFjAxO6Qwn7ig/EJxR4+yRK
         TQv/5qWqSyX6yt5/tBtCYjyVvTJM08jTlGEiv6kacsHeL0sCU+YjXRFfZT43MaCwQADw
         xGRSh3CJ55vzSgmhn/kEHb3UbUT6+mxdIXG31OKQVOnbmh/UIedt54jmaSDcec2XocYt
         UXYpIe42necuWkiOfvEWn4NRMKeIjQXcOAa7jeTEhGiCH+7dwTEKyYSYv5IoQFuHBf6N
         mY/Q==
X-Gm-Message-State: AOAM530KmGxQZKAKGIjFgyhWQPFf/5p+w9zjH7fcmhmxxqXjHQPn5/+F
        fiYD6N0TfrzFULG/FRwt07TTeQ9JY/awMbOERPhEUg==
X-Google-Smtp-Source: ABdhPJzMn2EQbtU855KGn9wsJ2wmLdC4J6kd6DQ42+Vam/YIJnzIkKs44R7f3Sz+eMYsI5o70Mhr/CHL8QcnEI8F9+Y=
X-Received: by 2002:a81:26c3:: with SMTP id m186mr10279438ywm.250.1644778690011;
 Sun, 13 Feb 2022 10:58:10 -0800 (PST)
MIME-Version: 1.0
References: <20220213040545.365600-1-tilan7663@gmail.com> <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
 <101663cb4d7d43e9b6bfa946f6b8036b@exmbdft6.ad.twosigma.com>
 <CANn89iKDzgHk_gk9+56xumy9M40br-aEoUXJ13KtFgxZRQJVOw@mail.gmail.com> <dd7f3fd1b08a44328d59116cd64f483a@exmbdft6.ad.twosigma.com>
In-Reply-To: <dd7f3fd1b08a44328d59116cd64f483a@exmbdft6.ad.twosigma.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 13 Feb 2022 10:57:58 -0800
Message-ID: <CANn89iLdcy4qbUUNSpLKoegh8+Nc=edC3WshQ=OasKyWJQ256A@mail.gmail.com>
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

On Sun, Feb 13, 2022 at 10:52 AM Tian Lan <Tian.Lan@twosigma.com> wrote:
>
> > To be clear, if the sender respects the initial window in first RTT , t=
hen first ACK it will receive allows a much bigger window (at least 2x),  a=
llowing for standard slow start behavior, doubling CWND at each RTT>
> >
> > linux TCP stack is conservative, and wants a proof of remote peer well =
behaving before opening the gates.
> >
> > The thing is, we have this issue being discussed every 3 months or so, =
because some people think the RWIN is never changed or something.
> >
> > Last time, we asked to not change the stack, and instead suggested user=
s tune it using eBPF if they really need to bypass TCP standards.
> >
> > https://lkml.org/lkml/2021/12/22/652
>
> I totally understand that Linux wants to be conservative before opening u=
p the gate and I'm fully support of this idea. I think the current Linux be=
havior is good for network with low latency, but in an environment with hig=
h RTT (i.e 20ms), the rcv_wnd really becomes the bottleneck. It took approx=
imately 6 * RTT on average for 4MiB transfer even with large initial snd_cw=
nd. I think allowing a larger default rcv_wnd would greatly reduce the numb=
er of RTT required for the transfer.
>
> From my understanding, BPF_SOCK_OPS_RWND_INIT was added to the kernel to =
allow the users to by-pass the default if they choose to. Prior to kernel 4=
.19, the rcv_wnd set via BPF_SOCK_OPS_RWND_INIT could exceed 64KiB and up t=
o the space. But since then, the initial rwnd would always be limited to th=
e 64KiB. This patch would just make the kernel behave similarly to the kern=
el prior to 4.19 if rcv_wnd is set by eBPF.
>
> What would you suggest for the application that currently relies on setti=
ng a "larger" rcv_wnd via BPF_SOCK_OPS_RWND_INIT, do you think if it is a b=
etter idea if the rcv_wnd is set after the connection is established.

I suggest that you do not interpret things as " BPF_SOCK_OPS_RWND_INIT
could exceed 64KiB"  because it can not.

If you really need to send more than 64KB in the first RTT, TCP is not
a proper protocol.

13d3b1ebe287 commit message should have been very clear about the 64K
limitation.
