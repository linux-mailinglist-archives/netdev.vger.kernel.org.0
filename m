Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D20905B5
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfHPQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:25:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43541 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfHPQZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:25:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id b11so6666552qtp.10
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 09:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=tJbAL73peLOlLB4/pZ1mzmtP7kI+uk4j46LfYonMjvo=;
        b=WHv0rmdFdva8tEfBCMXPRvVIsrye+EN364/5ZmRjTvfe+XfZxJc7xqjiRRByHb/T2Z
         lGJOTnNDkZWwvvaOHyQsXqpFKmVtuRquDTIRKFpu2tveJkOnmbQpVeXRf3TRPMvB5mce
         xERh+a5IsHz0/NBNaP2j5aIKEI7L9CuSFFJFcXI69N2tiGP9+xhPfWYQQn0b7P5HINa0
         w1QUh8k607qZMQkHqS63eBk1V4/mI4JCIn/p5+Ak+cJXr3vvXyqtXwahUH7SEtc+TcFc
         KmBY4nW3YiNQUOivzHeVSFxc55JJo2o15e5qwQQ3z2nLBwhiJEIr4seh3BdSqoeEFZuG
         Kluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=tJbAL73peLOlLB4/pZ1mzmtP7kI+uk4j46LfYonMjvo=;
        b=fu7hgtVay+N5BLAF732RUO6o9C3Cz4pVKi7Gm23vH/R35VSQkoESjUVZVXzNXA7aDg
         eanvTFRg6KAdfjCt6sV/kWLMCghdQ3/W67qzXp/2zR233T/1BCeVZu+jYO1mTBcgPppz
         SHjmIuzqGg8uIEoMESLeuUD+Cxn7DZuzUz1ZQ77+x1Mti+dp/YAR6nntZNTF4pUWvPY+
         iGb1jWwoWFQowO3bxsqvArcilQcahA7cE/a1LEgSqKe8DryvLLe9SVWJ1J+Jq94krL8L
         drnkndW/rheR2kxb6AHfktbA60CbBaF51hYIvG3M3ZEwPnOYlcCnYr+xgjaHODvTAYCK
         eMgA==
X-Gm-Message-State: APjAAAV3gocwAXyWNnuN821PGvXeQeChmFc4M+MBuW6aksNfL7k+Oyy0
        rkGIoy+mDX8+3q8HI/Ef15A=
X-Google-Smtp-Source: APXvYqyf5le6Ss+09vmtqsvppjzIp7yE3ggLO4F6e0lIxtl7Li7GONaroKZP/vY7ghw78HQB4EVq6A==
X-Received: by 2002:a0c:e6cc:: with SMTP id l12mr2337264qvn.60.1565972754628;
        Fri, 16 Aug 2019 09:25:54 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g3sm3127157qke.105.2019.08.16.09.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:25:53 -0700 (PDT)
Date:   Fri, 16 Aug 2019 12:25:52 -0400
Message-ID: <20190816122552.GC629@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH RFC net-next 3/3] net: dsa: mv88e6xxx: setup SERDES irq
 also for CPU/DSA ports
In-Reply-To: <20190816150834.26939-4-marek.behun@nic.cz>
References: <20190816150834.26939-1-marek.behun@nic.cz>
 <20190816150834.26939-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 17:08:34 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> @@ -2151,16 +2151,6 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  	if (err)
>  		return err;
>  
> -	/* Enable the SERDES interface for DSA and CPU ports. Normal
> -	 * ports SERDES are enabled when the port is enabled, thus
> -	 * saving a bit of power.
> -	 */
> -	if ((dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))) {
> -		err = mv88e6xxx_serdes_power(chip, port, true);
> -		if (err)
> -			return err;
> -	}
> -
>  	/* Port Control 2: don't force a good FCS, set the maximum frame size to
>  	 * 10240 bytes, disable 802.1q tags checking, don't discard tagged or
>  	 * untagged frames on this port, do a destination address lookup on all
> @@ -2557,6 +2547,48 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  	return err;
>  }
>  
> +static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	int err;
> +
> +	/* Enable the SERDES interface for DSA and CPU ports. Normal
> +	 * ports SERDES are enabled when the port is enabled, thus
> +	 * saving a bit of power.
> +	 */
> +	if ((dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))) {
> +		mv88e6xxx_reg_lock(chip);
> +
> +		err = mv88e6xxx_serdes_power(chip, port, true);
> +
> +		if (!err && chip->info->ops->serdes_irq_setup)
> +			err = chip->info->ops->serdes_irq_setup(chip, port);
> +
> +		mv88e6xxx_reg_unlock(chip);
> +
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +
> +	if ((dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))) {
> +		mv88e6xxx_reg_lock(chip);
> +
> +		if (chip->info->ops->serdes_irq_free)
> +			chip->info->ops->serdes_irq_free(chip, port);
> +
> +		if (mv88e6xxx_serdes_power(chip, port, false))
> +			dev_err(chip->dev, "failed to power off SERDES\n");
> +
> +		mv88e6xxx_reg_unlock(chip);
> +	}
> +}

So now we have mv88e6xxx_setup_port() and mv88e6xxx_port_setup(), which both
setup a port, differently, at different time. This is definitely error prone.
