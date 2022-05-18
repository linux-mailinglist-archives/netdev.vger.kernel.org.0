Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D16752C16E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241093AbiERR3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 13:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241081AbiERR3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 13:29:23 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B158A205E
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 10:29:22 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bq30so4862333lfb.3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 10:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LEaRkkNRBLdXEKpZo2dMeFcD5nuzH0uyFkVCliPM4rc=;
        b=CMHz/BCv5rFKv256fi8/HtbUuau3uFefhtQTjckuXDBZH8El91Tv61X1IkPJPzMqDz
         /sWp00AGYvyVNZVmxnlp1a4TC3vJ7FDiL0JJv+Gj+SYS+brGyjuhtgyJ6YeUADg1k+KJ
         YxVkOSqBf3DgHAwdfMWMmlWwhJpq31X6fTC77u9RHAQqZaKwWnYyLD5SoWm3RhHekHdf
         4ZcNAZzRjCmGx4TRWq163A++itWNrHUDU360bKMrCVp/ex7pqRAwHx0B5xPX+xdp81FT
         YKZ4yiekKllE/IT0mY0Kw7r/6KGYxB3pnLKLjyGdGKZPa4ubWyXmI/07WRnzjrIcgskG
         36Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LEaRkkNRBLdXEKpZo2dMeFcD5nuzH0uyFkVCliPM4rc=;
        b=wOO7Ejv0PxsR9mwmw47U35YQipwndqsCVdmtIreFYbq8nuF6D5uD0n9vzsWfG/oWnx
         rS4q4K5oMvCGaQdLhji4XCxzstCR4h3TQcQMP3lVwqspYWRaaXZSP8oDkctWwtl3hi9j
         3VyouLKpful2QvNqcYCRnsLCSX3/nOJm1wziIj1ux/kXWYSmzEQ/fmu24BWVBzfU4Xi5
         yNeAwXrB4s7T2CutynfoURx2vJryNoNaDr2bwDt0gO+HZZ1JmVjSby4fotl+rT/U9rMH
         SIGt+jiz1v2OCfn0VDeNKQyToEgLLPZZEbikW/7iieg2m668Zx02FbBFPZJtmHrmwMXd
         5lSg==
X-Gm-Message-State: AOAM533+bhrmuIXtMfKuUDIGnEz14UL6XZBGBfGYhXttYW7MbgY2q191
        iNOdB+P58BsljFxXL2YlFWL8u86hIDh+rvYdJOM=
X-Google-Smtp-Source: ABdhPJzCeJv7NkavNVnems235K9y8evN8cW/FSMvoiUTnfyH3lgoDYg04sbPQxKN6vH/ngdBxjAA68XThYwDKLsiLNo=
X-Received: by 2002:a05:6512:ba9:b0:477:9e15:a6ec with SMTP id
 b41-20020a0565120ba900b004779e15a6ecmr377295lfv.315.1652894960255; Wed, 18
 May 2022 10:29:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220509191810.2157940-1-jeffreyjilinux@gmail.com> <YnoPn+hQt7hQYWkA@shredder>
In-Reply-To: <YnoPn+hQt7hQYWkA@shredder>
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
Date:   Wed, 18 May 2022 07:29:08 -1000
Message-ID: <CACB8nPkQkH3fJt29kNQ_YqikP8eKPSuBJvh-_cFO_zqie2rw0A@mail.gmail.com>
Subject: Re: [PATCH net-next] show rx_otherhost_dropped stat in ip link show
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I thought we wanted to avoid otherhost_dropped being counted as an
error, I recall Jakub saying something about not wanting users to call
for help when they see error in the counter name.


On Mon, May 9, 2022 at 9:09 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Mon, May 09, 2022 at 07:18:10PM +0000, Jeffrey Ji wrote:
> > From: Jeffrey Ji <jeffreyji@google.com>
> >
> > This stat was added in commit 794c24e9921f ("net-core: rx_otherhost_dropped to core_stats")
> >
> > Tested: sent packet with wrong MAC address from 1
> > network namespace to another, verified that counter showed "1" in
> > `ip -s -s link sh` and `ip -s -s -j link sh`
> >
> > Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
> > ---
> >  include/uapi/linux/if_link.h |  2 ++
> >  ip/ipaddress.c               | 15 +++++++++++++--
> >  2 files changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index 22e21e57afc9..50477985bfea 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -243,6 +243,8 @@ struct rtnl_link_stats64 {
> >       __u64   rx_compressed;
> >       __u64   tx_compressed;
> >       __u64   rx_nohandler;
> > +
> > +     __u64   rx_otherhost_dropped;
>
> I believe you need to rebase against current iproute2-next. The kernel
> headers are already updated there. This tree:
> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
>
> >  };
> >
> >  /* Subset of link stats useful for in-HW collection. Meaning of the fields is as
> > diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> > index a80996efdc28..9d6af56e2a72 100644
> > --- a/ip/ipaddress.c
> > +++ b/ip/ipaddress.c
> > @@ -692,6 +692,7 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
> >               strlen("heartbt"),
> >               strlen("overrun"),
> >               strlen("compressed"),
> > +             strlen("otherhost_dropped"),
>
> There were a lot of changes in this area as part of the "ip stats"
> work. See print_stats64() in current iproute2-next.
>
> >       };
> >       int ret;
> >
> > @@ -713,6 +714,10 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
> >               if (s->rx_compressed)
> >                       print_u64(PRINT_JSON,
> >                                  "compressed", NULL, s->rx_compressed);
> > +             if (s->rx_otherhost_dropped)
> > +                     print_u64(PRINT_JSON,
> > +                                "otherhost_dropped",
> > +                                NULL, s->rx_otherhost_dropped);
> >
> >               /* RX error stats */
> >               if (show_stats > 1) {
> > @@ -795,11 +800,15 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
> >                                    rta_getattr_u32(carrier_changes) : 0);
> >
> >               /* RX stats */
> > -             fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
> > +             fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%*s%s",
> >                       cols[0] - 4, "bytes", cols[1], "packets",
> >                       cols[2], "errors", cols[3], "dropped",
> >                       cols[4], "missed", cols[5], "mcast",
> > -                     cols[6], s->rx_compressed ? "compressed" : "", _SL_);
> > +                     s->rx_compressed ? cols[6] : 0,
> > +                     s->rx_compressed ? "compressed " : "",
> > +                     s->rx_otherhost_dropped ? cols[7] : 0,
> > +                     s->rx_otherhost_dropped ? "otherhost_dropped" : "",
> > +                     _SL_);
> >
> >               fprintf(fp, "    ");
> >               print_num(fp, cols[0], s->rx_bytes);
> > @@ -810,6 +819,8 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
> >               print_num(fp, cols[5], s->multicast);
> >               if (s->rx_compressed)
> >                       print_num(fp, cols[6], s->rx_compressed);
> > +             if (s->rx_otherhost_dropped)
> > +                     print_num(fp, cols[7], s->rx_otherhost_dropped);
> >
> >               /* RX error stats */
> >               if (show_stats > 1) {
> > --
> > 2.36.0.512.ge40c2bad7a-goog
> >
