Return-Path: <netdev+bounces-9138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A357F7276EA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 553A92816F6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16F75394;
	Thu,  8 Jun 2023 05:51:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48F7628
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:51:57 +0000 (UTC)
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDD81707;
	Wed,  7 Jun 2023 22:51:56 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-25655c1fcf7so62212a91.0;
        Wed, 07 Jun 2023 22:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686203515; x=1688795515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=edezA4FlQa4yBPYDm1dMgz4cn5b7ZEoxxGt3/cZlG2A=;
        b=rrwSen/aCJnDP5iTTXhiDG2avnOdZi+PjlYNKqxrl3+vMeN3kLFgCq59LhyVnTrMP0
         dKiNDul7TSOoAs3BCpt99HLYmx5T6mV2ra9yFu2PI2ErRA9rfeerknUvxCCEqnQOQRS0
         4mzhM1PQUgBe4/AVI9UsoZ8lGZTsDlx0b7kNFA8ET3KSSylTRZEGh48lLiiRCM/liep3
         IVWT8ldRLgrqZ+7zDz30BwHpTItHF/d7VB6LdIjrUGQ4lHRWWD24/ELBUnD2yODxClCs
         xKY6V1q+UGut5nHQLFV4sZLiL+zsKKkzLOOtMfegBSw2k2x9RMqzXwJZpw1nFNoMXbuV
         HAoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686203515; x=1688795515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edezA4FlQa4yBPYDm1dMgz4cn5b7ZEoxxGt3/cZlG2A=;
        b=X0Lrzw6S8kHsSyYPfehF9R8wJRoFrHZR9iKlFFxr0TuyOHoSNS0upivB1dIexQWjBD
         54yybThvBI9b9hgffxAlbyiF0giNweywWhbL57UhfsXurtsM09uUCITabrHgmdBAT00e
         f80ldth/dx6hZR3aoXQOgZ6mn8N6ZLDK455IDCYcuEucn1tZhGCCRnHtnfA5BSV6DXy2
         3p9gufaQZyTZad0eA+Vb0N7116VznYMv4wyFs1SRtHMcni3NUQbv5XmD8NdnQSRkJGXw
         mvWeOe13ZZXnyzPZio9TlSK0/KGaZsxBkafFbapcgShKMuKJHkp/0bPXQNT49K6ldYD4
         R2CQ==
X-Gm-Message-State: AC+VfDxxLidSbVRwkKTj4EXB+JdVUt27Yv7zuR6/3b+DeSmUOBPbMRvL
	Y8oJUcpcqIKYFYQlWH0mpfk=
X-Google-Smtp-Source: ACHHUZ5SSWqD+2vo24pxwUlQz0AYKTMLPj89ezZzEUnDbXv5m+amO6MvVBxs1wpbc2X5cn9FB1J7Dg==
X-Received: by 2002:a17:90b:38c2:b0:259:c00a:8830 with SMTP id nn2-20020a17090b38c200b00259c00a8830mr4919307pjb.4.1686203515133;
        Wed, 07 Jun 2023 22:51:55 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id gt1-20020a17090af2c100b002591b957641sm433072pjb.41.2023.06.07.22.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 22:51:54 -0700 (PDT)
Date: Wed, 7 Jun 2023 22:51:52 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: micrel: Change to receive timestamp in the
 frame for lan8841
Message-ID: <ZIFseH84Cv1KSOtj@hoboy.vegasvil.org>
References: <20230607070948.1746768-1-horatiu.vultur@microchip.com>
 <ZIDCpPbCFCxKBV2k@hoboy.vegasvil.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIDCpPbCFCxKBV2k@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 10:47:16AM -0700, Richard Cochran wrote:
> On Wed, Jun 07, 2023 at 09:09:48AM +0200, Horatiu Vultur wrote:
> > +static long lan8841_ptp_do_aux_work(struct ptp_clock_info *ptp)
> > +{
> > +	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
> > +							ptp_clock_info);
> > +	struct skb_shared_hwtstamps *shhwtstamps;
> > +	struct timespec64 ts;
> > +	struct sk_buff *skb;
> > +	u32 ts_header;
> > +
> > +	while ((skb = skb_dequeue(&ptp_priv->rx_queue)) != NULL) {
> > +		lan8841_ptp_getseconds(ptp, &ts);
> 
> No need to call this once per frame.  It would be sufficent to call it
> once every 2 seconds and cache the result.

Okay, this is tricky.

- If you call lan8841_ptp_getseconds() after gathering the received
  frames, then the frame timestamps are clearly in the past WRT the
  call to getseconds.  That makes the wrap check simpler.  But the
  getseconds call really should be placed before the 'while' loop.

- If the Rx frame rate exceeds 1/second, then it would be more
  efficient to call getseconds every second, and cache the result.
  But then the wrap around check needs to account for the fact that
  the cached value may have occurred either before or after the frame
  timestamp.

I'll explain that second point when my brain wakes again...

Thanks,
Richard

