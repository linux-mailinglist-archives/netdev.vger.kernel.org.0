Return-Path: <netdev+bounces-5612-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 600A3712414
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04DB31C20C17
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A44154B5;
	Fri, 26 May 2023 09:54:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57087101F7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:54:42 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF67AA9;
	Fri, 26 May 2023 02:54:40 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-510e90d785fso699831a12.2;
        Fri, 26 May 2023 02:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685094879; x=1687686879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W4LLTisID6ZArwC9pPWjOyTEO98nNLz2NgV67bMxCZw=;
        b=Hu1PWpUWsToVHTHaxs0/+cOLsK/XpBnubMnKLqcS6jcbigjKzor9pzDtEFcPU82F2k
         gfYw1FaL1E0TkVLiOGhnwBNlaC8qdwXC8dzPKfHOA0cJC+f44wK8HR3LBtKjfYb8L2j2
         BIBNaKmk0O/j+u8XtCOpE6WHBMCH9P0r9iriPj5gjUUE2Pm90eNDj4llZmIqiMeYq/0j
         n+Awg/Kq/mZ9ePDWhb6Xdnuq9bHE8pkhN4gG2RffqVsp1dE1OpndwRvJG0L+pOLsHfpf
         /0JdaDJGQnW9iW8qPiGW51YuAt3d8BlJP7VwxJQ6OstKXHbFtgwHUACsXMC1W20FKnCs
         IEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685094879; x=1687686879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4LLTisID6ZArwC9pPWjOyTEO98nNLz2NgV67bMxCZw=;
        b=B/D14M0ba8ClfpOMOIFXe49VNVhaxHOeij3avObys2BHwtPz8ZYPH0BqazrfV+pXur
         eWeMQ8+MOyd4qprGePNibo4bhqFIPLhUhu3mry9+eoti8Tt/hugythC96jitvYjHqy/0
         r0Iwu93LRmnwW9vNRxD3sw8gSBDlTT/6TgVgYBK5fPxbI0YWKXJelv6zsCq9extwS6El
         H5qdWkU6A65S1CKtL/Izjs8ADciZLrIf9EypapXPqnM3NYlN+gjqC7O2OyP8Ird5Wcex
         a/Abp3Bzy2pGaSCl0lEbFMFlCcXz8BCdx7ZlEUf8G0xiD9WcXGtrBTXsrjnKtyTc2Qva
         3pQw==
X-Gm-Message-State: AC+VfDy2W5jWvGluddM9Pmr7rsFoFca62rq5r5CysHZG6hEKNq4ojVz4
	QYo3n+Sx/PY5GylFic5kWR8=
X-Google-Smtp-Source: ACHHUZ469jkIbu1fnw50ONMpvc1OJWI6cK3aVaGgxJ3mV/V/sPkL1KRk4cUHzyTIYMBTMAr9nAqwAQ==
X-Received: by 2002:a05:6402:7c6:b0:514:7afc:67d4 with SMTP id u6-20020a05640207c600b005147afc67d4mr419435edy.39.1685094878921;
        Fri, 26 May 2023 02:54:38 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z16-20020aa7d410000000b00506addaaab0sm1369797edq.32.2023.05.26.02.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 02:54:38 -0700 (PDT)
Date: Fri, 26 May 2023 12:54:36 +0300
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
Subject: Re: [PATCH net-next v2 4/5] net: dsa: microchip: ksz8: Prepare
 ksz8863_smi for regmap register access validation
Message-ID: <20230526095436.j5vrcevul2p3557c@skbuf>
References: <20230526073445.668430-1-o.rempel@pengutronix.de>
 <20230526073445.668430-5-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526073445.668430-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 09:34:44AM +0200, Oleksij Rempel wrote:
> This patch prepares the ksz8863_smi part of ksz8 driver to utilize the
> regmap register access validation feature.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

