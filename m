Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B6511D8A3
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbfLLVfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:35:45 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45896 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730902AbfLLVfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:35:45 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so37325pfg.12
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 13:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tNyTr3xmeziTZe5n4V426N6wqESB9WWCV1aV/dRJK0E=;
        b=jtYZI5YHv3VJtSWh3BQF6X+5cFIIVp8oegV5yzeVVYq++sEUsz1H0+OOU2aMxdo35K
         icvN1Mx8S74gC+Jv9Cpi3n2lzwshgXabupjaIQ1GqJH6un9/tAG1dDQITbaMdL92vD6/
         0HGzyGCzIcb2r1Yhin6S0JRI5Ao8HheBQf4JqqSdZrl9zrz5GhyKBQN3KEIKJzs4XD1c
         fkOLmPgEwZL+Qxm4qHLBhNWwip1Rbvgwu7gciuaqcgd1HGnuVgHO1FGN6W5/SX1mLI2L
         dx2aLxH5MYfzOUB/aiGvv+xBUJiwqM91/goa/N0fPSqTIR7CYV2rOgsdsvehkFmOqhjh
         1WAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tNyTr3xmeziTZe5n4V426N6wqESB9WWCV1aV/dRJK0E=;
        b=T8KfrpH6ERVOK1DT2R2QTkVZnyC8GgFLVWQq8AEK9+zETw4bZ5k8HkIpR6YkMwhoNe
         lYLU+hBBXdepYzggAlThVuNhInkE9KL/FZXAabvDUSRtZ/WXSIqfxLEbM4Lq9PZRsXMS
         2hFCUIlRqO4wZSgxMiGmnfm2a/52cKUAbdFFm9Z7OQ4aJct4B/p14nFkrhbg/tvQJsAi
         KlgQtwYKFJRGrrJAUgo2Bf118t0hFDix2mE9s1TyCkC0MVCWveWIKMNiSjGygcoTr5dL
         xGzM/MZo/VEbYll+JdhqR14M5cp/A8UZSHCh9NJSzvU0WjOC5mtZOIH4ldn5GhyivfB4
         kclA==
X-Gm-Message-State: APjAAAXWDgaZSUfT8FsFSSTq6hVA26n+caHIr3puGf8F+U7TLTK2CExW
        loJORqlwfFwg2jZ//LyPtsMGDg==
X-Google-Smtp-Source: APXvYqwSF48EtHnWteAR453fDew61L0gXn3g7cyIvgMYVcCUPbn3BCzIzqR1GWn2Dz9nkzIbBUUWEg==
X-Received: by 2002:a63:c207:: with SMTP id b7mr13054407pgd.422.1576186544879;
        Thu, 12 Dec 2019 13:35:44 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s15sm7615906pgq.4.2019.12.12.13.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 13:35:44 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:35:40 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Message-ID: <20191212133540.3992ac0c@cakuba.netronome.com>
In-Reply-To: <bd7553cd-8784-6dfd-0b51-552b49ca8eaa@pensando.io>
References: <20191212003344.5571-1-snelson@pensando.io>
        <20191212003344.5571-3-snelson@pensando.io>
        <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
        <20191212115228.2caf0c63@cakuba.netronome.com>
        <bd7553cd-8784-6dfd-0b51-552b49ca8eaa@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 11:59:50 -0800, Shannon Nelson wrote:
> On 12/12/19 11:52 AM, Jakub Kicinski wrote:
> > On Thu, 12 Dec 2019 06:53:42 +0000, Parav Pandit wrote: =20
> >>>   static void ionic_remove(struct pci_dev *pdev)
> >>>   {
> >>>   	struct ionic *ionic =3D pci_get_drvdata(pdev);
> >>> @@ -257,6 +338,9 @@ static void ionic_remove(struct pci_dev *pdev)
> >>>   	if (!ionic)
> >>>   		return;
> >>>  =20
> >>> +	if (pci_num_vf(pdev))
> >>> +		ionic_sriov_configure(pdev, 0);
> >>> + =20
> >> Usually sriov is left enabled while removing PF.
> >> It is not the role of the pci PF removal to disable it sriov. =20
> > I don't think that's true. I consider igb and ixgbe to set the standard
> > for legacy SR-IOV handling since they were one of the first (the first?)
> > and Alex Duyck wrote them.
> >
> > mlx4, bnxt and nfp all disable SR-IOV on remove. =20
>=20
> This was my understanding as well, but now I can see that ixgbe and i40e=
=20
> are both checking for existing VFs in probe and setting up to use them,=20
> as well as the newer ice driver.=C2=A0 I found this today by looking for=
=20
> where they use pci_num_vf().

Right, if the VFs very already enabled on probe they are set up.

It's a bit of a asymmetric design, in case some other driver left
SR-IOV on, I guess.
