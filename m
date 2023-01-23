Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FA967743F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 03:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjAWC6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 21:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjAWC6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 21:58:53 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EB2E3AB
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 18:58:52 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z20so8145594plc.2
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 18:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1neSYIYwuDBMfYi6YLPCwgdVE+1GYxZYSiDLNCTVXLs=;
        b=mmmMosZlz6g/OKY62yktaCLn4rxk/6SGUb0XX/UQ3f66hKbtuLTNe6KwAgz+zhNK3o
         fDjbthXjj+5es0h+OcpOoPFEBkBsihIf2DrTCdkYugA4C+IPqJ4QuL5zdC8qCT2SN1YE
         2uFFqFs2HIOMenNpbzQbggw6joHCfhbBoRWf/XgtoDUWbUoLYArM8dBU4MogKH0FzCAu
         1FWfYIaThz/zYWx1IYNVUCfJY1KNIxVFNQsUMADHUEdGDVuq0wL0L3TEPt7w1C3nq0Vo
         gR7ZvNEU0FWCdxGrE2pt6BbhqGNzTO/cPOpkoQGoIDFcpdaJgr/nEPsgiqI0KeD3ieI5
         UEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1neSYIYwuDBMfYi6YLPCwgdVE+1GYxZYSiDLNCTVXLs=;
        b=iR+vRGEED21PjPXnm4vLDdGB0lO96VrdKZ5+6osQ16A9/AY4E7j1zbzmhYdvuU1ex7
         4MtLKRJ2mzKNiBXBt1tEL9St3kN6XGjNU7L4jmSjxFHw+tZedVFIAmQS0a5KkZmD4hET
         w5OqjAXNEFw3HhG+OCdP2GBbCcHXU5zCydNm/3dWTgyu2xQNuDEznKe2dekVfW3Wj12s
         1rNjOMd2ckwvMfBqy87Wse6asvV2rWeMqFY96e8t3YXxZcselitAWeuBkIPkkqHsXeJd
         DinUY2b1gXN73SwpAYkSl6VmFYyLJI7/eQuFvMaoHVBMK18qgx0X+nZ58SkVlJN0LoQU
         JD9g==
X-Gm-Message-State: AFqh2krKGYiVHFVyPV0JXzeUm1Y+cVgk/YBWUtHD3ZHvrlPk3YiLXclF
        /AK/7M77KYDjFipWFKc+jFQ=
X-Google-Smtp-Source: AMrXdXurJ/Og2vGJsL70YiQK3Kw27xY/kZa2Ea80YDxvufpH/kRe/cj2+ZJMnCCtfwdsZclUNPFm6w==
X-Received: by 2002:a17:902:988c:b0:194:461f:8cf0 with SMTP id s12-20020a170902988c00b00194461f8cf0mr22018045plp.28.1674442731806;
        Sun, 22 Jan 2023 18:58:51 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902c3c300b001945b984341sm15370156plj.100.2023.01.22.18.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 18:58:51 -0800 (PST)
Date:   Sun, 22 Jan 2023 18:58:48 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <Y8336MEkd6R/XU7x@hoboy.vegasvil.org>
References: <87tu0luadz.fsf@nvidia.com>
 <20230119200343.2eb82899@kernel.org>
 <87pmb9u90j.fsf@nvidia.com>
 <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
 <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <20230120160609.19160723@kernel.org>
 <87ilgyw9ya.fsf@nvidia.com>
 <Y83vgvTBnCYCzp49@hoboy.vegasvil.org>
 <878rhuj78u.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rhuj78u.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 06:48:49PM -0800, Rahul Rameshbabu wrote:

> Another question then is can adjtime/ADJ_SETOFFSET make use of this
> servo implementation on the device or is there a strict expectation that
> adjtime/ADJ_SETOFFSET is purely a function that adds the offset to the
> current current time?

ADJ_SETOFFSET == clock_settime.  Drivers should set the time
immediately.

> If adjphase is implemented by a driver, should
> ADJ_SETOFFSET try to make use of it in the ptp stack if the offset
> provided is supported by the adjphase implementation?

No.


BTW, as mentioned in the thread, the KernelDoc is really, really bad:

 * @adjphase:  Adjusts the phase offset of the hardware clock.
 *             parameter delta: Desired change in nanoseconds.

The change log is much better:

    ptp: Add adjphase function to support phase offset control.

    Adds adjust phase function to take advantage of a PHC
    clock's hardware filtering capability that uses phase offset
    control word instead of frequency offset control word.

So the Kernel Doc should say something like:

 * @adjphase:  Feeds the given phase offset into the hardware clock's servo.
 *             parameter delta: Measured phase offset in nanoseconds.

Thanks,
Richard
