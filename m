Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DCC30D7D5
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhBCKm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbhBCKmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 05:42:53 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C9BC06174A
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 02:42:13 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t8so27643392ljk.10
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 02:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=W/Jx9T/D8g4ek0ww3H717M594yrmil+bxRpzkSE7ViA=;
        b=gZiO9jJ+In9gD8YLyVPSdM2eCHw6ycZal7rg026LXOj+kls2VxYE2cxJDRy6Vt352H
         83yLrfy7NTNM7hoQ0hwYfClRiB7q4Q+ptQvrEgnfHsw+CRaacehmMNX7LmyyMoiypwuo
         InVfz7yrl2JoGT/E8lsJWI2pOkOpgHDwjziQGJyMHgyX7jpEIRGvzOkjhGp2qnmwJC9W
         x7JV8MDcJu6kKzb9Sx+r+6lhfFx3DKAXPkSOYyTGqDsKLcC6ChdislGOYd19RN+wmtEK
         PwsjTvlqDeMEJ9d9VQhkNiPdwG9eQqMLc5GMjOEPBsoKFIWZUPmHTA1RmjNGp+sVnyi2
         zz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=W/Jx9T/D8g4ek0ww3H717M594yrmil+bxRpzkSE7ViA=;
        b=pzNzdnlby9VssTD9dFKXMshOBCIJ0raKgW1kZFNtDF6s23RU+cpkX9ccKIPNsFzB4I
         77ZP1Ct33mSl/6tIWSsvhuhPv04xRq0bZ5bnb/b+j4MUInlN36K9OeB/z9hIKlE5wN9e
         b/6WDmlmQIz28nZj+Du4AY6u1QR0TT8iZgzOdbAAR6izZ9WiU8VESUXysw3Y9Tjqrx0v
         Mms3qcvM59bveWs6xzwMvTkwM8NXxx8YtxZnFwa4ut1WJNVjE1WUUB3j+6IcUtlvKjWk
         cRcs4c3Q/1YHZGp3vgqK4gj88MC3k20bSxDbM56Y/p9YAOvN83/Z5gqbYhTKOwbgwIqZ
         2Ymg==
X-Gm-Message-State: AOAM530k0sYwo75+baVvZU/HH2unOQ08hiFfQ3ti5vgzqktILibXHP3K
        tb6Ftd6BMUH59wBOslcmtARsV/1qTSpI/W2l
X-Google-Smtp-Source: ABdhPJzUmwWD3zaWHdqM/8E/RROXxbH/9xfC+ABFlO1lYFMfxELn7JqbBoY6mr6mq3ckqCh+yfxOFQ==
X-Received: by 2002:a2e:8ed2:: with SMTP id e18mr1367442ljl.87.1612348931712;
        Wed, 03 Feb 2021 02:42:11 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u24sm201563lfu.81.2021.02.03.02.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 02:42:11 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [RFC net-next 7/7] net: dsa: mv88e6xxx: Request assisted learning on CPU port
In-Reply-To: <20210203101436.xpukhaiseak6wvbe@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com> <20210201062439.15244-1-dqfext@gmail.com> <8735yd5wnt.fsf@waldekranz.com> <20210203101436.xpukhaiseak6wvbe@skbuf>
Date:   Wed, 03 Feb 2021 11:42:10 +0100
Message-ID: <87zh0l4em5.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 12:14, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Feb 03, 2021 at 10:27:02AM +0100, Tobias Waldekranz wrote:
>> On Mon, Feb 01, 2021 at 14:24, DENG Qingfang <dqfext@gmail.com> wrote:
>> > I've tested your patch series on kernel 5.4 and found that it only works
>> > when VLAN filtering is enabled.
>> > After some debugging, I noticed DSA will add static entries to ATU 0 if
>> > VLAN filtering is disabled, regardless of default_pvid of the bridge,
>> > which is also the ATU# used by the bridge.
>> By default, a bridge will use a default PVID of 1, even when VLAN
>> filtering is disabled (nbp_vlan_init). Yet it will assign all packets to
>> VLAN 0 on ingress (br_handle_frame_finish->br_allowed_ingress).
>>
>> The switch OTOH, will use the PVID of the port for all packets when
>> 802.1Q is disabled, thus assigning all packets to VLAN 1 when VLAN
>> filtering is disabled.
>>
>> Andrew, Vladimir: Should mv88e6xxx always set the PVID to 0 when VLAN
>> filtering is disabled?
>
> For Ocelot/Felix, after trying to fight with some other fallout caused
> by a mismatch between hardware pvid and bridge pvid when vlan_filtering=0:
> https://patchwork.ozlabs.org/project/netdev/patch/20201015173355.564934-1-vladimir.oltean@nxp.com/
> I did this and lived happily ever after:

OK great, so there is precedent. I will add it to my TODO.

Thank you!
