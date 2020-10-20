Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8233C293909
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387481AbgJTKTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733223AbgJTKTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:19:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE24C061755;
        Tue, 20 Oct 2020 03:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9ZPtKI/+gVmDv9pNDlYR9rvIc/C7+2OLTkYM1hkB0jg=; b=MHeVr4qRbj08Q2ic+CNHre6H0
        Zc5QwHxIDyEFt627qQX7Ze7LWYp1GBgBKiJalmZFM01pevnN4pK49J4sqeL5C5Ec1w5lgsrZmplUE
        N4Tnr0jhjUwg8H0vR5m4izq/KfLp2MZbAxyu/GHhM1HKpFWMRER2EDK98VaQTXpsAGI86fGmk6xPq
        TP0mGWtXD7vCEVF7/EczvdRkmqDLJ+qnXGMgJrNwDQJGciAvy18Vg03YigVVDoHPRm6j8yw9D7bCn
        e8pcgy+yoKrsNW/p5QJ/LkpsnY0RxRLlrgrt01dE26/a0VTJGRTRom3dXAIfS8U+BhzjMNDMKacFp
        9t2zDsiAA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48622)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kUojJ-000785-Go; Tue, 20 Oct 2020 11:18:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kUojD-0005Ch-Qb; Tue, 20 Oct 2020 11:18:51 +0100
Date:   Tue, 20 Oct 2020 11:18:51 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6123/6131
Message-ID: <20201020101851.GC1551@shell.armlinux.org.uk>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-4-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020034558.19438-4-chris.packham@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 04:45:58PM +1300, Chris Packham wrote:
> +void mv88e6123_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
> +{
> +	u16 *p = _p;
> +	u16 reg;
> +	int i;
> +
> +	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
> +		return;
> +
> +	for (i = 0; i < 26; i++) {
> +		mv88e6xxx_phy_read(chip, port, i, &reg);

Shouldn't this deal with a failed read in some way, rather than just
assigning the last or possibly uninitialised value to p[i] ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
