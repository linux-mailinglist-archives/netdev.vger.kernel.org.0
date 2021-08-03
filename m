Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A102E3DF109
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhHCPEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbhHCPEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:04:14 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F244C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 08:04:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id b13so14793357wrs.3
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 08:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K3/JMg8FEzWcKtCaV5PSGvcVeIOGw/bKDM+HHJV/2hg=;
        b=cP045yghZHgLKxtRgIaQySkE+hD3mRHFkEIMjAyMLBWlWbNWl0fdykUmFB1qG+OVQo
         Y6yIlbRHl0L0VHxDFl3JBv6ewCxACZJTrmuEqWczS/I8z7XmFy0I7+pEtgGcEVGpZDK7
         f/egYzXkUdejlz931KY2QdBu9Etw48cSQkxTLqqgS12TT0R6Y0nWl/II3/NeLoEWZEMv
         L2xnvwXJZDUER6LsPQMNkdqZqlXjoaCP12K97TXv1NUi2gATNar8k/94kL32HqvGdxd4
         WAl/bxBqwjFVeRbl9DssVKDsuuuHJwuAv2TQKVo5Hffpv5WfFaZpVIE0P0Puw6MnY2Wm
         Z2Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K3/JMg8FEzWcKtCaV5PSGvcVeIOGw/bKDM+HHJV/2hg=;
        b=hATvZ14inJQXFVdJZ1ZUJByShkt8z7QR/U85pcO9ncr8SKNWuTyN3lz+hKBECbVfYo
         mkSxRE3Uya4Ymj9y6W+5TJ4+0RsQznJyHUJU9ZA9UhLyyFJdff3gBrvf1f4881db3LqC
         9toRbhLzpsM4xtOsXISMugD76znRC7js1RMtaUoBS2frZa1t8e5PrlSJjsg46bcsqnCX
         9phWvpOPFbAmC3qA/psf5uS9ZStgcoQeHjcFP7AiphKunRW4Lyaoiw+oxlxDDL+hNMyZ
         8klCIFcoXismExnZuRwzE7D34hDL/tabQMifa0RNBi27LQtEs7KOLNl9tMePRc8fK9yF
         ggZg==
X-Gm-Message-State: AOAM5331RAJJe5cIjMhL2q6SbW0YC9RHu/wD25opJd1ult+sh9PP02bB
        Il+4dwyYuhG3e/r7ft/FCFI=
X-Google-Smtp-Source: ABdhPJw1ZIVijQcctnMLos+87V3LSqmVWYSuo4fOuZ/ngDMleRs9TFH1Ki5m++tZntieyb53WYu81Q==
X-Received: by 2002:a5d:6d82:: with SMTP id l2mr22078828wrs.225.1628003042145;
        Tue, 03 Aug 2021 08:04:02 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.199.45])
        by smtp.gmail.com with ESMTPSA id d15sm14606834wrn.28.2021.08.03.08.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 08:04:01 -0700 (PDT)
Subject: Re: [RFC net-next] ipv6: Attempt to improve options code parsing
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, eric.dumazet@gmail.com, tom@herbertland.com
References: <20210802205133.24071-1-justin.iurman@uliege.be>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ce46ace3-11b9-6a75-b665-cee79252550e@gmail.com>
Date:   Tue, 3 Aug 2021 17:03:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802205133.24071-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/21 10:51 PM, Justin Iurman wrote:
> As per Eric's comment on a previous patchset that was adding a new HopbyHop
> option, i.e. why should a new option appear before or after existing ones in the
> list, here is an attempt to suppress such competition. It also improves the
> efficiency and fasten the process of matching a Hbh or Dst option, which is
> probably something we want regarding the list of new options that could quickly
> grow in the future.
> 
> Basically, the two "lists" of options (Hbh and Dst) are replaced by two arrays.
> Each array has a size of 256 (for each code point). Each code point points to a
> function to process its specific option.
> 
> Thoughts?
> 
Hi Justin

I think this still suffers from indirect call costs (CONFIG_RETPOLINE=y),
and eventually use more dcache.

Since we only deal with two sets/arrays, I would simply get rid of them
and inline the code using two switch() clauses.

I cooked the following patch instead:


 net/ipv6/exthdrs.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
 1 file changed, 46 insertions(+), 56 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index d897faa4e9e63831b9b4f0ad0e59bf7032b2bd96..5acdc62bb5419b81cac46c935d7436f490dc3e74 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -55,19 +55,6 @@
 
 #include <linux/uaccess.h>
 
