Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBF1263693
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 21:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIITYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 15:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgIITYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 15:24:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B37921D6C;
        Wed,  9 Sep 2020 19:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599679459;
        bh=nlWFWCSnvtY0mLZZMeSCfQTCzDo6swiuvKmc7yHCNKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sGernz+e3OSlmlp0EJtUXxym+NlLEqgNzI10OLNLp31q+b3OgL4LqM5V8dv4evoNc
         FY25iTbxowqkMImgPoJoCtfKBtBRWjwf50b+NxM+QYHy3QiDfK//UdeV35yNangfrx
         7PSTyufqVpLbiBvFYXKPTuI1VvBd6Rk9f05cy/aY=
Date:   Wed, 9 Sep 2020 12:24:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC v3 01/14] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200909122417.49b637eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b0550422-83a4-4e97-46e3-cb5f431a6dd7@nvidia.com>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
        <1598801254-27764-2-git-send-email-moshe@mellanox.com>
        <20200831121501.GD3794@nanopsycho.orion>
        <9fffbe80-9a2a-33de-2e11-24be34648686@nvidia.com>
        <20200902094627.GB2568@nanopsycho>
        <20200902083025.43407d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200903055729.GB2997@nanopsycho.orion>
        <20200903124719.75325f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200904090450.GH2997@nanopsycho.orion>
        <20200904125647.799e66e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6bd0fa45-68ce-b82d-98e6-327c6cd50e80@nvidia.com>
        <20200907105850.34726158@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b0550422-83a4-4e97-46e3-cb5f431a6dd7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 16:27:19 +0300 Moshe Shemesh wrote:
> On 9/7/2020 8:58 PM, Jakub Kicinski wrote:
> > On Mon, 7 Sep 2020 16:46:01 +0300 Moshe Shemesh wrote: =20
> >>> In that sense I don't like --live because it doesn't really say much.
> >>> AFAIU it means 1) no link flap; 2) < 2 sec datapath downtime; 3) no
> >>> configuration is lost in kernel or device (including netdev config,
> >>> link config, flow rules, counters etc.). I was hoping at least the
> >>> documentation in patch 14 would be more precise. =20
> >> Actually, while writing "no-reset" or "live-patching" I meant also no
> >> downtime at all and nothing resets (config, rules ... anything), that
> >> fits mlx5 live-patching.
> >>
> >> However, to make it more generic,  I can allow few seconds downtime and
> >> add similar constrains as you mentioned here to "no-reset". I will add
> >> that to the documentation patch. =20
> > Oh! If your device supports no downtime and packet loss at all that's
> > great. You don't have to weaken the definition now, whoever needs a
> > weaker definition can add a different constraint level later, no? =20
>=20
> Yes, but if we are thinking there will be more levels, maybe the flag=20
> "--live" or "--no_reset" is less extendable, we may need new attr. I=20
> mean should I have uAPI command line like:
>=20
> $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action {=20
> driver_reinit | fw_activate } [ limit_level=C2=A0 no_reset ] ]

That LGTM, thanks.
