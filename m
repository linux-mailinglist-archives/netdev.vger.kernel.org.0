Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D414C7014
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbiB1Oxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiB1Oxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:53:38 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070073EA86
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 06:52:59 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id q17so17954548edd.4
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 06:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bLtOjJz5t6QqX/3psjbQNivX18lHtWlQ9Jubh9UH8uM=;
        b=J0QfvsUfKiIdOZti+djj3ZqGhcou1y5+0DxTlir7GFR2bPiThwzw7l/axPaEVob4Sp
         VoVRnf3sFO5sc72kP6beAgH3QcbK9H+ExrNrV9vIDjMPAYuWO9cfIRZx5Fvldw2GQVAo
         i0o70zsMEl5jMxr58/mh9MuQoRdDj1lX+tn0xtkDBd5yGEmoj6hZPEteBWCPo662X+s0
         TtIrFaVSOq5sNM0tyKXUF0MqKxzAxdUv82XEx7xnFMYOZuEyCojMUnyFd0uL7y+vcSu3
         W/M2WF0nZju319tfmG+Am6yT8qVDr2z1AwQSJb6D0u346U5eWQl6s4rwMa5PlpXDfiK1
         HGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bLtOjJz5t6QqX/3psjbQNivX18lHtWlQ9Jubh9UH8uM=;
        b=NxX0stJ2j/meh94syXd7ctPpnj3j56qCIYdTKMurEaV+yyQ1Ob2e0VO9mF0mU9qNGi
         1evFfqY0kQGQZKT9d8H2R3XK5ja58SbYO7P+hNpNzqXMRuq7JdJoCCvdtbpAxH4f/w+K
         DsjDB7Da6MOxXO3NhPnk/rGuKHoFXEM1OTbnCXuGOEK1Pmrt7sljorlYihQhDiQ7uvJ7
         SOZAEpQfp8y8QAw2tK1G8v4pEu0cGVwPieqxwOPPeBreoTi5fjjWgGaGr0oN2Ewyk7z2
         wGVRTtkxhksVqNhPN40k7tbIgvJWV/p80AGOhy+9TFKf87tlfzneVZxE4Tnw7/mNDwl9
         TnLQ==
X-Gm-Message-State: AOAM532khzOxcwxYDxZimA2i0raqZwsBn7tA2R2n6lCt+A+zYxGfXLRR
        BpqUzz4m0aQ0lgFuigutguZrPF86WBI=
X-Google-Smtp-Source: ABdhPJyl7rZK4T2Ax3nh/T8C2+8kikSZSeqsDyyza7YsB9nlmWWaV5cZ4zn1CUz1Ca3kJ6quuLNnKg==
X-Received: by 2002:a05:6402:2142:b0:413:6531:bd9e with SMTP id bq2-20020a056402214200b004136531bd9emr17763411edb.5.1646059977286;
        Mon, 28 Feb 2022 06:52:57 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id my14-20020a1709065a4e00b006be97e14e5csm4419054ejc.95.2022.02.28.06.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 06:52:56 -0800 (PST)
Date:   Mon, 28 Feb 2022 16:52:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v4 3/3] net: dsa: realtek: rtl8365mb: add
 support for rtl8_4t
Message-ID: <20220228145255.x6en5rldy2efkztc@skbuf>
References: <20220227035920.19101-1-luizluca@gmail.com>
 <20220227035920.19101-4-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220227035920.19101-4-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 27, 2022 at 12:59:20AM -0300, Luiz Angelo Daros de Luca wrote:
