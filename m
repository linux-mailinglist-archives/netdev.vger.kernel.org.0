Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B33C28240F
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 14:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJCMYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 08:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgJCMYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 08:24:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AF8C0613D0;
        Sat,  3 Oct 2020 05:24:47 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l15so2805089wmh.1;
        Sat, 03 Oct 2020 05:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8eSDXNLL6FF69HYC8RCPsjEtE6QSnQXw8iOSx++wXpg=;
        b=NshsgDLQGAKzdyRt+WW1O7GVedOj6UPGSlfK5g55AwOoobnOc4NZpLhcOyCrBjuxXa
         o0sRCIFizB5cS/waeTFzdsXCokLbjMoA3HR2Nc2jysrekz9hO9D5U7TEt7hdBCfDnvdf
         tjySsDzChGkz6SbndGG8Zrww4TnDsbRcLaaTcVzhlOAEK1SdF2xzlDxtJfcMFGkS33yR
         5REAkeuUNnL1iyhMQBds5oQQwf6SW08gOsJqD5C5N5UpkhgJUakV17Gtk0onPqWNAJ3b
         htal8TjTZLPqp5iborQOeU5PmZrLSa3h0A7qJp6askloYOEGBg8GuQmkDhJaknTIILd+
         lPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8eSDXNLL6FF69HYC8RCPsjEtE6QSnQXw8iOSx++wXpg=;
        b=QB//vSHcmj7wV9x4xkUjRZFHDtY/NmUgWgak+kQfqk4iUvF5yS5Q2f3+B+wuAI1kIC
         pFL02D/WZwPtmS2XMbkSW9Mj+AqkQXD8/bNgfZ77J/jSQJmRRygS1M9SDEtRPz7ieFUy
         ik5xmnQUX6vBtQA716KEE5YT6g3/AeRPWi3NE98Tybw+FFagq81MwVXKXVl29Q39cAjb
         pgZ4zGbnYmYICw8zGOoEeH+Kp2ZkhcI/VW0L5QeMIQ6Eq7TaDVMru4e9naa9HyGRTY0a
         7ZmQbPpbvf8iv6RTrG66QP8EcMNTMxx01KpiCanHSB64cMzcW3OqKqOyPq/PgCNn1hpn
         OkOg==
X-Gm-Message-State: AOAM533RId6IQlzK8cqt195asz5MbWVRyvYjOd+VY38pGJsrYTNCe3VF
        HzJ8PYg3nRDPP5vLX5ZUai2QUzMLxA4xDe2MPpA=
X-Google-Smtp-Source: ABdhPJzvYn0eRH4WJcDwfFUQylM6Wjxg2KnUJmfxCRv3Be9DuXcwmmbPySylKyLtfGGfhmPVRiMRTUn3EJijQ6OwER4=
X-Received: by 2002:a1c:1905:: with SMTP id 5mr7694946wmz.32.1601727886483;
 Sat, 03 Oct 2020 05:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <202009300218.2AcHEN0L-lkp@intel.com> <20201003040824.GG70998@localhost.localdomain>
 <CADvbK_cPX1f5jrGsKuvya7ssOFPTsG7daBCkOP-NGN9hpzf5Vw@mail.gmail.com> <CADvbK_eXnzjDCypRkep9JqxBFV=cMXNkSZr4nyAaMiDc1VGXJg@mail.gmail.com>
