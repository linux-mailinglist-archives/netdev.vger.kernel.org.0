Return-Path: <netdev+bounces-4844-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A74CB70EBED
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66A4D1C20ABD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD20515B2;
	Wed, 24 May 2023 03:39:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD52EC2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:39:32 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0243BF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:39:30 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64d722dac08so124917b3a.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684899570; x=1687491570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4raEAJdRBK4nJvqgH2ZGygK2LX8df/PW7HWPrp78V4=;
        b=E/fofQU/hDIiQ9b8aTRcJyCUUYsNSqchVgh+i4fUBp1wlUtOqOvUrifWy3nsZX4cnS
         QIw4q1ERuVTAr85aIeIoxBJZ8jwrrsNh1wKVx6rnWL0Atox6mWW3oNl7qzHyxq3MUlxA
         d4CyJYRRgHYQmsB+M9PLOGSseSf4NRE+1qPE9IPoeeD1PnLjRB8JaIz33/vFozCoZMHO
         BeGk6ept5uiX0HetdAHDS+oNUmwimVAMFLFlZjv126Rj34Gx+NMcsXTe1NKT7HYq5m6z
         CKTEf4ciXX3fHjDmtRH+V1X5Wb/WFsw5fZq0/IWeatP5VjZMeKiFrnelybMMn4jlLl3q
         /5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684899570; x=1687491570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4raEAJdRBK4nJvqgH2ZGygK2LX8df/PW7HWPrp78V4=;
        b=M5gcwZPWWXVDdImq0ODdjE2WF+Z37srDQVOSwsNYh1i48pbKBTG3NzSt5ZtYBu3Clw
         4KuPhF4Qu7Au5d1rExeaIGyJsopFeDoJV2UkDKBs9EMP2VYHhg8LtspRHRpEG7yn9cCr
         QNWe+o6TiT7U7eTahUZq+M4j/iJU+wsFZa+sfvMpkCeiJ/R7fEwTu5WylkpBj6NKiLm2
         5PTco5b0SBiGUzKYh5ipXdWNAKMiA1K7qltQ+Aqi2xPN82lOIMjn5UkowuZwdVVgOU5z
         LG8C0uUFrS064K6smUpToVlItPtJjERNxvZDnFbZHRxWrJbGPplkpnFzgBy6EDF/KnCx
         Cq4g==
X-Gm-Message-State: AC+VfDxhHTRGT4qjElAd03sOSRWW3jhfmE24pAK0P5nSG9rvgAdwltYD
	IJD3+DUTOoYZd6aP98vxREI5N0N0Tl0=
X-Google-Smtp-Source: ACHHUZ5zqSpXlFjUNTm3pSkmxUVwfgSlS+AS1Wi5LGFJZj/3UjLeDkJv6LzZs0LOck2kmrS3pbgGyQ==
X-Received: by 2002:a05:6a20:72ac:b0:106:c311:e6bf with SMTP id o44-20020a056a2072ac00b00106c311e6bfmr14418820pzk.5.1684899570225;
        Tue, 23 May 2023 20:39:30 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h11-20020a62b40b000000b0062ddaa823bfsm6426166pfn.185.2023.05.23.20.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 20:39:29 -0700 (PDT)
Date: Tue, 23 May 2023 20:39:27 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 1/9] ptp: Clarify ptp_clock_info .adjphase
 expects an internal servo to be used
Message-ID: <ZG2G78dFbitcVj+d@hoboy.vegasvil.org>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
 <20230523205440.326934-2-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523205440.326934-2-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 01:54:32PM -0700, Rahul Rameshbabu wrote:
> .adjphase expects a PHC to use an internal servo algorithm to correct the
> provided phase offset target in the callback. Implementation of the
> internal servo algorithm are defined by the individual devices.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

