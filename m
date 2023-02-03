Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8250368A6EA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjBCXbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjBCXbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:31:00 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED731F4A8;
        Fri,  3 Feb 2023 15:30:59 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id dr8so19493203ejc.12;
        Fri, 03 Feb 2023 15:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=awV/5XZjt2KEg87Bf/oa/VcPR36YkggADN6IG+/kHnU=;
        b=KBaP1kJIyjx67NBfRIntmzyQWCIjJg+Fg435SSWO7zLbkMtGKZYNQQ5HokhIIA60sE
         WffYDlu6x5ArBynez4C6FMR3UV395pTjC5Pkqduj4De98lcEnXrHF3htvXWB2Z+qOvzr
         cHFhj9BYj0/dWCYaq4X6QoKBxaAPFUD8XbpXLsRNWzbWzWCLgVn9VolBmvji5JmwGDq4
         Ra8a5+ItO8kvj/mxsaQfhuzwbVUw5EdFZ/TCo27SRy43M9mKCrCBXyMHmD/e9pu50bI1
         ZDVtVTj4pLvmBjzQWVEc7Nzx2Fw0KsKHp3dTqaCKVMfsTdeHx/VsA1Q4yBfmFOmqaI8Z
         F6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awV/5XZjt2KEg87Bf/oa/VcPR36YkggADN6IG+/kHnU=;
        b=khEBFY13fJ/7JQe++8vrq+KmbaUP9rb3BIvgl5L6qwEIsGSqtMWXjtAErBo+h7PmjQ
         HcXshFgQp1BejI5zgLzSoyfl6yw2asLLDBlvnUPEN3TcYR6oLI1sScoZjFkArKKYoygB
         9/YAtK93J+MwI3wF803H0W+qPqS/4lBdZIJqlynTjBG2Yd7BjHKE4Q2itbapGrLJzaGQ
         h8l3y0rzH+Sgvx5TskBhumXRsFBnUL3YwiwfRCClvv2ZzzYa1OIyZRzCyDMw+OSXB9LD
         UTVSf04Kz5Zp5h3uGigUXxN9RYecTlPmE3H2fSns1U0PTUsheHsMr3IrRg81GpaU82kR
         0A3w==
X-Gm-Message-State: AO0yUKUSJZ4ecLNajgnfwEhidJoxjHyzfVFQ+0e3fTN9pxWDgJD7I4cO
        ZxyY1+Yh8PnYgBxAPzZ6IIg=
X-Google-Smtp-Source: AK7set/2GkFmiMzurtR/PYCAUMldAoVJ+T91vca/Cqd+u5hBB2MhV6abELpyLq2WN0iXq1emFgShYg==
X-Received: by 2002:a17:907:2d28:b0:88e:682e:3a9e with SMTP id gs40-20020a1709072d2800b0088e682e3a9emr13757225ejc.61.1675467058238;
        Fri, 03 Feb 2023 15:30:58 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id m19-20020a1709061ed300b0088ed7de4821sm2024587ejj.158.2023.02.03.15.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 15:30:57 -0800 (PST)
Date:   Sat, 4 Feb 2023 01:30:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 06/11] net: dsa: microchip: lan937x: get
 cascade tag protocol
Message-ID: <20230203233055.vdctyjmdeam4tj5p@skbuf>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-7-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-7-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:25PM +0530, Rakesh Sankaranarayanan wrote:
> Update ksz_get_tag_protocol to return separate tag protocol if
> switch is connected in cascade mode. Variable ds->dst->last_switch
> will contain total number of switches registered. For cascaded
> connection alone, this will be more than zero.

Nope, last_switch does not contain the total number of switches
registered, but the index of the last switch in this tree. DSA does not
assume that the indices are consecutive.

If you make any assumption in the driver regarding switch numbering in a
cascade setup, it is an assumption that a device tree writer who is not
you needs to know about. So you must document it in
Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml.

> 
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index adf8391dd29f..2160a3e61a5a 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -2567,9 +2567,13 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
>  	    dev->chip_id == KSZ9567_CHIP_ID)
>  		proto = DSA_TAG_PROTO_KSZ9477;
>  
> -	if (is_lan937x(dev))
> +	if (is_lan937x(dev)) {
>  		proto = DSA_TAG_PROTO_LAN937X_VALUE;
>  
> +		if (ds->dst->last_switch)
> +			proto = DSA_TAG_PROTO_LAN937X_CASCADE_VALUE;
> +	}

Also nope, see the comment on patch 1.

> +
>  	return proto;
>  }
>  
> -- 
> 2.34.1
> 
