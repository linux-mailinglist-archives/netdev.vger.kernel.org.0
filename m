Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF29210BF2
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgGANQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbgGANQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:16:30 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68539C03E97A;
        Wed,  1 Jul 2020 06:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=TzymcoRAO2UgBPJ0ZOVe0YcF3uo0oF1NDuUFLaqpiJ4=; b=m07W1h5vKC5SMjGqugevcSkZLL
        cghSRDU80En08ElqHsdloYVWrm+t5xNIDXw3uEFkYvRKBmgeSXmJBSHmntBOCX5QknNMtoBDAr7ei
        4eJ/47+c7xhbLklKkziuiyz+0amNouPoO6VrsNrv2Yuz5vYw6QKPYgtpt1Mip+w1Lwxn/L9wZ32hS
        N9Z16wQ/bg9GZxvTrdj47Xpuq6nmCOJN0Mp9aBJLE4iisjeXId4XVGHmyq3FNI1vH90P0pvWzyFXv
        2M7T/9D65rSS1Rt1mp62jWY2VZsb1xAMSm3fBPFq9ogG91g5kh4OXBxsTRvjZcKVVHlRTFP3xsDxH
        llEXk/xQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqcbD-0005v1-IE; Wed, 01 Jul 2020 13:16:27 +0000
Subject: Re: [net-next PATCH v2 2/3] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux.cj@gmail.com, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
 <20200701061233.31120-3-calvin.johnson@oss.nxp.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7f7a4876-0c80-dc54-5653-b268c685caae@infradead.org>
Date:   Wed, 1 Jul 2020 06:16:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701061233.31120-3-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/20 11:12 PM, Calvin Johnson wrote:
> Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
> provide them to be connected to MAC.
> 
> An ACPI node property "mdio-handle" is introduced to reference the
> MDIO bus on which PHYs are registered with autoprobing method used
> by mdiobus_register().
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
> Changes in v2: None
> 
>  Documentation/firmware-guide/acpi/dsd/phy.rst | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
> 
> diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
> new file mode 100644
> index 000000000000..78dcb0cacc7e
> --- /dev/null
> +++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
> @@ -0,0 +1,40 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================
> +MDIO bus and PHYs in ACPI
> +=========================
> +
> +The PHYs on a mdiobus are probed and registered using mdiobus_register().

            on an mdiobus (?)

> +Later, for connecting these PHYs to MAC, the PHYs registered on the
> +mdiobus have to be referenced.
> +
> +For each MAC node, a property "mdio-handle" is used to reference the
> +MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> +bus, use find_phy_device() to get the PHY connected to the MAC.
> +
> +
> +An example of this is show below::

                         shown

> +
> +	Scope(\_SB.MCE0.PR17) // 1G


-- 
~Randy

