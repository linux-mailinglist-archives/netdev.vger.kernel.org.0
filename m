Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FAF1B76F1
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgDXN1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:27:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60814 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgDXN1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IhuuaB8Uor4hU48nWdjvTU6FxfxyWVRlkDlBGzi6cMs=; b=xwUEiIB5mbpstFvzz/OpEGR4zO
        P63xodv4ab5MbVV9m/UHXWW7rEWw/5/ZcSFxmj9L8ED8nKpTKSVse3269RlSYb69gpO6NNHX8hnEQ
        SNzOS/Cplu3qXt0Bms2oafloekc2vsh6n0/cvqSag7hiAbpWwaEwDU3a/C91EjEJ5gPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRyLx-004Yr3-GG; Fri, 24 Apr 2020 15:26:49 +0200
Date:   Fri, 24 Apr 2020 15:26:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/9] net: ethernet backplane support
Message-ID: <20200424132649.GC1044545@lunn.ch>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 03:46:22PM +0300, Florinel Iordache wrote:
> Add support for Ethernet Backplane KR generic driver using link training
> (ieee802.3ap/ba standards), equalization algorithms (bee, fixed) and
> enable qoriq family of devices.
> This driver is dependent on uboot Backplane KR support:
> patchwork.ozlabs.org/project/uboot/list/?series=164627&state=*
> 
> v2 changes:
> * phy.rst and ABI/testing/sysfs-class-net-phydev updates with new PHY
> interface values according to Florian Fainelli feedback
> * dt bindings updates according to Rob Herring feedback: fixed errors
> occurred when running 'make dt_binding_check'
> * bpdev log changes according to feedback from Joe Perches: use %pV
> instead of an intermediate buffer and refactoring
> * reverse christmas tree updates according to David Miller feedback
> * use pr_info_once function in probe to display qoriq backplane driver
> version according to Joe's feedback
> * introduce helper function dt_serdes_type in qoriq backplane according
> to Joe's feedback
> * use standard linux defines to access AN control/status registers and
> not indirect with internal variables according to Andrew's feedback
> * dt bindings link training updates: pre-cursor, main-cursor, post-cursor
> * change display format for tx equalization using C() standard notation
> * add priv pointer in backplane_device and lane as device specific private
> extension to be used by upper layer backplane drivers
> * backplane refactoring: split backplane_phy_info struct in
> backplane_device and backplane_driver, add backplane specific ops and
> move amp_red as qoriq specific param
> * lane refactoring: split kr_lane_info struct in lane_device and lane_kr
> in order to separate lane kr specific data by generic device lane data,
> lane kr parameters unification, extension params for custom device
> specific
> * equalization refactoring: replace eq_setup_info/equalizer_info with
> equalizer_driver/equalizer_device data structures

Hi Florinel
> 
> Feedback not addressed yet:
> * general solution for PCS representation: still working to find a
> generic suitable solution, exploring alternatives, perhaps this
> should be addressed in phy generic layer

I actually think this is the most important point. It makes a big
difference to the overall structure of this code, the APIs it needs to
export. So don't expect too detailed a review until this is decided.

	Andrew
