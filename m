Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413D920BF45
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 09:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgF0HMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 03:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgF0HMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 03:12:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760B2C03E979
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 00:12:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cm23so5870981pjb.5
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 00:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mik72UYx5REbJzZvLHKbmjxZFviO5NA5LCTxs+hjzxQ=;
        b=iH5LbEyLq4r0c0RtKJ8YL0DuUTVt+fszVU8/MyltEGnvSj4KqevUzRJmZjSpxkUB6a
         H5Rn7BTNEkLubhBFccLMBmiISO6EeneIUDxwjtlUNcFUH9vhSqR3eaPjf5jdrADwYE3J
         bz6KpQr9P3c5WbFbeu8eAIXfGd2n3XP/37wEYW7mu9UDJ08SaoWsle0WESHMi5AsfLrw
         2U+1wsYJ+5LtPgLXGRa76m+2/yVbpWOxEZRjEMZvyzyam/M/Ave7YhkfCtWaIz8z7+zk
         b8NqwllsWkTcl71cYaW56dY9npICTuZ7M+ckCs9ZrUO3kG2e4GoDhDSbZI072pCeQZCa
         vX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mik72UYx5REbJzZvLHKbmjxZFviO5NA5LCTxs+hjzxQ=;
        b=VaViSB/33ACrMy5QaEgj/67xda01tjg59+LKPKGKpyLNE7nk6SI+j51nwTkSMFOKLC
         rOHigFp2W+bmMSSwu2ZN6wHfs7Kpwv3sQdKUP5X4r/ORlb9UARQf1PJ3z6rFh4dgrVCO
         C/g7sLMfGcNZKSTAoLj5dY8hA6FetsMUrMx8o4gIsXqnSksNEM6rNYb/IyG6LsqYaP+0
         7Y8jOHhv9pENiWA8rxoHrKDvwxkDS7HzbSBbRMCtNFROPncUjGtr2QWuQXKd2zHXx4wE
         I+LPLRzVajzIu7rNGXxm9CyYWkrShZKJVV0maLbp4XHMVaXcrLUL28UEv58aqbKSQR9r
         Cx7Q==
X-Gm-Message-State: AOAM531TKoI0WCSAl9poYaTtZgg28KphQLgg/OnDPOc7OvC9mFa7O22F
        BrrZIgesbuAD7fXI6engwuP5SNSw/6U=
X-Google-Smtp-Source: ABdhPJyymh19GkJY/ndiy68sBkjwIs5KUyds4uZud9q0Om5Fl9lIWu95aDU90hfnV4feBoJ0vxTSGw==
X-Received: by 2002:a17:902:7247:: with SMTP id c7mr5688537pll.103.1593241955628;
        Sat, 27 Jun 2020 00:12:35 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::1e])
        by smtp.gmail.com with ESMTPSA id t19sm5139197pgg.19.2020.06.27.00.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 00:12:35 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+3039ddf6d7b13daf3787@syzkaller.appspotmail.com,
        syzbot+80cad1e3cb4c41cde6ff@syzkaller.appspotmail.com,
        syzbot+736bcbcb11b60d0c0792@syzkaller.appspotmail.com,
        syzbot+520f8704db2b68091d44@syzkaller.appspotmail.com,
        syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com,
        Jiri Pirko <jiri@mellanox.com>
Subject: [Patch net] genetlink: get rid of family->attrbuf
Date:   Sat, 27 Jun 2020 00:12:24 -0700
Message-Id: <20200627071224.12221-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

genl_family_rcv_msg_attrs_parse() reuses the global family->attrbuf
when family->parallel_ops is false. However, family->attrbuf is not
protected by any lock on the genl_family_rcv_msg_doit() code path.

This leads to several different consequences, one of them is UAF,
like the following:

genl_family_rcv_msg_doit():		genl_start():
					  genl_family_rcv_msg_attrs_parse()
					    attrbuf = family->attrbuf
					    __nlmsg_parse(attrbuf);
  genl_family_rcv_msg_attrs_parse()
    attrbuf = family->attrbuf
    __nlmsg_parse(attrbuf);
					  info->attrs = attrs;
					  cb->data = info;

netlink_unicast_kernel():
 consume_skb()
					genl_lock_dumpit():
					  genl_dumpit_info(cb)->attrs

Note family->attrbuf is an array of pointers to the skb data, once
the skb is freed, any dereference of family->attrbuf will be a UAF.

Maybe we could serialize the family->attrbuf with genl_mutex too, but
that would make the locking more complicated. Instead, we can just get
rid of family->attrbuf and always allocate attrbuf from heap like the
family->parallel_ops==true code path. This may add some performance
overhead but comparing with taking the global genl_mutex, it still
looks better.

Fixes: 75cdbdd08900 ("net: ieee802154: have genetlink code to parse the attrs during dumpit")
Fixes: 057af7071344 ("net: tipc: have genetlink code to parse the attrs during dumpit")
Reported-and-tested-by: syzbot+3039ddf6d7b13daf3787@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+80cad1e3cb4c41cde6ff@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+736bcbcb11b60d0c0792@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+520f8704db2b68091d44@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c96e4dfb32f8987fdeed@syzkaller.appspotmail.com
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/genetlink.h |  2 --
 net/netlink/genetlink.c | 48 +++++++++++------------------------------
 2 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 74950663bb00..ad71ed4f55ff 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -41,7 +41,6 @@ struct genl_info;
  *	Note that unbind() will not be called symmetrically if the
  *	generic netlink family is removed while there are still open
  *	sockets.
