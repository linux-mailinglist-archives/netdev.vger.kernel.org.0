Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71871F0815
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbfKEVRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:17:31 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34860 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfKEVRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:17:30 -0500
Received: by mail-lj1-f194.google.com with SMTP id r7so14873882ljg.2
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mps6/m7zVOPbnuVxZnVmB3Q8JZ0VgpkbzHnUExkJRQk=;
        b=bq/saNFQnmQxNPZhwHF5kmgrWAcGNNgjwUJy8OIFfi2O0plm1p4hPpFCJ13ZlODr2x
         vatIA8ouE+yWcApmhpCEz/Hdeui9Ipf4/s/yDChuMzMPtn7U4gKj8DomCpzR48AvGmP8
         Et1pjA7Lj7lU/VJ6k+Fc6Nmv+i/J+hommUQPJV5wXYh5myDKEH4RSItDM7iPaWC2Cm9S
         lw4fvAq/UPtfGZYd/TLYW1lWoE/ehaBivBNDvxEvsGf23U2Md/RAxjYAeLoOymbPUGkY
         Q/V9Ia7hVgx8MtkLoYudJ0Z/7JQvKALeJ+Bq35pkQQOsGHTSXztmi3bjK0iQYIVQqv0/
         bmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mps6/m7zVOPbnuVxZnVmB3Q8JZ0VgpkbzHnUExkJRQk=;
        b=hCo5jfF4c02ihaHaAFaB2arV+kQFJIiostMDNnMWm09gvITdZC/BIhF2CoprhwVV6o
         gxY5emhTsysXZ0uJ6kCQNum6n3XtnNCmOu/aTViBNav5kIhANzPeV4+2aa1pNm5G4LAM
         R+FYSG3JvLKEFtdFu9gyJtbWeVVb6NteGRb2i6GDqQ8Ew+9ro512hJIR5NslI99y5Blo
         Rac1fWAYUvV6ebHyV3SHw+7zB/dsM9hZKzT7qSk5AabQ+rsMW4PTbrMVA1vkDJ1AOlco
         7tp4SJBbo4FKTHbubTdGAB6VZ814mGYbzTUXpdBmV9RNvaLEpyB6nk+73EmUPHZDUSZk
         9olQ==
X-Gm-Message-State: APjAAAVORLtK0wEMErfCBubIk6Kskp1GBFyQ/KSxWX11+WSTapNBAUhh
        dFUGuNBfY2yJ9rmXaqHAuGahFQ==
X-Google-Smtp-Source: APXvYqzOrhIND9VhXsXCk9Zrj8VlR8D9+gMPcJQfK02i5sZ6481+i5rHdVQgTj6qv/Y8ZkA+N8Swcw==
X-Received: by 2002:a2e:9842:: with SMTP id e2mr304289ljj.93.1572988648288;
        Tue, 05 Nov 2019 13:17:28 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 81sm9861270lje.70.2019.11.05.13.17.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:17:27 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, jiri@resnulli.us,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH iproute2-next 3/3] devlink: allow full range of resource sizes
Date:   Tue,  5 Nov 2019 13:17:07 -0800
Message-Id: <20191105211707.10300-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105211707.10300-1-jakub.kicinski@netronome.com>
References: <20191105211707.10300-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resource size is a 64 bit attribute at netlink level.
Make the command line argument 64 bit as well.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 devlink/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index e05a2336787a..ea3f992ee0d7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -283,7 +283,7 @@ struct dl_opts {
 	bool dpipe_counters_enable;
 	bool eswitch_encap_mode;
 	const char *resource_path;
-	uint32_t resource_size;
+	uint64_t resource_size;
 	uint32_t resource_id;
 	bool resource_id_valid;
 	const char *param_name;
@@ -1348,7 +1348,7 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 		} else if (dl_argv_match(dl, "size") &&
 			   (o_all & DL_OPT_RESOURCE_SIZE)) {
 			dl_arg_inc(dl);
-			err = dl_argv_uint32_t(dl, &opts->resource_size);
+			err = dl_argv_uint64_t(dl, &opts->resource_size);
 			if (err)
 				return err;
 			o_found |= DL_OPT_RESOURCE_SIZE;
-- 
2.23.0

