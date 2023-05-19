Return-Path: <netdev+bounces-3857-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C58867092DF
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B85F91C211CE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0AFB6123;
	Fri, 19 May 2023 09:21:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9493D611C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:21:20 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0D618C;
	Fri, 19 May 2023 02:21:19 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f576ba41dso122854666b.1;
        Fri, 19 May 2023 02:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684488077; x=1687080077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8FtU58ZSqUb//QETjnoWYvSe6+lYScaOwUjlDpCnasg=;
        b=U6fG4FHjn0kFNeJsljVk2PqisCNYdfOVHzYuyUb5chbStuXKVEfaKd/eLcXxSw0v9J
         DcjIO8jWx5829KvOEEoE50GWOJpxjjWuBauVP+9kuw6Thz8eculH0sFjUI5hhpEgrC8y
         pmZueQnwYvCHczLAt8AqwJ0JcFJSXbdGzdf2SI4TC4U6xddV+4BKPOBWF0SjsTiS8b8O
         3txL4Xn3H7mCNYIog8O7Ww21hJsloycn3b/z+B9phzMXiQjb938ZQpiQNmz9cmdWMQlr
         6joh9obIZFNGNAG/INdnBHUPB0fWmKzfVXU3d3o4OXza5KHa9oIYlKpb3INRCsNmXcbe
         jObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684488077; x=1687080077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8FtU58ZSqUb//QETjnoWYvSe6+lYScaOwUjlDpCnasg=;
        b=bwyqUAdF0ouGqU7nIeWp+mmk9xBvhCji26ecxw0qjmzvULecaWzVHxWTKLT7rUDSYS
         27AYltUqruz3P/Tw9BJuJGHXwgJxMfJZsE82xkhM14x227z4Vvwtn0fvOCdkTyK2Iyqw
         4Gma+lU+b3fgEiRcUiUokqq2Jk0EoP3mf0u2fDEQMV+6MBfoTYG26uamHG5tMasr3/q3
         D3v/ZXvCNs23Ad4XF2g5dxdgSA9KtXOtrQwsh+XLftDBygkwxgzctHngITfmIk/y6vlv
         NYQRK7MQGNNoN/pZ4lNc1G+K4m8bbCTDatTD8VSXskhoqOGMys2y8vDxFd3C+h2eIOz7
         k1kg==
X-Gm-Message-State: AC+VfDxqgR6ODIh68C7zwGT5RlrtyY2uxssdeqXayMcQwgu1OeJgTlJx
	4+krUvuCkTkRGkAqgj9BXwo=
X-Google-Smtp-Source: ACHHUZ7uQP2oWFfk3liIdwrQMOY9jrjMaEA9hME0wgeDbfs8ZELtcpXgdU2LqodQgfjd9GsZMeqflw==
X-Received: by 2002:a17:907:7291:b0:95f:969e:dc5a with SMTP id dt17-20020a170907729100b0095f969edc5amr916016ejc.30.1684488076655;
        Fri, 19 May 2023 02:21:16 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s20-20020a1709062ed400b0096efd44dbefsm2054633eji.1.2023.05.19.02.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 02:21:16 -0700 (PDT)
Date: Fri, 19 May 2023 12:21:14 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	kernel@pengutronix.de, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230519092114.jiunl3marjgxxkl2@skbuf>
References: <20230518092913.977705-1-o.rempel@pengutronix.de>
 <20230518092913.977705-1-o.rempel@pengutronix.de>
 <20230518092913.977705-2-o.rempel@pengutronix.de>
 <20230518092913.977705-2-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518092913.977705-2-o.rempel@pengutronix.de>
 <20230518092913.977705-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Oleksij,

On Thu, May 18, 2023 at 11:29:12AM +0200, Oleksij Rempel wrote:
> +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> +			      unsigned int mode, phy_interface_t interface,
> +			      struct phy_device *phydev, int speed, int duplex,
> +			      bool tx_pause, bool rx_pause)
> +{
> +	if (dsa_is_upstream_port(dev->ds, port))
> +		ksz8_upstream_link_up(dev, port, speed, duplex, tx_pause,
> +				     rx_pause);
> +}

Can we make phylink control independent of DSA switch tree topology please?
Whether the port goes towards the host or not has no saying in whether
it is an xMII port. DSA's phylink integration makes it possible to
connect the CPU port to the host SoC through a PHY + RJ45 cable, case in
which the xMII port could be used as a user port.

