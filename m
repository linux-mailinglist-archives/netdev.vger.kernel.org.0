Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F9B3A3234
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhFJRhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbhFJRhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:37:23 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473DDC0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:11 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l2so3229290wrw.6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ex6KOBRtY39MKOv6zeVS81/i8ZlR1DGsMXXweuEIq84=;
        b=pGA1/Eq/WGWaNPAx1bjvjqyeipVuB31JeFcZ0QfM/SmzE82xFGrXzZCtCMU0STDRTL
         8/UUxU9dezCJIjvL9/s9/vfw/4TVVnRapofJ7EXAJbAa+ZzQRBnQJOCoe0JcSN4m8xNK
         rD7Jjo+hfmViXl8WTJJtR+6Ms7KMxVDz8mTIBieambYtSxpgBQMi+aiu57lRqZTuHC+v
         reiWg0C2lRQ0rEe/315P6rdgbCsZd+/gGjcvH9VKjkRhIjBhyk8CeiiSXRhuxLbfcw2w
         hREkCjku3xX6zrlwVZzftQMu7pqoMtNBhxgBp9BRRnh/fKSaCNCxMejgvwpQFkMS/899
         YoMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ex6KOBRtY39MKOv6zeVS81/i8ZlR1DGsMXXweuEIq84=;
        b=h731sKz28yEfp9zqPbLnxyMeV09Afgyl4NM8aJYrx9fTaNSKd/RCgIG5qgI0tDTxkA
         BI6v2/B/lsGUYEMV4QPuvkMW+JlD8qOvz1tO/3UDwx99Kg7OYYFS7vV7yCdPsT/hGFWh
         nJBFgFg4w0naFOEKznNOdGX74vlISGF7bhmy+wWeZkZdgPeTPL1DleP4ORZM5mh1KQhZ
         yjffaERpXIt++PnMJc8C4xWxrL1CJ+zWHWJo3HAinj48tXvmmahTuZ9WMnK31uucFK/F
         AJ5Y649wxgybRgU6XnCt2pdPH6OD2oj7Eyj5I9s3uNDALSF45J6GDsNVjdB/vWWu8od2
         4yrw==
X-Gm-Message-State: AOAM530hWYhdtKwFMWqLeejLim8VX800MplMxyeha5fp6HhASyugyzjH
        6jAWy4/TUT/2faxBVYtBPikdqg==
X-Google-Smtp-Source: ABdhPJyBIT3F5KAger2RGNqQSCfi/Z6cPD3EbD8fcS3M7xBR3eEo8EDBO5DWEo2LRgVNnLjUprc/xA==
X-Received: by 2002:adf:df8a:: with SMTP id z10mr7171736wrl.62.1623346509769;
        Thu, 10 Jun 2021 10:35:09 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id x3sm9921356wmj.30.2021.06.10.10.35.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 10:35:09 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com, leon@kernel.org,
        m.chetan.kumar@intel.com, parav@nvidia.com,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 2/3] rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME
Date:   Thu, 10 Jun 2021 19:44:48 +0200
Message-Id: <1623347089-28788-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In some cases, for example in the upcoming WWAN framework changes,
there's no natural "parent netdev", so sometimes dummy netdevs are
created or similar. IFLA_PARENT_DEV_NAME is a new attribute intended to
contain a device (sysfs, struct device) name that can be used instead
when creating a new netdev, if the rtnetlink family implements it.

As suggested by Parav Pandit, we also introduce IFLA_PARENT_DEV_BUS_NAME
attribute in order to uniquely identify a device on the system (with
bus/name pair).

ip-link(8) support for the generic parent device attributes will help
us avoid code duplication, so no other link type will require a custom
code to handle the parent name attribute. E.g. the WWAN interface
creation command will looks like this:

$ ip link add wwan0-1 parent-dev wwan0 type wwan channel-id 1

So, some future subsystem (or driver) FOO will have an interface
creation command that looks like this:

$ ip link add foo1-3 parent-dev foo1 type foo bar-id 3 baz-type Y

Below is an example of dumping link info of a random device with these
new attributes:

$ ip --details link show wlp0s20f3
  4: wlp0s20f3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
     state UP mode DORMANT group default qlen 1000
     ...
     parent_devname 0000:00:14.3 parent_busname pci

Co-developed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 v2: - Squashed Johannes and Sergey changes
     - Added IFLA_PARENT_DEV_BUS_NAME attribute
     - reworded commit message + introduce Sergey's comment

 include/uapi/linux/if_link.h |  7 +++++++
 net/core/rtnetlink.c         | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index a5a7f0e..4882e81 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -341,6 +341,13 @@ enum {
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
 	IFLA_PROTO_DOWN_REASON,
+
+	/* device (sysfs) name as parent, used instead
+	 * of IFLA_LINK where there's no parent netdev
+	 */
+	IFLA_PARENT_DEV_NAME,
+	IFLA_PARENT_DEV_BUS_NAME,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 92c3e43..32599f3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1821,6 +1821,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_fill_prop_list(skb, dev))
 		goto nla_put_failure;
 
+	if (dev->dev.parent &&
+	    nla_put_string(skb, IFLA_PARENT_DEV_NAME,
+			   dev_name(dev->dev.parent)))
+		goto nla_put_failure;
+
+	if (dev->dev.parent && dev->dev.parent->bus &&
+	    nla_put_string(skb, IFLA_PARENT_DEV_BUS_NAME,
+			   dev->dev.parent->bus->name))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
@@ -1880,6 +1890,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_PARENT_DEV_BUS_NAME] = { .type = NLA_NUL_STRING },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
-- 
2.7.4

