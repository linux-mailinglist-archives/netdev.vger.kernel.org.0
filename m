Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEDD2B2D8B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 15:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgKNOAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 09:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgKNOAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 09:00:08 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4439AC0613D2
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 06:00:06 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id u18so18281380lfd.9
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 06:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=AGcVlRZ9vE1VQQJQyinrCZx9zIfIuSlLjtVaKeF4RGs=;
        b=INDtGaCkS0hpL4OxFtq0WAE0ZY3XPvpkhMefnsCYizWNOYEN8WNoQv2mjz8b96aKfp
         mC29/Av9RGTOXYjmhvz46Se1u7R9sEGsjs8x2TmtkDv61B8Rxx4d3vY7PxvifqlrgYNn
         xamKk3aIlJzYSMmFcy4kA8vfjLUHo9iiF7FXxtTc0mGdWkK6jdlVem0s9szVcajlf23k
         fTc4QzyStsX9rqLO65GS4eUd/pBDc3J+cz/r0GFOTAjRBXwszbckd9FJQKhMVu7Fzth0
         K5Z6lGD7kcBvseBztFhLcbWozJjYNmH6fKv6j1rJWKQlQOi/rGFTvGkau6yL8CwzE6HR
         xSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AGcVlRZ9vE1VQQJQyinrCZx9zIfIuSlLjtVaKeF4RGs=;
        b=EO+KQj51zmQilHiIKYnHqMog2N3G0+7Hc5H81W4idxIPrl4CVmekTY4701ZN2AU0hi
         yoS5kRLy6G35XvXAof/XnsgHXBlcJIUTaK9deoETCn+WTQ+b4kdeY5S554bNLCZKqZ/g
         AQmWEUUQQWyA8fx6s8tPOSWSQynu77xzI58ClalXYzKvLiQlsNPM47CQTeme1qyZ1Dcj
         lnACJNS2oKzhxtDrgcYAQodVX480+Z+P6i/ZD0bCC0v5388BzTCgLe2onuwrK8MI02cv
         E6xMVoBCGZ/4sx6rrblweOKJhFQWk6DMi4lpAy1q7ZoVLIat0DbGuh0AOpIoD/SwNweH
         nsmA==
X-Gm-Message-State: AOAM5334Nyh1Qgkcxi5bPEmVFtSNXyfpR1T/7hc8vdomuSwX4mj1tM0o
        K/+rRmtbjiIBzBwDN0E0gKDShg==
X-Google-Smtp-Source: ABdhPJzDqsUurfGe5s9cJYc0mLhuivmbdq3AH9gHgXmlZYcOYCyKDA61wtFCYSVXczhPArdCGiXbRg==
X-Received: by 2002:a19:587:: with SMTP id 129mr2609236lff.189.1605362404613;
        Sat, 14 Nov 2020 06:00:04 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id p137sm1639415lfa.146.2020.11.14.06.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 06:00:04 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan enhancements
In-Reply-To: <20201114115906.GA21025@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org> <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20201114115906.GA21025@salvia>
Date:   Sat, 14 Nov 2020 15:00:03 +0100
Message-ID: <87sg9cjaxo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 12:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If any of the flowtable device goes down / removed, the entries are
> removed from the flowtable. This means packets of existing flows are
> pushed up back to classic bridge / forwarding path to re-evaluate the
> fast path.
>
> For each new flow, the fast path that is selected freshly, so they use
> the up-to-date FDB to select a new bridge port.
>
> Existing flows still follow the old path. The same happens with FIB
> currently.
>
> It should be possible to explore purging entries in the flowtable that
> are stale due to changes in the topology (either in FDB or FIB).
>
> What scenario do you have specifically in mind? Something like VM
> migrates from one bridge port to another?

This should work in the case when the bridge ports are normal NICs or
switchdev ports, right?

In that case, relying on link state is brittle as you can easily have a
switch or a media converter between the bridge and the end-station:

        br0                  br0
        / \                  / \
    eth0   eth1          eth0   eth1
     /      \      =>     /      \
  [sw0]     [sw1]      [sw0]     [sw1]
   /          \         /          \
  A                                 A

In a scenario like this, A has clearly moved. But neither eth0 nor eth1
has seen any changes in link state.

This particular example is a bit contrived. But this is essentially what
happens in redundant topologies when reconfigurations occur (e.g. STP).

These protocols will typically signal reconfigurations to all bridges
though, so as long as the affected flows are flushed at the same time as
the FDB it should work.

Interesting stuff!
