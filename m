Return-Path: <netdev+bounces-1639-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D366FE9BB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26A381C20E0E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF491F181;
	Thu, 11 May 2023 02:10:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101EBEC9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:10:17 +0000 (UTC)
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506DDDE
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:10:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-24e57d65e5fso1172284a91.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683771015; x=1686363015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y7J9ASSzyI//UiC7uN9UfghBCWWcSvahXTHdaO5VzOM=;
        b=f5aI0aSEad1yM+Yp+q5zhZlEuE14PgVoPpUJRQ8p9GICThm6GfNLriAJP8fb6lvl6a
         6JHhk9KWtnembQWf7AvWLgdp19yC3SAJ6r+L5/mElrqm9wERvzqHTyRNVpMF0Ye6nSay
         zZlvdpI1AmHOeN8tVj9gI9L6TumRxOKkgkoozGWA8F9inNNWtlsuNcTfSoL1xZS97hPw
         SmBeGroO2qYZ15Cayjz3fYMql5IMZjrpd4RbVjTe7rZP4zvgvoURBvoZvvlxNYBhuys8
         SRHaTQS83Ri1AhN7RXyEnjroXczdcTKqBXAieJ0Gmq98blGmgSBPv4+aygm4VN/mMTej
         76Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683771015; x=1686363015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7J9ASSzyI//UiC7uN9UfghBCWWcSvahXTHdaO5VzOM=;
        b=hCiGwFw8k7EWJfCUcJFglNU7MoTk9hYAj9vzjtsSWOXt8+uVhvJedbBSs7Xzoz2qgG
         mGs1WOfX3TmAL4biWitXxJPdJnVR4yn5IloPo00zwIRt3WRGgY55QXFO7IXvHrpMTAvf
         /YzIC7MzTztF01Y7dsUNHr2Ux7+U19hVVc5hr0bDNn7dluPoqS3IBxIf1eRG6m6Uk/gM
         qI6PAswdKrrM+QxLyfUg0+CWUws8piBLAkg/Eqs7VMjjiiONs0YFdkjo84JJwAEsSjJJ
         XhRZukV0L+u+3n/meNyS/NG3Kb+G/HtCVFHBVbjsLmu9dBMwUavQSVm84Tm5pPVw50XH
         MlBw==
X-Gm-Message-State: AC+VfDwHozlCoGsnq4ahj3oJReHQeXDjNBIr5wUdfqVREU8tTV2rnlXU
	Tn0Yi8Jepy8O8Vo0nidGliJGBCyCB2U=
X-Google-Smtp-Source: ACHHUZ5n7giUjqYgTMx0FVZcwJc/Tbqp3S4FWpoxiOFObO7GYoccNhVUG2kQiKOtX9KC0cINtCSHhQ==
X-Received: by 2002:a17:90a:19d0:b0:24b:efc9:44d7 with SMTP id 16-20020a17090a19d000b0024befc944d7mr17200867pjj.0.1683771014714;
        Wed, 10 May 2023 19:10:14 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v10-20020a17090a520a00b0023fcece8067sm22132787pjh.2.2023.05.10.19.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:10:14 -0700 (PDT)
Date: Wed, 10 May 2023 19:10:12 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 2/9] docs: ptp.rst: Add information about NVIDIA
 Mellanox devices
Message-ID: <ZFxOhOeMWxjlYJmi@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-3-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510205306.136766-3-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:52:59PM -0700, Rahul Rameshbabu wrote:
> The mlx5_core driver has implemented ptp clock driver functionality but
> lacked documentation about the PTP devices. This patch adds information
> about the Mellanox device family.
> 
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

