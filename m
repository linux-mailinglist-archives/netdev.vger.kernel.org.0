Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6C493DFD
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 17:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353160AbiASQIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 11:08:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356078AbiASQIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 11:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642608485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=U8K7qFYMKSAMGRGCxYXsrjziNFU9WiOr4B1V4YZhIVQ=;
        b=O0VWgUDvrflrQweNPLg8WwtLxXBf9Lr4NZcTLf+nsFF21LWx3b5NhpE+FscNQMjHACPIIP
        155L19j7Ytg6NXl8F1sRIcpodOHeYXey2BPfZxlVL/e6tzKpj2ndhkiANKKZA//ZpbXy3j
        uFZtZIUELqSRjRhSPC7AkWdJeQXdkKM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-CbKyzyFFNQuEVkN1RfOthw-1; Wed, 19 Jan 2022 11:08:03 -0500
X-MC-Unique: CbKyzyFFNQuEVkN1RfOthw-1
Received: by mail-wm1-f72.google.com with SMTP id j18-20020a05600c1c1200b0034aeea95dacso4467168wms.8
        for <netdev@vger.kernel.org>; Wed, 19 Jan 2022 08:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=U8K7qFYMKSAMGRGCxYXsrjziNFU9WiOr4B1V4YZhIVQ=;
        b=CL+wQTN2BWESjN8GJ/9iHA8ekUi7qFWOFvNgZEsk1HRKcanrwCDTa/JwlvpFsl06OS
         Gktd/KhpwZFhV5HVQUbAefTC6zzqa3W9pvON+qZqn9+YvgXyUHIdH7GfIi4ObieibRGg
         SL16aCNah+B2t8Nerl/mKv5ypMFI5qSR98JJL1904RXlLA/PNhPSqczdZ6GFJV6I4HiE
         tBfbPjEsd2a0o7LHCUlsqYHPZeB8qejskIUIxXoMYraqRgD+14v/c97QNuXCYLQ/C6dz
         Nuj9QuCjmAyr2Cm0WEbKhDRznpcolAFMAvNovTf+iu9jiRpx1pbFI2SP2tx3ssCWbC9p
         mecA==
X-Gm-Message-State: AOAM530WmFfZja8eZUY2zninEkrN71rnrY+ZnHkzE82VFLGnP/C5xwNK
        mXdPogyaCfagbKN3YxOQr/vFD+HTqovCN7hIrvBck0OuT/GXLEJukRBVJTjWOBTq9rGt9DW+fH9
        tePyeDUfmFx94cx7p
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr11404989wrd.390.1642608482496;
        Wed, 19 Jan 2022 08:08:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFlY5IOdWFsM/oq+dzXWzGjEM2PA1qjFohHC2j6DgFWGID4u6ke5l6BiC3/eFa2goPUKH/bA==
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr11404969wrd.390.1642608482242;
        Wed, 19 Jan 2022 08:08:02 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l15sm5206031wmh.6.2022.01.19.08.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 08:08:01 -0800 (PST)
Date:   Wed, 19 Jan 2022 17:08:00 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Fernando Gont <fgont@si6networks.com>
Subject: [RFC PATCH net] Revert "ipv6: Honor all IPv6 PIO Valid Lifetime
 values"
Message-ID: <bbf2d9d5ecdc063a110fd35fccdb972b275d0a17.1642607791.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b75326c201242de9495ff98e5d5cff41d7fc0d9d.

This commit breaks Linux compatibility with USGv6 tests. The RFC this
commit was based on is actually an expired draft: no published RFC
currently allows the new behaviour it introduced.

Without full IETF endorsement, the flash renumbering scenario this
patch was supposed to enable is never going to work, as other IPv6
equipements on the same LAN will keep the 2 hours limit.

[Sent as RFC as I'd like to get Fernando's feedback before sending a
formal revert.]

Fixes: b75326c20124 ("ipv6: Honor all IPv6 PIO Valid Lifetime values")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/addrconf.h |  2 ++
 net/ipv6/addrconf.c    | 27 ++++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 78ea3e332688..e7ce719838b5 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -6,6 +6,8 @@
 #define RTR_SOLICITATION_INTERVAL	(4*HZ)
 #define RTR_SOLICITATION_MAX_INTERVAL	(3600*HZ)	/* 1 hour */
 
+#define MIN_VALID_LIFETIME		(2*3600)	/* 2 hours */
+
 #define TEMP_VALID_LIFETIME		(7*86400)
 #define TEMP_PREFERRED_LIFETIME		(86400)
 #define REGEN_MAX_RETRY			(3)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3eee17790a82..f927c199a93c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2589,7 +2589,7 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 __u32 valid_lft, u32 prefered_lft)
 {
 	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
-	int create = 0;
+	int create = 0, update_lft = 0;
 
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
@@ -2633,19 +2633,32 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 		unsigned long now;
 		u32 stored_lft;
 
-		/* Update lifetime (RFC4862 5.5.3 e)
-		 * We deviate from RFC4862 by honoring all Valid Lifetimes to
-		 * improve the reaction of SLAAC to renumbering events
-		 * (draft-gont-6man-slaac-renum-06, Section 4.2)
-		 */
+		/* update lifetime (RFC2462 5.5.3 e) */
 		spin_lock_bh(&ifp->lock);
 		now = jiffies;
 		if (ifp->valid_lft > (now - ifp->tstamp) / HZ)
 			stored_lft = ifp->valid_lft - (now - ifp->tstamp) / HZ;
 		else
 			stored_lft = 0;
-
 		if (!create && stored_lft) {
+			const u32 minimum_lft = min_t(u32,
+				stored_lft, MIN_VALID_LIFETIME);
+			valid_lft = max(valid_lft, minimum_lft);
+
+			/* RFC4862 Section 5.5.3e:
+			 * "Note that the preferred lifetime of the
+			 *  corresponding address is always reset to
+			 *  the Preferred Lifetime in the received
+			 *  Prefix Information option, regardless of
+			 *  whether the valid lifetime is also reset or
+			 *  ignored."
+			 *
+			 * So we should always update prefered_lft here.
+			 */
+			update_lft = 1;
+		}
+
+		if (update_lft) {
 			ifp->valid_lft = valid_lft;
 			ifp->prefered_lft = prefered_lft;
 			ifp->tstamp = now;
-- 
2.21.3

