Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA743E0B1
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhJ1MUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhJ1MUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 08:20:46 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08987C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 05:18:19 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r4so23416755edi.5
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 05:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+AP5pARAzypvJLWByFrroPKKfde+X4p5mj82zuVXrck=;
        b=Q6stBm/92aOgVO/n47PhENR+5Aw6Vo7xxbxuVJFaxheLevWjTcP5SXXNQ0GaGzSw/j
         rliHMFw/gk0Wus8uRwoW2zOHouTJaVSfQzwgPdrxzICdDm7FRDyU5XhB5BmbUQ/TNr7d
         Rr1heBA8iPTk0bP4naRCbaXiVoajv1WFlmdn+o5BFkZzUW+pHdlHCcVOAbT0Fx3nsqFO
         lxsPNn1NqtxIYvbeWlgoy63SIR9dSKrCAsGLZ7CoBHxbm+LGDJVdmnHcEGw08vCiv2Q2
         Ksak9oqn/lQGWey9kxV4P/wmh7p7P3oy3GP0Q9up5gJILKqXqF/VOcQpgPLys9YBgWpz
         U3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+AP5pARAzypvJLWByFrroPKKfde+X4p5mj82zuVXrck=;
        b=PLRornKKnQO3srvkRdsl03Lq5L/FKG7taaHsVPyMqu/6ysAxsJznP8Pn03UfxstDEE
         s5rr9rBgncEp+Uo5YsjQgsHSRt7/AJQnGPbsNxckGX+uGZzA0VPVu2aP0hD4PBgQGbX6
         vaiJc17IQsEp4hHqr0JxODF1GbPRB3NBX3VhVq+bqMFig3VD3QUipPgBtz+c910LyfWA
         oYUgoHnahKL20cTFEyrPaEI1XBcLCEAB7ZjVAFkG1l83ZYIiB/BVewTWX9eh3ocSV1Y+
         XQnaRfjtYWUxMK2J8XGI65mNtTgNFzlFYR/AyfMdPHNRgKn3nSKvTH2hnyJPmkG3h3oB
         Xh3g==
X-Gm-Message-State: AOAM530BqSTVZRHI4q2lDMn7+4ohnC5Vi+kxy1SS4aePKBgfdHsnCHk0
        Z1NbR/tWT49aFNhP/KruUMJDXTUrJ3H5iskYRImwuq+P
X-Google-Smtp-Source: ABdhPJxTBABvz02o4EzZK+6v+w3CQOihpzfcdPg29AYAcKP5RMi3nOe6OeJS3hy6sIyGnkHhObzRmX9Mz9za0w27dIk=
X-Received: by 2002:a17:907:7f8b:: with SMTP id qk11mr5122270ejc.313.1635423495407;
 Thu, 28 Oct 2021 05:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
 <1635330675-25592-2-git-send-email-sbhatta@marvell.com> <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
 <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
 <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXmWb2PZJQhpMfrR@shredder> <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
 <YXnRup1EJaF5Gwua@shredder>
In-Reply-To: <YXnRup1EJaF5Gwua@shredder>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 28 Oct 2021 17:48:02 +0530
Message-ID: <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to
 init and de-init serdes
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Thu, Oct 28, 2021 at 3:55 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Wed, Oct 27, 2021 at 06:43:00PM +0000, Sunil Kovvuri Goutham wrote:
> >
> > > ________________________________
> > > From: Ido Schimmel <idosch@idosch.org>
> > > Sent: Wednesday, October 27, 2021 11:41 PM
> > > To: Jakub Kicinski <kuba@kernel.org>
> > > Cc: sundeep subbaraya <sundeep.lkml@gmail.com>; David Miller <davem@d=
avemloft.net>; netdev@vger.kernel.org <netdev@vger.kernel.org>; Hariprasad =
Kelam <hkelam@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>; Suni=
l Kovvuri Goutham <sgoutham@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta=
@marvell.com>; Rakesh Babu Saladi <rsaladi2@marvell.com>; Saeed Mahameed <s=
aeed@kernel.org>; anthony.l.nguyen@intel.com <anthony.l.nguyen@intel.com>; =
Jesse Brandeburg <jesse.brandeburg@intel.com>; Andrew Lunn <andrew@lunn.ch>
> > > Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink=
 param to init and de-init serdes
