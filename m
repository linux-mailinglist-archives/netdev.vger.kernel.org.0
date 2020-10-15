Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C4A28F5E4
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388357AbgJOPcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbgJOPcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 11:32:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD0A422248;
        Thu, 15 Oct 2020 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602775975;
        bh=dpCemnMINpdU7ehwAmSaB541GU+21aff7h/2VJopyOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yOKhqP7xSFtpZ1zrHWfUBADgRZwU6IF6K23/nYSFeibxGm1K6rKXpNFND70OK6Xn/
         rbMMGmjhV04BLyboKMPVFdRzabID3dKbtfh85GPK1cKxF70LVgcXaiHfCo5dcC5jsR
         qPpXshCC/SGH3OeZ3AH4l/mLT3B09DimGdVZjbgA=
Date:   Thu, 15 Oct 2020 08:32:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        rsaladi2@marvell.com, Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 06/10] octeontx2-af: Add NIX1 interfaces to NPC
Message-ID: <20201015083251.10bc1aaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZupwJOZssMhE6Q_0VSCZ06WB2Sgo_BMpf2n=o7MALe+V6g@mail.gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
        <1602584792-22274-7-git-send-email-sundeep.lkml@gmail.com>
        <20201014194804.1e3b57ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupwJOZssMhE6Q_0VSCZ06WB2Sgo_BMpf2n=o7MALe+V6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 17:53:07 +0530 sundeep subbaraya wrote:
> Hi Jakub,
> 
> On Thu, Oct 15, 2020 at 8:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 13 Oct 2020 15:56:28 +0530 sundeep.lkml@gmail.com wrote:  
> > > -static const struct npc_mcam_kex npc_mkex_default = {
> > > +static struct npc_mcam_kex npc_mkex_default = {
> > >       .mkex_sign = MKEX_SIGN,
> > >       .name = "default",
> > >       .kpu_version = NPC_KPU_PROFILE_VER,  
> >
> > Why is this no longer constant? Are you modifying global data based
> > on the HW discovered in the system?  
> 
> Yes. Due to an errata present on earlier silicons
> npc_mkex_default.keyx_cfg[NIX_INTF_TX]
> and npc_mkex_default.keyx_cfg[NIX_INTF_RX] needs to be identical.

Does this run on the SoC? Is there no possibility that the same kernel
will have to drive two different pieces of hardware?
