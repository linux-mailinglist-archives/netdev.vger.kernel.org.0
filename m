Return-Path: <netdev+bounces-192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E76A56F5D12
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1518628171F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B037107BE;
	Wed,  3 May 2023 17:34:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C45A52
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 17:34:22 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8995AC;
	Wed,  3 May 2023 10:34:20 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2a8dd1489b0so54372701fa.3;
        Wed, 03 May 2023 10:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683135259; x=1685727259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqIFFECjD8VbhTkVXBRW7iw73ClVU9Rx1DVSjMQg4AI=;
        b=bkI/H/0RlNbJpxMKaE08VNPaEMX7VGjhwLUeyFtckK/cp88nmGMTBJKDedNpmrkny0
         PrY0Nk2uy406S0HQ4FV9zlP0FC/MoJV33b5FInYHwRD/qPY3imf19obSMfi6kmIpzcvU
         S+rrro7FK8NvGuk8U4e9x0uiyeOTWlFwdAhk98+j5fPl7H8Mjpr/gKdEJpWPtip5rQqL
         nXqxfZO8+iJ9gf0wR2cbnqjvTMhoJ6Yh+4jqJQ7hojgAC4uLhEIu6G5qJh1TqFaviwi/
         HdS8sMeifnzXvqzHSLlHNRScTL6BTp2z4q0WH1+T1WmsG0tKRjGkMZ/yKJ5JrvPEsnVJ
         fMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683135259; x=1685727259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XqIFFECjD8VbhTkVXBRW7iw73ClVU9Rx1DVSjMQg4AI=;
        b=kMx/ja9NOpUnhfC1TqJs5T6dUx30jxn/Rx769nCjgC6mE4zWFsDZSaHhO5JDH1B0Br
         B1P8WCMzXWPRWzfLFBTWlojuVdmFHLsBLgCtRcJAAVWaRX6+8/qvfOAHcnLxXrB1Th9w
         wk6PuX6XY3MAOFyHeukOoSucHEFINYC/wSUthqtriX0YrmY9PJuN7VLMp3Ws3HSXXH0f
         2Aut4D0NkpDGhGtMNgTpsrhrx2ykY7yRqoc0HYQft4kVcFwan2Lq8oSymBk2D8NiySON
         fqNJTO69ClzToFNsGWWa7t9J5ShZrsPSJx1/FQ06ndYgVmc2VROEChHXIMNWcillrV3k
         +14A==
X-Gm-Message-State: AC+VfDzSvx4b7jsF1E/EKuNIENOO8vpZ94RK5hH5ULCisdyv3kFOlcJO
	Fdy98ypxKPPbMTadttkW/CcjnruklpKYfO4TgUI=
X-Google-Smtp-Source: ACHHUZ7FMfCySIhXZgy4cLrSjQETM2G2bNB+KW2RTdqpfocu+dBYWUTW54izs9Nm00SLN+1A6WDs+d51UH1TPlrg9GI=
X-Received: by 2002:a2e:94ca:0:b0:2a8:e670:c3cc with SMTP id
 r10-20020a2e94ca000000b002a8e670c3ccmr228651ljh.16.1683135258825; Wed, 03 May
 2023 10:34:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230424124852.12625-1-johan+linaro@kernel.org>
 <20230424124852.12625-2-johan+linaro@kernel.org> <CABBYNZLBQjWVb=z8mffi4RmeKS-+RDLV+XF8bR2MiJ-ZOaFVHA@mail.gmail.com>
 <ZFIHj9OAJkRvSscs@hovoldconsulting.com>
In-Reply-To: <ZFIHj9OAJkRvSscs@hovoldconsulting.com>
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date: Wed, 3 May 2023 10:34:06 -0700
Message-ID: <CABBYNZJ23E50J2gfi5NgHj_bXMuVTHk29s+BH-zMhhWmRsd0Pg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Bluetooth: fix debugfs registration
To: Johan Hovold <johan@kernel.org>
Cc: Johan Hovold <johan+linaro@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Johan,

On Wed, May 3, 2023 at 12:04=E2=80=AFAM Johan Hovold <johan@kernel.org> wro=
te:
>
> On Tue, May 02, 2023 at 04:37:51PM -0700, Luiz Augusto von Dentz wrote:
> > Hi Johan,
> >
> > On Mon, Apr 24, 2023 at 5:50=E2=80=AFAM Johan Hovold <johan+linaro@kern=
el.org> wrote:
> > >
> > > Since commit ec6cef9cd98d ("Bluetooth: Fix SMP channel registration f=
or
> > > unconfigured controllers") the debugfs interface for unconfigured
> > > controllers will be created when the controller is configured.
> > >
> > > There is however currently nothing preventing a controller from being
> > > configured multiple time (e.g. setting the device address using btmgm=
t)
> > > which results in failed attempts to register the already registered
> > > debugfs entries:
> > >
> > >         debugfs: File 'features' in directory 'hci0' already present!
> > >         debugfs: File 'manufacturer' in directory 'hci0' already pres=
ent!
> > >         debugfs: File 'hci_version' in directory 'hci0' already prese=
nt!
> > >         ...
> > >         debugfs: File 'quirk_simultaneous_discovery' in directory 'hc=
i0' already present!
> > >
> > > Add a controller flag to avoid trying to register the debugfs interfa=
ce
> > > more than once.
> > >
> > > Fixes: ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for unc=
onfigured controllers")
> > > Cc: stable@vger.kernel.org      # 4.0
> > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > > ---
>
> > > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > > index 632be1267288..a8785126df75 100644
> > > --- a/net/bluetooth/hci_sync.c
> > > +++ b/net/bluetooth/hci_sync.c
> > > @@ -4501,6 +4501,9 @@ static int hci_init_sync(struct hci_dev *hdev)
> > >             !hci_dev_test_flag(hdev, HCI_CONFIG))
> > >                 return 0;
> > >
> > > +       if (hci_dev_test_and_set_flag(hdev, HCI_DEBUGFS_CREATED))
> > > +               return 0;
> >
> > Can't we just use HCI_SETUP like we do with in create_basic:
> >
> >     if (hci_dev_test_flag(hdev, HCI_SETUP))
> >         hci_debugfs_create_basic(hdev);
> >
> > Actually we might as well move these checks directly inside the
> > hci_debugfs function to make sure these only take effect during the
> > setup/first init.
>
> The problem is that commit ec6cef9cd98d ("Bluetooth: Fix SMP channel
> registration for unconfigured controllers") started deferring creation
> of most parts of the debugfs interface until the controller is
> configured (e.g. as some information is not available until then).
>
> Moving everything back to setup-time would effectively revert that.

Not moving back but just doing something like:

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index ec0df2f9188e..a6e94c29fc5a 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -310,6 +310,9 @@ DEFINE_INFO_ATTRIBUTE(firmware_info, fw_info);

 void hci_debugfs_create_common(struct hci_dev *hdev)
 {
+       if (!hci_dev_test_flag(hdev, HCI_SETUP))
+               return;
+
        debugfs_create_file("features", 0444, hdev->debugfs, hdev,
                            &features_fops);
        debugfs_create_u16("manufacturer", 0444, hdev->debugfs,

> Perhaps the interface can be changed in some way so that everything is
> again registered at setup-time (e.g. with placeholder values instead of
> conditionally created attributes), but that would at least not be
> something that we could backport.
>
> > >         hci_debugfs_create_common(hdev);
> > >
> > >         if (lmp_bredr_capable(hdev))
>
> Johan



--=20
Luiz Augusto von Dentz

