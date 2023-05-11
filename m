Return-Path: <netdev+bounces-1643-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5933C6FE9C1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A9311C20E65
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB231F182;
	Thu, 11 May 2023 02:14:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EDBBA37
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:14:42 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DDC2D45
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:14:40 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6439bf89cb7so1551447b3a.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683771280; x=1686363280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tu+WobPUgXH4EcB5NRD1hhMAv2G+RPFJaCdh5ZdPz4Q=;
        b=Sq/AwktdfIiEStxYU6HD3+kdV8fSQblikzMs9E4sdwFy22V+uTPQeU6pBTDb0RqyNc
         w4FlwMZvED6QTovYlBYkmKXVamqk5lhdVrCL2NcRFxKfsP9ukzoHRDsyX7K8QJrSbohi
         LzpChpGnbV/AGbEEq7DbuqWKfcAhgdg3/wVGmvra7NiDdypt+UDGaIsc8/cgterfm2j8
         EQGD/DZzlq0vy8SORZO9mAm98KDvLVKg+L3nKPxMrU8q/dR0byFJxkf9vAqSq2kAFrf3
         qhzohwC2r5tHnz651PgHgpuN20QRdU8YwX6NOfLfis8QQbM9cgJ5XR0NpqshZ8F9j+JQ
         RYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683771280; x=1686363280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tu+WobPUgXH4EcB5NRD1hhMAv2G+RPFJaCdh5ZdPz4Q=;
        b=W0DkAfJbmOfIPVHkd1f9RtHVdpbNfNTPsAja7HMbZWWpaIv7I9qokyqymARZeP2281
         3+LHfPkWl0qaKHxVxCHPwC/uCHYl/K8tVu3AUqu6L3YkouNv3wDYAb3FvFJG+OAbPGTG
         Yukd38KjFIvzdbjtpmxI8xzad2nBXOW3e0r6ylA2Il/Ko9gcdnDKZdGlyQb5ei7EniCQ
         Cd7eXAN3SKR4ME1tZ13WIFU+Esyjvfz06s3LFMxzUVCF5Ev0DEMpFQ+tmCV916YN/DLA
         WLFXyxwaPD7yI871o9W+mdLyDCwnQpl2DqTYLbZrmD+EP1XlkD+uQMNhA9ql6OKSMwoQ
         DIqA==
X-Gm-Message-State: AC+VfDwc+OHZ7dXaCsi77ff6LulX7+kj0TnHZDThn+0jCTXwlF/gsOye
	e5rrXSrme8F/YnjpbmlER7I=
X-Google-Smtp-Source: ACHHUZ6xPjki0+ILC5aRMnhnU8Z11YiVHCM3IJkxX8jRv9cPDh8pVmu0/Q6FXtMb/XTEoYPafcWd/Q==
X-Received: by 2002:a05:6a20:8e19:b0:f6:9492:93b8 with SMTP id y25-20020a056a208e1900b000f6949293b8mr21459063pzj.3.1683771280167;
        Wed, 10 May 2023 19:14:40 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a22-20020a62e216000000b0064624ca054dsm4138960pfi.156.2023.05.10.19.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:14:39 -0700 (PDT)
Date: Wed, 10 May 2023 19:14:37 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 3/9] testptp: Remove magic numbers related to
 nanosecond to second conversion
Message-ID: <ZFxPjV/pY7wtNqtT@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-4-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510205306.136766-4-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:53:00PM -0700, Rahul Rameshbabu wrote:
> Use existing NSEC_PER_SEC declaration in place of hardcoded magic numbers.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Maciek Machnikowski <maciek@machnikowski.net>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

