Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5E72DE8AB
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 19:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgLRSDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 13:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgLRSDh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 13:03:37 -0500
Date:   Fri, 18 Dec 2020 10:02:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608314576;
        bh=tVMIMe7WsSbTcqQ8MNZT+TrXrQshMzmtjK9H/0dP+to=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=nndPbkPvCJHTu+2Ut63KYbtM6dzoZIbwV5ahCforTiIKaT8OZs9FGvDiqvGt1rw3b
         BHJNx3LM0xtu8WbFgyEyfvuJD3ohGCDod3F8Z9pfxBr/OgCZY3zF/S3DQyiNQqq2H3
         jpEp/HFdSNKhxA77iLiR1zurnRdySVZ9RPGKkU38o0VrhoZJEKBfNXVFY5VY6cZ3MH
         hDcKtc5MBGJAjsokUEm8ShcD7ACxSg6P4Kvsf9VytwYZ2W3Yj/0B7c771ElK4TvrTU
         9l9h55bWGzjCIicp/yzjL7VOUDb6lEmebLGCiVPNuPxSGU3egRhXm4HQWWtJkdTDMP
         uURc6PrV7i6OQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Rix <trix@redhat.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: ambassador: remove h from printk format specifier
Message-ID: <20201218100250.60196dec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ae7d363b-99ec-d75f-bae3-add3ee4789bd@redhat.com>
References: <20201215142228.1847161-1-trix@redhat.com>
        <20201216164510.770454d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6ada03ed-1ecb-493b-96f8-5f9548a46a5e@redhat.com>
        <20201217092816.7b739b8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ae7d363b-99ec-d75f-bae3-add3ee4789bd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 14:03:07 -0800 Tom Rix wrote:
> On 12/17/20 9:28 AM, Jakub Kicinski wrote:
> > On Thu, 17 Dec 2020 05:17:24 -0800 Tom Rix wrote: =20
> >> On 12/16/20 4:45 PM, Jakub Kicinski wrote: =20
> >>> On Tue, 15 Dec 2020 06:22:28 -0800 trix@redhat.com wrote:   =20
> >>>> From: Tom Rix <trix@redhat.com>
> >>>>
> >>>> See Documentation/core-api/printk-formats.rst.
> >>>> h should no longer be used in the format specifier for printk.
> >>>>
> >>>> Signed-off-by: Tom Rix <trix@redhat.com>   =20
> >>> That's for new code I assume?
> >>>
> >>> What's the harm in leaving this ancient code be?   =20
> >> This change is part of a tree wide cleanup. =20
> > What's the purpose of the "clean up"? Why is it making the code better?
> >
> > This is a quote from your change:
> >
> > -  PRINTK (KERN_NOTICE, "debug bitmap is %hx", debug &=3D DBG_MASK);
> > +  PRINTK (KERN_NOTICE, "debug bitmap is %x", debug &=3D DBG_MASK);
> >
> > Are you sure that the use of %hx is the worst part of that line? =20
>=20
> In this case, it means this bit of code is compliant with the %h checker =
in checkpatch.
>=20
> why you are seeing this change for %hx and not the horrible debug &=3D or=
 the old PRINTK macro is because the change was mechanical.
>=20
> leveraging the clang build and a special fixit for %h, an allyesconfig fo=
r x86_64 cleans this problem from most of the tree in about an hour.=C2=A0 =
atm/ was just one of the places it hit, there are about 100 more.
>=20
> If you want the debug &=3D fixed, i can do that.

No, the opposite of that. I would like to see fewer patches touching
prehistoric code for little to no gain :(

> The macro is a treewide problem and i can add that to the treewide cleanu=
ps i am planning.
