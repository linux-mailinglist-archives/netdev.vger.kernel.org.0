Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A878F44766D
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhKGWtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhKGWtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 17:49:14 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051C3C061570;
        Sun,  7 Nov 2021 14:46:31 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id ee33so55351703edb.8;
        Sun, 07 Nov 2021 14:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bEiF+MMmD2sQTctyZ+whUpy7VksamCWgbQkB9bq4LEw=;
        b=h4oEnQmXZeeVTKMewnpzrd2adzQqUMfXYmoFx6YaVu75tIvAvU8KWwP3fN1cdvI5jS
         kiPjaoDDp1t8oswn8xtALKySNLUBfFddpYTMsWms03EmHFxXLOU8dNJmx15Rm69CwP9X
         QkTzvac/PZwYY+Wu26oLkrK1BgQYM14VhGOMOaSkBDg2bzhxWBaycQ1jO4oKJu/Ls6jg
         iULIRO7DfJPAifVG446FeEkEsndvoC36vGiL8NBrV8DAGLunFIdz91S7qx8U8yIVPXGl
         aRs3nktZ8TC2SG00XR/ntSfo3pFFYs+gJR5/BbJ9xHNEJslI/sBcQFBS/jxRliYZMXjm
         ogAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bEiF+MMmD2sQTctyZ+whUpy7VksamCWgbQkB9bq4LEw=;
        b=VTPunM5RD65YJD9pgfoOGmIbPl4bTK61ApPXots/Aqu7EHZfyQGFy/piaiN3SvOXqA
         fqbmIrlYmGx/0pVwQ2bclTvX863v8CdU31DTbCfznR5gNTJzHwxj4J+eOpJmfEKy8BrW
         8kNSYh6y3Y5o+rfruqJPg8Bz0XECFy2b6BEkYCSPS6p1ILamBoZx72cGOCZAWDRnK1iS
         OKPaRk2c3cNmx09mOV4rl9/nYdZV3rGUCybRT79KmxvLXwWEQIRITA9aimK3lom7I1YH
         K3L5q9U1CfCpUnT7kNZU4sEofEAx/kQm4RkPyqwwfpla/yz3/495UywOmMog522+O8JT
         W63g==
X-Gm-Message-State: AOAM533sWUMV+pd1Bgxxml0EYEifdMwjPv6KIub5GocmlIcXo5CAI6Rn
        BKDTJF+dQAv3a6tOXEQgExw=
X-Google-Smtp-Source: ABdhPJwbfy5hkh3avZSRxV96+bjuk0iL2V8Sfnu9bUgOAmQIJztQ383k6+/1JXl7RdPUmOJstMlsvg==
X-Received: by 2002:a17:907:2da3:: with SMTP id gt35mr84825722ejc.314.1636325189463;
        Sun, 07 Nov 2021 14:46:29 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id i4sm8174363edt.29.2021.11.07.14.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 14:46:29 -0800 (PST)
Date:   Sun, 7 Nov 2021 23:46:27 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] leds: trigger: add offload-phy-activity trigger
Message-ID: <YYhXQ3CuVlUmLJIz@Ansuel-xps.localdomain>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
 <20211107175718.9151-5-ansuelsmth@gmail.com>
 <befc2591-b96b-bac2-3b34-73cd3599049d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <befc2591-b96b-bac2-3b34-73cd3599049d@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 02:42:37PM -0800, Randy Dunlap wrote:
> On 11/7/21 9:57 AM, Ansuel Smith wrote:
> > +config LEDS_OFFLOAD_TRIGGER_PHY_ACTIVITY
> > +	tristate "LED Offload Trigger for PHY Activity"
> > +	depends on LEDS_OFFLOAD_TRIGGERS
> > +	help
> > +	  This allows LEDs to be configured to run by HW and offloaded based
> > +	  on some rules. The LED will blink or be on based on the PHY Activity
> > +	  for example on packet receive of based on the link speed.
> 
> Cannot parse:                           of based on
>

Typo. "on packet receive or based on the link speed"
You can find right below all the modes.

> > +	  The current rules are:
> 
> 
> -- 
> ~Randy

-- 
	Ansuel
