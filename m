Return-Path: <netdev+bounces-1644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA936FE9C2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC5C1C20CC0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A78F1F186;
	Thu, 11 May 2023 02:15:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7DDEC9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:15:38 +0000 (UTC)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B418A273E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:15:36 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-517ca8972c5so1280412a12.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683771336; x=1686363336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w75laJDqpUtwSwtVThmWcjAfJ8pDK9IL/fX0J7GIozg=;
        b=X19fTtZ+/7OvVbfo5N90aZ5Xc7XTIKjNL+P/Zz5+YTn1oEgKPhQ4vkz7sQk0R/j9JI
         CkOm4hbpkHSBCvbCqRyCC9FoX3gedwKDDMvrCKyuSWlpogIYMTgHM0Qii5659pZJN2AL
         rFWr+u1kWqYpC74++CIb2ttHeOkuwQNjclUsWXBiMmjlxKAFejt+K72BLZTgckhiUtLp
         5gAdWwATzxXQkrroPQIT7fPSYFo6RUXUBqjaUopemLJKxFud5HD87ThqB6uSv8d+tUXo
         Pou6RHgvmr+3AyonemybmlL2pdePJoK9YPG/2S5/ESeRqwom3A2h0r59wnzBuYFYR6BL
         FFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683771336; x=1686363336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w75laJDqpUtwSwtVThmWcjAfJ8pDK9IL/fX0J7GIozg=;
        b=OuXKXrLPmZTfn5bxvo92vy3ywZnRyjTqW80TMv2SyFVSkCBBARZYX9LdKBEdsCfBGF
         omjYZF76iChGaAnEYVcqM32VsdWlKNFkVLGbDU2h7WrNRAWXe7mkRtgTxk+Me32VqPcr
         zyZ4iENoahT3M8yKcq0P8Mqew9R7dTOmKwH7HqdgrtXcvaEt1vPLsVrCOwQzDn+cBrpR
         1rE9ZpLMy0e8FUveWUsIxeeHX/ob3/x+LJRpEMGuK39/Nt6cPGrsT8FRQB5uE98O9rkH
         0Lxk12AyOeVDX0k4NYq2rqUvg/EtFXxaedvCWM4M0NCRV/LPhjgFAKzQyKCqG7bIqkbQ
         4nrA==
X-Gm-Message-State: AC+VfDwWRI5kdPEtR7P0fnLl8zlCjtU/9SurKoIN02u1BClno1f4MikW
	wjIB5UgYSue8ReKSJZA70To=
X-Google-Smtp-Source: ACHHUZ4/rS4jhvITgBSKbClUIfqyuIavevrS7/qzCvSFZMFPzfF9G5bPjDb2eVf3r7s5Xzqc/fV3gg==
X-Received: by 2002:a05:6a00:408c:b0:63d:2d6a:47be with SMTP id bw12-20020a056a00408c00b0063d2d6a47bemr23446986pfb.2.1683771336166;
        Wed, 10 May 2023 19:15:36 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id e21-20020a62ee15000000b0063b867a1959sm4136947pfi.133.2023.05.10.19.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:15:35 -0700 (PDT)
Date: Wed, 10 May 2023 19:15:33 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 4/9] testptp: Add support for testing
 ptp_clock_info .adjphase callback
Message-ID: <ZFxPxTlwyiJPkb5v@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-5-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510205306.136766-5-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:53:01PM -0700, Rahul Rameshbabu wrote:
> Invoke clock_adjtime syscall with tx.modes set with ADJ_OFFSET when testptp
> is invoked with a phase adjustment offset value. Support seconds and
> nanoseconds for the offset value.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Maciek Machnikowski <maciek@machnikowski.net>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

