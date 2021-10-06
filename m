Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C5E42394A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbhJFIBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237577AbhJFIBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 04:01:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7268361077;
        Wed,  6 Oct 2021 07:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633507197;
        bh=/LStHJBGLNw9T51J1exKOb+eQVfpKcwAqrHoHewBHiU=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=SII5sdvcttL/J+sS2MtLSYD7QbYTIe/n7XefQLdKyIIRli1CylcQj+bjgq7GIUN1x
         2O51Kq0yLPxFzAiBdxl6pR2+UfhWiuv8jPmW7ns2gEjMA7UpX45/19cKPQlTd6O+yc
         MH9+fRyXM39PMAl7C57eMoixkuhg79BKf0sxFycHm+f0ypBZNSp56/uHBCmL3Qm/gl
         2b7xpBgI+C+cY9Ccxl+ObiNjq4wcCXkI8OPg83eehwsEgU3L7UbI+PLcv/CL1h77rY
         Slvd7aK4GZI/jNlOwRNk90wiTBYLsCZ6uLx4h7Se0Kjs4H/RdfKRdFUJh5buUrcrMC
         7RVarBpgEN6tg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YV1EO9dsVSwWW7ua@dhcp22.suse.cz>
References: <20210928125500.167943-1-atenart@kernel.org> <YV1EO9dsVSwWW7ua@dhcp22.suse.cz>
Subject: Re: [RFC PATCH net-next 0/9] Userspace spinning on net-sysfs access
From:   Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org,
        Jiri Bohac <jbohac@suse.cz>
To:     Michal Hocko <mhocko@suse.com>
Message-ID: <163350719413.4226.2526174755566600987@kwain>
Date:   Wed, 06 Oct 2021 09:59:54 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Michal Hocko (2021-10-06 08:37:47)
> On Tue 28-09-21 14:54:51, Antoine Tenart wrote:
> thanks for posting this. Coincidentally we have come across a similar
> problem as well just recently.
>=20
> > What made those syscalls to spin is the following construction (which is
> > found a lot in net sysfs and sysctl code):
> >=20
> >   if (!rtnl_trylock())
> >           return restart_syscall();
>=20
> One of our customer is using Prometeus (https://github.com/prometheus/pro=
metheus)
> for monitoring and they have noticed that running several instances of
> node-exporter can lead to a high CPU utilization. After some
> investigation it has turned out that most instances are busy looping on
> on of the sysfs files while one instance is processing sysfs speed file
> for mlx driver which performs quite a convoluted set of operations (send
> commands to the lower layers via workqueues) to talk to the device to
> get the information.
>=20
> The problem becomes more visible with more instance of node-exporter
> running at parallel. This results in some monitoring alarms at the said
> machine because the high CPU utilization is not expected.
>=20
> I would appreciate if you CC me on next versions of this patchset.

Sure, will do!

Nice to see this can help others. Any help on (extensively) testing is
welcomed :-)

Thanks,
Antoine
