Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE30102ACC
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfKSR3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:29:25 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:44686 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbfKSR3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:29:24 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJHTG3L069131;
        Tue, 19 Nov 2019 11:29:16 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574184556;
        bh=r/cBAHM8oY922P/6C8P9pt6goo9s2PX5XRBXQYR1CPs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=FHa8q0AkaQO/TTYzSCJp+gu59qGkDHoWhpifhhJKOVXbe/7yw1YNPIQ+Zmioo5Fb7
         b2ZSb14bLzq+rRZx3GI8MukkkMcDhVLWLnTt2daCpnOBJhLMQlctIbLuySr/DNx+FL
         UjWrquOZJbvuC5FhShxZEwsyCQytFg7kpXUUXSv0=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAJHTGsr005655
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Nov 2019 11:29:16 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 11:29:16 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 11:29:16 -0600
Received: from [10.250.33.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJHTGpj083047;
        Tue, 19 Nov 2019 11:29:16 -0600
Subject: Re: [PATCH][next] net: phy: dp83869: fix return of uninitialized
 variable ret
To:     Andrew Lunn <andrew@lunn.ch>, Colin King <colin.king@canonical.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20191118114835.39494-1-colin.king@canonical.com>
 <20191118232912.GC15395@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <1346c899-2114-875a-68a7-4ce0c08307dc@ti.com>
Date:   Tue, 19 Nov 2019 11:27:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118232912.GC15395@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 11/18/19 5:29 PM, Andrew Lunn wrote:
> On Mon, Nov 18, 2019 at 11:48:35AM +0000, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> In the case where the call to phy_interface_is_rgmii returns zero
>> the variable ret is left uninitialized and this is returned at
>> the end of the function dp83869_configure_rgmii.  Fix this by
>> returning 0 instead of the uninitialized value in ret.
>>
>> Addresses-Coverity: ("Uninitialized scalar variable")
>> Fixes: 01db923e8377 ("net: phy: dp83869: Add TI dp83869 phy")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
> Dan: phy_modify_mmd() could fail. You check the return value for
> phy_read and phy_write, so it would be consistent to also check

Thanks for the heads up on this.

I need to check the set/clear_mmd bits too.

Dan


> 	 Andrew
