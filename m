Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425FB2A2BB2
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgKBNkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgKBNkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:40:23 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D522FC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 05:40:21 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id dg9so14337125edb.12
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 05:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fv0SrkZM/tWkTzXPyZ3hiNzTHju7rIwRyi8wIJIGItw=;
        b=ighJZ6cwkd9oQ/ecysy7oMOaj2k0hfo+6M5JwZxBknaZS5AnlSULK8PJWlSAWA5vMD
         lJ9rmScq+xXiWGUJXTOz6YhhfC1UoPKhX//0xEQTFFbAaOzabkjMx6NBu0gucUU6LG91
         jDzPajIQFrWY2bEQLqom9mh165my7dT6OC/+3n7VoL6LBZShC4Xr+VQs5AWLKb6+hpT9
         lGUo/i3/QALMBJSBHTenGeK908SLnzwHB/UqAymbKyucSUHXihj8E2vTsW3dd+0kQ1QC
         K+aib0Hbfa1GjPs6hikC9rinDKlb6md5IRDJa44E1LsmQRgBLSbVubyAOlpS8IpLjlXP
         7njQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fv0SrkZM/tWkTzXPyZ3hiNzTHju7rIwRyi8wIJIGItw=;
        b=L/KJ9xILdouW2h0v9acF8QxWZfgZ7mrzGk+DhsI0YeuPaIGoR4WhdUXvBZq1A39aMV
         f6Pf5lzWNn9YjE9TkrDXy0QrJ7aGWzxaKfca/299A8aUoGRf3NjJWZYnA4OXGN6a679F
         71Bj/sjtnEHh+gh/sAQTTyLUNlOCbfW2yXYY6Zs7tv8mGLiFiJ61RQgqFszsjV26PKGl
         jICCRxdnOYRCTYqI1kLS7fYIyus7h5N7OeLW3UONbF4a88bOazBY4KXxTYLzQEejJkGN
         s49TeImuUJxKaGQb+sc8de880xPp7UGzqK9Ezaps/s+wPFvl94SzDxbwRwD9Y9mRP3a1
         oKFA==
X-Gm-Message-State: AOAM531zB0v7QYWO2Bcj0caL/CwJoYns+btXO/rTGFhMy6jo4IlmXsZC
        fmWuphhZBKzrQ0CZCYLvmSA=
X-Google-Smtp-Source: ABdhPJy724Keg7H3Wy2lB3LJaqiUAz08li4xaUzRZvehFHm3T5zopyxmbLi2A6E2vCUVjGmyt5icAg==
X-Received: by 2002:a50:fc85:: with SMTP id f5mr16980010edq.187.1604324420587;
        Mon, 02 Nov 2020 05:40:20 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id d23sm6197828eds.48.2020.11.02.05.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 05:40:19 -0800 (PST)
Date:   Mon, 2 Nov 2020 15:40:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Chuanhong Guo <gch981213@gmail.com>
Subject: Re: [PATCH v2 net-next] net: dsa: mt7530: support setting MTU
Message-ID: <20201102134017.d7wj3io45n4sipc5@skbuf>
References: <20201102075821.26873-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102075821.26873-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 03:58:21PM +0800, DENG Qingfang wrote:
> MT7530/7531 has a global RX packet length register, which can be used
> to set MTU.
> 
> Supported packet length values are 1522 (1518 if untagged), 1536, 1552,
> and multiple of 1024 (from 2048 to 15360).
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> v1 -> v2:
> 	Avoid duplication of mt7530_rmw()
> 	Fix code wrapping
> ---
>  drivers/net/dsa/mt7530.c | 49 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/mt7530.h | 12 ++++++++++
>  2 files changed, 61 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index de7692b763d8..ca39f81de75a 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1021,6 +1021,53 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	struct mii_bus *bus = priv->bus;
> +	int length;
> +	u32 val;
> +
> +	/* When a new MTU is set, DSA always set the CPU port's MTU to the
> +	 * largest MTU of the slave ports. Because the switch only has a global
> +	 * RX length register, only allowing CPU port here is enough.
> +	 */
> +	if (!dsa_is_cpu_port(ds, port))
> +		return 0;
> +
> +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +
> +	val = mt7530_mii_read(priv, MT7530_GMACCR);
> +	val &= ~MAX_RX_PKT_LEN_MASK;
> +
> +	/* RX length also includes Ethernet header, MTK tag, and FCS length */
> +	length = new_mtu + ETH_HLEN + MTK_HDR_LEN + ETH_FCS_LEN;
> +	if (length <= 1522)
> +		val |= MAX_RX_PKT_LEN_1522;

Could you please fix the checkpatch warnings here?

> +	else if (length <= 1536)
> +		val |= MAX_RX_PKT_LEN_1536;
> +	else if (length <= 1552)
> +		val |= MAX_RX_PKT_LEN_1552;
> +	else {
> +		val &= ~MAX_RX_JUMBO_MASK;
> +		val |= MAX_RX_JUMBO(DIV_ROUND_UP(length, 1024));
> +		val |= MAX_RX_PKT_LEN_JUMBO;
> +	}
> +
> +	mt7530_mii_write(priv, MT7530_GMACCR, val);
> +
> +	mutex_unlock(&bus->mdio_lock);
> +
> +	return 0;
> +}
> +
