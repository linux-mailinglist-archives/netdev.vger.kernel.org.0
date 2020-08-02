Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BE2235A20
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 21:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgHBTOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 15:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgHBTOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 15:14:09 -0400
Received: from localhost (mobile-166-175-186-42.mycingular.net [166.175.186.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B0F206E9;
        Sun,  2 Aug 2020 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596395648;
        bh=8BmtM5Wz6njp3alR4dE4/v12QyDF8IHMxGR5An5fCEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=i/jHSvTUizuVlNBRmQdxRNPe6coho/ATL8nGKi/xOmyBYjKmz9+xWg85IsgGxSgIS
         dL1yfc+oHKYsaeZL0AE3OSX+Y10i5fuMEzdWvutU18j1LA95jrbDgF15+X0v94hhxC
         1mNVxGQqYc9cBpDxqrC9KNkOyCMbtt1kU/iMoM8s=
Date:   Sun, 2 Aug 2020 14:14:06 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Saheed Bolarinwa <refactormyself@gmail.com>, trix@redhat.com,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Joerg Roedel <joro@8bytes.org>, bjorn@helgaas.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mtd@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-hwmon@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-edac@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net
Subject: Re: [RFC PATCH 00/17] Drop uses of pci_read_config_*() return value
Message-ID: <20200802191406.GA248232@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802184648.GA23190@nazgul.tnic>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 02, 2020 at 08:46:48PM +0200, Borislav Petkov wrote:
> On Sun, Aug 02, 2020 at 07:28:00PM +0200, Saheed Bolarinwa wrote:
> > Because the value ~0 has a meaning to some drivers and only
> 
> No, ~0 means that the PCI read failed. For *every* PCI device I know.

Wait, I'm not convinced yet.  I know that if a PCI read fails, you
normally get ~0 data because the host bridge fabricates it to complete
the CPU load.

But what guarantees that a PCI config register cannot contain ~0?
If there's something about that in the spec I'd love to know where it
is because it would simplify a lot of things.

I don't think we should merge any of these patches as-is.  If we *do*
want to go this direction, we at least need some kind of macro or
function that tests for ~0 so we have a clue about what's happening
and can grep for it.

Bjorn
