Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E927B63E73C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 02:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLABt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 20:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLABt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 20:49:27 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CEC76140;
        Wed, 30 Nov 2022 17:49:26 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id y83so191086yby.12;
        Wed, 30 Nov 2022 17:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ASlF8P8Cjkv5aBNg3NNVj0Sbno4BP6bRyvkitAAUHtw=;
        b=Yuio867pzsacBPROxPCWBAv2+4qJ5sKTgpsELTI3ERVE/woS/iqrhDdziy5L+emNY6
         TwlQOWhoLNYDe5OCwlEuxw9eoF9WJ82f3AGwXb32J1YmI7eEn9QJWBfdSXWuFxNuLhL+
         XztGqqn+9MDcOeFU1+CzTxDh2J2QRYQ731E6/pd0fSr9qTlca63zNWa6lLJs8/LkMB5c
         wWPDoeuax/0SXF9+FoQ0vlXXfOZ2F1GvkfMgusoOORUPQbDeD2odlyOQ8AS4TnmeFZGz
         xhc7l0XYssiszMAToVQSt0M9Ak0oLDJSGaVoXJJr27Jotvpjuq4OgQshs/qIHYnL21DG
         Otqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASlF8P8Cjkv5aBNg3NNVj0Sbno4BP6bRyvkitAAUHtw=;
        b=aym//TD1UWzMJXO1pH6azFEIystjK9hQnakWYq67Wl0bjgj5OxLeD6ZPtz32yF7mgr
         YNsOFA628I9e59rPVnseujqCtnu52DmR0/yPgFAksqYIHY16VeypsmKWMSPpTM+iklSc
         ws5KmygeROqFrKZR1i0zs/t0n3KdVea33Lu1dMeNaaZrvx+DUl9nT6ryL8XYpvsZZgWG
         aL5XE0wjuCtn/iUg68cHSWZPuwIzgj+2LZ6f6dKARuUGIWH27vu0Nzg7cOXgNoZohDCM
         7ovBbfBEIZHHdcm4A8j+4mWpWuH7TIlfuFlkxiaFu0rfbYd6SSQjX+bKMkjJ5bUOBlOW
         +K/A==
X-Gm-Message-State: ANoB5pnlq/OdlEoUZQfHlVNJINghUkQuxx7GS6eDInzdZ7Opl/TvxVMr
        F4dmXdO0H/3n0mT6urYK/8R0kk+0Eh3OHZ30Ul4=
X-Google-Smtp-Source: AA0mqf7m930pENVDkd5XVVZzHpy7ijyk/f5n3TgDwvPUU0zxtEEIVoFHXoJCU6CJMStuzeyTSQzgy1IDXlCbcabAntw=
X-Received: by 2002:a25:b948:0:b0:6de:6c1:922e with SMTP id
 s8-20020a25b948000000b006de06c1922emr62074536ybm.0.1669859365431; Wed, 30 Nov
 2022 17:49:25 -0800 (PST)
MIME-Version: 1.0
References: <20221129084329.92345-1-zys.zljxml@gmail.com> <Y4dhMhPswo5Y7DuU@corigine.com>
In-Reply-To: <Y4dhMhPswo5Y7DuU@corigine.com>
From:   Katrin Jo <zys.zljxml@gmail.com>
Date:   Thu, 1 Dec 2022 09:49:04 +0800
Message-ID: <CAOaDN_RHiNvBcNy75VDubkD05LKmzRFymCo08QqBgwS8vrpCTQ@mail.gmail.com>
Subject: Re: [PATCH] net: tun: Remove redundant null checks before kfree
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yushan Zhou <katrinzhou@tencent.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 9:57 PM Simon Horman <simon.horman@corigine.com> wr=
ote:
>
> + Thierry Reding, linux-tegra, dri-devel
>
> On Tue, Nov 29, 2022 at 04:43:29PM +0800, zys.zljxml@gmail.com wrote:
> > From: Yushan Zhou <katrinzhou@tencent.com>
> >
> > Fix the following coccicheck warning:
> > ./drivers/gpu/host1x/fence.c:97:2-7: WARNING:
> > NULL check before some freeing functions is not needed.
> >
> > Signed-off-by: Yushan Zhou <katrinzhou@tencent.com>
>
> Hi,
>
> the change in the patch looks good to me.
> However, it does not appear to be a networking patch,
> so I think you have sent it to the wrong place.
>
> With reference to:
>
> $ ./scripts/get_maintainer.pl drivers/gpu/host1x/fence.c
> Thierry Reding <thierry.reding@gmail.com> (supporter:DRM DRIVERS FOR NVID=
IA TEGRA)
> David Airlie <airlied@gmail.com> (maintainer:DRM DRIVERS)
> Daniel Vetter <daniel@ffwll.ch> (maintainer:DRM DRIVERS)
> Sumit Semwal <sumit.semwal@linaro.org> (maintainer:DMA BUFFER SHARING FRA=
MEWORK)
> "Christian K=C3=B6nig" <christian.koenig@amd.com> (maintainer:DMA BUFFER =
SHARING FRAMEWORK)
> dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR NVIDIA TEGRA)
> linux-tegra@vger.kernel.org (open list:DRM DRIVERS FOR NVIDIA TEGRA)
> linux-kernel@vger.kernel.org (open list)
> linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK)
> linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING FRAMEWO=
RK)
>
> And https://lore.kernel.org/dri-devel/39c44dce203112a8dfe279e8e2c4ad164e3=
cf5e5.1666275461.git.robin.murphy@arm.com/
>
> I would suggest that the patch subject should be:
>
>  [PATCH] gpu: host1x: Remove redundant null check before kfree
>
> And you should send it:
>
>   To: Thierry Reding <thierry.reding@gmail.com>
>   Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org
>
> > ---
> >  drivers/gpu/host1x/fence.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpu/host1x/fence.c b/drivers/gpu/host1x/fence.c
> > index ecab72882192..05b36bfc8b74 100644
> > --- a/drivers/gpu/host1x/fence.c
> > +++ b/drivers/gpu/host1x/fence.c
> > @@ -93,8 +93,7 @@ static void host1x_syncpt_fence_release(struct dma_fe=
nce *f)
> >  {
> >         struct host1x_syncpt_fence *sf =3D to_host1x_fence(f);
> >
> > -       if (sf->waiter)
> > -               kfree(sf->waiter);
> > +       kfree(sf->waiter);
> >
> >         dma_fence_free(f);
> >  }
> > --
> > 2.27.0
> >

Apologies for the mistake... I'll resend it to the correct place.
Thanks for your reminder, anyway.

Best,
Katrin
