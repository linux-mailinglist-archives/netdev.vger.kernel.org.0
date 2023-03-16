Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249236BD7C5
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 19:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjCPSGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 14:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCPSGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 14:06:44 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566AA93E1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 11:06:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c18so2637881ple.11
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 11:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1678990003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mCt8prfCSQ7oDsx1bTuDrvYgv/LfInuW8e+kaRN+58=;
        b=N7kAVSsQ2PohremsNoTkrBI76k1fo4dMkpIMDKU+nAYfLZWsQ7F29kyOiVeTJdYwZX
         Fd65aCXwSsf023/A96yZN403ncG2Q8IWQoinGlAomyWDPk79ic0Fpp+DHxUwB7utP5OV
         ZX4wSoTBTeEV9AAb5l1N8EFXjOHRnq7lhBgBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678990003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8mCt8prfCSQ7oDsx1bTuDrvYgv/LfInuW8e+kaRN+58=;
        b=eXla8v56TStMkaddpOvd9PxKV/nTFmD/SPqsdPYqCRRt888gJ2nQodjMEhhqCNTwzZ
         5aBH6i3DlhCuyzg4Nv+bqGr2pPIP0/VLaRypDoIwEbGq6V5ZnP38EF06s27Q9iFzczjm
         N1boKGwOsjqL9M6hwO5QDWf4d6KwCv+86U3dHlOVtGz28q3e5qoeJSUOYbalEi9XIKtJ
         vsAs/zKUTQy7xpVTNiDbxRHuOBv2LhZb4uAh1wCondcjddPKMPei0siAlrwdj3iWX9uq
         70xGQTE82ADLrGslXM9g17p2D8Q9zTk2KyL/tBUcIyKFzGHcyw19vA7yIU7MOO+Ea3WK
         k3KA==
X-Gm-Message-State: AO0yUKW/I9fsXDoxzf2n8BVVxV2s3gDwYd+M+E7WsmXKIGXmlSXUcs1x
        dmd8C8Z4ud/xdpPr+ozPyHPELMCMwT0KllBgSrLFOg==
X-Google-Smtp-Source: AK7set+M3yi0RkByN/JVYAXsavvcjHycEh223j6ZkIHzA6icQqmZXnmsToLX0ZkwVT+60lYsEynMe/S+6cJ5ovdwPBo=
X-Received: by 2002:a17:90a:5386:b0:237:9cbe:22ad with SMTP id
 y6-20020a17090a538600b002379cbe22admr1400389pjh.5.1678990002656; Thu, 16 Mar
 2023 11:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230315181902.4177819-1-joel@joelfernandes.org>
 <20230315181902.4177819-12-joel@joelfernandes.org> <996f0981-98f4-5077-12b6-bb093bbd28be@datenfreihafen.org>
In-Reply-To: <996f0981-98f4-5077-12b6-bb093bbd28be@datenfreihafen.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 16 Mar 2023 14:06:30 -0400
Message-ID: <CAEXW_YT-KEU-c6zUUEDPvBS=9HFmc1L6JeQiwXU-RfYR78sywA@mail.gmail.com>
Subject: Re: [PATCH v2 12/14] mac802154: Rename kfree_rcu() to kvfree_rcu_mightsleep()
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Girault <david.girault@qorvo.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Alexander Aring <aahringo@redhat.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 12:41=E2=80=AFPM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
> Hello.
>
> On 15.03.23 19:18, Joel Fernandes (Google) wrote:
> > The k[v]free_rcu() macro's single-argument form is deprecated.
> > Therefore switch to the new k[v]free_rcu_mightsleep() variant. The goal
> > is to avoid accidental use of the single-argument forms, which can
> > introduce functionality bugs in atomic contexts and latency bugs in
> > non-atomic contexts.
> >
> > The callers are holding a mutex so the context allows blocking. Hence
> > using the API with a single argument will be fine, but use its new name=
.
> >
> > There is no functionality change with this patch.
> >
> > Fixes: 57588c71177f ("mac802154: Handle passive scanning")
> > Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> >   net/mac802154/scan.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
> > index 9b0933a185eb..5c191bedd72c 100644
> > --- a/net/mac802154/scan.c
> > +++ b/net/mac802154/scan.c
> > @@ -52,7 +52,7 @@ static int mac802154_scan_cleanup_locked(struct ieee8=
02154_local *local,
> >       request =3D rcu_replace_pointer(local->scan_req, NULL, 1);
> >       if (!request)
> >               return 0;
> > -     kfree_rcu(request);
> > +     kvfree_rcu_mightsleep(request);
> >
> >       /* Advertize first, while we know the devices cannot be removed *=
/
> >       if (aborted)
> > @@ -403,7 +403,7 @@ int mac802154_stop_beacons_locked(struct ieee802154=
_local *local,
> >       request =3D rcu_replace_pointer(local->beacon_req, NULL, 1);
> >       if (!request)
> >               return 0;
> > -     kfree_rcu(request);
> > +     kvfree_rcu_mightsleep(request);
> >
> >       nl802154_beaconing_done(wpan_dev);
> >
>
> I just saw that there is a v2 of this patch. My ACK still stands as for v=
1.
>
>
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

Thanks! Applied the ack and will be taking it via the RCU tree as we discus=
sed.

 - Joel
