Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C0D53EDFA
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiFFSmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiFFSmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:42:04 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221EA19FF6E
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 11:42:03 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id s13so16710253ljd.4
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 11:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=zyNzvpmrgf75DqbV+qeI0uwXThgoxSGdVdvBo/EBodo=;
        b=aS8YRGN3ykm43w0kYe8TFeuv4ic2MpiHYb+dpFL0Y8hrUKLaiHsWOWAT4pPsdBMDH/
         jRKOY4yWwARRDYETbhAtvbqE66zEfffIeVQ/2h+cOsJJQTKqp8Ud9YYsMtLZoMdf8mg0
         55Bvkn+Oc33YTRyCyjMRbMCvz1CStY+ihnqHW1UTdHNgOmDVQ/aldK3IEutb02gr5Sz1
         FC+4OxW4UmU4FSmaDzVFiYsg0yzeGEocqwUK3rZe+sklMvFGzzfm6rd4FybSZeUU4PMR
         xgQyRe8c+w8ZrL2iV3/RN/Do0CdocFRNhXze6Xz2vtd4vajtKPFs/hB8oUj8OSBd82Kn
         vZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=zyNzvpmrgf75DqbV+qeI0uwXThgoxSGdVdvBo/EBodo=;
        b=j9pOtjATziIMuFEbaP5oUxRDFg3OiC/+gZID40JZlwGVpRYqLJ4Nvo+ye6kZjPAx0P
         zlDn3N1cy6igk4wcqtA/uDsdRf/YTJBN5fUNStD+XXQCnoxB8oH6wLOD11lLRrPNcUUK
         nmjxrcNdtHujWbtIvcHb1iYZkMZTsp+m8X5nPbrhKoWRZb0P9nWfPLvMcFMy1FtMd3yv
         WINKjNoCd+4bFBAObK1OpA/6aznsVqXAehWVw3h6pjfMC5GhBpZYUUGtKztWIs9DEcuf
         /tzNQGhN1rE8auV6iEtB2tUUTUczyguhEJGDkn6bk5JI/Q0g5wWCCOgJ4daFav3JnpEe
         5eAQ==
X-Gm-Message-State: AOAM530uuRo712iNxY+0z+CPl4++8SL3/ZXWZ5Ko77dlQw8K5hEQ1NML
        6a4Vw+WcJjB5unHcXHdP2N0wclltDLc=
X-Google-Smtp-Source: ABdhPJygFA0r2GjivNeVFTGyklqBWWjYNPPgRY8D6LwoSF5S1BTVa0PVbL0NNdQo4oUT3NqBEcvgOw==
X-Received: by 2002:a2e:6808:0:b0:255:9946:7501 with SMTP id c8-20020a2e6808000000b0025599467501mr3674935lja.505.1654540921315;
        Mon, 06 Jun 2022 11:42:01 -0700 (PDT)
Received: from [192.168.1.241] ([46.109.159.121])
        by smtp.gmail.com with ESMTPSA id bj39-20020a2eaaa7000000b002556cf330e8sm2549651ljb.99.2022.06.06.11.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 11:42:00 -0700 (PDT)
From:   Anton Makarov <antonmakarov11235@gmail.com>
X-Google-Original-From: Anton Makarov <anton.makarov11235@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        david.lebrun@uclouvain.be, kuba@kernel.org
Subject: [net-next 1/1] seg6: add support for SRv6 Headend Reduced
 Encapsulation
Message-ID: <4f26bfaf-3c91-fe19-ede1-d47d852c17f6@gmail.com>
Date:   Mon, 6 Jun 2022 21:41:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends SRv6 Headend behaviors with reduced SRH encapsulation
accordingly to RFC 8986. Additional SRv6 Headend behaviors H.Encaps.Red and
H.Encaps.L2.Red optimize overhead of network traffic for SRv6 L2 and L3 
VPNs.

Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
---
  include/net/seg6.h                 |  2 +
  include/uapi/linux/seg6_iptunnel.h |  2 +
  net/ipv6/seg6_iptunnel.c           | 95 +++++++++++++++++++++++++++++-
  3 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index af668f17b398..8d0ce782f830 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -62,6 +62,8 @@ extern struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff 
*skb, int flags);
  extern void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm 
*opt);
  extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr 
*osrh,
                   int proto);
+extern int seg6_do_srh_encap_red(struct sk_buff *skb, struct 
ipv6_sr_hdr *osrh,
+                 int proto);
  extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr 
*osrh);
  extern int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr 
*nhaddr,
                     u32 tbl_id);
diff --git a/include/uapi/linux/seg6_iptunnel.h 
b/include/uapi/linux/seg6_iptunnel.h
index eb815e0d0ac3..a9fa777f16de 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -35,6 +35,8 @@ enum {
      SEG6_IPTUN_MODE_INLINE,
      SEG6_IPTUN_MODE_ENCAP,
      SEG6_IPTUN_MODE_L2ENCAP,
+    SEG6_IPTUN_MODE_ENCAP_RED,
+    SEG6_IPTUN_MODE_L2ENCAP_RED,
  };

  #endif
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index d64855010948..430975b03597 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -36,9 +36,11 @@ static size_t seg6_lwt_headroom(struct 
seg6_iptunnel_encap *tuninfo)
      case SEG6_IPTUN_MODE_INLINE:
          break;
      case SEG6_IPTUN_MODE_ENCAP:
+    case SEG6_IPTUN_MODE_ENCAP_RED:
          head = sizeof(struct ipv6hdr);
          break;
      case SEG6_IPTUN_MODE_L2ENCAP:
