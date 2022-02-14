Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023094B5CA5
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiBNVYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 16:24:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiBNVYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 16:24:12 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C043FEB0C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 13:24:02 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id p14so15829317ejf.11
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 13:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wcjj7gZXIEp2LHTuwEUIdb3BuIzLUnOSVz2CqHE7ouQ=;
        b=MYWK3YTQ9H35QQAULCjH03XYLMBKBCeX4EYxaXf/krhyi29r0wvXOrtAg0+d1T09h9
         bfkt81Uej0z2HgTvzj3nqwqfebJ4FSfk4cs6pyvqIi5Nr3Z7k2g8p3dpDgUBYDey8Fg3
         UJM+t8U9WQiFaEc6IBe02AATcf6t7iBp6hDH8ygMYQ0Kre6dWiLqKwCj9vECW2Sj9tRH
         7wQ4yfH14/dqlaev2lQklp542dDCLdnSYfroU3alZpBjhNoa5yZjhA6RTPsF8Vzjd21E
         MKkafx3b7TrNr0VSDpvFOzRG6P02/vB97evCSg4q6M9oAawxqtDRAzPVuOOZBjt8GmZU
         bNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wcjj7gZXIEp2LHTuwEUIdb3BuIzLUnOSVz2CqHE7ouQ=;
        b=M2iZeOuxVhQJVqd86yGOvWYzL5thMtaglDOApreX/G57pP/VnL6AiZX8wF8vqW/f4l
         RaUNbndcfZE+kScp9KJKEyZAaan/VUrbTxgb/Zk5mSeTuEgAaYohbcnKextB41XtEdal
         x9yWN2KH2Q499hU6jDtv/laiS2Eayo6t0QrrwTDkoH8VKaCoD0eH4rLdkoTlcB5sdQjg
         ebxtmI/IFVR/rB9I5+rtbHED+pyGHEIjaZ/OyPVx0zg0ySzWdwmKQM4vmYxfPmhVFG/q
         2XI7i/QYjOqXLhfELBFsvhy0CAbv8BlllmBsys3UzSqoJGbPNCSnFycn3Z1DBJlmBWYh
         PRgg==
X-Gm-Message-State: AOAM531xie3YfUPq1/m1usEenA2lFUrReyqH437FPJvdqwimO1zHm5z3
        LpdBrpvk3bVcDQG7BdJbT67XJr+KGUXHcQEn9CzqWd0rk4MsRbnW+Tw=
X-Google-Smtp-Source: ABdhPJyfDNdiMZd+ex2RPuAmdqYf/5cE0OeiiYbKprMe/K5gzmyZz0ejuAaBR5ZeV7518GV36ASSkBVLq50AwWDCgS8=
X-Received: by 2002:a17:906:7a18:: with SMTP id d24mr607389ejo.232.1644873840270;
 Mon, 14 Feb 2022 13:24:00 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR05MB6392296287614B80498B73C5CE339@BYAPR05MB6392.namprd05.prod.outlook.com>
In-Reply-To: <BYAPR05MB6392296287614B80498B73C5CE339@BYAPR05MB6392.namprd05.prod.outlook.com>
From:   Mobashshera Rasool <mobash.rasool.linux@gmail.com>
Date:   Tue, 15 Feb 2022 02:53:49 +0530
Message-ID: <CAJceWd-o4ubk=-rC_3DQfj55QqRMPr4T5BF1odxdiz9Gk1J1Bg@mail.gmail.com>
Subject: [PATCH net-next] net: ip6mr: add support for passing full packet on
 wrong mif
To:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     mrasool@vmware.com, equinox@opensourcerouting.org,
        mobash.rasool@gmail.com
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

This patch adds support for MRT6MSG_WRMIFWHOLE which is used to pass
full packet and real vif id when the incoming interface is wrong.
While the RP and FHR are setting up state we need to be sending the
registers encapsulated with all the data inside otherwise we lose it.
The RP then decapsulates it and forwards it to the interested parties.
Currently with WRONGMIF we can only be sending empty register packets
and will lose that data.
This behaviour can be enabled by using MRT_PIM with
val == MRT6MSG_WRMIFWHOLE. This doesn't prevent MRT6MSG_WRONGMIF from
happening, it happens in addition to it, also it is controlled by the same
throttling parameters as WRONGMIF (i.e. 1 packet per 3 seconds currently).
Both messages are generated to keep backwards compatibily and avoid
breaking someone who was enabling MRT_PIM with val == 4, since any
positive val is accepted and treated the same.

