Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF69308387
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 03:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhA2CBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 21:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhA2CBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 21:01:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4601364DD8;
        Fri, 29 Jan 2021 02:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611885659;
        bh=p0uHFwUvCH/6f8HoOpLMSnv8kygVAGKQioPwd2Bn850=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vv79sw3oz/2XNH3HNycl0o0xiymVHSHmUYfgb9Hya162IWQmY/UwxldSg7SCNCh5+
         aD2BWxsxRsPA7MlRxUrLvbEaRyAPH8xiUwEnfGBpem0m65J5EdarVbu3Jq4TlRHI22
         d2MeOr1p3zLTtGiOs7JA20oLsuC/mw0krk6KT1oWL+8oZ7I6BWOmmsIrF24fAtEpU4
         J4TK6Dnkuy3aWbMxZwjdjltpV4VNkQyiSliBgY1MG4R//hU6+CL5XiqEsjTYhaoVZK
         r3xcOlSTqelyDZL7SDRuJFK6t8AsE3bg5zyVtlImbCEiv3X57f37ghPW6Br7AL6fUu
         oN3fxh8QVqBdw==
Date:   Thu, 28 Jan 2021 18:00:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: [PATCH net-next 1/2] net: usb: qmi_wwan: add qmap id sysfs file
 for qmimux interfaces
Message-ID: <20210128180058.3224e376@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87mtwudene.fsf@miraculix.mork.no>
References: <20210125152235.2942-1-dnlplm@gmail.com>
        <20210125152235.2942-2-dnlplm@gmail.com>
        <87wnw1f0yj.fsf@miraculix.mork.no>
        <20210126180231.75e19557@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87mtwudene.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 08:26:13 +0100 Bj=C3=B8rn Mork wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > We got two patches adding new sysfs files for QMI in close succession -
> > is there a sense of how much this interface will grow over time? =20
>=20
> The honest answer is no.
>=20
> I do not expect this interface to grow at all.  But then I didn't expect
> it to grow before the two recent additions either...  Both are results
> of feedback from the userspace developers actually using this interface.
>=20
> If I try to look into the future, then I do believe the first addition,
> the "pass_through" flag, makes further changes unnecessary.  It allows
> the "rmnet" driver to take over all the functionality related to
> qmap/qmimux.  The rmnet driver has a proper netlink interface for
> management.  This is how the design should have been from the start, and
> would have been if the "rmnet" driver had existed when we added qmap
> support to qmi_wwan.  Or if I had been aware that someone was working on
> such a driver.
>=20
> So why do we still need this last addition discussed here? Well, there
> are users of the qmi_wwan internal qmimux interface.  They should move
> to "rmnet", but this might take some time and we obviously can't remove
> the old interface in any case. But there is a design flaw in that
> interface, which makes it rather difficult to use. This last addition
> fixes that flaw.
>=20
> I'll definitely accept the judgement if you want to put your foot down
> and say that this has to stop here, and that we are better served
> without this last fix.
>=20
> > It's no secret that we prefer netlink in networking land. =20
>=20
> Yes.  But given that we have the sysfs interface for managing this
> qmimux feature, I don't see netlink as an alternative to this patch.
>=20
> The same really applies to the previous sysfs attribute, adding another
> flag to a set which is already exposed as sysfs attributes.
>=20
> The good news is that it allowed further qmimux handling to be offloaded
> to "rmnet", which does have a netlink interface.

Thanks for the explanation. I'll trust you on this one :)

I applied v2 and added the acks from v1.