In-Reply-To: <CADvbK_eXnzjDCypRkep9JqxBFV=cMXNkSZr4nyAaMiDc1VGXJg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 20:24:34 +0800
Message-ID: <CADvbK_fzASk9dLbHLNtLLc+uS7hLz6nDi2CESgN55Yh-o92+rQ@mail.gmail.com>
Subject: Re: [PATCH net-next 11/15] sctp: add udphdr to overhead when udp_port
 is set
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org, kbuild-all@lists.01.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 7:23 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Sat, Oct 3, 2020 at 4:12 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Sat, Oct 3, 2020 at 12:08 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Wed, Sep 30, 2020 at 03:00:42AM +0800, kernel test robot wrote:
> > > > Hi Xin,
> > > >
> > > > Thank you for the patch! Yet something to improve:
> > >
> > > I wonder how are you planning to fix this. It is quite entangled.
> > > This is not performance critical. Maybe the cleanest way out is to
> > > move it to a .c file.
> > >
> > > Adding a
> > > #if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> > > in there doesn't seem good.
> > >
> > > >    In file included from include/net/sctp/checksum.h:27,
> > > >                     from net/netfilter/nf_nat_proto.c:16:
> > > >    include/net/sctp/sctp.h: In function 'sctp_mtu_payload':
> > > > >> include/net/sctp/sctp.h:583:31: error: 'struct net' has no member named 'sctp'; did you mean 'ct'?
> > > >      583 |   if (sock_net(&sp->inet.sk)->sctp.udp_port)
> > > >          |                               ^~~~
> > > >          |                               ct
> > > >
> > Here is actually another problem, I'm still thinking how to fix it.
> >
> > Now sctp_mtu_payload() returns different value depending on
> > net->sctp.udp_port. but net->sctp.udp_port can be changed by
> > "sysctl -w" anytime. so:
> >
> > In sctp_packet_config() it gets overhead/headroom by calling
> > sctp_mtu_payload(). When 'udp_port' is 0, it's IP+MAC header
> > size. Then if 'udp_port' is changed to 9899 by 'sysctl -w',
> > udphdr will also be added to the packet in sctp_v4_xmit(),
> > and later the headroom may not be enough for IP+MAC headers.
> >
> > I'm thinking to add sctp_sock->udp_port, and it'll be set when
> > the sock is created with net->udp_port. but not sure if we should
> > update sctp_sock->udp_port with  net->udp_port when sending packets?
> something like:
>
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 6614c9fdc51e..c379d805b9df 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -91,6 +91,7 @@ void sctp_packet_config(struct sctp_packet *packet,
> __u32 vtag,
>         if (asoc) {
>                 sk = asoc->base.sk;
>                 sp = sctp_sk(sk);
> +               sctp_sock_check_udp_port(sock_net(sk), sp, asoc);
>         }
>         packet->overhead = sctp_mtu_payload(sp, 0, 0);
>         packet->size = packet->overhead;
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 21d0ff1c6ab9..f5aba9086d33 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -1250,6 +1250,7 @@ static inline struct sctp_chunk
> *sctp_make_op_error_limited(
>         if (asoc) {
>                 size = min_t(size_t, size, asoc->pathmtu);
>                 sp = sctp_sk(asoc->base.sk);
> +               sctp_sock_check_udp_port(sock_net(sk), sp, asoc);
>         }
>
>         size = sctp_mtu_payload(sp, size, sizeof(struct sctp_errhdr));
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 8edab1533057..3e7f81d63d2e 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -6276,6 +6276,8 @@ static struct sctp_packet *sctp_ootb_pkt_new(
>         sctp_transport_route(transport, (union sctp_addr *)&chunk->dest,
>                              sctp_sk(net->sctp.ctl_sock));
>
> +       sctp_sock_check_udp_port(net, net->sctp.ctl_sock, NULL);
> +
>         packet = &transport->packet;
>         sctp_packet_init(packet, transport, sport, dport);
>         sctp_packet_config(packet, vtag, 0);
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index d793dfa94682..e5de5f98be0c 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1550,6 +1550,17 @@ static int sctp_error(struct sock *sk, int
> flags, int err)
>         return err;
>  }
>
> +void sctp_sock_check_udp_port(struct net* net, struct sctp_sock *sp,
> +                             struct sctp_association *asoc)
> +{
> +       if (likely(sp->udp_port == net->sctp.udp_port))
> +               return;
> +
> +       if (asoc && (!sp->udp_port || !net->sctp.udp_port))
> +               sctp_assoc_update_frag_point(asoc);
> +       sp->udp_port = net->sctp.udp_port;
> +}
> +
>  /* API 3.1.3 sendmsg() - UDP Style Syntax
>   *
>   * An application uses sendmsg() and recvmsg() calls to transmit data to
> @@ -1795,6 +1806,8 @@ static int sctp_sendmsg_to_asoc(struct
> sctp_association *asoc,
>                         goto err;
>         }
>
> +       sctp_sock_check_udp_port(net, sp, asoc);
> +
>         if (sp->disable_fragments && msg_len > asoc->frag_point) {
>                 err = -EMSGSIZE;
>                 goto err;

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 6408bbb1b95d..86f74f2fe6de 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -580,7 +580,7 @@ static inline __u32 sctp_mtu_payload(const struct
sctp_sock *sp,

        if (sp) {
                overhead += sp->pf->af->net_header_len;
-               if (sock_net(&sp->inet.sk)->sctp.udp_port)
+               if (sp->udp_port)
                        overhead += sizeof(struct udphdr);
        } else {
                overhead += sizeof(struct ipv6hdr);
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 6614c9fdc51e..c96b13ec72f4 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -91,6 +91,14 @@ void sctp_packet_config(struct sctp_packet *packet,
__u32 vtag,
        if (asoc) {
                sk = asoc->base.sk;
                sp = sctp_sk(sk);
+
+               if (unlikely(sp->udp_port != sock_net(sk)->sctp.udp_port)) {
+                       __u16 port = sock_net(sk)->sctp.udp_port;
+
+                       if (!sp->udp_port || !port)
+                               sctp_assoc_update_frag_point(asoc);
+                       sp->udp_port = port;
+               }
        }
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8edab1533057..8deb9d1554e9 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6276,6 +6276,8 @@ static struct sctp_packet *sctp_ootb_pkt_new(
        sctp_transport_route(transport, (union sctp_addr *)&chunk->dest,
                             sctp_sk(net->sctp.ctl_sock));

+       sctp_sk(net->sctp.ctl_sock)->udp_port = net->sctp.udp_port;
+
        packet = &transport->packet;
        sctp_packet_init(packet, transport, sport, dport);
        sctp_packet_config(packet, vtag, 0);

Actually doing this is enough, more simple and clear.
