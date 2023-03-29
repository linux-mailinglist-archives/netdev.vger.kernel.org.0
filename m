Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9536CCFFF
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjC2CfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC2CfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:35:03 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625FB2D4F;
        Tue, 28 Mar 2023 19:35:02 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a25eabf3f1so1347875ad.0;
        Tue, 28 Mar 2023 19:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680057302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tlqx0fjb88NND2yTSpCBt3TrLVt9nt+Nx1kV8nMjXY8=;
        b=iSBcYG2Whp//b9H4VuQylMhXaTRpzkELhPf7kc94jOD5ZnyFlo+HteX7I/8tZu1RYT
         jrKwBTqQPmeLba9jY9WsPuvk9CJT9YbcJf+6X98XkenByfkDwq+2Bs3eP48f6AqSDdYp
         zIiOgSGjh8b/GNbxxNLV/lwIyptLOdPEQ+NX1HW9rxTaZtyUfdbnLqF7fDBGPw5VCpb1
         w27WYzos393f1rjNjSHJCpWYCCdWS1Sl3UUX0dS+9RZWnE7nShXVnFoe+u7RjYZ11srD
         h4jN1zCrYKSl1JcsuUNzGarYkS7ZcwrUvdh03W7oS1cCz0S/9lTZSHxDsXWrDPZucGRh
         gTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680057302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tlqx0fjb88NND2yTSpCBt3TrLVt9nt+Nx1kV8nMjXY8=;
        b=NAU43eSZqBd/g/pZhNbyitCWTktCE/daub/HddL6PafcyxIlFNm4Y3hC3MWYU8qsbb
         pFRnZ9JsGcVPWLxK+eAnTJHLKewI3n6YaNevUT6Mn/xaI4hxCf8p+tdeKdIHHG+N5+gH
         mgHAwKHWEpDTJynnumugxcwIxxoro/twc0ycHZsWRgBaeQqOdJT7G+fKcy3v+e6PGX1Z
         lOLSf0EklDfXsg4N0jflKeoPAatyYXaRkUHNfG8wy2xE2e0Qlwq4HsG7KZqFEPjVxvB7
         /0Hrx/htXjdzeRKaYXN7j6DgMkPrtAaYmlRl3VHQ1uJJkni0TT49vyTle/WDGCNFCBLh
         J/0w==
X-Gm-Message-State: AO0yUKUTjxXDJDfdLX0uzhq/kzbPtKD8tuuv2sYfp5f4mrWc0OUG5xMP
        dKgeEjvpNoIKZrT9ZG0itH4=
X-Google-Smtp-Source: AK7set+JrMLI3ke2wHmNYRWX9b/zuXwN4tqA5ALBJkXvaCCrVkvsuwUTyXe/y699i8gjdUzL5P9mNw==
X-Received: by 2002:a05:6a20:7da6:b0:db:91fd:92b0 with SMTP id v38-20020a056a207da600b000db91fd92b0mr13782108pzj.1.1680057301780;
        Tue, 28 Mar 2023 19:35:01 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005e4c3e2022fsm21779363pfh.72.2023.03.28.19.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 19:35:01 -0700 (PDT)
Date:   Tue, 28 Mar 2023 19:34:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tianfei Zhang <tianfei.zhang@intel.com>
Cc:     netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        vinicius.gomes@intel.com, pierre-louis.bossart@linux.intel.com,
        marpagan@redhat.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com, nico@fluxnic.net,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v3] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZCOj0rK/lqx7ktT0@hoboy.vegasvil.org>
References: <20230328142455.481146-1-tianfei.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142455.481146-1-tianfei.zhang@intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 10:24:55AM -0400, Tianfei Zhang wrote:
> Adding a DFL (Device Feature List) device driver of ToD device for
> Intel FPGA cards.
> 
> The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> as PTP Hardware clock(PHC) device to the Linux PTP stack to synchronize
> the system clock to its ToD information using phc2sys utility of the
> Linux PTP stack. The DFL is a hardware List within FPGA, which defines
> a linked list of feature headers within the device MMIO space to provide
> an extensible way of adding subdevice features.
> 
> Signed-off-by: Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
> Signed-off-by: Tianfei Zhang <tianfei.zhang@intel.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
