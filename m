Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE074C441F
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbiBYMBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240337AbiBYMBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:01:39 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C632763E2
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:01:07 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id r13so10417124ejd.5
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jDjUmA6gk5EFqQ1BExbUKpCTLSI0ebRlaVNBi2tItq8=;
        b=p9voHynpBlBsxwtOwhgxwi1+Dlv+soZe/LUAC4UC/LIyOkO2SxG8YPcBgcCjWV0yKG
         qWsjP7nRyHsSwqLNmj5RZl6ipFV6wW6AlX2u+veZ9cDfCFdrjFF61aOKvQGvlBZvaJy6
         DUG8Wd3Ai4g5ZBU/874kaEUaLLo5nynUD9fQqAwnwT5kby8BjEJVJBa9j5oORfZLTXRm
         M65Ln7F8RsZ2pEJeYF7xFX+/hLUqO6pqQUqmRt1kmX+OpgvZAOKiFT3AZ6X6wlA76GMX
         bp1i96eS7lZHbBh2GkEbbglQCdTniyAvcSQrt8bioGq8kXbwoiaPlk+aBwvRaELvH6RQ
         StbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jDjUmA6gk5EFqQ1BExbUKpCTLSI0ebRlaVNBi2tItq8=;
        b=IVsOrlnUwj5K0D4Z38Q9VZbSGLoxaKyKwEioyoYwq6KY04CBPNK/EoepbXf2tPVKu7
         7PfvIkKtkrRAklvJKVmUF3sRSL4QQNhFDYisnLQCf8ZnMKEebx7sO599bpAEh6wLqGEb
         9W5eYVoYI29W68+ViCRaCVuhlakyreXiS+kL71M1MqgQQKAfgbJfMeu2V1lyK4Wa4wbw
         YdjYXKVVbE2GZWvH2BcaDDO1QYvmCh2aDoUfh37EhiA3BDLy59PfLtOcVXThMyNkamp+
         klu6OEdrMgQ2bv4Q4EFtCkBEsljUcKN0CsHeQsRuMjbh0OUDmXVGXasAsYSSU0eaCVEo
         tXeA==
X-Gm-Message-State: AOAM530jlbcxyvaPL1hv/C5jrjBxgYbPV8RSF/NcC4TEZq/ChDuDXUJN
        5cyLoF7l8aAZLCI9lJBEGME=
X-Google-Smtp-Source: ABdhPJzZA5nxsG+vSrDtiYJlcrkEytZV2a5V9bmjN38BwMUemxtZzb2cB+uuztBgsQHTKwAkPhrI3w==
X-Received: by 2002:a17:906:3650:b0:6ce:a6e0:3e97 with SMTP id r16-20020a170906365000b006cea6e03e97mr6058591ejb.15.1645790466295;
        Fri, 25 Feb 2022 04:01:06 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7cc0a000000b0040f826f09fdsm1229420edt.81.2022.02.25.04.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 04:01:05 -0800 (PST)
Date:   Fri, 25 Feb 2022 14:01:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] net: dsa: sja1105: support switching
 between SGMII and 2500BASE-X
Message-ID: <20220225120104.rdqpwlvfzvk7i2dt@skbuf>
References: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
 <E1nNZGt-00AbHB-KN@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNZGt-00AbHB-KN@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 12:00:27PM +0000, Russell King (Oracle) wrote:
> Vladimir Oltean suggests that sja1105 can support switching between
> SGMII and 2500BASE-X modes. Augment sja1105_phylink_get_caps() to
> fill in both interface modes if they can be supported.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
