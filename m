Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AF37FDA7
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388149AbfHBPf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:35:27 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39475 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfHBPf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:35:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so36255016pgi.6
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 08:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ApEPfYLDkaftPbdGrgkwltjAOkRc+C1sr4uIvLIlPbI=;
        b=UkhvvGLmTZwuM/XOr2DMVT4r9W5ST4fy5Wc35J5kLQZCt99xKKYdPxJl5qj+0WVgmo
         wVvh03/l9DAPJ3C/g/Y78Ak+Z40x4j8vKMX2PzqkQa8LeBWIsu22QumMD+0GviObNLAn
         HAZa5GiU5ZW5FPzmGLGcRPtdP1n89RhDROE7KFnqSpX2UpqgtiWC0eiQKBeJ3BMYBFcn
         0NNcpB7KMNboscR4u8R25mMz3Cj1vhJf5eYXLhoQc2iANId6dwu8Q5xHH+3bCb7FYXKC
         qX/eKLZbDUkrlppDup7I7AZGHTEIYHHVCbrBng2rUIECZcMx/fbhe0H7EHr7073CfJ8K
         HVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ApEPfYLDkaftPbdGrgkwltjAOkRc+C1sr4uIvLIlPbI=;
        b=hic8idah7MUdpSXMYSFkEZUwU8dI4NY1oc5ssHwW0q/sIgq+GDSG9LzN+eyRuUroGI
         1qirBYzwOQVbwavSkRqkRGJzyPY6NbDwlgx/LIqKBrZWYwn5akmywdDQwo8rU2g0R1oq
         obZmTJOQq/pxlpqCS/WGqS7OeW/EL1e4t9/liNfgTvg6SeBFnSUTMmbNR6rHCuuKLkkc
         nskxplzqInf9eCmgslZLbtt6TJ9HPwkdTDIdwZqbaQeoNAm2ua2YpXjdY6pAWfzPid8E
         0wjsGyo+1hbes5SVh49OlfV9kJjvjWhVAmrD6nkoAWaCclJXjhvtRU1VYAYKcBtbKcM3
         C2JA==
X-Gm-Message-State: APjAAAWimDbGcnSO8zS79duzBwkOi+i1dN8lYjQWNhdAwFQA7NQ0xdWg
        qNdXRB2NaCZSncdjwp7zyks=
X-Google-Smtp-Source: APXvYqyLMr94yFdu2mZ8K2EOcJa1Uh7dEJp8bg+yQqwpDn14AA1TTigDkZ4fC43I3+UyfqWw0cssYA==
X-Received: by 2002:a62:ae01:: with SMTP id q1mr58894229pff.219.1564760126671;
        Fri, 02 Aug 2019 08:35:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m101sm6818193pjb.7.2019.08.02.08.35.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 08:35:26 -0700 (PDT)
Date:   Fri, 2 Aug 2019 08:35:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        michael-dev <michael-dev@fami-braun.de>
Subject: Re: [PATCH net v4] net: bridge: move default pvid init/deinit to
 NETDEV_REGISTER/UNREGISTER
Message-ID: <20190802083519.71cb4fa2@hermes.lan>
In-Reply-To: <20190802105736.26767-1-nikolay@cumulusnetworks.com>
References: <0a015a21-c1ae-e275-e675-431f08bece86@cumulusnetworks.com>
        <20190802105736.26767-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Aug 2019 13:57:36 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> +int br_vlan_bridge_event(struct net_device *dev, unsigned long event, void *ptr)
>  {
>  	struct netdev_notifier_changeupper_info *info;
> -	struct net_bridge *br;
> +	struct net_bridge *br = netdev_priv(dev);
> +	bool changed;
> +	int ret = 0;
>  
>  	switch (event) {
> +	case NETDEV_REGISTER:
> +		ret = br_vlan_add(br, br->default_pvid,
> +				  BRIDGE_VLAN_INFO_PVID |
> +				  BRIDGE_VLAN_INFO_UNTAGGED |
> +				  BRIDGE_VLAN_INFO_BRENTRY, &changed, NULL);
> +		break;

Looks good.

As minor optimization br_vlan_add could ignore changed pointer if NULL.
This would save places where you don't care.


Something like:
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 021cc9f66804..bacd3543b215 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -626,10 +626,11 @@ static int br_vlan_add_existing(struct net_bridge *br,
 		refcount_inc(&vlan->refcnt);
 		vlan->flags |= BRIDGE_VLAN_INFO_BRENTRY;
 		vg->num_vlans++;
-		*changed = true;
+		if (changed)
+			*changed = true;
 	}
 
-	if (__vlan_add_flags(vlan, flags))
+	if (__vlan_add_flags(vlan, flags) && changed)
 		*changed = true;
 
 	return 0;
@@ -653,7 +654,8 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags, bool *changed,
 
 	ASSERT_RTNL();
 
-	*changed = false;
+	if (changed)
+		*changed = false;
 	vg = br_vlan_group(br);
 	vlan = br_vlan_find(vg, vid);
 	if (vlan)
@@ -679,7 +681,7 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags, bool *changed,
 	if (ret) {
 		free_percpu(vlan->stats);
 		kfree(vlan);
-	} else {
+	} else if (changed) {
 		*changed = true;
 	}
 

