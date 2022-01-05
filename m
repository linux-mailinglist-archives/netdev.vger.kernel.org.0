Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEAC48574C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242295AbiAERdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiAERdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 12:33:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A756BC061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 09:33:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66D3CB81151
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 17:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A30C36AE3;
        Wed,  5 Jan 2022 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641403981;
        bh=Pv8mLodZyiWSV/V2wLJOLbDDT1uv44AZwuKln2pq2X0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cq0DT8oURqNElaAB0GFHiDIQU1PJ86qEYKE0h2Y7qYy1N40i9g8gTAE/+hW1aN+CG
         MhriVf+qYe70lfiIhbAE8eZClq/ftDRd2KToPtkhCvnOAPAST+6xdRzKW3QpQf22by
         m3+lmR/lh1i1sXCH5vLb1Qdzw3Qm8f7m37hXT17kfzwOgU+E3k0mJ6l5aJ/Av9yuR7
         Z6NljtpDn7Nms5K2snSkuzUvYCkx3KEBwDKoRtD+nc5UPlu4Jx9TiN/AfHYXs9nWNh
         Lm0L59WFDqtJWchiuz3KKhVId61fNLdfEma4ergO0IMrKf70wosExepo+9hoDz+GAr
         o41lgLZ4+EGhw==
Date:   Wed, 5 Jan 2022 09:32:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v4 2/8] net/fungible: Add service module for
 Fungible drivers
Message-ID: <20220105093258.0b7ac0ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOkoqZmom=Yqxq7FkF=3oBrtd+0BenZZMES3nvUxf2b3CCiyfg@mail.gmail.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
        <20220104064657.2095041-3-dmichail@fungible.com>
        <20220104180959.1291af97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOkoqZnTv_xc6oB13jdTEK65wbYzyOO1kigmMv7KsJug58bBpA@mail.gmail.com>
        <CAOkoqZmom=Yqxq7FkF=3oBrtd+0BenZZMES3nvUxf2b3CCiyfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jan 2022 22:12:35 -0800 Dimitris Michailidis wrote:
> On Tue, Jan 4, 2022 at 8:49 PM Dimitris Michailidis
> > On Tue, Jan 4, 2022 at 6:10 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > CHECK: Unnecessary parentheses around 'fdev->admin_q->rq_depth > 0'
> > > #630: FILE: drivers/net/ethernet/fungible/funcore/fun_dev.c:584:
> > > +       if (cq_count < 2 || sq_count < 2 + (fdev->admin_q->rq_depth > 0))  
> >
> > I saw this one but checkpatch misunderstands this expression.
> > There are different equivalent expressions that wouldn't have them
> > but this one needs them.  
> 
> What I wrote is probably unclear. By 'them' I meant the parentheses.

I see, perhaps it's better written as:

	if (cq_count < 2 || sq_count < 2 + !!fdev->admin_q->rq_depth)
