Return-Path: <netdev+bounces-6045-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB879714877
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:23:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D370A280E5D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261C66AB1;
	Mon, 29 May 2023 11:23:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4013D9E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 11:23:40 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF210BE;
	Mon, 29 May 2023 04:23:38 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-5149c51fd5bso1855143a12.0;
        Mon, 29 May 2023 04:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685359417; x=1687951417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yOs5JIgeXI1mbtFp+7PNez8/KPhj8szOgzOuEmmTc6U=;
        b=k74dFq3WqjLW5o8VW/K0SdX4Ssw+UmrkFxWfEzcL25qMjW8e4mpPAy5VLJ4Asiqsv7
         tLgVVkiKU6V30c9Ii81oWtNQWRgpZ1eR4jfKa9MjRTEIBoIGZZxMuO1gVjCHrxJ3/xTV
         DRubZMnEXbCO4TsomWfBFoCguy7JCVUJiuUDS9lWB+FAYksAmMIo5a22MO7OvOh/IVlZ
         h7RTBO1CIW7FENS3aLlWmBftyCikgzBsjAgT5BW+M/0K2Mebmz/U6v9jpxpTCXLQUfqh
         M0jgHJfbNUmyQjnnq6Z4V2PIojlMdwf/UfOZbXwgdv+snZ18vkiNjWTWyj5NzAvbPs1I
         6D1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685359417; x=1687951417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yOs5JIgeXI1mbtFp+7PNez8/KPhj8szOgzOuEmmTc6U=;
        b=e92HJm3S9U0Dp4E1K6yy5VuKUGX1rTdx17QF2rb/5z7eqo5HjvITYJws09ey7rE5Oz
         CLHDUZ55V1WgntcIoSrGHMbffrhnixclWm4Ne24WPoI57NOUaqt2dcI3lmMvSLQ7Qlut
         cPV5IwJ2vqbPJojBM7Sozz9bqq+WTDEadVtIvGSrdCYmxXXD9yJkWwmUeVXphkBGr9YW
         QcTrc+BbRKLrVM/obuI8f8uGZmSvUfpJ6anSUowHyhGFYe92W/bh7c4jlspJkzKxvTTG
         ea9tNchB9BES6Qtb6XyqGkYUzFMfZmVaDbaf4BOXyiSTW8Fz9U87dz5u9Z1LSZPGBoYh
         SEYA==
X-Gm-Message-State: AC+VfDx58NUD5jQPf3VDioLQfIR979Oz7BiDoqs8t7ExOqGEx5NsGBkZ
	AGiULmjSFlqIh2qr6bQQyzs=
X-Google-Smtp-Source: ACHHUZ5QdtfY/0JeoHmyxNPlNBTIGZFEsFas9ZrpUncW3a7pVnzaEtJA1eotKmF1Hhs/hpwWC1RKpA==
X-Received: by 2002:a17:907:701:b0:965:6aff:4f02 with SMTP id xb1-20020a170907070100b009656aff4f02mr11378812ejb.41.1685359416757;
        Mon, 29 May 2023 04:23:36 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id cb23-20020a170906a45700b00965ddf2e221sm5825994ejb.93.2023.05.29.04.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 04:23:36 -0700 (PDT)
Date: Mon, 29 May 2023 14:23:34 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Lukasz Majewski <lukma@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020
 switches
Message-ID: <20230529112334.bkulgoiloe26w37g@skbuf>
References: <20230523142912.2086985-1-lukma@denx.de>
 <20230529110222.68887a31@wsk>
 <20230529105132.h673mnjddubl7und@skbuf>
 <20230529130314.0d4c474e@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529130314.0d4c474e@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 01:03:14PM +0200, Lukasz Majewski wrote:
> This I've replied to Andrew in a private mail.

Aha.

> The above question has been replied:
> https://lore.kernel.org/all/20230524145357.3928f261@wsk/
> 
> Do you have any more comments?

I don't have any comments.

