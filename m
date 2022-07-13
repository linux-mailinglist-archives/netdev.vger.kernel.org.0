Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB873572CE1
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiGMFEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiGMFEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:04:10 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED6AC8E8B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:04:08 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id z12so13853253wrq.7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nlosUsqTGPWz0mUfYpKLZRwSb93KsVieCWkpmRDvpuM=;
        b=JeSIshIhbKp5dPwJhTHlFTFRLH7m7aet9K7jwWExy8SbOK6HQddLAMiivhPWse2fCL
         lPxtvI+P/MNx9VIRZ8pUx3aTr+FgnXXQTNFSgu0g48HvAzykzIL/wNz83rbRi/aL1vos
         6zJqBBZCYKuzp5AsZkCMk7oWpxRS6Q5sWAD6nCUDOZ69P0N0Ylz3u+aRzzKiegk6Yx7X
         F5R4IZoipnRenWO5fooDMWO43daAD/IaLoliOyO/2OV1IHGIvG/O2WZIaNfbDQHx9VDe
         lOqCWIEutkokMRHTVIwPP/yb9VaXCG2tWsCBYfAGICHxmHtKVFEow+Upg6KCLbe9ovbg
         hgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nlosUsqTGPWz0mUfYpKLZRwSb93KsVieCWkpmRDvpuM=;
        b=uv2cX09fny0V4t+p0hL5JxC1jVRMVCGX8TDCK2jl1428DmpM4hxUzrxsizNmQrgF3I
         c/ZcKA1OBB3sreOM0vUGZBlX+9QW486ti5nZWmIIQgepmn5IjW2qYfwcInlcGrfLiu/r
         q0p6UYTXzGLpLwkPtpSNmORBdCiIsImA/laclkJ8oLgXNK4ZEV6y3eTgQ+KL9ukW28Fd
         sicI+pXWq5jmuIf5zPg6AZw6k+YCHU9nclAsmQCrdXbZ5ivBI27QEICPQsbXI+l7HWF4
         JKM7wEQmqRP74elufLnRCFfMmh7ymi+1igN8NlW4BYecPL+8R2SGXRm2HPW58fPHqFYR
         c2/Q==
X-Gm-Message-State: AJIora/oLuqlrI0GRf58wdfkk9ttotxz1HchRabUmTHY15ZcikYLD1jV
        oFCzEUJd1cZkagYmi7/isbrIMw==
X-Google-Smtp-Source: AGRyM1uzcpopFP6jOJDkkQ0OKDviZGLpp3z8jDqyCbLjwQiyrYXsyV/LvKhJVc7Asg4eQUc7X1E2tA==
X-Received: by 2002:adf:fb0e:0:b0:21a:34a2:5ca9 with SMTP id c14-20020adffb0e000000b0021a34a25ca9mr1293743wrr.472.1657688646828;
        Tue, 12 Jul 2022 22:04:06 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id az29-20020a05600c601d00b003a03e63e428sm1045923wmb.36.2022.07.12.22.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 22:04:05 -0700 (PDT)
Date:   Wed, 13 Jul 2022 07:04:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <Ys5SRCNwD8prZ0pL@nanopsycho>
References: <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
 <20220630111327.3a951e3b@kernel.org>
 <YsbBbBt+DNvBIU2E@nanopsycho>
 <20220707131649.7302a997@kernel.org>
 <YsfcUlF9KjFEGGVW@nanopsycho>
 <20220708110535.63a2b8e9@kernel.org>
 <YskOt0sbTI5DpFUu@nanopsycho>
 <20220711102957.0b278c12@kernel.org>
 <Ys0OvOtwVz7Aden9@nanopsycho>
 <20220712171341.29e2e91c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712171341.29e2e91c@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 13, 2022 at 02:13:41AM CEST, kuba@kernel.org wrote:
>On Tue, 12 Jul 2022 08:03:40 +0200 Jiri Pirko wrote:
>> >AFAIU the problem is that you want to control endpoints which are not
>> >ndevs with this API. Is that the main or only reason? Can we agree that
>> >it's legitimate but will result in muddying the netdev model (which in
>> >itself is good and complete)?  
>> 
>> I don't think this has anything to do with netdev model. 
>> It is actually out of the scope of it, therefore there cannot be any mudding of it.
>
>You should have decided that rate limiting was out of scope for netdev
>before we added tc qdisc and tc police support. Now those offloads are
>there, used by people and it's too late.
>
>If you want to create a common way to rate limit functions you must
>provide plumbing for the existing methods (at least tc police,
>preferably legacy NDO as well) to automatically populate the new API.

Even if there is no netdevice to hook it to, because it does not exist?
I have to be missing something, sorry :/
