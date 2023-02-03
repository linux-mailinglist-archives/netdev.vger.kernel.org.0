Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B9068A6E1
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjBCXZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjBCXZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:25:05 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA8EA911F;
        Fri,  3 Feb 2023 15:24:46 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id me3so19527256ejb.7;
        Fri, 03 Feb 2023 15:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=csKQHGTTXE8SV3C6vkHB0k0M5WYpXzXMlTtAejEAmog=;
        b=h6Ufv2PcunmtUPuTUVhXQPF6ZifkNKaiL+Xv8u9FYFodXMXcFVqZWUOBT6bm6L3KFP
         2Z5TUDgi2613XxRhNsC2mVPkcxiwuXWemDZ7FCpxQvEJBLiEaZlv9W7NG5ku7L+Fhi2V
         ER+t8bNkEtHuXXZ55tE/c7e8/JCSgLbGozhZmNLOt1JfoNGrQWIfEQp4q4YyIVOC5g24
         zz6FNXuKAFgHRey675Z9jQ9MVXiZ8oIW5K5QRsO2YAOhobmQMPDiK/c6VuYeCKQxNQyP
         HIgKXNN1MIdNub62xta/0dKIF16I0RhQq2MjVYULnW9ZEZI/CSheSZe1Ie3zAfRYZLw8
         DncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csKQHGTTXE8SV3C6vkHB0k0M5WYpXzXMlTtAejEAmog=;
        b=P7Z6x3iVjjGj13K+lZfHNzBNftO4KuP51KaGiyCK/XTDPrLrIrnkiviOM0pPSep41/
         +UPRYxpHirOMfpi5hHCeBi3HxBPiMnm2gXRqKTZQ0gxk0N5fhfF/1y3LlT3zb+wV++VJ
         7t/TfsHkog8Dwql6YXkAiu6N0485peAsqwJ3EPYGjwg+sbbDCRRtjcd1PLbsUwD6nzji
         Gk7zMr3kbf8Gmm8Pbj0ktghkENbWS+ynzmtFQ31oyI8QnZtx+awVDJ/fL6cWHRZEArOK
         WujqpuzCvMuI4AT+uTci+2xiswfdmborGVfqGXal7EEgK+nlF1NakXrTPJkABUiSReeL
         DJxQ==
X-Gm-Message-State: AO0yUKXLUEhf4rp9O8eb1dprUbsEqdWRWRN9Y7PqOTrUnJkIJoMDAdLH
        SXJopDO1o/TgQkjZq6+NR1E=
X-Google-Smtp-Source: AK7set/HUtKLQ/AI50EqkDXqXTtd2rmtkvCxV48VFGkTRWWy2n5Lm1fi3chCqFZO/M+QL76q8HJA7Q==
X-Received: by 2002:a17:906:6a24:b0:888:d373:214d with SMTP id qw36-20020a1709066a2400b00888d373214dmr15746435ejc.29.1675466684862;
        Fri, 03 Feb 2023 15:24:44 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id 13-20020a170906004d00b008512e1379dbsm2042615ejg.171.2023.02.03.15.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 15:24:44 -0800 (PST)
Date:   Sat, 4 Feb 2023 01:24:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 03/11] net: dsa: microchip: lan937x: enable
 cascade port
