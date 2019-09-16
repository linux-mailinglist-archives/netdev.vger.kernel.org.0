Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9608AB3729
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 11:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbfIPJbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 05:31:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40492 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfIPJbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 05:31:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so1033456wmj.5
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 02:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hsKbqAMvEtlRB6fazMnfDbGt3rg26P7WcP/IwY/zW+0=;
        b=MacdhDfgAEheHOPWVThq4lVRwX1MEwgBoBi8kQ4bVwa3eC2XexVztq9yfKbDuaeDJ+
         IHTjkhktmZVUNDSY/Xj96K9wu5V0evtuyEnixwF8ROS+UaCqNIlV0jeBnEVcgECDKb4N
         ytmAZCtnCsgkSzN6+n5QZXaQHQGlTWqMmqTDMl/p7ahwrMMmC4L6WL/S6TJTTEmv5W/4
         Tt9/32PKUFhvKOcaG8Nh/O27uhdWUW//cWcSwlqW6ThFzV1qnaCoF4EqH+l+faQh0TK8
         aK3spdaCmfwfqw7npcOX2GYoCqxaujrt0Rw9VJqbnL2dhD4OZPQCji29IaD7asaZdJbs
         bzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hsKbqAMvEtlRB6fazMnfDbGt3rg26P7WcP/IwY/zW+0=;
        b=JeT6AkL2hHKZsQ12zEtF+TaD0akOwB52wvWxIn/84G3TeeXmwnc7Vh6nu2MhgByYlJ
         YpV5Gs7SrT4QmKRQ95NF0VPH+kVdpVaHmfL5IAv45s/cDle9ztMKEAjWWNtVBNTxf6oh
         jFS0NV2XBXa7Pzdl5aShkqwKegVLTnJtDyOy/lfEge7R7o6SPQ9xWbHZFxHZxHTnksIL
         vB9vMf8yvsbh5JHepUZz6NUPm+d7fIlUqJSCHyxZyBqWuWpyuWY+OBNaQXELgTheo/JT
         ip14LqGhkfCIFNcNzGi+WQ+LtBNOdnYBZHZzjlYqwNq5yqoYu/Sr+B1d06AOMP2y0Xee
         aUOQ==
X-Gm-Message-State: APjAAAWQ8iUULu10qM4Ke/bl89P0kMt5zkMn5f8seNdLueT6NikDQR0M
        7je6IhQa3fnFiC0rTtcTrLqvrQ==
X-Google-Smtp-Source: APXvYqx7lzxTnGWGjaeng/D0AmxDN0sbXibtIP9N/1xWHCtWxzjRIwBBBpoKT5wIKL65UjYBlbOMvA==
X-Received: by 2002:a1c:c911:: with SMTP id f17mr13362416wmb.73.1568626271694;
        Mon, 16 Sep 2019 02:31:11 -0700 (PDT)
Received: from apalos.home (athedsl-4503352.home.otenet.gr. [94.71.163.64])
        by smtp.gmail.com with ESMTPSA id s12sm53695217wra.82.2019.09.16.02.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 02:31:11 -0700 (PDT)
Date:   Mon, 16 Sep 2019 12:31:08 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        joergen.andreasen@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: Pass ndo_setup_tc slave
 callback to drivers
Message-ID: <20190916093108.GA28448@apalos.home>
References: <20190914011802.1602-1-olteanv@gmail.com>
 <20190914011802.1602-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914011802.1602-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Yes fixes my request on the initial RFC. Sorry for the delayed response.

On Sat, Sep 14, 2019 at 04:17:57AM +0300, Vladimir Oltean wrote:
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
> ---
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
