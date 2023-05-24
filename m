Return-Path: <netdev+bounces-4849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8CA70EBFD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3C64280EF9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EFE15B3;
	Wed, 24 May 2023 03:44:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2114815B2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:44:07 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2DB13E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:44:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1ae4048627aso794495ad.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684899842; x=1687491842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vJ7ODieC1tzXgACuUmtbeZJNt8RFN9HD9lHk5cE5wiA=;
        b=KKIKRID+pVcJPUFbF1YIvhLx/fj6QlRRHD5ToyPIuuu5in9ozmza05FavWvXb21M7o
         tUdll5P/FdTFrbJOJDQpkoEiOSPtjKEyQfbJSEvUSCktqhNjPI/RS2U0sy4NeaNr5VO7
         JLIdH1Vckt3vSl2nwTVMBr0KMaRUOJ4iOiGYc641qMrmamNdzRxZlucAU1ugNGq8qz4J
         aI1N9VMaBIIm7VF8RITVBluTVJkzxjg+q95bJIQiNpNnBKYvIQbCnr0ZZlWF2Y6acS1m
         zsu3LoScH6zp8dZejVvWyK/6i7zGM5ZSY9KJoJynnd8yLNO4wpoM63yZSsNJNt5Rmrnk
         9Q4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684899842; x=1687491842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJ7ODieC1tzXgACuUmtbeZJNt8RFN9HD9lHk5cE5wiA=;
        b=AxcdL4uwUSk+A7lGLm6B6fgoS1US87J44Z9ZZJZfv/eEaT/Z1aQAg2UzW+WyL/drHt
         B7qrI6bCOH3FedrBssAlT+S6IzdxaGbgOd7qF5fYyytio/kp39Zb9Ym07px0X6FWo8Ql
         d3lt2ahgdoYgn9m2GxxbK/sztbFzT9VDVPa59P6/cdEJAInkyfrERCVm2NdnQ2mSoDjQ
         aLKg1sfB5jlcXOKU1tAq+H9fXmUdwPexpF8QSmg3W/Or0WfLVyL/05dzCLEQyYzL6D/J
         mdPV5pHVzJLomsiPzYQGYxKpnirfPdg5bW50R9/5moerx1k/TWCj1MwdPirmxqs/Uwqc
         eXRA==
X-Gm-Message-State: AC+VfDxUP6/UuC+yyXM6zmz1T2fsVUp8qcjXx4cEhQ1YAxoJmKwJgVx2
	bbwqQ5dNLLaITQozjUuSqgM=
X-Google-Smtp-Source: ACHHUZ7IZWNCmuWYQermspX7ftIPNN3Z+Wr02ByVzlEpYWZMD542xRo9VQUj8ACENJRY1ypglFQYrg==
X-Received: by 2002:a17:902:d506:b0:1ae:4a37:d5af with SMTP id b6-20020a170902d50600b001ae4a37d5afmr17950296plg.0.1684899842113;
        Tue, 23 May 2023 20:44:02 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h15-20020a170902f54f00b001ac5b0a959bsm7542800plf.24.2023.05.23.20.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 20:44:01 -0700 (PDT)
Date: Tue, 23 May 2023 20:43:59 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Maciek Machnikowski <maciek@machnikowski.net>
Subject: Re: [PATCH net-next v2 5/9] ptp: Add .getmaxphase callback to
 ptp_clock_info
Message-ID: <ZG2H/0J+ZH1JvH4i@hoboy.vegasvil.org>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
 <20230523205440.326934-6-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523205440.326934-6-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 01:54:36PM -0700, Rahul Rameshbabu wrote:
> Enables advertisement of the maximum offset supported by the phase control
> functionality of PHCs. The callback is used to return an error if an offset
> not supported by the PHC is used in ADJ_OFFSET. The ioctls
> PTP_CLOCK_GETCAPS and PTP_CLOCK_GETCAPS2 now advertise the maximum offset a
> PHC's phase control functionality is capable of supporting. Introduce new
> sysfs node, max_phase_adjustment.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Maciek Machnikowski <maciek@machnikowski.net>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

