Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 875CFB950F
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 18:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403806AbfITQQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 12:16:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38382 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbfITQQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 12:16:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id h195so4842771pfe.5
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 09:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zSkjuHRpYctb0k8lAPcEAIoSi3sqg/2iQqIHCOrTV6Y=;
        b=a5PqEb1gaamzXpm1kAdDIo14WuUjFTOM2URtXPzcZahhO38EYwVE/QM3ZnyHMUjN/0
         McDJIUHRoNAryE5zLNzHxPvQNmKyGZdcJTg6dZtkRkf1X4Tf+oVLGKNCEN+Oko++tXbi
         sPBxkE0Dm2bAwju+ohgt3jnBYUcxe8SmPPgYeQWRpdK3Zft117qYgE/vKBhmJnIcsRkf
         U1hQKaZ3PoJcDkbeu/s17lCm+MjArQqEyFj+cV52Az9LK3qHsTkTFb3lsmFPRB5Q4O4U
         u8rN4iQ0Q/yP7/v0DEpWp3iRFLndzA/BzwUTYMoxtF1XVEsJKRSJdEE5V3UvhvZsM7Fx
         8PNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zSkjuHRpYctb0k8lAPcEAIoSi3sqg/2iQqIHCOrTV6Y=;
        b=MsgaH45zdq9Ko3aV46PBHY/xxVok8YjeBejMudXTj/o9oZuuF9i7c7Ef7XXXjXy1Yu
         TSD3GaurWbqVHllnwc7/NI8QiwSrX3SI6nP/2Lcw3FlOY19QQUyJCahp5ec41eTznX83
         NVV09NLq0iHlsy5FUGEDGR2yzO+qY9RcheZnj0AtqXITy19w89WYmLDuzjolmKwXPkHy
         0LhKPvdyYf0aCu2oOKoyxyPeG559Bhnh8CWClHRsiPFFG6/YGPf+i3gBKiY8iNCuEVDz
         3tDm3WVmpZQfHPgbeAzZc0t0iBv5xC6dzViZxjB3OyihyNJg3AlGN8iz8CMZuF2h/K25
         Ll2g==
X-Gm-Message-State: APjAAAVqcZRSVhQGhG3MXxfHJnwX9VRmefG16VsMqNP1bRcAS+hHopmj
        pMWSFi0Ae1KtXzXpklODU9ZHRQ==
X-Google-Smtp-Source: APXvYqxNjYC/c7eSPHt3em2lVyIkLOWrMZy6TeMWbDnNvnWQbX2sHr2JU45PCTsLSl4guV1bztUnmw==
X-Received: by 2002:a17:90a:bf04:: with SMTP id c4mr5570770pjs.89.1568996211776;
        Fri, 20 Sep 2019 09:16:51 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::2])
        by smtp.gmail.com with ESMTPSA id e1sm2262557pgi.42.2019.09.20.09.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 09:16:51 -0700 (PDT)
Date:   Fri, 20 Sep 2019 09:16:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin Shelar <pshelar@ovn.org>,
        Simon Horman <simon.horman@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Message-ID: <20190920091647.0129e65f@cakuba.netronome.com>
In-Reply-To: <vbfk1a41fr1.fsf@mellanox.com>
References: <20190919.132147.31804711876075453.davem@davemloft.net>
        <vbfk1a41fr1.fsf@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Sep 2019 15:13:55 +0000, Vlad Buslov wrote:
> On Thu 19 Sep 2019 at 14:21, David Miller <davem@davemloft.net> wrote:
> > As Linus pointed out, the Kconfig logic for CONFIG_NET_TC_SKB_EXT
> > is really not acceptable.
> >
> > It should not be enabled by default at all.
> >
> > Instead the actual users should turn it on or depend upon it, which in
> > this case seems to be OVS.
> >
> > Please fix this, thank you.  
> 
> Hi David,
> 
> We are working on it, but Paul is OoO today. Is it okay if we send the
> fix early next week?

Doesn't really seem like we have too many ways forward here, right?

How about this?

------>8-----------------------------------

net: hide NET_TC_SKB_EXT as a config option

Linus points out the NET_TC_SKB_EXT config option looks suspicious.
Indeed, it should really be selected to ensure correct OvS operation
if TC offload is used. Hopefully those who care about TC-only and
OvS-only performance disable the other one at compilation time.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 net/openvswitch/Kconfig |  1 +
 net/sched/Kconfig       | 13 +++----------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/Kconfig b/net/openvswitch/Kconfig
index 22d7d5604b4c..bd407ea7c263 100644
--- a/net/openvswitch/Kconfig
+++ b/net/openvswitch/Kconfig
@@ -15,6 +15,7 @@ config OPENVSWITCH
 	select NET_MPLS_GSO
 	select DST_CACHE
 	select NET_NSH
+	select NET_TC_SKB_EXT if NET_CLS_ACT
 	---help---
 	  Open vSwitch is a multilayer Ethernet switch targeted at virtualized
 	  environments.  In addition to supporting a variety of features
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index b3faafeafab9..f1062ef55098 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -719,6 +719,7 @@ config NET_EMATCH_IPT
 config NET_CLS_ACT
 	bool "Actions"
 	select NET_CLS
+	select NET_TC_SKB_EXT if OPENVSWITCH
 	---help---
 	  Say Y here if you want to use traffic control actions. Actions
 	  get attached to classifiers and are invoked after a successful
@@ -964,18 +965,10 @@ config NET_IFE_SKBTCINDEX
         depends on NET_ACT_IFE
 
 config NET_TC_SKB_EXT
-	bool "TC recirculation support"
-	depends on NET_CLS_ACT
-	default y if NET_CLS_ACT
+	bool
+	depends on NET_CLS_ACT && OPENVSWITCH
 	select SKB_EXTENSIONS
 
-	help
-	  Say Y here to allow tc chain misses to continue in OvS datapath in
-	  the correct recirc_id, and hardware chain misses to continue in
-	  the correct chain in tc software datapath.
-
-	  Say N here if you won't be using tc<->ovs offload or tc chains offload.
-
 endif # NET_SCHED
 
 config NET_SCH_FIFO
-- 
2.21.0
