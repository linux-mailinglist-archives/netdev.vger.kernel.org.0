Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38788326A5B
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhBZXUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBZXUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 18:20:12 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC41DC061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 15:19:31 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 18so7705644lff.6
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 15:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=T/LpDwoTwByw24gd30NVuDJjSRxDufrmRQWA3zhpaMo=;
        b=HMTJPhxsMm8lqeyqKmbPWUcLP8ylb1wKPB1rKmzSRj1rE85DWi/o/oi42+hMZLMS5b
         rh3XWEVPOMWdcJJDL4pvlSZ1fJPQr1zsAMorhSLuVFuisTvcsODbazKDNMEtey05u38y
         clYXdfRE2HCh9Twyt0j4inwhlHLwL/NbB+pTeqwst7tHC1Ao6DBKV05PYVuQDdYs5qhD
         mbUo9cWmLe4fZ38LiMhh9+sqSIBiFaURl2CdsQP+bGavFh4eENApuO98afQr0nRswfFV
         aOgdAoco7zxsuvEUActsyWk17GXTFgsMySxx74zivMbz0t2MmuYhfOmmcAQi7D18CKmf
         vV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=T/LpDwoTwByw24gd30NVuDJjSRxDufrmRQWA3zhpaMo=;
        b=JXYmv8ok1N4pJBklisIVMmbxqZyo6eM5BLuSNtOW41haUUE1U97xw9zTeaodV/hjhi
         R/phuMsLZtkog6CTrkbNzj1QZ4xdrBpHX1Q7/pvVuAUO+qBTkgEgWsCKR9iDUN5B63Vf
         acekIIk6WqtznZv+NTI6qW0V0u0EvOaw2JVkuYIWMPEpDH6BltX0e5Hruebz5QAuMrky
         etITAtx/qtthUKJA08zPXFMCHoIN4PgzQbBFSvQgG+k7LXMA2I3J1ERiVBpxn3/3IZG1
         uMYfiwsW61ae726kU167wfn/IIlQmGXK7azQhsqljNcdy3StP3h4civGXR0PFd0MSrCk
         L+vQ==
X-Gm-Message-State: AOAM530RIETx54fqq5dFpnPWxRr0WcjHb97k9kTNpV1xlZtpxmfGyKrc
        J9+xbhQGA3Mtw29d3V2pohWgbw==
X-Google-Smtp-Source: ABdhPJwt27w6jGjg7I8FAyazNy+qe9J9bscCbP9kYVOWsmOoWZ+dR8sOQG4ftES4z6Nlw7uY5ghNCw==
X-Received: by 2002:a05:6512:4c9:: with SMTP id w9mr1723618lfq.335.1614381570017;
        Fri, 26 Feb 2021 15:19:30 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id w3sm175717lfk.269.2021.02.26.15.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 15:19:29 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 02/12] Documentation: networking: dsa: rewrite chapter about tagging protocol
In-Reply-To: <20210226181250.4km4xf4ntxkts6y7@skbuf>
References: <20210221213355.1241450-1-olteanv@gmail.com> <20210221213355.1241450-3-olteanv@gmail.com> <87y2fbrivy.fsf@waldekranz.com> <20210226181250.4km4xf4ntxkts6y7@skbuf>
Date:   Sat, 27 Feb 2021 00:19:29 +0100
Message-ID: <87h7lyquwu.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 20:12, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Feb 25, 2021 at 09:29:21PM +0100, Tobias Waldekranz wrote:
>> This is not strictly true for mv88e6xxx. The connection between the tree
>> and the CPU may use Ethertyped DSA tags, while inter-switch links use
>> regular DSA tags.
>> 
>> However, I think it is better to keep this definition short, as it is
>> "true enough" :)
>
> What is the use case for this? Build a DSA tree out of old switches
> which support only DSA, plus new switches which support both DSA and
> EDSA, and have the host CPU see only EDSA, with the cascaded switches
> playing the role of DSA->EDSA adapters for the leaf switches?
> Is there any point in doing this? If it ever becomes necessary to
> support this, can't we just say that you should configure your entire
> DSA tree to use either DSA or EDSA, whichever happens to be supported
> across all devices? We already have support for changing the tag
> protocol, mv88e6xxx should implement it, then we could add some logic
> somewhere to scan for the DSA tree at probe time and figure out a common
> denominator.

This is already supported today. Cascade ports are _always_ set to
DSA. There are 2 reasons for that that I can think of:

1. It is the lowest common denominator, supported by all devices, so it
   makes for an easy algorithm.

2. It adds the minimum amount of overhead (4 bytes less than EDSA). If
   you are saturating your cascade link with 64B packets, that has quite
   an impact on your maximum pps.

As for why you would choose EDSA over DSA for connecting to the CPU: I
would say that on Linux with the DSA driver there is no reason, we could
probably drop the support altogether.

Before /sys/class/net/*/dsa/tagging, tcpdump could produce better
output, but that is no longer an issue.

The other advantage with EDSA is that you can use it for control traffic
(TO_CPU), while receiving data traffic (FORWARD) either untagged
Q-tagged. So you could use more of your NIC's offloads for example. But
this does not really work with the switchdev model as there is no
separation of control/data.

Though, now that I think about it, maybe we _can_ to that with the
filter method I just learned about from reading your excellent
documentation :)

Whether we want to is another question, but my guess is that things like
L3 forwarding performance could improve quite a bit, since there is less
memmoving around of L2 headers.
