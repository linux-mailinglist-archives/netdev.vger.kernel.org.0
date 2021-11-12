Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECB044DFE8
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhKLBtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhKLBtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 20:49:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB5060F94;
        Fri, 12 Nov 2021 01:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636681616;
        bh=5aW4+ULRFBb8KEf0hwe2BA1rQMqSqqJAvuU8Wm2H1vQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hUw7PcSEd7Xslz0bH7qny/EW+RdY2tila+rkBNpfkPMK/Y++qidXBy+rhGy9uF7UB
         iwO9aVI0WuOLxlBTsBEmtv4/lPiFATaUrQNZtL6Cy8qG6TxpfcC3O8u2Ttrlu90fXs
         7ZPu8bAM2+V7Pkvhkc+xalN1ORr9LkRtGHFprGLYgnGftiDB5CUDxgBbI7L3zeTNkL
         u/DyXKoJvQOh9O/uJHBpYP74F1V7A0+fImbHNIrTqxc/lmO/yaKTq1Y288E1ZEOWcZ
         Q0u7NS/wCS4rTYtOEBP7WOK/HaRMx4coDiztGBes4I9lcz4WDlO0qVjIzjyQGk1/0E
         cz8r8zTnK2tVg==
Date:   Thu, 11 Nov 2021 17:46:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: 32bit x86 build broken (was: Re: [GIT PULL] Networking for
 5.16-rc1)
Message-ID: <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
References: <20211111163301.1930617-1-kuba@kernel.org>
        <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 23:09:07 +0000 pr-tracker-bot@kernel.org wrote:
> The pull request you sent on Thu, 11 Nov 2021 08:33:01 -0800:
>=20
> > git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5=
.16-rc1 =20
>=20
> has been merged into torvalds/linux.git:
> https://git.kernel.org/torvalds/c/f54ca91fe6f25c2028f953ce82f19ca2ea0f07bb

Rafael, Srinivas, we're getting 32 bit build failures after pulling back
from Linus today.

make[1]: *** [/home/nipa/net/Makefile:1850: drivers] Error 2
make: *** [Makefile:219: __sub-make] Error 2
../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c: In funct=
ion =E2=80=98send_mbox_cmd=E2=80=99:
../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:79:37: er=
ror: implicit declaration of function =E2=80=98readq=E2=80=99; did you mean=
 =E2=80=98readl=E2=80=99? [-Werror=3Dimplicit-function-declaration]
   79 |                         *cmd_resp =3D readq((void __iomem *) (proc_=
priv->mmio_base + MBOX_OFFSET_DATA));
      |                                     ^~~~~
      |                                     readl

Is there an ETA on getting this fixed?


