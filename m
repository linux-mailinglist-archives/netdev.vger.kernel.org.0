Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2803C281E96
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJBWoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:44:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgJBWoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:44:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601678676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7zWKGhR/q69FafmsZaB4IylYsAjMnC/LKuK1PXoJhVw=;
        b=LlXaE3Wvd5tnubCGAygDeGV3tVOkRhGEmNx5ASh0GclE16YHLUNvnMFtECm4l5b95mBG1f
        30kqjiBeynwbfv0zoSBX43U1+bOqjCKN3oHC+JCeN1dn2WpBjYVdgwsjJqDyNAilzcGzCq
        srO7eKU+Kh/uOPMhsSgHB3zuA+KmyUk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-IcVHNv3wPV6Ju-pTKyER9A-1; Fri, 02 Oct 2020 18:44:35 -0400
X-MC-Unique: IcVHNv3wPV6Ju-pTKyER9A-1
Received: by mail-wr1-f72.google.com with SMTP id a12so1092165wrg.13
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:44:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7zWKGhR/q69FafmsZaB4IylYsAjMnC/LKuK1PXoJhVw=;
        b=P/EjEBWOfaZvqwbTqZyxkt9QwBDvpo3AMDWEuN9TMw13fGZozPH3d3Zsh4gQ25gW8h
         LYZmC6mUVDtddY9sqPQxhMJNEVf5Ief5urhOGFYHkqkV3dHc+iej+G86bjMNrEEEd/7e
         Ob0UmU0KxXNAHevoXWrfEJnOp5pzsVk3VGDbobJef1D7b8VUi38dLPuOjqGUxCU/LmTC
         iXpKuzE6bXbUMFTGXAybgzcN2gp4UyRFcwvQDUMi4QElSV1Kp2mlTY0VrPt9jf6JSbxO
         1k9xBcYeg/eWLCxzUmjZhEYHB2t+gGZG38DvLJVvuqK59iGKqFSNLGLj5M9uJp5Dmo1J
         JnIw==
X-Gm-Message-State: AOAM530fGlSuclD696m2q3eNT3zQK3Ed+lzoOAGM9VloRSiL9K/z5mTO
        GOLtoLPiYfJsswxlXSiyW+I2YuwLSNgDB2I2d1fhnIGpxkfw906g7Zrlh9cRX0jwkzSlu7vvE0f
        pSdYVIHTVHfH4E3be
X-Received: by 2002:a1c:4c17:: with SMTP id z23mr4871588wmf.40.1601678674117;
        Fri, 02 Oct 2020 15:44:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyukUyy1OEiGzQnlndv6TPjgOVqdVvJdTXCaF1dhjrSRbkVAL0Az0QQfeZ232VYtGk1aTrG7g==
X-Received: by 2002:a1c:4c17:: with SMTP id z23mr4871574wmf.40.1601678673917;
        Fri, 02 Oct 2020 15:44:33 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id l10sm3055635wru.59.2020.10.02.15.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 15:44:33 -0700 (PDT)
Date:   Sat, 3 Oct 2020 00:44:31 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Benc <jbenc@redhat.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 2/2] net/sched: act_mpls: Add action to push MPLS
 LSE before Ethernet header
Message-ID: <8d62ce3ad342d3e6629a3ebbec928b9d1a205631.1601673174.git.gnault@redhat.com>
References: <cover.1601673174.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1601673174.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the MAC_PUSH action which pushes an MPLS LSE before the mac
header (instead of between the mac and the network headers as the
plain PUSH action does).

The only special case is when the skb has an offloaded VLAN. In that
case, it has to be inlined before pushing the MPLS header.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/uapi/linux/tc_act/tc_mpls.h |  1 +
 net/sched/act_mpls.c                | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/tc_act/tc_mpls.h b/include/uapi/linux/tc_act/tc_mpls.h
index 9360e95273c7..9e4e8f52a779 100644
--- a/include/uapi/linux/tc_act/tc_mpls.h
+++ b/include/uapi/linux/tc_act/tc_mpls.h
@@ -10,6 +10,7 @@
 #define TCA_MPLS_ACT_PUSH	2
 #define TCA_MPLS_ACT_MODIFY	3
 #define TCA_MPLS_ACT_DEC_TTL	4
+#define TCA_MPLS_ACT_MAC_PUSH	5
 
 struct tc_mpls {
 	tc_gen;		/* generic TC action fields. */
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 8118e2640979..bb6b715636db 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -87,6 +87,23 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 				  skb->dev && skb->dev->type == ARPHRD_ETHER))
 			goto drop;
 		break;
+	case TCA_MPLS_ACT_MAC_PUSH:
+		if (skb_vlan_tag_present(skb)) {
+			if (__vlan_insert_inner_tag(skb, skb->vlan_proto,
+						    skb_vlan_tag_get(skb),
+						    ETH_HLEN) < 0)
+				goto drop;
+
+			skb->protocol = skb->vlan_proto;
+			__vlan_hwaccel_clear_tag(skb);
+		}
+
+		new_lse = tcf_mpls_get_lse(NULL, p, mac_len ||
+					   !eth_p_mpls(skb->protocol));
+
+		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, 0, false))
+			goto drop;
+		break;
 	case TCA_MPLS_ACT_MODIFY:
 		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
 		if (skb_mpls_update_lse(skb, new_lse))
@@ -188,6 +205,7 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 		}
 		break;
 	case TCA_MPLS_ACT_PUSH:
+	case TCA_MPLS_ACT_MAC_PUSH:
 		if (!tb[TCA_MPLS_LABEL]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label is required for MPLS push");
 			return -EINVAL;
-- 
2.21.3

