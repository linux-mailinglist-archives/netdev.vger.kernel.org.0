Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28C84464B3
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 15:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhKEOQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhKEOQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 10:16:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A0BC061714;
        Fri,  5 Nov 2021 07:14:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so3464691pjb.1;
        Fri, 05 Nov 2021 07:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UAdWLhVbmpcMPvEzkqOSE4eZqcPjG43ILrvT9vGpQ6o=;
        b=RLHS0+2iHo+MgqkP0dPPF7zlOvMZ40e73VrQLXGvuulyjWacoYIu0SnBy3c+jNT+nE
         A7bfCcUNR8AQKCUR9D3zmfZTi6vjmjJH9LNDqsjleW7apqT8EcXt8XdWzTXX3z75IkNr
         hh1vzdyF36pYFnF7VWDp3oACaucGqENrxGCS/Uc0vmjDE6ypzXHfogF7/BWJOfD1x5yj
         TzlTkbp3Ehu/jfStcSWMZI+vn6u3J2PeMNFk4rnt9UNz+4jddzl6JqXYdQ8wi2fuZtb9
         Re4bziuspFEp8S8a1HYPhNC6gL5AUyJ6yCo+uD8gkmLrgQnF0qg0cvY2IA7rk2Vut3UK
         7SEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UAdWLhVbmpcMPvEzkqOSE4eZqcPjG43ILrvT9vGpQ6o=;
        b=3eIKHjbNwnVtKNSaHnFnZ5yAjDP3AWdiTinx0Km1Fu0rlnSxvUb9bGkVSfQAlnuara
         uNsrM9o2FKjHTbxS6F1R6SLs3EXpJ1GXdfXGWFQimhMoGcppAbikA0448/apQfKFrnaK
         2qFjPsIq4hfTveLYGfkxs8IE0i3z425YyPOFtKLacq2OW1jumSs6Y1rwUwbN0scRFLkb
         rdhk+Tpv4cx+66RllP7rBqJTYWjt6c2C1F5yBEXwThFoIzhxGfKrY3Zjc6S1jImxwZJP
         j+ks47Q35nnZtA+rA95DowO3tbym79bkLaZMp3jqaIhqjO2YHT3W1uyazFEEXptqrZpc
         oS0g==
X-Gm-Message-State: AOAM530fN2lZgbcHfGOxxro9qNMRqcrmYko3fAXYOGqiqwDd6cPOefGt
        SfjG+DZmTqtBbYATNq5++Vk=
X-Google-Smtp-Source: ABdhPJw225KFwpyyOBi/M4OJGWqF3qT1gOncgGJeSRTBd4DJACTtYQxc8CPLTYfkBLfjrqa+G4HaXA==
X-Received: by 2002:a17:902:cecf:b0:141:e15d:4a2a with SMTP id d15-20020a170902cecf00b00141e15d4a2amr33690604plg.66.1636121649970;
        Fri, 05 Nov 2021 07:14:09 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id mr2sm6422554pjb.25.2021.11.05.07.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 07:14:09 -0700 (PDT)
Date:   Fri, 5 Nov 2021 07:14:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Message-ID: <20211105141407.GB16456@hoboy.vegasvil.org>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105141319.GA16456@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 07:13:19AM -0700, Richard Cochran wrote:
> On Fri, Nov 05, 2021 at 02:38:01PM +0100, Martin Kaistra wrote:
> > Ok, then I will remove HWTSTAMP_FILTER_PTP_V2_(EVENT|SYNC|DELAY_REQ) from
> > this list, what about HWTSTAMP_FILTER_ALL?
> 
> AKK means time stamp every received frame, so your driver should

s/AKK/ALL/

> return an error in this case as well.
> 
> Thanks,
> Richard
>  
