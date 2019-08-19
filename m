Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B924F925D8
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfHSOEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:04:06 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34464 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfHSOEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:04:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id d3so1026877plr.1;
        Mon, 19 Aug 2019 07:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ps39WlYvmdpvuYvHQVHohCHXUeQ1Cte8oiy7konFYFA=;
        b=rLUCyVzSdDWGS6fh7m3KOtsKXZew61vtd9PbRIRRP9lCYRMUZOa1jpNGeqNzqQFA+k
         cP1/Crv0DJMr5LWXKGkeY6GryYtDdJPtftbdsUfv3/e97hMDCHdRUoOIFAWzLdI4nonD
         CRPX+i9SAecBwUQFnBJpfwO707bkUnqzCSvP8jTniEV9JDesAZGauYbK9xD7LTNbQ+ps
         pB3hMV7Hcw5fHX5I7bCMyaNkv7oEEaciUz4PnLpFpJsN8601SBWyui1JZSi7O8GKI1Ir
         WfwMqun+RHxYpYn7Xe1M/f0z3ko0HrpqYQrdJsSoCGQZ1JaCTljnAUZLegsszmKza6/y
         daEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ps39WlYvmdpvuYvHQVHohCHXUeQ1Cte8oiy7konFYFA=;
        b=s5CbrSrqoZUb+yIO6i0y0xPOV9CEHPehE7lkQcQwhf/kgadb0jlBlR26XD7KKGnhFz
         dhHC1ejzNuk5XdLDA6L8KCWyzQSk40+VX1zGIznzFXh4uhw+i8e+nplAKR4oUTFq5xxe
         77l+zdJSLZ7DBNh6MDRbqgTcS2oiQLBGRg/VvbB1vds6uO2EJGzWxvZD5Owwu/giEzLB
         7EOyD17Dadm0nUVcKCPTLUTNsR18vUI2wsiTY8X9CkwixDm3/YLANCzs65J6EUWm0Fdg
         xxGDpJ7Y5L9HhhUG/T9NWqwaSsWooQMzIzyCCI1YpKkzkF9If1QvobunMbxcT2DEt5KL
         5qCA==
X-Gm-Message-State: APjAAAW+RslTIIAV56kXrEHZAi+xkTZUOjFzB6Gs28pfdtpbZDRbGt0F
        PBOinsh8U2BiOgxqa/AryBzo7uGcIhk=
X-Google-Smtp-Source: APXvYqwbIfVUSaZRElaoHz7wNk0I3Q4kxUIt/nRwdyd5Sh2rR99cgSMmNGbReha1gDZAX8FnSyc2Wg==
X-Received: by 2002:a17:902:b702:: with SMTP id d2mr23380367pls.259.1566223445660;
        Mon, 19 Aug 2019 07:04:05 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s6sm15588524pfs.122.2019.08.19.07.04.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:04:05 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 8/8] sctp: remove net sctp.x_enable working as a global switch
Date:   Mon, 19 Aug 2019 22:02:50 +0800
Message-Id: <37fe4fef4061a07a201684eef6377c9a2d5641e4.1566223325.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b45828d4f886e9d1e92a8b68c1932af9ff80b562.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
 <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
 <db032735abcb20ea14637fa610b9f95fa2710abb.1566223325.git.lucien.xin@gmail.com>
 <a2e37d8eb5b502e747eca1951e21c3d249bacf06.1566223325.git.lucien.xin@gmail.com>
 <b45828d4f886e9d1e92a8b68c1932af9ff80b562.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netns sctp feature flags shouldn't work as a global switch,
which is mostly like a firewall/netfilter's job. Also, it will
break asoc as it discard or accept chunks incorrectly when net
sctp.x_enable is changed after the asoc is created.

Since each type of chunk's processing function will check the
corresp asoc's feature flag, this 'global switch' should be
removed, and net sctp.x_enable will only work as the default
feature flags for the future sctp sockets/endpoints.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statetable.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 61ed9c6..88ea87f 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -976,26 +976,22 @@ static const struct sctp_sm_table_entry *sctp_chunk_event_lookup(
 	if (cid <= SCTP_CID_BASE_MAX)
 		return &chunk_event_table[cid][state];
 
-	if (net->sctp.prsctp_enable) {
-		if (cid == SCTP_CID_FWD_TSN || cid == SCTP_CID_I_FWD_TSN)
-			return &prsctp_chunk_event_table[0][state];
-	}
+	switch ((u16)cid) {
+	case SCTP_CID_FWD_TSN:
+	case SCTP_CID_I_FWD_TSN:
+		return &prsctp_chunk_event_table[0][state];
 
-	if (net->sctp.addip_enable) {
-		if (cid == SCTP_CID_ASCONF)
-			return &addip_chunk_event_table[0][state];
+	case SCTP_CID_ASCONF:
+		return &addip_chunk_event_table[0][state];
 
-		if (cid == SCTP_CID_ASCONF_ACK)
-			return &addip_chunk_event_table[1][state];
-	}
+	case SCTP_CID_ASCONF_ACK:
+		return &addip_chunk_event_table[1][state];
 
-	if (net->sctp.reconf_enable)
-		if (cid == SCTP_CID_RECONF)
-			return &reconf_chunk_event_table[0][state];
+	case SCTP_CID_RECONF:
+		return &reconf_chunk_event_table[0][state];
 
-	if (net->sctp.auth_enable) {
-		if (cid == SCTP_CID_AUTH)
-			return &auth_chunk_event_table[0][state];
+	case SCTP_CID_AUTH:
+		return &auth_chunk_event_table[0][state];
 	}
 
 	return &chunk_event_table_unknown[state];
-- 
2.1.0

