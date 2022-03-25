Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A564E7C75
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiCYX7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 19:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiCYX7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 19:59:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686A11C4B2A
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 16:57:38 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so9992258pjf.1
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 16:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UX74vH9OC1+sjh0vNRkmDWxhaLw51W7M5NXy+mT4cEE=;
        b=WGMYJ7cU8C9Mnwt6R07t++2nJcF0Ftzb3Rp8rMnD5MGGLT27BYecA8OHqt4xQIWbAo
         MpHUAMGoKtwraNeojB/Jf8R6g1DjTYL78ax8bR52SJaUrO313AnnyDd5X7R0Va4BOM/2
         3x02Idr0yBFIPDktbykR83VmxWROzFhMPIG2p3aILSf/QfisqDcUFyeim6a808E9BjBH
         PBNBZdeNbFV4dqYkjK9YFMhnBqCDMmG7qAvkY5aVaOcRYJM9SHv3U/W4lcMeEcdwbSze
         D4VcjOzh7AJKwsVHTsLV4ivMZulze2RriIcw8stuR2YybwwgFFLJtnp0QfjkWYQ6B2dA
         P1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UX74vH9OC1+sjh0vNRkmDWxhaLw51W7M5NXy+mT4cEE=;
        b=qdn+NfE6on4dRy4UXXkU2c/n5TFJqLaLuNPY+hhsWKHEJGPeplZXpmoF8OedfCdJA/
         NaA4zJ0vPmvuFuFN2Ty3OZIS+zGTbXpHOnsC42rrZmWw/4xhO46idGLvjgzyRa7n0WtL
         1pLyy2D56Mbnhnf1wgZ71fk+Z0Au0658eoFaT9NMVJd4rqSwj1hzopmF6Eb0pAOxWhkI
         tRzyrp0+ksJmLDeWmdomW07itUn1OAhQrqsCLBDArX1FEL1dm3C1rB2mYTgMfMiz8gcl
         8VMh3SH+fQqla/mIVF2e5D3AM9W9yhW+U09lvo+YGFjAfpUhVEgE3P2sZRF0LOm++Ha0
         JEEQ==
X-Gm-Message-State: AOAM530JaIERUw4UnNp5YMd/ss5COa/ckuWIr4BOIyzPhgDv9de1ejSL
        aqfwnRVdMbaz470fIfYuLGENPA==
X-Google-Smtp-Source: ABdhPJyIXQBr9qlk1fc0b8vR2Z7JGpGpfMQbzhBlhblenGLm8EyEkzciaB+2roujHdOoyX6C5tVBeQ==
X-Received: by 2002:a17:902:da92:b0:154:10dc:26f8 with SMTP id j18-20020a170902da9200b0015410dc26f8mr14174084plx.133.1648252657662;
        Fri, 25 Mar 2022 16:57:37 -0700 (PDT)
Received: from google.com (249.189.233.35.bc.googleusercontent.com. [35.233.189.249])
        by smtp.gmail.com with ESMTPSA id k185-20020a6384c2000000b003821dcd9020sm6374887pgd.27.2022.03.25.16.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 16:57:36 -0700 (PDT)
Date:   Fri, 25 Mar 2022 23:57:33 +0000
From:   William McVicker <willmcvicker@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Message-ID: <Yj5W7VEij0BGwFK0@google.com>
References: <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
 <YjpGlRvcg72zNo8s@google.com>
 <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
 <Yjzpo3TfZxtKPMAG@google.com>
 <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
 <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
 <Yj4FFIXi//ivQC3X@google.com>
 <Yj4ntUejxaPhrM5b@google.com>
 <976e8cf697c7e5bc3a752e758a484b69a058710a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <976e8cf697c7e5bc3a752e758a484b69a058710a.camel@sipsolutions.net>
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/25/2022, Johannes Berg wrote:
> On Fri, 2022-03-25 at 20:36 +0000, William McVicker wrote:
> > 
> > I found that my wlan driver is using the vendor commands to create/delete NAN
> > interfaces for this Android feature called Wi-Fi aware [1]. Basically, this
> > features allows users to discover other nearby devices and allows them to
> > connect directly with one another over a local network. 
> > 
> 
> Wait, why is it doing that? We actually support a NAN interface type
> upstream :) It's not really quite fully fleshed out, but it could be?
> Probably should be?
> 
> 
> > Thread 1                         Thread 2
> >  nl80211_pre_doit():
> >    rtnl_lock()
> >    wiphy_lock()                   nl80211_pre_doit():
> >                                     rtnl_lock() // blocked by Thread 1
> >  nl80211_vendor_cmd():
> >    doit()
> >      cfg80211_unregister_netdevice()
> >    rtnl_unlock():
> >      netdev_run_todo():
> >        __rtnl_unlock()
> >                                     <got RTNL lock>
> >                                     wiphy_lock() // blocked by Thread 1
> >        rtnl_lock(); // DEADLOCK
> >  nl80211_post_doit():
> >    wiphy_unlock();
> 
> 
> Right, this is what I had discussed in my other mails.
> 
> Basically, you're actually doing (some form of) unregister_netdevice()
> before rtnl_unlock().
> 
> Clearly this isn't possible in cfg80211 itself.
> 
> However, I couldn't entirely discount the possibility that this is
> possible:
> 
> Thread 1                   Thread 2
>                             rtnl_lock()
>                             unregister_netdevice()
>                             __rtnl_unlock()
> rtnl_lock()
> wiphy_lock()
> netdev_run_todo()
>  __rtnl_unlock()
>  // list not empty now    
>  // because of thread 2     rtnl_lock()
>  rtnl_lock()
>                             wiphy_lock()
> 
> ** DEADLOCK **
> 
> 
> Given my other discussion with Jakub though, it seems that we can indeed
> make sure that this cannot happen, and then this scenario is impossible
> without the unregistration you're doing.

