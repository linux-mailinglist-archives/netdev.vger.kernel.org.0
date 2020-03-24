Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937B2190381
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 03:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgCXCKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 22:10:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38185 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCXCKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 22:10:51 -0400
Received: by mail-io1-f66.google.com with SMTP id m15so11484522iob.5
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 19:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0bMu/YGPL04y7QZoPKkunPzPNSKt6kZavxIm4S3iV4s=;
        b=rMVhqfiFUu84/8EcUEXqzXFIJJjtf2TwXrCy/+u/7haco8yYwW+AVfVsDlXxRtgt3v
         yu7dlQYL15fSsjBG0rHZiFLrjp9+5THumPccnlSvOVzQA+oZlN3A9KFlzx232H1kgrKw
         /MxMxVC3x3pur3FiBo5hyheizuTCw/38iAPM5oejN8qN/osfU8BAeWGUwQMWvYax76/o
         V2vnsn78C9MHKDBknVSSTA8h8GC0hfo1LOr2bybLUPF3JOwCW+ivEhqAw8oo379XnRrH
         xIKZ1pRvMQq0nQvslFox6sE6I9+WtZWMsBw13HxMOoVzk294qJIwI/jfO0TyO/Twio8B
         s+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0bMu/YGPL04y7QZoPKkunPzPNSKt6kZavxIm4S3iV4s=;
        b=lstoHynJ14ESZUEc5VhzLJ4N5j8x9Y+MIWdULChLGdmoLPeMI3Edrhn6+/vFh4iTmx
         wYaywN05tNXRjopQY3L0U0Ocebg1D1Pi1sbm6EnZlJcYMEyD74HmO1m5c4kgYH0tsllD
         tHzDzoehFbaaRjApuOIrwDhE0dEq/3aMnjVxCpm5WYRnzcV3c1atS+TZVW092rjKo85L
         A6/Wc5aHncBR8cJ12ETE6ww/HL8+3GhDnAYNyJTaLAIoyvoJ4Laz0Tg2oX8e8p/XVCI2
         wurTQFZFnbp1+W5Y4KjGjdwy/aK0OfrqzpvAEYCFoOc5endZYgBcjnAg2bv8gTqQDlwT
         M2Ng==
X-Gm-Message-State: ANhLgQ3ZhRqiBKfFvOIvcdSx2lyhZtltzjk98QcwPC3fP+H2IxxIp8e0
        7p1/ZxLYtLYf5B3AonOTv6/0IcliPq1WwJuteiZz5lBB2AA=
X-Google-Smtp-Source: ADFU+vulm1386gmyMpo8S7bnD3LMUTgQq68MyL7Id3sshcR2hg+SU7LgpZ5+lyE5+rg6c66KSmFVhDmcLx8EptVfTXw=
X-Received: by 2002:a6b:8f11:: with SMTP id r17mr20665780iod.92.1585015850762;
 Mon, 23 Mar 2020 19:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200324011019.248392-1-zenczykowski@gmail.com>
In-Reply-To: <20200324011019.248392-1-zenczykowski@gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Tue, 24 Mar 2020 11:10:39 +0900
Message-ID: <CAKD1Yr2xAkr4=2tdPCtCPtFve0UQz2sbs2bYCr7kJnqc2VQ54w@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6-ndisc: add support for 'PREF64' dns64 prefix identifier
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Erik Kline <ek@google.com>,
        Jen Linkova <furry@google.com>, Michael Haro <mharo@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:10 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
> As specified in draft-ietf-6man-ra-pref64-09 (while it is still a draft,
> it is purely waiting on the RFC Editor for cleanups and publishing):
>   PREF64 option contains lifetime and a (up to) 96-bit IPv6 prefix.

Right. The number is assigned by IANA and the draft is in the RFC
editor queue, so this number will not change.

> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 4a3feccd5b10..6ffa153e5166 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -197,6 +197,7 @@ static inline int ndisc_is_useropt(const struct net_d=
evice *dev,
>         return opt->nd_opt_type =3D=3D ND_OPT_RDNSS ||
>                 opt->nd_opt_type =3D=3D ND_OPT_DNSSL ||
>                 opt->nd_opt_type =3D=3D ND_OPT_CAPTIVE_PORTAL ||
> +               opt->nd_opt_type =3D=3D ND_OPT_PREF64 ||
>                 ndisc_ops_is_useropt(dev, opt->nd_opt_type);
>  }

Acked-By: Lorenzo Colitti <lorenzo@google.com>
