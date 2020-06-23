Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00532068B0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbgFWXx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387850AbgFWXxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:53:24 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A53C061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:22 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h185so215542pfg.2
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3mEJDzaWQ4l091KLnMAOuiONSZwy+jNM1y+BZ46c1vg=;
        b=NSsimIa0Zdja+mljoI1xzE1d06iK3b2dekprE/MFh6FlMx8bOuC/9ybnjUf434S54Q
         QqKO6WbW8Bp2nm0SnqiZO9LFnsyMDoc7sOy14BxJ52AFC2z4T6GboVHu70Vnyaszva6s
         0YkwFxVRB5Mw0b6qpjoWNcmPJ3fhRyECuLuOmvfhbE0yUUDU3hkrLjTIzj5auXb3xPhe
         eiVvpQsUl1DuPNmX1ptIxzigeOL4vEmdjcyM57+eU1w563tWziyodmi4JopNXZKI6qOj
         Nr99JeYFmDMhp9o5tU/L+yjjlZ4ohSMJLbY0UOSJ0jJBNEQihpa7ux4cspO0aX/ne8a6
         90yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3mEJDzaWQ4l091KLnMAOuiONSZwy+jNM1y+BZ46c1vg=;
        b=aXah5vUweVW0BRkMwUMp/xu74PU7DWfFMfQbVW6MPeohsJRU6HJdLEehyYgxm2JqQl
         CsbCtb86S42NNptgSkA/7Ppu1PafXKdLfhx5zU/MoLntVuDZvMh5Zll/Vs0h9PwSAo4j
         36vIF8r2yKGmLfu9ks44qw6pSfVF+bq33bcDvTd3gcwiSL6eAUCr3muMlO2OcoJTrhuO
         ofFh1AFpwnQez+62RdkI2KHcsyLqG8kNz2nH6x6syoTX/NnCMB5YQZf61KTet+PJhbv0
         QCVGXGQOK/JWdBU4KgCkK5GD+f0asufHBR1d12n4Y5R90HI0BLrbojnsEbsyUshk26Am
         WcwQ==
X-Gm-Message-State: AOAM530OTo4grKWIjjojtzzL4RusttRq5S5ZiyinJfbeEtoSQcput0dD
        m6/bKaTc9sA5k9n5/uT/uUuV2x/XSMc=
X-Google-Smtp-Source: ABdhPJwhVi82SRSi7QwaLXB22/8Ff6VhhBkuTxQtpBnxecd/2OdUJU8ZGrdoZM+U80D8dvoXssTj+Q==
X-Received: by 2002:aa7:9599:: with SMTP id z25mr28556123pfj.176.1592956401284;
        Tue, 23 Jun 2020 16:53:21 -0700 (PDT)
Received: from hermes.corp.microsoft.com (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 23sm18096521pfy.199.2020.06.23.16.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 16:53:20 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 4/5] ip: replace slave_kind
Date:   Tue, 23 Jun 2020 16:53:06 -0700
Message-Id: <20200623235307.9216-5-stephen@networkplumber.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623235307.9216-1-stephen@networkplumber.org>
References: <20200623235307.9216-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of slave_kind, rename variable to sub_kind
to describe the kind of sub-device that is being looked for
when filtering messages.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ip_common.h | 2 +-
 ip/ipaddress.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index d604f7554405..7d0c9f57745a 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -23,7 +23,7 @@ struct link_filter {
 	int group;
 	int master;
 	char *kind;
-	char *slave_kind;
+	char *sub_kind;
 	int target_nsid;
 };
 
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index f97eaff3dbbf..4cbff38c9834 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -924,7 +924,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 	if (filter.kind && match_link_kind(tb, filter.kind, 0))
 		return -1;
 
-	if (filter.slave_kind && match_link_kind(tb, filter.slave_kind, 1))
+	if (filter.sub_kind && match_link_kind(tb, filter.sub_kind, 1))
 		return -1;
 
 	if (n->nlmsg_type == RTM_DELLINK)
@@ -2012,7 +2012,7 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 			soff = strlen(*argv) - strlen("_slave");
 			if (!strcmp(*argv + soff, "_slave")) {
 				(*argv)[soff] = '\0';
-				filter.slave_kind = *argv;
+				filter.sub_kind = *argv;
 			} else {
 				filter.kind = *argv;
 			}
-- 
2.26.2

