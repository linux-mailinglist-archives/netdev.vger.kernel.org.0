Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273FF279CEC
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 01:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgIZXww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 19:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgIZXwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 19:52:51 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF6BC0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 16:52:51 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c8so6236036edv.5
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 16:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ari2QKNy5Vk+9r7R59iFu9AbzdqYaWrIjCknyyJFrIQ=;
        b=Stv+J/8h5ayrd5w+RZ/zWKK5nrf2N0VeaL/tZGsPLpsPpGu+4WOv3ay/dvluG0h/M0
         5MRzyPimTVy6AxaslGB18NZ7IOT2UCYqk+VoibkDkAGSvO5n9DsJp9N6lx99rncEn9lg
         40MLRYcah+OefnJjLxpGq2rMUR7JmypRVg1NXFnr0K8eNFp8KfCmqSs/0dlf7TqQNaLe
         paGSTtqswsnywvS0d39VrLotUQ0803LXNCf/4PCBiOkftqBZpuI1PRlv5MAVn/YlDJ/0
         eP1jiC/SSuwquKDQ1gqGh3mU31Pw8nQCZZvRVEHTtZjlCQwXvrEKKISCJt/XALPDFQtN
         gn/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ari2QKNy5Vk+9r7R59iFu9AbzdqYaWrIjCknyyJFrIQ=;
        b=MLZ6PhjPNK6rXQhHb4hkIWzKDVGJ9pYAUj/+X6iMSZ76+vdTL7Qig2UBAdvs3zOMCr
         UuTygm+FT7snQlg7V+j1BbaE6mU2mRq3cGT1gG8CbfJi4xYaHUWuh8/IloJIeWlnQzu7
         RcEQnhkP48y7Xoek8g4iCpebRfQ+werz4sOWbqKHP+pJ67dcTS56WDnBsYjLbH6MZHoE
         MsI1OA9R2j7hANU2K9VXvsBu8zoMwb2krj5OqJmYURgvvFe2JsUQG7zA6Nh02hwEUwde
         paH3alZQNb3Nn62miLcpY5kC7vrmZCzcHILDGB7gWVHanHiXBuc1MRQUHAvZJ7j1VIZn
         rRkg==
X-Gm-Message-State: AOAM530ELo57VHs3SGWFce5amuhfofgOMo755YwvfyKF0y0yJAKbrVK1
        3u7cqSrnyKk4gGvtJasyUMBo5Sr0n5E=
X-Google-Smtp-Source: ABdhPJyOgNyxIOMae4kn50VeTcVdOX5XlVHXy44YZRxqqeRTfuoCLT+WoG6jDxRHHjm0LU1vZagpKA==
X-Received: by 2002:a50:fc08:: with SMTP id i8mr8908664edr.257.1601164368755;
        Sat, 26 Sep 2020 16:52:48 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id bf25sm5466518edb.95.2020.09.26.16.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 16:52:48 -0700 (PDT)
Date:   Sun, 27 Sep 2020 02:52:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: Add per port
 devlink regions