Sounds good.

> 
> > Since I'm unlocking the RTNL inside nl80211_vendor_cmd() after calling doit()
> > instead of waiting till post_doit(), I get into the situation you mentioned
> > where the net_todo_list is not empty when calling rtnl_unlock. So I decided to
> > drop the rtnl_unlock() in nl80211_vendor_cmd() and defer that until
> > nl80211_post_doit() after calling wiphy_unlock(). With this change, I haven't
> > been able to reproduce the deadlock. So it's possible that we aren't actually
> > able to hit this deadlock in nl80211_pre_doit() with the existing code since,
> > as you mentioned, one wouldn't be able to call unregister_netdevice() without
> > having the RTNL lock.
> > 
> 
> Right, this is why I said earlier that actually adding a flag for vendor
> commands to get the RTNL would be more complex - you'd have to basically
> open-code pre_doit() and post_doit() in there and check the sub-command
> flag at the very beginning and very end.
> 
> johannes

Instead of open coding it, we could just pass the internal_flags via struct
genl_info to nl80211_vendor_cmds() and then handle the rtnl_unlock() there if
the vendor command doesn't request it. I included the patch below in case
there's any chance you would consider this for upstream. This would at least
add backwards compatibility to the vendor ops API so that existing drivers that
depend on the RTNL being held don't need to be fully refactored.

Thanks,
Will

[1] https://lore.kernel.org/all/487e4136-94dc-5a77-89c7-e416a05c3a35@quicinc.com/

---
 include/net/cfg80211.h  |  1 +
 include/net/genetlink.h |  1 +
 net/netlink/genetlink.c |  1 +
 net/wireless/nl80211.c  | 54 +++++++++++++++++++++++++++++------------
 4 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 30d86032e8cb..01f8a2cc6d11 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4706,6 +4706,7 @@ enum wiphy_vendor_command_flags {
 	WIPHY_VENDOR_CMD_NEED_WDEV = BIT(0),
 	WIPHY_VENDOR_CMD_NEED_NETDEV = BIT(1),
 	WIPHY_VENDOR_CMD_NEED_RUNNING = BIT(2),
+	WIPHY_VENDOR_CMD_NEED_RTNL = BIT(3),
 };
 
 /**
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 7cb3fa8310ed..e92796366492 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -92,6 +92,7 @@ struct genl_info {
 	possible_net_t		_net;
 	void *			user_ptr[2];
 	struct netlink_ext_ack *extack;
+	u8			internal_flags;
 };
 
 static inline struct net *genl_info_net(struct genl_info *info)
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 1afca2a6c2ac..2db1c07c9f5a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -719,6 +719,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 	info.userhdr = nlmsg_data(nlh) + GENL_HDRLEN;
 	info.attrs = attrbuf;
 	info.extack = extack;
+	info.internal_flags = ops->internal_flags;
 	genl_info_net_set(&info, net);
 	memset(&info.user_ptr, 0, sizeof(info.user_ptr));
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 686a69381731..561c3cd3a9a0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13991,6 +13991,19 @@ static int nl80211_vendor_check_policy(const struct wiphy_vendor_command *vcmd,
 	return nla_validate_nested(attr, vcmd->maxattr, vcmd->policy, extack);
 }
 
+#define NL80211_FLAG_NEED_WIPHY		0x01
+#define NL80211_FLAG_NEED_NETDEV	0x02
+#define NL80211_FLAG_NEED_RTNL		0x04
+#define NL80211_FLAG_CHECK_NETDEV_UP	0x08
+#define NL80211_FLAG_NEED_NETDEV_UP	(NL80211_FLAG_NEED_NETDEV |\
+					 NL80211_FLAG_CHECK_NETDEV_UP)
+#define NL80211_FLAG_NEED_WDEV		0x10
+/* If a netdev is associated, it must be UP, P2P must be started */
+#define NL80211_FLAG_NEED_WDEV_UP	(NL80211_FLAG_NEED_WDEV |\
+					 NL80211_FLAG_CHECK_NETDEV_UP)
+#define NL80211_FLAG_CLEAR_SKB		0x20
+#define NL80211_FLAG_NO_WIPHY_MTX	0x40
+
 static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -13999,6 +14012,12 @@ static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 					   info->attrs);
 	int i, err;
 	u32 vid, subcmd;
