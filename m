Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AD943D688
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhJ0W1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:27:30 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:36765 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229437AbhJ0W1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:27:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BBEA45804BA;
        Wed, 27 Oct 2021 18:25:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 18:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6HGRn5
        3Qz8T1YVH1YxLcWRyEaXBqMDadFeaNZY6cscw=; b=CE0yf1vu3vnXgTpvU9u+M2
        tbmn4BPBfzWvewddbY88GYpE5R9xjBa1JIQUlhnvDp4cUwd9xza2IOr2XWXdhwt0
        XA1pgxJCizuP4SYPqacvxn7GrxM2yZzDnvTJk2+PotBKVIdMesua9rXHVMVX9gXb
        WuLxIFRrWSL7j6vaYefZ4Gpq2gfu7WT0GnWLUOJR0Pv9XC/LDKm7CvvulUM9SNHG
        am0inuz4jg0kXMwQBD0hfIdPEOsNspmGfjiu3hYejjpXeFI3Z9/ofwYHuu34pLWm
        bZ7w2fZa0gO0JhEeAMDxPZcbXbE1n5/mSPKYVJfIp2Hz2eYAU+AKbt8WfDOybfNA
        ==
X-ME-Sender: <xms:vtF5YbCPpwRBImUGIdDHf1Tpiri6GrN1vdZOhyHx_-4-eBKV4epkGQ>
    <xme:vtF5YRhqpuSHgjM2hRlXyUh2Czh35GRFzRY-uOQcAi1TjSTTg_bP2F1OQfAARDRiv
    tEFGePPWWIBWz4>
X-ME-Received: <xmr:vtF5YWkUrXMn5ZuWoQo0hduaEp04FmP5RhCNdrqN2RD7LiSgbCm6jomnKwAK1p_exjAaDLlgxSLMEy0Qheo6CKpDjWN-3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptefhffeuhfekgedutedtvdduheegheelheefiefhleegkedtheeihfehfeeu
    geelnecuffhomhgrihhnpehprhhoohhfphhoihhnthdrtghomhenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:vtF5Ydxyt-S9DXwEEfI5gAUE2r4syrLOnSCGsJuOPRzdOkUzamqUdg>
    <xmx:vtF5YQRUYRq18s3AEbENjfxPyujeFa9UDQG4arX1dCNQh2ipyw5qRQ>
    <xmx:vtF5YQb6ghl7Mmrg_FNjkY9Bxgk0jPOk5S2kTE0cV_NKAJIdXY8KZA>
    <xmx:v9F5YVLvlJdFPSDTwZFKEEC4WU-9RwedkUDxXv6WrjyT8P9xvXr67g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 18:25:01 -0400 (EDT)
Date:   Thu, 28 Oct 2021 01:24:58 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Sunil Kovvuri Goutham <sgoutham@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        sundeep subbaraya <sundeep.lkml@gmail.com>,
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
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <YXnRup1EJaF5Gwua@shredder>
References: <1635330675-25592-1-git-send-email-sbhatta@marvell.com>
 <1635330675-25592-2-git-send-email-sbhatta@marvell.com>
 <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
 <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
 <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXmWb2PZJQhpMfrR@shredder>
 <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 06:43:00PM +0000, Sunil Kovvuri Goutham wrote:
