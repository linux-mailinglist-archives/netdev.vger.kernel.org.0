Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921C319592C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgC0OiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:38:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgC0OiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4vL5BHC9tC2x6/2ekEAI8ZRp9HpEd17O+2m+jI61aDI=; b=fBPw7b3+lnB8otFW4ewUOD3tus
        lpFSdV0OjkPSDOqRoli10CXwobmJAKFjWzS4wUXBoTfpU+ZLIecKyJLsr7KHKUM/cR92kpUNlMB95
        P2R1bW5RquxJS+iibX57e69uM0ukZUZ5UWx93p6ZVhGcAtVpGy60fojtXhXzGOOnDoqc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHq7V-0002Lf-QV; Fri, 27 Mar 2020 15:38:01 +0100
Date:   Fri, 27 Mar 2020 15:38:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Message-ID: <20200327143801.GI11004@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 03:51:19PM +0200, Florinel Iordache wrote:
> +static void setup_supported_linkmode(struct phy_device *bpphy)
> +{
> +	struct backplane_phy_info *bp_phy = bpphy->priv;

I'm not sure it is a good idea to completely take over phydev->priv
like this, in what is just helper code. What if the PHY driver needs
memory of its own? There are a few examples of this already in other
PHY drivers. Could a KR PHY contain a temperature sensor? Could it
contain statistics counters which need accumulating?

	Andrew
