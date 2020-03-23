Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B61C18FFCB
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgCWUtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:49:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:27507 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726173AbgCWUtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584996539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YusDrJHgpQYBMdm47W+/18/y89tRNu/kM9vUiAgJIuU=;
        b=ac33ep1LK+DSU811Ub9slodt07ci/N9o2qzmepVPFMEWZzaiiQEUbjOddGnFAfQv45b6s1
        /46yUtlLX21YCGDMdHfV/93bQCiyCXrM8qnZL/KXsW5zosODWvEMTiEmsrSzevJivY50cm
        EifoBHvmxcICP8KrPYsB3o39+ZHmE84=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-Vkk_CHQWOLK1Agm8DHgnxg-1; Mon, 23 Mar 2020 16:48:57 -0400
X-MC-Unique: Vkk_CHQWOLK1Agm8DHgnxg-1
Received: by mail-wr1-f70.google.com with SMTP id d17so7980687wrs.7
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 13:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YusDrJHgpQYBMdm47W+/18/y89tRNu/kM9vUiAgJIuU=;
        b=PXuoXk4sLyba15bRS0qXoEJfX/lo5eOiqXHhP/9vlkfLeabLZey9+c/Dqf7+HxahL9
         LOJlj2Xn37ypBYUKoJ5L+zfB3Q8jAow3wq115LVM8le3hIIVfnJHqTQkPV2uMhzOSa1L
         HOQyIhx7JZP1Xz1ozQONpL+70XKk9Pf7q4SWwdlf99WCR+i+PPVNjdksqvMfr1ruvD4z
         69PNK9pp1V65BAPWx0KkpxwDszSmTjMXgr4KY3dvYDre+28617M+wYc2MqarAQ4BU3TB
         pcErzECTMH7INCl6VqOFFPpjHnEfjNAcx+V9oacrebngP2YakS4v3Lrw84wzhGjdZKZq
         DC4Q==
X-Gm-Message-State: ANhLgQ0x13ALv4nhag83t3cDOIvyHjQP6Dq4YhZjBHKDM4tlOwueRfcw
        ydCsBoT0D8XWjvVhFAVb0NUQWfoj6RR1WOkKXMKtOBITdbsbOg1+B1EQDl9i0PqMU5BlSpfJO+1
        Hw9RqUt8hxsVerF44
X-Received: by 2002:adf:fa85:: with SMTP id h5mr6806679wrr.63.1584996536431;
        Mon, 23 Mar 2020 13:48:56 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuF399OftZU7Uwj9+P3HzHWVNXViaK3rhvjWVCMVM83ODrG9kdEcufqo62hvpKTTcDu+d5vFA==
X-Received: by 2002:adf:fa85:: with SMTP id h5mr6806659wrr.63.1584996536185;
        Mon, 23 Mar 2020 13:48:56 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id i12sm25873362wro.46.2020.03.23.13.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 13:48:55 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:48:53 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next 4/4] cls_flower: Add extack support for flags key
Message-ID: <c9a0bd844581d7762f430be68c2f020d275f187b.1584995986.git.gnault@redhat.com>
References: <cover.1584995986.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1584995986.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass extack down to fl_set_key_flags() and set message on error.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/sched/cls_flower.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 5811dd971ee5..9b6acd736dc8 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -856,14 +856,16 @@ static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
 	}
 }
 
-static int fl_set_key_flags(struct nlattr **tb,
-			    u32 *flags_key, u32 *flags_mask)
+static int fl_set_key_flags(struct nlattr **tb, u32 *flags_key,
+			    u32 *flags_mask, struct netlink_ext_ack *extack)
 {
 	u32 key, mask;
 
 	/* mask is mandatory for flags */
-	if (!tb[TCA_FLOWER_KEY_FLAGS_MASK])
+	if (!tb[TCA_FLOWER_KEY_FLAGS_MASK]) {
+		NL_SET_ERR_MSG(extack, "Missing flags mask");
 		return -EINVAL;
+	}
 
 	key = be32_to_cpu(nla_get_u32(tb[TCA_FLOWER_KEY_FLAGS]));
 	mask = be32_to_cpu(nla_get_u32(tb[TCA_FLOWER_KEY_FLAGS_MASK]));
@@ -1474,7 +1476,8 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 		return ret;
 
 	if (tb[TCA_FLOWER_KEY_FLAGS])
-		ret = fl_set_key_flags(tb, &key->control.flags, &mask->control.flags);
+		ret = fl_set_key_flags(tb, &key->control.flags,
+				       &mask->control.flags, extack);
 
 	return ret;
 }
-- 
2.21.1

