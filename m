Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8E31FF7D4
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgFRPqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:46:14 -0400
Received: from foss.arm.com ([217.140.110.172]:53214 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgFRPqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 11:46:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED3A5101E;
        Thu, 18 Jun 2020 08:46:12 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34CF43F6CF;
        Thu, 18 Jun 2020 08:46:12 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
To:     Andrew Lunn <andrew@lunn.ch>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
 <20200617173414.GI205574@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <a1ae8926-9082-74ca-298a-853d297c84e7@arm.com>
Date:   Thu, 18 Jun 2020 10:43:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617173414.GI205574@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 6/17/20 12:34 PM, Andrew Lunn wrote:
> On Wed, Jun 17, 2020 at 10:45:34PM +0530, Calvin Johnson wrote:
>> From: Jeremy Linton <jeremy.linton@arm.com>
> 
>> +static const struct acpi_device_id xgmac_acpi_match[] = {
>> +	{ "NXP0006", (kernel_ulong_t)NULL },
> 
> Hi Jeremy
> 
> What exactly does NXP0006 represent? An XGMAC MDIO bus master? Some
> NXP MDIO bus master? An XGMAC Ethernet controller which has an NXP
> MDIO bus master? A cluster of Ethernet controllers?

Strictly speaking its a NXP defined (they own the "NXP" prefix per 
https://uefi.org/pnp_id_list) id. So, they have tied it to a specific 
bit of hardware. In this case it appears to be a shared MDIO master 
which isn't directly contained in an Ethernet controller. Its somewhat 
similar to a  "nxp,xxxxx" compatible id, depending on how they are using 
it to identify an ACPI device object (_HID()/_CID()).

So AFAIK, this is all valid ACPI usage as long as the ID maps to a 
unique device/object.

> 
> Is this documented somewhere? In the DT world we have a clear
> documentation for all the compatible strings. Is there anything
> similar in the ACPI world for these magic numbers?

Sadly not fully. The mentioned PNP and ACPI 
(https://uefi.org/acpi_id_list) ids lists are requested and registered 
to a given organization. But, once the prefix is owned, it becomes the 
responsibility of that organization to assign & manage the ID's with 
their prefix. There are various individuals/etc which have collected 
lists, though like PCI ids, there aren't any formal publishing requirements.

