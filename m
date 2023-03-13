Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D44C6B8046
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjCMSU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjCMSUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:20:41 -0400
X-Greylist: delayed 110 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Mar 2023 11:20:12 PDT
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B02B7E7A4;
        Mon, 13 Mar 2023 11:20:12 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 32DII48B525011;
        Mon, 13 Mar 2023 19:18:04 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 32DII48B525011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1678731484;
        bh=fDODv/JG6TlBswRvg4d33h1IlTOtA6L8xzOB57WlhEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fgYRIeOrOxLUgHicG+sUWCDB30KAfKyx7pLKxPGVFm0PKzSAgF8waEyVG2cGnhwOh
         W0zMOWOGdf57bj6vCGCNO7R4EoUyDloc2I92XX2u567dapKjA51SzdlaQW20WoTTPy
         YMiub42DWA6fODW+K7NBHV4wpcjeeS2kNz4ZomCU=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 32DII4dm525010;
        Mon, 13 Mar 2023 19:18:04 +0100
Date:   Mon, 13 Mar 2023 19:18:03 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Use of_property_read_bool() for boolean properties
Message-ID: <20230313181803.GA524627@electric-eye.fr.zoreil.com>
References: <20230310144718.1544169-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310144718.1544169-1-robh@kernel.org>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob Herring <robh@kernel.org> :
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to to of_property_read_bool().
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
[...]
>  drivers/net/ethernet/via/via-velocity.c         |  3 +--
[...]
> diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
> index a502812ac418..86f7843b4591 100644
> --- a/drivers/net/ethernet/via/via-velocity.c
> +++ b/drivers/net/ethernet/via/via-velocity.c
> @@ -2709,8 +2709,7 @@ static int velocity_get_platform_info(struct velocity_info *vptr)
>  	struct resource res;
>  	int ret;
>  
> -	if (of_get_property(vptr->dev->of_node, "no-eeprom", NULL))
> -		vptr->no_eeprom = 1;
> +	vptr->no_eeprom = of_property_read_bool(vptr->dev->of_node, "no-eeprom");
>  
>  	ret = of_address_to_resource(vptr->dev->of_node, 0, &res);
>  	if (ret) {

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

Simon Horman's comment regarding assignment of bool value to an integer
typed field also apply here.

-- 
Ueimor
