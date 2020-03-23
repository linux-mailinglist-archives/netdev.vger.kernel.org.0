Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3B018FFCA
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgCWUtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:49:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:26992 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgCWUs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:48:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584996536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DJKRkKKAITBVz5prbm+LFb3Tia3qNNsVmORPnwYKgHc=;
        b=cTcdhcjVTuOgEQmIcxOkmqk3TuKXdexO25mGrCYRfhxC+59fE1+2eKxS5Id2BE+j8F/Cem
        yOpMgqO5623R5WhcW0in1ajN7i+5UxyugGcQ3ejXV8arfleVk9eNrvJBqhu/zrfm8aJRTP
        v6CCaMPb8RPVoOlbWc1MsXdmqqzrvfc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-uqkii7hYOSm1MpbbUM6f9A-1; Mon, 23 Mar 2020 16:48:55 -0400
X-MC-Unique: uqkii7hYOSm1MpbbUM6f9A-1
Received: by mail-wm1-f71.google.com with SMTP id f185so404717wmf.8
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 13:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DJKRkKKAITBVz5prbm+LFb3Tia3qNNsVmORPnwYKgHc=;
        b=kEz5+E7Msc+stlYR5as7yJaAADUGzHFuWhkiIbGI9li36E+QXjMnwODncP//nEKVTY
         YwU/d4bpS4y7x3VmmyrdwLs9hKYk2QL4VBIuPgPKotpJB1QImkCptaBN4DyIbE0NUhoi
         OBgY69RnQSlIvTcGENFj/+AgGQN/0sfTZuMb4NlA2ywNbG4A2BGAecHdinzPyClJmva2
         oTy3COQ1qZS8GixzG6Y5Dp6rB/YUuLUBTTeS4Gj0KzXrKuvIJCzCUewNxF4G7odP0Xxd
         H/aJScX/5PmzQa/TI/JC7tyN8DB0h17zFnhLcVVuUd+4+XAMYOSxXk6ZDJc59JGchDey
         HmtA==
X-Gm-Message-State: ANhLgQ2D3JB8WubUshlD2vdlmlznsXeBys2uL595M9d7AhZyrrrswOdD
        Ch24FRqilNzOvy+Y5VvBc64VhJXUXnNtu2Nf8d5/Q8MQ5uuKZpGcaC3RpCLrwQC/Yx4tvH2/TvE
        htXMiF6tYrIanyl0q
X-Received: by 2002:a5d:6888:: with SMTP id h8mr22562630wru.159.1584996533899;
        Mon, 23 Mar 2020 13:48:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuG/Q37U+StoLzqAj/ipfdfariRPDLn8W+OjZaUIN1QKNvVBupiGuFyNmSZcmX982nwxtxaQg==
X-Received: by 2002:a5d:6888:: with SMTP id h8mr22562618wru.159.1584996533689;
        Mon, 23 Mar 2020 13:48:53 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id s2sm7060160wru.68.2020.03.23.13.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 13:48:53 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:48:51 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next 3/4] cls_flower: Add extack support for src and dst
 port range options
Message-ID: <6bc15ab727d856ac966a3bf6fa1345ce031eaaae.1584995986.git.gnault@redhat.com>
References: <cover.1584995986.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1584995986.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass extack down to fl_set_key_port_range() and set message on error.

Both the min and max ports would qualify as invalid attributes here.
Report the min one as invalid, as it's probably what makes the most
sense from a user point of view.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/sched/cls_flower.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 544cc7b490a3..5811dd971ee5 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -738,7 +738,8 @@ static void fl_set_key_val(struct nlattr **tb,
 }
 
 static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
-				 struct fl_flow_key *mask)
+				 struct fl_flow_key *mask,
+				 struct netlink_ext_ack *extack)
 {
 	fl_set_key_val(tb, &key->tp_range.tp_min.dst,
 		       TCA_FLOWER_KEY_PORT_DST_MIN, &mask->tp_range.tp_min.dst,
@@ -753,13 +754,22 @@ static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 		       TCA_FLOWER_KEY_PORT_SRC_MAX, &mask->tp_range.tp_max.src,
 		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.src));
 
-	if ((mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
-	     htons(key->tp_range.tp_max.dst) <=
-		 htons(key->tp_range.tp_min.dst)) ||
-	    (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
-	     htons(key->tp_range.tp_max.src) <=
-		 htons(key->tp_range.tp_min.src)))
+	if (mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
+	    htons(key->tp_range.tp_max.dst) <=
+	    htons(key->tp_range.tp_min.dst)) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_PORT_DST_MIN],
+				    "Invalid destination port range (min must be strictly smaller than max)");
 		return -EINVAL;
+	}
+	if (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
+	    htons(key->tp_range.tp_max.src) <=
+	    htons(key->tp_range.tp_min.src)) {
+		NL_SET_ERR_MSG_ATTR(extack,
+				    tb[TCA_FLOWER_KEY_PORT_SRC_MIN],
+				    "Invalid source port range (min must be strictly smaller than max)");
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1402,7 +1412,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 	if (key->basic.ip_proto == IPPROTO_TCP ||
 	    key->basic.ip_proto == IPPROTO_UDP ||
 	    key->basic.ip_proto == IPPROTO_SCTP) {
-		ret = fl_set_key_port_range(tb, key, mask);
+		ret = fl_set_key_port_range(tb, key, mask, extack);
 		if (ret)
 			return ret;
 	}
-- 
2.21.1

