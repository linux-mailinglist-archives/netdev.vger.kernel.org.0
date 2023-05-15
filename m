Return-Path: <netdev+bounces-2568-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFB1E702884
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73FF7280FAB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B402C128;
	Mon, 15 May 2023 09:28:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F30D8831
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:28:41 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C291BEF
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:28:38 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-3062c1e7df8so8213613f8f.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684142917; x=1686734917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QRBaFlhf9sFFgjiQBXj3BZflOgpJ96Bb6sKHpf2Tstg=;
        b=w51K1VOHufmt/cdo5w3wovdmoamaTl7lMVZxFXyP3ZWusdj94pYEGN60Mn9Ooj4rnE
         5rMJTFoOJbcZ/of+KvbrkjcxABJz2X4nxpdNCceheEmAtlwojp7jcYk3O2kfo2xwLu1g
         p0fUGqFltb7quYlp/4UbBp7s80AmcQXqO2kOS4edtOF/fod9dxWe+M3OhZ0Ko+E/P4Qa
         Wq+LQ/DZq7Fdyn5cAvqbv+oQ5IRg+PuDkiyZsKOtEx9GW1Cc7I1qdZuPfnjVyVwlH+jB
         jwtNmg33+8hGhnefPskKyhY3dXFUduJrjw3IJ6RKNtD/PKLmD9UEDdIcPgQh33GVQnyv
         LjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684142917; x=1686734917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRBaFlhf9sFFgjiQBXj3BZflOgpJ96Bb6sKHpf2Tstg=;
        b=Z9Ug4CocglHtSAi+Tgol1aNlsanPe6smqN1pP1lRottUbwRLBuDjS6DoEwMqcwagka
         KEo0lCvAiqMbfK9LV8JZInvePfPqZBq7EQ4SY2WuIOmCANNxB5K6w629BZQ8t5jkEt2D
         mIL4SFj8MfLTyz3aQBczhRzCFZNNMgfsvY5KqJDovuPtOZ9j6pKL0yELi4Unmq/QgZ36
         MuF3otzX6tWiuC6HaGf/lpHOZMW+gX8AudAOOG7w5bH+2P4DspGCnv0ugsISPTAX6MJc
         +JOMGC03phz2d/bgkh58gY8Pz01Mcj/tsHtfU85FUqr0sv8ycfqxPfOw4y0VD31X9lqe
         b1Rw==
X-Gm-Message-State: AC+VfDyYSIEnrNRot/3diJwfAk1zgVLiBIA4IDkVKkMdHjXk12dLwKHM
	KnxTfJDJwFbTmOpkW3noF83OtQ==
X-Google-Smtp-Source: ACHHUZ7PbioezIsR65ywi6/2ShhPZZoflieboKI5tlTUmDknlGjBF0hRQiD/bbU3CrRMH0nAD1PH1w==
X-Received: by 2002:a5d:58c1:0:b0:306:20eb:bedd with SMTP id o1-20020a5d58c1000000b0030620ebbeddmr21733882wrf.51.1684142916991;
        Mon, 15 May 2023 02:28:36 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s2-20020a5d4ec2000000b003063a92bbf5sm32022989wrv.70.2023.05.15.02.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 02:28:35 -0700 (PDT)
Date: Mon, 15 May 2023 12:28:19 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: wuych <yunchuan@nfschina.com>
Cc: dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: liquidio: lio_core: Remove unnecessary
 (void*) conversions
Message-ID: <61522ef5-7c7a-4bee-bcf6-6905a3290e76@kili.mountain>
References: <20230515084906.61491-1-yunchuan@nfschina.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515084906.61491-1-yunchuan@nfschina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 04:49:06PM +0800, wuych wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>
> ---
>  drivers/net/ethernet/cavium/liquidio/lio_core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
> index 882b2be06ea0..10d9dab26c92 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
> @@ -904,8 +904,7 @@ static
>  int liquidio_schedule_msix_droq_pkt_handler(struct octeon_droq *droq, u64 ret)
>  {
>  	struct octeon_device *oct = droq->oct_dev;
> -	struct octeon_device_priv *oct_priv =
> -	    (struct octeon_device_priv *)oct->priv;
> +	struct octeon_device_priv *oct_priv = oct->priv;
>  

Networking code needs to be in Reverse Christmas Tree order.  Longest
lines first.  This code wasn't really in Reverse Christmas Tree order
to begine with but now it's more obvious.

regards,
dan carpenter