Message-ID: <20200926235246.sk6jmeqdrd5oivj4@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-8-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926210632.3888886-8-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 11:06:32PM +0200, Andrew Lunn wrote:
> Add a devlink region to return the per port registers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/dsa/mv88e6xxx/devlink.c | 109 +++++++++++++++++++++++++++-
>  1 file changed, 105 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
> index 81e1560db206..ed74b075de84 100644
> --- a/drivers/net/dsa/mv88e6xxx/devlink.c
> +++ b/drivers/net/dsa/mv88e6xxx/devlink.c
> @@ -415,6 +415,36 @@ static int mv88e6xxx_region_atu_snapshot(struct devlink *dl,
>  	return err;
>  }
>  
> +static int mv88e6xxx_region_port_snapshot(struct devlink_port *devlink_port,
> +					  const struct devlink_port_region_ops *ops,
> +					  struct netlink_ext_ack *extack,
> +					  u8 **data)
> +{
> +	struct dsa_switch *ds = dsa_devlink_port_to_ds(devlink_port);
> +	int port = dsa_devlink_port_to_port(devlink_port);
> +	struct mv88e6xxx_chip *chip = ds->priv;

> +	u16 *registers;

I was meaning to ask this since the global regions patchset, but I
forgot.

Do we not expect to see, under the same circumstances, the same region
snapshot on a big endian and on a little endian system?

> +	int i, err;
> +
> +	registers = kmalloc_array(32, sizeof(u16), GFP_KERNEL);
> +	if (!registers)
> +		return -ENOMEM;
> +
> +	mv88e6xxx_reg_lock(chip);
> +	for (i = 0; i < 32; i++) {
> +		err = mv88e6xxx_port_read(chip, port, i, &registers[i]);
> +		if (err) {
> +			kfree(registers);
> +			goto out;
> +		}
> +	}
> +	*data = (u8 *)registers;
> +out:
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
>  static struct mv88e6xxx_region_priv mv88e6xxx_region_global1_priv = {
>  	.id = MV88E6XXX_REGION_GLOBAL1,
>  };
> @@ -443,6 +473,12 @@ static struct devlink_region_ops mv88e6xxx_region_atu_ops = {
>  	.destructor = kfree,
>  };
>  
> +static const struct devlink_port_region_ops mv88e6xxx_region_port_ops = {
> +	.name = "port",
> +	.snapshot = mv88e6xxx_region_port_snapshot,
> +	.destructor = kfree,
> +};
> +
>  struct mv88e6xxx_region {
>  	struct devlink_region_ops *ops;
>  	u64 size;
> @@ -471,11 +507,59 @@ mv88e6xxx_teardown_devlink_regions_global(struct mv88e6xxx_chip *chip)
>  		dsa_devlink_region_destroy(chip->regions[i]);
>  }
>  
> -void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds)
> +static void
> +mv88e6xxx_teardown_devlink_regions_port(struct mv88e6xxx_chip *chip,
> +					int port)
>  {
> -	struct mv88e6xxx_chip *chip = ds->priv;
> +	dsa_devlink_region_destroy(chip->ports[port].region);
> +}
>  
> -	mv88e6xxx_teardown_devlink_regions_global(chip);
> +static int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
> +						struct mv88e6xxx_chip *chip,
> +						int port)
> +{
> +	struct devlink_region *region;
> +
> +	region = dsa_devlink_port_region_create(ds,
> +						port,
> +						&mv88e6xxx_region_port_ops, 1,
> +						32 * sizeof(u16));
> +	if (IS_ERR(region))
> +		return PTR_ERR(region);
> +
> +	chip->ports[port].region = region;
> +
> +	return 0;
> +}
> +
> +static void
> +mv88e6xxx_teardown_devlink_regions_ports(struct mv88e6xxx_chip *chip)
> +{
> +	int port;
> +
> +	for (port = 0; port < mv88e6xxx_num_ports(chip); port++)
> +		mv88e6xxx_teardown_devlink_regions_port(chip, port);
> +}
> +
> +static int mv88e6xxx_setup_devlink_regions_ports(struct dsa_switch *ds,
> +						 struct mv88e6xxx_chip *chip)
> +{
> +	int port, port_err;
> +	int err;
> +
> +	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
> +		err = mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
> +		if (err)
> +			goto out;
> +	}
> +
> +	return 0;
> +
> +out:
> +	for (port_err = 0; port_err < port; port_err++)

"while (port-- >= 0)" should do the trick. Also, maybe it would be
overall more aesthetic if you wouldn't use the goto and have 2 exit
points in such a small function, but a simple break here. Like this:

	int err;

	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
		err = mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
		if (err) {
			while (port-- >= 0)
				mv88e6xxx_teardown_devlink_regions_port(chip,
									port);
			break;
		}
	}

	return err;

> +		mv88e6xxx_teardown_devlink_regions_port(chip, port_err);
> +
> +	return err;
>  }
>  
>  static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
> @@ -511,8 +595,25 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
>  int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
> +	int err;
> +
> +	err = mv88e6xxx_setup_devlink_regions_global(ds, chip);
> +	if (err)
> +		return err;
> +
> +	err = mv88e6xxx_setup_devlink_regions_ports(ds, chip);
> +	if (err)
> +		mv88e6xxx_teardown_devlink_regions_global(chip);
>  
> -	return mv88e6xxx_setup_devlink_regions_global(ds, chip);
> +	return err;
> +}
> +
> +void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +
> +	mv88e6xxx_teardown_devlink_regions_ports(chip);
> +	mv88e6xxx_teardown_devlink_regions_global(chip);
>  }
>  
>  int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
> -- 
> 2.28.0
> 
