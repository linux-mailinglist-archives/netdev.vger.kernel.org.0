Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761D328EDB
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 03:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388740AbfEXBis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 21:38:48 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45308 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731676AbfEXBis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 21:38:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id i21so4072802pgi.12
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 18:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fIG1/oNez6GVfieaNVvRGqClWbB80a7VpaI4ZVWlUTY=;
        b=kGOO7QJjYShPVPBvs/ZZX4VQ4eRHKxuNroC1T1gSIH+LURunL1GYc8S5KkMJ4304nt
         D0vjJP1zY0itozAzVofvfnp6vwc37FxbJCWVEjzCPHkvqiNeBjdFsXbkJdDIa+f/G+o7
         l2A9DZTeNt5XJA8Qxui7ybi7g1aIi80biu8DQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fIG1/oNez6GVfieaNVvRGqClWbB80a7VpaI4ZVWlUTY=;
        b=fSk63gu1kyz6owlTe8lgBXSjWJDO1SA8h+ApwwmiOik3rUxsx1mpBYSTzNNBldijLx
         JcpN/JukOlDiofWP17v2W9VuuoFy/MYUCqmld98VJGM+/sYnuFtCOycLqcVA28FLrhcV
         Ahhrt99yhkXei/2F6EY0h7SITWo1Xu37N3fK6gzNpIixohY0CPflKU+yTOrs8vPvQwsC
         YwCcSYlIglyCDe663G479FrnApz7Oc73uIl71fYRoKOoBeZpkUHHioEqCep48nmpvOEE
         sKuFYxSXr05fnocHlXlgqn4xBaGp4DhF/abRd7IwL9NkgNkry6MOuNpW3n2mZDf3LjEl
         UXmw==
X-Gm-Message-State: APjAAAU/kCWkMs1PmCsTOYYZp5qHMDZ1wqSk+2ckKqo6KXVF1Xsl60RA
        HJUGDYBXZvQINRZS4FGn6N9oug==
X-Google-Smtp-Source: APXvYqxbCF0d1RN2Gw85wpBkrv/MWoagSl5+oFwhvvoDBMmfB9ADuQlYwD4bfak3BfVpG5B/MM3VLA==
X-Received: by 2002:a63:d016:: with SMTP id z22mr102922046pgf.116.1558661926884;
        Thu, 23 May 2019 18:38:46 -0700 (PDT)
Received: from [10.0.1.19] (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.gmail.com with ESMTPSA id f36sm524732pgb.76.2019.05.23.18.38.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 18:38:46 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
Date:   Thu, 23 May 2019 18:38:44 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
 <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for the report.
>=20
> Zerocopy notification reference count is managed in skb_segment. That
> should work.
>=20
> Support for timestamping with the new GSO feature is indeed an
> oversight. The solution is similar to how TCP associates the timestamp
> with the right segment in tcp_gso_tstamp.
>=20
> Only, I think we want to transfer the timestamp request to the last
> datagram, not the first. For send timestamp, the final byte leaving
> the host is usually more interesting.

TX Timestamping the last packet of a datagram is something that would
work poorly for our application. We need to measure the time it takes
for the first bit that is sent until the first bit of the last packet is =
received.
Timestaming the last packet of a burst seems somewhat random to me
and would not be useful. Essentially we would be timestamping a=20
random byte in a UDP GSO buffer.

I believe there is a precedence for timestamping the first packet. With
IPv4 packets, the first packet is timestamped and the remaining =
fragments
are not.=
