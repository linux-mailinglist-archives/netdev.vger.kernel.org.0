Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6997D350D43
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 05:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhDADta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 23:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhDADtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 23:49:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41641C0613E6
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 20:49:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so2336748pjh.1
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 20:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9luDLg9CEnQ0YH8mX3EiQf6SA0AZDDFgbRXW4PesTP0=;
        b=WeE21d3yGTpsXg0XU+wtMVCzsiHDaASc4q3u42eOKiAMv0VkEhUFp+083yYkKTXuow
         8bLoku9q7D0fkOoGYDHFYfXP2NSzLRzl5LuWX110w78kjBC9dM/2PwpU1F1+1ECYDJol
         rZbBrI0cY96bI3B8ATRVS/HFQ/4ZSOA72OmL/xXNSIme4AkS5jdLNjcVTHkz2vMbhhyd
         oyS7z3biDxhaShmQl9n9tMQNnQqcJZU3c3D1jq/uxa3ey0DuSYdkR/KZ91nESdJsxo2u
         K0GTMDvh6ZGKCV+DsL6dWRqfaaq1TBRJBeZA8fnlzD2hfGddjX2LItCWLMx+BjlPHob7
         RZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9luDLg9CEnQ0YH8mX3EiQf6SA0AZDDFgbRXW4PesTP0=;
        b=DTck8wh+E8SQyL4/wpPL3STYrcIDUuZWR1/w8Kwd/hJrS+Ifx97sRBx8wpw7uSjeNG
         Ip1iHe+OwP0YGVfXpyrNBHHIK1IHzonpLCUa3CUkK8/dwfe4nWeSEtK6C5qr+5QsvRX3
         /tPVZFp4hxGpQUpaBubv8HB2szQsNp99hG6xIOJxgvIuNVUgOkocX6iyFbXbbwd8OG47
         RY2+7OyVJ5y+wjzNoE8zYOASf694DNNMDijW+o+2cN9qh9ISyzKwTb7vk3N03p6y5hkf
         yzkYxhRwvuifDAqovulMlQb5+V8h2pyjTdaoRc3As1KEGDwmULP5WGTQpoBKpEKFxy3v
         d7Dg==
X-Gm-Message-State: AOAM5314WTVwJ9/EaBbb00rqlcpCWbQ0UaJBsxsJHaW9C5tr8q2reEFE
        7RFQe/l1vwLKNiODXxn9v4RB9qzDlS85YA==
X-Google-Smtp-Source: ABdhPJwwIn5FmzIM8CnfIVs8l0kC/ENaPPc8qKirWzkUKJbxyZpYVuOIdI9zLG119YpieKKx2myXrA==
X-Received: by 2002:a17:902:9a0a:b029:e6:bf00:8a36 with SMTP id v10-20020a1709029a0ab02900e6bf008a36mr6168835plp.51.1617248957821;
        Wed, 31 Mar 2021 20:49:17 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id q1sm4195351pgf.20.2021.03.31.20.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 20:49:17 -0700 (PDT)
Date:   Wed, 31 Mar 2021 20:49:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hongren Zheng <i@zenithal.me>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: [RFC] add extack errors for iptoken
Message-ID: <20210331204902.78d87b40@hermes.local>
In-Reply-To: <YF80x4bBaXpS4s/W@Sun>
References: <YF80x4bBaXpS4s/W@Sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perhaps the following (NOT TESTED) kernel patch will show you how such error messages
could be added.

Note: requires trickling down the extack parameter, but that is a good thing because
other place like devconf could use it as well.

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 4da61c950e93..479f60ef54c0 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -147,8 +147,8 @@ struct rtnl_af_ops {
 	int			(*validate_link_af)(const struct net_device *dev,
 						    const struct nlattr *attr);
 	int			(*set_link_af)(struct net_device *dev,
-					       const struct nlattr *attr);
-
+					       const struct nlattr *attr,
+					       struct netlink_ext_ack *extack);
 	int			(*fill_stats_af)(struct sk_buff *skb,
 						 const struct net_device *dev);
 	size_t			(*get_stats_af_size)(const struct net_device *dev);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1bdcb33fb561..3485b16a7ff3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2863,7 +2863,7 @@ static int do_setlink(const struct sk_buff *skb,
 
 			BUG_ON(!(af_ops = rtnl_af_lookup(nla_type(af))));
 
-			err = af_ops->set_link_af(dev, af);
+			err = af_ops->set_link_af(dev, af, extack);
 			if (err < 0) {
 				rcu_read_unlock();
 				goto errout;
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 75f67994fc85..2e35f68da40a 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1978,7 +1978,8 @@ static int inet_validate_link_af(const struct net_device *dev,
 	return 0;
 }
 
-static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla)
+static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
+			    struct netlink_ext_ack *extack)
 {
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 120073ffb666..b817086fbf42 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5672,7 +5672,8 @@ static int inet6_fill_link_af(struct sk_buff *skb, const struct net_device *dev,
 	return 0;
 }
 
-static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
+static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token,
+			     struct netlink_ext_ack *extack)
 {
 	struct inet6_ifaddr *ifp;
 	struct net_device *dev = idev->dev;
@@ -5681,14 +5682,29 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
 
 	ASSERT_RTNL();
 
-	if (!token)
+	if (!token) {
 		return -EINVAL;
-	if (dev->flags & (IFF_LOOPBACK | IFF_NOARP))
+	}
+
+	if (dev->flags & IFF_LOOPBACK) {
+		NL_SET_ERR_MSG_MOD(extack, "Device is loopback");
 		return -EINVAL;
-	if (!ipv6_accept_ra(idev))
+	}
+
+	if (dev->flags & IFF_NOARP) {
+		NL_SET_ERR_MSG_MOD(extack, "Device does not do discovery");
 		return -EINVAL;
-	if (idev->cnf.rtr_solicits == 0)
+	}
+
+	if (!ipv6_accept_ra(idev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device does accept route adverts");
+		return -EINVAL;
+	}
+
+	if (idev->cnf.rtr_solicits == 0) {
+		NL_SET_ERR_MSG(extack, "Device has disabled router solicitation");
 		return -EINVAL;
+	}
 
 	write_lock_bh(&idev->lock);
 
@@ -5796,7 +5812,8 @@ static int inet6_validate_link_af(const struct net_device *dev,
 	return 0;
 }
 
-static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
+static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla,
+			     struct netlink_ext_ack *extack)
 {
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct nlattr *tb[IFLA_INET6_MAX + 1];
@@ -5809,7 +5826,8 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
 		BUG();
 
 	if (tb[IFLA_INET6_TOKEN]) {
-		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]));
+		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]),
+					extack);
 		if (err)
 			return err;
 	}
