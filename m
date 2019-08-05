Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EFF81F82
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfHEOvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:51:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34316 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbfHEOvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xGBt9uPaaUhBa3DfLuwF1wIJm3KlhenxI8dM/AWbh3Q=; b=UlH081iED8X4kH/81ySUZUvhty
        euIrqe4L9wZ2s1KjkDxWyyZFBvfkBWZsgPNWX8oZmo30rcoApbaptSB47m+qp4AtDOQP6c+7jQ2it
        qezmVr2emfPUZ8Zh5CD9Hhp3INRAV36dmN7f5h1OLBymj0WEoSx0BNHKcU4NDby7YmNg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hueKH-0007bZ-HD; Mon, 05 Aug 2019 16:51:05 +0200
Date:   Mon, 5 Aug 2019 16:51:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 06/16] net: phy: adin: support PHY mode converters
Message-ID: <20190805145105.GN24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-7-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-7-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:43PM +0300, Alexandru Ardelean wrote:
> Sometimes, the connection between a MAC and PHY is done via a
> mode/interface converter. An example is a GMII-to-RGMII converter, which
> would mean that the MAC operates in GMII mode while the PHY operates in
> RGMII. In this case there is a discrepancy between what the MAC expects &
> what the PHY expects and both need to be configured in their respective
> modes.
> 
> Sometimes, this converter is specified via a board/system configuration (in
> the device-tree for example). But, other times it can be left unspecified.
> The use of these converters is common in boards that have FPGA on them.
> 
> This patch also adds support for a `adi,phy-mode-internal` property that
> can be used in these (implicit convert) cases. The internal PHY mode will
> be used to specify the correct register settings for the PHY.
> 
> `fwnode_handle` is used, since this property may be specified via ACPI as
> well in other setups, but testing has been done in DT context.

Looking at the patch, you seems to assume phy-mode is what the MAC is
using? That seems rather odd, given the name. It seems like a better
solution would be to add a mac-mode, which the MAC uses to configure
its side of the link. The MAC driver would then implement this
property.

I don't see a need for this. phy-mode indicates what the PHY should
use. End of story.

     Andrew
