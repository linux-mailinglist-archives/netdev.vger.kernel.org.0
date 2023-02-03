Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAA168A705
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBCXtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBCXtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:49:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998E14DBC7;
        Fri,  3 Feb 2023 15:49:01 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id hx15so19573132ejc.11;
        Fri, 03 Feb 2023 15:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N5vjLrXIiKNHh6jAx83i0dChYtMAb2Yc7HOdu1UYG2M=;
        b=CZO0du6MLzx4P6QJmmx5N9yh657RlrOUz/XtvmPSHA3z0ua9Pqu06MaNhUcVOyBjJA
         WIH2WeROsOhd7mtJSDTAR3J/Y5220BN0BfLSXZ8Na60WK3ydRwpz/R6+JQRxa5LELvgH
         Rb9ggijWL5pCxVRw48/N0WpKIJhp8N5SotobX0ALe+p3XE4e6p6zfRf7rxCoPDPRIudj
         HwDcgc+8crGNgCBk3f1wF0mbqUbgJqhdKdkTCoXpeWLGitIMfNUu7u28MDdjFWovcUMX
         WubcugcXvVN3KkAl/TOLqBF4bWOIgnPh+EQTxbwAYSyzOwPmIEvPsJxL85dGUog9hkb7
         wFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5vjLrXIiKNHh6jAx83i0dChYtMAb2Yc7HOdu1UYG2M=;
        b=JAvdAUaRysQb7ubi5dQIXe6li1L/VoJfVH4gX7Uox/IJVXitZ04xQ/PmpwUhLBiiB9
         pJP+s33sk57uIOKuewAVgIzwUh0mxcb59jEsno755EWkWx66f+uJlxhRq9vVUcsTBW9+
         2K+Ytz2f5/FYbldyJzpe6tut2hLyCfbzLtuogldgCd/lq8BJfDP11mlsxfCpi4+mkbkO
         6huqPyfX5SP5IgAStVCVV7cIy2KRvO7dlhyuvBN0WiIU9qOJVYp/GBWhoASokBhIj2UL
         7OwNnyrPMHT4cZgmqyrh6oEaMFmJ/BjcdtZjTXyPm0MIrpzPFDDgLpbEX0TZhErWnPrN
         7TFQ==
X-Gm-Message-State: AO0yUKWWb3BidisTGnM+KvjuCqMe86IuhsCzRRE39OxGPFq5RF2YHvVP
        UThwAAebPex1NqcJO3qIS2U=
X-Google-Smtp-Source: AK7set97llQhnxh8GmM48+E1cl26z1QmVRFow6wwdh3Yt5vv4UueKvk1dXz4X1X0klNI30G3OBnMTw==
X-Received: by 2002:a17:907:8d16:b0:878:955e:b4a4 with SMTP id tc22-20020a1709078d1600b00878955eb4a4mr12997914ejc.33.1675468140171;
        Fri, 03 Feb 2023 15:49:00 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id pj23-20020a170906d79700b0086d70b9c023sm2052536ejb.63.2023.02.03.15.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 15:48:59 -0800 (PST)
Date:   Sat, 4 Feb 2023 01:48:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 10/11] net: dsa: microchip: lan937x: update
 vlan untag membership
Message-ID: <20230203234857.gsarv3kljlgesuwf@skbuf>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-11-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-11-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:29PM +0530, Rakesh Sankaranarayanan wrote:
> Exclude cascaded port from vlan untag membership table since it will be
> the host port for second switch. Here setting 1 means, port will be
> capable of receiving tagged frames and 0 means, port can not receive
> tagged frames.
> 
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index bf13d47c26cf..4c12131098b1 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -399,7 +399,7 @@ int ksz9477_port_vlan_add(struct ksz_device *dev, int port,
>  		vlan_table[1] |= BIT(port);
>  	else
>  		vlan_table[1] &= ~BIT(port);
> -	vlan_table[1] &= ~(BIT(dev->cpu_port));
> +	vlan_table[1] &= ~(BIT(dev->cpu_port) | BIT(dev->dsa_port));

same comment, what if dev->dsa_port is 0xff?

>  
>  	vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
>  
> -- 
> 2.34.1
> 