Signed-off-by: Mobashshera Rasool <mobash.rasool@gmail.com>
---
 include/uapi/linux/mroute6.h |  1 +
 net/ipv6/ip6mr.c             | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h
index a1fd617..1d90c21 100644
--- a/include/uapi/linux/mroute6.h
+++ b/include/uapi/linux/mroute6.h
@@ -134,6 +134,7 @@ struct mrt6msg {
 #define MRT6MSG_NOCACHE         1
 #define MRT6MSG_WRONGMIF        2
 #define MRT6MSG_WHOLEPKT        3               /* used for use level encap */
+#define MRT6MSG_WRMIFWHOLE     4               /* For PIM Register
and assert processing */
         __u8            im6_mbz;                /* must be zero            */
         __u8            im6_msgtype;            /* what type of message    */
         __u16           im6_mif;                /* mif rec'd on            */
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 7cf73e6..1eed315 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1040,7 +1040,7 @@ static int ip6mr_cache_report(struct mr_table
*mrt, struct sk_buff *pkt,
         int ret;

 #ifdef CONFIG_IPV6_PIMSM_V2
-       if (assert == MRT6MSG_WHOLEPKT)
+       if (assert == MRT6MSG_WHOLEPKT || assert == MRT6MSG_WRMIFWHOLE)
                 skb = skb_realloc_headroom(pkt, -skb_network_offset(pkt)
                                                 +sizeof(*msg));
         else
@@ -1056,7 +1056,7 @@ static int ip6mr_cache_report(struct mr_table
*mrt, struct sk_buff *pkt,
         skb->ip_summed = CHECKSUM_UNNECESSARY;

 #ifdef CONFIG_IPV6_PIMSM_V2
-       if (assert == MRT6MSG_WHOLEPKT) {
+       if (assert == MRT6MSG_WHOLEPKT || assert == MRT6MSG_WRMIFWHOLE) {
                 /* Ugly, but we have no choice with this interface.
                    Duplicate old header, fix length etc.
                    And all this only to mangle msg->im6_msgtype and
@@ -1068,8 +1068,11 @@ static int ip6mr_cache_report(struct mr_table
*mrt, struct sk_buff *pkt,
                 skb_reset_transport_header(skb);
                 msg = (struct mrt6msg *)skb_transport_header(skb);
                 msg->im6_mbz = 0;
-               msg->im6_msgtype = MRT6MSG_WHOLEPKT;
-               msg->im6_mif = mrt->mroute_reg_vif_num;
+               msg->im6_msgtype = assert;
+               if (assert == MRT6MSG_WRMIFWHOLE)
+                       msg->im6_mif = mifi;
+               else
+                       msg->im6_mif = mrt->mroute_reg_vif_num;
                 msg->im6_pad = 0;
                 msg->im6_src = ipv6_hdr(pkt)->saddr;
                 msg->im6_dst = ipv6_hdr(pkt)->daddr;
@@ -1633,6 +1636,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int
optname, sockptr_t optval,
         mifi_t mifi;
         struct net *net = sock_net(sk);
         struct mr_table *mrt;
+       bool do_wrmifwhole;

         if (sk->sk_type != SOCK_RAW ||
             inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
@@ -1746,12 +1750,15 @@ int ip6_mroute_setsockopt(struct sock *sk, int
optname, sockptr_t optval,
                         return -EINVAL;
                 if (copy_from_sockptr(&v, optval, sizeof(v)))
                         return -EFAULT;
+
+               do_wrmifwhole = (v == MRT6MSG_WRMIFWHOLE);
                 v = !!v;
                 rtnl_lock();
                 ret = 0;
                 if (v != mrt->mroute_do_pim) {
                         mrt->mroute_do_pim = v;
                         mrt->mroute_do_assert = v;
+                       mrt->mroute_do_wrvifwhole = do_wrmifwhole;
                 }
                 rtnl_unlock();
                 return ret;
@@ -2127,6 +2134,9 @@ static void ip6_mr_forward(struct net *net,
struct mr_table *mrt,
                                MFC_ASSERT_THRESH)) {
                         c->_c.mfc_un.res.last_assert = jiffies;
                         ip6mr_cache_report(mrt, skb, true_vifi,
MRT6MSG_WRONGMIF);
+                       if (mrt->mroute_do_wrvifwhole)
+                               ip6mr_cache_report(mrt, skb, true_vifi,
+                                                  MRT6MSG_WRMIFWHOLE);
                 }
                 goto dont_forward;
         }
--
2.7.4
