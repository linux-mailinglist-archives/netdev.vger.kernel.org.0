Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC552E8C34
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 13:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbhACM4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 07:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbhACM4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 07:56:08 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90E6C061573
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 04:55:27 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D7zJC5dcYz1rwDg;
        Sun,  3 Jan 2021 13:55:23 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D7zJC59mbz1qqkM;
        Sun,  3 Jan 2021 13:55:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id LDq958j7Phlu; Sun,  3 Jan 2021 13:55:22 +0100 (CET)
X-Auth-Info: e7E+DRazrB1miByzfuVFDXTKIVmhv/RBuosbla9a/Ow=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun,  3 Jan 2021 13:55:22 +0100 (CET)
Subject: Re: [PATCH 1/2] net: phy: micrel: Add KS8851 PHY support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
References: <20201230125358.1023502-1-marex@denx.de>
 <X+ygLXjVd3rr8Vbf@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <19fac48e-dd17-26d8-0ebc-c08b51876861@denx.de>
Date:   Sun, 3 Jan 2021 13:55:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X+ygLXjVd3rr8Vbf@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/20 4:43 PM, Andrew Lunn wrote:
> On Wed, Dec 30, 2020 at 01:53:57PM +0100, Marek Vasut wrote:
>> The KS8851 has a reduced internal PHY, which is accessible through its
>> registers at offset 0xe4. The PHY is compatible with KS886x PHY present
>> in Micrel switches, except the PHY ID Low/High registers are swapped.
> 
> Can you intercept the reads in the KS8851 driver and swap them back
> again? The mv88e6xxx driver does something similar. The mv88e6393
> family of switches have PHYs with the Marvell OUI but no device ID. So
> the code traps these reads and provides an ID.

I would prefer to keep this as-is, since then the PHY driver can match 
on these swapped IDs and discern the PHY from PHY present in the KS886x 
switch.
