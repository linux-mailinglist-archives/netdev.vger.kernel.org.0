Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A266D265D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjCaQ6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjCaQ6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:58:38 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719BACDC6
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:58:37 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q6so9981602iot.2
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680281917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQO8gFdZhPZqEv9jW6VDhWq1JUAzdecn3dMRQWYYc1M=;
        b=FWoPC2cicH2fuNaRU1k3oaRGmYey2RZ94ll7G9PRGABlGOI68bEZEWT1qN8/HLSUdr
         mjIRaKrIMu3PoHS+D7vAm1RZthJRjHHkT9BqYFA6tuxdlT2w5rkAIOoQefA+2o/Y91bN
         w7WsToQ0IfuNSgwpbGHWJPHl0hIYLWtycysieapI+B0a9/vob4MMKyjORk+xJLhLuaeJ
         kEZaVfowCe32Em5SsfFnIBbXUXW1Hgp2BmWGaN18Z0lDix44AK+FTRPtdd7VSbLrYIX9
         GPu9Si/Lwz5ycwsN8aU41xVhUkUfT3sAPqyZsPCCbMbyVbG0gtbhkYOOT7hpI9rtTftD
         uGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQO8gFdZhPZqEv9jW6VDhWq1JUAzdecn3dMRQWYYc1M=;
        b=4z6n05Kq2MsvfPZjqICS00udNfYcmO+WEsD663mKacSALvQY1vo49KfCHxkNCKlQnT
         BxtdDSy4r3Aen7MMUe8cuIIOn/cjXHzqGpzz1LhD0QgdO46qEwGdcVKJv+bZhLmAJxyj
         qIcNFhcupe8VK7lBCNWtS7Qw5uG8mfYexCFMqP/4nL9SNdQpgSLU0EPlJ6IopQ2FDB12
         P7D9Xk0kPZwmxGsMW5dLRsWrW1z77KnNjTIbV88ml589PSUF0Obw+S80cTMQ5jjWIj+b
         vMOpwlGavUKzP7jtDsXZf3HU8dpwaEDmOY5fmQfDuyKS3QkvyT5m4eKK2abA/kDpDvOG
         IzGQ==
X-Gm-Message-State: AO0yUKWEmQa5skE6L0Kx4brMARtmFCysq93ZZquveBqlJ7WaYl0sXiQM
        kb9Uxbami/imEoDp5CfI6ZpaAicoUFpnqIZCWU6Zvg==
X-Google-Smtp-Source: AK7set9teEdu7own9W1arjTeOofkaJhVwyVxPeZbiYiV7sDY0uRxwDi6XRfrCS91YrmKE3uACacntw6rCpeTw4A+0MU=
X-Received: by 2002:a5e:c810:0:b0:752:dd73:efde with SMTP id
 y16-20020a5ec810000000b00752dd73efdemr10462766iol.1.1680281916552; Fri, 31
 Mar 2023 09:58:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230331074919.1299425-1-arnd@kernel.org> <8dd0ab75-d007-8aa7-e546-c5fe93f9e03b@intel.com>
In-Reply-To: <8dd0ab75-d007-8aa7-e546-c5fe93f9e03b@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Mar 2023 18:58:25 +0200
Message-ID: <CANn89iLcgesDzLvvoAhDSFgmKz_1VcMNOTA=F8rDXzLmOSuTvw@mail.gmail.com>
Subject: Re: [PATCH] net: netcp: MAX_SKB_FRAGS is now 'int'
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jason Xing <kerneljasonxing@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 5:08=E2=80=AFPM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: Arnd Bergmann <arnd@kernel.org>
> Date: Fri, 31 Mar 2023 09:48:56 +0200
>
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The type of MAX_SKB_FRAGS has changed recently, so the debug printk
> > needs to be updated:
> >
> > drivers/net/ethernet/ti/netcp_core.c: In function 'netcp_create_interfa=
ce':
> > drivers/net/ethernet/ti/netcp_core.c:2084:30: error: format '%ld' expec=
ts argument of type 'long int', but argument 3 has type 'int' [-Werror=3Dfo=
rmat=3D]
> >  2084 |                 dev_err(dev, "tx-pool size too small, must be a=
t least %ld\n",
> >       |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
> >
> > Fixes: 3948b05950fd ("net: introduce a config option to tweak MAX_SKB_F=
RAGS")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/net/ethernet/ti/netcp_core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/etherne=
t/ti/netcp_core.c
> > index 1bb596a9d8a2..dfdbcdeb991f 100644
> > --- a/drivers/net/ethernet/ti/netcp_core.c
> > +++ b/drivers/net/ethernet/ti/netcp_core.c
> > @@ -2081,7 +2081,7 @@ static int netcp_create_interface(struct netcp_de=
vice *netcp_device,
> >       netcp->tx_pool_region_id =3D temp[1];
> >
> >       if (netcp->tx_pool_size < MAX_SKB_FRAGS) {
> > -             dev_err(dev, "tx-pool size too small, must be at least %l=
d\n",
> > +             dev_err(dev, "tx-pool size too small, must be at least %d=
\n",
> >                       MAX_SKB_FRAGS);
> >               ret =3D -ENODEV;
> >               goto quit;
>
> (not related to the actual fix)
>
> I'd personally define %MAX_SKB_FRAGS as `(u32)CONFIG_MAX_SKB_FRAGS`.
> It can't be below zero or above %U32_MAX and we have to define it
> manually anyway, so why not cast to the type expected from it :D
>

Some files have the assumption MAX_SKB_FRAGS can be understood by the
C preprocessor.

#if MAX_SKB_FRAGS > 32
...

Kconfig does not allow to define unsigned int.
That would be the easiest way really...
