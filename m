Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0666E4D1B0B
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347643AbiCHO4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344500AbiCHO4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:56:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103A24C40B;
        Tue,  8 Mar 2022 06:55:05 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id e2so17275589pls.10;
        Tue, 08 Mar 2022 06:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HMX124D2O6WPuvZBHig1l49K2rmUx1oosDsmC1rlFeI=;
        b=MehPtKYdoA5tKN/dBDD12lz/SPGrsdZ9+QMqxA2bTZTWRE4BBYBvAU/mTGk9MAHjHD
         C468idWwn5HVyuLPZF9ZMkI6mJ+YPCaPpBba1GvldllwD3+K7Xz2Rc5r7cLPyEUlLD01
         0mYHyBLdwpQqE+YjVyiqvOHlKV7XhU1SYy5+hWdqWIKSvF/f/UO4rCSEepSusTY1J4LL
         BOGMDtGBtqvk3brYh6UmrAYZ2u8m0oazi5qznWSwROX0wVLVkkrfFvbZVsPwRGsXKnnv
         SOvG05PF0vQxEbMxrfek7uFoEZ4tcOjuEibTZyAQ2UcwX7cELZ6S3VoLxxpCcampOTzK
         4QYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HMX124D2O6WPuvZBHig1l49K2rmUx1oosDsmC1rlFeI=;
        b=VWTDbbneizFQCae4IsQkuqfYhOpgkLCfuuOnTIGd1UOnSpr26C/6ceEzMfk1FSjRlD
         yf20Dvrm8Kj8Oyn5MuscGr2eSXMeN6teryAAzpk+nSWSsyApcVj4B3kkh0DKDqApj+oD
         +qW+iFmMgj+5V0vQdNWOXaT8SSO++ORCpsygnAJ1u8ooFX2KGw+VEzqARNpMXvgnkRRc
         lNU6jcfMD69748CJqAkHQ5+5Bf5A3MYi+Qi7wQDcpMSCIyqtuJruPU42PAxNKjqWissx
         2O8583Hb9vDZIDviSlEtx8mbzKonA9CZT70dJZiVKrGHC4/50Tu8cb6SEnWyBh8iDcWm
         wEng==
X-Gm-Message-State: AOAM530VPEY4T74mP1GmF0jyncrgfOQCJckaz+kHnEj9BGw4UPMFbkdL
        v9EtjFr/Z6OvSlMChYMZkP4=
X-Google-Smtp-Source: ABdhPJxrh7nKcxgGctqWO5BYXIxGIJ54+G6QuTy2xEnrQRAxiikZzw8nB6Yh2MXXL3oBRzU1KJvA+Q==
X-Received: by 2002:a17:90a:cf03:b0:1bf:7005:7d73 with SMTP id h3-20020a17090acf0300b001bf70057d73mr5082347pju.8.1646751304511;
        Tue, 08 Mar 2022 06:55:04 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id pc17-20020a17090b3b9100b001bf88fe5edcsm3392883pjb.9.2022.03.08.06.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:55:04 -0800 (PST)
Date:   Tue, 8 Mar 2022 06:55:02 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp: idt82p33: use rsmu driver to access i2c/spi bus
Message-ID: <20220308145502.GE29063@hoboy.vegasvil.org>
References: <1646748651-16811-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1646748651-16811-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 09:10:51AM -0500, Min Li wrote:
> rsmu (Renesas Synchronization Management Unit ) driver is located in
> drivers/mfd and responsible for creating multiple devices including
> idt82p33 phc, which will then use the exposed regmap and mutex
> handle to access i2c/spi bus.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