+	bool internal_rtnl_flag = info->internal_flags & NL80211_FLAG_NEED_RTNL;
+
+	/* In case of an error, we need to set the RTNL flag so that we unlock the
+	 * RTNL in post_doit().
+	 */
+	info->internal_flags = NL80211_FLAG_NEED_RTNL;
 
 	if (!rdev->wiphy.vendor_commands)
 		return -EOPNOTSUPP;
@@ -14058,6 +14077,12 @@ static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 				return err;
 		}
 
+		if (!internal_rtnl_flag && !(vcmd->flags & WIPHY_VENDOR_CMD_NEED_RTNL)) {
+			rtnl_unlock();
+			/* clear the rtnl flag so that we don't unlock in post_doit(). */
+			info->internal_flags &= ~NL80211_FLAG_NEED_RTNL;
+		}
+
 		rdev->cur_cmd_info = info;
 		err = vcmd->doit(&rdev->wiphy, wdev, data, len);
 		rdev->cur_cmd_info = NULL;
@@ -15165,19 +15190,6 @@ static int nl80211_set_fils_aad(struct sk_buff *skb,
 	return rdev_set_fils_aad(rdev, dev, &fils_aad);
 }
 
-#define NL80211_FLAG_NEED_WIPHY		0x01
-#define NL80211_FLAG_NEED_NETDEV	0x02
-#define NL80211_FLAG_NEED_RTNL		0x04
-#define NL80211_FLAG_CHECK_NETDEV_UP	0x08
-#define NL80211_FLAG_NEED_NETDEV_UP	(NL80211_FLAG_NEED_NETDEV |\
-					 NL80211_FLAG_CHECK_NETDEV_UP)
-#define NL80211_FLAG_NEED_WDEV		0x10
-/* If a netdev is associated, it must be UP, P2P must be started */
-#define NL80211_FLAG_NEED_WDEV_UP	(NL80211_FLAG_NEED_WDEV |\
-					 NL80211_FLAG_CHECK_NETDEV_UP)
-#define NL80211_FLAG_CLEAR_SKB		0x20
-#define NL80211_FLAG_NO_WIPHY_MTX	0x40
-
 static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info)
 {
@@ -15231,8 +15243,14 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		/* we keep the mutex locked until post_doit */
 		__release(&rdev->wiphy.mtx);
 	}
-	if (!(ops->internal_flags & NL80211_FLAG_NEED_RTNL))
-		rtnl_unlock();
+
+	/* NL80211 vendor command doit() will handle the RTNL unlocking based on the
+	 * vendor command flags.
+	 */
+	if (ops->cmd != NL80211_CMD_VENDOR) {
+		if (!(ops->internal_flags & NL80211_FLAG_NEED_RTNL))
+			rtnl_unlock();
+	}
 
 	return 0;
 }
@@ -15259,7 +15277,11 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		wiphy_unlock(&rdev->wiphy);
 	}
 
-	if (ops->internal_flags & NL80211_FLAG_NEED_RTNL)
+	/* If a vendor command requested for the RTNL, then it will set the
+	 * info->internal_flags to indicate that the RTNL needs to be released.
+	 */
+	if (ops->internal_flags & NL80211_FLAG_NEED_RTNL ||
+	    info->internal_flags & NL80211_FLAG_NEED_RTNL)
 		rtnl_unlock();
 
 	/* If needed, clear the netlink message payload from the SKB
-- 
2.35.1.1021.g381101b075-goog

