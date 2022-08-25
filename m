Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3435A12A5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242800AbiHYNrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiHYNrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:47:07 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918776BD53;
        Thu, 25 Aug 2022 06:47:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m3-20020a05600c3b0300b003a5e0557150so3079363wms.0;
        Thu, 25 Aug 2022 06:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=lZ9wOH+7wIjjJFPVh1Fs4Uxl5iE6jE2+n6FdjpAdOkM=;
        b=IkVc3C+SDjYsKBMZael/OHcoHjFUKyfFSKUrVKUEHpn7MHNGpQqgQTwRr8WGDoJQxm
         bNT3dUjdl/TW7oVP5f1K126OREo5rJgM2fLBt9iQ8em4IYJMVYVVq9ZTKcZHVUe45tdc
         QNphb8UPLfwnZayDDEgmDzzd+jv78H3BAdf7N4dHBaQyaTKMMOIU6aPfTQrVXBjN8DWq
         FLm8idoqUDBIYty+9nzAWt+CFeZII7ske+u7+wDb24xegCzzOgvH40kNP6ltrjw/PIj9
         WWKQzOH028GfCC7gHR/Dkk+HigHEBoN+SFEwFXgMQKNNS5LIvrnOJ/onSgwUtwLQNagA
         k/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=lZ9wOH+7wIjjJFPVh1Fs4Uxl5iE6jE2+n6FdjpAdOkM=;
        b=ONrJLMXBxYv9Ve9U9qsoF/+HMjfJBNTcn4oK7y4NqLvHukCC+VW/5g2n8/c1ujwnZT
         deA/wZ9dYbrFTBg50z4DWcMbX7GmjJbz8lPPHRrz6E5V4lKMl/WQShJFaumXt7ronOoq
         pVy/qxk1IOrd/utLbk246u6UIYCwtLrv8d6YNaYptcVNDhDoW/46d1jXeNwtepvikG8Y
         YdhHnYQDNyyL8j51YZasIcglmglUb0uImJDx1sC6C8I1As28N9wRHG0EyJetbSEnml74
         xUyOkheFqxmxTAxzFlu+BcjqgmuOH+e/1ALHUDvL3G8P065+g6nrJbqz3iJx8//9lm+f
         66wQ==
X-Gm-Message-State: ACgBeo2wZ4WisoPwa9y8uRkqgIhz60QeT66IwyNU9+VdNhqdnMa6VJOS
        U0foHLePyZHXZ9pEsF1kQhk=
X-Google-Smtp-Source: AA6agR6bx505URvWwMgpSdq+cfThVwoPYD7ynM7VSt8ua+yKGkGIgFjxAyROuVPc3bS0+ibbmpxmag==
X-Received: by 2002:a05:600c:4d15:b0:3a5:b3fe:75dd with SMTP id u21-20020a05600c4d1500b003a5b3fe75ddmr8630439wmp.116.1661435223851;
        Thu, 25 Aug 2022 06:47:03 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id i26-20020a1c541a000000b003a5de95b105sm5356049wmb.41.2022.08.25.06.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 06:47:03 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v2 3/3] xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode
Date:   Thu, 25 Aug 2022 16:46:36 +0300
Message-Id: <20220825134636.2101222-4-eyal.birger@gmail.com>
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

Allow specifying the xfrm interface if_id and link as part of a route
metadata using the lwtunnel infrastructure.

This allows for example using a single xfrm interface in collect_md
mode as the target of multiple routes each specifying a different if_id.

With the appropriate changes to iproute2, considering an xfrm device
ipsec1 in collect_md mode one can for example add a route specifying
an if_id like so:

ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1

In which case traffic routed to the device via this route would use
if_id in the xfrm interface policy lookup.

Or in the context of vrf, one can also specify the "link" property:

ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 dev eth15

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

----

v2:
 - move lwt_xfrm_info() helper to dst_metadata.h
 - add "link" property as suggested by Nicolas Dichtel
---
 include/net/dst_metadata.h    |  11 ++++
 include/uapi/linux/lwtunnel.h |  10 ++++
 net/core/lwtunnel.c           |   1 +
 net/xfrm/xfrm_interface.c     | 100 ++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index e4b059908cc7..57f75960fa28 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -60,13 +60,24 @@ skb_tunnel_info(const struct sk_buff *skb)
 	return NULL;
 }
 
+static inline struct xfrm_md_info *lwt_xfrm_info(struct lwtunnel_state *lwt)
+{
+	return (struct xfrm_md_info *)lwt->data;
+}
+
 static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_buff *skb)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	struct dst_entry *dst;
 
 	if (md_dst && md_dst->type == METADATA_XFRM)
 		return &md_dst->u.xfrm_info;
 
+	dst = skb_dst(skb);
+	if (dst && dst->lwtstate &&
+	    dst->lwtstate->type == LWTUNNEL_ENCAP_XFRM)
+		return lwt_xfrm_info(dst->lwtstate);
+
 	return NULL;
 }
 
diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index 2e206919125c..229655ef792f 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -15,6 +15,7 @@ enum lwtunnel_encap_types {
 	LWTUNNEL_ENCAP_SEG6_LOCAL,
 	LWTUNNEL_ENCAP_RPL,
 	LWTUNNEL_ENCAP_IOAM6,
+	LWTUNNEL_ENCAP_XFRM,
 	__LWTUNNEL_ENCAP_MAX,
 };
 
