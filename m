Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09F6582928
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiG0O6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbiG0O6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:58:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A592DA8C;
        Wed, 27 Jul 2022 07:58:07 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id oy13so31946133ejb.1;
        Wed, 27 Jul 2022 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D18WvZPkj6n5WDrANeJHZXATHlFFUi8vr9qfbamAa1U=;
        b=F2s6ehi+ivSVnhU0Vuq7fanzF56aZwNxtOFwgZ9zfDnz/7lCeWXx3SahXL8Ro6KVxc
         UJtMSK92OEISrck8zag9qqZhOs5IxnkCkc32dwNBls+rNjS06jzJ47xlB67/5EJHm0u2
         FbaE5U2iNomQXv8gG9aM6XzQLLsIM0VhWBqcfW33lv9cdNYDDC/caovvSpy2khDhTy7K
         +NK5nLxUfo/Kbf0V2Y7tF3qS2EIjarbaqQGbCXXdEvm9qu0UUfKp6uQlxJO/n94H/sVS
         HONR39G9abzkTBlT+PLoIM7R8oiXI1l7Z8vbjh0AwCSy31t5DYmPqd0SbQCwbJC6O+Zw
         VDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D18WvZPkj6n5WDrANeJHZXATHlFFUi8vr9qfbamAa1U=;
        b=hngRyt48KJw9rQzC4m5spvwPmSCrMDYjK6GwxsufLaMzb2PV4nBtO3sRe4iSZ3G5pS
         /hERg9iv3aDeiYo06FfwPt84ZdbOJtW1J/g4S9l5m4WJ1Z3+NCUMoeGgkP/pLRh41SjP
         hmMwgzbWfOjHdxvO2bBVIyRujS173HKDH0fc0h8SFL5VKjB2A2/Ph7RUHUvUrhqnGmQW
         +2FZdKtBA00L3IW2qCup/a/0JIktHw2MLQZwA8ru/cX/2yWRXmlO0AI2pfe2U5oXLEEG
         m6+u9FUPSy9huYJ4vnTLBIIQBh/gS1llSspPMdEUzvpl3Voxm/+K63t2KNScrt70kLKS
         XiTg==
X-Gm-Message-State: AJIora/K0k0xr6JDbcP1cISgDl8AHB+wX7orxPxM/GO2oHATJKv5n8ha
        gUSPjTE26WCErDK4na1SRm8=
X-Google-Smtp-Source: AGRyM1t+4p6cdyGJ/g+qZ7OFSbM1kuluFIuSZnvurPe8vvvMAhV83NXQscQe7grfGgfB4LAHDT6fGA==
X-Received: by 2002:a17:907:3f12:b0:72f:b537:4a0 with SMTP id hq18-20020a1709073f1200b0072fb53704a0mr17590644ejc.40.1658933886021;
        Wed, 27 Jul 2022 07:58:06 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id n2-20020a056402060200b0043a87e6196esm10289198edv.6.2022.07.27.07.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:58:05 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:58:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, jaz@semihalf.com,
        tn@semihalf.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH v2] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
Message-ID: <20220727145802.is7teuybcgzwpbvg@skbuf>
References: <20220726230918.2772378-1-mw@semihalf.com>
 <20220726230918.2772378-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726230918.2772378-1-mw@semihalf.com>
 <20220726230918.2772378-1-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:09:18AM +0200, Marcin Wojtas wrote:
> Commit 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> stopped relying on SPEED_MAX constant and hardcoded speed settings
> for the switch ports and rely on phylink configuration.
> 
> It turned out, however, that when the relevant code is called,
> the mac_capabilites of CPU/DSA port remain unset.
> mv88e6xxx_setup_port() is called via mv88e6xxx_setup() in
> dsa_tree_setup_switches(), which precedes setting the caps in
> phylink_get_caps down in the chain of dsa_tree_setup_ports().
> 
> As a result the mac_capabilites are 0 and the default speed for CPU/DSA
> port is 10M at the start. To fix that, execute mv88e6xxx_get_caps()
> and obtain the capabilities driectly.
> 
> Fixes: 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
