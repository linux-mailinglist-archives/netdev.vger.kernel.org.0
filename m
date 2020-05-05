Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774991C645B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgEEXUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgEEXUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 19:20:01 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB03C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 16:20:00 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e2so3187731eje.13
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 16:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hpk77g7UvVuJDTBuEIs12x2gdqwgzrNeTIra+yqoVu8=;
        b=nrUIB0xysOW4kQBDtHW4iFwyDzqdc6UjEPOCMJDK9rnv1X4UULWtmBLG/oJ6E3/ZFO
         VwILYVWzDkoehkz/hj/lNheghIkhFruqzjyB570rLD2mpKCTf6YdHKXLY8qQkt5ScnDE
         gIEhQH9Nd1UOd7LnykJg9M2JQwSI+4e9bOexctqWV9k27Y0knjIhkVIOZy0xErB0vZvn
         0H1ALA3jg2eeYBg2yGjksXObNAHbmyfIz3ySY9TEmNaxFMhyNsJv21LVhgjAAoE+0Igp
         UHUpFcYn/g9YjsNh/GRDdT+IkvUBh1zbtOnmo6mo9nGv9X7z7AZ2obqbO+RRHPN2AEdY
         bR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hpk77g7UvVuJDTBuEIs12x2gdqwgzrNeTIra+yqoVu8=;
        b=S3/HQm/80SUdD/LpHc7Deag2AM2yI3fZV1VXK3LR9hZUhsmIlAxmrLQz6PIKd0WLy5
         2H4TJhpWvR0KyoCzsDm4FmVLr02ckfjpF3StqpWGL1lVAUe8mIp8LFYXEdpvdF+aYZX5
         UuFcdf3H/Lgm36U4wsZO0F+wMxKnbVHPIHc6rH7z5r/QZkYse2LP/+5hvxa5TlVmjt6X
         SQeBf7DwUgef6yMuhAAn34JcPmGHSlgq+6rxqd3DplbKYJ8xUcO6Q+JaPY1v6QlBfkt1
         4gRKW8lsCvT0uVjb0ci3QIwYZ5k/xNvsRnEHokBlSXZWk84f0Pg5LFb9Ps/wbwaVjG67
         2RZA==
X-Gm-Message-State: AGi0PuZQW3oMfztt4Eo+B7dxyOcySfj8hWBoem0+5Y2ru8ci8YT7/Eu/
        gHV9fp+tnEppOaFly2xzf4X+ktU7cn5ARd+uoQtWEQ==
X-Google-Smtp-Source: APiQypJp9NWVA4+BQgAQIcXGHNYDU3OsGrZMVRSfzBS5cR+2ZndN0xJ8SGmjXM4HZv4lWjwrpN/GK9+pCxJYJYEm4qY=
X-Received: by 2002:a17:906:a38f:: with SMTP id k15mr5048896ejz.181.1588720799531;
 Tue, 05 May 2020 16:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200505185723.191944-1-zenczykowski@gmail.com>
 <20200505.142322.2185521151586528997.davem@davemloft.net> <CANP3RGfVbvSRath6Ajd6_xzVrcK1dci=fFLMAGEogrT54fuudw@mail.gmail.com>
 <20200505.150951.1869532656064502918.davem@davemloft.net>
In-Reply-To: <20200505.150951.1869532656064502918.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 5 May 2020 16:19:45 -0700
Message-ID: <CAHo-Oow8n8JXaoY-P9Bjb9gG0cHwkwf+E4m_eWX1Tf6k4+2jPg@mail.gmail.com>
Subject: Re: [PATCH] Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It's local system policy, how do I react to packets.  If it doesn't
> violate the min/max limits for ipv6 packets it emits onto the internet
> I don't see this as something that can be seen as mandatory.

And if you *truly* do want to violate internet standards you can
indeed already achieve this behaviour by dropping incoming icmpv6
packet too big errors (and there's lots of reasons why that is a bad
idea...).

I'll repeat what I said previously: this is a userspace visible
regression in behaviour, of none or very questionable benefit.

It results in TCP over IPv6 simply not working to destinations to
which your locked mtu is higher then the real path mtu.  This is why
'locked mtu' on IPv4 turns of the Don't Fragment bit - to allow
fragmentation at intermediate routers.  There is no such thing in
IPv6.
There is no DF bit, and there is no router fragmentation - all ipv6
fragmentation is supposed to happen at the source host.
This is why hosts must either use 1280 min guaranteed mtu or be
responsive to pmtu errors.  Otherwise things simply don't work.
