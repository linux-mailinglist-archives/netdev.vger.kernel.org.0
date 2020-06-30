Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0F20F2AD
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbgF3K1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732315AbgF3K1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:27:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295C5C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=z50RgeQqrjHvUYrHYr80pPuodaN2bTfUFcYbMLvVm6g=; b=i/MNYCfvsGV8SSfST9Nk5JHF/
        lDNRNBF4MxjRIZMUv2daf2uw0BeFbGH8x994CUyxlOP5z6j9zl5YVMh2ZAgUcojIWZ49VrnWsMzOj
        /cBU9JHVGhijqQRFeSTPyMwX8ZvhTJjW5CvjigxzWVKLVd8cWDpW9eUifkw/ZS/PhXavbhEBZ65EB
        pbkS+6kiEphxvVLIpaBcjm8j1TagtlWRWf/ugspFnOT81hOFfonLcAGl9cRAPPzgagr8oedSS97A2
        tERa2OyftF2ol/VEm4G6kVOEb3e4jVCdgh82Pt0jxT76tzDLcqJEqNIg5LSBoYJt47woBfEqOwF0P
        WB3Exi90Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33492)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqDUV-0000PJ-Ii; Tue, 30 Jun 2020 11:27:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqDUV-00086O-A8; Tue, 30 Jun 2020 11:27:51 +0100
Date:   Tue, 30 Jun 2020 11:27:51 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/3] Convert Broadcom SF2 to mac_link_up() resolved
 state
Message-ID: <20200630102751.GA1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert Broadcom SF2 DSA support to use the newly provided resolved
link state via mac_link_up() rather than using the state in
mac_config().

 drivers/net/dsa/bcm_sf2.c | 90 +++++++++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 34 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
