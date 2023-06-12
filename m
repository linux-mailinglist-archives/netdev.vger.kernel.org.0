Return-Path: <netdev+bounces-10126-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AA7572C5ED
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B4AD281103
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6777919BA9;
	Mon, 12 Jun 2023 13:28:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B0F18AF3
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:28:54 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAB11A1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:28:45 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-5149390b20aso7550423a12.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686576524; x=1689168524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BfN9uxpW5wuO1dwDB0JNZMoEkrjtFWs4Ft8SPWQY+X0=;
        b=L32Dw8kYfDXMbby68wpQ/XXrPn58T7HBNeedLQLBpKZbWjg8BxzBcRtHl5ooRsf0GZ
         Ap8skbBM1AhLpWnf4eBYIf2StYniFTm6rmL26tkw4eDNq+mdyH2Vl8uZllxNFaJTEwrj
         gqX1r6DQ34M2AYkynvBJ7UwhAucvMriDEaRn3vYTO0odzlP5Xhuujfe0HK2Xt6v27336
         qUGbKlEztKvKptZNlQtB2w7ZbjWABWUpNqPTzQ+kh51nzqUtyJwKAH6LA5t7ul2BhY23
         wexSLJVTLbxoJFkT315aHlYpMJf2tXrc/KqAY+n/qYWVpTu4+saPvNQ7xUTRem/7Sy1W
         2Ajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686576524; x=1689168524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfN9uxpW5wuO1dwDB0JNZMoEkrjtFWs4Ft8SPWQY+X0=;
        b=eUA5L+XvKgbIs5G+l8geslXKy30wuS8Se4LgHdypuJuJr9d67IkTaSx0vibaQ8rMD8
         cLMq6i8qK/cCzPnJcUzIiHWMVkDjB/yoAKRNvdwlDAiXNsRbgp+4z8w9CDJrcMzbzWFm
         Sr0c+lZwHRUgEY/fX26bE6M8bX68VLfWCReb9tAkiWf0umD9aIgGqX3eRR1HVpzCo8LI
         Jkxk0s1t7a/P9pxcv7iIf0VNCSJW4eUn1WZQsOfk+gXOHjXQqy7b9WEA52CRuoJNHkaH
         WwVqjUQq1sHEvy7s8SPhbcmSV+DeufFe4LxJoUyRMuBvNx3W70VHKcY55j0TWuflq9+p
         9VzA==
X-Gm-Message-State: AC+VfDymfYpjpad9yl9nuLSYG6BbeT1jopwZbUcp5NJHgeSPXoH1OQ4C
	KwZqmxcW9wA2fWh/wnywtPQ=
X-Google-Smtp-Source: ACHHUZ7oKx6Cy2gjanL89uM/Dlsyk8HkF428hRSyXT30cqpkaGRbqJJ2jjI9XXq20bZc+hEyuE0NGA==
X-Received: by 2002:aa7:c557:0:b0:516:9f9a:a3a with SMTP id s23-20020aa7c557000000b005169f9a0a3amr5768015edr.1.1686576524202;
        Mon, 12 Jun 2023 06:28:44 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y8-20020aa7c248000000b005164ae1c482sm5083355edo.11.2023.06.12.06.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 06:28:43 -0700 (PDT)
Date: Mon, 12 Jun 2023 16:28:41 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230612132841.xcrlmfhzhu5qazgk@skbuf>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612131707.GS12152@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 04:17:07PM +0300, Leon Romanovsky wrote:
> On Mon, Jun 12, 2023 at 03:37:18PM +0300, Vladimir Oltean wrote:
> > On Mon, Jun 12, 2023 at 02:59:25PM +0300, Leon Romanovsky wrote:
> > > As far as I can tell, the calls to .shutdown() and .remove() are
> > > mutually exclusive.
> > 
> > In this particular case, or in general?
> > 
> > In general they aren't. If the owning bus driver also implements its .shutdown()
> > as .remove(), then it will call the .remove() method of all devices on that bus.
> > That, after .shutdown() had already been called for those same children.
> 
> Can you please help me to see how? What is the call chain?
> 
> From what I see callback to ->shutdown() iterates over all devices in
> that bus and relevant bus will check that driver is bound prior to call
> to driver callback. In both cases, the driver is removed and bus won't
> call to already removed device.

The sequence of operations is:

* device_shutdown() walks the devices_kset backwards, thus shutting down
  children before parents
  * .shutdown() method of child gets called
  * .shutdown() method of parent gets called
    * parent implements .shutdown() as .remove()
      * the parent's .remove() logic calls device_del() on its children
        * .remove() method of child gets called

> If it does, it is arguably bug in bus logic, which needs to prevent such
> scenario.

It's just a consequence of how things work when you reuse the .remove() logic
for .shutdown() without thinking it through. It's a widespread pattern.

