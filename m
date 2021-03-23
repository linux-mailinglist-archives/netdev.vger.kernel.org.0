Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B768345C69
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 12:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhCWLEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 07:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhCWLDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 07:03:31 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075C2C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 04:03:29 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id y1so24995537ljm.10
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 04:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WBxgCJhTRh1WcB80GYtxlS5QFCPAaAzzNvuI6b37OqI=;
        b=lC4fnoXFPSe37rwtbiqGitcathcpWNNR0fmRi8yqrF26eCPpRxsoXAw0iHHIvhXc55
         ST6bPtdNRf0aAX5x5Isxe89YIX0xEK2DrAGNAnUsDCjsUB+E1qm8VB+YX67nHbnj3yaN
         tL4QG8bMBDxMF9h6UpDn+lWv+iXNlGAlbiP7tBhLFJk/gJJf94FyU2YfLpDpaGN5TwBT
         EQPlYFayqslNJtAoGzq7ydw2TLcsS1+8vp2cQhUtCgZBMhOffNT+fKjEqdazYsNvfXZo
         l0n/Rs0UmuLqINCZYJc9lVk5pV/6wmFTVyioYPikNfGKb4SlXZL146y6lH0kP4Fvk+a1
         eBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WBxgCJhTRh1WcB80GYtxlS5QFCPAaAzzNvuI6b37OqI=;
        b=CX7xCaNcXjGwAExG/BZ3H3+RKH029k/ffgi2bqw5ouUyA0tnu//Pxj5mPIRtigs79O
         IUJwHPpmP29tgN0xm5LeJ7H83JHfwqhmbc5spCJdAW6iTG3QJy5pdlL8y9viYFuRISKF
         2lAn3f8ueGKP1WnZ2g66QM5/QMIjSYQ+aUNCX2ZJFIvARXcbfrBY0dQzrCD7EBr1tGy6
         N0d5rAR0kMQAMIsK4Rqw+RVP/hHoejzetKyjAWahlOtFfSXl+hoFF9NxzMPsyk1tiNr1
         xsDpBwtKLAcmuJmxMa1NBMF4C6/8YZDKjVE1OnmdoZrdL6o7hhTyj8wVBE/lywxMZSRd
         ypog==
X-Gm-Message-State: AOAM531bw1hVne1nqWdiyzUEQ0ExgxQknWqaqPdDNjAkTVDlx6bnuIEG
        z61+XS53Jg17Mo82awEa0H11TeEsuYTRJO4npZM=
X-Google-Smtp-Source: ABdhPJyvIW/AJOL07/K3dKLG7AJVrZHfkW9Vvtibd4QN5bt+jpCmj7ivTHr2kYpWrWtwgprlT1Fcsg==
X-Received: by 2002:a2e:b522:: with SMTP id z2mr2717075ljm.416.1616497407211;
        Tue, 23 Mar 2021 04:03:27 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w14sm1810984lfl.305.2021.03.23.04.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 04:03:26 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/8] net: dsa: mv88e6xxx: Offload bridge port flags
In-Reply-To: <20210323105249.vf5nmagufqnfpyh7@skbuf>
References: <20210318192540.895062-1-tobias@waldekranz.com> <87im5im9n4.fsf@waldekranz.com> <20210323105249.vf5nmagufqnfpyh7@skbuf>
Date:   Tue, 23 Mar 2021 12:03:26 +0100
Message-ID: <87ft0mm8sh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 12:52, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 23, 2021 at 11:45:03AM +0100, Tobias Waldekranz wrote:
>> On Thu, Mar 18, 2021 at 20:25, Tobias Waldekranz <tobias@waldekranz.com> wrote:
>> > Add support for offloading learning and broadcast flooding flags. With
>> > this in place, mv88e6xx supports offloading of all bridge port flags
>> > that are currently supported by the bridge.
>> >
>> > Broadcast flooding is somewhat awkward to control as there is no
>> > per-port bit for this like there is for unknown unicast and unknown
>> > multicast. Instead we have to update the ATU entry for the broadcast
>> > address for all currently used FIDs.
>> >
>> > v2 -> v3:
>> >   - Only return a netdev from dsa_port_to_bridge_port if the port is
>> >     currently bridged (Vladimir & Florian)
>> >
>> > v1 -> v2:
>> >   - Ensure that mv88e6xxx_vtu_get handles VID 0 (Vladimir)
>> >   - Fixed off-by-one in mv88e6xxx_port_set_assoc_vector (Vladimir)
>> >   - Fast age all entries on port when disabling learning (Vladimir)
>> >   - Correctly detect bridge flags on LAG ports (Vladimir)
>> >
>> > Tobias Waldekranz (8):
>> >   net: dsa: Add helper to resolve bridge port from DSA port
>> >   net: dsa: mv88e6xxx: Avoid useless attempts to fast-age LAGs
>> >   net: dsa: mv88e6xxx: Provide generic VTU iterator
>> >   net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
>> >   net: dsa: mv88e6xxx: Use standard helper for broadcast address
>> >   net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
>> >   net: dsa: mv88e6xxx: Offload bridge learning flag
>> >   net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag
>> >
>> >  drivers/net/dsa/mv88e6xxx/chip.c | 270 ++++++++++++++++++++++---------
>> >  drivers/net/dsa/mv88e6xxx/port.c |  21 +++
>> >  drivers/net/dsa/mv88e6xxx/port.h |   2 +
>> >  include/net/dsa.h                |  14 ++
>> >  net/dsa/dsa_priv.h               |  14 +-
>> >  5 files changed, 232 insertions(+), 89 deletions(-)
>> >
>> > -- 
>> > 2.25.1
>> 
>> Jakub/Dave, is anything blocking this series from going in? I am unable
>> to find the series on patchwork, is that why?
>
> Tobias, the series went in:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d7417ee918582504076ec1a74dfcd5fe1f55696c

Ahh, that explains that. I have been looking for it in the diffstat when
pulling net-next, but David pulled it in so fast that it probably flew
by before I expected it :)

> I'm not sure why the patchwork bot didn't go "deet-doot-dot, I am a bot"
> on us.

Yeah that is weird.

Thanks!
