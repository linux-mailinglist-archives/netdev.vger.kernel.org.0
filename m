Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6946733BB0
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfFCXEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:04:00 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45914 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFCXD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:03:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so1592076qkj.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 16:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3wD4XKnC52ChQXnah5Wm6NhkKkuhVyeo/CSAIpyAe2Y=;
        b=cgnK0g8hWS0U80Iv/CjHU7icJavaiF219Wf9YwAFjiE0xz6bXoMqwGLsc4LU88D6rC
         k8p2qwsWvixeFUbcMiMDmYrbhZ/p+jp4gslY9j+auLC50B1Z06/L3oMPBprJAD3QV0ZX
         mZP4sQvtRwfAAt9YfMVxfkueWYjP9GsXADOCPOZXdkT6eJG+Vp0Ez0f3xafhoOgbf2RS
         0GwZdKyDGGo98iJTlbGgD+tqXY+keIXk2ZfQdBLO5yPZkcgZO2OAjXPdc8mWT95x/uvq
         crjINVUJi+NQnBAJ6I8KYXc1JZaWOgx+zmEYUAcEc+g+FVt//l3FpXRQSljFSZIbGE+p
         zxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3wD4XKnC52ChQXnah5Wm6NhkKkuhVyeo/CSAIpyAe2Y=;
        b=EkI0RiZ4wL120ShNUa9HyK510qZhMXIUz7eV+nbiIDU6XtueacXVTMUGIhNRdgrfw+
         iUBATG125wELWjnj8akjgv0LStJq4xRyUnR0psB2cerWOWYDSfmvzUEUn63FU3ycaR7P
         DrpYdMKKtFJ2p+t0w6JB3BieiX/BsDhYGOXN2j0YEeTE4LCIvagmiggtVzFHoncHfBhF
         GoXXrGPhCDnwe0NefVJuVNR1bXwHyaUdvWJ2Ke0LClhAHNEIPFCnQfu2rh4Fll6MWYMp
         gy9YqDhjE8M78qUwZpoKtb9OFS4wq6b0vy1KFIm7ir3SQG/fbxBMYTeNvyl4lBCZujZR
         F8hA==
X-Gm-Message-State: APjAAAW7SODypuB2814L9wxsAqtuEUxEHT4OXJAo+wLdwTlpaqY+XxAL
        t+2tRg9GiQa4w3+EF+VNQY1mfg==
X-Google-Smtp-Source: APXvYqw/jRIJJaEZ8T5A8VbeNrRx5fPx0YeMHTCocz96uioJWVQfv6/T5nvHS2lNMN4xwnxIZNTc1Q==
X-Received: by 2002:a37:49c2:: with SMTP id w185mr17101654qka.156.1559603037926;
        Mon, 03 Jun 2019 16:03:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j9sm7668554qkg.30.2019.06.03.16.03.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 03 Jun 2019 16:03:57 -0700 (PDT)
Date:   Mon, 3 Jun 2019 16:03:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Woodhouse, David" <dwmw@amazon.co.uk>
Cc:     "Jubran, Samih" <sameehj@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Message-ID: <20190603160351.085daa91@cakuba.netronome.com>
In-Reply-To: <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
References: <20190603144329.16366-1-sameehj@amazon.com>
        <20190603143205.1d95818e@cakuba.netronome.com>
        <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 22:27:28 +0000, Woodhouse, David wrote:
> On Mon, 2019-06-03 at 14:32 -0700, Jakub Kicinski wrote:
> > On Mon, 3 Jun 2019 17:43:18 +0300, sameehj@amazon.com wrote: =20
> > > * net: ena: ethtool: add extra properties retrieval via get_priv_flag=
s (2/11):
> > >   * replaced snprintf with strlcpy
> > >   * dropped confusing error message
> > >   * added more details to  the commit message =20
> >=20
> > I asked you to clearly state that you are using the blindly passing
> > this info from the FW to user space.  Stating that you "retrieve" it
> > is misleading. =20
>=20
> Yes, we should be very clear about that.
>=20
> > IMHO it's a dangerous precedent, you're extending kernel's uAPI down to
> > the proprietary FW of the device.  Now we have no idea what the flags
> > are, so we can't refactor and create common APIs among drivers, or even
> > use the same names.  We have no idea what you're exposing. =20
>=20
> Yes, that should be documented very clearly too, and we should
> absolutely make sure that anything that makes sense for other devices
> is considered for making a common API.
>=20
> However, the deployment environment for ENA is kind of weird =E2=80=94 we=
 get
> to upgrade the *firmware*, while guest kernels might get updated only
> once a decade. So the passthrough you're objecting to, actually gives
> us fairly much the only viable way to offer many users the tuning
> options they need =E2=80=94 or at least to experiment and establish wheth=
er
> they *do* need them or not, and thus if we should turn them into a
> "real" generic property.
>=20
> You do have a valid concern, but I think we can handle it, and I
> suspect that the approach taken here does make sense. Let's just make
> it explicitly clear, and also document the properties that we expect to
> be exposing, for visibility.

Thank you.

It's generally easier to push FW updates, also to enterprises, rather
than rolling out full new kernels.  People are less concerned with FW
updates, because the only thing those can break is the NIC.  Some
customers also run their own modified kernels.  I'd dispute the fact
that Amazon is so very special.

I don't dispute that this is convenient for Amazon and your FW team.
However, what's best for the vendors differs here from what's good for
Open Source (the FW is proprietary) and IMHO health of Linux ecosystem
in general.

Any "SmartNIC" vendor has temptation of uAPI-level hand off to the
firmware (including my employer), we all run pretty beefy processors
inside "the NIC" after all.  The device centric ethtool configuration
can be implemented by just forwarding the uAPI structures as they are
to the FW.  I'm sure Andrew and others who would like to see Linux
takes more control over PHYs etc. would not like this scenario, either.

To address your specific points, let's be realistic, after initial
submission it's unlikely the features will be updated in a timely
manner anywhere else than perhaps some Amazon's own docs.  Can you
be more specific on what those tuning options are today?  There are
users who don't care to update their kernels for 10 years, yet they
care about some minor tuning option of the NIC?
