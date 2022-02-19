Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CCE4BC785
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 11:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241881AbiBSKA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 05:00:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiBSKA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 05:00:58 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E16A1BFA;
        Sat, 19 Feb 2022 02:00:38 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hw13so20541213ejc.9;
        Sat, 19 Feb 2022 02:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eyoLzh3GoCjEcko6E6TRX3Q0MN5P8KHlKdLhPGSzjas=;
        b=nnddJEcHqLBBgfgW6X8nP2hJ+jbcGZujjBROoEt9DQKra/B8N1F3VqRROEaOdXzS1G
         TnmFhHNUyN5sK64vsVyWIaI5/IWYIRSDlRlHN9lO44vm9/RH205qjm0HVp0WDQBkojHS
         SxK7lXv9qPuxBw0h8IcrUN22V3RAYtX9gwDEXgiSTbwCKm6Cv+emuMeHX4pjOUOxLO1r
         SBJvros1knM0ArBLcFpYEDQBMbDEOjZyNBZZLUKg0Dh+l34NitpBj33SGW8TgzKLy4aU
         BUdMEoxEsM4NVFdyaStDhqIhtOms7cKP4Ae+XytJsnPBGISv5erc6kLo/q/y+6+jwYSL
         tJVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eyoLzh3GoCjEcko6E6TRX3Q0MN5P8KHlKdLhPGSzjas=;
        b=ikZVPyIlASmHZ8l0LzizvdISxXwDLAR9X8p3ifNg1lWZ1QB9bSlmWF2ucgYVRlNzil
         2mLL0frS+3j3BRiiDasziSZa3I/iVMvU7vHm1bP1d+5yze98xKlwIfI4okKhWM4Y9yNv
         hGHpYiACfFJ+Swpsr8TxowJ8nR/J9EVe3GIueqaJsGcCZtByXsI9SlKNg8g/WN99suyf
         5D5CvnCfAoCqO6ouU3dYEZehToU8lFX59uC4b/6eBWoJho1OTktfXiCrFH/1cVSNe05u
         VM8iMi/dE6eRXQR7AM/mDLqFOQz62kO7+GtlD7KsDIRRMCz/98K7hb53hVaLdMi2M7V5
         SX1Q==
X-Gm-Message-State: AOAM531SyddbjLXZ6CCt4lCJv3jaM4D+l5KiUkWoeZv4CScBbj40UQmk
        IKcMn/dZfnm2ZK3Ub+OZYrg=
X-Google-Smtp-Source: ABdhPJx1V2gD2Zh/g9vSl2TlbwK/2IUdNqZeGbq6SyVxCfhg7AYOb4RmbSYhkOf48WpzRbDFW0e3YQ==
X-Received: by 2002:a17:906:154c:b0:6ce:21d7:2826 with SMTP id c12-20020a170906154c00b006ce21d72826mr9312950ejd.9.1645264837397;
        Sat, 19 Feb 2022 02:00:37 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id b20sm5824839ede.23.2022.02.19.02.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 02:00:36 -0800 (PST)
Date:   Sat, 19 Feb 2022 12:00:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/5] net: dsa: mv88e6xxx: Add support for
 bridge port locked mode
Message-ID: <20220219100034.lh343dkmc4fbiad3@skbuf>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
 <20220218155148.2329797-5-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218155148.2329797-5-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 04:51:47PM +0100, Hans Schultz wrote:
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index ab41619a809b..46b7381899a0 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -1234,6 +1234,39 @@ int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
>  	return err;
>  }
>  
> +int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
> +			    bool locked)
> +{
> +	u16 reg;
> +	int err;
> +
> +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
> +	if (err)
> +		return err;
> +
> +	reg &= ~MV88E6XXX_PORT_CTL0_SA_FILT_MASK;
> +	if (locked)
> +		reg |= MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK;
> +
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
> +	if (err)
> +		return err;
> +
> +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, &reg);
> +	if (err)
> +		return err;
> +
> +	reg &= ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
> +	if (locked)
> +		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
> +
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);

	return mv88e6xxx_port_write(...);

> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
