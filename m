Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA3D5783FF
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbiGRNmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbiGRNmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:42:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072181F615;
        Mon, 18 Jul 2022 06:42:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q5so9035106plr.11;
        Mon, 18 Jul 2022 06:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5glw/sVKGgr66L6xdKScVn9xWukMCuFZ8q3nmTVvFE8=;
        b=cuf5hUNtU0/KD49tulskC6amR8It/LlvQxClHQW7a95ejrXa0AMXXvDIVXFMdgWZGo
         L4shcCbaKv4vbFfVBNWowQoIRv4WlZQnyOkBi36rsjENKDNwYeDN1K/ng0mBTntQdMWp
         hZewgxuY8Iens+riIINMlpzMak4zzvQBoP/I7igoqcoEjS5eTYvq3yVXnb5JPAZYLkMi
         DdCyqq8y1Z2wbWnhdKbbSoQ6F/FBVAlWxdoJxoZDUBLah+IZG9D/kk6RTI3rLn1rOKBm
         COvpWZEXUaMOUV2J+ZTN9U+makeZYPFrf72PV8JSRQbg7f/ZdLs4gljTKLLUXV847sJO
         2T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5glw/sVKGgr66L6xdKScVn9xWukMCuFZ8q3nmTVvFE8=;
        b=5oZA/H5s0KEXN80lbACVLaImIOo5+fDT4v3CP/I/hZ2T9hj4lmB7uMNlyZTgg1erhX
         l2/aq8pMuK+1AaYR7DF5QIDx3Q4mkdvbG06xOZjrpL2TdEcY5xfSLHDzT5k3H2KFFz6J
         V5lR+cAvsGwHR16mT7v6hxWJmfGn+/RjB2y4s9jkATjthGnGD9V3YQGEG6IcP9w5erG/
         ehelvxTDmy9Gq9Cw3OWDuErwqJap30UouZForLTkTvMPCaKaJaAihEgc0iiL3y7d9gKp
         nbKz7dlrxF0rGck8jKw1U2F3CytXrN7B7uFXIWt2rAOCJrwzcSvMVWEZGHRLI33xSTVl
         QhEQ==
X-Gm-Message-State: AJIora+0LmchGhq8ZEV9JKCB19XduoP3vK0hY6XJUIGk6Ef+JysB+C2s
        7zBT/m8xoECSHPXqV4rf4rs=
X-Google-Smtp-Source: AGRyM1vdWDP6toZwzfT59MCLzgbNBvctHq8GcsK2BIiEqY3q/W/oe43RyzEJa94BKciD5Fy66/oMsA==
X-Received: by 2002:a17:903:31c9:b0:16c:3024:69c4 with SMTP id v9-20020a17090331c900b0016c302469c4mr28613487ple.81.1658151726421;
        Mon, 18 Jul 2022 06:42:06 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w29-20020a63491d000000b003fadd680908sm8169824pga.83.2022.07.18.06.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:42:06 -0700 (PDT)
Date:   Mon, 18 Jul 2022 06:42:03 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Message-ID: <YtVjKzTOxdP9zm4u@hoboy.vegasvil.org>
References: <20220718114333.4866-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718114333.4866-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 05:13:33PM +0530, Divya Koppera wrote:
> Removing NULL check, as using it here is not valid

NAK.

Please read the code:

 * ptp_clock_register() - register a PTP hardware clock driver
 *
 * @info:   Structure describing the new clock.
 * @parent: Pointer to the parent device of the new clock.
 *
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.


You must handle the NULL pointer case.

Thanks,
Richard


> 
> Fixes New smatch warnings:
> drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing zero to 'PTR_ERR'
> 
> vim +/PTR_ERR +2613 drivers/net/phy/micrel.c
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index e78d0bf69bc3..04146b936786 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -2812,7 +2812,7 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
>  
>  	shared->ptp_clock = ptp_clock_register(&shared->ptp_clock_info,
>  					       &phydev->mdio.dev);
> -	if (IS_ERR_OR_NULL(shared->ptp_clock)) {
> +	if (IS_ERR(shared->ptp_clock)) {
>  		phydev_err(phydev, "ptp_clock_register failed %lu\n",
>  			   PTR_ERR(shared->ptp_clock));
>  		return -EINVAL;
> -- 
> 2.17.1
> 
