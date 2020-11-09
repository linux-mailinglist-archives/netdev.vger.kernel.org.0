Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFAA2AB5DA
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgKILFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgKILFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:05:22 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E317C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 03:05:22 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id e27so11797457lfn.7
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 03:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=3uRqsn75rbTwmBzJ0l/P9eIK6ZSJjaqzCJOX5cis7Sg=;
        b=DXpAsJPy5/YV6jAny8c92G1x7TZxdWFdo6NU20rMRMVLAjaCL4nIUTC5Wp4QQQJHhI
         eAB2hAQM+LWirsljJ4rm92E97EU+ZvYv36mrGA3FjZikayvCoMlZ88JvfmRc+oghKoyE
         PO8AHteeqQPzSjuVkNKLKNFrWNQ6Q2XM8oMh212ZmoIo7XMPRn6mv/dmbjVb8624xvqY
         EtfI09MEAK3Z8pYO+CB4dyESgYcZIo5Uy5c26iqS8XvdYSrIx+nhgtNGYBL1AaEE090I
         On0hy0nKgNLQC9GZhKHRZf0UfGs0fQRwHmj45rUWIsEqdDNycUrVfM2AnlgK4LBegzx4
         IFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3uRqsn75rbTwmBzJ0l/P9eIK6ZSJjaqzCJOX5cis7Sg=;
        b=XKyfdodlxozytAnvr3/30VSiLDv64/hcrF7aJ9hBSEfddiNEWpoaT2qneJhmaG63BO
         AvkZvTw/GuXZkQ6ZrY/z9O/p32Oy4IRAJW9v3rZ0jWso+8ZeAjo0Tgpk+8/1wTvJfCrT
         GiTtAQ6zFPDRy/aicF0AZSP1sXKG/yikNUTRmxLPCnZZwm2EK+LuymfHVQ2pK4A2OpW9
         IHNqM7RjZ4Cz5JKxvwKEITIQhrqbQ/J+f8iOy3ZXDFFlspQIIkKGpj6nJS1UKfqqTZ87
         YuNnIa/2VioHRKnPYRC6YPxUozTaes7Pmw9N4znSgjN+3XmdKiKaT+5AJWimXog66RST
         ES1Q==
X-Gm-Message-State: AOAM533oet0mfMHyJj8+TBsnweKOvgnbMTLo5R5w47FU1+JTLrg9D/88
        RNC6qobSWUOuDhVQtwZSSq5gUQ==
X-Google-Smtp-Source: ABdhPJw8KwEkpCc5VDk7H19aX073UZnSTjC7ZaX8bdUVFH7yTffGsWwHvtkjrvZt5fIe3nS/tsX0dA==
X-Received: by 2002:ac2:4d93:: with SMTP id g19mr5116818lfe.594.1604919920651;
        Mon, 09 Nov 2020 03:05:20 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c70sm59878lfd.87.2020.11.09.03.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 03:05:20 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
In-Reply-To: <20201109100300.dgwce4nvddhgvzti@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com> <20201108131953.2462644-4-olteanv@gmail.com> <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com> <20201108172355.5nwsw3ek5qg6z7yx@skbuf> <20201108235939.GC1417181@lunn.ch> <20201109003028.melbgstk4pilxksl@skbuf> <87y2jbt0hq.fsf@waldekranz.com> <20201109100300.dgwce4nvddhgvzti@skbuf>
Date:   Mon, 09 Nov 2020 12:05:19 +0100
Message-ID: <87tutyu6xc.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 12:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Nov 09, 2020 at 09:09:37AM +0100, Tobias Waldekranz wrote:
>> one. But now you have also increased the background load of an already
>> choked resource, the MDIO bus.
>
> In practice, DSA switches are already very demanding of their management
> interface throughput, for PTP and things like that. I do expect that if
> you spent any significant amount of time with DSA, you already know the
> ins and outs of your MDIO/SPI/I2C controller and it would already be
> optimized for efficiency. But ok, we can add this to the list of cons.

You are arguing for my position though, no? Yes it is demanding; that is
why we must allocate it carefully.

> So there you have it, it's not that bad. More work needs to be done, but
> IMO it's still workable.

If you bypass learning on all frames sent from the CPU (as today), yes I
agree that you should be able to solve it with static entries. But I
think that you will have lots of weird problems with initial packet loss
as the FDB updates are not synchronous with the packet flow. I.e. the
bridge will tell DSA to update the entry, but the update in HW will
occur some time later when the workqueue actually performs the
operation.

> But now maybe it makes more sense to treat the switches that perform
> hardware SA learning on the CPU port separately, after I've digested
> this a bit.

Yes, please. Because it will be impossible to add tx forward offloading
otherwise.
