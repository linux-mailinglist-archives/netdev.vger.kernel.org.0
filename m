Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE06520B1C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiEJCYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiEJCYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:24:16 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583C52A7C08
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:20:20 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2f7bb893309so164455637b3.12
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rpJkptexJXwGHGK1SVH524N6M2yYDRaWDHKpn/zLgkk=;
        b=R6kFCKcuiJJ01+evggHDQjh0JoQ0V6p99/Ah9MhAF1GRDq3VgQiZvWp/ZTsZlqDjY0
         spz+uj3ym9amyK1CqTcXovahBxmgYls6QpmhD2ISp2YLwbuxGoFNjE+QJuheYbeZrcgy
         38hddjhb7KMxsfEO+EHdES5+RUmyMm3UbXpoTBEVTUMpukt/7Hep+UJHZ9yH+fEFJR0/
         Y72j6JVToLWDTvG1NzsiHUpIM7w8jNFtCxa4MqSa4m0+onN0eI2kPLmCxsINmi7kJ1Gg
         qzCscocjpvJ1qkVQW14XvQ6chcrQCy4N/TFKsMcM+gKiMg1RuK/dXlRTGlkp5xx3BVJp
         /V0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rpJkptexJXwGHGK1SVH524N6M2yYDRaWDHKpn/zLgkk=;
        b=JeLHp1fgxajQ0gX7dTXV/l8u8cF6fBUCbCPjscu0VSvNuJEy8q/NCpnvZPr2+gW8m/
         wda2/ocaT+fjysJqFNurCSmaK0OX+XPVvz0jaB1X64g6UU/LDECWiwA7BH3hT9ocM49x
         Ry2m3U1fIHPMp9qt30oYveNdK6HtNcopQ2NSoVqwHIc3UGMH1ZTUglYvg5jfIwK0fv3q
         i3S0yKWktFqjg7IfeiHvPqmXGQ/b2E5IJZapEvRnTXGObjWRTHSaf/yh/klUM1k3sDpx
         vv9i0tn7A7UkXOtLj52fZzIAWYWsfSwJ2/1BfG9kgtcJ56ngtdoA1yy16VflRkVzT4By
         9T0Q==
X-Gm-Message-State: AOAM530OJ0kK8i3fWgP9UJsdRJmnY1mE1LpnpoHjVQOD1AKs1SLq0+gA
        wOUWCM0/njONKnlEWtU35+w/w9qYW3oSVCk7fg5dag==
X-Google-Smtp-Source: ABdhPJzNLIWyTucog9+LxO/OfWZFOtSKpflkiAkQ5zC/6zFDt5xqm2N8hU1w4MIxTgKq+PYUt+NRHkFNjiJ2Yx949oU=
X-Received: by 2002:a81:234b:0:b0:2f8:4082:bbd3 with SMTP id
 j72-20020a81234b000000b002f84082bbd3mr17063640ywj.47.1652149219309; Mon, 09
 May 2022 19:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220509222149.1763877-3-eric.dumazet@gmail.com>
 <202205100923.RHeXqtNd-lkp@intel.com> <CANn89i+uKcuJDxfZ7zNHrrj3QKHojfdv42S+DbFhFAeO-DCcSA@mail.gmail.com>
In-Reply-To: <CANn89i+uKcuJDxfZ7zNHrrj3QKHojfdv42S+DbFhFAeO-DCcSA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 19:20:08 -0700
Message-ID: <CANn89iKav+CyauFvgaiN4fyavVjEsa=wn2Wrdf6mopSrN=ecWQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 02/13] net: allow gso_max_size to exceed 65536
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 7:09 PM Eric Dumazet <edumazet@google.com> wrote:
>

>
> Alexander used :
>
> +                       if (sk->sk_gso_max_size > GSO_LEGACY_MAX_SIZE &&
> +                           (!IS_ENABLED(CONFIG_IPV6) || sk->sk_family
> != AF_INET6 ||
> +                            !sk_is_tcp(sk) ||
> ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
> +                               sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
>
> I guess we could simply allow gso_max_size to be bigger than
> GSO_LEGACY_MAX_SIZE only
> if IS_ENABLED(CONFIG_IPV6)
>
> So the above code could really be:
>
> #if IS_ENABLED(CONFIG_IPV6)
>                        if (sk->sk_gso_max_size > GSO_LEGACY_MAX_SIZE &&
>                            (sk->sk_family != AF_INET6 ||
>                             !sk_is_tcp(sk) ||
> ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
>                                sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
> #endif

In v6, I will squash the following diff to Alexander patch:

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index dfd57a647c97ed0f400ffe89c73919367a900f75..6bd9e09b34ec583a05a929ca979511e6423dbeb7
100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2271,8 +2271,13 @@ struct net_device {

 /* TCP minimal MSS is 8 (TCP_MIN_GSO_SIZE),
  * and shinfo->gso_segs is a 16bit field.
+ * If IPV6 is not enabled, we keep legacy value.
  */
+#if IS_ENABLED(CONFIG_IPV6)
 #define GSO_MAX_SIZE           (8 * GSO_MAX_SEGS)
+#else
+#define GSO_MAX_SIZE           GSO_LEGACY_MAX_SIZE
+#endif

        unsigned int            gso_max_size;
 #define TSO_LEGACY_MAX_SIZE    65536
diff --git a/net/core/dev.c b/net/core/dev.c
index 7349f75891d5724a060781abc80a800bdf835f74..4be3695846520af18a687cdcaa70c5f327ba94e8
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3003,7 +3003,7 @@ EXPORT_SYMBOL(netif_set_real_num_queues);
  */
 void netif_set_tso_max_size(struct net_device *dev, unsigned int size)
 {
-       dev->tso_max_size = size;
+       dev->tso_max_size = min(GSO_MAX_SIZE, size);
        if (size < READ_ONCE(dev->gso_max_size))
                netif_set_gso_max_size(dev, size);
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index f7c3171078b6fccd25757e8fe54dd56a2a674238..2a931f396472108ccedcd3d08189c63775caecff
100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2312,10 +2312,13 @@ void sk_setup_caps(struct sock *sk, struct
dst_entry *dst)
                        sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
                        /* pairs with the WRITE_ONCE() in
netif_set_gso_max_size() */
                        sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+#if IS_ENABLED(CONFIG_IPV6)
                        if (sk->sk_gso_max_size > GSO_LEGACY_MAX_SIZE &&
-                           (!IS_ENABLED(CONFIG_IPV6) || sk->sk_family
!= AF_INET6 ||
-                            !sk_is_tcp(sk) ||
ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
+                           (sk->sk_family != AF_INET6 ||
+                            !sk_is_tcp(sk) ||
+                            ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
                                sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
+#endif
                        sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
                        /* pairs with the WRITE_ONCE() in
netif_set_gso_max_segs() */
                        max_segs = max_t(u32,
READ_ONCE(dst->dev->gso_max_segs), 1);
