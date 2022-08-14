Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A556591EFF
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 09:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240338AbiHNH4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 03:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiHNH4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 03:56:30 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1552B198;
        Sun, 14 Aug 2022 00:56:29 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w19so8755980ejc.7;
        Sun, 14 Aug 2022 00:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=nnod5G/GV0QvT7Ke+0aBdKSty9dUGI6Tfo0IuZ+lJZ4=;
        b=qkbI0Yr+/EYvguI0CoUcxPrtpCVSHuKOP2ChcgnLklY+PbxiSA+/GQM8Xj9WCkKNHT
         /QDgOgaPFO2IJ0+8JQHARnkKMvzZ7c9oOcLsaOSUIWhntSSKP40tFPUEpmYY7ytcUdZn
         ERQoBS/IG/2cU898eJK0Jzf1rwzt88bwntrAt59OgqoVJt0Uh6yh6CU0PKWFpkfXh8Mq
         C9/CL5B6e88PSOrqOWwkaM8vUsPWgdHIItonPFXnEB+jyIGuq770gYJ/57nIr/liorJZ
         Ft/5e8LnrNG8T2wY06GRvuyNYZCu7yVDnnUqvlze/5HJZpwztkLTDP9WBsW1wckaOOzA
         WTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=nnod5G/GV0QvT7Ke+0aBdKSty9dUGI6Tfo0IuZ+lJZ4=;
        b=vj6voQXSQofGyDu/SIhqydhhe36QE+raSu4p3Rc0e/6lQfH4IJ+fQwve84cMWUvMgd
         93vRqZEr1cb9RmL1QNmhYBSiNRi2gJtZacebwYpfFrscdXb/2+4QPZ439g0d+Plp6Ayc
         HUkjcKFr7GzPEf6hvyMz8E30bL/49gocoHMsN0n7DECGcxVC1d/lYZey0MiJu2hvqemS
         YHnCHNB/ruAbXQn//debcTq7Y2Tmvnu13Nh2f/VMCM5X4zJryGwj+JHbbylqyQ87CbBB
         rvRqHRV52GSO/inuJNjToGL55tD9wcvKIKhB08apvbCtLXrUDGT6cTfBlA/gImBFZSJI
         WOrQ==
X-Gm-Message-State: ACgBeo1m/9WVOOmJjv4zFbrGPU/YKo+zBwLx3bEsKDcLjzWygAVMvlcT
        G4bQjFVDudsdjhGNG0y/WfA=
X-Google-Smtp-Source: AA6agR5ilcwyrpyp9/9l6JV4QPrEu5iw1EoYmiG4Zsz8aYfSRn266+XPhO/Yl7vAIUsH5LSqvwH/wQ==
X-Received: by 2002:a17:907:c07:b0:730:b91b:2cab with SMTP id ga7-20020a1709070c0700b00730b91b2cabmr7448655ejc.294.1660463788148;
        Sun, 14 Aug 2022 00:56:28 -0700 (PDT)
Received: from skbuf ([188.26.57.212])
        by smtp.gmail.com with ESMTPSA id gq17-20020a170906e25100b00730e5397057sm2649505ejb.185.2022.08.14.00.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 00:56:27 -0700 (PDT)
Date:   Sun, 14 Aug 2022 10:56:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [Patch net] net: dsa: microchip: ksz9477: fix fdb_dump last
 invalid entry
Message-ID: <20220814075624.us3ru5f45hsw6phb@skbuf>
References: <20220812093411.5879-1-arun.ramadoss@microchip.com>
 <20220812093411.5879-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812093411.5879-1-arun.ramadoss@microchip.com>
 <20220812093411.5879-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 03:04:11PM +0530, Arun Ramadoss wrote:
> In the ksz9477_fdb_dump function it reads the ALU control register and
> exit from the timeout loop if there is valid entry or search is
> complete. After exiting the loop, it reads the alu entry and report to
> the user space irrespective of entry is valid. It works till the valid
> entry. If the loop exited when search is complete, it reads the alu
> table. The table returns all ones and it is reported to user space. So
> bridge fdb show gives ff:ff:ff:ff:ff:ff as last entry for every port.
> To fix it, after exiting the loop the entry is reported only if it is
> valid one.
> 
> Fixes: c2e866911e25 ("net: dsa: microchip: break KSZ9477 DSA driver into two files")

I think this should be:
Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
since that's when ksz9477_port_fdb_dump() was introduced, with identical
logic.

> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 4b14d80d27ed..aa961dc03ddf 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -613,15 +613,17 @@ int ksz9477_fdb_dump(struct ksz_device *dev, int port,
>  			goto exit;
>  		}
>  
> -		/* read ALU table */
> -		ksz9477_read_table(dev, alu_table);
> +		if (ksz_data & ALU_VALID) {

I wonder if you could avoid increasing the indentation level using:

		if (!(ksz_data & ALU_VALID))
			continue;

> +			/* read ALU table */
> +			ksz9477_read_table(dev, alu_table);
>  
> -		ksz9477_convert_alu(&alu, alu_table);
> +			ksz9477_convert_alu(&alu, alu_table);
>  
> -		if (alu.port_forward & BIT(port)) {
> -			ret = cb(alu.mac, alu.fid, alu.is_static, data);
> -			if (ret)
> -				goto exit;
> +			if (alu.port_forward & BIT(port)) {
> +				ret = cb(alu.mac, alu.fid, alu.is_static, data);
> +				if (ret)
> +					goto exit;
> +			}
>  		}
>  	} while (ksz_data & ALU_START);
>  
> 
> base-commit: f86d1fbbe7858884d6754534a0afbb74fc30bc26
> -- 
> 2.36.1
> 

