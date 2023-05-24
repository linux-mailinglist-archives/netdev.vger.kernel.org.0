Return-Path: <netdev+bounces-5186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5DE971017F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 01:05:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70FDC28143F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 23:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7088826;
	Wed, 24 May 2023 23:05:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0406087A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 23:05:40 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F026A1A1;
	Wed, 24 May 2023 16:05:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50db91640d3so2813791a12.0;
        Wed, 24 May 2023 16:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684969533; x=1687561533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3GxzgFxfx+TiykE1Xh7O/xgq+W33H38gTkL9jRqPtEs=;
        b=rrYsnM4KPn6tO5D7xGsfGPwlyWMsLT2AEb1zyF4C1gnFiH07WSRSz58+hy/oolz/vK
         8EnW0MBhN7noJvbAX4d/AXU9PNFDIAZIOv+JC2wxraLBkfTpCgtOUyNs+pTFYg79a516
         9Ggu5E5s0Ry6nnDYQzpEfuYNcJAXwW8ieD7lCqfmVdh00eEZxXpYdD0D1dAaAQ8gZvPX
         7EaQzCDqU5ZYNnK5djzJL9pXlAIMufaDqP2HjjU+3MySoAtb/oMsXteku2xHIHuw/sXB
         4JeLvXUpKkTtQ1bgOpGL/lAH7UaXkun6cbOdYK7vdI6Of7rgBBZTwaqUKF4mpoyLho3S
         PhKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684969533; x=1687561533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3GxzgFxfx+TiykE1Xh7O/xgq+W33H38gTkL9jRqPtEs=;
        b=A+u7onaKw6E24zwRO7KXnZ9rcysXF3YZ8axFQaRXVhk47pDVuN5HQutehFpDo8lEcO
         pObBH04ATqIH1Z0R/5gO3o9vNjK2nH6J7TeUuJ/xRzGymhoN6F0puzIHXLPUbn2GdlWO
         u+8sOXDS4RXDPsjHnVpYVQWFev24GMMGLV2awgeQdS1xhxvYm6zH/EkVWrgTaaIad7T3
         zE9sqVU48t2kvfm7KeSzAn2IkHK23OMSHyOyrE+NqgatFNoeEv8UVvWlASEEn26s9o5K
         EUxPJTNQ9AisAIuCaoX59KxNlVv2/fEkZJ8HAs51p5zZORdoPWf8FGZQL+HVk7pyoq2W
         MZzw==
X-Gm-Message-State: AC+VfDzlz2liq1PRJpN3UFfQXJsQJ4w2IEMo99bma6jfIVU/9eGDFFDR
	yk0zJGzoRxWlARbkZ4l2Me+IOnLVHzzjuw==
X-Google-Smtp-Source: ACHHUZ7Rqz2GAY35oKipEF/f4kZ9HSWyjBNdexIQnogNGNYtRhUG9pdKdSTq0qjRXerZPH2T40IDcg==
X-Received: by 2002:aa7:c3ca:0:b0:50d:f881:1afc with SMTP id l10-20020aa7c3ca000000b0050df8811afcmr2869223edr.23.1684969533077;
        Wed, 24 May 2023 16:05:33 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ay24-20020a056402203800b0050690bc07a3sm374208edb.18.2023.05.24.16.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 16:05:32 -0700 (PDT)
Date: Thu, 25 May 2023 02:05:30 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v3 4/4] net: phy: mscc: enable VSC8501/2 RGMII RX
 clock
Message-ID: <20230524230530.ahnoz6cfedcz4pri@skbuf>
References: <20230523153108.18548-1-david.epping@missinglinkelectronics.com>
 <20230523153108.18548-5-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523153108.18548-5-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 05:31:08PM +0200, David Epping wrote:
> By default the VSC8501 and VSC8502 RGMII/GMII/MII RX_CLK output is
> disabled. To allow packet forwarding towards the MAC it needs to be
> enabled.
> 
> For other PHYs supported by this driver the clock output is enabled
> by default.
> 
> Signed-off-by: David Epping <david.epping@missinglinkelectronics.com>
> ---

Fixes: d3169863310d ("net: phy: mscc: add support for VSC8502")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

