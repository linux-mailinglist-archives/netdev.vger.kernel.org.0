Return-Path: <netdev+bounces-1638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C0D6FE9BA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:09:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94C33281486
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60901F180;
	Thu, 11 May 2023 02:09:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACCA1F17B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:09:44 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F732F4
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:09:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1ab26a274d6so11453345ad.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683770983; x=1686362983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LmcSiky2pADMvn02TK1Heq4inmhzO/S17fvX0K/gPHY=;
        b=DWMUYjtI8VkHlMB/r/gv3lDhiuX3jaIvBnTJ8QhCVntv82PxqG//4TJUZI4qAe2Xr6
         jKyQfySt2r8WCXnSUqUGc5czocQysO8hcrCCGpVoZuWIx8Db0KAO/2CVur8OhT8lHYlS
         bta6FAB4YKbs1l0+fcazE4ik45djrzo0d9pHt2xJxuR1Gu3GfJhOLWl+ozcONlSYpmrK
         G6uH4N8INLjS23RQtmmBeVgDSX++ZVdA1y5iCYQomEsOrzzb6Jy6e2TxzT13aXNPsQU3
         m5NOFjdONRrZ/7uUMs3QB09LT23hjfKugTL7CvO79Gz9BCZvY717NtDAwPboEVtgp6Kh
         VlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683770983; x=1686362983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmcSiky2pADMvn02TK1Heq4inmhzO/S17fvX0K/gPHY=;
        b=Bq6FlaJD4SS1cxzuiZSQVxV25VSZw4UbfZuJ0/xQpsTPQ7wiTDr3DwxvyGwltRdNFR
         Ee9NXoBX+FJQXIxy4lC1znyuYbvhgeru0KCjE3Lr0vmz//Bt3uRjuB6fDUnZoJRu6LY9
         fLWbDFsZ06/Tj+o+6+vLOdjy3LNeSb1XdtaEzMOFV6apklaDB4QwyNw63yry5J67odun
         qjWxaR1XfqTiTPN0Ts+ZvmivDs+tH6o/RliTC1+e/qABZOoyK4xGzDF7TNsVxeX23FMZ
         B4pJS20xompfSEKBCKEoOdPE+CSzMJFHQVjTTXQstfpnIrp8CIzuYMFEYmrWF4AWTq1L
         9kWg==
X-Gm-Message-State: AC+VfDx+cuDRz7ILwKtAm7nYNwLmos/mTPm74kdkj47MPkX7KSzntPs/
	rrEFGaLknQda8wtcA2ewbIA=
X-Google-Smtp-Source: ACHHUZ6sOsfbMQelT+CVXP/CzMiMI58bkfzAd3Jun1ngsGrHshpBVk2V6vrOUKNYCU+mjf0lGbl3Og==
X-Received: by 2002:a17:902:f547:b0:1a6:cf4b:4d7d with SMTP id h7-20020a170902f54700b001a6cf4b4d7dmr24244393plf.2.1683770982807;
        Wed, 10 May 2023 19:09:42 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k10-20020a170902694a00b001a4fecf79e4sm4475143plt.49.2023.05.10.19.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:09:42 -0700 (PDT)
Date: Wed, 10 May 2023 19:09:40 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 1/9] ptp: Clarify ptp_clock_info .adjphase
 expects an internal servo to be used
Message-ID: <ZFxOZM9saCVDNIqD@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-2-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510205306.136766-2-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:52:58PM -0700, Rahul Rameshbabu wrote:
> +PTP hardware clock requirements for '.adjphase'
> +-----------------------------------------------
> +
> +   The 'struct ptp_clock_info' interface has a '.adjphase' function.
> +   This function has a set of requirements from the PHC in order to be
> +   implemented.
> +
> +     * The PHC implements a servo algorithm internally that is used to
> +       correct the offset passed in the '.adjphase' call.
> +     * When other PTP adjustment functions are called, the PHC servo
> +       algorithm is disabled,

I disagree with this part:

> and the frequency prior to the '.adjphase'
> +       call is restored internally in the PHC.

That seems like an arbitrary rule that doesn't make much sense.

Thanks,
Richard



