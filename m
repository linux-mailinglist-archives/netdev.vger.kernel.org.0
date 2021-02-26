Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640173261AC
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 12:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhBZLAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 06:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhBZLAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 06:00:21 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3338BC06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:59:41 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id b1so2440516lfb.7
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 02:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=PdLUe4ZL0EK5wp0NIS6/QNIlN/dp+wyWGnbig5PvoDE=;
        b=vJz0VzgovGrKWcIF10SpNv0qonwHQ5S3FzdsKC18mf/FKM1bC3zbKVi3rfMoDd8KsC
         UiWRbhF3DOUgakMsBXK8W0twEXzOTEG3uHa2MCNszTJcP3hixjDzTa5DrEN0U/Lr/oiB
         3QXCZa8aobUCrI1kTUmTMLeckjoQWw5RLXA4o5bWOD3k8MC/29k9ErafYsA/la8IWRjd
         HhH1TdtB20WKzONNFwqGbyC0LXJ6ele5t7epGCje+JYAO7SHokgxuNeU4hwF1VehnnOd
         Y4CUOjwKlfDZMYfdAvDYL1gpIxi880MnkWH7qb3x2/W8bsT0mn3msq4TGTObThttiNLU
         yy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PdLUe4ZL0EK5wp0NIS6/QNIlN/dp+wyWGnbig5PvoDE=;
        b=nmE+1aVhSNXIuwJ09h4dFpxA5RDu4cGVSMwJrLpyt/j3OYtfR7ZOiGjZUV1GtqAqQL
         5WshLcmsjRuinoD8U5P8bNkf60b2yz5M6owlJyLMW87/uc76VjcN0fr5hp+lISOaZNLt
         vR4QY1K3KP0o3wIHlQo8I8k1qIFngTgILT4qa/mQCetZ8k3s5Ize3XxLwvQS9OkUb5Mh
         dtStUGFvViADAzjaM+QYwtVSXHMlDzB0H+CirjH1tampf1n0yp/3zQrXEFQOSPlmSaD7
         7/O9sTLGzbjwhRsiD/Yyue/QR4nm296QXbVc0/oqVzQIkjCNGaXdCEM1U++JNBAUx6GH
         /riQ==
X-Gm-Message-State: AOAM531HxrX6tk53CmZlNpDmAUQJAjuYPyKcw2qIyysEwftguzvUGzjg
        89RADj1gnH0KCzqCt6juggkZEQ==
X-Google-Smtp-Source: ABdhPJx6iaputC9agAqLtcC5MarnzmJH8lj7A2c3oz9UoklsQfS7sE/E9VEEHeDfd4P/URUXPcf5wA==
X-Received: by 2002:ac2:41d9:: with SMTP id d25mr1434914lfi.194.1614337179590;
        Fri, 26 Feb 2021 02:59:39 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id n3sm1394457ljg.13.2021.02.26.02.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 02:59:39 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 06/17] net: dsa: add addresses obtained from RX filtering to host addresses
In-Reply-To: <20210224114350.2791260-7-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com> <20210224114350.2791260-7-olteanv@gmail.com>
Date:   Fri, 26 Feb 2021 11:59:36 +0100
Message-ID: <87pn0nqelj.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 13:43, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> In case we have ptp4l running on a bridged DSA switch interface, the PTP
> traffic is classified as link-local (in the default profile, the MAC
> addresses are 01:1b:19:00:00:00 and 01:80:c2:00:00:0e), which means it
> isn't the responsibility of the bridge to make sure it gets trapped to
> the CPU.
>
> The solution is to implement the standard callbacks for dev_uc_add and
> dev_mc_add, and behave just like any other network interface: ensure
> that the user space program can see those packets.

So presumably the application would use PACKET_ADD_MEMBERSHIP to set
this up?

This is a really elegant way of solving this problem I think!

One problem I see is that this will not result in packets getting
trapped to the CPU, rather they will simply be forwarded.  I.e. with
this patch applied, once ptp4l adds the groups it is interested in, my
HW FDB will look like this:

ADDR                VID  DST   TYPE
01:1b:19:00:00:00     0  cpu0  static
01:80:c2:00:00:0e     0  cpu0  static

But this will not allow these groups to ingress on (STP) blocked
ports. AFAIK, PTP (certainly LLDP which also uses the latter group)
should be able to do that.

For mv88e6xxx (but I think this applies to most switches), there are
roughly three ways a given multicast group can reach the CPU:

1. Trap: Packet is unconditionally redirected to the CPU, independent
   of things like 802.1X or STP state on the ingressing port.
2. Mirror: Send a copy of packets that pass all other ingress policy to
   the CPU.
3. Forward: Forward packets that pass all other ingress policy to the
   CPU.

Entries are now added as "Forward", which means that the group will no
longer reach the other local ports. But the command from the application
is "I want to see these packets", it says nothing about preventing the
group from being forwarded. So I think the default ought to be
"Mirror". Additionally, we probably need some way of specifying "Trap"
to those applications that need it. E.g. ptp4l could specify
PACKET_MR_MULTICAST_TRAP in mr_action or something if it does not want
the bridge (or the switch) to forward it.

If "Forward" is desired, the existing "bridge mdb" interface seems like
the proper one, since it also affects other ports.