-/*
- *     Parsing tlv encoded headers.
- *
- *     Parsing function "func" returns true, if parsing succeed
- *     and false, if it failed.
- *     It MUST NOT touch skb->h.
- */
-
-struct tlvtype_proc {
-       int     type;
-       bool    (*func)(struct sk_buff *skb, int offset);
-};
-
 /*********************
   Generic functions
  *********************/
@@ -112,9 +99,17 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
        return false;
 }
 
+static bool ipv6_hop_ra(struct sk_buff *skb, int optoff);
+static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff);
+static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff);
+static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff);
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+static bool ipv6_dest_hao(struct sk_buff *skb, int optoff);
+#endif
+
 /* Parse tlv encoded option header (hop-by-hop or destination) */
 
-static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
+static bool ip6_parse_tlv(bool hopbyhop,
                          struct sk_buff *skb,
                          int max_count)
 {
@@ -176,20 +171,45 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
                        if (tlv_count > max_count)
                                goto bad;
 
-                       for (curr = procs; curr->type >= 0; curr++) {
-                               if (curr->type == nh[off]) {
-                                       /* type specific length/alignment
-                                          checks will be performed in the
-                                          func(). */
-                                       if (curr->func(skb, off) == false)
+                       if (hopbyhop) {
+                               switch (nh[off]) {
+                               case IPV6_TLV_ROUTERALERT:
+                                       if (!ipv6_hop_ra(skb, off))
+                                               return false;
+                                       break;
+                               case IPV6_TLV_IOAM:
+                                       if (!ipv6_hop_ioam(skb, off))
+                                               return false;
+                                       break;
+                               case IPV6_TLV_JUMBO:
+                                       if (!ipv6_hop_jumbo(skb, off))
+                                               return false;
+                                       break;
+                               case IPV6_TLV_CALIPSO:
+                                       if (!ipv6_hop_calipso(skb, off))
+                                               return false;
+                                       break;
+                               default:
+                                       if (!ip6_tlvopt_unknown(skb, off,
+                                                               disallow_unknowns))
+                                               return false;
+                                       break;
+                               }
+                       } else {
+                               switch (nh[off]) {
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+                               case IPV6_TLV_HAO:
+                                       if (!ipv6_dest_hao(skb, off))
+                                               return false;
+                                       break;
+#endif
+                               default:
+                                       if (!ip6_tlvopt_unknown(skb, off,
+                                                               disallow_unknowns))
                                                return false;
                                        break;
                                }
                        }
-                       if (curr->type < 0 &&
-                           !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
-                               return false;
-
                        padlen = 0;
                }
                off += optlen;
@@ -267,16 +287,6 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
 }
 #endif
 
-static const struct tlvtype_proc tlvprocdestopt_lst[] = {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-       {
-               .type   = IPV6_TLV_HAO,
-               .func   = ipv6_dest_hao,
-       },
-#endif
-       {-1,                    NULL}
-};
-
 static int ipv6_destopt_rcv(struct sk_buff *skb)
 {
        struct inet6_dev *idev = __in6_dev_get(skb->dev);
@@ -307,7 +317,7 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
        dstbuf = opt->dst1;
 #endif
 
-       if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
+       if (ip6_parse_tlv(false, skb,
                          net->ipv6.sysctl.max_dst_opts_cnt)) {
                skb->transport_header += extlen;
                opt = IP6CB(skb);
@@ -1051,26 +1061,6 @@ static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
        return false;
 }
 
-static const struct tlvtype_proc tlvprochopopt_lst[] = {
-       {
-               .type   = IPV6_TLV_ROUTERALERT,
-               .func   = ipv6_hop_ra,
-       },
-       {
-               .type   = IPV6_TLV_IOAM,
-               .func   = ipv6_hop_ioam,
-       },
-       {
-               .type   = IPV6_TLV_JUMBO,
-               .func   = ipv6_hop_jumbo,
-       },
-       {
-               .type   = IPV6_TLV_CALIPSO,
-               .func   = ipv6_hop_calipso,
-       },
-       { -1, }
-};
-
 int ipv6_parse_hopopts(struct sk_buff *skb)
 {
        struct inet6_skb_parm *opt = IP6CB(skb);
@@ -1096,7 +1086,7 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
                goto fail_and_free;
 
        opt->flags |= IP6SKB_HOPBYHOP;
-       if (ip6_parse_tlv(tlvprochopopt_lst, skb,
+       if (ip6_parse_tlv(true, skb,
                          net->ipv6.sysctl.max_hbh_opts_cnt)) {
                skb->transport_header += extlen;
                opt = IP6CB(skb);