> > >
> > > On Wed, Oct 27, 2021 at 10:08:57AM -0700, Jakub Kicinski wrote:
> > > > On Wed, 27 Oct 2021 22:13:32 +0530 sundeep subbaraya wrote:
> > > > > > On Wed, 27 Oct 2021 16:01:14 +0530 Subbaraya Sundeep wrote:
> > > > > > > From: Rakesh Babu <rsaladi2@marvell.com>
> > > > > > >
> > > > > > > The physical/SerDes link of an netdev interface is not
> > > > > > > toggled on interface bring up and bring down. This is
> > > > > > > because the same link is shared between PFs and its VFs.
> > > > > > > This patch adds devlink param to toggle physical link so
> > > > > > > that it is useful in cases where a physical link needs to
> > > > > > > be re-initialized.
> > > > > >
> > > > > > So it's a reset? Or are there cases where user wants the link
> > > > > > to stay down?
> > > > >
> > > > > There are cases where the user wants the link to stay down and de=
bug.
> > > > > We are adding this to help customers to debug issues wrt physical=
 links.
> > > >
> > > > Intel has a similar thing, they keep adding a ethtool priv flag cal=
led
> > > > "link-down-on-close" to all their drivers.
> > >
> > > This is the list I compiled the previous time we discussed it:
> > >
> > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__git.kernel.org=
_pub_scm_linux_kernel_git_torvalds_linux.git_commit_-3Fid-3Dc3880bd159d431d=
06b687b0b5ab22e24e6ef0070&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3Dq3VKxXQ=
KiboRw_F01ggTzHuhwawxR1P9_tMCN2FODU4&m=3D4xGR8HuIRKUriC93QV4GmQBJ6KVwRgGZ05=
Syzpq2CAM&s=3Dfvl1aLwL55CWIsG2NT5i3QsP4o_GTEsGhA6Epjz7ZAk&e=3D
> > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__git.kernel.org=
_pub_scm_linux_kernel_git_torvalds_linux.git_commit_-3Fid-3Dd5ec9e2ce41ac19=
8de2ee18e0e529b7ebbc67408&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3Dq3VKxXQ=
KiboRw_F01ggTzHuhwawxR1P9_tMCN2FODU4&m=3D4xGR8HuIRKUriC93QV4GmQBJ6KVwRgGZ05=
Syzpq2CAM&s=3DkH50Qq3h75xREveyWvCUn35wXagtt4uv1QRK0wMBEdk&e=3D
> > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__git.kernel.org=
_pub_scm_linux_kernel_git_torvalds_linux.git_commit_-3Fid-3Dab4ab73fc1ec6de=
c548fa36c5e383ef5faa7b4c1&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3Dq3VKxXQ=
KiboRw_F01ggTzHuhwawxR1P9_tMCN2FODU4&m=3D4xGR8HuIRKUriC93QV4GmQBJ6KVwRgGZ05=
Syzpq2CAM&s=3DUc3yY-5HjS7TgRBl4DPLsJ19XiHDD_PvF8hA38K4XwI&e=3D
> > >
> > > It seems that various drivers default to not shutting down the link u=
pon
> > > ndo_stop(), but some users want to override it. I hit that too as it
> > > breaks ECMP (switch thinks the link is up).
> > >
> > > > Maybe others do this, too.  It's time we added a standard API for
> > > > this.
> > >
> > > The new parameter sounds like a reset, but it can also be achieved by=
:
> > >
> > > # ethtool --set-priv-flags eth0 link-down-on-close on
> > > # ip link set dev eth0 down
> > > # ip link set dev eth0 up
> > >
> > > Where the first command is replaced by a more standard ethtool API.
> >
> > The intention here is provide an option to the user to toggle the serde=
s configuration
> > as and when he wants to.
>
> But why? What is the motivation? The commit message basically says that
> you are adding a param to toggle the physical link because it is useful
> to toggle the physical link.
>
> > There is no dependency with logical interface's status.
>
> But there is and the commit message explains why you are not doing it as
> part of ndo_{stop,open}(): "because the same link is shared between PFs
> and its VFs"
>
> Such constraints also apply to other drivers and you can see that in the
> "link-down-on-close" private flag. I'm also aware of propriety tools to
> toggle device bits which prevent the physical link from going down upon
> ndo_stop().
>
> > Having a standard API to select bringing down physical interface upon l=
ogical interface's close call
> > is a good idea. But this patch is not for that.
>
> IIUC, your default behavior is not to take the physical link down upon
> ndo_stop() and now you want to toggle the link. If you have a standard
> API to change the default behavior, then the commands I showed will
> toggle the link, no?

Actually we also need a case where debugging is required when the
logical link is
up (so that packets flow from kernel to SerDes continuously) but the
physical link
is down. We will change the commit description since it is giving the
wrong impression.
A command to change physical link up/down with no relation to ifconfig
is needed.

Thanks,
Sundeep
