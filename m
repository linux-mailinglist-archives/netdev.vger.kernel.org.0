Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89463511CE6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243268AbiD0Qnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243393AbiD0Qnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:43:52 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE1D67D05;
        Wed, 27 Apr 2022 09:40:40 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id y3so4505870ejo.12;
        Wed, 27 Apr 2022 09:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eYY7a5mrkl2bM/PSDJSC0NT9uuZ4Dsfa0rMHieAI4Eo=;
        b=UhOvn9DvCFVJJwJL7ZjXn67Xo+sMyPqMNao7HbyH8R3SVKkdEnj3h60SlkFPizLs3s
         8ayxZTUyJGzvFXvYbyzsoUEnlgkVL0xydjlDCoeKnZ6BG2uNNX8x+SWQt8DpPX1rU2qp
         PpLPoQphEBBsfRf6vgqWpSIx61xIObgGYuAR9rLoehMrdzaAsAvdMR1QHJdo10eU/xiM
         l/oA6TCVkS/1oflMiQiWDs9LJu+uR21U+yVn2UEqAp+HL2Unio9V7Iflr5T5i1Bhcv+j
         EcjQvEea0fTF/5CwSTo1dKBfRYZAgGmzICYnStPdqJ7Srk93YpbLsqbIr5Eap3AncLXt
         wKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eYY7a5mrkl2bM/PSDJSC0NT9uuZ4Dsfa0rMHieAI4Eo=;
        b=vz5wfPJpcZBXx6RzTZW6QV3o/VBZos80colPOSIUpgZ/0wDr1CC4GnEZJuDs3E3rSz
         FmIhNIZCKUkbyqxj6WY7UQ8qTty5Uab7k0FfqjjAfP9rUtrjR9AAvAR4CR9IIZKwTmqn
         UtWsegLJD7++YfzhMTx9TpQCze2MJDXSojjMZGUR5rXT/J/hVYcjfWUPzbLjD/27fSxE
         ulTs2gpKRpT8YGAH60c6zDvs3KPUTOBWiBdI0yfN4Lk6ij9rS4v66VOSdz4M8o7ByXBe
         Vy/xsIXO6hxXCUnaaRQXM+F9nvh24YuePP1treonUde6m6u0mt/pnAIL+ZG/BBbllxWk
         ULkw==
X-Gm-Message-State: AOAM531AS5ib3YHv/syq1l5S9qCv5S/6kE56Tios8FkA/yru845P/gpo
        fI0j1lEQkA9QAar8XAZu4tM=
X-Google-Smtp-Source: ABdhPJztncgZwGz2Ow3QWOzOVsARAsEDQ5KST7yUKFQu8jtQrou4CrTMQf7avORNyY8ZDY3IRJP6Ew==
X-Received: by 2002:a17:907:1c8f:b0:6e8:f898:63bb with SMTP id nb15-20020a1709071c8f00b006e8f89863bbmr28273177ejc.721.1651077639371;
        Wed, 27 Apr 2022 09:40:39 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id q3-20020a5085c3000000b0042617226f87sm1552140edh.16.2022.04.27.09.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:40:38 -0700 (PDT)
Date:   Wed, 27 Apr 2022 19:40:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [RFC patch net-next 1/3] net: dsa: ksz9477: port mirror sniffing
 limited to one port
Message-ID: <20220427164037.tpui4hm32hktasys@skbuf>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
 <20220427162343.18092-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427162343.18092-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 09:53:41PM +0530, Arun Ramadoss wrote:
> This patch limits the sniffing to only one port during the mirror add.
> And during the mirror_del it checks for all the ports using the sniff,
> if and only if no other ports are referring, sniffing is disabled.
> The code is updated based on the review comments of LAN937x port mirror
> patch.
> https://patchwork.kernel.org/project/netdevbpf/patch/20210422094257.1641396-8-prasanna.vengateshan@microchip.com/
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

This probably needs:

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")

with the mention that it probably won't be backported too far due to the
dependency on 0148bb50b8fd ("net: dsa: pass extack to dsa_switch_ops ::
port_mirror_add()"). But this doesn't change what you should do.

You should send it towards the "net" tree (probably right now), wait
until the "net" pull request for this gets sent out, then "net" gets
merged back into "net-next", then you can continue your work with the
other patches.

>  drivers/net/dsa/microchip/ksz9477.c | 38 ++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 4f617fee9a4e..90ce789107eb 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -990,14 +990,32 @@ static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
>  				   bool ingress, struct netlink_ext_ack *extack)
>  {
>  	struct ksz_device *dev = ds->priv;
> +	u8 data;
> +	int p;
> +
> +	/* Limit to one sniffer port
> +	 * Check if any of the port is already set for sniffing
> +	 * If yes, instruct the user to remove the previous entry & exit
> +	 */
> +	for (p = 0; p < dev->port_cnt; p++) {
> +		/* Skip the current sniffing port */
> +		if (p == mirror->to_local_port)
> +			continue;
> +
> +		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
> +
> +		if (data & PORT_MIRROR_SNIFFER) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Sniffer port is already configured, delete existing rules & retry");
> +			return -EBUSY;
> +		}
> +	}
>  
>  	if (ingress)
>  		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
>  	else
>  		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
>  
> -	ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_SNIFFER, false);
> -
>  	/* configure mirror port */
>  	ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
>  		     PORT_MIRROR_SNIFFER, true);
> @@ -1011,16 +1029,28 @@ static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
>  				    struct dsa_mall_mirror_tc_entry *mirror)
>  {
>  	struct ksz_device *dev = ds->priv;
> +	bool in_use = false;
>  	u8 data;
> +	int p;
>  
>  	if (mirror->ingress)
>  		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
>  	else
>  		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
>  
> -	ksz_pread8(dev, port, P_MIRROR_CTRL, &data);
>  
> -	if (!(data & (PORT_MIRROR_RX | PORT_MIRROR_TX)))
> +	/* Check if any of the port is still referring to sniffer port */
> +	for (p = 0; p < dev->port_cnt; p++) {
> +		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
> +
> +		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
> +			in_use = true;
> +			break;
> +		}
> +	}
> +
> +	/* delete sniffing if there are no other mirroring rule exist */

Either "there are no other mirroring rules", or "no other mirroring rule
exists".

> +	if (!in_use)
>  		ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
>  			     PORT_MIRROR_SNIFFER, false);
>  }
> -- 
> 2.33.0
> 
