Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4DC2EF8FC
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 21:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbhAHUU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbhAHUUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 15:20:53 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C56C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 12:20:12 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id h16so12430598edt.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 12:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7554PS+RmXDqISK7YiVD4ljXC+qv4l8E6s66DaLLIi8=;
        b=qJiKMBbFOciQz7glh8cURPbS4Pn0v5tENVxouLjT2E9vzs8eOqTDO+Ctr2aP6r86DA
         rjf/nu3AmIJx4HtjZFc96XcyyUvlwQGxM2cR/8CkkjZN7p/nA7YeWA2ckoI+rwJh9equ
         4DMlbrV0aOEEe+walDhHuBQUZ2RHbVoP4AbSAPTatzVq9C6bM2+CO78w8Q7ojHvNpdWq
         oYpr2uXWwJDlxOVPm/u2uTEhi6UV3YbzrUBU2vvMhYc6R7q0e5mYTwT4tjyIdKon/lqE
         +Ge2HUbFYTI8ay2wXrZPHWRzD3ja/LpZpk4skfLHRVLNBDnYPWkYPj1Y8ie6oRzjaefw
         YuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7554PS+RmXDqISK7YiVD4ljXC+qv4l8E6s66DaLLIi8=;
        b=sNEPHHPC8RxLjC/r7XaUdP7nlpotSgMzyFdTBAenT3q5qaXFHuAwM5CNXS5hTLzGmg
         JAfp0nCBL1cJ14I3TLjrx73I82d/Yr69FqgpCVkyix+jTXRxtyDfyaokIuq9BZWPy/UI
         KsCw4HClapzzDgArKae4FkIZd+c7Uqf4s1GZL79PTspOEzAottaqI28qjtUMA0VIIrkd
         v4QKhdTflZPApajUksz1LksuwEywqXFXJwHELyGDuclVPbvye9KV32IvfljZVwnGqJg/
         DvpsJb8a38iLG+AzCXFdC5j7hE8bQ/Gd2M85EMyaq0r7sPCqRLTauRv/30W1Xwj/V2gg
         QL/w==
X-Gm-Message-State: AOAM530UXTCy9ZYo22N5Jxy5tPfSmhyLe7f107C5ESVYymrkX9oqVsnj
        aV4zFPV7UYTIca/Qmh2R7O4=
X-Google-Smtp-Source: ABdhPJwKwNySk0c8LDtLc3qZTQHHyL7D2lRtQQ5T++RpPFnYrbXTtMz8ujt52pq1eKqpki7JVwXBbQ==
X-Received: by 2002:a50:d5c1:: with SMTP id g1mr6751658edj.299.1610137211371;
        Fri, 08 Jan 2021 12:20:11 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t19sm3844034ejc.62.2021.01.08.12.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 12:20:10 -0800 (PST)
Date:   Fri, 8 Jan 2021 22:20:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
Message-ID: <20210108202009.vdb3ulr4ckgj5ns7@skbuf>
References: <20210107094951.1772183-1-olteanv@gmail.com>
 <20210107094951.1772183-11-olteanv@gmail.com>
 <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
 <20210107113313.q4e42cj6jigmdmbs@skbuf>
 <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
 <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
 <CANn89iLm7nwckUVjoHsH-gYwQwEsscK+D2brG+NgndLZaUy_5g@mail.gmail.com>
 <20210108092125.adwhc3afwaaleoef@skbuf>
 <CANn89i+1KEyGDm-9RXpK4H6aWtn5Zmo3rgj_+zWYwFXhxm8bvg@mail.gmail.com>
 <0c2b5e3ee14addfb86f023f2108bacc4e5c5652b.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c2b5e3ee14addfb86f023f2108bacc4e5c5652b.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 11:38:57AM -0800, Saeed Mahameed wrote:
> Let me take a look at the current series, and if I see that the
> rcu/dev_hold approach is more lightweight then i will suggest it to
> Vladimir and he can make the final decision.

The last version does use temporary RCU protection. I decided to not
change anything about the locking architecture of the drivers.
