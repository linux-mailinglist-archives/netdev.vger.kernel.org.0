Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE77397BA
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfFGV1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:27:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43978 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbfFGV1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:27:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so1783760pgv.10
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 14:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5CKulcptEySxXVAWWWC3/zYcxLqGzLNBLawqYrZAtQQ=;
        b=yEkgDmH/S5FCOTqeWlzvMvcB4Iu0qKTocXcRk7qnYmRB74/Lu/odSKExpx0g1It4QI
         QvNdlub8bgI/a6WQC04XYzcgzZIM16cAhszsmtpqt7K/D3S8dcuNjYtNlltRjuFeIQpl
         bJ3NPCXG/wi37aYqG8mTSAOHM/cEY37n4B6Gh9AUjfe3W1ZWvir2h3H07IRS7wKh/dPt
         +mSALb/M7FqTlSQhlNEO/OlbcCwOpP1Nkks+1yUNM423oNEyezeTLwhXviQKNfPbieAS
         d7ZfK0Mx3aB0qyc6vMZPki0ObsMtnU7Z19Kzx8L3l4uzcMtyMKrtVpaOR4vHl5Hc+fin
         EFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5CKulcptEySxXVAWWWC3/zYcxLqGzLNBLawqYrZAtQQ=;
        b=fC3MGliLFtMIKe4bvqnmLnsiX/VtamEToE1nNvNaUSVvc5VU3BbbOb/d9bjaWX0z1h
         hHxHATNSCcQ6fUfuF10vD3IJIQWRC8hTagTLBWtgs6lDwBkoa5uSRtadWNJCl1ee/d4s
         OFuvDgbxmG+TFlcARrFcCBsejnL1LsjK3MLGSqnNoynPf2sIAvXDPuje+KwrMqFYP6Db
         xpIGSi/h7avohK/dpLx/J0g4rxNBcjSDLfikHRTUqq7MxYSJpSfuct5rqzhEhi9V9ELi
         OcxdJkxT5z66WQCatb/6bfsIA3wkonxvy+qjUh/8vRLo4vdDFCRmfu8gJXtfR3Xfvazr
         3iCg==
X-Gm-Message-State: APjAAAUFtqVCEuPDlZkwurIwHBhXs7AE80y6Ulm7Nv039Ly0nN+Tm4AX
        1NykX/JHGfa6Zpo1/jlj8VoafYXcPWE=
X-Google-Smtp-Source: APXvYqzlLZ2ipRdrS3Yu3xNe8IfkPWeDNxnQ6kM9/osm5QYicMdXoX7pdj7ZIOmnyrCO3L8Y+Lzyow==
X-Received: by 2002:a63:ee0a:: with SMTP id e10mr4841461pgi.28.1559942842402;
        Fri, 07 Jun 2019 14:27:22 -0700 (PDT)
Received: from cakuba.netronome.com (wsip-98-171-133-120.sd.sd.cox.net. [98.171.133.120])
        by smtp.gmail.com with ESMTPSA id 138sm3198986pfu.129.2019.06.07.14.27.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 14:27:21 -0700 (PDT)
Date:   Fri, 7 Jun 2019 14:27:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Bshara, Nafea" <nafea@amazon.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jubran, Samih" <sameehj@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Message-ID: <20190607142717.3ee89f12@cakuba.netronome.com>
In-Reply-To: <20190606181416.5ce1400d@cakuba.netronome.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
        <20190603143205.1d95818e@cakuba.netronome.com>
        <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
        <20190603160351.085daa91@cakuba.netronome.com>
        <20190604015043.GG17267@lunn.ch>
        <D26B5448-1E74-44E8-83DA-FC93E5520325@amazon.com>
        <af79f238465ebe069bc41924a2ae2efbcdbd6e38.camel@infradead.org>
        <20190604102406.1f426339@cakuba.netronome.com>
        <7f697af8f31f4bc7ba30ef643e7b3921@EX13D11EUB003.ant.amazon.com>
        <20190606100945.49ceb657@cakuba.netronome.com>
        <D9B372D5-1B71-4387-AA8D-E38B22B44D8D@amazon.com>
        <20190606150428.2e55eb08@cakuba.netronome.com>
        <861B5CF2-878E-4610-8671-9D66AB61ABD7@amazon.com>
        <20190606160756.73fe4c06@cakuba.netronome.com>
        <35E875B8-FAE8-4C6A-BA30-FB3E2F7BA66B@amazon.com>
        <20190606164219.10dca54e@cakuba.netronome.com>
        <9057E288-28BA-4865-B41A-5847EE41D66F@amazon.com>
        <20190606181416.5ce1400d@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 18:14:16 -0700, Jakub Kicinski wrote:
> On Fri, 7 Jun 2019 01:04:14 +0000, Bshara, Nafea wrote:
> > On Jun 6, 2019, at 4:43 PM, Jakub Kicinski wrote: =20
> > >>> Okay, then you know which one is which.  Are there multiple ENAs but
> > >>> one EFA? =20
> > >>=20
> > >> Yes,  very possible. Very common
> > >>=20
> > >> Typical use case that instances have one ena for control plane, one
> > >> for internet facing , and one 100G ena that also have efa capabiliti=
es =20
> > >=20
> > > I see, and those are PCI devices..  Some form of platform data would
> > > seem like the best fit to me.  There is something called:
> > >=20
> > > /sys/bus/pci/${dbdf}/label
> > >=20
> > > It seems to come from some ACPI table - DSM maybe?  I think you can p=
ut
> > > whatever string you want there =F0=9F=A4=94   =20
> >=20
> > Acpi path won=E2=80=99t work, much of thee interface are hot attached, =
using
> > native pcie hot plug and acpi won=E2=80=99t be involved.  =20
>=20
> Perhaps hotplug break DSM, I won't pretend to be an ACPI expert.  So you
> can find a way to stuff the label into that file from another source.
> There's also VPD, or custom PCI caps, but platform data generally seems
> like a better idea.

Jiri, do you have any thoughts about using phys_port_name for exposing
topology in virtual environments.  Perhaps that's the best fit on the
netdev side.  It's not like we want any other port name in such case,
and having it automatically appended to the netdev name may be useful.
