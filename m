Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84AD1FF7D6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgFRPqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgFRPqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 11:46:16 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B7F206FA;
        Thu, 18 Jun 2020 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592495176;
        bh=DT0upM96HqMPQgMBB/CBDR/hHIvxmmHmwQeiDFEQokc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GXcSUll+dNeAUO+jNzYafwo2c1CS45mcRu+sfDjFtuinyWXojtby8XnVdiQuOFZdg
         RYDNGhBa+rLBC36+h5uwX37Aivz4t88QB741IQtelI03Wm6iydkR7tLBqwBjPa/ohF
         DDEKzE4l6Oa1sgDyJ/doI5lqsYp64jp+u15+y1x8=
Date:   Thu, 18 Jun 2020 08:46:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 3/9] net: dsa: hellcreek: Add PTP clock support
Message-ID: <20200618084614.7ef6b35c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618064029.32168-4-kurt@linutronix.de>
References: <20200618064029.32168-1-kurt@linutronix.de>
        <20200618064029.32168-4-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 08:40:23 +0200 Kurt Kanzenbach wrote:
> From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>=20
> The switch has internal PTP hardware clocks. Add support for it. There ar=
e three
> clocks:
>=20
>  * Synchronized
>  * Syntonized
>  * Free running
>=20
> Currently the synchronized clock is exported to user space which is a good
> default for the beginning. The free running clock might be exported later
> e.g. for implementing 802.1AS-2011/2020 Time Aware Bridges (TAB). The swi=
tch
> also supports cross time stamping for that purpose.
>=20
> The implementation adds support setting/getting the time as well as offse=
t and
> frequency adjustments. However, the clock only holds a partial timeofday
> timestamp. This is why we track the seconds completely in software (see o=
verflow
> work and last_ts).
>=20
> Furthermore, add the PTP multicast addresses into the FDB to forward that
> packages only to the CPU port where they are processed by a PTP program.
>=20
> Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Please make sure each patch in the series builds cleanly with the W=3D1
C=3D1 flags. Here we have:

../drivers/net/dsa/hirschmann/hellcreek_ptp.c: In function =C3=A2=E2=82=AC=
=CB=9C__hellcreek_ptp_clock_read=C3=A2=E2=82=AC=E2=84=A2:
../drivers/net/dsa/hirschmann/hellcreek_ptp.c:30:28: warning: variable =C3=
=A2=E2=82=AC=CB=9Csech=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-b=
ut-set-variable]
   30 |  u16 nsl, nsh, secl, secm, sech;
      |                            ^~~~
../drivers/net/dsa/hirschmann/hellcreek_ptp.c:30:22: warning: variable =C3=
=A2=E2=82=AC=CB=9Csecm=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-b=
ut-set-variable]
   30 |  u16 nsl, nsh, secl, secm, sech;
      |                      ^~~~
../drivers/net/dsa/hirschmann/hellcreek_ptp.c:30:16: warning: variable =C3=
=A2=E2=82=AC=CB=9Csecl=C3=A2=E2=82=AC=E2=84=A2 set but not used [-Wunused-b=
ut-set-variable]
   30 |  u16 nsl, nsh, secl, secm, sech;
      |                ^~~~

Next patch adds a few more.