@@ -111,4 +112,13 @@ enum {
 
 #define LWT_BPF_MAX_HEADROOM 256
 
+enum {
+	LWT_XFRM_UNSPEC,
+	LWT_XFRM_IF_ID,
+	LWT_XFRM_LINK,
+	__LWT_XFRM_MAX,
+};
+
+#define LWT_XFRM_MAX (__LWT_XFRM_MAX - 1)
+
 #endif /* _UAPI_LWTUNNEL_H_ */
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 9ccd64e8a666..6fac2f0ef074 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -50,6 +50,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
 		return "IOAM6";
 	case LWTUNNEL_ENCAP_IP6:
 	case LWTUNNEL_ENCAP_IP:
+	case LWTUNNEL_ENCAP_XFRM:
 	case LWTUNNEL_ENCAP_NONE:
 	case __LWTUNNEL_ENCAP_MAX:
 		/* should not have got here */
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 389d8be12801..604de1ee3772 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -60,6 +60,103 @@ struct xfrmi_net {
 	struct xfrm_if __rcu *collect_md_xfrmi;
 };
 
+static const struct nla_policy xfrm_lwt_policy[LWT_XFRM_MAX + 1] = {
+	[LWT_XFRM_UNSPEC]	= { .type = NLA_REJECT },
+	[LWT_XFRM_IF_ID]	= { .type = NLA_U32 },
+	[LWT_XFRM_LINK]		= { .type = NLA_U32 },
+};
+
+static void xfrmi_destroy_state(struct lwtunnel_state *lwt)
+{
+}
+
+static int xfrmi_build_state(struct net *net, struct nlattr *nla,
+			     unsigned int family, const void *cfg,
+			     struct lwtunnel_state **ts,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[LWT_XFRM_MAX + 1];
+	struct lwtunnel_state *new_state;
+	struct xfrm_md_info *info;
+	int ret;
+
+	ret = nla_parse_nested(tb, LWT_XFRM_MAX, nla, xfrm_lwt_policy, extack);
+	if (ret < 0)
+		return ret;
+
+	if (!tb[LWT_XFRM_IF_ID])
+		return -EINVAL;
+
+	new_state = lwtunnel_state_alloc(sizeof(*info));
+	if (!new_state)
+		return -ENOMEM;
+
+	new_state->type = LWTUNNEL_ENCAP_XFRM;
+
+	info = lwt_xfrm_info(new_state);
+
+	info->if_id = nla_get_u32(tb[LWT_XFRM_IF_ID]);
+	if (!info->if_id) {
+		ret = -EINVAL;
+		goto errout;
+	}
+
+	if (tb[LWT_XFRM_LINK]) {
+		info->link = nla_get_u32(tb[LWT_XFRM_LINK]);
+		if (!info->link) {
+			ret = -EINVAL;
+			goto errout;
+		}
+	}
+
+	*ts = new_state;
+	return 0;
+
+errout:
+	xfrmi_destroy_state(new_state);
+	kfree(new_state);
+	return ret;
+}
+
+static int xfrmi_fill_encap_info(struct sk_buff *skb,
+				 struct lwtunnel_state *lwt)
+{
+	struct xfrm_md_info *info = lwt_xfrm_info(lwt);
+
+	if (nla_put_u32(skb, LWT_XFRM_IF_ID, info->if_id))
+		return -EMSGSIZE;
+
+	if (info->link) {
+		if (nla_put_u32(skb, LWT_XFRM_LINK, info->link))
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
+static int xfrmi_encap_nlsize(struct lwtunnel_state *lwtstate)
+{
+	return nla_total_size(4) + /* LWT_XFRM_IF_ID */
+		nla_total_size(4); /* LWT_XFRM_LINK */
+}
+
+static int xfrmi_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
+{
+	struct xfrm_md_info *a_info = lwt_xfrm_info(a);
+	struct xfrm_md_info *b_info = lwt_xfrm_info(b);
+
+	return memcmp(a_info, b_info, sizeof(*a_info));
+}
+
+static const struct lwtunnel_encap_ops xfrmi_encap_ops = {
+	.build_state	= xfrmi_build_state,
+	.destroy_state	= xfrmi_destroy_state,
+	.fill_encap	= xfrmi_fill_encap_info,
+	.get_encap_size = xfrmi_encap_nlsize,
+	.cmp_encap	= xfrmi_encap_cmp,
+	.owner		= THIS_MODULE,
+};
+
 #define for_each_xfrmi_rcu(start, xi) \
 	for (xi = rcu_dereference(start); xi; xi = rcu_dereference(xi->next))
 
@@ -1081,6 +1178,8 @@ static int __init xfrmi_init(void)
 	if (err < 0)
 		goto rtnl_link_failed;
 
+	lwtunnel_encap_add_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
+
 	xfrm_if_register_cb(&xfrm_if_cb);
 
 	return err;
@@ -1099,6 +1198,7 @@ static int __init xfrmi_init(void)
 static void __exit xfrmi_fini(void)
 {
 	xfrm_if_unregister_cb();
+	lwtunnel_encap_del_ops(&xfrmi_encap_ops, LWTUNNEL_ENCAP_XFRM);
 	rtnl_link_unregister(&xfrmi_link_ops);
 	xfrmi4_fini();
 	xfrmi6_fini();
-- 
2.34.1

