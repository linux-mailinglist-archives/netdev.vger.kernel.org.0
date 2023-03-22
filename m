Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217026C4181
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 05:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCVETp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 00:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCVETo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 00:19:44 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C8A570BA;
        Tue, 21 Mar 2023 21:19:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id bc12so17584308plb.0;
        Tue, 21 Mar 2023 21:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679458783; x=1682050783;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F6PaN8bq5XqNt//+gDdH/EjNZE6f5FyGQiHw8QB10Fk=;
        b=YeDmt6o77jyo/E07AuCw2ctK4ASL3TF0OMhnqpK3epCAWrZYfS/UP+YPpTWGm71dse
         2g7BrwdgLz9a/ZKZG9fe5pszctFGfc54eNT4mqnVkkiIb/CJvLHqZP1WWhxYzgC73Vs4
         h6nARBLlo9m0d2fQnhkZeBEV6Vl1/lfz269MXzdHhBbICKv90yQpKVS5iXBiOEGH35mQ
         slYMnvI1WESCBmzduzryc0jPmFvPjCv2QhSfLd5dXwzTW6qtrFT30yGuV+noxjZIOw2c
         zTxyoamQfKnYUlRkdvXWODMzmcDRiqTqC471bCjHD3wWUmzOaHFcihUcbJCoiihXwuM+
         WZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679458783; x=1682050783;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6PaN8bq5XqNt//+gDdH/EjNZE6f5FyGQiHw8QB10Fk=;
        b=zNpESFSv+7NYUCMgZ6WZSUh+aYqtHuYDz53TqDFQYRW4M0ORKnwuygT8yh+jpZufan
         kM8YMXhCPGQsruikvuM039cwBmt0uMWBlkY1MNJ8LolCzQuwRQUA4RGmZMgnspYekJ/A
         C8HxQQI3PinsYKNMcfEjqw9JgZ/Bj5SZaC5p3GyJEqdBTrWZ6e2Nlgwe+wvYsn76tX8p
         fX2LL1c41S+HNcK6FYWaYi9Lqcc1NG9e7Bux27LzNXO0HUA7ShQ10BjHVt8mf4ck9pGi
         dojzln/D46FbMXrKUwOcyQw44tcMQSwv6DqVd455ZPQljCIkXFukEe7ush1P6S7WTjhM
         ECGw==
X-Gm-Message-State: AO0yUKX8TVeIhRYKftPcrKE18JBEcfMfINAk1WQg2i4HlklptdwoSnag
        rW/mRBcO78yHOnr8RjQ1RF4=
X-Google-Smtp-Source: AK7set95VhyeXVHUSXumU94QggbrKVSUulUlNsegINxlRgAiQM3VSWm0RleO250lfPGcswA+Kn1vEg==
X-Received: by 2002:a05:6a21:78a9:b0:d9:d1e6:82ac with SMTP id bf41-20020a056a2178a900b000d9d1e682acmr5250903pzc.5.1679458782789;
        Tue, 21 Mar 2023 21:19:42 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id u20-20020aa78494000000b005d296facfa3sm9067706pfn.36.2023.03.21.21.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 21:19:42 -0700 (PDT)
Date:   Tue, 21 Mar 2023 21:19:39 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, jacob.e.keller@intel.com,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: adjust estf
 following ptp changes
Message-ID: <ZBqB28RyKHYPPgEF@hoboy.vegasvil.org>
References: <20230321062600.2539544-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321062600.2539544-1-s-vadapalli@ti.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 11:56:00AM +0530, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> When the CPTS clock is synced/adjusted by running linuxptp (ptp4l/phc2sys),
> it will cause the TSN EST schedule to drift away over time. This is because
> the schedule is driven by the EstF periodic counter whose pulse length is
> defined in ref_clk cycles and it does not automatically sync to CPTS clock.
>    _______
>  _|
>   ^
>   expected cycle start time boundary
>    _______________
>  _|_|___|_|
>   ^
>   EstF drifted away -> direction
> 
> To fix it, the same PPM adjustment has to be applied to EstF as done to the
> PHC CPTS clock, in order to correct the TSN EST cycle length and keep them
> in sync.
> 
> Drifted cycle:
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230373377017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230373877017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230374377017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230374877017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230375377017
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230375877023
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230376377018
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230376877018
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635968230377377018
> 
> Stable cycle:
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863193375473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863193875473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863194375473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863194875473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863195375473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863195875473
> AM65_CPTS_EVT: 7 e1:01770001 e2:000000ff t:1635966863196375473
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
