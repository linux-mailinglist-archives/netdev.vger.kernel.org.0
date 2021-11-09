Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010E644B422
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 21:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244560AbhKIUno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 15:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242487AbhKIUnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 15:43:43 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F471C061764;
        Tue,  9 Nov 2021 12:40:57 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d5so163675wrc.1;
        Tue, 09 Nov 2021 12:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mg2e7z58lDe73VgrFciCdoCrTckxjsQdMH47LIpMlD8=;
        b=Lvp6NHOPZwHxPj+fWGq2BvF2OdAqief2GwNbnsMaefDadOSWDKKRqm4nLRL+frEpyn
         3KxZbtgCyg5WaAc7md7R3p0k2BKSjcdVrhP1UX8HyvvL8nEyjPsN5gIKQkVZMXEjuZht
         B9boo/vxS4NoUxhzQF06GsGAvqR63F77yGlkWa3Av52PpHn0WQBXQPFK6NqjB0mukGUl
         e1ecdTvzm6ZXzm5okWFnbpUUl8Xv52ZoFIygwJ/p/YnYDPpxmmamQBMbyVQf4Au0VQdK
         8VbYtJ5KUNe1E3SBSIpZfqkYRK2o+H9ydDPeJFetb8HMFLUTDwG/1l64AiNY9Yyja5oh
         ztLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mg2e7z58lDe73VgrFciCdoCrTckxjsQdMH47LIpMlD8=;
        b=BMEf8quqlRyJnHb6GvhkduziGhNFEvDoqRpXO/Bc4I4n0pbvjsj/0+THCwEZfNHZ13
         3VbetPCh7Xnnz8sWbBKVKrO9sg2IGP+uFk1qN2vRVOBthpPTqNnZJT5TTO9xET/Zx20E
         Zlcq5xCirXYFVRbdmx0iOiqlhyCK96tXk+cN5tQ9sRZSszQqjtR7M8pa3IdQtTxX4blx
         BZ+q2WFusV8mmGiLYe+BnaBS2uK7qNtrSF5Yb50ofLzCEmS54RlS8wTnztY+ucDikTiZ
         9JRRwhEreoJh8SHabCERmtzNVwakcq3xsXlPAtV2LqOSsjOE09kjQxLNIbfz1PMczO15
         v2/Q==
X-Gm-Message-State: AOAM531920aB0Ti7Xtu0tl5iptidCk4AAcsdVmslkpF2KmXfavq3/KWE
        RTKWddZv0gRpbZI54oLj1VKFaBhd6WU=
X-Google-Smtp-Source: ABdhPJwHsR1gf29UiIqSs41HqAedueBMeaFCg5gVeoGSnC2EYmMxGiaTJQFQe7hvoJXGYs2R4Sx2Nw==
X-Received: by 2002:a05:6000:23a:: with SMTP id l26mr12861034wrz.215.1636490455780;
        Tue, 09 Nov 2021 12:40:55 -0800 (PST)
Received: from Ansuel-xps.localdomain ([5.171.121.77])
        by smtp.gmail.com with ESMTPSA id i17sm3675547wmq.48.2021.11.09.12.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 12:40:55 -0800 (PST)
Date:   Tue, 9 Nov 2021 21:40:53 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v3 1/8] leds: add support for hardware driven LEDs
Message-ID: <YYrc1UfhVLEO/Nth@Ansuel-xps.localdomain>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-2-ansuelsmth@gmail.com>
 <YYrbT6pMGXqA2EVn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYrbT6pMGXqA2EVn@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 09:34:23PM +0100, Andrew Lunn wrote:
> On Tue, Nov 09, 2021 at 03:26:01AM +0100, Ansuel Smith wrote:
> > Some LEDs can be driven by hardware (for example a LED connected to
> > an ethernet PHY or an ethernet switch can be configured to blink on
> > activity on the network, which in software is done by the netdev trigger).
> > 
> > To do such offloading, LED driver must support this and a supported
> > trigger must be used.
> > 
> > LED driver should declare the correct blink_mode supported and should set
> > the blink_mode parameter to one of HARDWARE_CONTROLLED or
> > SOFTWARE_HARDWARE_CONTROLLED.
> > The trigger will check this option and fail to activate if the blink_mode
> > is not supported. By default if a LED driver doesn't declare blink_mode,
> > SOFTWARE_CONTROLLED is assumed.
> > 
> > The LED must implement 3 main API:
> > - trigger_offload_status(): This asks the LED driver if offload mode is
> >     enabled or not.
> >     Triggers will check if the offload mode is supported and will be
> >     activated accordingly. If the trigger can't run in software mode,
> >     return -EOPNOTSUPP as the blinking can't be simulated by software.
> 
> I don't understand this last part. The LED controller is not
> implementing software mode, other than providing a method to manually
> turn the LED on and off. And there is a well defined call for that. If
> that call is a NULL, it is clear it is not implemented. There is no
> need to ask the driver.
> 
>      Andrew

You are right I have to remove the last part as it doesn't make sense.
We already use blink_mode. Will remove in v4.

-- 
	Ansuel
