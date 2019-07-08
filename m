Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78EAE61DC3
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 13:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfGHLXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 07:23:14 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39090 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbfGHLXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 07:23:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so16624277wrt.6
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 04:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kFZFJurzEI4AlY3KFTL8Z+4xhnQNOKxB4D1P19r+hWc=;
        b=P8a65DOQ76pLdqVa4fXNd9mxAmtGC9M0fjI4fF7zZ0D+G7j3DB9H7NFM+V4zVKpFyp
         bhGu4UDjmvm0nswG6wpbQB18g9bY/3U8/yOhg+4rMc9QoHuUZTy6xv4v3HMskEACpTSu
         SO6j8cn03VG5IpW7m+LKG0hBah1v2UtMKb+0IpoOz12Z01sIPXb1e1GJ252PQRRUIme4
         H/U322WaYk0mb9DQ2g7ayg8X1i1DJ8jc3WZ8CBRljiQ22vRMXR/7TEsN7KAhYZfuE3qu
         BzbxjCnX30gIx3sy7h99FKef0Enuf+1YHLNtxx2DcAqyKnznz5ESjnthHxVV7qVaFuoV
         sqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kFZFJurzEI4AlY3KFTL8Z+4xhnQNOKxB4D1P19r+hWc=;
        b=fi7nD1p3xMBSYnqxc2mnlQs+LxQH8frW1O36RqXBIUMjBbdxh9+C8HmtFYThytF2cs
         6tuyJWPcyBAblIWnThxUwvrafzv9uc3wO3J1a6uUY9wiYaauLgxZ/j+bqC8KuhaB7KxW
         YHI5FubwiPnmfXXKB8x7TyW8HelLF8VQIHMTuB8BpSdWxK5UL8i3HbG6iBo/59rgCvx5
         +OHq1nMwPsnRJCGNHl80nEW/LXL8S5OTzYNf3XQYBcCW0EQ2CeJUkT8lT7dXyISCkS5o
         R5sPQ3MQDyTV4vAd9bsF+SKzaTpy3WQZSiYIdVPpBDik9S7HfCZusAI2ZnKyRk0POmu7
         +ZGg==
X-Gm-Message-State: APjAAAVCN3hwxnvLzKeaNIZOlxqN0fxtgSMV1T+GC3YZBP9Mb6tAhb9b
        WmNDX8+3CIfoe74fRjqQorn+tg==
X-Google-Smtp-Source: APXvYqwZ58L777NyzPguxlsTeYv7G9tGPwhiEIMksobEGGi4YFycO58AxacOCEThUGnQvv1dAQ7Eqw==
X-Received: by 2002:a5d:518f:: with SMTP id k15mr18121877wrv.321.1562584990942;
        Mon, 08 Jul 2019 04:23:10 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id s25sm11539698wmc.21.2019.07.08.04.23.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 04:23:10 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:23:07 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 3/6] net: dsa: Pass tc-taprio offload to
 drivers
Message-ID: <20190708112307.GA7480@apalos>
References: <20190707172921.17731-1-olteanv@gmail.com>
 <20190707172921.17731-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190707172921.17731-4-olteanv@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> tc-taprio is a qdisc based on the enhancements for scheduled traffic
> specified in IEEE 802.1Qbv (later merged in 802.1Q).  This qdisc has
> a software implementation and an optional offload through which
> compatible Ethernet ports may configure their egress 802.1Qbv
> schedulers.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  include/net/dsa.h |  3 +++
>  net/dsa/slave.c   | 14 ++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 1e8650fa8acc..e7ee6ac8ce6b 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -152,6 +152,7 @@ struct dsa_mall_tc_entry {
>  	};
>  };
>  
> +struct tc_taprio_qopt_offload;
>  
>  struct dsa_port {
>  	/* A CPU port is physically connected to a master device.
> @@ -516,6 +517,8 @@ struct dsa_switch_ops {
>  				   bool ingress);
>  	void	(*port_mirror_del)(struct dsa_switch *ds, int port,
>  				   struct dsa_mall_mirror_tc_entry *mirror);
> +	int	(*port_setup_taprio)(struct dsa_switch *ds, int port,
> +				     struct tc_taprio_qopt_offload *qopt);

Is there any way to make this more generic? 802.1Qbv are not the only hardware
schedulers. CBS and ETF are examples that first come to mind. Maybe having
something more generic than tc_taprio_qopt_offload as an option could host
future schedulers?

>  
>  	/*
>  	 * Cross-chip operations
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 99673f6b07f6..2bae33788708 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -965,12 +965,26 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
>  	}
>  }
>  
> +static int dsa_slave_setup_tc_taprio(struct net_device *dev,
> +				     struct tc_taprio_qopt_offload *f)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct dsa_switch *ds = dp->ds;
> +
> +	if (!ds->ops->port_setup_taprio)
> +		return -EOPNOTSUPP;
> +
> +	return ds->ops->port_setup_taprio(ds, dp->index, f);
> +}
> +
>  static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  			      void *type_data)
>  {
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
>  		return dsa_slave_setup_tc_block(dev, type_data);
> +	case TC_SETUP_QDISC_TAPRIO:
> +		return dsa_slave_setup_tc_taprio(dev, type_data);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> -- 
> 2.17.1
> 
Thanks
/Ilias
