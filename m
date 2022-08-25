Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A905A12A8
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbiHYNrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242702AbiHYNrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:47:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301D3B5E61;
        Thu, 25 Aug 2022 06:47:00 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso2739369wmc.0;
        Thu, 25 Aug 2022 06:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=X9MHTgsIwaJa51FzMjWGj/DuVB/5l++H+9kOvAZB8+o=;
        b=oU0kHXJV3/cnE8C9JqciZkG71pKyFhfJyiOo87aiSAqGLvUSfsRz8sZhoS07tM6gdo
         kZ5rG4CYdObKS6BxPG8LxYCFiiFL+Jsn4vkdrhz8tJD6aQ6berrIMA2UT6NhqIPoQcuF
         OpCdVW/6Yvg5rLunW+kBBp6bNr0/NWf6K9II83clVE95i3VQ4SY8xxfJA8PPqiFQO11f
         qBV4ZZ0SWAuHyXVyLVT80nKz8PMQ8ETLGrnKROphmIiEfXfJ04H04ZEkiF83Tz6UL58u
         BUjgsVlSowC8oOVNBaiHb6PSiEBBoMZYIpTAU+iQ7pUtPM8XRBV1vsjdCz/B2EN0oG8+
         dH5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=X9MHTgsIwaJa51FzMjWGj/DuVB/5l++H+9kOvAZB8+o=;
        b=kGWiLX7MaUA8ExSyFwzzhSEiX9cFvh/WChew9o6XOrSDy7Bu58mshWPczgPRRmw+F2
         WAUgRCn3MHkDqqSr48/wPO6X6CNfW+Z1et+oiekKtlQQpBzayumeIoddt0eyaOSOIKkk
         kzPH7/IVVrmAzjkzXor82qSFVT9VS+Cxr3N2AEK+Gf6vJB9mnlTlOonNJmYIfDJunTNf
         aXnu4ydflbjTGnOBR691uwfW5G9eqoHVc4YOpwDk0tGk6vX7VbtbIZv7mr3t9GH0+WPc
         6CkCjkl49PdF09LMB23xDEQqiRSnaDeiLT8hryP3lW3jaWqgErkRmkk5k0b1e5Ug+FNO
         TMPA==
X-Gm-Message-State: ACgBeo24wQQQ9izjdTtiZKnj86nu4CT/7ZPazhXDc6+K1HlJmeazCMMv
        zsUelN+3NlPd3rR72F3I7oKv1k0qv/o9qg==
X-Google-Smtp-Source: AA6agR6MBm5aJRuERdGU0ncU22MuiBMx03uPYqV/WUcfRPLo8VimOpR6lA7pOQmGtOK4B5dew+EwYw==
X-Received: by 2002:a7b:ce05:0:b0:3a5:c069:25b3 with SMTP id m5-20020a7bce05000000b003a5c06925b3mr2433770wmc.87.1661435218634;
        Thu, 25 Aug 2022 06:46:58 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id i26-20020a1c541a000000b003a5de95b105sm5356049wmb.41.2022.08.25.06.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 06:46:58 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v2 1/3] net: allow storing xfrm interface metadata in metadata_dst
Date:   Thu, 25 Aug 2022 16:46:34 +0300
Message-Id: <20220825134636.2101222-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825134636.2101222-1-eyal.birger@gmail.com>
References: <20220825134636.2101222-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRM interfaces provide the association of various XFRM transformations
to a netdevice using an 'if_id' identifier common to both the XFRM data
structures (polcies, states) and the interface. The if_id is configured by
the controlling entity (usually the IKE daemon) and can be used by the
administrator to define logical relations between different connections.

For example, different connections can share the if_id identifier so
that they pass through the same interface, . However, currently it is
not possible for connections using a different if_id to use the same
interface while retaining the logical separation between them, without
using additional criteria such as skb marks or different traffic
selectors.

When having a large number of connections, it is useful to have a the
logical separation offered by the if_id identifier but use a single
network interface. Similar to the way collect_md mode is used in IP
tunnels.

This patch attempts to enable different configuration mechanisms - such
as ebpf programs, LWT encapsulations, and TC - to attach metadata
to skbs which would carry the if_id. This way a single xfrm interface in
collect_md mode can demux traffic based on this configuration on tx and
provide this metadata on rx.

The XFRM metadata is somewhat similar to ip tunnel metadata in that it
has an "id", and shares similar configuration entities (bpf, tc, ...),
however, it does not necessarily represent an IP tunnel or use other
ip tunnel information, and also has an optional "link" property which
can be used for affecting underlying routing decisions.

Additional xfrm related criteria may also be added in the future.

Therefore, a new metadata type is introduced, to be used in subsequent
patches in the xfrm interface and configuration entities.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

----

v2: add "link" property as suggested by Nicolas Dichtel
---
 include/net/dst_metadata.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index adab27ba1ecb..e4b059908cc7 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -9,6 +9,7 @@
 enum metadata_type {
 	METADATA_IP_TUNNEL,
 	METADATA_HW_PORT_MUX,
+	METADATA_XFRM,
 };
 
 struct hw_port_info {
@@ -16,12 +17,18 @@ struct hw_port_info {
 	u32 port_id;
 };
 
+struct xfrm_md_info {
+	u32 if_id;
+	int link;
+};
+
 struct metadata_dst {
 	struct dst_entry		dst;
 	enum metadata_type		type;
 	union {
 		struct ip_tunnel_info	tun_info;
 		struct hw_port_info	port_info;
+		struct xfrm_md_info	xfrm_info;
 	} u;
 };
 
@@ -53,6 +60,16 @@ skb_tunnel_info(const struct sk_buff *skb)
 	return NULL;
 }
 
+static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_buff *skb)
+{
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+
+	if (md_dst && md_dst->type == METADATA_XFRM)
+		return &md_dst->u.xfrm_info;
+
+	return NULL;
+}
+
 static inline bool skb_valid_dst(const struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -82,6 +99,9 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);
+	case METADATA_XFRM:
+		return memcmp(&a->u.xfrm_info, &b->u.xfrm_info,
+			      sizeof(a->u.xfrm_info));
 	default:
 		return 1;
 	}
-- 
2.34.1

