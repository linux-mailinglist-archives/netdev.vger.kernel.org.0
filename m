Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55225259135
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgIAOsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgIAOsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:48:00 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06A2C061244;
        Tue,  1 Sep 2020 07:47:59 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id h4so2086030ejj.0;
        Tue, 01 Sep 2020 07:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/LMHXr3k3JO3kQFd2w4+9nVbRwQcfH7U6hJYUZVSo9o=;
        b=XxjYDKKXT0ZQLI7ZL7stqxP36WiWegyNzoE06ioAIqAzb46Jkp4N8IkEgMlMCNSEpJ
         LGroqrU9XtKSCUXDKrvg3bg8+YLFdx/5AOld3EsXXH0VWNLRBbE9vzkZn2LQyeZKVDx7
         LM601O3ox2EMX7CKqRBYv+xp1ctityBQYnkKHwqfIveqxdS5wwNBQf08fFafOHCDn1Il
         o3M0T+MehaY0W3PIno2RhC29Mas8xLSjZJ2/p5NSylq7GjEn4P9i/910HdKvz9Z37VUy
         vf5lmxYTITM3YA0WNGCqfKgLh/nd8YZUFqf89VsWgrlhTqQrSZSJ6bEhfoUm4u/yfUVn
         eTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/LMHXr3k3JO3kQFd2w4+9nVbRwQcfH7U6hJYUZVSo9o=;
        b=Oy7J5HUGoSgBG7EB7Kp1hG6kqnSG8ghU+HOQN/bnsmFZljAf0LfHlszP6zgbuibjgq
         F216CmHj9PeYNeYarmciXNtea5G9c3LDnEnNFZmLP0FI1MtsOU1/o3AMQxJmIiegvGOH
         SydrnkH0n4/lzksRkLpgA0F3P51nxJmC5CcgraHabrxbR+kW709v1u/LZd19DYslqZ0P
         SfMoPFAJzgo/rujf8wuEswjRrnjZ8fc4wZi9XlNRwZG3Z0rjjYoRPO0bKZDsvke3W3c1
         tRz1zd773g9GRuZ7BKnyCoqCAx8ikf09iIdWYZgaUDnfreklMbQgBnBt2MfSpDGmQDWy
         CtcQ==
X-Gm-Message-State: AOAM530vKdcXd/7J48wJhQyVO0Sv/Uj0T0q3vr+2muzYLQd0DdCzr11E
        3EGVap6iQHYWqwpVbt01V70=
X-Google-Smtp-Source: ABdhPJwjO60NL00+4drwU7HBYj27ddWfKe0WiE48gtrA19FeunNZ7+deCMEDvuOF7S+RXacZZJ5fUQ==
X-Received: by 2002:a17:906:3957:: with SMTP id g23mr1921217eje.24.1598971678516;
        Tue, 01 Sep 2020 07:47:58 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id n15sm1460254eja.26.2020.09.01.07.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 07:47:58 -0700 (PDT)
Date:   Tue, 1 Sep 2020 17:47:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
Message-ID: <20200901144755.jd2wnmweywwvkwvl@skbuf>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-6-kurt@linutronix.de>
 <87pn7ftx6b.fsf@intel.com>
 <87bliz13kj.fsf@kurt>
 <20200825093219.bybzzpyfbbccjanf@skbuf>
 <87v9gxefzj.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9gxefzj.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 01, 2020 at 04:20:00PM +0200, Kurt Kanzenbach wrote:
>
> After giving this a bit more thought, it can be implemented by using
> workqueues only. That ptp time is "cached" anyway the we could just
> periodically check for the base time arrival. That should solve the
> irqsave and the being synchronized problem.
>
> Thanks,
> Kurt

Ok, this sounds simple enough. If the base-time is within 8 seconds of
the current PTP time, then apply the taprio configuration, otherwise
reschedule a delayed workqueue after N seconds (where N has what
value?).

If my math is correct, then N can't simply be the the delta between the
current PTP time and the (base-time minus 8 seconds) value - i.e. just
one schedule_delayed_work - because at large deltas, the PHC frequency
adjustment (+/- 6.25%) starts to matter. At maximum frequency, the PHC
can exceed the monotonic clock of the system by more than 8 seconds in
(8 * 100 / 6.25) = 128 seconds. So if the base-time is in the future by
more than 128 seconds and you plan for a single schedule_delayed_work,
there's a chance that you'll miss the window. And even if you try to
compensate using the current frequency adjustment, that's all that it is
- the current, instantaneous frequency adjustment, not the one from 128
seconds later.

How about N being half that delta? It's not ideal, since there would
need to be log2(delta) reschedules, but at least the error of the first
approximation won't propagate to the next, and the delta will keep
decreasing as time passes, therefore so will the error.

Thanks,
-Vladimir
