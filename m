Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9233B57A125
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbiGSOTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239280AbiGSOTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:19:09 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A82167CB;
        Tue, 19 Jul 2022 06:56:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p8so2252900plq.13;
        Tue, 19 Jul 2022 06:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PfgQUmHXfEsVlt7EAdQAep/0k+r0QZc8dV885v2KGqk=;
        b=oSFTG21y1pXhyCeqwKlLlq3unncBMp95IC3TGLCmO1z42grixpBG8U96oGTKV7Xe1d
         lRs4m2FetXtN4JPCyEpKdZ2pBaTNo7SVrBQizmYX6MwkS4XUbwv+KG1HuZKgN7x0lcPK
         3iRkO2cfxHlRpRv5V9q71amM1qrojleD4W/4svWWHA8pmBI7MbHg4ikgsWqUeIizxmlM
         QPL8RXBCGJVU4Lkgu43XdBNY4kkexqVHaLn9EiEJHSgDhCnJIanihqbd3L+IEtizN95s
         dzYjGxwtininmup825hjdosdpjKg94hiatXmimrPvCzm2bh8HY3x5pkWtCqWd+MJks5E
         YDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PfgQUmHXfEsVlt7EAdQAep/0k+r0QZc8dV885v2KGqk=;
        b=lYihxBzbAMPizpjw3BYLHIMcvDtXQhaGdt03Hn73aHhiZ6KKtbzHcuo9k4VbN1Gkwz
         jiOtMgJBbXxpE4U/YrwJCiegFIfhDmFPP2pW8+9keD6YkLkiK4GYZZGWtw7iK2HCgMNJ
         DNKROJJBN7+ndrXmX3Ecbo60hihYaxHoPVvfRsSRz9gu4HTv4Qb5tVUjdfDhv9wT7yG4
         x/ThMvAPo1/dRW3iH1XwfsQ9nzhHeauaCwaMmMdTfyd8p5nkcAxcOfV6F2TRqmpvr71i
         rlwoISbX+0n/wuuyEgflzWgdtyNQoCcOAQaCd5k4FZIC4cTScD0lLwJM8Kdhe7TKGvuk
         WjGQ==
X-Gm-Message-State: AJIora+6YlfGyNIQXjlxjIZm6fMsrJxmARaNg7F9otM22JMXU05CFjQk
        4ukqObNvA+ViWaBZVmX7meg=
X-Google-Smtp-Source: AGRyM1u02n8sve9ba2gLev+p5N2PAurYO8H0ftACBkugnGykUFfhZ88nVh46EMaFvnkjq3mxTADYbw==
X-Received: by 2002:a17:90b:3c0c:b0:1ef:e647:ff48 with SMTP id pb12-20020a17090b3c0c00b001efe647ff48mr44369290pjb.173.1658238983691;
        Tue, 19 Jul 2022 06:56:23 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090264d000b0016bdee4f24asm1684907pli.48.2022.07.19.06.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:56:23 -0700 (PDT)
Date:   Tue, 19 Jul 2022 06:56:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com
Subject: Re: [PATCH v2 net] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Message-ID: <Yta4BFfr+OkUmOhl@hoboy.vegasvil.org>
References: <20220719120052.26681-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719120052.26681-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 05:30:52PM +0530, Divya Koppera wrote:
> Handle the NULL pointer case
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
> v1 -> v2:
> - Handled NULL pointer case
> - Changed subject line with net-next to net

This is not a genuine bug fix, and so it should target next-next.

> ---
>  drivers/net/phy/micrel.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index e78d0bf69bc3..6be6ee156f40 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -2812,12 +2812,16 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
>  
>  	shared->ptp_clock = ptp_clock_register(&shared->ptp_clock_info,
>  					       &phydev->mdio.dev);
> -	if (IS_ERR_OR_NULL(shared->ptp_clock)) {
> +	if (IS_ERR(shared->ptp_clock)) {
>  		phydev_err(phydev, "ptp_clock_register failed %lu\n",
>  			   PTR_ERR(shared->ptp_clock));
>  		return -EINVAL;
>  	}
>  
> +	/* Check if PHC support is missing at the configuration level */
> +	if (!shared->ptp_clock)
> +		return 0;

This is cause a NULL pointer de-reference in lan8814_ts_info()
when it calls 

	info->phc_index = ptp_clock_index(shared->ptp_clock);

> +
>  	phydev_dbg(phydev, "successfully registered ptp clock\n");
>  
>  	shared->phydev = phydev;
> -- 
> 2.17.1
> 

Thanks,
Richard
