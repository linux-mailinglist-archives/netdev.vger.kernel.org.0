Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2A22F2D3E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 11:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbhALKx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 05:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbhALKx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 05:53:58 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67F9C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 02:53:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j16so1811627edr.0
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 02:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rpbYUHLDYNoe0aUzOs6xVDw/LqV/sO/iqWMmtqrYge0=;
        b=iGaxeFwmZO753zcMLHBukE6Ph7Gngfzi8Q3sgVGa1OppWjLYgLvJgFfW5TEZYaFDYO
         eYUiYl4txgFDZ5cA3RXk1TH3DCIxf/EOBfd+uRz5shfjtvuxMByw+Zt+xrEXKCVS4p6f
         weJlVr99TDguPZbZ7OdZMPHsFzgB39aASVZKEF/f/bAVOrN9hpiEbVLr5BDoaCrelAzV
         kAnRagxMERqG9GEB9uYh8N4US2YfBevupK5loPuqgkQrU5zGnI4TEhk2k/G9AbbTKGsw
         RARbnXPIOHvbWnOs9PMBG+4a7trP5LAzLHOeJD1pnzGY9DjK2cdiEZWUjhrfLer8t2op
         Zv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rpbYUHLDYNoe0aUzOs6xVDw/LqV/sO/iqWMmtqrYge0=;
        b=QWGuqsBcGFXFWJjSJUP/N0KG4T6lJK933jpHIz5k6dWmsJwF1RhplYIVSGd8eOldDm
         9KiNOIzv+wfUVwhcBr8S+iDXveIGbGYxl2737cSurjlHoXyzKKfzVRrDVGOtk3UKH9hH
         TZPQZ6/Jxo0RPfYysBtKr7Y3mhGw4o7RqZ3EsCybihI4Po2ZxAdoU/MnRzZmG32tXZNU
         Ql6vOxRyCfNwWQpEvb8kKLhND7h2cpxzfDHzwZtvCqIWzbwuCl6/e5hfrv5qFzj3vGvQ
         KS1+9jGmYRZ55Evh751qb8Z//JtyCVeBuC9wprmkBBBRiLBOGHBkyGZ3b1PwUdyBbaI/
         3qNQ==
X-Gm-Message-State: AOAM532Gu+U0sb02RNtQPcGaFzGDaBOkLhcJApZegaxikELD7frlzj+V
        EpaswQpGpV8oCu8jSZ3jxNg=
X-Google-Smtp-Source: ABdhPJwSTLp3EOnhPaCHv4cJYH/GvR/3uiluGVUSZ4LAaGFVjOc8AwTjIp5h9V0VbuVlVIueKE2Thg==
X-Received: by 2002:a05:6402:1597:: with SMTP id c23mr2934707edv.212.1610448795549;
        Tue, 12 Jan 2021 02:53:15 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id by30sm1224013edb.15.2021.01.12.02.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 02:53:15 -0800 (PST)
Date:   Tue, 12 Jan 2021 12:53:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v14 4/6] net: dsa: mv88e6xxx: wrap
 .set_egress_port method
Message-ID: <20210112105313.rka5m6ha6qjwjpcn@skbuf>
References: <20210111012156.27799-1-kabel@kernel.org>
 <20210111012156.27799-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111012156.27799-5-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:21:54AM +0100, Marek Behún wrote:
> There are two implementations of the .set_egress_port method, and both
> of them, if successful, set chip->*gress_dest_port variable.
> 
> To avoid code repetition, wrap this method into
> mv88e6xxx_set_egress_port.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    | 48 ++++++++++++++++++-----------
>  drivers/net/dsa/mv88e6xxx/global1.c | 19 ++----------
>  2 files changed, 32 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 9bddd70449c6..62bef0759077 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2521,6 +2521,26 @@ static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
>  	return err;
>  }
>  
> +static int mv88e6xxx_set_egress_port(struct mv88e6xxx_chip *chip,
> +				     enum mv88e6xxx_egress_direction direction,
> +				     int port)
> +{
> +	int err = -EOPNOTSUPP;
> +
> +	if (chip->info->ops->set_egress_port) {

I would probably return -EOPNOTSUPP early and reduce the indentation
level by one:

	if (!chip->info->ops->set_egress_port)
		return -EOPNOTSUPP;
