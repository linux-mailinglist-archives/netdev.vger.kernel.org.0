Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CF55269B0
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383451AbiEMS5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383418AbiEMS5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:57:06 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1266B7E6
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:57:01 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id q73-20020a4a334c000000b0035eb110dd0dso2884813ooq.10
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wum7m/AWYrADrVd3nYIP1zeEUmvEHouw2DspDSjzyyI=;
        b=VVwk/4AifqQYGpAdkZ4ifDF4cObtc7AOim47EWqAysMphAOW1j1bYnm2+VdsAfvfVf
         PB0V2qBowsq6sRTU6p/wBQYzuQunRIbPdHReRB5C+t0YowC6Blu3n4vE8CIaMSZt1Bd/
         zlAINbyxSkWMRDxF+EkFPzIbVk1JKMmzTTTiETJ1oT278wAGr1eHNrohjvxwG5A/Vh7I
         uyWiyEH2XyRjoSVRWS7N4LUQpuqt2XtxcAgaoNoKWizx0o5CHTg+qsqzeFhEv1AZUEHY
         TXHJ9+Bugt4EgC041baDfkC7jahSJODFveRMjGR58YizYr68I7PpR/BJ+1i/uqpk//6G
         BA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wum7m/AWYrADrVd3nYIP1zeEUmvEHouw2DspDSjzyyI=;
        b=foFxxz9PQIyZVpVzuJiKaJpNiArvp3p3Pdi92Fo7Wg3H621ZXJBJN7S+nVwobP3ZN4
         vi/h95vCxaTpdeHqTtDGesVCyT6UEkJrKv5ojG02+iGJzbb8kxXgCpO4ox3O9IIT2w1S
         fV2CetlEaw0Y0Oqx9mQrlTsTa+I9S/KBrbI9pOz8U+L/Q525w0iPUBgUIE5EYsvS3c0V
         x/niMQKHNMZrLspwaHUpHCqz+LFPJQCjbqvBCm3A2uX8/mlsY7cl0mdlDeqnI+ZilPNT
         AqUMXCYF6ChljXdQrm0f3+IQ5QFcwrOawAu75NvTMM5VJLcIRpP9tNanw1K2vzasIj8t
         jp4Q==
X-Gm-Message-State: AOAM532ZqqPSZJVBK6mmY8JYt2T0eP/ASe1pXzv7Dt/LgpWsjRw/cKww
        GgeYHJa7Fq9Lunb1ySfMtlRRjmhUEPfPRIoq5vOtBx6MX/nytg==
X-Google-Smtp-Source: ABdhPJzrtYgrdlPCX7WbJr8lLXwTqW2xY9t0qr184w2an30VL7p3S7frxKky0IrCob6pdc2J39Xt0cQEN3yK4p82YXk=
X-Received: by 2002:a4a:95c6:0:b0:35f:7f11:7055 with SMTP id
 p6-20020a4a95c6000000b0035f7f117055mr2445597ooi.87.1652468221329; Fri, 13 May
 2022 11:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <01a8af8654b87058ecd421e471d760a43784ab96.1652456873.git.lucien.xin@gmail.com>
 <CANn89iJxkikxKmN7JM_-1dohhb7TvH0Ok7CWxAajz_Lqi3y3Dw@mail.gmail.com>
In-Reply-To: <CANn89iJxkikxKmN7JM_-1dohhb7TvH0Ok7CWxAajz_Lqi3y3Dw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 13 May 2022 14:56:20 -0400
Message-ID: <CADvbK_csbGvLsAPpk+fZcE0APeNz26iwTSCYZTK9=RDNRV2E5Q@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: set dst dev to blackhole_netdev instead of
 loopback_dev in ifdown
To:     Eric Dumazet <edumazet@google.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
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

On Fri, May 13, 2022 at 12:22 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 13, 2022 at 8:47 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > The global blackhole_netdev has replaced pernet loopback_dev to become the
> > one given to the object that holds an netdev when ifdown in many places of
> > ipv4 and ipv6 since commit 8d7017fd621d ("blackhole_netdev: use
> > blackhole_netdev to invalidate dst entries").
> >
> > Especially after commit faab39f63c1f ("net: allow out-of-order netdev
> > unregistration"), it's no longer safe to use loopback_dev that may be
> > freed before other netdev.
>
> Maybe add it formally in Fixes: tag.
>
Sure. :)

Fixes: faab39f63c1f ("net: allow out-of-order netdev unregistration")

> >
> > This patch is to set dst dev to blackhole_netdev instead of loopback_dev
> > in ifdown.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/xfrm/xfrm_policy.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> > index 00bd0ecff5a1..f1876ea61fdc 100644
> > --- a/net/xfrm/xfrm_policy.c
> > +++ b/net/xfrm/xfrm_policy.c
> > @@ -3744,7 +3744,7 @@ static int stale_bundle(struct dst_entry *dst)
> >  void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev)
> >  {
> >         while ((dst = xfrm_dst_child(dst)) && dst->xfrm && dst->dev == dev) {
> > -               dst->dev = dev_net(dev)->loopback_dev;
> > +               dst->dev = blackhole_netdev;
>
> I assume the XFRM layer is ready to deal with dst->dev set to blackhole ?
>
> No initial setup needed ?
I don't see why it's not ready, since it's been using loopback_dev.
In early time, commit 8d7017fd621d replaced loopback_dev quite straightforward
for ipv4/6.

BTW, there's still another one left in dn_dst_ifdown(), I will fix it
in another patch.

Thanks.

>
> Thanks
>
> >                 dev_hold(dst->dev);
> >                 dev_put(dev);
> >         }
> > --
> > 2.31.1
> >
