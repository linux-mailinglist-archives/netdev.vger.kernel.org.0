Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A595037A5
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 18:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbiDPRAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 13:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiDPRAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 13:00:44 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F81C4BFFD
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 09:58:11 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id t11so20226180eju.13
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 09:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YXxJ2U5MK0DNYLscrVzxl5xIWdVVJY9JmdEudpzTeTg=;
        b=Y1LMnTPnzZpNsMFNB/daZT8+EcZptw1+A8wVMivGWiGAlow216zR4GgsddR8J7BEeT
         ayoQzVLUEPLHbNj+xlm5SBWe7gKw2oJ8cG+GshAm9llSK9Xk6BML7/mc48ezvZMroXBQ
         CDZFSt/feItkecGOzIE+VJYDa22S7n/L2tWVviRsbMtU52mh7DUaCfn9SYpQ24nyi/W0
         6dyk++0UnlQLBSBZINGtMaY9/TsynwGfKO46MdNhMqCZXy0EAJe8e7gPas/Ev8z70kHp
         qjliVQGIBc3fRXHlfgcprDZtb8QMvS+jcaFZ0vmaea09pPTSjwDZfioRFL9zes9dPa+f
         DCvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YXxJ2U5MK0DNYLscrVzxl5xIWdVVJY9JmdEudpzTeTg=;
        b=sPlHyYRw+AAizgtS9gUFiWgGVTWhIK40v3pTZWHVfXs/rOMEvyL5kDhKsff1CSDice
         8VyKdPpP7CAC2FkigimGpCeq3AHxRQXXxwLKGaacAt1jMNiRMS+ZqJ6au52iaGGbpBng
         GvtOQDtCw748sdZUmVOeiE2E8ltDJImw/SCSZ7ytf+e74+qeq/Q4P3I0dHjLW/c6t7w8
         +jQBwGATmiWMEEJXFGnNK7izlSaY1YKgER+MFvGcxFHIMVI4Xr3zZZZuDJ8VbUBn7+nd
         jNXRKFMVXk9njkAqnjgnLYeTB0ysJ9IxqIg5KS8csenJKod4Q2w8mtBhYBKS+M2JTY1P
         Ri7w==
X-Gm-Message-State: AOAM533cUY3O5fim4Eja5idyNkYD7vHtK0/+5Em15c4F9vUxuJqP0Sov
        cBY1xRq48Ok5arIAiDBL6GA=
X-Google-Smtp-Source: ABdhPJxR0FMuKqo86eO7F4ya8AxvMfkmHwqVS742M03+j9XhKdIbxIbEL882o8QwlMXWxE/4j5S1gA==
X-Received: by 2002:a17:907:7204:b0:6e8:c1e9:49f7 with SMTP id dr4-20020a170907720400b006e8c1e949f7mr3239331ejc.251.1650128289745;
        Sat, 16 Apr 2022 09:58:09 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id e22-20020a170906505600b006da7d71f25csm2836825ejk.41.2022.04.16.09.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 09:58:09 -0700 (PDT)
Date:   Sat, 16 Apr 2022 09:58:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
Message-ID: <20220416165807.GB3040@hoboy.vegasvil.org>
References: <20220403175544.26556-5-gerhard@engleder-embedded.com>
 <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
 <20220410134215.GA258320@hoboy.vegasvil.org>
 <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
 <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com>
 <20220412214655.GB579091@hoboy.vegasvil.org>
 <CANr-f5zLyphtbi49mvsH_rVzn7yrGejUGMVobwrFmX8U6f2YVA@mail.gmail.com>
 <20220414063627.GA2311@hoboy.vegasvil.org>
 <CANr-f5zzQ6_UsOdLZK7b-k5Jy4qhdGJ4_D2irK-S0FzhE5u3rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5zzQ6_UsOdLZK7b-k5Jy4qhdGJ4_D2irK-S0FzhE5u3rQ@mail.gmail.com>
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

On Sat, Apr 16, 2022 at 12:04:20AM +0200, Gerhard Engleder wrote:
> - vclock:   slow path with phc lookup (not changed)

This one could really use caching.  (I know that isn't your patch, but
maybe you can try to fix it?)

Thanks,
Richard