> The trailing tag is also supported by this family. The default is still
> rtl8_4 but now the switch supports changing the tag to rtl8_4t.
> 
> Reintroduce the dropped cpu in struct rtl8365mb (removed by 6147631).
> 
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  drivers/net/dsa/realtek/rtl8365mb.c | 82 +++++++++++++++++++++++------
>  1 file changed, 67 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index 2ed592147c20..ff865af65d55 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -566,6 +566,7 @@ struct rtl8365mb_port {
>   * @chip_ver: chip silicon revision
>   * @port_mask: mask of all ports
>   * @learn_limit_max: maximum number of L2 addresses the chip can learn
> + * @cpu: CPU tagging and CPU port configuration for this chip
>   * @mib_lock: prevent concurrent reads of MIB counters
>   * @ports: per-port data
>   * @jam_table: chip-specific initialization jam table
> @@ -580,6 +581,7 @@ struct rtl8365mb {
>  	u32 chip_ver;
>  	u32 port_mask;
>  	u32 learn_limit_max;
> +	struct rtl8365mb_cpu cpu;
>  	struct mutex mib_lock;
>  	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
>  	const struct rtl8365mb_jam_tbl_entry *jam_table;
> @@ -770,6 +772,16 @@ static enum dsa_tag_protocol
>  rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
>  			   enum dsa_tag_protocol mp)
>  {
> +	struct realtek_priv *priv = ds->priv;
> +	struct rtl8365mb_cpu *cpu;
> +	struct rtl8365mb *mb;
> +
> +	mb = priv->chip_data;
> +	cpu = &mb->cpu;
> +
> +	if (cpu->position == RTL8365MB_CPU_POS_BEFORE_CRC)
> +		return DSA_TAG_PROTO_RTL8_4T;
> +
>  	return DSA_TAG_PROTO_RTL8_4;
>  }
>  
> @@ -1725,8 +1737,10 @@ static void rtl8365mb_irq_teardown(struct realtek_priv *priv)
>  	}
>  }
>  
> -static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365mb_cpu *cpu)
> +static int rtl8365mb_cpu_config(struct realtek_priv *priv)
>  {
> +	struct rtl8365mb *mb = priv->chip_data;
> +	struct rtl8365mb_cpu *cpu = &mb->cpu;
>  	u32 val;
>  	int ret;
>  
> @@ -1752,6 +1766,42 @@ static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365m
>  	return 0;
>  }
>  
> +static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu_index,
> +					 enum dsa_tag_protocol proto)
> +{
> +	struct realtek_priv *priv = ds->priv;
> +	struct rtl8365mb_cpu *cpu;
> +	struct rtl8365mb *mb;
> +	int ret;
> +
> +	mb = priv->chip_data;
> +	cpu = &mb->cpu;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_RTL8_4:
> +		cpu->format = RTL8365MB_CPU_FORMAT_8BYTES;
> +		cpu->position = RTL8365MB_CPU_POS_AFTER_SA;
> +		break;
> +	case DSA_TAG_PROTO_RTL8_4T:
> +		cpu->format = RTL8365MB_CPU_FORMAT_8BYTES;
> +		cpu->position = RTL8365MB_CPU_POS_BEFORE_CRC;
> +		break;
> +	/* The switch also supports a 4-byte format, similar to rtl4a but with
> +	 * the same 0x04 8-bit version and probably 8-bit port source/dest.
> +	 * There is no public doc about it. Not supported yet and it will probably
> +	 * never be.
> +	 */
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	ret = rtl8365mb_cpu_config(priv);
> +	if (ret)
> +		return ret;

return rtl8365mb_cpu_config(...)

Don't forget to remove the "ret" variable when you update this.

> +
> +	return 0;
> +}
> +
>  static int rtl8365mb_switch_init(struct realtek_priv *priv)
>  {
>  	struct rtl8365mb *mb = priv->chip_data;
> @@ -1798,13 +1848,14 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
>  static int rtl8365mb_setup(struct dsa_switch *ds)
>  {
>  	struct realtek_priv *priv = ds->priv;
> -	struct rtl8365mb_cpu cpu = {0};
> +	struct rtl8365mb_cpu *cpu;
>  	struct dsa_port *cpu_dp;
>  	struct rtl8365mb *mb;
>  	int ret;
>  	int i;
>  
>  	mb = priv->chip_data;
> +	cpu = &mb->cpu;
>  
>  	ret = rtl8365mb_reset_chip(priv);
>  	if (ret) {
> @@ -1827,21 +1878,14 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  		dev_info(priv->dev, "no interrupt support\n");
>  
>  	/* Configure CPU tagging */
> -	cpu.trap_port = RTL8365MB_MAX_NUM_PORTS;
>  	dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
> -		cpu.mask |= BIT(cpu_dp->index);
> +		cpu->mask |= BIT(cpu_dp->index);
>  
> -		if (cpu.trap_port == RTL8365MB_MAX_NUM_PORTS)
> -			cpu.trap_port = cpu_dp->index;
> +		if (cpu->trap_port == RTL8365MB_MAX_NUM_PORTS)
> +			cpu->trap_port = cpu_dp->index;
>  	}
> -
> -	cpu.enable = cpu.mask > 0;
> -	cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
> -	cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
> -	cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
> -	cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
> -
> -	ret = rtl8365mb_cpu_config(priv, &cpu);
> +	cpu->enable = cpu->mask > 0;
> +	ret = rtl8365mb_cpu_config(priv);
>  	if (ret)
>  		goto out_teardown_irq;
>  
> @@ -1853,7 +1897,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
>  			continue;
>  
>  		/* Forward only to the CPU */
> -		ret = rtl8365mb_port_set_isolation(priv, i, cpu.mask);
> +		ret = rtl8365mb_port_set_isolation(priv, i, cpu->mask);
>  		if (ret)
>  			goto out_teardown_irq;
>  
> @@ -1983,6 +2027,12 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
>  		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
>  		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
>  
> +		mb->cpu.trap_port = RTL8365MB_MAX_NUM_PORTS;
> +		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
> +		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
> +		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
> +		mb->cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
> +
>  		break;
>  	default:
>  		dev_err(priv->dev,
> @@ -1996,6 +2046,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
>  
>  static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
>  	.get_tag_protocol = rtl8365mb_get_tag_protocol,
> +	.change_tag_protocol = rtl8365mb_change_tag_protocol,
>  	.setup = rtl8365mb_setup,
>  	.teardown = rtl8365mb_teardown,
>  	.phylink_get_caps = rtl8365mb_phylink_get_caps,
> @@ -2014,6 +2065,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
>  
>  static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
>  	.get_tag_protocol = rtl8365mb_get_tag_protocol,
> +	.change_tag_protocol = rtl8365mb_change_tag_protocol,
>  	.setup = rtl8365mb_setup,
>  	.teardown = rtl8365mb_teardown,
>  	.phylink_get_caps = rtl8365mb_phylink_get_caps,
> -- 
> 2.35.1
> 

