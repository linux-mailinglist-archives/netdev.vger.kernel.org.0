Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA362459B4
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 23:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgHPV4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 17:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgHPV4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 17:56:34 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4D3C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:56:34 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id v22so10797225edy.0
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KA5z2NtIEOPTm6mIEtGlhhk+Q2EUatq73A29i6BcQzk=;
        b=oNG98V6cfrlKBcYkscy77LDBnCkc6mtQz0l2wZVoeOhHDdXGbhzqjeLiv0NHhBx7iY
         DXELG82VIpxzltu17lzhxltKhqvekOCJ/yYZ5iafa8usC39sl8JVlQ999/DT+0aXZhyx
         /4d4XcVeUC5xw+IKjm//WOCQF/I2n5g3KtFZ5Kt4ItXM8R7RlSukNv1yjutBndWBM0dS
         /pq83Eh+3F2gkInYse7Rqrie8yGBYazJoLFlfhXY09/LbZccPCQf7/PaWMBzPpyLqPl7
         641ekwTaaGmNOgRrmjfGEoBXHNykEtwO9cvqeKxaATj/lxkIFJOTmwUswWoGlHJo+P4y
         27yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KA5z2NtIEOPTm6mIEtGlhhk+Q2EUatq73A29i6BcQzk=;
        b=GTqMvgTT3UV3m3+z6914J7/dD5ZpC2yfbnwkOF4TwgHoGXOPHYQb+ctRg8uDntfqvE
         tZijqJ+EebX2+qa5Q7fn5w4s3WqLvy1i42O9+jeHtV6519AK6YB36L6SlvSYWkc7pDUY
         K1zGr6QG9KltAQadWba7d0gfOaO0QHW6p984QAD8O0OJDQBmfCuEsyX+e+48DyhVUKec
         Z7Y77WuEYNv9o73XXit//z6BSvWLX+KZla8GjihNPlpKx2bYCc/EZSO4ShVa0pTNMZKh
         QjWk7DRVZSdmVONxxpCVzvVrDM/8pzYXzblcvUTytjuZ1fiBsT9joPQf0jnTEDCWXQKr
         Ewlw==
X-Gm-Message-State: AOAM532O0cpr4Gpz/IRoj6p1rpXrKlySRYR2Zcc5sojTGnzDBTUN6DBP
        O5NQnSmnfaqA4C9tJowDr4Q=
X-Google-Smtp-Source: ABdhPJzTrC/CBU0uRU0zzdjMpwYNMZiGT6m1FxRSC75dmcCfbMaXGmE/N02SBy8gXTQC3S8hAWRcwA==
X-Received: by 2002:a05:6402:1386:: with SMTP id b6mr12126842edv.296.1597614993112;
        Sun, 16 Aug 2020 14:56:33 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id hk14sm12988525ejb.88.2020.08.16.14.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 14:56:32 -0700 (PDT)
Date:   Mon, 17 Aug 2020 00:56:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 6/7] net: dsa: wire up devlink info get
Message-ID: <20200816215630.l7rdynh4ymx426uq@skbuf>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-7-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816194316.2291489-7-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 09:43:15PM +0200, Andrew Lunn wrote:
> Allow the DSA drivers to implement the devlink call to get info info,
> e.g. driver name, firmware version, ASIC ID, etc.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/dsa.h |  5 ++++-
>  net/dsa/dsa2.c    | 21 ++++++++++++++++++---
>  2 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 8963440ec7f8..0e34193d15ba 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -612,11 +612,14 @@ struct dsa_switch_ops {
>  	bool	(*port_rxtstamp)(struct dsa_switch *ds, int port,
>  				 struct sk_buff *skb, unsigned int type);
>  
> -	/* Devlink parameters */
> +	/* Devlink parameters, etc */
>  	int	(*devlink_param_get)(struct dsa_switch *ds, u32 id,
>  				     struct devlink_param_gset_ctx *ctx);
>  	int	(*devlink_param_set)(struct dsa_switch *ds, u32 id,
>  				     struct devlink_param_gset_ctx *ctx);
> +	int	(*devlink_info_get)(struct dsa_switch *ds,
> +				    struct devlink_info_req *req,
> +				    struct netlink_ext_ack *extack);
>  
>  	/*
>  	 * MTU change functionality. Switches can also adjust their MRU through
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index c0ffc7a2b65f..860f2fb22fe0 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -21,9 +21,6 @@
>  static DEFINE_MUTEX(dsa2_mutex);
>  LIST_HEAD(dsa_tree_list);
>  
> -static const struct devlink_ops dsa_devlink_ops = {
> -};
> -
>  struct dsa_switch *dsa_switch_find(int tree_index, int sw_index)
>  {
>  	struct dsa_switch_tree *dst;
> @@ -382,6 +379,24 @@ static void dsa_port_teardown(struct dsa_port *dp)
>  	dp->setup = false;
>  }
>  
> +static int dsa_devlink_info_get(struct devlink *dl,
> +				struct devlink_info_req *req,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct dsa_switch *ds;
> +
> +	ds = dsa_devlink_to_ds(dl);
> +

Why not place the declaration and the assignment on a single line?

> +	if (ds->ops->devlink_info_get)
> +		return ds->ops->devlink_info_get(ds, req, extack);
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static const struct devlink_ops dsa_devlink_ops = {
> +	.info_get = dsa_devlink_info_get,
> +};
> +
>  static int dsa_switch_setup(struct dsa_switch *ds)
>  {
>  	struct dsa_devlink_priv *dl_priv;
> -- 
> 2.28.0
> 

Thanks,
-Vladimir
