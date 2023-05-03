Return-Path: <netdev+bounces-162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B866F591E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 373E81C20D90
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806D0D531;
	Wed,  3 May 2023 13:35:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7112F321E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:35:25 +0000 (UTC)
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012B51FDB
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 06:35:23 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-55a010774a5so61101557b3.3
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 06:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683120923; x=1685712923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/HzLEhIjuKFWd0RmFL36ROlVagTDI2BEogjapWI9fE=;
        b=CHqYWrUvFft88y3Ie/yjLfqFqQDr/3nmeELynOfcjsZBZO+9t/ZkxPO7Xt9IYyD5Ja
         iqEQGPsDJSMDjcbdlCH1SJpd2MynoEZgR3BMmB6ksYIRzmtf5DaSk2z4TbiibiOvwQRo
         gcEzKligRtyOdC0kH6YJaJWPBdxWw/13QtdO+EcJieEu4Q43kTias/MeXN+0TTTsjl48
         yUFGJyZr19GwXntLKFj+jWUjhuYdHgihghPp0drmOzlGzQ6V0RmD/uMancNWWjzwWeO8
         dcbCJtgZJuTtcxVQ3GCiuHGPLnx1jUG+6tpiIWKjDgrAw0E0keiXj91Yh7xZx49KSMb/
         nbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683120923; x=1685712923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/HzLEhIjuKFWd0RmFL36ROlVagTDI2BEogjapWI9fE=;
        b=TO57ObYTPsxP47dAWYA2mwI6btlcJJwy6/rSifKKHRAkzaqXpnVLjUPAPU5hS4h1ED
         wHvz0LZaPRkJxDDyg5mP1R64TgHJvhf1qX3K9HUfMT/He+VOCbvai3Q0KAAj01RKuLNt
         ufIZ7MfgDHsWQ707ndH9XZ7DRzVNRCBJiktOvAhmTu4NsM1SKFA3YBPgyQkC6lGP6ba6
         sTMltkVvemrqWPpF662CaNEWsTvtKVLV24sBIdufABKJzecXIlO85V/SQMtCyVIQnKSy
         Aau9LzsH3Rlqkgi3SSPhvxQ5fLcXLlZeSQEo76uSD/yH5vy/fELiOC/DOBsjKRckG14w
         2RLg==
X-Gm-Message-State: AC+VfDx5zwJueyMUybPATIB8sSjCmoBF+grSJaXpyPGIfZtZSFmER31v
	8HedHJFp9cgdd0J9rrIRBTU/7mlP8D/UwtTMHAQ=
X-Google-Smtp-Source: ACHHUZ4iOD46TqNB4nqJSJSwhMMr5RF1VvGbd6DIIcEcSAYZ4fkdOAtL676ahXM19aIlE1DV9NrzD5YcqPS1T6FIRrY=
X-Received: by 2002:a81:6c8f:0:b0:55a:1022:7814 with SMTP id
 h137-20020a816c8f000000b0055a10227814mr11707619ywc.28.1683120922218; Wed, 03
 May 2023 06:35:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1683065352.git.lucien.xin@gmail.com> <0d328807d5087d0b6d03c3d2e5f355cd44ed576a.1683065352.git.lucien.xin@gmail.com>
 <DB9PR05MB90784F5E870CF98996BD406A886C9@DB9PR05MB9078.eurprd05.prod.outlook.com>
In-Reply-To: <DB9PR05MB90784F5E870CF98996BD406A886C9@DB9PR05MB9078.eurprd05.prod.outlook.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 3 May 2023 09:35:02 -0400
Message-ID: <CADvbK_f5YPuY0eaZj5JcixUU7rFQosuAWg8PdorrGz08ve6DmA@mail.gmail.com>
Subject: Re: [PATCHv2 net 2/3] tipc: do not update mtu if msg_max is too small
 in mtu negotiation
To: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Cc: network dev <netdev@vger.kernel.org>, 
	"tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 2, 2023 at 11:31=E2=80=AFPM Tung Quang Nguyen
