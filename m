Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2C62ECEC5
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbhAGLe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbhAGLe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 06:34:28 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0705CC0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 03:33:17 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id w1so9126069ejf.11
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 03:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o12C0B8766PeV5xuA5qzieBfYQmIo53hzp2RFllMI/w=;
        b=Shuxr/EExuVX74RPqlwo+Z9yevBj02qXsjZUmiiUFp2bpSc28wv3wN9RyslydAdrKv
         xQkvQr/8WuIura82ASImWIZO4+SzmELvGJrmqEpFcfx2BkTdVKZM2M6JWt4JumayXukD
         fDrF410Khoj2mK0hDywk9XA4C3bge5M8zjgfhDtNB7or99a7rrKte20REOdBQR+Lghik
         13Dumb2T6bUx5zijw+ZLYuDv9C29OvsoD9QFhV6NWR8HSgzEm9NUE3ytETthPn+4GKq6
         Vi/KN43gA6ODNnXTDcLrmcxajm3xGyXF9MlQMUyFMiISfMSl8beUZ566yWWk10+peVQA
         3VXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o12C0B8766PeV5xuA5qzieBfYQmIo53hzp2RFllMI/w=;
        b=rEJzF8H0966IAv+ZWFDVt9uSRdSZODfby9d57F0Oa6EsAKuefgcj8i6jx7lfsLRJy6
         vRlqzy01FdaSiUnsXK0Ue8eaeh1KmH2/Fs4Q2W+gDnGNe4A8E2eqQLO2dP0+8AiiWhVZ
         uwu1Ee3hdXOrQisoViEy3nnYJq1gz3uAWQwznASC6AasP8Ja3LPuWnpoEiwLo1cxXrRH
         tUMFMK0r5ZxudAKxVRfFZ4uA28U529mCNMxbBbPyEjQMx7mXojMKDAyLk1R6b6gGO3Y1
         p8IQgH7QyUpfSscU11SIK7CAuGEoydBJEtUMo33TlOY0PtP3Xv0f/jwIyxPnqvYq8HyQ
         RmAw==
X-Gm-Message-State: AOAM532xlZ08/Cm1LE1quB3FtujNCH/UdcHo2ic5Q+YbAcRpgAaWJy9Q
        to5fZNCT+X/jY8YVPWamKvgzv74AO0fOyw==
X-Google-Smtp-Source: ABdhPJzw4lERFzEabivBr1MI1t8SRsuzJiBl4xVnFg87HOE/vXFN7ELbsjSjlxdz2rs6CTWbB8l6iA==
X-Received: by 2002:a17:906:354a:: with SMTP id s10mr6012432eja.335.1610019195725;
        Thu, 07 Jan 2021 03:33:15 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bn21sm2350179ejb.47.2021.01.07.03.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 03:33:15 -0800 (PST)
Date:   Thu, 7 Jan 2021 13:33:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
Message-ID: <20210107113313.q4e42cj6jigmdmbs@skbuf>
References: <20210107094951.1772183-1-olteanv@gmail.com>
 <20210107094951.1772183-11-olteanv@gmail.com>
 <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 12:18:28PM +0100, Eric Dumazet wrote:
> What a mess really.

Thanks, that's at least _some_ feedback :)

> You chose to keep the assumption that ndo_get_stats() would not fail,
> since we were providing the needed storage from callers.
>
> If ndo_get_stats() are now allowed to sleep, and presumably allocate
> memory, we need to make sure
> we report potential errors back to the user.
>
> I think your patch series is mostly good, but I would prefer not
> hiding errors and always report them to user space.
> And no, netdev_err() is not appropriate, we do not want tools to look
> at syslog to guess something went wrong.

Well, there are only 22 dev_get_stats callers in the kernel, so I assume
that after the conversion to return void, I can do another conversion to
return int, and then I can convert the ndo_get_stats64 method to return
int too. I will keep the plain ndo_get_stats still void (no reason not
to).

> Last point about drivers having to go to slow path, talking to
> firmware : Make sure that malicious/innocent users
> reading /proc/net/dev from many threads in parallel wont brick these devices.
>
> Maybe they implicitly _relied_ on the fact that firmware was gently
> read every second and results were cached from a work queue or
> something.

How? I don't understand how I can make sure of that.

There is an effort initiated by Jakub to standardize the ethtool
statistics. My objection was that you can't expect that to happen unless
dev_get_stats is sleepable just like ethtool -S is. So I think the same
reasoning should apply to ethtool -S too, really.
