Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C496DBC44
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441804AbfJRFAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:00:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42614 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfJRFAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:00:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id g9so932987plj.9;
        Thu, 17 Oct 2019 22:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HXzFJI/J/iuS7umfGU0E3WbfBmf272p7UrFI2fd2lao=;
        b=ukP+M1s/Rb3wueS//9V9ply43AdKgY+mOWY20e2SOPnBewg9HAFb8C6FEGLpjcvzWM
         d8McqNTWm616/H8B8OsOjGibsxGBRdha0d1N36woottSd+1mMMh/Qhp47F5O/tOSzFlx
         qmlQHZFMntlbIb3+7/8gTvrJ5/meJsqcSt0gySDSen+FExra8Llez5VhGaMPIL9gv8/G
         pAUJS7YpOX0ouw1ItD0Vxle6rE/yGzvac4REeuHTZS+roDqM+Wg1hD/FtnyTXygZqeS4
         3KbV5JNfI7z015J1wvmJkObZqH6EH3xV0DL3ir8AovHs/HTOo64HCBNs9nW3DYliz5Xc
         FMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HXzFJI/J/iuS7umfGU0E3WbfBmf272p7UrFI2fd2lao=;
        b=fffIbq7HefmqO07G0uVr/8tfso7iF484VWCb7JyUNXu3OCQEMSgeLQf6QpXj7lSOZw
         cx+Qc6Iv12WxiAdvj11CrrscXD1xe1/7tnAvSQ10KLPuk2Kmgitms4ShW428d1x9Zep0
         6qvreLWg2Fr2sS+yqgLs+N9y1CIVmVgb0f21XLhZSgqJFxcBECYL0lRwjPVscVbhR16A
         KvF0LwmMBFr+U5fGNnvUMeHyXhZ3Y0j/Kt4lbt3UdoAaSTTyMcdSmLPOF5+mqCKT++tB
         HJ2+0wEWgkBT4uWflQpEDRobG2gBVjhMqdWkRJs2a117bbmNidzw6+bR9phB9LvBmZRC
         JX/Q==
X-Gm-Message-State: APjAAAWRlOHSFntQKLDfRpXB2Blt80sCaJvzGM3huAYQ4kUXpQitVgwK
        6M6jUFXOKDIkoIL78TEV4vk/nezj
X-Google-Smtp-Source: APXvYqwB+B4q0ZvtPAxyqi037lwMrxXdZ7UlDoM3w/+8/3BXXUcZumuGlG6GQ1wCkaO5d9I9rYP0YQ==
X-Received: by 2002:a17:902:ab82:: with SMTP id f2mr7817238plr.39.1571371760774;
        Thu, 17 Oct 2019 21:09:20 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:09:20 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 12/15] xdp_flow: Implement vlan_push action
Date:   Fri, 18 Oct 2019 13:07:45 +0900
Message-Id: <20191018040748.30593-13-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another example action.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/xdp_flow_kern_bpf.c | 23 +++++++++++++++++++++--
 net/xdp_flow/xdp_flow_kern_mod.c |  5 +++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/net/xdp_flow/xdp_flow_kern_bpf.c b/net/xdp_flow/xdp_flow_kern_bpf.c
index 381d67e..7930349 100644
--- a/net/xdp_flow/xdp_flow_kern_bpf.c
+++ b/net/xdp_flow/xdp_flow_kern_bpf.c
@@ -90,10 +90,29 @@ static inline int action_redirect(struct xdp_flow_action *action)
 static inline int action_vlan_push(struct xdp_md *ctx,
 				   struct xdp_flow_action *action)
 {
+	struct vlan_ethhdr *vehdr;
+	void *data, *data_end;
+	__be16 proto, tci;
+
 	account_action(XDP_FLOW_ACTION_VLAN_PUSH);
 
-	// TODO: implement this
-	return XDP_ABORTED;
+	proto = action->vlan.proto;
+	tci = action->vlan.tci;
+
+	if (bpf_xdp_adjust_head(ctx, -VLAN_HLEN))
+		return XDP_DROP;
+
+	data_end = (void *)(long)ctx->data_end;
+	data = (void *)(long)ctx->data;
+	if (data + VLAN_ETH_HLEN > data_end)
+		return XDP_DROP;
+
+	__builtin_memmove(data, data + VLAN_HLEN, ETH_ALEN * 2);
+	vehdr = data;
+	vehdr->h_vlan_proto = proto;
+	vehdr->h_vlan_TCI = tci;
+
+	return _XDP_CONTINUE;
 }
 
 static inline int action_vlan_pop(struct xdp_md *ctx,
diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
index 2581b81..7ce1733 100644
--- a/net/xdp_flow/xdp_flow_kern_mod.c
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -84,6 +84,11 @@ static int xdp_flow_parse_actions(struct xdp_flow_actions *actions,
 			action->ifindex = act->dev->ifindex;
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
+			action->id = XDP_FLOW_ACTION_VLAN_PUSH;
+			action->vlan.tci = act->vlan.vid |
+					   (act->vlan.prio << VLAN_PRIO_SHIFT);
+			action->vlan.proto = act->vlan.proto;
+			break;
 		case FLOW_ACTION_VLAN_POP:
 		case FLOW_ACTION_VLAN_MANGLE:
 		case FLOW_ACTION_MANGLE:
-- 
1.8.3.1

