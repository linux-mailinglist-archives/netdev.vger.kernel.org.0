Return-Path: <netdev+bounces-4102-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C088570AE0C
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 14:29:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BAA81C208EB
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 12:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C7B20F3;
	Sun, 21 May 2023 12:29:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C661FA6
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 12:29:00 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7254D93;
	Sun, 21 May 2023 05:28:59 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f0678de80so919735366b.3;
        Sun, 21 May 2023 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684672138; x=1687264138;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HqR2EuARFe8tzhwU8P0Dyt/TUIF6fAHCbDr22HmtgIs=;
        b=SLtw20JQNgpsHOapcwkQKGgmrKMKL6L0Od+dlyLse4DhqO1oOZICQBtR6VZRURw5cm
         XY4Yulytk8GdrV4pWzW9fcL4xOQNqQ8jngsGNXHK65Z+MkvrW9m7jMF40dEiJ6Pf++nZ
         H696xDYOtUdN4aO/iWcRhcp1kDqLwpEppEwPWH1/HVgLpS6sWLyn/DjR/RLZs44ElZ60
         MZ7pH4fzN4tWjOFC8oDwBgLW0cGCU6mcqOjkQ1ijVYeBXVgtm+mHqZVgIow8MzOfhbL2
         3z8Wsu1WWeQKDOMytv1Y7UN8+lzU9+fH3qUrE7l7+ofufS06X4n18XSKsN3R23JN9yGu
         nGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684672138; x=1687264138;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqR2EuARFe8tzhwU8P0Dyt/TUIF6fAHCbDr22HmtgIs=;
        b=X741sDzLZLcxcgWo5RVqjpmMcclBKRlPhvYEu87Zr/10j1ZA/B4A9uNRyxYvEYsBWa
         3IKeFAfVly+HIXDFwLkm5o23qOriSvgftaYS0zHnc/YyAc7mKlyGPBsnKTp6ncNarStd
         wP/c9giJBVOWY409GyzGuEQHf9+av1O6EAtAEWYmSF45+gp3rJWd0RxnUBKL0cy+QyJz
         eUo5G26Yljf+h+o3LivR5B2nDRkbI/lDAQ/dhHNrXTsiRQgOI1NN0PpQ9zhm6zkuBvnR
         7Ut3wmi1oWVCgk+rXGd+xJFWATFw5XoDLe5Vl3UFNbE6RIWkYnB+YwwllPg8A3SdSTUR
         moEg==
X-Gm-Message-State: AC+VfDzZ6FzeRTfDjpQOQY9GIdVY6Z1Qh6KuChHfWn8dmSqqTlq7RKCJ
	FjUUvvRqWTu3XWoq7zBacsI=
X-Google-Smtp-Source: ACHHUZ6SmxaC5xD7+/WAoHyWJvyVL074/XZtzIC/nDy+04VGNVOlAe8i8+2fkMzyfcw+xY0IJnLixw==
X-Received: by 2002:a17:906:5044:b0:96a:63d4:24c5 with SMTP id e4-20020a170906504400b0096a63d424c5mr7403271ejk.77.1684672137826;
        Sun, 21 May 2023 05:28:57 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y7-20020a170906518700b0096f55247570sm1855741ejk.0.2023.05.21.05.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 05:28:57 -0700 (PDT)
Date: Sun, 21 May 2023 15:28:55 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 2/3] net: phy: mscc: add support for VSC8501
Message-ID: <20230521122855.gykmg6a63hklyjbw@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-3-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-3-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520160603.32458-3-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-3-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 06:06:02PM +0200, David Epping wrote:
> The VSC8501 PHY can use the same driver implementation as the VSC8502.
> Adding the PHY ID and copying the handler functions of VSC8502 is
> sufficient to operate it.
> 
> Signed-off-by: David Epping <david.epping@missinglinkelectronics.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

