Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA87485E72
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 03:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344610AbiAFCLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 21:11:01 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:55512
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344611AbiAFCKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 21:10:55 -0500
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0E68D4002A
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 02:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641435049;
        bh=kCp8BU9jFTwzHT3B2Mn0sWuhrSLvpFWxrZu1tCP3WDA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=TTDo6YYTRzsThukuPQmAdSoT+i2emWdqgLst6PUcgM5HxbnBeG9b/8aWGDhscXP9x
         pO3XhTIGTgyAY4eDyw3MYI1aRYjrR0bKg3BRTk3D5hMxzwsRMjzjfeCF73TNDAxit+
         NjIt5BXi7BweEpH77xXZokvM+poaBNnZzHqlujkk9l+Zr72jqYL1kzA4AzgYBKi4ua
         s1hkODm+H0nVu2SiUrXEub4PjYTkItEw740vVWH+vfbdZW+Ga2siGa/gyQ9l2+V5AM
         yFZMg3zY2nFWHKlkXgLwd/UGK3/1clxndsdGXRuXWUakB/lyTqwOHx8dnEBgzOAAkP
         fFfKPw64qdbpg==
Received: by mail-ot1-f70.google.com with SMTP id e59-20020a9d2ac1000000b0058f1da0d3f1so471509otb.15
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 18:10:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kCp8BU9jFTwzHT3B2Mn0sWuhrSLvpFWxrZu1tCP3WDA=;
        b=o2DgmIRitHCOAxJvzuPputf2YyNgjo6x5F3zmvqvb6iKAWcZjxCVuqNdS/QxDmNtdn
         EctN7SmnnL7SqF5RtyQ6wXnQm9a2xq2RYx/eyvDOb+TrhcLE0MTq59+3ixaNVKvRtdAl
         pnoy8w2aycR1YpkgcUrtTIMF37WAbi3FFe1OvSKL0GXw4J0x9lYUwfKs2WfUfFfnzJsj
         m+LxNAyD6ZQEqcTODr8YBUQVMHQxwb+3JYDVnmJC+BDpK6YIOlmmWZgtmxtzuBooEQBd
         M3v+iTgnWZg8nJSjg/a9gWgQpBoX+nxb2JX2ZMzbEAEQt0sQNTqcePOQSzxrR+oeRSP7
         Y5bQ==
X-Gm-Message-State: AOAM531DWjIDzF+HCITPkd4cguImXp0RZL6ws+o9aB0GNfJK/QFbUQXd
        ZPcndLJqU2CMzIK3ZJ10lTVaeOqVNzk+UcEyi98BEb8t2UhXmKms73WpN24zKaVQlu+RjTxJ7ok
        FTcMPTH8b9fMWqOB0/+p8+Eb562Mq6ky6UH9XH4lpzpt1cdUyiw==
X-Received: by 2002:a9d:24e4:: with SMTP id z91mr40165442ota.11.1641435046793;
        Wed, 05 Jan 2022 18:10:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxT8mA1RVuvMHANTIBtNwGuaoR73dzilRpdJyf0qMP2d/UoeS6lSFs6LwXWDZ0zwXeqNM4Dms4BFbsHVuK1d5U=
X-Received: by 2002:a9d:24e4:: with SMTP id z91mr40165426ota.11.1641435046492;
 Wed, 05 Jan 2022 18:10:46 -0800 (PST)
MIME-Version: 1.0
References: <20220105151427.8373-1-aaron.ma@canonical.com> <YdXVoNFB/Asq6bc/@lunn.ch>
 <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com> <YdYbZne6pBZzxSxA@lunn.ch>
In-Reply-To: <YdYbZne6pBZzxSxA@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 6 Jan 2022 10:10:34 +0800
Message-ID: <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough address
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 6:27 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Jan 05, 2022 at 10:49:56PM +0100, Oliver Neukum wrote:
> >
> > On 05.01.22 18:30, Andrew Lunn wrote:
> > > On Wed, Jan 05, 2022 at 11:14:25PM +0800, Aaron Ma wrote:
> > >> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> > >> or USB hub, MAC passthrough address from BIOS should be
> > >> checked if it had been used to avoid using on other dongles.
> > >>
> > >> Currently builtin r8152 on Dock still can't be identified.
> > >> First detected r8152 will use the MAC passthrough address.
> > > I do have to wonder why you are doing this in the kernel, and not
> > > using a udev rule? This seems to be policy, and policy does not belong
> > > in the kernel.
> > Debatable. An ethernet NIC has to have a MAC. The kernel must
> > provide one. That we should always take the one found in the
> > device's ROM rather than the host's ROM is already a policy decision.
>
> In general, it is a much longer list of places to find the MAC address
> from. It could be in three different places in device tree, it could
> be in ACPI in a similar number of places, it could be in NVMEM,
> pointed to by device tree, the bootloader might of already programmed
> the controller with its MAC address, etc, or if everything else fails,
> it could be random.
>
> So yes, the kernel will give it one. But if you want the interface to
> have a specific MAC address, you probably should not be trusting the
> kernel, given it has so many options.

Can udev in current form really handle the MAC race? Unless there's a
new uevent right before ndo_open() so udev can decide which MAC to
assign? Even with that, the race can still happen...

So what if we keep the existing behavior (i.e. copy MAC from ACPI),
and let userspace daemon like NetworkManager to give the second NIC
(r8152 in this case) a random MAC if the main NIC (I219 in this case)
is already in use? Considering the userspace daemon has the all the
information required and it's the policy maker here.

Kai-Heng

>
>         Andrew
>
>
