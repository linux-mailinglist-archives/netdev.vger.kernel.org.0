Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAC6511ECA
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbiD0R2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbiD0R2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:28:30 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC93580F1;
        Wed, 27 Apr 2022 10:25:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id k23so4795349ejd.3;
        Wed, 27 Apr 2022 10:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CjJJv/HW0W0z/VarlbGbcsPtyv0boVYsrKMhgc2MCQ4=;
        b=EQktnjL3YTHOusdLaEOhhMGmLEkhCF8DJyOmmO0JmYYRe1iGewG9mNs4zyGi/QfEpB
         cQ4xGWu5t7E4jBNieFbMpyYMIdTV7HvazVgeDLVaJBhG8EaLEHCAjwNoSgdZNQ+6sQbO
         vkfHRJ/DLP4P+39eihnyFbl8CeqkmcyXkKpkdG/aQXwBz5uuBUSW8su+GkF3Ncs1FwLY
         THIsbBseeSZ+3ocZMmGu6dYc+RekHkvcVl0zs0jD5ko84TzhMab2EVL33OIrdqifLVUd
         +uXtqZpYGpixASjoSVfq2ZdoqT+qHbGDaIXG7Cvcy9tvrhMm2cpPWCRtx0le2ls6I1Ka
         V4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CjJJv/HW0W0z/VarlbGbcsPtyv0boVYsrKMhgc2MCQ4=;
        b=q9SQ/pvuPDnmM22wyR9T3pX4kD/t6j2LcB/3kf6qgLaR7S3boBqUyMaIUK6vU2JCxv
         PV4qe4YvAbWdcISA9kyevfFJKCAHex6J5GgQUt/CXs2A2BjVIAKoHV2WcAv0GYdOl/zu
         M9Lwrp/gtJCVA1ouJ38PFk0wAIlNADc+zUZNiPxj3I23O5HbAkmG9GVoxsCYaxipJHsr
         8DRZM95b5OYentCCuTzuKzn9VkZA8AMgfV0KPc7Xan6w99N3bxS+K+MpUoXwvyh4Icwu
         mH3PtjjU+KcLKw1Y9BvASRsETcaRAi5pYqd+lKxJBVlwtmHPywrjEre5fsDQnuGWtxxL
         bMkA==
X-Gm-Message-State: AOAM533hELbfofGlq/3QbboUWbmYAY3CDYBzrLOzxvC6eDptnM9fyT+i
        MsojRBY5uak2QIWCqiSSFkvnlyG72po=
X-Google-Smtp-Source: ABdhPJyvqzIreW1w7c2WM0BP7M7meaKhOsxx0Nw79+KcMESI1+8narqGSZn0JGOKlHPrNBeMf4dQ9Q==
X-Received: by 2002:a17:907:3f82:b0:6df:919c:97a with SMTP id hr2-20020a1709073f8200b006df919c097amr27280082ejc.19.1651080316670;
        Wed, 27 Apr 2022 10:25:16 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id g11-20020a1709061e0b00b006eff90d9c18sm7087716ejj.92.2022.04.27.10.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 10:25:15 -0700 (PDT)
Date:   Wed, 27 Apr 2022 20:25:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        upstream@semihalf.com
Subject: Re: [net: PATCH] net: dsa: add missing refcount decrementation
Message-ID: <20220427172514.n4musn42dhygzbu2@skbuf>
References: <20220425094708.2769275-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425094708.2769275-1-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 11:47:08AM +0200, Marcin Wojtas wrote:
> After obtaining the "phy-handle" node, decrementing
> refcount is required. Fix that.
> 
> Fixes: a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed")
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  net/dsa/port.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 32d472a82241..cdc56ba11f52 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1620,8 +1620,10 @@ int dsa_port_link_register_of(struct dsa_port *dp)
>  			if (ds->ops->phylink_mac_link_down)
>  				ds->ops->phylink_mac_link_down(ds, port,
>  					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
> +			of_node_put(phy_np);
>  			return dsa_port_phylink_register(dp);
>  		}
> +		of_node_put(phy_np);
>  		return 0;
>  	}
>  
> -- 
> 2.29.0
> 

Thanks for the patch.

commit fc06b2867f4cea543505acfb194c2be4ebf0c7d3
Author: Miaoqian Lin <linmq006@gmail.com>
Date:   Wed Apr 20 19:04:08 2022 +0800

    net: dsa: Add missing of_node_put() in dsa_port_link_register_of

    The device_node pointer is returned by of_parse_phandle()  with refcount
    incremented. We should use of_node_put() on it when done.
    of_node_put() will check for NULL value.

    Fixes: a20f997010c4 ("net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed")
    Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
