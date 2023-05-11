Return-Path: <netdev+bounces-1648-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 815E36FE9CE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:21:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2AE11C20E9D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673B91F189;
	Thu, 11 May 2023 02:21:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C698BA28
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:21:00 +0000 (UTC)
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1494110F3
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:20:59 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-52c9e4418e1so1141000a12.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683771658; x=1686363658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXF4S5UsyrTC6gAQx5IQgiVGbhSX807UJyezisjnY84=;
        b=V+nufmOlk32EWFWgsNd482lPys85NrjCiQzykZest1a+SEGfQXcjtdrjaS7S/vLVtp
         cPH4sdrRg8s6e6JbLoz0eciQEBZdb2Dd553cU81CWtOGfFqffLVVvQBzmZNU0XfQ40p5
         AxWNnQ1NI0q76bgiy6PTeLyRrHCTF7oTkXjnLqRTCLxjsVJIy1hW0wwD/B/zp5Wo3nAy
         q58Ix4kolzDBJMEeQUuWCDDuoHwqXKonpfzz0xvBHoFWvqdB9cMxa9c+fvjJ4fFD50U/
         fu88D4ZPdUxGPa65ac9bZ/0qFlhC4Xyn2h61JAC7l65nmjxpbpmS4d76iNdtveDh+2XK
         yFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683771658; x=1686363658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXF4S5UsyrTC6gAQx5IQgiVGbhSX807UJyezisjnY84=;
        b=XsIEtv2h4l/R7Ja/emZmUXYeIfaere/4XUr2Yd+p1hFUDfb4YghPkW2z0hZlhfgZ+/
         E+Xjf3PjEikMTy0f/sjCQ/ryiVkjCVnE53ZQMKRK+i1LBktik24+iYuV7ncSJ8Cn2XoV
         6y+/lKfJ8/6+AfUggx0BwSDnkM98+fbUYyC5+4HazBpHmCa3NSuR5bwHyzyZg+V+UWD0
         z93NpuqdA9XXQMInTzOw+uzCnToeMWYgTz4vN8Nag6yqlKdbMIRyhUWPcVHRhJ4fTCxa
         BgrkRIMJgtwrwh+OfHqt2EY7Qfb7ezllpM+SIQ9qUl4ACsuBLcEqDWIRgdmcM/dJC67b
         dnjw==
X-Gm-Message-State: AC+VfDxYAcMYMnJmaPCY87m4Fw/irsHHyhCo6Uy6gie8WGTalmZfR0pK
	mOOzv/xCa9rItM9AuDGEPD4=
X-Google-Smtp-Source: ACHHUZ7bcXYcQ4ZBWJzmxuV0PA9xtwPpnh5rzE5v57mEAFZpN87xsmCETzy9Usois3MFn31D2N028A==
X-Received: by 2002:a17:903:41c3:b0:1ab:160c:525a with SMTP id u3-20020a17090341c300b001ab160c525amr24856283ple.2.1683771658563;
        Wed, 10 May 2023 19:20:58 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id e5-20020a170902b78500b001a6c58e95d7sm4483026pls.269.2023.05.10.19.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:20:58 -0700 (PDT)
Date: Wed, 10 May 2023 19:20:56 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 6/9] net/mlx5: Add .getmaxphase ptp_clock_info
 callback
Message-ID: <ZFxRCFkYqndkveFh@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-7-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510205306.136766-7-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:53:03PM -0700, Rahul Rameshbabu wrote:
> Implement .getmaxphase callback of ptp_clock_info in mlx5 driver. No longer
> do a range check in .adjphase callback implementation. Handled by the ptp
> stack.
> 
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