+    case SEG6_IPTUN_MODE_L2ENCAP_RED:
          return 0;
      }

@@ -195,6 +197,81 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct 
ipv6_sr_hdr *osrh, int proto)
  }
  EXPORT_SYMBOL_GPL(seg6_do_srh_encap);

+/* encapsulate an IPv6 packet within an outer IPv6 header with reduced 
SRH */
+int seg6_do_srh_encap_red(struct sk_buff *skb, struct ipv6_sr_hdr 
*osrh, int proto)
+{
+    struct dst_entry *dst = skb_dst(skb);
+    struct net *net = dev_net(dst->dev);
+    struct ipv6hdr *hdr, *inner_hdr6;
+    struct iphdr *inner_hdr4;
+    struct ipv6_sr_hdr *isrh;
+    int hdrlen = 0, tot_len, err;
+    __be32 flowlabel = 0;
+
+    if (osrh->first_segment > 0)
+        hdrlen = (osrh->hdrlen - 1) << 3;
+
+    tot_len = hdrlen + sizeof(struct ipv6hdr);
+
+    err = skb_cow_head(skb, tot_len + skb->mac_len);
+    if (unlikely(err))
+        return err;
+
+    inner_hdr6 = ipv6_hdr(skb);
+    inner_hdr4 = ip_hdr(skb);
+    flowlabel = seg6_make_flowlabel(net, skb, inner_hdr6);
+
+    skb_push(skb, tot_len);
+    skb_reset_network_header(skb);
+    skb_mac_header_rebuild(skb);
+    hdr = ipv6_hdr(skb);
+
+    memset(skb->cb, 0, 48);
+    IP6CB(skb)->iif = skb->skb_iif;
+
+    if (skb->protocol == htons(ETH_P_IPV6)) {
+        ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr6)),
+                 flowlabel);
+        hdr->hop_limit = inner_hdr6->hop_limit;
+    } else if (skb->protocol == htons(ETH_P_IP)) {
+        ip6_flow_hdr(hdr, ip6_tclass(inner_hdr4->tos), flowlabel);
+        hdr->hop_limit = inner_hdr4->ttl;
+    }
+
+    skb->protocol = htons(ETH_P_IPV6);
+
+    hdr->daddr = osrh->segments[osrh->first_segment];
+    hdr->version = 6;
+
+    if (osrh->first_segment > 0) {
+        hdr->nexthdr = NEXTHDR_ROUTING;
+
+        isrh = (void *)hdr + sizeof(struct ipv6hdr);
+        memcpy(isrh, osrh, hdrlen);
+
+        isrh->nexthdr = proto;
+        isrh->first_segment--;
+        isrh->hdrlen -= 2;
+    } else {
+        hdr->nexthdr = proto;
+    }
+
+    set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
+
+#ifdef CONFIG_IPV6_SEG6_HMAC
+    if (osrh->first_segment > 0 && sr_has_hmac(isrh)) {
+        err = seg6_push_hmac(net, &hdr->saddr, isrh);
+        if (unlikely(err))
+            return err;
+    }
+#endif
+
+    skb_postpush_rcsum(skb, hdr, tot_len);
+
+    return 0;
+}
+EXPORT_SYMBOL_GPL(seg6_do_srh_encap_red);
+
  /* insert an SRH within an IPv6 packet, just after the IPv6 header */
  int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
  {
@@ -265,6 +342,7 @@ static int seg6_do_srh(struct sk_buff *skb)
              return err;
          break;
      case SEG6_IPTUN_MODE_ENCAP:
+    case SEG6_IPTUN_MODE_ENCAP_RED:
          err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
          if (err)
              return err;
@@ -276,7 +354,11 @@ static int seg6_do_srh(struct sk_buff *skb)
          else
              return -EINVAL;

-        err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+        if (tinfo->mode == SEG6_IPTUN_MODE_ENCAP)
+            err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+        else
+            err = seg6_do_srh_encap_red(skb, tinfo->srh, proto);
+
          if (err)
              return err;

@@ -285,6 +367,7 @@ static int seg6_do_srh(struct sk_buff *skb)
          skb->protocol = htons(ETH_P_IPV6);
          break;
      case SEG6_IPTUN_MODE_L2ENCAP:
+    case SEG6_IPTUN_MODE_L2ENCAP_RED:
          if (!skb_mac_header_was_set(skb))
              return -EINVAL;

@@ -294,7 +377,11 @@ static int seg6_do_srh(struct sk_buff *skb)
          skb_mac_header_rebuild(skb);
          skb_push(skb, skb->mac_len);

-        err = seg6_do_srh_encap(skb, tinfo->srh, IPPROTO_ETHERNET);
+        if (tinfo->mode == SEG6_IPTUN_MODE_L2ENCAP)
+            err = seg6_do_srh_encap(skb, tinfo->srh, IPPROTO_ETHERNET);
+        else
+            err = seg6_do_srh_encap_red(skb, tinfo->srh, IPPROTO_ETHERNET);
+
          if (err)
              return err;

@@ -514,6 +601,10 @@ static int seg6_build_state(struct net *net, struct 
nlattr *nla,
          break;
      case SEG6_IPTUN_MODE_L2ENCAP:
          break;
+    case SEG6_IPTUN_MODE_ENCAP_RED:
+        break;
+    case SEG6_IPTUN_MODE_L2ENCAP_RED:
+        break;
      default:
          return -EINVAL;
      }
-- 
2.20.1

