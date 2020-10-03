Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0382823CF
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 13:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJCLXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 07:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgJCLXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 07:23:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8329C0613D0;
        Sat,  3 Oct 2020 04:23:46 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so4553423wrx.7;
        Sat, 03 Oct 2020 04:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RbIkL1MLggQpNrhEkO/nseBhlRz9oCOjUCnTTlflXxs=;
        b=IkRrY80ig+Ex9uCTjlNV/kR/z7RpkUTO8iwy37gzo1i4Vm6Qh6uH9Ut8IYwqQRuyhY
         /WunDlYH1FKDKsOwJdGuhDWOET66LlIKHDFMZqBG2E+Q4LpPKaHP/spn7XhET2dyY4FH
         NwKGr5i7BFMiVd/Vpw0Swn1ady4xMI+fhWhsGPDd7U8hybQ27zLJEhT9S/Q9Civp4BEm
         ikESkHXCxf2C1D+mC8e4zuxaAO+oUFGV/QdcsY+tkEKsX7evW1RTLt+hYWW0mvPQfWn3
         dohunfB60iCeX5+7Ah35XeBGyR1S4qQZO6v8rbowUqP5S/vME6PY4iXop6uVUqF8zqs6
         a4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RbIkL1MLggQpNrhEkO/nseBhlRz9oCOjUCnTTlflXxs=;
        b=DTHCu4YhvcFb+W3vnxm37c1L9AfD7MMRBG8aPI6FgE5ONsL4n1O/6OK6aZzA/gCskY
         SAs5TYIjEaUhqcjFgmMCxszpOZmSqFPefszpwAmbzQHLsupYkKGNUu9N0UBR96CceZbX
         wjWmkhSfj3Z/sb34KeZXgj+56YcnQOy07VeWPahoArxukDiSDqUNcCOOpJjZz66RuYsl
         zDcB57br2HgxaunOvNHtViwIWIcV4qRy31HOkZEWYDf6qcAW9YZiT4fN7a3vc1fEFSPJ
         T71xbYm/+iC2sx6UW1v0FU7LK+RKMMrUyN3jtMEnvzGrUtAnRPryJcj/KGmgy5mQfML+
         mwvg==
X-Gm-Message-State: AOAM533JothEnaSpJLeuhNPDCXvJqj4cM2mSEqKw5Zhs1l7HSX9ZCnkq
        KkI51xi2HBVgANCgJUE5y2cX1oN4UXbBtQnFVJ4=
X-Google-Smtp-Source: ABdhPJyxMz8Yad3hb6WXtOH541uxpjRgz318d5HRrRpavvZVWx5166kOVN2sO2YbHOCJ7nfqwMll4vVa3g7DpNtITQI=
X-Received: by 2002:adf:82ce:: with SMTP id 72mr7703948wrc.404.1601724225629;
 Sat, 03 Oct 2020 04:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <202009300218.2AcHEN0L-lkp@intel.com> <20201003040824.GG70998@localhost.localdomain>
 <CADvbK_cPX1f5jrGsKuvya7ssOFPTsG7daBCkOP-NGN9hpzf5Vw@mail.gmail.com>
In-Reply-To: <CADvbK_cPX1f5jrGsKuvya7ssOFPTsG7daBCkOP-NGN9hpzf5Vw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 19:23:33 +0800
Message-ID: <CADvbK_eXnzjDCypRkep9JqxBFV=cMXNkSZr4nyAaMiDc1VGXJg@mail.gmail.com>
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

