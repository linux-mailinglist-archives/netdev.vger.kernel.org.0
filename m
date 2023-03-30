Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870C36D0941
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbjC3PS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjC3PS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:18:27 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEDB1710;
        Thu, 30 Mar 2023 08:17:12 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id cv11so23145pfb.8;
        Thu, 30 Mar 2023 08:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680189428;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FA0U4SDL///ujoD+6fvbnRqUso7ME0lB+YoiNxaqOGI=;
        b=UJt5cPqX/jeDEMgvvtO/bIu/rY84pX4TTSGLa9sv96HBWv6FuNb4McRgUzTTJGeIc0
         kVvy5hsCSlMj0M5DoEIi/MVOujYlVv0przbWCAqZ75bi27UkhnRDxVDfuRr6wW7SJbdS
         mM8QFhQBH72G3ye3NcU17k9mJVuns/Eju+DgBZ44g9Mtn6sqtPXqRDcxew08fsXAG/9F
         oy0HSoHMs2yzeytHD0mfQubKmJDKS0ehRoYYsgyVUCO27HTcLYyN03IFUxa1gtc5LYX/
         74AAMcZ/IPpqk8EcaQW3NNKOJfac36WJdjJTRt6ZaLBAQ4USolT/r5U2tyqbc/udynlk
         zK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680189428;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FA0U4SDL///ujoD+6fvbnRqUso7ME0lB+YoiNxaqOGI=;
        b=x34wLdQH+R4aWl7RkKDAhHyHBfZYD4WwOK2zOT+0XxDpRMJdnifw0sGZuG1ttCrUlV
         QYkXtBr4Ssnpl6sZvMt5XomUpbtKgmrwyog6HUiTQMDU8FiSVPDJ0JL9LBkXHse+FDox
         dJl4le8FcIdU5vgIgD5iUJcK8WQ7Hzfnom3ONOy99bvcYBWZWBPBnn81dCIWzS0JUeby
         8swdycgmp2wz6v6Ke+k9YqkbKuR7CXlZYHiqnRTcad/vFjI6Haf2G//w9gaLRlgZMMoX
         NbBKP6BM0bzNjwj4BqVo/ZMwjrPSWKACDW3605F2DIHBxqjW/jH5o1Eh1/2PaLpP7K9k
         h7Rw==
X-Gm-Message-State: AAQBX9einwFVwQjETtUACxRcB0iOMR+5l9RhcWyE37z1Oq8hli5QX7Ac
        Ju+vVzo3hYaY8dZVfv+f67c=
X-Google-Smtp-Source: AKy350YYZN1P0+j/psneCG5srWVzMywslgUD8SECnjWdVeqvONP9WYzN9b82cmaJYHUIQTAnNqG3Fg==
X-Received: by 2002:aa7:95ba:0:b0:625:e728:4c5b with SMTP id a26-20020aa795ba000000b00625e7284c5bmr19747261pfk.14.1680189427752;
        Thu, 30 Mar 2023 08:17:07 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w20-20020aa78594000000b0062604b7552fsm10791pfn.63.2023.03.30.08.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 08:17:07 -0700 (PDT)
Date:   Thu, 30 Mar 2023 18:16:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Alexis =?utf-8?Q?Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rzn1-a5psw: enable DPBU for CPU
 port and fix STP states
Message-ID: <20230330151653.atzd5ptacral6syx@skbuf>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
 <20230330083408.63136-1-clement.leger@bootlin.com>
 <20230330083408.63136-2-clement.leger@bootlin.com>
 <20230330083408.63136-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230330083408.63136-2-clement.leger@bootlin.com>
 <20230330083408.63136-2-clement.leger@bootlin.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit title: s/DPBU/BPDU/

On Thu, Mar 30, 2023 at 10:34:07AM +0200, Clément Léger wrote:
> Current there were actually two problems which made the STP support non
> working. First, the BPDU were disabled on the CPU port which means BDPUs

s/BDPU/BPDU/

> were actually dropped internally to the switch.

Separate patches for the 2 problems?

> TO fix that, simply enable

S/TO/To/

> BPDUs at management port level. Then, the a5psw_port_stp_set_state()
> should  have actually received BPDU while in LEARNING mode which was not
> the case. Additionally, the BLOCKEN bit does not actually forbid
> sending forwarded frames from that port. To fix this, add
> a5psw_port_tx_enable() function which allows to disable TX. However, while
> its name suggest that TX is totally disabled, it is not and can still
> allows to send BPDUs even if disabled. This can be done by using forced

s/allows/allow/

> forwarding with the switch tagging mecanism but keeping "filtering"

s/mecanism/mechanism/

> disabled (which is already the case). Which these fixes, STP support is now

s/Which/With/

> functional.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Have you considered adding some Fixes: tags and sending to the "net" tree?

