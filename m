Return-Path: <netdev+bounces-10458-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4722B72E939
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41C6E1C203D8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25A530B85;
	Tue, 13 Jun 2023 17:19:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D578723C74
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:19:05 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80057E79;
	Tue, 13 Jun 2023 10:19:04 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-970056276acso868777266b.2;
        Tue, 13 Jun 2023 10:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686676743; x=1689268743;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p4QInf/d1L8SrPqwFR5Nj89qGLFRXPp6zO6OZlIHQOY=;
        b=fRqlzpWU0sB1qZKgBW/YPkCOytUilldw+41kk/32WY+fGxaTwcCqRZybOQN0kKd1aE
         /Vlf0oUArqmJ716Wmd7b8BfJNXpfa55k3XiEkoORkhnZh/M3hPsTUoxZs1f7XxP94ap3
         LL3W/w/DAzlzr2Rst2nIQtWMzz9QbBD4PEB5R9r2MqeJ5yecvzC99JtmEbtnqJenqJyL
         WManpolJT7MTTcgnCkggmPicvD0NXzIVGyCm1TO79agliz+eEtVywK10+F9CGqFcc/sS
         7MFcTJkMNer9H4tTi9XewEe+pmypjBtCr91JXRedcbhY66pzjLrwILwSt46mDl4egAGI
         Q4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686676743; x=1689268743;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p4QInf/d1L8SrPqwFR5Nj89qGLFRXPp6zO6OZlIHQOY=;
        b=mGlR+kmHgdkqfefTVrxPYz0sS/3/9Qgb/aa4YmfJsOi/rjPOmF1hbdQzMA9YZGKesx
         p4m4BqPlXIF08AQiySncPKcSx1w7BbeokgNmrUYpX+0E3AGSrXtyhKnPyxp0qb3bPdfe
         RAZ4UlvJgXU/APfRiXv1GAnmwkHGQ/8bAAIyaOFiZhzW9fI2DlFu4zKi49OuWzq/1Qpr
         W5lMCYxKn139BzSdXnOjKLGGUOAUeiSkGe3er09k6cHOpMZVrPwjeKOJ5Kg/DBBRBt07
         yv8MITMcI87F2bqPY18uySG0NQoU2vae1JKBFPq0MusnJJ7EEHU8K8GYOeAZjlQWUgdK
         jWgQ==
X-Gm-Message-State: AC+VfDyxwAk6QfkCEdZ0HEx9XT8K5yylUkifaNnoLV2tYQKyMB9GAjKd
	uuydYfcT0+Sl5EFpDaLnDZE=
X-Google-Smtp-Source: ACHHUZ6zfUkTuAU3Y4lSL0//vyjsHyipyXKX+QvaIbs+9xDbjGyhfOmJd9SogL6sZvqVdNkBipaIJQ==
X-Received: by 2002:a17:907:1b25:b0:974:5d36:f3a3 with SMTP id mp37-20020a1709071b2500b009745d36f3a3mr13305198ejc.27.1686676742570;
        Tue, 13 Jun 2023 10:19:02 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id um14-20020a170906cf8e00b00977d14d89fesm6878099ejb.34.2023.06.13.10.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 10:19:02 -0700 (PDT)
Date: Tue, 13 Jun 2023 20:18:58 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 08:14:35PM +0300, Arınç ÜNAL wrote:
> Actually, having only "net: dsa: introduce preferred_default_local_cpu_port
> and use on MT7530" backported is an enough solution for the current stable
> kernels.
> 
> When multiple CPU ports are defined on the devicetree, the CPU_PORT bits
> will be set to port 6. The active CPU port will also be port 6.
> 
> This would only become an issue with the changing the DSA conduit support.
> But that's never going to happen as this patch will always be on the kernels
> that support changing the DSA conduit.

Aha, ok. I thought that device trees with CPU port 5 exclusively defined
also exist in the wild. If not, and this patch fixes a theoretical only
issue, then it is net-next material.

