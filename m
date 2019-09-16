Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F31B37A0
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 11:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfIPJ5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 05:57:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39761 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfIPJ5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 05:57:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so8976335wml.4
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 02:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=socXTyfxq6vDrcjWYM19NFMc96YqOKN10lzdiNQHHPI=;
        b=K3aktbDp0upm0AMVDjEo9u9e3AF6mEjn/lsM7Esc0eHwRdcdEXm6CBxcYDVPjsw8Ob
         9bryMcMy6mxrI8KQg63XR/7nTj1rFV6RFa2NRFFgskRb++8k5PLLM651Lvn5lA2vpIy5
         T4XGmkj7UgQPW0XEj5EtHoCmMSHqkxPaZ44pXWgneSFJzup+U58Y1xUPkG+aSIj/nnfc
         uNbC4EKnVLeMzisQ1oucqY5NdnaOrF/E9ckcYpSFnd2H5d3oA2wK9qwG5QDZteiVjWwJ
         dWfgDND5QPeovRpnXNhbMIDwrxWvICai+5pzbfVaRQGUnQrZjbMUFz9jGRRF47B3z47c
         jhGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=socXTyfxq6vDrcjWYM19NFMc96YqOKN10lzdiNQHHPI=;
        b=OebFEq4l9SX2/ko/USW4q1OmIFfphSc9oOR/y3FkV0T6/IMwulUqsPLLDiWbMGVfkq
         +q/ZEywIl88sPxWpGsxIUnGG+tJMxRXXsEs887Ec4Jom0rkFsJ/MwAp6YCzsTOpnBiQr
         PrCvvmXyj4Mcs4cY+QJA7lNO+AzcLnUfHZNTKipcVEQNxy+gigyR/hkhQ3rSCsHVezdD
         T/PYAvT4QRGZhJF0byeoyBsPt6kTJdhZ880c9+01l7M6giTFtXatpriDsJwrsL0DtAby
         CxuN+hJmqq4zDAuBsmaz9jbOdsGbdhg0ZOP6xNSR6q7ZcuBTkqDwSUVj3KsIS+mvnRAU
         5sdg==
X-Gm-Message-State: APjAAAWdq9jNdfxbR4OLP7B8EzMJvZec3elObS8HP3o6gepC/6hxZ/zi
        NyGIzrVM+SSz3awv7mFgLxhn2Q==
X-Google-Smtp-Source: APXvYqxfZhkBmma7/5sdsIFMH5YZsiA6eFOve64YOCEQUG2spCZsxd63tZKx6+yB96ZTMi4RSYqP2A==
X-Received: by 2002:a1c:4384:: with SMTP id q126mr14628426wma.153.1568627817357;
        Mon, 16 Sep 2019 02:56:57 -0700 (PDT)
Received: from apalos.home (athedsl-4503352.home.otenet.gr. [94.71.163.64])
        by smtp.gmail.com with ESMTPSA id s9sm14071186wme.36.2019.09.16.02.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 02:56:56 -0700 (PDT)
Date:   Mon, 16 Sep 2019 12:56:53 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        jose.abreu@synopsys.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        joergen.andreasen@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 2/6] net: dsa: Pass ndo_setup_tc slave
 callback to drivers
Message-ID: <20190916095653.GA4323@apalos.home>
References: <20190915020003.27926-1-olteanv@gmail.com>
 <20190915020003.27926-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915020003.27926-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 15, 2019 at 04:59:59AM +0300, Vladimir Oltean wrote:
> DSA currently handles shared block filters (for the classifier-action
> qdisc) in the core due to what I believe are simply pragmatic reasons -
> hiding the complexity from drivers and offerring a simple API for port
> mirroring.
> 
> Extend the dsa_slave_setup_tc function by passing all other qdisc
> offloads to the driver layer, where the driver may choose what it
> implements and how. DSA is simply a pass-through in this case.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes since v2:
> - Added Florian Fainelli's Reviewed-by.
> 
> Changes since v1:
> - Added Kurt Kanzenbach's Acked-by.
> 
> Changes since RFC:
> - Removed the unused declaration of struct tc_taprio_qopt_offload.
> 
>  include/net/dsa.h |  2 ++
>  net/dsa/slave.c   | 12 ++++++++----
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 96acb14ec1a8..541fb514e31d 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -515,6 +515,8 @@ struct dsa_switch_ops {
>  				   bool ingress);
>  	void	(*port_mirror_del)(struct dsa_switch *ds, int port,
>  				   struct dsa_mall_mirror_tc_entry *mirror);
> +	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
> +				 enum tc_setup_type type, void *type_data);
>  
>  	/*
>  	 * Cross-chip operations
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 9a88035517a6..75d58229a4bd 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1035,12 +1035,16 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
>  static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  			      void *type_data)
>  {
> -	switch (type) {
> -	case TC_SETUP_BLOCK:
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (type == TC_SETUP_BLOCK)
>  		return dsa_slave_setup_tc_block(dev, type_data);
> -	default:
> +
> +	if (!ds->ops->port_setup_tc)
>  		return -EOPNOTSUPP;
> -	}
> +
> +	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
>  }
>  
>  static void dsa_slave_get_stats64(struct net_device *dev,
> -- 
> 2.17.1
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
