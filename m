Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CCA32FC73
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 19:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhCFSR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 13:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhCFSRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 13:17:12 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0616CC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 10:17:12 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id r3so3718859lfc.13
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 10:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=C05xZlO9pteK4aU1l5GEyVAPwIn0LPOj5hiIDDT2Fss=;
        b=xT8d3FrvcW7uaIFKIdQYE85kZJtTROchu4PyocJZ7VSseaYKf5QJm1bcj9vgaRZ37+
         mkZR9WmmahcQudd4nfh4eVPxErCO3g1QkZxD+SZfekH+XDWumPKLgWMOwcI4oJd0mFqs
         NNT14bRuhUtj7iKvF9pdZsLFRHEKs1y/MAAsbCYuvBrhMyihMv0Dz7hOiFi9f2qki6aK
         dNXzxEOnDJDKGLamOXWZCuyYGo2DsG/yj8EOZZqV+IIWXlGAmB5CAJ4lHhM0kyJ4xHHH
         biYW2Nc9QgxV7J7H1ghwzbgiW83qB22wW8QkPIMszQh3ToLC0rJDlyH6I9CsXgQ/uQoX
         +htg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=C05xZlO9pteK4aU1l5GEyVAPwIn0LPOj5hiIDDT2Fss=;
        b=Z4qMTFI9G27pbkm2XBxbtoClbDYGQ1/1ELzbnbiXNTNUriQuTMniQqrqivExiQeRJ6
         x0jc51cEHPWdy9k/VEEw0qWvg+4SOSWvYC2gMkY1I8bOVKc1aZRcR1EUrbBIZEY2f3ca
         1fwikOfHcLN7QaAebhevnenFDOk0a3y6VtBMJ0HEsncWLZijJZ4VecXSAfaGOD0RdgLI
         aWyJZRcmjK1r7xy6GZmfwI4OCnNCDn6P5gjITRiTDa+BUtPLAchsQJuzrqzXo8oIVQpM
         bI+g1Lj/l+fH555Ja4XXbilgQ576nP/D+xr8x3ix/2M9uOYi2q2Xn/Ddv/eW0xEEgYCD
         mhxQ==
X-Gm-Message-State: AOAM532GIGkFUEG1ztg8K5zES/hTQ881jeJ742D004mAJ3rQcrWqRmE8
        eaDkBCnYdN5xaLu7/snIzF7bsYeA+YU9gg==
X-Google-Smtp-Source: ABdhPJyFzywrgh1jimi4CLpZQV4Ncohc++6aKVRfeVdUBdUaSnGIO+nefWLGb20mvtWVzEzZ3eRzUg==
X-Received: by 2002:a05:6512:6d0:: with SMTP id u16mr9056774lff.300.1615054630210;
        Sat, 06 Mar 2021 10:17:10 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id z20sm733396lfh.178.2021.03.06.10.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 10:17:09 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: Always react to global bridge attribute changes
In-Reply-To: <20210306140440.3uwmyji4smxdpgpm@skbuf>
References: <20210306002455.1582593-1-tobias@waldekranz.com> <20210306002455.1582593-3-tobias@waldekranz.com> <20210306140033.axpbtqamaruzzzew@skbuf> <20210306140440.3uwmyji4smxdpgpm@skbuf>
Date:   Sat, 06 Mar 2021 19:17:09 +0100
Message-ID: <87czwcqh96.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 16:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Sat, Mar 06, 2021 at 04:00:33PM +0200, Vladimir Oltean wrote:
>> Hi Tobias,
>>
>> On Sat, Mar 06, 2021 at 01:24:55AM +0100, Tobias Waldekranz wrote:
>> > This is the second attempt to provide a fix for the issue described in
>> > 99b8202b179f, which was reverted in the previous commit.
>> >
>> > When a change is made to some global bridge attribute, such as VLAN
>> > filtering, accept events where orig_dev is the bridge master netdev.
>> >
>> > Separate the validation of orig_dev based on whether the attribute in
>> > question is global or per-port.
>> >
>> > Fixes: 5696c8aedfcc ("net: dsa: Don't offload port attributes on standalone ports")
>> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> > ---
>>
>> What do you think about this alternative?
>
> Ah, wait, this won't work when offloading objects/attributes on a LAG.
> Let me actually test your patch.

Right. But you made me realize that my v1 is also flawed, because it
does not guard against trying to apply attributes to non-offloaded
ports. ...the original issue :facepalm:

I have a version ready which reuses the exact predicate that you
previously added to dsa_port_offloads_netdev:

-               if (netif_is_bridge_master(attr->orig_dev))
+               if (dp->bridge_dev == attr->orig_dev)

Do you think anything else needs to be changed, or should I send that as
v2?
