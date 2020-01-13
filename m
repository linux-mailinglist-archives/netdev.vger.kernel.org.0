Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2656E139BBF
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 22:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgAMVj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 16:39:27 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26487 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728836AbgAMVj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 16:39:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578951566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5kQvYl3bWkkEOFtkGtb9DiISVu/0bqJPGbXsf10KC8U=;
        b=GHtIGMYz0hgLUR4j14OyOznuoqtl8zE1cutYT1g638bi7dAtq7q47u07dcE/vQfoai6eeU
        XfB8XjQATSng+nJWKKofwIe9hGeU/mNJup3CLppOCE3CXlastB5gZd7RgYCBjaUr9F7EBp
        gM5D4PONwZGbW0xn1nsoJeHwQH+eVNA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-t8-cHEFQMe-MhA6i8rSBTw-1; Mon, 13 Jan 2020 16:39:25 -0500
X-MC-Unique: t8-cHEFQMe-MhA6i8rSBTw-1
Received: by mail-wm1-f70.google.com with SMTP id q206so970761wme.9
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 13:39:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5kQvYl3bWkkEOFtkGtb9DiISVu/0bqJPGbXsf10KC8U=;
        b=fNDTqSZhIbnMsUpXN1Fn5f0o94lNwY0hgyRy9TreKutLsHJBZGnLyzJXhaTLkJSiJE
         o8fFVAMsJE1dM0+LmSEFL3cATuloYivBjHI5L8ZiISou4ed+nfCP+rbIVFny1AnaAkAs
         MaO/Lkhwz2BOnveepnpDljlgLE+Pqe9oVTQmP8P8kfuc/Q+qe19J76J3tf3XNI6dP+qW
         SLDCDd+VqRGMvvFZVcfmAkp/Wp9qlon2TCWFx665rSRIAb9+K+fsojIAXw3KdhAmuyFD
         SIshbKro4afC6ydh3KFB8IdlrPjVuTnrSnsY56OmW7nC0FYUSfnr+7MKUtY/WMSoH7eI
         Kt4Q==
X-Gm-Message-State: APjAAAWD9gsJg2EztjIUKuG78rcyQcYyH8apfXTlHLqzrDPo2gxUE1Gk
        KCRrdmNWam/gtrfbzr17lsNks4ZdGqy2Fv1AdPRzPyLQglO+EZeqNHGeoKTzsungM+f/hI7dCjn
        wUr6jR6JJmsunUwm7
X-Received: by 2002:adf:f103:: with SMTP id r3mr20438271wro.295.1578951563518;
        Mon, 13 Jan 2020 13:39:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqy1AxWYdDlajBsYF2RwBoEeFOJZrPRUpYUROWRmROFoj6gUVq7L68WGdoBKju+zYxxmid2P7w==
X-Received: by 2002:adf:f103:: with SMTP id r3mr20438249wro.295.1578951563221;
        Mon, 13 Jan 2020 13:39:23 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id h2sm17466927wrt.45.2020.01.13.13.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 13:39:22 -0800 (PST)
Date:   Mon, 13 Jan 2020 22:39:20 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 1/3] netns: Remove __peernet2id_alloc()
Message-ID: <08c9fc961300286913ce9b0494b8601fccb5c059.1578950227.git.gnault@redhat.com>
References: <cover.1578950227.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1578950227.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__peernet2id_alloc() was used for both plain lookups and for netns ID
allocations (depending the value of '*alloc'). Let's separate lookups
from allocations instead. That is, integrate the lookup code into
__peernet2id() and make peernet2id_alloc() responsible for allocating
new netns IDs when necessary.

This makes it clear that __peernet2id() doesn't modify the idr and
prepares the code for lockless lookups.

Also, mark the 'net' argument of __peernet2id() as 'const', since we're
modifying this line.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/core/net_namespace.c | 55 +++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 39402840025e..05e07d24b45b 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -211,16 +211,10 @@ static int net_eq_idr(int id, void *net, void *peer)
 	return 0;
 }
 
-/* Should be called with nsid_lock held. If a new id is assigned, the bool alloc
- * is set to true, thus the caller knows that the new id must be notified via
- * rtnl.
- */
-static int __peernet2id_alloc(struct net *net, struct net *peer, bool *alloc)
+/* Should be called with nsid_lock held. */
+static int __peernet2id(const struct net *net, struct net *peer)
 {
 	int id = idr_for_each(&net->netns_ids, net_eq_idr, peer);
-	bool alloc_it = *alloc;
-
-	*alloc = false;
 
 	/* Magic value for id 0. */
 	if (id == NET_ID_ZERO)
@@ -228,23 +222,9 @@ static int __peernet2id_alloc(struct net *net, struct net *peer, bool *alloc)
 	if (id > 0)
 		return id;
 
-	if (alloc_it) {
-		id = alloc_netid(net, peer, -1);
-		*alloc = true;
-		return id >= 0 ? id : NETNSA_NSID_NOT_ASSIGNED;
-	}
-
 	return NETNSA_NSID_NOT_ASSIGNED;
 }
 
-/* should be called with nsid_lock held */
-static int __peernet2id(struct net *net, struct net *peer)
-{
-	bool no = false;
-
-	return __peernet2id_alloc(net, peer, &no);
-}
-
 static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 			      struct nlmsghdr *nlh, gfp_t gfp);
 /* This function returns the id of a peer netns. If no id is assigned, one will
@@ -252,26 +232,37 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
  */
 int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp)
 {
-	bool alloc = false, alive = false;
 	int id;
 
 	if (refcount_read(&net->count) == 0)
 		return NETNSA_NSID_NOT_ASSIGNED;
+
 	spin_lock_bh(&net->nsid_lock);
-	/*
-	 * When peer is obtained from RCU lists, we may race with
+	id = __peernet2id(net, peer);
+	if (id >= 0) {
+		spin_unlock_bh(&net->nsid_lock);
+		return id;
+	}
+
+	/* When peer is obtained from RCU lists, we may race with
 	 * its cleanup. Check whether it's alive, and this guarantees
 	 * we never hash a peer back to net->netns_ids, after it has
 	 * just been idr_remove()'d from there in cleanup_net().
 	 */
-	if (maybe_get_net(peer))
-		alive = alloc = true;
-	id = __peernet2id_alloc(net, peer, &alloc);
+	if (!maybe_get_net(peer)) {
+		spin_unlock_bh(&net->nsid_lock);
+		return NETNSA_NSID_NOT_ASSIGNED;
+	}
+
+	id = alloc_netid(net, peer, -1);
 	spin_unlock_bh(&net->nsid_lock);
-	if (alloc && id >= 0)
-		rtnl_net_notifyid(net, RTM_NEWNSID, id, 0, NULL, gfp);
-	if (alive)
-		put_net(peer);
+
+	put_net(peer);
+	if (id < 0)
+		return NETNSA_NSID_NOT_ASSIGNED;
+
+	rtnl_net_notifyid(net, RTM_NEWNSID, id, 0, NULL, gfp);
+
 	return id;
 }
 EXPORT_SYMBOL_GPL(peernet2id_alloc);
-- 
2.21.1

