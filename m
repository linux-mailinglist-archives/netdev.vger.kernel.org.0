Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72401A6FE1
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 01:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390017AbgDMXnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 19:43:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20027 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728489AbgDMXno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 19:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586821423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xqr4dsXCGQ7mBSR00NAzM1Q6acm6mNGXK+xaVCuI9s0=;
        b=B4iDpdXksWO52RHAHJ0BILE7FbAiEZBoEOAI99uuqFm6aJGCnazNLYEpLp4g59KMjxQCCI
        /stHGS18sJidHznh5XxvXVXYlnPMY0400ZqfZ5tFIpwF35VKSNwMb6oZdCekuEsvvmuy3f
        1CVRKqyxucV/FqYIfauQXDE8INGT8Lk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-sKsn570rNjKQXhT-WGqq1A-1; Mon, 13 Apr 2020 19:43:39 -0400
X-MC-Unique: sKsn570rNjKQXhT-WGqq1A-1
Received: by mail-ed1-f71.google.com with SMTP id y66so2914215ede.19
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 16:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xqr4dsXCGQ7mBSR00NAzM1Q6acm6mNGXK+xaVCuI9s0=;
        b=fz//OqCs77L6hYpZmVMRwuQB3nD46ZTJnev3v58QJ+rsfa84ed3WyCRU0n+NXY8Scz
         zAAfTCu/Ik+99G7RDBtzMatQ2eCYzsCxNNfzd5YJgIngInZSmV7AhRRR+TAQOOGs++Lz
         7UDzcMVWCDfRsi+voQVY3ZiGEWC5+Z9ndMzCnLbd/Rn8gIhMgVVdKiIoNYmgkVzCTZYH
         Qy+D97KNCdYeeBaWFcqAfihKXYMqhCXQ5wG9+Alq6B/pT8SqxoEMyF/7fuUGDFTUo15L
         +MaIF0dIkJBr5qEHboSMSRBdkeyX7/TtUaVcrx3A+fhnli0OmySkHbgb/l/eZqrmzAM/
         G+OQ==
X-Gm-Message-State: AGi0PuZiOOkCBg6K7gon0+XM5fHlahJj7GIO1xaWPYWBWIEwFIDVcX+j
        pCH810J4d8+35DZcTPFtGXvbWk/QmxMxaDnehDPtJ5EfVPXGNqKxG8ifimWlWXRGbVHiJAZGoyf
        bX8Cw9Txz8EQ2IrdAIMiGHv07G/hMVXE5
X-Received: by 2002:a17:906:a418:: with SMTP id l24mr4284478ejz.362.1586821418589;
        Mon, 13 Apr 2020 16:43:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypKa/t6ZDKsi78psOMm2ofYlu33r+ev1cgYcUx7E9J7maeva3YKq+x4SEnS8Mxo6UUPZcXftIkJxkGJxL//DCa8=
X-Received: by 2002:a17:906:a418:: with SMTP id l24mr4284462ejz.362.1586821418314;
 Mon, 13 Apr 2020 16:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com> <20190524100554.8606-4-maxime.chevallier@bootlin.com>
In-Reply-To: <20190524100554.8606-4-maxime.chevallier@bootlin.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 14 Apr 2020 01:43:02 +0200
Message-ID: <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to handle
 RSS tables
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        Nadav Haklai <nadavh@marvell.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 1:21 AM Maxime Chevallier
<maxime.chevallier@bootlin.com> wrote:
>
> The PPv2 controller has 8 RSS tables that are shared across all ports on
> a given PPv2 instance. The previous implementation allocated one table
> per port, leaving others unused.
>
> By using RSS contexts, we can make use of multiple RSS tables per
> port, one being the default table (always id 0), the other ones being
> used as destinations for flow steering, in the same way as rx rings.
>
> This commit introduces RSS contexts management in the PPv2 driver. We
> always reserve one table per port, allocated when the port is probed.
>
> The global table list is stored in the struct mvpp2, as it's a global
> resource. Each port then maintains a list of indices in that global
> table, that way each port can have it's own numbering scheme starting
> from 0.
>
> One limitation that seems unavoidable is that the hashing parameters are
> shared across all RSS contexts for a given port. Hashing parameters for
> ctx 0 will be applied to all contexts.
>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Hi all,

I noticed that enabling rxhash blocks the RX on my Macchiatobin. It
works fine with the 10G ports (the RX rate goes 4x up) but it
completely kills the gigabit interface.

# 10G port
root@macchiatobin:~# iperf3 -c 192.168.0.2
Connecting to host 192.168.0.2, port 5201
[  5] local 192.168.0.1 port 42394 connected to 192.168.0.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   941 MBytes  7.89 Gbits/sec  4030    250 KBytes
[  5]   1.00-2.00   sec   933 MBytes  7.82 Gbits/sec  4393    240 KBytes
root@macchiatobin:~# ethtool -K eth0 rxhash on
root@macchiatobin:~# iperf3 -c 192.168.0.2
Connecting to host 192.168.0.2, port 5201
[  5] local 192.168.0.1 port 42398 connected to 192.168.0.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   860 MBytes  7.21 Gbits/sec  428    410 KBytes
[  5]   1.00-2.00   sec   859 MBytes  7.20 Gbits/sec  185    563 KBytes

# gigabit port
root@macchiatobin:~# iperf3 -c turbo
Connecting to host turbo, port 5201
[  5] local 192.168.85.42 port 45144 connected to 192.168.85.6 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   113 MBytes   948 Mbits/sec    0    407 KBytes
[  5]   1.00-2.00   sec   112 MBytes   942 Mbits/sec    0    428 KBytes
root@macchiatobin:~# ethtool -K eth2 rxhash on
root@macchiatobin:~# iperf3 -c turbo
iperf3: error - unable to connect to server: Resource temporarily unavailable

I've bisected and it seems that this commit causes the issue. I tried
to revert it on nex-next as a second test, but the code has changed a
lot much since, generating too much conflicts.
Can you have a look into this?

Thanks,
-- 
Matteo Croce
per aspera ad upstream