- * @attrbuf: buffer to store parsed attributes (private)
  * @mcgrps: multicast groups used by this family
  * @n_mcgrps: number of multicast groups
  * @mcgrp_offset: starting number of multicast group IDs in this family
@@ -66,7 +65,6 @@ struct genl_family {
 					     struct genl_info *info);
 	int			(*mcast_bind)(struct net *net, int group);
 	void			(*mcast_unbind)(struct net *net, int group);
-	struct nlattr **	attrbuf;	/* private */
 	const struct genl_ops *	ops;
 	const struct genl_multicast_group *mcgrps;
 	unsigned int		n_ops;
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 55ee680e9db1..a914b9365a46 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -351,22 +351,11 @@ int genl_register_family(struct genl_family *family)
 		start = end = GENL_ID_VFS_DQUOT;
 	}
 
-	if (family->maxattr && !family->parallel_ops) {
-		family->attrbuf = kmalloc_array(family->maxattr + 1,
-						sizeof(struct nlattr *),
-						GFP_KERNEL);
-		if (family->attrbuf == NULL) {
-			err = -ENOMEM;
-			goto errout_locked;
-		}
-	} else
-		family->attrbuf = NULL;
-
 	family->id = idr_alloc_cyclic(&genl_fam_idr, family,
 				      start, end + 1, GFP_KERNEL);
 	if (family->id < 0) {
 		err = family->id;
-		goto errout_free;
+		goto errout_locked;
 	}
 
 	err = genl_validate_assign_mc_groups(family);
@@ -385,8 +374,6 @@ int genl_register_family(struct genl_family *family)
 
 errout_remove:
 	idr_remove(&genl_fam_idr, family->id);
-errout_free:
-	kfree(family->attrbuf);
 errout_locked:
 	genl_unlock_all();
 	return err;
@@ -419,8 +406,6 @@ int genl_unregister_family(const struct genl_family *family)
 		   atomic_read(&genl_sk_destructing_cnt) == 0);
 	genl_unlock();
 
-	kfree(family->attrbuf);
-
 	genl_ctrl_event(CTRL_CMD_DELFAMILY, family, NULL, 0);
 
 	return 0;
@@ -485,30 +470,23 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 	if (!family->maxattr)
 		return NULL;
 
-	if (family->parallel_ops) {
-		attrbuf = kmalloc_array(family->maxattr + 1,
-					sizeof(struct nlattr *), GFP_KERNEL);
-		if (!attrbuf)
-			return ERR_PTR(-ENOMEM);
-	} else {
-		attrbuf = family->attrbuf;
-	}
+	attrbuf = kmalloc_array(family->maxattr + 1,
+				sizeof(struct nlattr *), GFP_KERNEL);
+	if (!attrbuf)
+		return ERR_PTR(-ENOMEM);
 
 	err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
 			    family->policy, validate, extack);
 	if (err) {
-		if (family->parallel_ops)
-			kfree(attrbuf);
+		kfree(attrbuf);
 		return ERR_PTR(err);
 	}
 	return attrbuf;
 }
 
-static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
-					   struct nlattr **attrbuf)
+static void genl_family_rcv_msg_attrs_free(struct nlattr **attrbuf)
 {
-	if (family->parallel_ops)
-		kfree(attrbuf);
+	kfree(attrbuf);
 }
 
 struct genl_start_context {
@@ -542,7 +520,7 @@ static int genl_start(struct netlink_callback *cb)
 no_attrs:
 	info = genl_dumpit_info_alloc();
 	if (!info) {
-		genl_family_rcv_msg_attrs_free(ctx->family, attrs);
+		genl_family_rcv_msg_attrs_free(attrs);
 		return -ENOMEM;
 	}
 	info->family = ctx->family;
@@ -559,7 +537,7 @@ static int genl_start(struct netlink_callback *cb)
 	}
 
 	if (rc) {
-		genl_family_rcv_msg_attrs_free(info->family, info->attrs);
+		genl_family_rcv_msg_attrs_free(info->attrs);
 		genl_dumpit_info_free(info);
 		cb->data = NULL;
 	}
@@ -588,7 +566,7 @@ static int genl_lock_done(struct netlink_callback *cb)
 		rc = ops->done(cb);
 		genl_unlock();
 	}
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
+	genl_family_rcv_msg_attrs_free(info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -601,7 +579,7 @@ static int genl_parallel_done(struct netlink_callback *cb)
 
 	if (ops->done)
 		rc = ops->done(cb);
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
+	genl_family_rcv_msg_attrs_free(info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -694,7 +672,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 		family->post_doit(ops, skb, &info);
 
 out:
-	genl_family_rcv_msg_attrs_free(family, attrbuf);
+	genl_family_rcv_msg_attrs_free(attrbuf);
 
 	return err;
 }
-- 
2.27.0

