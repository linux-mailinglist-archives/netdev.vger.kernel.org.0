Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81593231DC
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhBWUIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhBWUHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 15:07:50 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF337C06174A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 12:07:09 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jt13so36499751ejb.0
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 12:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RBGCQP3sS45lWfuY4fvQFlAIxRom/+cG1QpxcL52oqU=;
        b=Vk1hNO0uUOHo8BBgph9fhMJ1NNRFSUEgKLDNgcLnLQhAMPJhLyEKiWca+PO8F+BXeX
         piCR7BXlb57d0VE+tR8aLaKIln7wARrUuUnw+TqwDeTVQgqVWt1dTdpd+h3ruMRgOsDq
         CHV2NDnGKntuHsmX69ZZFLxPtvNfaaojQ0bKzZ3aevMh162QOST4lUaB4KX8CZfpeEc2
         2rRNF8yLFQn4BoNjYbp6imCYjeDL7h8s9MiK4EHH93/lfi+JSLqi0euZ/WCjGnpYW6ET
         h5rb+dgmpXXTCA+HY1kMxA5yqFZhLBxfT1G8vRPpY+V1sa4JFEejWUddT0aGPx0q6BAs
         jdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RBGCQP3sS45lWfuY4fvQFlAIxRom/+cG1QpxcL52oqU=;
        b=Oc/ZAvUXWdy0LHiFImTLWm4JOHRW0WzF9/CkUgDKpS+lRMQ4R1rEDd/YEXYhrHC0fN
         CwLlL8s6H7LzacujXETYWi8qT9DAnIUhArqWr7HtjkfdOI3esXuMM2o6zVAEH60zwrTK
         z1p9mcjW6wT0anecbdrhTpqAcYr9QZMKkrcMvFVPPom35+q0eFhPxAFGh98m+VHR0GvF
         QKOdrjpQg3qF32nxHB1uwT8KrwxlP46wHrn4+roJYoB78/JsX8KeKE21PY7G8Nlp/Lf3
         3BA0Drz8C53d4PI1fceULaErbVObln+GGJdJqwlZXnF8bDnPjVORuZYc6fIB/y/kDhVQ
         nimQ==
X-Gm-Message-State: AOAM531Pbo2WD0UFi4YYIQqIbSjimqWdWfkvQXXtMs4UEb32nkAZtHRN
        w7WD7KseeYqgk1rRCxIkTuo=
X-Google-Smtp-Source: ABdhPJwLO1hkzUzIneI2KCgdscXpFppOh0AFSqiFyK0cEy4SgrEQjMcBgHWXFYqGWMR4VMHN1HdTTg==
X-Received: by 2002:a17:907:94d4:: with SMTP id dn20mr28004939ejc.397.1614110828772;
        Tue, 23 Feb 2021 12:07:08 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id j24sm1487989edy.3.2021.02.23.12.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 12:07:08 -0800 (PST)
Date:   Tue, 23 Feb 2021 22:07:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: Timing of host-joined bridge multicast groups with switchdev
Message-ID: <20210223200706.wubjodat6dyn2bmi@skbuf>
References: <20210223173753.vrlxhnj5rtvd6i6g@skbuf>
 <YDVBxrkYOtlmO1bn@shredder.lan>
 <20210223180236.e2ggiuxhr5aaayx5@skbuf>
 <YDVXhZdy510mFtG/@shredder.lan>
 <20210223194908.ne4a7abulirqfbs6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223194908.ne4a7abulirqfbs6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 09:49:08PM +0200, Vladimir Oltean wrote:
> > But I'm not sure how we replay it only for a single notifier block. I'm
> > not familiar with setups where you have more than one listener let alone
> > more than one that is interested in notifications from a specific
> > bridge, so maybe it is OK to just replay it for all the listeners. But I
> > would prefer to avoid it if we can.
> 
> At least with a driver-initiated pull, this seems to work:
...
> I am just not sure why I need to emit the notification only once per
> ASIC. Currently, SWITCHDEV_OBJ_ID_HOST_MDB is emitted for all bridge
> ports, so the callers need to reference-count it anyway. As for the port
> mdb entries, I am filtering the entries towards just a single port when
> that joins. So I think this is okay.

Sorry, I'm a bit more slow today.

So there seems to be no easy way to get access to the notifier block
that the new port uses, instead we can only call the entire notifier
chain from the bridge layer. I guess I'll have to defer that problem
until enough drivers make use of the pull mechanism that it becomes
unbearable then.