<tung.q.nguyen@dektech.com.au> wrote:
>
> >When doing link mtu negotiation, a malicious peer may send Activate msg
> >with a very small mtu, e.g. 4 in Shuang's testing, without checking for
> >the minimum mtu, l->mtu will be set to 4 in tipc_link_proto_rcv(), then
> >n->links[bearer_id].mtu is set to 4294967228, which is a overflow of
> >'4 - INT_H_SIZE - EMSG_OVERHEAD' in tipc_link_mss().
> >
> >With tipc_link.mtu =3D 4, tipc_link_xmit() kept printing the warning:
> >
> > tipc: Too large msg, purging xmit list 1 5 0 40 4!
> > tipc: Too large msg, purging xmit list 1 15 0 60 4!
> >
> >And with tipc_link_entry.mtu 4294967228, a huge skb was allocated in
> >named_distribute(), and when purging it in tipc_link_xmit(), a crash
> >was even caused:
> >
> >  general protection fault, probably for non-canonical address 0x2100001=
011000dd: 0000 [#1] PREEMPT SMP PTI
> >  CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 6.3.0.neta #19
> >  RIP: 0010:kfree_skb_list_reason+0x7e/0x1f0
> >  Call Trace:
> >   <IRQ>
> >   skb_release_data+0xf9/0x1d0
> >   kfree_skb_reason+0x40/0x100
> >   tipc_link_xmit+0x57a/0x740 [tipc]
> >   tipc_node_xmit+0x16c/0x5c0 [tipc]
> >   tipc_named_node_up+0x27f/0x2c0 [tipc]
> >   tipc_node_write_unlock+0x149/0x170 [tipc]
> >   tipc_rcv+0x608/0x740 [tipc]
> >   tipc_udp_recv+0xdc/0x1f0 [tipc]
> >   udp_queue_rcv_one_skb+0x33e/0x620
> >   udp_unicast_rcv_skb.isra.72+0x75/0x90
> >   __udp4_lib_rcv+0x56d/0xc20
> >   ip_protocol_deliver_rcu+0x100/0x2d0
> >
> >This patch fixes it by checking the new mtu against tipc_bearer_min_mtu(=
),
> >and not updating mtu if it is too small.
> >
> >v1->v2:
> >  - do the msg_max check against the min MTU early, as Tung suggested.
> Please move above version change comment to after "---".
I think it's correct to NOT use ''---' for version changes, see the
comment from davem:

  https://lore.kernel.org/netdev/20160415.172858.253625178036493951.davem@d=
avemloft.net/

unless there are some new rules I missed.

Thanks.

> >
> >Fixes: ed193ece2649 ("tipc: simplify link mtu negotiation")
> >Reported-by: Shuang Li <shuali@redhat.com>
> >Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >---
> > net/tipc/link.c | 9 ++++++---
> > 1 file changed, 6 insertions(+), 3 deletions(-)
> >
> >diff --git a/net/tipc/link.c b/net/tipc/link.c
> >index b3ce24823f50..2eff1c7949cb 100644
> >--- a/net/tipc/link.c
> >+++ b/net/tipc/link.c
> >@@ -2200,7 +2200,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l=
, struct sk_buff *skb,
> >       struct tipc_msg *hdr =3D buf_msg(skb);
> >       struct tipc_gap_ack_blks *ga =3D NULL;
> >       bool reply =3D msg_probe(hdr), retransmitted =3D false;
> >-      u32 dlen =3D msg_data_sz(hdr), glen =3D 0;
> >+      u32 dlen =3D msg_data_sz(hdr), glen =3D 0, msg_max;
> >       u16 peers_snd_nxt =3D  msg_next_sent(hdr);
> >       u16 peers_tol =3D msg_link_tolerance(hdr);
> >       u16 peers_prio =3D msg_linkprio(hdr);
> >@@ -2239,6 +2239,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l=
, struct sk_buff *skb,
> >       switch (mtyp) {
> >       case RESET_MSG:
> >       case ACTIVATE_MSG:
> >+              msg_max =3D msg_max_pkt(hdr);
> >+              if (msg_max < tipc_bearer_min_mtu(l->net, l->bearer_id))
> >+                      break;
> >               /* Complete own link name with peer's interface name */
> >               if_name =3D  strrchr(l->name, ':') + 1;
> >               if (sizeof(l->name) - (if_name - l->name) <=3D TIPC_MAX_I=
F_NAME)
> >@@ -2283,8 +2286,8 @@ static int tipc_link_proto_rcv(struct tipc_link *l=
, struct sk_buff *skb,
> >               l->peer_session =3D msg_session(hdr);
> >               l->in_session =3D true;
> >               l->peer_bearer_id =3D msg_bearer_id(hdr);
> >-              if (l->mtu > msg_max_pkt(hdr))
> >-                      l->mtu =3D msg_max_pkt(hdr);
> >+              if (l->mtu > msg_max)
> >+                      l->mtu =3D msg_max;
> >               break;
> >
> >       case STATE_MSG:
> >--
> >2.39.1
>

