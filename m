Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292722EEF69
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbhAHJWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbhAHJWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:22:09 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F008CC0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:21:28 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ga15so13659471ejb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KsvzYv7wcFcwk1/90wmcvRJ0DDi4aQAhPjBy0HxtmnY=;
        b=RUQUOYWqi1yin6IyphOPkGjjQFvO5dMJHcb+leKP9bAuSFfQruTXwpkIalPGQ9QaII
         dBDin30ev9BwQmf7z5N2MbvGSEjiaGEhFakWtO6J+B0hBe6PP9BpB56RpYshlVpxzA6g
         j5Ogv63Ew/9gqxyWRvXgkJW3f0ls+ThbysAnfXK5I2rSM95t4IEBB8FdLRgEqPduMypJ
         r+c09rOZTw7cTXt0vRTxMZEL5VQvpuEvGOaInfLCSMb0yW03hDPte2PoKs91XGeNgpql
         MyrXi4O6F0ZK6CoPpGuNCbYz3N3Glcu8+pzQJb92CGKm69swc5Ovwz+dUG5FFzgttmeT
         rkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KsvzYv7wcFcwk1/90wmcvRJ0DDi4aQAhPjBy0HxtmnY=;
        b=pnMYLU1q3HL5PcIwMgv3f1Fg3EF77T/0I+lDVwhCmP8qy5DGLFVEJ0+bbMt9nn2G3n
         tR2OKYpwAh4B2HRxa6MWsRZQB8hV5pdxrQw1Xr2RFdFjXZAX8DT4/BJ6YUqkFRBAkgcb
         VEWQepxPtd8DQlKAfwbafFthEBbm7UBItOgqi/JFPasXwcls0U3C94bXRO44gO6s10rm
         LowMkBTO/Ujv0uC8Ov3mAYpyOLnc7XqUuQhF13DoI85qBNYFAT9Ebb7+3cfS36uYVNsB
         zYjllTGyG2OYo4wEWa90enp0eA1VtmAExgXlS3afmADJX88FchqjVorMFef1A/pKP6JG
         jFGQ==
X-Gm-Message-State: AOAM5329wtpOGQmJIAkZrXUK5UCTQaBUA2x6tN3y+8FVWgQlQ5rx42dj
        qYFIxvBUkdxfyLT3K7WmML4=
X-Google-Smtp-Source: ABdhPJzp6ODysiWWRfkSoljs/e6Z+3Nr7UohAimtpjbRnE77kc6JBWxOeCCADR0xkXGCKFoySzMSlg==
X-Received: by 2002:a17:906:229a:: with SMTP id p26mr2090623eja.291.1610097687775;
        Fri, 08 Jan 2021 01:21:27 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q17sm1563773edr.83.2021.01.08.01.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 01:21:27 -0800 (PST)
Date:   Fri, 8 Jan 2021 11:21:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
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
Message-ID: <20210108092125.adwhc3afwaaleoef@skbuf>
References: <20210107094951.1772183-1-olteanv@gmail.com>
 <20210107094951.1772183-11-olteanv@gmail.com>
 <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
 <20210107113313.q4e42cj6jigmdmbs@skbuf>
 <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
 <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
 <CANn89iLm7nwckUVjoHsH-gYwQwEsscK+D2brG+NgndLZaUy_5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLm7nwckUVjoHsH-gYwQwEsscK+D2brG+NgndLZaUy_5g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 10:14:01AM +0100, Eric Dumazet wrote:
> If you disagree, repost a rebased patch series so that we can
> test/compare and choose the best solution.

I would rather use Saeed's time as a reviewer to my existing and current
patch set.
