Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6DD545657
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 23:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345042AbiFIVNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 17:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbiFIVNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 17:13:10 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEE123147B
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 14:13:06 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id o7so16581224eja.1
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 14:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3MU1iy5vggREQvdppWrBFb1kdmlu2yH4MsRtL8FjIoU=;
        b=MkCrXf7A/vXbXC0ObEWs5M1CAVVYj7McfrMu76piQpPa5al6mhOXmPPsu012cTzJz6
         v+X/ycwrw0w7ro1B7Ix2iDPxUubdl3D4z3rtg2Z1jjxltsKmxmkxPJi6tDijv18ylBd3
         IlSizoe5No+J/+q19W2rKCsqmi32F93WAhf1/qo4/mkAAyeM2TdTaT5M9zVGWlCWUe8i
         YTkRNNIA6urI2QtCqgDvsHl7m45C6z02/9TDTCzcn17fVjP9VsZb4m3UhKNjpPBAegUx
         Shvsc0h4Sosui428Kbz2JuG8f2jB69TkPBhRqBtfTp8Jc0vS7TlB5U9hO5pt9hDi8Pt2
         h2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3MU1iy5vggREQvdppWrBFb1kdmlu2yH4MsRtL8FjIoU=;
        b=kjIiVqHFRHwFCdfDQOL1l8aF4OBs4ohB7u76QjBkhA7BTeZPJnZ6kS2tJh9p2RJjYs
         JSjR5sPzcKD2x2+mneC62rRaPdO9d6h/lix20p16vTDBCDy88U6u4Bz8BSKzyfYKZh6i
         JvdLbPcQ0WBD+vWVUr8Txmxw91j2uvF3ZF+0fX0sC8HCtoXvl0g+srkDQshl6SmaAFh8
         neK8R/PTYaH5MOvdDlD8jDAiPqNEHwzyxNPk2QpZJz47lfHtLnSBN+PGQyr61DnhUbPc
         ZY95T0bn2VU3vCJ+vibT/j/HrDR6ea8jrpGbWuetqV1KlOL3pe0bUum2CfZ4931qWM8v
         X4pA==
X-Gm-Message-State: AOAM533WOyRoAyzHslGa6xImxHOrcWRnqWX5xxojV2EaQHhjm5B2lDdi
        QKj4VFzOUOj/WzVShx7m86TMS726MJc9fGAB4d4=
X-Google-Smtp-Source: ABdhPJx42mutLfjaKm1KGFojoaqiwfw9m0C5XNEBGI8CBpKdMskWNPu0hMIWCwcChazODpp/N3kqbOQvzPrtRscLos8=
X-Received: by 2002:a17:907:d8d:b0:711:d82f:5d33 with SMTP id
 go13-20020a1709070d8d00b00711d82f5d33mr18923472ejc.595.1654809185195; Thu, 09
 Jun 2022 14:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220609210516.2311379-1-jeffreyjilinux@gmail.com>
 <CACB8nPkSn+Q5Bi4VwggS5so+ZsrU8OiBMdbC_y7czCU8EGeOjg@mail.gmail.com> <CACB8nPmGX4fgcLfgLGx+yuaua+3qEsUUc6v08QHxOpa2T3qepA@mail.gmail.com>
In-Reply-To: <CACB8nPmGX4fgcLfgLGx+yuaua+3qEsUUc6v08QHxOpa2T3qepA@mail.gmail.com>
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
Date:   Thu, 9 Jun 2022 14:12:53 -0700
Message-ID: <CACB8nP=6aJWt_Q=Mh=CKnDb0d8p5cor=hF91rcyH+VC-5v0shw@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] show rx_otherehost_dropped stat in ip
 link show
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, the spacing got messed up when I pasted into Gmail, it should
be fixed now.

mypc[netns:ns-123771-2]:~# ip netns exec $ns2 ./ip -s -s link sh
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    RX:  bytes packets errors dropped  missed   mcast
             0       0      0       0       0       0
    RX errors:  length    crc   frame    fifo overrun
                     0      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
             0       0      0       0       0       0
    TX errors: aborted   fifo  window heartbt transns
                     0      0       0       0       0
