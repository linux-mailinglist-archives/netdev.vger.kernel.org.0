Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2915625B894
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 04:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgICCGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 22:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgICCGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 22:06:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A9820758;
        Thu,  3 Sep 2020 02:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599098812;
        bh=DHyvDkPmuj4a55kP3D5+yzCXiLND9zVO76+MZSV4Ixw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AzRik9EoxphZRlptoez9MA2s4Zq2FhgJR7/D71SVbV4IZEm3Tktn++09fLI2gRKly
         18dImPdFGfP5g6HX1eBhqdjnqf2rV+V9++1Viqk8MYjfSBJdDFG8zAmW06aGfHqnya
         PG2LbOWbssj0Wj7DXjHqQhc5xWQTu0uXnXlojzvc=
Date:   Wed, 2 Sep 2020 19:06:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/3] net: dp83869: Add speed optimization
 feature
Message-ID: <20200902190650.52c46eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200902203444.29167-4-dmurphy@ti.com>
References: <20200902203444.29167-1-dmurphy@ti.com>
        <20200902203444.29167-4-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Sep 2020 15:34:44 -0500 Dan Murphy wrote:
> Set the speed optimization bit on the DP83869 PHY.
> 
> Speed optimization, also known as link downshift, enables fallback to 100M
> operation after multiple consecutive failed attempts at Gigabit link
> establishment. Such a case could occur if cabling with only four wires
> (two twisted pairs) were connected instead of the standard cabling with
> eight wires (four twisted pairs).
> 
> The number of failed link attempts before falling back to 100M operation is
> configurable. By default, four failed link attempts are required before
> falling back to 100M.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

there seems to be lots of checkpatch warnings here:

ERROR: switch and case should be at the same indent
#111: FILE: drivers/net/phy/dp83869.c:342:
+	switch (cnt) {
+		case DP83869_DOWNSHIFT_1_COUNT:
[...]
+		case DP83869_DOWNSHIFT_2_COUNT:
[...]
+		case DP83869_DOWNSHIFT_4_COUNT:
[...]
+		case DP83869_DOWNSHIFT_8_COUNT:
[...]
+		default:

CHECK: Alignment should match open parenthesis
#139: FILE: drivers/net/phy/dp83869.c:370:
+static int dp83869_get_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, void *data)

CHECK: Alignment should match open parenthesis
#150: FILE: drivers/net/phy/dp83869.c:381:
+static int dp83869_set_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, const void *data)

WARNING: please, no spaces at the start of a line
#168: FILE: drivers/net/phy/dp83869.c:669:
+       ret = phy_modify(phydev, DP83869_CFG2, DP83869_DOWNSHIFT_EN,$

ERROR: code indent should use tabs where possible
#169: FILE: drivers/net/phy/dp83869.c:670:
+                        DP83869_DOWNSHIFT_EN);$

WARNING: please, no spaces at the start of a line
#169: FILE: drivers/net/phy/dp83869.c:670:
+                        DP83869_DOWNSHIFT_EN);$

WARNING: please, no spaces at the start of a line
#170: FILE: drivers/net/phy/dp83869.c:671:
+       if (ret)$

WARNING: suspect code indent for conditional statements (7, 15)
#170: FILE: drivers/net/phy/dp83869.c:671:
+       if (ret)
+               return ret;

ERROR: code indent should use tabs where possible
#171: FILE: drivers/net/phy/dp83869.c:672:
+               return ret;$

WARNING: please, no spaces at the start of a line
#171: FILE: drivers/net/phy/dp83869.c:672:
+               return ret;$

total: 3 errors, 5 warnings, 2 checks, 152 lines checked
