Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7910E4C42AA
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbiBYKpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbiBYKpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:45:20 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5528D1F6349
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:44:48 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id a23so10005166eju.3
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7C+CKYbG33N5ieTIq5+vJbfFYr2bC3Sz5mhJElnayY8=;
        b=LIgzp0AyRfWZJdvASOJROn/mpenZ3VUsr+aEJq5o+r1BfMyiC3UtSuvIhoMCscN7O8
         ejrId4IDj2HU18GilYzMPwaXSi0lmZtSa1YQQiz2wduDwJPfJdvXcLfOVCHllJAn0qf4
         JHtRsYu6dVXsxV4ONQ+BnARyAvUxL5W/CefuMujwLku7Jo2aElC7R4PJC1LLr6HMn7C7
         P/9sE98sfcElS9aCg09W5NIqo4Sc/BceIEye5/ak70He9sy97GfuciEQAxrATjirG9wm
         zwMPhnwFXEoeYXGyKRVeqM6eYqorIYC3GbF17uAq4MDaqQ0jpgY6P3KCPuls/V9zkBz+
         eq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7C+CKYbG33N5ieTIq5+vJbfFYr2bC3Sz5mhJElnayY8=;
        b=LMIAMeoxAcDs8dHPOKZaFoaZXnhCmcityFLJvCfiNxnszEk40LrY1SzJRVd8wBy4XE
         RiJXzDduvUFAp3NI/f4on5RrtP5+tMOf8NRBOWnpbWl6N1RIO7JvERQMHz5S0DTX8ZUW
         gqqCTquZZVhBAQMUxYeV62yrpXxpzpRPdx55k0fy+vYxLbw3DWeJMhSbkiBphYg0c0bu
         faAflnnM2eNnjqy0YkxF9WYgX9FBFSrbRes2myq9jdQYGGb27XBUz/GYE2SOSEh0JWPS
         99C+FizHMaX7R2NZuZftQLF+XZZ7iOolYboA4lKYEeTj8p+Y+wjypym1CAiULKVn5XpA
         0K1A==
X-Gm-Message-State: AOAM5305O/2fC+WcwQMPpRCt6GGPvj1r4P6EcamVO8JIWZInAidf3zWR
        ww9uu3qVJVdBeUNJxnFLNWI=
X-Google-Smtp-Source: ABdhPJw7WsdfRw6fevXwpPtP5BVZcPyBwSuj2c63aIeHRljGVaAiX/AKogrZNasFppNgfoSKpOGyqQ==
X-Received: by 2002:a17:906:2b93:b0:6cf:bb48:5a80 with SMTP id m19-20020a1709062b9300b006cfbb485a80mr5526851ejg.681.1645785886858;
        Fri, 25 Feb 2022 02:44:46 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id b15-20020a50cccf000000b0040f74c6abedsm1179214edj.77.2022.02.25.02.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:44:46 -0800 (PST)
Date:   Fri, 25 Feb 2022 12:44:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 5/6] net: dsa: sja1105: convert to
 phylink_generic_validate()
Message-ID: <20220225104445.pibnr7vyc5m42nrv@skbuf>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGmG-00AOj6-Dl@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNGmG-00AOj6-Dl@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 04:15:36PM +0000, Russell King (Oracle) wrote:
> Populate the MAC capabilities for the SJA1105 DSA switch using the same
> decision making which sja1105_phylink_validate() uses. Remove the now
> obsolete sja1105_phylink_validate() implementation to allow DSA to use
> phylink_generic_validate() for this switch driver.
> 
> As noted by Vladimir, this fixes an inconsequential bug which allowed
> gigabit and lower interface modes to be indicated when operating in
> 2500base-X mode.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
