Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689DF2F321C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbhALNpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389017AbhALNo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 08:44:57 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60108C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 05:44:14 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id 6so3591571ejz.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 05:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DggcAzaHrg9qcG/KEgarh9Ma3/As3Zhva7TDZfvS75Y=;
        b=tMLoMhpm3041nZeKJ3MNyTJmesBxx3i50iHgEXPmF7MwfT/K9LkXyowTNlHWaPLm/2
         TeE32jSEFhOeqtywz1uX6kdIe53+0hDW2arkcKr4j45ww33ue/Hp2ou/8j/+XguBB4PV
         0behYrRJD/kWYPFxV4x5sY5BO/UX2dxlOKF/bqdiflqvsde6/tc59ONtYCFwWQZLTWTJ
         KuDEpXqDX3Vi0yxQuVg03dVJRXS0WBm74ESOQePQGtU9hyIiFAfTx1p9g4K4P+N5FoSu
         4JRQ933lDfUuHaqZPlUN3O9kfBQuHcEbuqyS0TVRSfafSJQru/D6O2mjFJ7/R+1cAEcG
         gMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DggcAzaHrg9qcG/KEgarh9Ma3/As3Zhva7TDZfvS75Y=;
        b=p/QzJI+mrlBYk5epbUqAaE3plhr3hA3ik/mz9HK3iHTF+KY80V88gTxnThv6kcGj4s
         sgY5NAYostrjbYIOqD8qinAgTWwAjui6XcBmag7cOzcVEmFQ1mZTV+syALAxSC8v3dMG
         hiHf+TxkS1uKjCJFp524EYcNyySI4BlrkAjs/rTYM3Ouu+SMSDG5PUhkVsfvPQO3IGLp
         1+VPBK0eJ8oyR1C0zwDF9SyQLzU2bQYz0WxnJ2KubZY/h0QiUUHwLa/vWbHtrzrxNoAD
         vSARQTegdkQuoI5TgQ3/4qRnFbzQ9zPcDDCqXWe5Ff+QTFIw+BrCm+itYjgi7NXLdKtf
         Iz8w==
X-Gm-Message-State: AOAM532vZuUHs02NV1yuX5JPtukt7nY6KiQluifc2FJlRzHqvRKAgzeY
        ruhEf2PGgyRq5UoJZgG4THc=
X-Google-Smtp-Source: ABdhPJyBC3kynXECbal1GjqyWvfbKNUaGG/dyLC3eFGX2k1LqjgBM2+VKbodomnOQoOlxitMBxZ/tw==
X-Received: by 2002:a17:906:dfd5:: with SMTP id jt21mr3277313ejc.519.1610459053070;
        Tue, 12 Jan 2021 05:44:13 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id r11sm1447960edt.58.2021.01.12.05.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 05:44:12 -0800 (PST)
Date:   Tue, 12 Jan 2021 15:44:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [PATCH v6 net-next 03/15] net: procfs: hold netif_lists_lock
 when retrieving device statistics
Message-ID: <20210112134410.pr5lqv4hcxe3dxfy@skbuf>
References: <20210109172624.2028156-1-olteanv@gmail.com>
 <20210109172624.2028156-4-olteanv@gmail.com>
 <fa9efc8c4c0cb3dd3b0bba153b4b368e64ff06c3.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa9efc8c4c0cb3dd3b0bba153b4b368e64ff06c3.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 03:46:32PM -0800, Saeed Mahameed wrote:
> This can be very costly, holding a mutex while traversing the whole
> netedv lists and reading their stats, we need to at least allow
> multiple readers to enter as it was before, so maybe you want to use
> rw_semaphore instead of the mutex.
> 
> or just have a unified approach of rcu+refcnt/dev_hold as you did for
> bonding and failover patches #13..#14, I used the same approach to
> achieve the same for sysfs and procfs more than 2 years ago, you are
> welcome to use my patches:
> https://lore.kernel.org/netdev/4cc44e85-cb5e-502c-30f3-c6ea564fe9ac@gmail.com/

Ok, what mail address do you want me to keep for your sign off?
