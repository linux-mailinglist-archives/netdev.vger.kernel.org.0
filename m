Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B413D2F9571
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 22:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbhAQVWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 16:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbhAQVWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 16:22:35 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24377C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 13:21:55 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c6so8278267ede.0
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 13:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3bsarhbzhKm1fQIXTqZtVImEKIUz+RAmZFrCBsfu9Ew=;
        b=tADhvubCiqaD2dE+C7CbipXrYx7j5AMJkLZ9cgx6t1//++7lhdqw7ncAc79wy6mEK9
         hd7BHyPix47/prnI2TlAw2Y4GO+MThZx6ExpLs9INRLj5xv1WDEGf/Mkj9igG8ydGwJc
         mcMTU9nkUxOsTQ/2d4vuusR0k+RdANYKTVoLUIDsHkvftyQt8bwr20Gu9RaoNQNKluNF
         d+JVRfUPb+Uoz/LFwFMD1fOQLIURYb8VS7y4qtwS1uiH+JtpqFXSKiXMfdGDYomRJsin
         +lIpd2qk6KznyIGT5ut3WoOGm+NWGyq1o1tUFx10DUX68/CFDYeMcNhqyMxHcdihTWOj
         UFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3bsarhbzhKm1fQIXTqZtVImEKIUz+RAmZFrCBsfu9Ew=;
        b=eIhe7b8un6GCLF860VhopT7J3PfhRyXQs6dlElQBEF/Egdk/Nlql93Ao/9PaPq/t7R
         nKS+qk9g4e1ARZu5AybCX0XRBemEvtcYSL3VtH8LhbP7/wFF/QH+f3q8dCN5wEwG2M3W
         0JWVirIip7fIjLAMUFZHKhr25ZULcUAqjyFDfc9+m8mloHybPT8jiPBDbBAd1K1TFxG6
         0Y/yJfjDLSwk4QPnva5A3+d8Bx7ffwk4Ybn5rkI1Lk3TOPSOpgzYbSRwj/lpD6YWOrAm
         I4dJaoCHO/SQvAzw1NVVeaXO0RfARtswi/x4Vm3kgI0COURJoTY0qOOuj6B3+NnnuJnH
         xIgA==
X-Gm-Message-State: AOAM532jvJpFWsHIGEfAgnBQ4KSbtuD4lY23V2zwRzzOU955ZF8VkKoz
        wfJS7/+VACq5zAwH+qkSWFo=
X-Google-Smtp-Source: ABdhPJxrl3y2xrvELvYk+yIVU+iUkQiP61lUmhm971cU1j7xjN5b88D2yQuv8mtfkMktsXgcLRA6+g==
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr16811932edt.296.1610918513782;
        Sun, 17 Jan 2021 13:21:53 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id v24sm9606586edw.23.2021.01.17.13.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 13:21:53 -0800 (PST)
Date:   Sun, 17 Jan 2021 23:21:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/1] net: dsa: hellcreek: Add TAPRIO
 offloading support
Message-ID: <20210117212152.njfq75lt3selqbar@skbuf>
References: <20210116124922.32356-1-kurt@linutronix.de>
 <20210116124922.32356-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116124922.32356-2-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 01:49:22PM +0100, Kurt Kanzenbach wrote:
> The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
> schedules may be configured individually on each front port. Each port has eight
> egress queues. The traffic is mapped to a traffic class respectively via the PCP
> field of a VLAN tagged frame.
>
> The TAPRIO Qdisc already implements that. Therefore, this interface can simply
> be reused. Add .port_setup_tc() accordingly.
>
> The activation of a schedule on a port is split into two parts:
>
>  * Programming the necessary gate control list (GCL)
>  * Setup delayed work for starting the schedule
>
> The hardware supports starting a schedule up to eight seconds in the future. The
> TAPRIO interface provides an absolute base time. Therefore, periodic delayed
> work is leveraged to check whether a schedule may be started or not.
>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