> 
> > ________________________________
> > From: Ido Schimmel <idosch@idosch.org>
> > Sent: Wednesday, October 27, 2021 11:41 PM
> > To: Jakub Kicinski <kuba@kernel.org>
> > Cc: sundeep subbaraya <sundeep.lkml@gmail.com>; David Miller <davem@davemloft.net>; netdev@vger.kernel.org <netdev@vger.kernel.org>; Hariprasad Kelam <hkelam@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Rakesh Babu Saladi <rsaladi2@marvell.com>; Saeed Mahameed <saeed@kernel.org>; anthony.l.nguyen@intel.com <anthony.l.nguyen@intel.com>; Jesse Brandeburg <jesse.brandeburg@intel.com>; Andrew Lunn <andrew@lunn.ch>
> > Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param to init and de-init serdes
> >
> > On Wed, Oct 27, 2021 at 10:08:57AM -0700, Jakub Kicinski wrote:
> > > On Wed, 27 Oct 2021 22:13:32 +0530 sundeep subbaraya wrote:
> > > > > On Wed, 27 Oct 2021 16:01:14 +0530 Subbaraya Sundeep wrote:
> > > > > > From: Rakesh Babu <rsaladi2@marvell.com>
> > > > > >
> > > > > > The physical/SerDes link of an netdev interface is not
> > > > > > toggled on interface bring up and bring down. This is
> > > > > > because the same link is shared between PFs and its VFs.
> > > > > > This patch adds devlink param to toggle physical link so
> > > > > > that it is useful in cases where a physical link needs to
> > > > > > be re-initialized.
> > > > >
> > > > > So it's a reset? Or are there cases where user wants the link
> > > > > to stay down?
> > > >
> > > > There are cases where the user wants the link to stay down and debug.
> > > > We are adding this to help customers to debug issues wrt physical links.
> > >
> > > Intel has a similar thing, they keep adding a ethtool priv flag called
> > > "link-down-on-close" to all their drivers.
> >
> > This is the list I compiled the previous time we discussed it:
> >
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__git.kernel.org_pub_scm_linux_kernel_git_torvalds_linux.git_commit_-3Fid-3Dc3880bd159d431d06b687b0b5ab22e24e6ef0070&d=DwIBAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=q3VKxXQKiboRw_F01ggTzHuhwawxR1P9_tMCN2FODU4&m=4xGR8HuIRKUriC93QV4GmQBJ6KVwRgGZ05Syzpq2CAM&s=fvl1aLwL55CWIsG2NT5i3QsP4o_GTEsGhA6Epjz7ZAk&e=
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__git.kernel.org_pub_scm_linux_kernel_git_torvalds_linux.git_commit_-3Fid-3Dd5ec9e2ce41ac198de2ee18e0e529b7ebbc67408&d=DwIBAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=q3VKxXQKiboRw_F01ggTzHuhwawxR1P9_tMCN2FODU4&m=4xGR8HuIRKUriC93QV4GmQBJ6KVwRgGZ05Syzpq2CAM&s=kH50Qq3h75xREveyWvCUn35wXagtt4uv1QRK0wMBEdk&e=
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__git.kernel.org_pub_scm_linux_kernel_git_torvalds_linux.git_commit_-3Fid-3Dab4ab73fc1ec6dec548fa36c5e383ef5faa7b4c1&d=DwIBAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=q3VKxXQKiboRw_F01ggTzHuhwawxR1P9_tMCN2FODU4&m=4xGR8HuIRKUriC93QV4GmQBJ6KVwRgGZ05Syzpq2CAM&s=Uc3yY-5HjS7TgRBl4DPLsJ19XiHDD_PvF8hA38K4XwI&e=
> >
> > It seems that various drivers default to not shutting down the link upon
> > ndo_stop(), but some users want to override it. I hit that too as it
> > breaks ECMP (switch thinks the link is up).
> >
> > > Maybe others do this, too.  It's time we added a standard API for
> > > this.
> >
> > The new parameter sounds like a reset, but it can also be achieved by:
> >
> > # ethtool --set-priv-flags eth0 link-down-on-close on
> > # ip link set dev eth0 down
> > # ip link set dev eth0 up
> >
> > Where the first command is replaced by a more standard ethtool API.
> 
> The intention here is provide an option to the user to toggle the serdes configuration
> as and when he wants to.

But why? What is the motivation? The commit message basically says that
you are adding a param to toggle the physical link because it is useful
to toggle the physical link.

> There is no dependency with logical interface's status.

But there is and the commit message explains why you are not doing it as
part of ndo_{stop,open}(): "because the same link is shared between PFs
and its VFs"

Such constraints also apply to other drivers and you can see that in the
"link-down-on-close" private flag. I'm also aware of propriety tools to
toggle device bits which prevent the physical link from going down upon
ndo_stop().

> Having a standard API to select bringing down physical interface upon logical interface's close call
> is a good idea. But this patch is not for that.

IIUC, your default behavior is not to take the physical link down upon
ndo_stop() and now you want to toggle the link. If you have a standard
API to change the default behavior, then the commands I showed will
toggle the link, no?