Message-ID: <20230203232442.hhfgebj4rppmh5nn@skbuf>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-4-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-4-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-4-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-4-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:22PM +0530, Rakesh Sankaranarayanan wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index aab60f2587bf..c3c3eee178f4 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -147,6 +147,7 @@ struct ksz_device {
>  	u32 chip_id;
>  	u8 chip_rev;
>  	int cpu_port;			/* port connected to CPU */
> +	int dsa_port;                   /* Port used as cascaded port */

nitpick: since "dsa_port" is typically a keyword that I use for the DSA
framework's generic port structure (struct dsa_port *dp), I would appreciate
if you could name this in some other way, like "cascade_port". I don't
believe the explanatory comment would even be necessary in that case.
And btw, the comment is inconsistent in alignment (tabs vs spaces) with
the line immediately above it.

>  	u32 smi_index;
>  	int phy_port_cnt;
>  	phy_interface_t compat_interface;
> @@ -358,6 +359,7 @@ struct ksz_dev_ops {
>  	void (*setup_rgmii_delay)(struct ksz_device *dev, int port);
>  	int (*tc_cbs_set_cinc)(struct ksz_device *dev, int port, u32 val);
>  	void (*config_cpu_port)(struct dsa_switch *ds);
> +	void (*config_dsa_port)(struct dsa_switch *ds);
>  	int (*enable_stp_addr)(struct ksz_device *dev);
>  	int (*reset)(struct ksz_device *dev);
>  	int (*init)(struct ksz_device *dev);
> diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
> index 3388d91dbc44..ef84abc31556 100644
> --- a/drivers/net/dsa/microchip/lan937x.h
> +++ b/drivers/net/dsa/microchip/lan937x.h
> @@ -11,6 +11,7 @@ int lan937x_setup(struct dsa_switch *ds);
>  void lan937x_teardown(struct dsa_switch *ds);
>  void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
>  void lan937x_config_cpu_port(struct dsa_switch *ds);
> +void lan937x_config_dsa_port(struct dsa_switch *ds);
>  int lan937x_switch_init(struct ksz_device *dev);
>  void lan937x_switch_exit(struct ksz_device *dev);
>  int lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 399a3905e6ca..5108a3f4bf76 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -205,11 +205,42 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  	dev->dev_ops->cfg_port_member(dev, port, member);
>  }
>  
> +void lan937x_config_dsa_port(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct dsa_port *dp;
> +
> +	dev->dsa_port = 0xFF;
> +
> +	dsa_switch_for_each_port(dp, ds) {
> +		if (dsa_is_dsa_port(ds, dp->index)) {

Would be good if you introduced dsa_switch_for_each_dsa_port() as a
separate patch, and used it here first.

Not sure if you realize this, but dsa_is_dsa_port() contains a list
iteration hidden in it, in dsa_to_port(). So dsa_switch_for_each_port()
-> dsa_is_dsa_port() effectively does an O(n^2) list walk (apart from
uselessly increasing the code indentation).

> +			ksz_rmw32(dev, REG_SW_CASCADE_MODE_CTL,
> +				  CASCADE_PORT_SEL, dp->index);
> +			dev->dsa_port = dp->index;
> +
> +			/* Tail tag should be enabled for switch 0
> +			 * in cascaded connection.
> +			 */
> +			if (dev->smi_index == 0) {
> +				lan937x_port_cfg(dev, dp->index, REG_PORT_CTRL_0,
> +						 PORT_TAIL_TAG_ENABLE, true);
> +			}
> +
> +			/* Frame check length should be disabled for cascaded ports */
> +			lan937x_port_cfg(dev, dp->index, REG_PORT_MAC_CTRL_0,
> +					 PORT_CHECK_LENGTH, false);

break?

> +		}
> +	}
> +}
> +
>  void lan937x_config_cpu_port(struct dsa_switch *ds)
>  {
>  	struct ksz_device *dev = ds->priv;
>  	struct dsa_port *dp;
>  
> +	/* Initializing cpu_port parameter into invalid value */
> +	dev->cpu_port = 0xFF;
> +
>  	dsa_switch_for_each_cpu_port(dp, ds) {
>  		if (dev->info->cpu_ports & (1 << dp->index)) {
>  			dev->cpu_port = dp->index;
> diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
> index 45b606b6429f..4f30bc12f7a9 100644
> --- a/drivers/net/dsa/microchip/lan937x_reg.h
> +++ b/drivers/net/dsa/microchip/lan937x_reg.h
> @@ -32,6 +32,9 @@
>  #define REG_SW_PORT_INT_STATUS__4	0x0018
>  #define REG_SW_PORT_INT_MASK__4		0x001C
>  
> +#define REG_SW_CASCADE_MODE_CTL         0x0030
> +#define CASCADE_PORT_SEL                7
> +
>  /* 1 - Global */
>  #define REG_SW_GLOBAL_OUTPUT_CTRL__1	0x0103
>  #define SW_CLK125_ENB			BIT(1)
> -- 
> 2.34.1
> 

