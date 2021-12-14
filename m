Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FB1474C7D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 21:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbhLNUKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 15:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhLNUKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 15:10:01 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54711C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:10:01 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so17008799pjb.5
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tUcxJau8o2NA6rKJurbeUEAP/6UqB5CVfGIYN2vnW8o=;
        b=LeMwMiKdKMAn3b/pQk1L45vAC8IvV7I18/2VGy217DUncWm2gT2zK5I5Fi0uKs68eb
         Q2ruhMDCXMVv+0uDImGpo6gxQmVb63pej4K05Y/LR2Cz1hh33LRG5e+sHYOXTfRODbft
         e16ahZ66yqnn9Qy91/9LlyEdhuj/LeAkIQKiyDwq6T+EWAMugjwf7ccY34DecejDDvCE
         QIdRciHyc3ylzWanr8ZDTklxsaD7h2XzplP8iXDwvrcC2GKz+F68qVA/Kx+bpyHF9P6V
         MmaaQIplRHS3EkR10H5uVLXWvSwZKYIBFYW7OsSgo4OSO3XnjJjX8rw8MFQFy4GcKSBP
         zXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tUcxJau8o2NA6rKJurbeUEAP/6UqB5CVfGIYN2vnW8o=;
        b=xdgtuwQt52tXrnUxL9d5BRbIeBQHbuVlxgKbSdL0bJeZ5aJQMpeuBoa73ZuBcXJeUq
         pqOs17JTFHN5bYlaKlZjDmayyab5PXWhowmuR6iJwUL2b+tcsyKMI6x5ZzPR4S0k+ci7
         w1kXplQgFvksp8YedwWfVeWepBxZPsu7fyoNvhcDfNa+FFUV/fF11fsNtBdvpdEgWmSM
         45bzmJuVXBnXtrd3EgNMPtHnnCsh1ZxcBoe2oz66/vfRbQIKzFV5ZJdUBWtLZ8NIvUVz
         lyjEoeaWyAa5WMxQM1CIQwIWq7UFE0nQlaAq+WrH1BiBAf5bYzWAtIEhG/3PI76Q7mGy
         c2Xw==
X-Gm-Message-State: AOAM53082YSFHtdst2A5n1OJoxbs1BuTC0TkBQXvtCoQ2iUk/ZpwktdG
        JtIYbgglfrKq9PoxuNAWeZ0=
X-Google-Smtp-Source: ABdhPJxq7/KH3dzED8URhIacHhE9U0jBb3QTQov+yf3wdX4hyTZkgzMwbcOIpgS+qHnxMGgaX7tB6Q==
X-Received: by 2002:a17:90a:2a47:: with SMTP id d7mr7791101pjg.155.1639512600833;
        Tue, 14 Dec 2021 12:10:00 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id il7sm411778pjb.54.2021.12.14.12.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 12:10:00 -0800 (PST)
Date:   Tue, 14 Dec 2021 12:09:57 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] net: dsa: hellcreek: Fix handling of
 MGMT protocols
Message-ID: <20211214200957.GA2576@hoboy.vegasvil.org>
References: <20211214134508.57806-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214134508.57806-1-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 02:45:04PM +0100, Kurt Kanzenbach wrote:

> Kurt Kanzenbach (4):
>   net: dsa: hellcreek: Fix insertion of static FDB entries
>   net: dsa: hellcreek: Add STP forwarding rule
>   net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports
>   net: dsa: hellcreek: Add missing PTP via UDP rules
> 
>  drivers/net/dsa/hirschmann/hellcreek.c | 87 +++++++++++++++++++++++---
>  1 file changed, 80 insertions(+), 7 deletions(-)

Acked-by: Richard Cochran <richardcochran@gmail.com>
