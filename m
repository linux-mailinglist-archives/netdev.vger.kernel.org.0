Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769543DF71B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhHCVvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhHCVvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:51:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E780C603E7;
        Tue,  3 Aug 2021 21:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628027485;
        bh=Unj5EunJ8A3Xk+wAxY86IYHefC4zVn+7nFtpAcbkyW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SYwiOmSyaAU7+7N4M1Rq168qDALgambEyPPDslPDiCkVpplo/wpFNP+GugoMEFGhQ
         izADxbuy6lkg0W7G3gIF/xCxX1bqOrZMkREDDvQk8XVNt7C7z5l1YTU3WTZe1+TE9r
         0UKgo+g7mY+XdNTLJx2p8aaIntY50VMIXaxmoK7YKq6lqjYf/3rbW1NDKgA+l6OJuM
         MyEgdxPCuxWc9Xhp396vVDzYCuZNaKS38ZaQ+APwHQtLZJIcTgk9spQ2rzuuZzKgjW
         GqaIppvftIeohRw7/nYHMJHrDNetscEjjZMpTwBqheQoCo0YWau6OJTzmVv2LqPA4e
         VT1Z5+t9g5bIw==
Date:   Tue, 3 Aug 2021 14:51:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
Message-ID: <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com>
References: <20210803123921.2374485-1-kuba@kernel.org>
        <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
        <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Aug 2021 14:32:19 -0700 Cong Wang wrote:
> On Tue, Aug 3, 2021 at 2:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 3 Aug 2021 10:11:13 -0700 Cong Wang wrote: =20
> > > On Tue, Aug 3, 2021 at 5:39 AM Jakub Kicinski <kuba@kernel.org> wrote=
: =20
> > > Since when netdevsim is *only* for upstream tests? =20
> >
> > Since it was created. =20
>=20
> Why it was created only for upstream? IOW, what's wrong with
> using it only for non-upstream tests?
>=20
> BTW, we also use dummy device for testing, it is not only for
> upstream. It is extremely odd to single netdevsim out. I don't
> see any special reason here.

=46rom my own experience companies which are serious about their
engineering have a lot of code dedicated to testing. I don't think
we can deal with all such code upstream.

At the same time I want to incentivize upstreaming all of the tests
which are widely applicable (i.e. not HW-specific).

Last but not least test harnesses are really weird from functional, code
lifetime and refactoring perspective. netdevsim is not expected to keep
uAPI as long as in-tree tests do no break/are updated as well.

> > > Even if so, where is this documented? And why not just point it
> > > out when reviewing it instead of silently waiting for weeks? =20
> >
> > I was AFK for the last two weeks. =20
>=20
> How about documenting it in netdev-FAQ (or literally any doc)?
> This would save everyone's time.

Fair, I'll send a patch.

> > > It is clearly not dead. We internally used it for testing sch_mq,
> > > this is clearly stated in the git log. =20
> >
> > Please contribute those tests upstream or keep any test harness
> > they require where such test are, out of tree. =20
>=20
> Peilin will add tc-testing for sch_mq which requires this netdevsim
> feature.
>=20
> > =20
> > > How did you draw such a conclusion without talking to authors? =20
> >
> > There is no upstream test using this code, and I did CC you, didn't I? =
=20
>=20
> There are downstream tests, which are mentioned in changelog.
>=20
> I am pretty sure upstream tests only cover part of the whole networking
> code, if you really want to apply the rule, a lot of code are already dea=
d.
> Once again, I don't see any reason why you only treat netdevsim different=
ly.
> ;)

I hope the first part of this response scheds some light.

> > > But this does remind me of using netdevsim for tc-testing. =20
> >
> > Please bring the code back as part of the series adding upstream tests.=
 =20
>=20
> Please remove all those not covered by upstream tests just to be fair??

I'd love to remove all test harnesses upstream which are not used by
upstream tests, sure :)
