Return-Path: <netdev+bounces-2678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FE97030B2
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9A682811E8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AECED2E9;
	Mon, 15 May 2023 14:56:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8C4C8F7
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 14:56:49 +0000 (UTC)
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B718F1FE9
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:56:28 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-30786c87cdaso10091671f8f.2
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684162587; x=1686754587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UKdQljelele47fGhlCDtFyRrYOqvsvKHSxZYQmiGNRs=;
        b=Hn29fxuNMyby+YmQYnHiOhftbcHGmxehKzHtB7YzQD7v/sceIbhluaRt8wSdlJJJWW
         rYxh0eyDlDa3kfYLGhU0UbUOBzmTKnmuDJaUeb6gs8Cg3XSI32vksTKtxZ/DPf+Wv/jz
         6g7f33Af+mM8iEK5njYrtDiH+fb///gfth7NgjgLVYobaoY6p/ugrq3V+8CUQOLiJ4jm
         o0ej63/zA/PuxrUudmBd2t5GWqb5iX2lr2pfM36Mm3DYvZXLV+XD6oeihMT07MIw1tct
         7ztFaxRSccEK503l2NlgWVizWJ0tgN66uJnr011LOYo/QivoD2AH9G9y2QVT+33V7JP2
         /vzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684162587; x=1686754587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UKdQljelele47fGhlCDtFyRrYOqvsvKHSxZYQmiGNRs=;
        b=apsNlq2yeVDnN1to3sUoGY2IuvFGnXyWxVG0xXbYX+BCYGWwa8mhQIeAX6UnrmZHzA
         0yDdgENiCikacfG7QveOPguN21ZINDYWFw3swKx40mwpxEeX/Y3LYt87RHmtaw99e0GY
         yueE26WHg91krQFDVShRzUeZzjbmAVIrUAyECyAFJ8FRBEek5gdtK8ih+zuFWSCo0lBn
         ViHwo1mhaej3YxbdrTZF0idVCFDLbpBTvwlSFbxtbzSSd7Up543xZ6f++4ESzytq6ssV
         iZk8udZIQ33JKL37ZRHu7u9t2b3EimLWjUUng4qyTgDzCrksSskntuxqZBlhA9aZt5RE
         XOIQ==
X-Gm-Message-State: AC+VfDwA3xe+ig6dlifPxSiv8YImGZt7apumvEZHhHyuYBhK7BIK8L35
	LCg1+DK5++x5191RwJmX/XBugA==
X-Google-Smtp-Source: ACHHUZ6GgrO8jcM5d3saW4J4IAVcPfC4QhJI1fiDa7hJz6KmjkRa3o1EhVVQMxnA/Z2etk4iReXBIQ==
X-Received: by 2002:a5d:6086:0:b0:306:2671:7cad with SMTP id w6-20020a5d6086000000b0030626717cadmr27241216wrt.55.1684162587152;
        Mon, 15 May 2023 07:56:27 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j17-20020a5d6051000000b002e5ff05765esm32745232wrt.73.2023.05.15.07.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 07:56:25 -0700 (PDT)
Date: Mon, 15 May 2023 17:56:21 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: wuych <yunchuan@nfschina.com>
Cc: dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: liquidio: lio_core: Remove unnecessary
 (void*) conversions
Message-ID: <2c8a5e3f-965e-422a-b347-741bcc7d33ce@kili.mountain>
References: <20230515084906.61491-1-yunchuan@nfschina.com>
 <61522ef5-7c7a-4bee-bcf6-6905a3290e76@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61522ef5-7c7a-4bee-bcf6-6905a3290e76@kili.mountain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 12:28:19PM +0300, Dan Carpenter wrote:
> On Mon, May 15, 2023 at 04:49:06PM +0800, wuych wrote:
> > Pointer variables of void * type do not require type cast.
> > 
> > Signed-off-by: wuych <yunchuan@nfschina.com>
> > ---
> >  drivers/net/ethernet/cavium/liquidio/lio_core.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
> > index 882b2be06ea0..10d9dab26c92 100644
> > --- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
> > +++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
> > @@ -904,8 +904,7 @@ static
> >  int liquidio_schedule_msix_droq_pkt_handler(struct octeon_droq *droq, u64 ret)
> >  {
> >  	struct octeon_device *oct = droq->oct_dev;
> > -	struct octeon_device_priv *oct_priv =
> > -	    (struct octeon_device_priv *)oct->priv;
> > +	struct octeon_device_priv *oct_priv = oct->priv;
> >  
> 
> Networking code needs to be in Reverse Christmas Tree order.  Longest
> lines first.  This code wasn't really in Reverse Christmas Tree order
> to begine with but now it's more obvious.

Oh, duh.  This obviously can't be reversed because it depends on the
first declaration.  Sorry for the noise.

regards,
dan carpenter