2: veth2@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UP mode DEFAULT group default qlen 1000
    link/ether 8e:c0:a5:7d:87:ad brd ff:ff:ff:ff:ff:ff link-netns ns-123771=
-1
    RX:  bytes packets errors dropped  missed   mcast
          1766      22      0       0       0       0
    RX errors:  length    crc   frame    fifo overrun otherhost
                     0      0       0       0       0        10
    TX:  bytes packets errors dropped carrier collsns
          1126      13      0       0       0       0
    TX errors: aborted   fifo  window heartbt transns
                     0      0       0       0       2

On Thu, Jun 9, 2022 at 2:08 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wrote:
>
> json output:
>
> mypc[netns:ns-123771-2]:~# ip netns exec $ns2 ./ip -s -s -j link sh
> [{"ifindex":1,"ifname":"lo","flags":["LOOPBACK","UP","LOWER_UP"],"mtu":65=
536,"qdisc":"noqueue","operstate":"UNKNOWN","linkmode":"DEFAULT","group":"d=
efault","txqlen":1000,"link_type":"loopback","address":"00:00:00:00:00:00",=
"broadcast":"00:00:00:00:00:00","stats64":{"rx":{"bytes":0,"packets":0,"err=
ors":0,"dropped":0,"over_errors":0,"multicast":0,"length_errors":0,"crc_err=
ors":0,"frame_errors":0,"fifo_errors":0,"missed_errors":0,"otherhost":0},"t=
x":{"bytes":0,"packets":0,"errors":0,"dropped":0,"carrier_errors":0,"collis=
ions":0,"aborted_errors":0,"fifo_errors":0,"window_errors":0,"heartbeat_err=
ors":0,"carrier_changes":0}}},{"ifindex":2,"link_index":2,"ifname":"veth2",=
"flags":["BROADCAST","MULTICAST","UP","LOWER_UP"],"mtu":1500,"qdisc":"noque=
ue","operstate":"UP","linkmode":"DEFAULT","group":"default","txqlen":1000,"=
link_type":"ether","address":"8e:c0:a5:7d:87:ad","broadcast":"ff:ff:ff:ff:f=
f:ff","link_netnsid":0,"stats64":{"rx":{"bytes":2116,"packets":27,"errors":=
0,"dropped":0,"over_errors":0,"multicast":0,"length_errors":0,"crc_errors":=
0,"frame_errors":0,"fifo_errors":0,"missed_errors":0,"otherhost":10},"tx":{=
"bytes":1406,"packets":17,"errors":0,"dropped":0,"carrier_errors":0,"collis=
ions":0,"aborted_errors":0,"fifo_errors":0,"window_errors":0,"heartbeat_err=
ors":0,"carrier_changes":2}}}]
>
> On Thu, Jun 9, 2022 at 2:07 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wrot=
e:
> >
> > sample output:
> >
> > mypc[netns:ns-123771-2]:~# ip netns exec $ns2 ./ip -s -s link sh
> > 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
> > mode DEFAULT group default qlen 1000
> > link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> > RX: bytes packets errors dropped missed mcast
> > 0 0 0 0 0 0
> > RX errors: length crc frame fifo overrun
> > 0 0 0 0 0
> > TX: bytes packets errors dropped carrier collsns
> > 0 0 0 0 0 0
> > TX errors: aborted fifo window heartbt transns
> > 0 0 0 0 0
> > 2: veth2@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
> > state UP mode DEFAULT group default qlen 1000
> > link/ether 8e:c0:a5:7d:87:ad brd ff:ff:ff:ff:ff:ff link-netns ns-123771=
-1
> > RX: bytes packets errors dropped missed mcast
> > 1766 22 0 0 0 0
> > RX errors: length crc frame fifo overrun otherhost
> > 0 0 0 0 0 10
> > TX: bytes packets errors dropped carrier collsns
> > 1126 13 0 0 0 0
> > TX errors: aborted fifo window heartbt transns
> > 0 0 0 0 2
> >
> > On Thu, Jun 9, 2022 at 2:05 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wr=
ote:
> > >
> > > From: Jeffrey Ji <jeffreyji@google.com>
> > >
> > > This stat was added in commit 794c24e9921f ("net-core: rx_otherhost_d=
ropped to core_stats")
> > >
> > > Tested: sent packet with wrong MAC address from 1
> > > network namespace to another, verified that counter showed "1" in
> > > `ip -s -s link sh` and `ip -s -s -j link sh`
> > >
> > > Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
> > > ---
> > > changelog:
> > > v2: otherhost <- otherhost_dropped
> > >
> > >  ip/ipaddress.c | 18 +++++++++++++++---
> > >  1 file changed, 15 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> > > index 142731933ba3..d7d047cf901e 100644
> > > --- a/ip/ipaddress.c
> > > +++ b/ip/ipaddress.c
> > > @@ -692,6 +692,7 @@ void print_stats64(FILE *fp, struct rtnl_link_sta=
ts64 *s,
> > >                 strlen("heartbt"),
> > >                 strlen("overrun"),
> > >                 strlen("compressed"),
> > > +               strlen("otherhost"),
> > >         };
> > >
> > >         if (is_json_context()) {
> > > @@ -730,6 +731,10 @@ void print_stats64(FILE *fp, struct rtnl_link_st=
ats64 *s,
> > >                         if (s->rx_nohandler)
> > >                                 print_u64(PRINT_JSON,
> > >                                            "nohandler", NULL, s->rx_n=
ohandler);
> > > +                       if (s->rx_otherhost_dropped)
> > > +                               print_u64(PRINT_JSON,
> > > +                                          "otherhost", NULL,
> > > +                                          s->rx_otherhost_dropped);
> > >                 }
> > >                 close_json_object();
> > >
> > > @@ -778,7 +783,8 @@ void print_stats64(FILE *fp, struct rtnl_link_sta=
ts64 *s,
> > >                         size_columns(cols, ARRAY_SIZE(cols), 0,
> > >                                      s->rx_length_errors, s->rx_crc_e=
rrors,
> > >                                      s->rx_frame_errors, s->rx_fifo_e=
rrors,
> > > -                                    s->rx_over_errors, s->rx_nohandl=
er);
> > > +                                    s->rx_over_errors, s->rx_nohandl=
er,
> > > +                                    s->rx_otherhost_dropped);
> > >                 size_columns(cols, ARRAY_SIZE(cols),
> > >                              s->tx_bytes, s->tx_packets, s->tx_errors=
,
> > >                              s->tx_dropped, s->tx_carrier_errors,
> > > @@ -811,11 +817,14 @@ void print_stats64(FILE *fp, struct rtnl_link_s=
tats64 *s,
> > >                 /* RX error stats */
> > >                 if (show_stats > 1) {
> > >                         fprintf(fp, "%s", _SL_);
> > > -                       fprintf(fp, "    RX errors:%*s %*s %*s %*s %*=
s %*s %*s%s",
> > > +                       fprintf(fp, "    RX errors:%*s %*s %*s %*s %*=
s %*s%*s%*s%s",
> > >                                 cols[0] - 10, "", cols[1], "length",
> > >                                 cols[2], "crc", cols[3], "frame",
> > >                                 cols[4], "fifo", cols[5], "overrun",
> > > -                               cols[6], s->rx_nohandler ? "nohandler=
" : "",
> > > +                               s->rx_nohandler ? cols[6] + 1 : 0,
> > > +                               s->rx_nohandler ? " nohandler" : "",
> > > +                               s->rx_otherhost_dropped ? cols[7] + 1=
 : 0,
> > > +                               s->rx_otherhost_dropped ? " otherhost=
" : "",
> > >                                 _SL_);
> > >                         fprintf(fp, "%*s", cols[0] + 5, "");
> > >                         print_num(fp, cols[1], s->rx_length_errors);
> > > @@ -825,6 +834,9 @@ void print_stats64(FILE *fp, struct rtnl_link_sta=
ts64 *s,
> > >                         print_num(fp, cols[5], s->rx_over_errors);
> > >                         if (s->rx_nohandler)
> > >                                 print_num(fp, cols[6], s->rx_nohandle=
r);
> > > +                       if (s->rx_otherhost_dropped)
> > > +                               print_num(fp, cols[7],
> > > +                               s->rx_otherhost_dropped);
> > >                 }
> > >                 fprintf(fp, "%s", _SL_);
> > >
> > > --
> > > 2.36.1.476.g0c4daa206d-goog
> > >
