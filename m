Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084835EF35F
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiI2KYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiI2KYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:24:47 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2AE13F75
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:24:43 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dv25so1795594ejb.12
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=2/OWC4VkZw6MGa7jzw/XS8dbhw6CFZ1hXk4yOuXpv4k=;
        b=V7cX/orE+652K2QPWvSZDBEHKddm2nexACKiBIttzjydmE05j3rVoMaCUfETTIPibw
         m2NLaSbR/1C9F+pRrTtfwn3CQnoKYYq4+WIUd+5v/GJ7WZoLgfxIjwpMOFdHfbOUzqVK
         x9J4O/20roNnFlnzz0I87FqjsJoH4d+8H3/i5z3V5oKbAWPNcPn+XWBoKmoWvQp9NHkP
         NLj98y1h83J1p/7zoUPekgAr8AZpQlOm4Xks4Ddi4xJBT2NRMhC6E9Gsj4D0SB2hnraF
         md2Z6moc+1Mk26VMmEwzizsDSIwYporpyC94uh8Zyky+K60HFYtvlu8yiv3LKGwshzjS
         fGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2/OWC4VkZw6MGa7jzw/XS8dbhw6CFZ1hXk4yOuXpv4k=;
        b=u1uLtuQ5XcmQmdnvt1mLDecoxU7+7jcwo9kdRoYTGbBvLvn0TH2i2WFzJZ3zPpIyA4
         fBmJ5qYuoEe74C1UctBNsmtXcaKtX/x7IrrEt8DtWWprrYRPGSOvMsVp4eaZtMxO4XTw
         dfDFX5TFqOMtsMTNO7GFxjhsxmqVFxJKswsykqtKjtZcdRVEXXVWQN3ZzS1KmPfm0EHb
         6UQOIqpkFQQALvKFqfiTEw0CFrNM6ty+ZWn3P/NFkGA14lfEirU9RunYTi5vVWcq48NW
         TrQuEqAM5A4nPZmQxHkQx5rfv41g21L7DmA5xAz/45XYtaC2Iz/sK/9nV4+Z5gWmEz3w
         47ZA==
X-Gm-Message-State: ACrzQf0xAAi0+pyQd4Hph4CDyNVz1VniC/54gzW8IXsBIbBomjdpInyO
        gMbgq4wBSrqi8VJNAjX0DajUVnAFJ37k0h6g
X-Google-Smtp-Source: AMsMyM52SLa0y+p9uyPBfFd0k2rp3sHJvV8nFx3T5NWWhc6yTnrJ0xcSye2iFUjoxZTcyTpdtuIGBQ==
X-Received: by 2002:a17:907:3d8e:b0:783:c8a5:f472 with SMTP id he14-20020a1709073d8e00b00783c8a5f472mr2078023ejc.566.1664447081952;
        Thu, 29 Sep 2022 03:24:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h7-20020a1709066d8700b0073dbaeb50f6sm3787272ejt.169.2022.09.29.03.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 03:24:41 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com
Subject: [patch iproute2-next 2/2] devlink: fix typo in variable name in ifname_map_cb()
Date:   Thu, 29 Sep 2022 12:24:36 +0200
Message-Id: <20220929102436.3047138-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929102436.3047138-1-jiri@resnulli.us>
References: <20220929102436.3047138-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

s/port_ifindex/port_index/

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0e194c9800b7..8c02730b27a9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -782,7 +782,7 @@ static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
 	struct ifname_map *ifname_map;
 	const char *bus_name;
 	const char *dev_name;
-	uint32_t port_ifindex;
+	uint32_t port_index;
 	const char *port_ifname;
 
 	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
@@ -795,10 +795,10 @@ static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
 
 	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
 	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
-	port_ifindex = mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_INDEX]);
+	port_index = mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_INDEX]);
 	port_ifname = mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_NETDEV_NAME]);
 	ifname_map = ifname_map_alloc(bus_name, dev_name,
-				      port_ifindex, port_ifname);
+				      port_index, port_ifname);
 	if (!ifname_map)
 		return MNL_CB_ERROR;
 	list_add(&ifname_map->list, &dl->ifname_map_list);
-- 
2.37.1