On Sat, Oct 3, 2020 at 4:12 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Sat, Oct 3, 2020 at 12:08 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, Sep 30, 2020 at 03:00:42AM +0800, kernel test robot wrote:
> > > Hi Xin,
> > >
> > > Thank you for the patch! Yet something to improve:
> >
> > I wonder how are you planning to fix this. It is quite entangled.
> > This is not performance critical. Maybe the cleanest way out is to
> > move it to a .c file.
> >
> > Adding a
> > #if defined(CONFIG_IP_SCTP) || defined(CONFIG_IP_SCTP_MODULE)
> > in there doesn't seem good.
> >
> > >    In file included from include/net/sctp/checksum.h:27,
> > >                     from net/netfilter/nf_nat_proto.c:16:
> > >    include/net/sctp/sctp.h: In function 'sctp_mtu_payload':
> > > >> include/net/sctp/sctp.h:583:31: error: 'struct net' has no member named 'sctp'; did you mean 'ct'?
> > >      583 |   if (sock_net(&sp->inet.sk)->sctp.udp_port)
> > >          |                               ^~~~
> > >          |                               ct
> > >
> Here is actually another problem, I'm still thinking how to fix it.
>
> Now sctp_mtu_payload() returns different value depending on
> net->sctp.udp_port. but net->sctp.udp_port can be changed by
> "sysctl -w" anytime. so:
>
> In sctp_packet_config() it gets overhead/headroom by calling
> sctp_mtu_payload(). When 'udp_port' is 0, it's IP+MAC header
> size. Then if 'udp_port' is changed to 9899 by 'sysctl -w',
> udphdr will also be added to the packet in sctp_v4_xmit(),
> and later the headroom may not be enough for IP+MAC headers.
>
> I'm thinking to add sctp_sock->udp_port, and it'll be set when
> the sock is created with net->udp_port. but not sure if we should
> update sctp_sock->udp_port with  net->udp_port when sending packets?
something like:

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 6614c9fdc51e..c379d805b9df 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -91,6 +91,7 @@ void sctp_packet_config(struct sctp_packet *packet,
__u32 vtag,
        if (asoc) {
                sk = asoc->base.sk;
                sp = sctp_sk(sk);
+               sctp_sock_check_udp_port(sock_net(sk), sp, asoc);
        }
        packet->overhead = sctp_mtu_payload(sp, 0, 0);
        packet->size = packet->overhead;
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 21d0ff1c6ab9..f5aba9086d33 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1250,6 +1250,7 @@ static inline struct sctp_chunk
*sctp_make_op_error_limited(
        if (asoc) {
                size = min_t(size_t, size, asoc->pathmtu);
                sp = sctp_sk(asoc->base.sk);
+               sctp_sock_check_udp_port(sock_net(sk), sp, asoc);
        }

        size = sctp_mtu_payload(sp, size, sizeof(struct sctp_errhdr));
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8edab1533057..3e7f81d63d2e 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6276,6 +6276,8 @@ static struct sctp_packet *sctp_ootb_pkt_new(
        sctp_transport_route(transport, (union sctp_addr *)&chunk->dest,
                             sctp_sk(net->sctp.ctl_sock));

+       sctp_sock_check_udp_port(net, net->sctp.ctl_sock, NULL);
+
        packet = &transport->packet;
        sctp_packet_init(packet, transport, sport, dport);
        sctp_packet_config(packet, vtag, 0);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d793dfa94682..e5de5f98be0c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1550,6 +1550,17 @@ static int sctp_error(struct sock *sk, int
flags, int err)
        return err;
 }

+void sctp_sock_check_udp_port(struct net* net, struct sctp_sock *sp,
+                             struct sctp_association *asoc)
+{
+       if (likely(sp->udp_port == net->sctp.udp_port))
+               return;
+
+       if (asoc && (!sp->udp_port || !net->sctp.udp_port))
+               sctp_assoc_update_frag_point(asoc);
+       sp->udp_port = net->sctp.udp_port;
+}
+
 /* API 3.1.3 sendmsg() - UDP Style Syntax
  *
  * An application uses sendmsg() and recvmsg() calls to transmit data to
@@ -1795,6 +1806,8 @@ static int sctp_sendmsg_to_asoc(struct
sctp_association *asoc,
                        goto err;
        }

+       sctp_sock_check_udp_port(net, sp, asoc);
+
        if (sp->disable_fragments && msg_len > asoc->frag_point) {
                err = -EMSGSIZE;
                goto err;
