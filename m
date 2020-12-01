Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B562C94BC
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgLABfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729876AbgLABfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:35:13 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36F81206F9;
        Tue,  1 Dec 2020 01:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606786472;
        bh=YWkMbuA/BULRJ57CNbiov3qWFAb50COHW2yGh8fMToE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1WawQ+071kJWsO+F49DVfTQTA1X1E/m8NPwWkgcb6IGyrIAyU+5xVFV34vQqEIEQr
         y0/XgAreler51dJPAbpqSInmBXje+CAB6kPhs1ogjFNydCEJ6LThct/RrM9+EqP16i
         S1kR5KRu0fWTPSJBH1LErbPFievYnaWhOQuljo34=
Date:   Mon, 30 Nov 2020 17:34:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Camelia Groza <camelia.groza@nxp.com>, brouer@redhat.com,
        saeed@kernel.org, davem@davemloft.net, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/7] dpaa_eth: add XDP support
Message-ID: <20201130173431.3144fb85@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201128225957.GA45349@ranger.igk.intel.com>
References: <cover.1606322126.git.camelia.groza@nxp.com>
        <20201128225957.GA45349@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 23:59:57 +0100 Maciej Fijalkowski wrote:
> On Wed, Nov 25, 2020 at 06:53:29PM +0200, Camelia Groza wrote:
> > Enable XDP support for the QorIQ DPAA1 platforms.
> > 
> > Implement all the current actions (DROP, ABORTED, PASS, TX, REDIRECT). No
> > Tx batching is added at this time.
> > 
> > Additional XDP_PACKET_HEADROOM bytes are reserved in each frame's headroom.
> > 
> > After transmit, a reference to the xdp_frame is saved in the buffer for
> > clean-up on confirmation in a newly created structure for software
> > annotations. DPAA_TX_PRIV_DATA_SIZE bytes are reserved in the buffer for
> > storing this structure and the XDP program is restricted from accessing
> > them.
> > 
> > The driver shares the egress frame queues used for XDP with the network
> > stack. The DPAA driver is a LLTX driver so no explicit locking is required
> > on transmission.
> > 
> > Changes in v2:
> > - warn only once if extracting the timestamp from a received frame fails
> >   in 2/7
> > 
> > Changes in v3:
> > - drop received S/G frames when XDP is enabled in 2/7
> > 
> > Changes in v4:
> > - report a warning if the MTU is too hight for running XDP in 2/7
> > - report an error if opening the device fails in the XDP setup in 2/7
> > - call xdp_rxq_info_is_reg() before unregistering in 4/7
> > - minor cleanups (remove unneeded variable, print error code) in 4/7
> > - add more details in the commit message in 4/7
> > - did not call qman_destroy_fq() in case of xdp_rxq_info_reg() failure
> > since it would lead to a double free of the fq resources in 4/7
> > 
> > Changes in v5:
> > - report errors on XDP setup with extack in 2/7
> > - checkpath fix in 4/7
> > - add more details in the commit message in 4/7
> > - reduce the impact of the A050385 erratum workaround code on non-erratum
> > platforms in 7/7  
> 
> For the series:
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Applied, thanks!
