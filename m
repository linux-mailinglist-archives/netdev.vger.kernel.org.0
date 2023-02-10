Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F146925DA
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjBJS4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjBJS4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:56:35 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B2A77B86;
        Fri, 10 Feb 2023 10:56:33 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id dr8so18276637ejc.12;
        Fri, 10 Feb 2023 10:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Aj5NLYn89wFIFl6LVUFKw5kJYz+jFfWeozhTNvkByWw=;
        b=SVZcMeHDKoxsFFJbvZKcXY+aqNlWVO1dhQsJ87RWqWypw7ZF5Fb9yMzvf9hk9o+Fd/
         Z7l+/g40qYjrd0JMbTlC1fc0Uaepzymb5jlwoI1xyMqJwL1QD4wClTEuMxfUUAJrVKKD
         wsOG+2W8SXzH2Cr8894DR3Ffb9/oWxay77fVCqSjeiy35XJpcAiM3rTeCA7IIo+Kitky
         rJ+HYHc+Tpx+bxAQqX5D3x9CuqiPQuHoIeLhah09t6nsG6ZtE5F4hyS0G0npzSzuNX//
         Vaq5CsGuua36lZ30O/inHOm5PA+DRJeX7/7GLe5RWFafaHrlGGQNcuysq7mZScPLozbx
         Njqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aj5NLYn89wFIFl6LVUFKw5kJYz+jFfWeozhTNvkByWw=;
        b=FiMq/b8vNDRD5JiwTjbt1lSY0/T/5GvGxkzZkC8dUTNNRqyhsMzBSjGkc5tawUvAy+
         HU478xobT+JxECRXJ4doz8PruOfF+jf2ULuMJn304whG1d+ghb4U7dV7yQareSNCmvtP
         ua4j2CAA9NliWDoIrH8NqCTC+KG0MQMeleC2urZJ/L9t0jMinfDvbs+SSKZnOv5IWoKn
         0MoMlCwtCmAe8oixTClTBqoFbI6OcgUqju21AV7NJDTTin1+nqzZkpKmDTRqEnOfD0JK
         MNgHzzcbqxsdhgpGPj7JIcsg21YgvxyI4BVBQNFgXNbNo8PcTehEBZhaX0FXvShk3mhc
         NXBw==
X-Gm-Message-State: AO0yUKUej56Nu+PGpnN2FLdRtyg3fGghQ1kGyUHvv9C0XsG6znpQt+Ao
        WYfucORrR89LI7AxsEq/0Ro=
X-Google-Smtp-Source: AK7set+IEGgjGWCYJGmXAqIIlDYLy8RZZkqkt5ZmVwQCxpPqL4EDLvPs7dQeF6dQ6myRL7nSH8xX7w==
X-Received: by 2002:a17:906:801:b0:884:37fd:bf4c with SMTP id e1-20020a170906080100b0088437fdbf4cmr17274720ejd.19.1676055392414;
        Fri, 10 Feb 2023 10:56:32 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906500f00b0088f94272ce9sm2727241ejj.151.2023.02.10.10.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 10:56:31 -0800 (PST)
Date:   Fri, 10 Feb 2023 20:56:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Richard van Schagen <richard@routerhints.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Subject: Re: [PATCH net-next] net: dsa: mt7530: add support for changing DSA
 master
Message-ID: <20230210185629.gfbaibewnc5u3tgs@skbuf>
References: <20230210172942.13290-1-richard@routerhints.com>
 <20230210172942.13290-1-richard@routerhints.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230210172942.13290-1-richard@routerhints.com>
 <20230210172942.13290-1-richard@routerhints.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 08:29:43PM +0300, arinc9.unal@gmail.com wrote:
> From: Richard van Schagen <richard@routerhints.com>
> 
> Add support for changing the master of a port on the MT7530 DSA subdriver.
> 
> [ arinc.unal@arinc9.com: Wrote subject and changelog ]
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Richard van Schagen <richard@routerhints.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index b5ad4b4fc00c..04bb4986454e 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1072,6 +1072,38 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +mt7530_port_change_master(struct dsa_switch *ds, int port,
> +				       struct net_device *master,
> +				       struct netlink_ext_ack *extack)

alignment

> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	struct dsa_port *dp = dsa_to_port(ds, port);
> +	struct dsa_port *cpu_dp = master->dsa_ptr;
> +	int old_cpu = dp->cpu_dp->index;
> +	int new_cpu = cpu_dp->index;

I believe you need to reject LAG DSA masters.

> +
> +	mutex_lock(&priv->reg_mutex);
> +
> +	/* Move old to new cpu on User port */
> +	priv->ports[port].pm &= ~PCR_MATRIX(BIT(old_cpu));
> +	priv->ports[port].pm |= PCR_MATRIX(BIT(new_cpu));
> +
> +	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
> +		   priv->ports[port].pm);
> +
> +	/* Move user port from old cpu to new cpu */
> +	priv->ports[old_cpu].pm &= ~PCR_MATRIX(BIT(port));
> +	priv->ports[new_cpu].pm |= PCR_MATRIX(BIT(port));
> +
> +	mt7530_write(priv, MT7530_PCR_P(old_cpu), priv->ports[old_cpu].pm);
> +	mt7530_write(priv, MT7530_PCR_P(new_cpu), priv->ports[new_cpu].pm);

- who writes to the "pm" field of CPU ports?
- how does this line up with your other patch which said (AFAIU) that
  the port matrix of CPU ports should be 0 and that should be fine?
- read/modify/write (rmw) using PCR_MATRIX_MASK rather than mt7530_write().
  That overwrites the other PCR fields.

> +
> +	mutex_unlock(&priv->reg_mutex);
> +
> +	return 0;
> +}
> +
>  static int
>  mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  {
> @@ -3157,6 +3189,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
>  	.set_ageing_time	= mt7530_set_ageing_time,
>  	.port_enable		= mt7530_port_enable,
>  	.port_disable		= mt7530_port_disable,
> +	.port_change_master	= mt7530_port_change_master,
>  	.port_change_mtu	= mt7530_port_change_mtu,
>  	.port_max_mtu		= mt7530_port_max_mtu,
>  	.port_stp_state_set	= mt7530_stp_state_set,
> -- 
> 2.37.2
> 

