Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9322565FBF
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 01:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiGDXfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 19:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiGDXfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 19:35:02 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D75C2BC3;
        Mon,  4 Jul 2022 16:35:01 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id eq6so13255545edb.6;
        Mon, 04 Jul 2022 16:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=T8S0l8y9d8Axnt5vHKcfa4KW+KyScMqV4sAI/irB22c=;
        b=djDAMtpfqnkI0WF6TGgtPkzlMpfSoeYlDDNgE6j8sY8HpSm54gda2piV9ltBSZrvg3
         SSVuf/WyApMz/hclgRyNMOcNCDZtVwvIq2TtoIiNI2s+tX81GatXIUojo/l3YWSolpBY
         gwU9xw+DXKp2ogpRNzU9EflHjuuB57+a6C7CETy68HMOiOWi95UhQ38UeBIQMsV7pprY
         VkUYDQ4iAiJH3oVYQpyl4elEWWi87xUp9C/yOvLpnQl7Ud4vDGgOuyfA1zQpMhq5fhab
         2hMTgk6TGlNTf90/1polYojoeDDayil6EdQ95g0HNeKZScgKOtzAmSw3eLyk+kDES6m2
         lqGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=T8S0l8y9d8Axnt5vHKcfa4KW+KyScMqV4sAI/irB22c=;
        b=iXCKmW2KpApsozVcVGZLos5aqL6g1M+j43+p3Qmt3p16C/sPdkEWHoNxWwjRNfE857
         yJHDLfVN7fhXzCSnMUzXFXMJVpfaOigOuor0b/x5aEMAoylcJPVBQFB9ury1s003w+/A
         Q6L4TVmPiPFRvOoETWkW4xakpMrdTHpNZ/mDK4iTfYq3gU6HG7/mq1G8Hkp2HQG/9vy3
         02BjhSM1uH2jPjS/QXMfluEsfJEkfJkLR2JOdTFXUxYSpdzffe69oEo46NpTzx7Pm7Tr
         QJ3oQxlcDh49GCU0wI4zeD785MQ/S93GMwae/dyY57H5T3y9didcSdW42vba/1hNcPrF
         5a1g==
X-Gm-Message-State: AJIora+/1SyEng4JMzPFAChnwYvMsowkk1AJkDQidvxVas7Pgli2AeOX
        bjUyBaS/w91T4unUtcL8aMP0oDF+9pfalDiE
X-Google-Smtp-Source: AGRyM1uodonDapeOyqMZ310HkDK2VMS5hY2SPriOX5HIFT6St6SrPc+6yDST4p88DwqpSBQcwPISPA==
X-Received: by 2002:a05:6402:249d:b0:437:8622:6de8 with SMTP id q29-20020a056402249d00b0043786226de8mr42730595eda.113.1656977699772;
        Mon, 04 Jul 2022 16:34:59 -0700 (PDT)
Received: from skbuf ([188.25.231.173])
        by smtp.gmail.com with ESMTPSA id s8-20020a508dc8000000b00435c10b5daesm21554012edh.34.2022.07.04.16.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 16:34:58 -0700 (PDT)
Date:   Tue, 5 Jul 2022 02:34:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH stable 4.9] net: dsa: bcm_sf2: force pause link settings
Message-ID: <20220704233457.tgnenjn3ct6us75i@skbuf>
References: <20220704153510.3859649-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220704153510.3859649-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, Jul 04, 2022 at 08:35:07AM -0700, Florian Fainelli wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream
> 
> The pause settings reported by the PHY should also be applied to the GMII port
> status override otherwise the switch will not generate pause frames towards the
> link partner despite the advertisement saying otherwise.
> 
> Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/bcm_sf2.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 40b3adf7ad99..03f38c36e188 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -671,6 +671,11 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
>  		reg |= LINK_STS;
>  	if (phydev->duplex == DUPLEX_FULL)
>  		reg |= DUPLX_MODE;
> +	if (phydev->pause) {
> +		if (phydev->asym_pause)
> +			reg |= TXFLOW_CNTL;
> +		reg |= RXFLOW_CNTL;
> +	}

Is this correct? phydev->pause and phydev->asym_pause keep the Pause and
Asym_Pause bits advertised by the link partner. In other words, in this
manual resolution you are ignoring what the local switch port has
advertised.

To give you an example (I'm looking at the infamous Table 28B–3—Pause
resolution from IEEE 802.3).

Your logic, simplified, says: enable TXFLOW_CNTL as local device
resolution iff the link partner advertised PAUSE=1 && ASM_DIR=1, and
RXFLOW_CNTL if the link partner advertised PAUSE=1 at all.

The most trivial counter-example is if we (local device) advertise
PAUSE=0 ASM_DIR=0 (this can be achieved with ethtool rx off tx off).
That is one way to rig the negotiated flow control to off/off regardless
of what the link partner has advertised. But your logic would enable
local capabilities just because the link partner said so, ignoring what
was advertised here.

Another example is if the local station advertises PAUSE=1, ASM_DIR=1,
and remote PAUSE=0, ASM_DIR=1. According to IEEE, the link partners
should agree on "rx on tx off" for the local system, and "tx on rx off"
for the link partner. But your logic does not even enter the first "if"
condition, because phydev->pause (link partner's PAUSE advertisement) is
0. So neither TXFLOW_CNTL nor RXFLOW_CNTL will be enabled locally,
despite the expectation and what is printed by phy_print_status().

>  
>  	core_writel(priv, reg, CORE_STS_OVERRIDE_GMIIP_PORT(port));
>  
> -- 
> 2.25.1
> 