>  drivers/net/dsa/rzn1_a5psw.c | 53 +++++++++++++++++++++++++++++-------
>  drivers/net/dsa/rzn1_a5psw.h |  4 ++-
>  2 files changed, 46 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 919027cf2012..bbc1424ed416 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -120,6 +120,22 @@ static void a5psw_port_mgmtfwd_set(struct a5psw *a5psw, int port, bool enable)
>  	a5psw_port_pattern_set(a5psw, port, A5PSW_PATTERN_MGMTFWD, enable);
>  }
>  
> +static void a5psw_port_tx_enable(struct a5psw *a5psw, int port, bool enable)
> +{
> +	u32 mask = A5PSW_PORT_ENA_TX(port);
> +	u32 reg = enable ? mask : 0;
> +
> +	/* Even though the port TX is disabled through TXENA bit in the
> +	 * PORT_ENA register it can still send BPDUs. This depends on the tag

s/register/register,/

> +	 * configuration added when sending packets from the CPU port to the
> +	 * switch port. Indeed, when using forced forwarding without filtering,
> +	 * even disabled port will be able to send packets that are tagged. This

s/port/ports/

> +	 * allows to implement STP support when ports are in a state were

s/were/where/

> +	 * forwarding traffic should be stopped but BPDUs should still be sent.

To be absolutely clear, when talking about BPDUs, is it applicable
effectively only to STP protocol frames, or to any management traffic
sent by tag_rzn1_a5psw.c which has A5PSW_CTRL_DATA_FORCE_FORWARD set?

> +	 */
> +	a5psw_reg_rmw(a5psw, A5PSW_CMD_CFG(port), mask, reg);
> +}
> +
>  static void a5psw_port_enable_set(struct a5psw *a5psw, int port, bool enable)
>  {
>  	u32 port_ena = 0;
> @@ -292,6 +308,18 @@ static int a5psw_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
>  	return 0;
>  }
>  
> +static void a5psw_port_learning_set(struct a5psw *a5psw, int port,
> +				    bool learning, bool blocked)
> +{
> +	u32 mask = A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port);
> +	u32 reg = 0;
> +
> +	reg |= !learning ? A5PSW_INPUT_LEARN_DIS(port) : 0;
> +	reg |= blocked ? A5PSW_INPUT_LEARN_BLOCK(port) : 0;
> +
> +	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
> +}

Would it be useful to have independent functions for "learning" and
"blocked", for when learning will be made configurable?

> +
>  static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int port,
>  					  bool set)
>  {
> @@ -344,28 +372,33 @@ static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
>  
>  static void a5psw_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
>  {
> -	u32 mask = A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port);
>  	struct a5psw *a5psw = ds->priv;
> -	u32 reg = 0;
> +	bool learn, block;
>  
>  	switch (state) {
>  	case BR_STATE_DISABLED:
>  	case BR_STATE_BLOCKING:
> -		reg |= A5PSW_INPUT_LEARN_DIS(port);
> -		reg |= A5PSW_INPUT_LEARN_BLOCK(port);
> -		break;
>  	case BR_STATE_LISTENING:
> -		reg |= A5PSW_INPUT_LEARN_DIS(port);
> +		block = true;
> +		learn = false;
> +		a5psw_port_tx_enable(a5psw, port, false);
>  		break;
>  	case BR_STATE_LEARNING:
> -		reg |= A5PSW_INPUT_LEARN_BLOCK(port);
> +		block = true;
> +		learn = true;
> +		a5psw_port_tx_enable(a5psw, port, false);
>  		break;
>  	case BR_STATE_FORWARDING:
> -	default:
> +		block = false;
> +		learn = true;
> +		a5psw_port_tx_enable(a5psw, port, true);
>  		break;
> +	default:
> +		dev_err(ds->dev, "invalid STP state: %d\n", state);
> +		return;
>  	}
>  
> -	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
> +	a5psw_port_learning_set(a5psw, port, learn, block);

To be consistent, could you add a "bool tx_enabled" and a single call to
a5psw_port_tx_enable() at the end? "block" could also be named "!rx_enabled"
for some similarity and clarity regarding what it does.

>  }
>  
>  static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
> @@ -673,7 +706,7 @@ static int a5psw_setup(struct dsa_switch *ds)
>  	}
>  
>  	/* Configure management port */
> -	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_DISCARD;
> +	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_ENABLE;
>  	a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg);
>  
>  	/* Set pattern 0 to forward all frame to mgmt port */
> diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
> index c67abd49c013..04d9486dbd21 100644
> --- a/drivers/net/dsa/rzn1_a5psw.h
> +++ b/drivers/net/dsa/rzn1_a5psw.h
> @@ -19,6 +19,8 @@
>  #define A5PSW_PORT_OFFSET(port)		(0x400 * (port))
>  
>  #define A5PSW_PORT_ENA			0x8
> +#define A5PSW_PORT_ENA_TX_SHIFT		0

either use it in the A5PSW_PORT_ENA_TX() definition, or remove it.

> +#define A5PSW_PORT_ENA_TX(port)		BIT(port)
>  #define A5PSW_PORT_ENA_RX_SHIFT		16
>  #define A5PSW_PORT_ENA_TX_RX(port)	(BIT((port) + A5PSW_PORT_ENA_RX_SHIFT) | \
>  					 BIT(port))
> @@ -36,7 +38,7 @@
>  #define A5PSW_INPUT_LEARN_BLOCK(p)	BIT(p)
>  
>  #define A5PSW_MGMT_CFG			0x20
> -#define A5PSW_MGMT_CFG_DISCARD		BIT(7)
> +#define A5PSW_MGMT_CFG_ENABLE		BIT(6)
>  
>  #define A5PSW_MODE_CFG			0x24
>  #define A5PSW_MODE_STATS_RESET		BIT(31)
> -- 
> 2.39.2
> 

