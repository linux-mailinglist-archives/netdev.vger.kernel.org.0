Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5530C281930
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388324AbgJBR07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:26:59 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49216 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388054AbgJBR07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 13:26:59 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 092HQolG075846;
        Fri, 2 Oct 2020 12:26:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601659610;
        bh=ewHUeYHxEWWw/NLsg3xyaxNpCjxWbm+uZ/+WM9qoesQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=SmyURSm3ArcoNE1vaXX/ZerOFtRbMr5YAhPX1qkKg0/CdEEjnk75rbKOSDXP17PwK
         oHhKzkOUAirQoFm4d89ZmeadTkI24uTzoJoX52pOi/7fQsujLcDZq3nHUdaqhjm47h
         +VLbRbRtfQULJ7COt6DDUG7XIgu3kCmwQcIlPRYM=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 092HQoPJ092954
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 2 Oct 2020 12:26:50 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 2 Oct
 2020 12:26:50 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 2 Oct 2020 12:26:49 -0500
Received: from [10.250.71.177] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 092HQnij038358;
        Fri, 2 Oct 2020 12:26:49 -0500
Subject: Re: [PATCH][next] net: phy: dp83869: fix unsigned comparisons against
 less than zero values
To:     Colin King <colin.king@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201002165422.94328-1-colin.king@canonical.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <1ffbf497-cb07-4302-8a79-236338f00383@ti.com>
Date:   Fri, 2 Oct 2020 12:26:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002165422.94328-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin

On 10/2/20 11:54 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently the comparisons of u16 integers value and sopass_val with
> less than zero for error checking is always false because the values
> are unsigned. Fix this by making these variables int.  This does not
> affect the shift and mask operations performed on these variables
>
> Addresses-Coverity: ("Unsigned compared against zero")
> Fixes: 49fc23018ec6 ("net: phy: dp83869: support Wake on LAN")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/phy/dp83869.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> index 0aee5f645b71..cf6dec7b7d8e 100644
> --- a/drivers/net/phy/dp83869.c
> +++ b/drivers/net/phy/dp83869.c
> @@ -305,7 +305,7 @@ static int dp83869_set_wol(struct phy_device *phydev,
>   static void dp83869_get_wol(struct phy_device *phydev,
>   			    struct ethtool_wolinfo *wol)
>   {
> -	u16 value, sopass_val;
> +	int value, sopass_val;
>   
>   	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
>   			WAKE_MAGICSECURE);

Wonder why this was not reported before as the previous comparison issue 
reported by zero day.

Acked-by: Dan Murphy <dmurphy@ti.com>

