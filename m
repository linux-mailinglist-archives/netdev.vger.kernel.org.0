Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD7051C032
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376705AbiEENJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378883AbiEENJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:09:01 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED4265B0;
        Thu,  5 May 2022 06:05:21 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bv19so8611700ejb.6;
        Thu, 05 May 2022 06:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=aNKOhtKTSEh4Mqkalcz76ou0WqeGSr1qJcVWuxMdUgc=;
        b=Rl64O5ujSl9GyaSM5CAsEp/QIQNn+pY27aNk3caCBymQk23TAnjTdLhOdwHuO6v0Xe
         LX95mSzpjCgmTKkznYc5Yyn76KiDpX9xumKc4M1AUZEYRARlObL/akMmPkCzORIKL2lX
         dlpF+c7Fo/EM2tTUuQq6vezqYHPWtHJMjpiZD295uy9umFpMWTszJvqe8O9FMRVKKzWZ
         39NxWphExiy2VLUvQHnw1XON74THBYcpqVaK7Ay9nwQyOij7UZJuTGjXdOoXRJAHLA2l
         eVAymy9eRQmh81jLURLeW4veoZ0H4K1ec6R+oOwMfiYPlpTwVqvB9viXzZuWG3IS1eu6
         Paxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=aNKOhtKTSEh4Mqkalcz76ou0WqeGSr1qJcVWuxMdUgc=;
        b=PJM40PmC6l5F4QsHvu8LMmD0bO35bnQV2IQnGl19spdZHs+KY5T9e/mi4cFkYIz4TR
         4c0zvXfN6zJiChY3OstDxmigL9FrHRiqN+NV29iPlrNI+/t6nCDwcqP9J9mImtaZz7yk
         a/sQlbDoyeUiUt5TKOO2voAYu3r0AgGxFFcjmb72IaLoKFGjTb8TtTORhrO/Fga4lyMA
         gdXoCHDZ3nG+X5bIaQpQjgljyujP1if/BAjrlnTjv7Br6NGd9mfy5mV1zPPIIuFlgSLr
         jdbqQbWBPCleLocRmF2O/iFo0lBhOwKYrpyXgvwwBlEczPp8KQcokj2b4I4Ldw6I6y/U
         UILQ==
X-Gm-Message-State: AOAM533E5J+8Qt26IFavaUCrkumTDm4iS9HZHpy5XmhqNcwF+FjkwQXP
        HtoydIgxNXI3nEbBBt34soA=
X-Google-Smtp-Source: ABdhPJyyVh6cKMR5tBekSuJuZBCdlWUsoD48Yo83JDTJb326k6wuXABrCERWF5ectwaSbf2VtzR4pw==
X-Received: by 2002:a17:907:7e88:b0:6f4:99be:a333 with SMTP id qb8-20020a1709077e8800b006f499bea333mr12336755ejc.719.1651755918889;
        Thu, 05 May 2022 06:05:18 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090628c400b006f3ef214e07sm721237ejd.109.2022.05.05.06.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:05:18 -0700 (PDT)
Message-ID: <6273cb8e.1c69fb81.716fc.3f98@mx.google.com>
X-Google-Original-Message-ID: <YnPLjDg5Vs3eQyG+@Ansuel-xps.>
Date:   Thu, 5 May 2022 15:05:16 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 03/11] leds: trigger: netdev: drop
 NETDEV_LED_MODE_LINKUP from mode
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-4-ansuelsmth@gmail.com>
 <YnMLay1N2KBjC1VE@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnMLay1N2KBjC1VE@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        WEIRD_QUOTING autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 01:25:31AM +0200, Andrew Lunn wrote:
> On Tue, May 03, 2022 at 05:16:25PM +0200, Ansuel Smith wrote:
> > Drop NETDEV_LED_MODE_LINKUP from mode list and convert to a simple bool
> > that will be true or false based on the carrier link. No functional
> > change intended.
> 
> What is missing from the commit message is an explanation why?
> 
>      Andrew

Will add the reason.
Just in case it doesn't make sense...
The reason is that putting a state in the mode bitmap doesn't look
correct. It's ""acceptable"" if we have only 3 state (rx, tx and link).
It become problematic when we start to have 7 modes and a link up state
should be handled differently.

Does it make sense?

-- 
	Ansuel
