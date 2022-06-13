Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5C9548347
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbiFMJXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbiFMJW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:22:58 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA29413E12;
        Mon, 13 Jun 2022 02:22:54 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id n10so9952302ejk.5;
        Mon, 13 Jun 2022 02:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xqopTaT/PEVAdsFQ3thhCPOb+zZPEkFQt3o2zW4Y79w=;
        b=Dt2RMH9tX27Rn2sLmR4EF86hfGg34aUKXrBAqDDpP/54gNzpOHgddSTmTfT3Hy6X7n
         9sfV9NKkjpNRcPKuwkHamn0KFZrUxczHsbXvX10Z5yASWerlkd6L13Z/fzfR/ZIBZyfO
         488y9c7lYVPsWgp5gKydu9P8zq/h/ha7OkPEctaH/v9G5I6vEbrsPvRp9qvqeZCXhZUr
         x430SZz7iL236gYdlDEjju8/DvMfwc2kx1C85vtWu87uI6kx6kRmbef2jo81qwQXfAQT
         SuDTeaOXnfrqaay7/5Qpm3XVm176PJSiJRaPPaRiJsh3Pd6Xn4cnTvXoNSYBcTnOu4ZB
         gRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xqopTaT/PEVAdsFQ3thhCPOb+zZPEkFQt3o2zW4Y79w=;
        b=UJLJwEOYeqnId268Fr0Koi84LDj6SvsSzN95nhnl1+NP+PiEJC1IHgV1wdsoj1JnNL
         p/14SR1d7MUTbgk8QPs+UfPAAhpZmPMImGh3Oa3loUOkTxJXboJf1YmwwxzTS0dxLuJa
         tGzfAj6ZudoHMCPy14LEQqFwzYQG4BbAKEQr9vrNnA+qPE84R5qGPj9Qc1cPIfYxlpP7
         dEeIQsbqXXnwAOfgAbmshOb45ceO3fOqA82HTnrCFd2JYOQV5Rok7gOQ1rpjh9RgljWs
         ypopvz6ONnXIvLtKTImyyddWh2GbuLuqhbTaPSqAuArtp4ACt/kGMPx30MD7bCTWFmhM
         3o4g==
X-Gm-Message-State: AOAM531VOT7gskozqvcQI2fDLOcjdGF3OXL0C+LUSINVVhNI4EzhH4Fb
        jv0yj9Ve2eXpFxZtD99JFQ4=
X-Google-Smtp-Source: ABdhPJytm+lgE99TqNDgwlB6q1T9lMMkOcaPixmjKcL9usBk3mpJVmKOe2x3j/ZVI/GZjwVr1VSVaQ==
X-Received: by 2002:a17:906:7791:b0:712:1c42:777a with SMTP id s17-20020a170906779100b007121c42777amr15790302ejm.68.1655112172896;
        Mon, 13 Jun 2022 02:22:52 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id kb17-20020a170907925100b006f3ef214e63sm3591722ejb.201.2022.06.13.02.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:22:52 -0700 (PDT)
Date:   Mon, 13 Jun 2022 12:22:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next v2 03/15] net: dsa: microchip: move
 tag_protocol & phy read/write to ksz_common
Message-ID: <20220613092250.jx6fonocr6pudppn@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:45PM +0530, Arun Ramadoss wrote:
> This patch move the dsa hook get_tag_protocol to ksz_common file. And
> the tag_protocol is returned based on the dev->chip_id.
> ksz8795 and ksz9477 implementation on phy read/write hooks are
> different. This patch modifies the ksz9477 implementation same as
> ksz8795 by updating the ksz9477_dev_ops structure.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

It would be easier to review if you would split the phy_read/phy_write
change from the get_tag_protocol change.

