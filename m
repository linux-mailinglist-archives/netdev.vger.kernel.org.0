Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574C46C666D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCWLVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCWLVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:21:06 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2602F1167C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:21:05 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ew6so21881237edb.7
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679570464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jDCC5ux4HmzsqYV/2lwqfpDI+o4eKtLbnQ/J7OyhDRE=;
        b=4jarIhY5HizTXMg3id+X3+WKjHlkaueY64bBwCuXRpk6b0k67ZqztZ19lBf47I8hog
         P357z8Pmo0vxE57iUrixvw30O/1UfVKwtOJFgwK7HyvCcgVJpr0PWRotQ2/JFnR3P7j6
         L7KnSJVj3ezVUlJb23muMXtGPhpbBPQ4U4oFdY88vUVjVOtkX6RyYPvRQF32u4P3QzNe
         SAWO/RxV/zcNY6s9z3zs8l45Bmfoz6hCDBg2j3QKvkoRCQOFkTpRkaIUcWvBoFaIPAej
         S/dL5Y6Cgs/quCxWik6FQTljWktgztHlWruaT/Lcop5/9OQey6g16Slb11xyJ/d91dLa
         05Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679570464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jDCC5ux4HmzsqYV/2lwqfpDI+o4eKtLbnQ/J7OyhDRE=;
        b=qzkNf1Mhds2dgN8ek/4MiSz9g7FJYu64Sz7/spEHQYW8EV/cPLofS0mKZ0c1gbFR3i
         qPdd+vJCbywUIgd+xbuc1L2/Vb5vaSjKUtzGY9ic0oQXxyWcLWq1buDrM+IcEb4ihaTn
         nOLrozVP+nxpb4i66QiJE326+k94th0oYjD/Bjft528/z3+esRfwMAxRw/psJC+MQYuT
         40YCiVBkFPrU0dw42S4Qr/8o2telz1iS/5JMpE702HjDug5LP6PJ9ECBicxTq0eiaMe0
         d7DNMhVxDs8Q7iym1z110/a59aGNGFUMM1xL86eIFurf622CU8BZMes15ZUNw+9Z4gkk
         0uXg==
X-Gm-Message-State: AO0yUKWZL+ee7GRvyzhFVC/dPDZTW88q98UxNb42atrohYbKWCXas1eB
        qwsX1fIpLWFMO5yOz6QJW5b6NQ==
X-Google-Smtp-Source: AK7set9YUDnRnSj7cZIcYcBaBlW9jFPY1WXwdOUSIRCkccZjtBxm9cqS7ntDGFGywlgIASCSj/+nKQ==
X-Received: by 2002:a17:906:694b:b0:878:7cf3:a9e7 with SMTP id c11-20020a170906694b00b008787cf3a9e7mr10555881ejs.65.1679570464600;
        Thu, 23 Mar 2023 04:21:04 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id jx3-20020a170907760300b00930876176e2sm8554987ejc.29.2023.03.23.04.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 04:21:04 -0700 (PDT)
Date:   Thu, 23 Mar 2023 12:21:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 0/6] Create common DPLL/clock configuration API
Message-ID: <ZBw2HlGePj7J5GCX@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-1-vadfed@meta.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:01AM CET, vadfed@meta.com wrote:
>Implement common API for clock/DPLL configuration and status reporting.
>The API utilises netlink interface as transport for commands and event
>notifications. This API aim to extend current pin configuration and
>make it flexible and easy to cover special configurations.
>
>v5 -> v6:
> * rework pin part to better fit shared pins use cases
> * add YAML spec to easy generate user-space apps
> * simple implementation in ptp_ocp is back again


Vadim, Arkadiusz.

I have couple of patches on top of this one and mlx5 implementation.
I would like to send it to you until Sunday. Could you include those to
the next rfc?

I will not review this version more now. Lets do the changes, I will
continue with the review on the next version of rfc.

Thanks!
