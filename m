Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1943E28CBD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388375AbfEWV5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:57:07 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37430 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387616AbfEWV5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:57:07 -0400
Received: by mail-ed1-f67.google.com with SMTP id w37so11304131edw.4;
        Thu, 23 May 2019 14:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0hFIYP9BoSosYVt9SP0AzGwicw0FRzRX7GTueMZ052w=;
        b=L28iF9YNdfgD6nZuWUZ5m9+n4a5Fn/zRIhYI05iWZEVwJVoLG+QsfmqyhIlO6wX28R
         4IkzaxWuOuUP+VovDi6Erl4aCVdBTl4+h0JADwA3s/3Mcebfs/OsHPCZG9Kt91imqdO2
         MeqtR5BY5VkTX6hU1xGVJEQJmBqB7D0d+fQXDdjDfxSflpJhZpsInHtMmOjCBiH+IhTZ
         oDuIxOhLKC1GyX158YJYpCnOaOPcsUwUeEW0jtT+HDfUabJSyg2wuRETdomMphhG9BCA
         msNX6ZhmuxID3wv18AkJi3n3AwOKVZrJFZ7RCDMn3zls1oEjwcLqaVfnKiSXXKPuk59F
         S6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0hFIYP9BoSosYVt9SP0AzGwicw0FRzRX7GTueMZ052w=;
        b=bTcWnuOkvDPNu3pM9doibdVwMLqfZeHlVK0SKnc7DEmFoXDknMm0J3l4dyueUCkcE3
         95XJ/m2Dp95ZRRnZdiM2PJ+qXOoykmLopddpLuTe0QuXvXKE438q88AYzpeYuri0R/hu
         hKqtWJLKfXIcs1eallwrt2tNyg9j7loYCW5slbTmAYEwD8cLXJ9BOwXvghyvi9DdCmvd
         qxAcHzmL9XBwE4o5y8stu4w+bK2TV1WL4iLGV7DlK2mrEpWVJQSIuQ06FyTX9PN/o5Gz
         N8+bSt9nI5w2OHXOV3Ym++5YcWvoZDhZ56YW485Bbo54BJh2aB0/8r8TsbPtFj3gxfrE
         CvzA==
X-Gm-Message-State: APjAAAVmH39p2r73cwaN1iAOlTRRBGFMw4xEhyMucXZU67aspoFeUSnJ
        xohzv0Nw3OD2w61KlaLY6CxrCBVeX1qPwQit6SI=
X-Google-Smtp-Source: APXvYqx9KDXJ9IwoB0tIocBE2RmIG6u6/T1Fb+03i2yHmtzhni66bmqLso1anlhpbYAoMoogIUJJLv2Ofq5PniVW6Z8=
X-Received: by 2002:a50:b665:: with SMTP id c34mr99194045ede.148.1558648625357;
 Thu, 23 May 2019 14:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-5-fklassen@appneta.com>
In-Reply-To: <20190523210651.80902-5-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 May 2019 17:56:29 -0400
Message-ID: <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 5:11 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> This enhancement adds the '-a' option, which will count all CMSG
> messages on the error queue and print a summary report.
>
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")

Also not a fix, but an extension.

>
> Example:
>
>     # ./udpgso_bench_tx -4uT -a -l5 -S 1472 -D 172.16.120.189
>     udp tx:    492 MB/s     8354 calls/s   8354 msg/s
>     udp tx:    477 MB/s     8106 calls/s   8106 msg/s
>     udp tx:    488 MB/s     8288 calls/s   8288 msg/s
>     udp tx:    882 MB/s    14975 calls/s  14975 msg/s
>     Summary over 5.000 seconds ...
>     sum udp tx:    696 MB/s      57696 calls (11539/s)  57696 msgs (11539/s)
>     Tx Timestamps: received:     57696   errors: 0
>
> This can be useful in tracking loss of messages when under load. For example,
> adding the '-z' option results in loss of TX timestamp messages:
>
>     # ./udpgso_bench_tx -4ucT -a -l5 -S 1472 -D 172.16.120.189 -p 3239 -z
>     udp tx:    490 MB/s     8325 calls/s   8325 msg/s
>     udp tx:    500 MB/s     8492 calls/s   8492 msg/s
>     udp tx:    883 MB/s    14985 calls/s  14985 msg/s
>     udp tx:    756 MB/s    12823 calls/s  12823 msg/s
>     Summary over 5.000 seconds ...
>     sum udp tx:    657 MB/s      54429 calls (10885/s)  54429 msgs (10885/s)
>     Tx Timestamps: received:     34046   errors: 0
>     Zerocopy acks: received:     54422   errors: 0

This would probably also be more useful as regression test if it is in
the form of a pass/fail test: if timestamps are requested and total
count is zero, then the feature is broken and the process should exit
with an error.

>
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")

Repeated

> Signed-off-by: Fred Klassen <fklassen@appneta.com>
> ---
>  tools/testing/selftests/net/udpgso_bench_tx.c | 152 +++++++++++++++++++-------
>  1 file changed, 113 insertions(+), 39 deletions(-)
>
> diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
> index 56e0d890b066..9924342a0b03 100644
> --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> @@ -62,10 +62,19 @@ static bool cfg_tcp;
>  static uint32_t        cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
>  static bool    cfg_tx_tstamp;
>  static uint32_t        cfg_tos;
> +static bool    cfg_audit;
>  static bool    cfg_verbose;
>  static bool    cfg_zerocopy;
>  static int     cfg_msg_nr;
>  static uint16_t        cfg_gso_size;
> +static unsigned long total_num_msgs;
> +static unsigned long total_num_sends;
> +static unsigned long stat_tx_ts;
> +static unsigned long stat_tx_ts_errors;
> +static unsigned long tstart;
> +static unsigned long tend;
> +static unsigned long stat_zcopies;
> +static unsigned long stat_zcopy_errors;
>
>  static socklen_t cfg_alen;
>  static struct sockaddr_storage cfg_dst_addr;
> @@ -137,8 +146,11 @@ static void flush_cmsg(struct cmsghdr *cmsg)
>                         struct my_scm_timestamping *tss;
>
>                         tss = (struct my_scm_timestamping *)CMSG_DATA(cmsg);
> -                       fprintf(stderr, "tx timestamp = %lu.%09lu\n",
> -                               tss->ts[i].tv_sec, tss->ts[i].tv_nsec);
> +                       if (tss->ts[i].tv_sec == 0)
> +                               stat_tx_ts_errors++;
> +                       if (cfg_verbose)
> +                               fprintf(stderr, "tx timestamp = %lu.%09lu\n",
> +                                       tss->ts[i].tv_sec, tss->ts[i].tv_nsec);

changes unrelated to this feature?
