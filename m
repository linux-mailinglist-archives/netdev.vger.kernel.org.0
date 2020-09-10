Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7AF2651C5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgIJVBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgIJOp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:45:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A2B52145D;
        Thu, 10 Sep 2020 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599749095;
        bh=gBQ2xDKC4vPI21KMyB6pz1v879PQnhxxXqax3ZiUVwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pX2AwwEn0KkQNQnuanGqPzoKnHeDR/VRoX/7xChUOcI4T/nLF7sv9t8daejt3xMOW
         Lv9qK9sDruWyQhRfs3qeuw5K7upBbdWj94RYxRS9fYJFlrpoT23iOAMdnXFw+fj4XS
         +R1mAGC8h7S6KgVPw4LQB6iCQIVgXXS9OHohBtW0=
Date:   Thu, 10 Sep 2020 07:44:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com
Subject: Re: [PATCH v2] net: Phy: Add PHY lookup support on MDIO bus in case
 of ACPI probe
Message-ID: <20200910074454.7e4b0940@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599738183-26957-1-git-send-email-vikas.singh@puresoftware.com>
References: <1599738183-26957-1-git-send-email-vikas.singh@puresoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 17:13:03 +0530 Vikas Singh wrote:
> The function referred to (of_mdiobus_link_mdiodev()) is only built when
> CONFIG_OF_MDIO is enabled, which is again, a DT specific thing, and would
> not work in case of ACPI.
> Given that it is a static function so renamed of_mdiobus_link_mdiodev()
> as mdiobus_link_mdiodev() and did necessary changes, finally moved it out
> of the #ifdef(CONFIG_OF_MDIO) therefore make it work for both DT & ACPI.
> 
> Signed-off-by: Vikas Singh <vikas.singh@puresoftware.com>

nit:

CHECK: braces {} should be used on all arms of this statement
#60: FILE: drivers/net/phy/mdio_bus.c:461:
+		if (is_of_node(child)) {
[...]
+		} else if (fwnode_property_read_u32(child, "reg", &addr))
[...]
