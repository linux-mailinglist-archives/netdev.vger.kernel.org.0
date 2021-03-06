Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1AB32FD61
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 22:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhCFVQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 16:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhCFVQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 16:16:15 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349BBC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 13:16:15 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id q25so12603473lfc.8
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 13:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=en8md+IJizqgaMmmIE+AOWKMVs74MqtB4uZeWP4ZEDY=;
        b=tnLwOgBycq3JwcvZiG3elA1V25O3PfOrHy22SiDZjM0UPnh57F45unw0clQ7DTCE1H
         X//xiIbvLY4Te9L93APq0PpR//W7vTlPeE+LUshKrch6dlD5elk2VSUc1jlNt6iY3m8M
         iBgdEVi9DMydfQRIfpwpLJwS8bZDgoiJHs0XIP+vvptDemeZHAzkv6XE8olUZynwDdT/
         xffXnTRKVwJnWECMrmnDzISeJGbSgiu7JhLA2yyqjCVtDuDdVwJFdVPvGDCVwhgpe3sy
         U2ECAN+NEbobZPIJ1rtxOenZIHmGJPGShHSX+I6AraqMArz39yiX/JTj0Yru1XtV7roF
         5U7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=en8md+IJizqgaMmmIE+AOWKMVs74MqtB4uZeWP4ZEDY=;
        b=eDjvraAfRGr6L1ZuG1jo5f8tlT2jmh4iGeFw7eWd7GwnctCpACNifNx/VQGAWeAqCJ
         xgQ7+6KOcMZitT3U+Dksctv5qkMvyN+HL+o5k3qU/FLqhPEv8uQkiZjaeQ5N2G4clPug
         sVJVjwr+Ab3TyzM5W88i1xO0H2YPYbzL8ibteX3/4GBg25b07kE8gRTbS5YBHPcCvy1H
         lCI6yf7yR+pr5JPcaCXIIPU6J8HUnedtG3PZOpKX/ZSxbd5ijxsRMi0e1AUD6kFPr0wx
         jPIlx+qlB/+XpooHjVvE3+y2PHenPkSeEiUL4f8oO9Bk8EhJ6iCuuuKF0UOCuxxaWOOX
         SB6g==
X-Gm-Message-State: AOAM530WJLJYel+OKRXkyMuEXnbP84RgRevAhyvVgeqlg2hLdxZ/W1oR
        7UszTbK+TIE3kt7iipoUCy8CYg==
X-Google-Smtp-Source: ABdhPJy1SXuvpJCwLUU1hjru8ON6whFHskvNjBvhDEnAyTIm9VHSU7JxUJFWquX+s+Iqm/RFkjLgtg==
X-Received: by 2002:a19:7402:: with SMTP id v2mr9498726lfe.58.1615065373712;
        Sat, 06 Mar 2021 13:16:13 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id 188sm222675lfo.0.2021.03.06.13.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 13:16:12 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: Query on new ethtool RSS hashing options
In-Reply-To: <20210306125427.tzt42itdwukz2cto@skbuf>
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com> <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CA+sq2CfwCTZ1zXpBkYHZpKfWSFABuOrHpGqdG+4uRRip+O+pYQ@mail.gmail.com> <20210306125427.tzt42itdwukz2cto@skbuf>
Date:   Sat, 06 Mar 2021 22:16:12 +0100
Message-ID: <87a6rgq8yr.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 14:54, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Sat, Mar 06, 2021 at 05:38:14PM +0530, Sunil Kovvuri wrote:
>> > Can you share the format of the DSA tag? Is there a driver for it
>> > upstream? Do we need to represent it in union ethtool_flow_union?
>> >
>> 
>> No, there is no driver for this tag in the kernel.
>> I have attached the tag format.
>> There are multiple DSA tag formats and representing them ethtool_flow
>> union would be difficult.
>> Hence wondering if it would be okay to add a more flexible way ie
>> offset and num_bytes from the start of packet.
>
> How sure are you that the tag format you've shared is not identical to
> the one parsed by net/dsa/tag_dsa.c?

That is indeed the format parsed by tag_dsa.c. Based on the layout in
the image, I am pretty sure that it is from the functional spec. of the
Amethyst (6393X). So while the format is supported, that specific device
is not. Hopefully that will change soon:

https://lore.kernel.org/netdev/cover.1610071984.git.pavana.sharma@digi.com/

As for the NIC: Marvell has an EVK for the Amethyst, connected to a
CN9130 SoC. The ethernet controllers in those can parse DSA tags in
hardware, so I would put my money on that.

The upstream driver (mvpp2) does not seem to support it though, AFAIK.
