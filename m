Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CC14C446A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiBYMQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiBYMQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:16:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D245A22759D
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:15:59 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id a23so10494627eju.3
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JLjMO5SQ8woi7JqWPtJdZvb4oKXZQ0lJVn363PJcUYA=;
        b=Sr57oM1DDUmVN1Y+tjAVIXGx0fza171PXYDjc2NO7iEXo11SwpEAw8Ra3Yuqai/agv
         ENTK1SU511UNLzJLJZy1Xrr0ieOOo0Lo6jG0r62PuGqRfvVn2FiHP5Wkx9oaNV4cKD0h
         lJ6k/sBOjUp5JoY5pMEmPHyH+Hf+WEcAemQ3VLjRoWYN+ukjmU+tnD6aTz/AyotT+sA+
         v+lDNhzSpMBZaiwAhZfRePFxd44DDFFEjRLJGDhGnbQ017v2v0Xk0//TOUyS/OmvJKMn
         tPiWcUl+74jaCZDD0HH3LssyC5dXhF5EHJhh1P0IlAeEO1jKCiwgly0GSjyEjbh24a/m
         7guQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JLjMO5SQ8woi7JqWPtJdZvb4oKXZQ0lJVn363PJcUYA=;
        b=7deaeyq9ctInq/S7CEaMagDV6w3WLWBhtj0az615+41KZ93A3UXFp4oQ5zSDEPUsOX
         XGgI+F+KxYqFL4UzJSSf/08JEykUhZKz+5ZAIrH7zPdPnkKJSoEngSKyrc3w7Sbu/tKg
         PLclDK1eDR/0pVzqUyUArlI98viHdx1VLW388mi5pglfk+feeJ0RmQcK1TUmFt+IQvX8
         v0yrRL0hLPaa2tozwksKjtbw+ZgRNYAltUCsc2GEH1Cbj4me8y1dg7tNPwvzxSzQCpVh
         bX8fzyboxClCNl+8e6Hh3GKeQrA/yOX3wWc+SuusOh/Hhf5yraFvPN9xoxjtUdTrEDkq
         e78w==
X-Gm-Message-State: AOAM533g+Uc2d05rwTze8Q/Zobtg1fUVafCbWyKNxEm6rNTCwVwgFEe0
        UvNvZAeGTTSyWFba4NaFPco=
X-Google-Smtp-Source: ABdhPJx6jxXc1dpPTjbXLnfAcitOEJuCphF4tLcgfFJSNIZVzUie2lC5hkypDUbDDRVxLbvvqfJzuA==
X-Received: by 2002:a17:906:d10c:b0:6cd:4aa2:cd62 with SMTP id b12-20020a170906d10c00b006cd4aa2cd62mr6133132ejz.229.1645791358366;
        Fri, 25 Feb 2022 04:15:58 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id k18-20020a50ce52000000b0040f75ad0e60sm1260200edj.83.2022.02.25.04.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 04:15:57 -0800 (PST)
Date:   Fri, 25 Feb 2022 14:15:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: dsa: sja1105: populate
 supported_interfaces
Message-ID: <20220225121556.u7cfh2hi7nq443jm@skbuf>
References: <YhjDvsSC1gZAYF74@shell.armlinux.org.uk>
 <E1nNZCc-00Ab1Q-Kg@rmk-PC.armlinux.org.uk>
 <20220225115858.6hwi4e55fjkgqzs5@skbuf>
 <YhjGolv59ZjDDr5I@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YhjGolv59ZjDDr5I@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 12:08:02PM +0000, Russell King (Oracle) wrote:
> On Fri, Feb 25, 2022 at 01:58:58PM +0200, Vladimir Oltean wrote:
> > On Fri, Feb 25, 2022 at 11:56:02AM +0000, Russell King (Oracle) wrote:
> > > Populate the supported interfaces bitmap for the SJA1105 DSA switch.
> > > 
> > > This switch only supports a static model of configuration, so we
> > > restrict the interface modes to the configured setting.
> > > 
> > > Reviewed-by: Vladimir Oltean <olteanv@gmail.com>                                Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > 
> > These all appear on the same line, can you please fix and resend?
> 
> I hate vi/vim precisely because of this.
> 
> How this problem happens. I read the email in mutt under KDE's kconsole
> with your attributation. I select the attributation so it can be pasted.
> I edit the commit, which starts vi, move to the line containing my
> sign-off, hit 'i' and paste it in.
> 
> The result is a line that _looks_ in vi as being entirely correct. The
> next line follows on as if it is a separate line.
> 
> I save the commit message. When I look at it in "git log", again,
> everything looks good.
> 
> The only times that it can be identified is after sending and looking
> at it in mutt, and noticing that the Signed-off-by line appears to have
> a# '+' prefix, indicating that mutt wrapped the line - or after it gets
> merged into net-next when linux-next identifies the lack of s-o-b, by
> which time it's too late to fix.
> 
> How do others avoid this problem? Not use vi/vim, but use some other
> editor such as emacs or microemacs that doesn't have this crazy way of
> dealing with multiple lines?

I do this in vim all the time and never had this problem.
Maybe you're not realizing it's on the same line because you don't have
line numbers turned on? A long line wrapped by the vim viewer would be
obvious.

:set number

Compare (just a random bit of a commit message)

 20 Fixes: 869f0ec048dc ("arm64: dts: freescale: Fix 'interrupt-map' parent address cells")           │
 21 Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com> Signed-off-by: Vladimir Oltean <vladimir.│
    oltean@nxp.com>                                                                                   │
 22

with

Fixes: 869f0ec048dc ("arm64: dts: freescale: Fix 'interrupt-map' parent address cells")               │
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com> Signed-off-by: Vladimir Oltean <vladimir.    │
oltean@nxp.com>                                                                                       │
