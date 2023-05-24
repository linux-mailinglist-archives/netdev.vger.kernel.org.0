Return-Path: <netdev+bounces-5170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 120EF70FF91
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 23:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB87A2813D0
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C944C2260F;
	Wed, 24 May 2023 21:01:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD71B182A2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 21:01:59 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F36B6
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:01:57 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-510e5a8704bso785a12.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684962116; x=1687554116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ecRHb3a4uZb7D9V7KAm1/nNRXIsZmVIjd+RGF7WArC0=;
        b=Y5GLMKGFPpIlQIqkAD39okDyWwz+EMI6KjtjQk4TVsTOtaWHy4Lt7mmHTJmGhBmz/S
         7Xp5+LCH0/jjszqdPtFwYFtRNcaNAmMyWgsMV8z+snOmyhRqZ/RFPxUc/O05u+Wt8z27
         wkUu4Mkt1sKkoHYscyuLFbyJzwHe3LU0BW2Ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684962116; x=1687554116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ecRHb3a4uZb7D9V7KAm1/nNRXIsZmVIjd+RGF7WArC0=;
        b=DL+PWdr2QaetWCak5TZT3ot79HQFH8gewTq/dbimSq1/uUn6kzkbfqkVw2KtU4RU03
         GZUGaLepZjV37HXJPsTR5H21FG/v4UOrYi4N/3b3ddk3RYMtdZQrwu9BTJYuTo1+whw5
         BTCR7ftUcMVO1HORYCnAqXAwHSz/UQ9wrik9k+7BuQNHeFKB3jynynkvRvQ3yT81TcNP
         1DyougigX2XfKQIuZ63jjqmNbLOXJn4Jd1M0ocL0qGZTv+SKqK1/ILPHBvbW8JA1VjtJ
         hyG4r19t8lBzczNJ8rV6ZRQjPGsI4Ie8SDjZ6faeVoxIPQDFeuF9YHnmayKkMS5E8r8R
         4/4w==
X-Gm-Message-State: AC+VfDzUJwxFyrYp0FkpYMOuSqC1DNMQz8Ny3X/NMVggeDYn0VGt2DyC
	KuJuULCuEcVETQwPosbQPjAhmNhZkxQY8H+NtBoDfQ==
X-Google-Smtp-Source: ACHHUZ6ZLl9FAFgZv7T7gZGWy3LVOp7WfMUJpmQRoNZp2N//Vp6blt2TIamig2Vgxpe5PVROXbu3CI1TU8VYliv/Kzk=
X-Received: by 2002:a50:cd47:0:b0:4bc:dee8:94ca with SMTP id
 d7-20020a50cd47000000b004bcdee894camr23378edj.7.1684962116191; Wed, 24 May
 2023 14:01:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230518072657.1.If9539da710217ed92e764cc0ba0f3d2d246a1aee@changeid>
 <CALs4sv2+Uu=Bry=B3FYzWdNrHjGWDvPCDhTFcNERVpWTjpmEyA@mail.gmail.com>
 <CANEJEGuzoBa_yYHRCa0KygUe=AOhUkSg4u6gWx+QNCuGtKod2Q@mail.gmail.com>
 <52cfebaf-79f6-c318-c14b-3716555d0e8f@intel.com> <SJ0PR11MB5866456B9007E3DC55FD8728E5419@SJ0PR11MB5866.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5866456B9007E3DC55FD8728E5419@SJ0PR11MB5866.namprd11.prod.outlook.com>
From: Grant Grundler <grundler@chromium.org>
Date: Wed, 24 May 2023 14:01:44 -0700
Message-ID: <CANEJEGsOU3KkG5rQ5ph3EQOiBvPXmhUk7aPvM3nj5V5KudP=ZA@mail.gmail.com>
Subject: Re: [PATCH] igb: Fix igb_down hung on surprise removal
To: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
Cc: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>, Grant Grundler <grundler@chromium.org>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, "Neftin, Sasha" <sasha.neftin@intel.com>, 
	"Ruinskiy, Dima" <dima.ruinskiy@intel.com>, Ying Hsu <yinghsu@chromium.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, Paolo Abeni <pabeni@redhat.com>, 
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 5:34=E2=80=AFAM Loktionov, Aleksandr
<aleksandr.loktionov@intel.com> wrote:
>
> Good day Tony
>
> We reviewed the patch and have nothing against.

Thank you for reviewing!

Can I take this as the equivalent of "Signed-off-by: Loktionov,
Aleksandr <aleksandr.loktionov@intel.com>"?

Or since Tony is listed in MAINTAINERS for drivers/net/ethernet/intel,
is he supposed to provide that?

cheers,
grant

>
> With the best regards
> Alex
> ND ITP Linux 40G base driver TL
>
>
>
> > -----Original Message-----
> > From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> > Sent: Tuesday, May 23, 2023 8:04 PM
> > To: Grant Grundler <grundler@chromium.org>; Pavan Chebbi
> > <pavan.chebbi@broadcom.com>; Loktionov, Aleksandr
> > <aleksandr.loktionov@intel.com>; Neftin, Sasha <sasha.neftin@intel.com>=
;
> > Ruinskiy, Dima <dima.ruinskiy@intel.com>
> > Cc: Ying Hsu <yinghsu@chromium.org>; netdev@vger.kernel.org; David S.
> > Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> > Jakub Kicinski <kuba@kernel.org>; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Paolo Abeni <pabeni@redhat.com>; intel-
> > wired-lan@lists.osuosl.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] igb: Fix igb_down hung on surprise removal
> >
> > On 5/22/2023 1:16 PM, Grant Grundler wrote:
> > > On Thu, May 18, 2023 at 3:36=E2=80=AFAM Pavan Chebbi
> > <pavan.chebbi@broadcom.com> wrote:
> > >>
> > >> On Thu, May 18, 2023 at 12:58=E2=80=AFPM Ying Hsu <yinghsu@chromium.=
org>
> > wrote:
> > >>>
> > >>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> > >>> b/drivers/net/ethernet/intel/igb/igb_main.c
> > >>> index 58872a4c2540..a8b217368ca1 100644
> > >>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > >>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > >>> @@ -9581,6 +9581,11 @@ static pci_ers_result_t
> > igb_io_error_detected(struct pci_dev *pdev,
> > >>>          struct net_device *netdev =3D pci_get_drvdata(pdev);
> > >>>          struct igb_adapter *adapter =3D netdev_priv(netdev);
> > >>>
> > >>> +       if (state =3D=3D pci_channel_io_normal) {
> > >>> +               dev_warn(&pdev->dev, "Non-correctable non-fatal err=
or
> > reported.\n");
> > >>> +               return PCI_ERS_RESULT_CAN_RECOVER;
> > >>> +       }
> > >>> +
> > >>
> > >> This code may be good to have. But not sure if this should be the fi=
x
> > >> for igb_down() synchronization.
> > >
> > > I have the same opinion. This appears to solve the problem - but I
> > > don't know if there is a better way to solve this problem.
> > >
> > >> Intel guys may comment.
> > >
> > > Ping? Can we please get feedback from IGB/IGC maintainers this week?
> > >
> > > (I hope igc maintainers can confirm this isn't an issue for igc.)
> >
> > Adding some of the igb and igc developers.
> >
> > > cheers,
> > > grant
> > >
> > >>
> > >>>          netif_device_detach(netdev);
> > >>>
> > >>>          if (state =3D=3D pci_channel_io_perm_failure)
> > >>> --
> > >>> 2.40.1.606.ga4b1b128d6-goog
> > >>>
> > >>>

