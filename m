Return-Path: <netdev+bounces-5613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D16A4712418
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:55:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AAC828174A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7CF154BC;
	Fri, 26 May 2023 09:55:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDC415496
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:55:44 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A90F9E;
	Fri, 26 May 2023 02:55:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96f683e8855so71116766b.2;
        Fri, 26 May 2023 02:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685094940; x=1687686940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cf6s+pRtDPBWZvHwWYLt5G+cdZWXh4lFysYNJBncOIM=;
        b=EiWwmP/O7rlmQZ7mEXSsgAAapMTg6qODs7Jwglc3YXEBfnsgbNnSdLVfcuulzzGUQ/
         n2gilogO8U2iId0i5lYVx1Ll9wTvw/NfXMCKzLg+IcGWvhOtN5m8Pr7Y6QEg1tjG2C4V
         3BJAepfumdkC0DSJZBKVi5ZD2VZ9s6YJ2poGdNgSImROCDzq2eCR1Us/KGn553oyUd5j
         4YAvi4xZmEtQ9v1xOb12eU/gMDK5xGGDC7Sk5rB5pA28u7+hsSgmC5SVUIzy7ZTPdgaz
         DEkQxEz0zR+g31H/K6QWnh85gSvo5y5wyj5CdcgAPYBObtzOFGNB7HM/syGpQpTk7FAE
         w9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685094940; x=1687686940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cf6s+pRtDPBWZvHwWYLt5G+cdZWXh4lFysYNJBncOIM=;
        b=LZ99ZIW7NMuCjrT2Fou8abxIxmlNxJAmapCs55iW4eJCv78m/dgCV7ZIcMN3rFgLAL
         asJPQxzCq+I14YiDAWQ+v4CnvhlFZ8Z4140GOmDuWJDKVT/alu55YsYvMipq8qBpN6JM
         /UGbAzuMY0WYixLIJh7SL4z/Xjlc31r3rXG/awarxNztwMn44HU+jbgHC7XJ59dcH7nL
         E8qnmzMsOaop3WRqxjPoqngKPNpiBRT0Z/3TXoU2hSGQbQtJlUT7ln3tfqU0N0ZNl51M
         1cIgJnOmenZzvIh7lWydICcp3YhUtqT45hQO2HvtfPZ+wm7FhaTkLOfgFbSUZ5fufn/r
         1tTw==
X-Gm-Message-State: AC+VfDyl8+BdRcbWK+4Fhu4GZ/dqaWJ5c+zeXDSRAYD4spqiKP+qjvZg
	9znMgv6zVAmsKgSoY7rfTBM=
X-Google-Smtp-Source: ACHHUZ6ARSbGs0hULYC/9+Y/bupDEUqbiFVEFDBv3GQLEIGyMZEq/7359++XFIzJy43TKSl6rpG3NA==
X-Received: by 2002:a17:907:9627:b0:95e:d3f5:3d47 with SMTP id gb39-20020a170907962700b0095ed3f53d47mr1736888ejc.48.1685094939864;
        Fri, 26 May 2023 02:55:39 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id gz15-20020a170906f2cf00b00965ac8f8a3dsm1932065ejb.173.2023.05.26.02.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 02:55:39 -0700 (PDT)
Date: Fri, 26 May 2023 12:55:37 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v2 3/5] net: dsa: microchip: remove ksz_port:on
 variable
Message-ID: <20230526095537.yaa3dgn56rwioxcv@skbuf>
References: <20230526073445.668430-1-o.rempel@pengutronix.de>
 <20230526073445.668430-1-o.rempel@pengutronix.de>
 <20230526073445.668430-4-o.rempel@pengutronix.de>
 <20230526073445.668430-4-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526073445.668430-4-o.rempel@pengutronix.de>
 <20230526073445.668430-4-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 09:34:43AM +0200, Oleksij Rempel wrote:
> The only place where this variable would be set to false is the
> ksz8_config_cpu_port() function. But it is done in a bogus way:
> 
>  	for (i = 0; i < dev->phy_port_cnt; i++) {
> 		if (i == dev->phy_port_cnt) <--- will be never executed.
> 			break;
> 		p->on = 1;
> 
> So, we never have a situation where p->on = 0. In this case, we can just
> remove it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

