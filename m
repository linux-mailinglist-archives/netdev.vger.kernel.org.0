Return-Path: <netdev+bounces-3932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0AC7099B7
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25473281C44
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A995677;
	Fri, 19 May 2023 14:30:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4535910971
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:30:11 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C113EE1;
	Fri, 19 May 2023 07:30:09 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f7bf3cf9eso75228566b.0;
        Fri, 19 May 2023 07:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684506608; x=1687098608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CHMFMX7wtsHi+JJrcQ8ch2zghp9ED1gM5742JvmFaww=;
        b=B2g8iZifUNFvKgNeimRo3zeDViTd78RIcgwcNpZ4RGq0xmmFBEdXsDMnThk7a4zwKY
         Is+IRqo1VwcUV3pFm8TIqIeg9mE4Nf+cVRMJTfVwm/hC7KJ4zrzavmM+MOL0jvlzNUQS
         xmfIA1AMG3XXgCMWqPRhQwTxQiJQpxil+zs9cQ4RXJbqRdnNHd1RX2zvIbX345Kr1NIk
         5d5DiG/hJmCZsi0h/hNSFqo23il8oG1IsHA8XWoakB4SqUsZPy+PjEwAotqHq0g9Exxg
         AYVutobttq3ReW+fWl7P6sg2YbRuCEraQsVsqBOyFIvMFn+Qu+QeRLZzApJ5RQTQiStH
         4avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684506608; x=1687098608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHMFMX7wtsHi+JJrcQ8ch2zghp9ED1gM5742JvmFaww=;
        b=C4mooBB50gXuBHA7BvATk9cq/AtTWDNudEHEmd7VBA0vtr4mHMWr6ifWGyCt0CHVG6
         cTsEwL9g9eoNlCVC/J/2ywAB5YA4SWpUq/D/I1kZ5qepVVwHmErMIc+A7wCBxfQKUoI/
         jHMryCaQjfje1oZ0RiuAe+SO7ZbEEbs3QZ+NbBuPGk+3fD7oycggr8JTS5NCf2rMNVkx
         9SteqDEVUzspW3NbhI6nUFUOPNprBilQd7qiA2jAuBOC3uENlYSoIv+o2WWxabalbfdT
         3p/dOcluvav5EE1+8yi4hBAcuwB9SnkzkaJ75UNKjXQTc1VOrQB/KJMPkc8uagqffP8J
         cXWA==
X-Gm-Message-State: AC+VfDzch/HuR2eHJT36XJ2IIGuXpObzPITW4IS3pg5+BovE0kLqOhVa
	6SjEGFJ77aKuXnhu82HGSqM=
X-Google-Smtp-Source: ACHHUZ7XHe4FPALPkE+NJVS4vycDimRwcV+1rNKWOtb+cTJtBBGtJSf1vQahAwzgqzE5DWsgQWGHfw==
X-Received: by 2002:a17:907:5cd:b0:94e:46ef:1361 with SMTP id wg13-20020a17090705cd00b0094e46ef1361mr1648791ejb.34.1684506607763;
        Fri, 19 May 2023 07:30:07 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id gf3-20020a170906e20300b0096a16e49b0fsm2370805ejb.51.2023.05.19.07.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 07:30:07 -0700 (PDT)
Date: Fri, 19 May 2023 17:30:04 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Simon Horman <simon.horman@corigine.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v4 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230519143004.luvz73jiyvnqxk4y@skbuf>
References: <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519124700.635041-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:46:59PM +0200, Oleksij Rempel wrote:
> +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> +			      unsigned int mode, phy_interface_t interface,
> +			      struct phy_device *phydev, int speed, int duplex,
> +			      bool tx_pause, bool rx_pause)
> +{
> +	/* If the port is the CPU port, apply special handling. Only the CPU
> +	 * port is configured via global registers.
> +	 */
> +	if (dev->cpu_port == port)
> +		ksz8_cpu_port_link_up(dev, speed, duplex, tx_pause, rx_pause);
> +}

I'm sorry, but this is also baking in assumptions related to the
topology of the tree (that the xMII port is used as a CPU port).
The ksz8 driver may make this assumption in other places too,
but I don't want to make it even worse to fix. Is the
!dev->info->internal_phy[port] condition not enough here?