>  drivers/net/dsa/microchip/ksz8795.c    | 13 +--------
>  drivers/net/dsa/microchip/ksz9477.c    | 37 ++++++++------------------
>  drivers/net/dsa/microchip/ksz_common.c | 24 +++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.h |  2 ++
>  4 files changed, 38 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 927db57d02db..6e5f665fa1f6 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -898,17 +898,6 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
>  	}
>  }
>  
> -static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
> -						   int port,
> -						   enum dsa_tag_protocol mp)
> -{
> -	struct ksz_device *dev = ds->priv;
> -
> -	/* ksz88x3 uses the same tag schema as KSZ9893 */
> -	return ksz_is_ksz88x3(dev) ?
> -		DSA_TAG_PROTO_KSZ9893 : DSA_TAG_PROTO_KSZ8795;
> -}
> -
>  static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
>  {
>  	/* Silicon Errata Sheet (DS80000830A):
> @@ -1394,7 +1383,7 @@ static void ksz8_get_caps(struct dsa_switch *ds, int port,
>  }
>  
>  static const struct dsa_switch_ops ksz8_switch_ops = {
> -	.get_tag_protocol	= ksz8_get_tag_protocol,
> +	.get_tag_protocol	= ksz_get_tag_protocol,
>  	.get_phy_flags		= ksz8_sw_get_phy_flags,
>  	.setup			= ksz8_setup,
>  	.phy_read		= ksz_phy_read16,
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 7d3c8f6908b6..4fb96e53487e 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -276,21 +276,8 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
>  	mutex_unlock(&mib->cnt_mutex);
>  }
>  
> -static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
> -						      int port,
> -						      enum dsa_tag_protocol mp)
> +static void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
>  {
> -	enum dsa_tag_protocol proto = DSA_TAG_PROTO_KSZ9477;
> -	struct ksz_device *dev = ds->priv;
> -
> -	if (dev->features & IS_9893)
> -		proto = DSA_TAG_PROTO_KSZ9893;
> -	return proto;
> -}
> -
> -static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
> -{
> -	struct ksz_device *dev = ds->priv;
>  	u16 val = 0xffff;
>  
>  	/* No real PHY after this. Simulate the PHY.
> @@ -335,24 +322,20 @@ static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
>  		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
>  	}
>  
> -	return val;
> +	*data = val;
>  }
>  
> -static int ksz9477_phy_write16(struct dsa_switch *ds, int addr, int reg,
> -			       u16 val)
> +static void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
>  {
> -	struct ksz_device *dev = ds->priv;
> -
>  	/* No real PHY after this. */
>  	if (addr >= dev->phy_port_cnt)
> -		return 0;
> +		return;
>  
>  	/* No gigabit support.  Do not write to this register. */
>  	if (!(dev->features & GBIT_SUPPORT) && reg == MII_CTRL1000)
> -		return 0;
> -	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
> +		return;
>  
> -	return 0;
> +	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
>  }
>  
>  static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
> @@ -1326,10 +1309,10 @@ static int ksz9477_setup(struct dsa_switch *ds)
>  }
>  
>  static const struct dsa_switch_ops ksz9477_switch_ops = {
> -	.get_tag_protocol	= ksz9477_get_tag_protocol,
> +	.get_tag_protocol	= ksz_get_tag_protocol,
>  	.setup			= ksz9477_setup,
> -	.phy_read		= ksz9477_phy_read16,
> -	.phy_write		= ksz9477_phy_write16,
> +	.phy_read		= ksz_phy_read16,
> +	.phy_write		= ksz_phy_write16,
>  	.phylink_mac_link_down	= ksz_mac_link_down,
>  	.phylink_get_caps	= ksz9477_get_caps,
>  	.port_enable		= ksz_enable_port,
> @@ -1417,6 +1400,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
>  	.cfg_port_member = ksz9477_cfg_port_member,
>  	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
>  	.port_setup = ksz9477_port_setup,
> +	.r_phy = ksz9477_r_phy,
> +	.w_phy = ksz9477_w_phy,
>  	.r_mib_cnt = ksz9477_r_mib_cnt,
>  	.r_mib_pkt = ksz9477_r_mib_pkt,
>  	.r_mib_stat64 = ksz_r_mib_stats64,
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 9057cdb5971c..a43b01c2e67f 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -930,6 +930,30 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
>  }
>  EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
>  
> +enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
> +					   int port, enum dsa_tag_protocol mp)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	enum dsa_tag_protocol proto;

Please choose a default value in case the dev->chip_id does not take any
of the branches, or at least do something to not return uninitialized
variables from the stack.

> +
> +	if (dev->chip_id == KSZ8795_CHIP_ID ||
> +	    dev->chip_id == KSZ8794_CHIP_ID ||
> +	    dev->chip_id == KSZ8765_CHIP_ID)
> +		proto = DSA_TAG_PROTO_KSZ8795;
> +
> +	if (dev->chip_id == KSZ8830_CHIP_ID ||
> +	    dev->chip_id == KSZ9893_CHIP_ID)
> +		proto = DSA_TAG_PROTO_KSZ9893;
> +
> +	if (dev->chip_id == KSZ9477_CHIP_ID ||
> +	    dev->chip_id == KSZ9897_CHIP_ID ||
> +	    dev->chip_id == KSZ9567_CHIP_ID)
> +		proto = DSA_TAG_PROTO_KSZ9477;
> +
> +	return proto;
> +}
> +EXPORT_SYMBOL_GPL(ksz_get_tag_protocol);
> +
>  static int ksz_switch_detect(struct ksz_device *dev)
>  {
>  	u8 id1, id2;
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index d16c095cdefb..f253f3f22386 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -231,6 +231,8 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
>  int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
>  void ksz_get_strings(struct dsa_switch *ds, int port,
>  		     u32 stringset, uint8_t *buf);
> +enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
> +					   int port, enum dsa_tag_protocol mp);
>  
>  /* Common register access functions */
>  
> -- 
> 2.36.1
> 

