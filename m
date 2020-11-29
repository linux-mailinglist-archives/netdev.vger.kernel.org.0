Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FB32C7A20
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 17:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgK2Q5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 11:57:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgK2Q5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 11:57:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjPzv-009NGP-PM; Sun, 29 Nov 2020 17:56:27 +0100
Date:   Sun, 29 Nov 2020 17:56:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jean Pihet <jean.pihet@newoldbits.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Subject: Re: [PATCH 1/2] net: dsa: ksz: pad frame to 64 bytes for transmission
Message-ID: <20201129165627.GA2234159@lunn.ch>
References: <20201129102400.157786-1-jean.pihet@newoldbits.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201129102400.157786-1-jean.pihet@newoldbits.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 11:23:59AM +0100, Jean Pihet wrote:
> Some ethernet controllers (e.g. TI CPSW) pad the frames to a minimum
> of 64 bytes before the FCS is appended. This causes an issue with the
> KSZ tail tag which could not be the last byte before the FCS.
> Solve this by padding the frame to 64 bytes minus the tail tag size,
> before the tail tag is added and the frame is passed for transmission.

Hi Jean

what tree is this based on? Have you seen

commit 88fda8eefd9a7a7175bf4dad1d02cc0840581111
Author: Christian Eggers <ceggers@arri.de>
Date:   Sun Nov 1 21:16:10 2020 +0200

    net: dsa: tag_ksz: don't allocate additional memory for padding/tagging
    
    The caller (dsa_slave_xmit) guarantees that the frame length is at least
    ETH_ZLEN and that enough memory for tail tagging is available.

