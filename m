Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C4788734
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 02:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbfHJATD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 20:19:03 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43430 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfHJATD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 20:19:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so16922079qto.10
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 17:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lROwVT+wlc5C0hCROGp6HV+5q8pu73gE5Sg96e6/aNQ=;
        b=VCZ2EVgcEnDNot3RQ2QRJyFhufRMiRgofUWYJyujEOPPsRoGO6qT3SPHLSKZblmWDv
         ZIHO+Jkhs238SEnHoxRjNvoEwdlDcrbCEL4G6FkQ57Z1BIsbUl6PpAmHmeVIJSlKqEga
         jnCREtkgGns6zs98YEAmBUZUFSxkyTYhSnldg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lROwVT+wlc5C0hCROGp6HV+5q8pu73gE5Sg96e6/aNQ=;
        b=eGj77uXpR6fWl63hqkSqWsbEMR7bqjI8Ip9sebXgUAjplQHNhue+MWFrUCkHf8xVT0
         zAwENjcSMrhsZrLpOmf6BjxX5K9+wYpw8el5PZgcPXIK3SElUIl5bXRo531lb3xHJeCI
         NhXwsXj/dz8dhuGyjP1hmEzWIdU0AQqfiHvH6v2sT0PxtyQ214NyT5HMm3Nm9MUJAAaC
         99lDRmofCuztHYzpumKjHJPJwMrc+wQ2NMConXlsZ8bk8SlXIOuIRJ3MJOeS9bjOe64h
         EaKQexb5GJXhYxOcA7CjWCL1t3aRRY8CIEhMll93YgA/bKZd+vvSn02Zw8HiIaKhCQ8/
         N/hw==
X-Gm-Message-State: APjAAAVFZ/ZMPcA0gXg2PsvV5WRNnK9Dpn5JGX/I8z78HaBT3B0ZYcYL
        USdbyukTlXNdCv8llQtlq7oM5SAOK0s=
X-Google-Smtp-Source: APXvYqyQFaQ6hRxrK98GdGO0uWI2FXN7f2izZmaUh0e4wpC/qYo2lZFH/rjpSVmpiG+I/B4Dk7gBnA==
X-Received: by 2002:ac8:53d3:: with SMTP id c19mr20950206qtq.225.1565396341859;
        Fri, 09 Aug 2019 17:19:01 -0700 (PDT)
Received: from robot.nc.rr.com (cpe-2606-A000-111D-8179-B743-207D-F4F9-B992.dyn6.twc.com. [2606:a000:111d:8179:b743:207d:f4f9:b992])
        by smtp.googlemail.com with ESMTPSA id u16sm1230497qkj.107.2019.08.09.17.19.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 17:19:01 -0700 (PDT)
From:   Donald Sharp <sharpd@cumulusnetworks.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: [PATCH 1/2] ip nexthop: Add space to display properly when showing a group
Date:   Fri,  9 Aug 2019 20:18:42 -0400
Message-Id: <20190810001843.32068-2-sharpd@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When displaying a nexthop group made up of other nexthops, the display
line shows this when you have additional data at the end:

id 42 group 43/44/45/46/47/48/49/50/51/52/53/54/55/56/57/58/59/60/61/62/63/64/65/66/67/68/69/70/71/72/73/74proto zebra

Modify code so that it shows:

id 42 group 43/44/45/46/47/48/49/50/51/52/53/54/55/56/57/58/59/60/61/62/63/64/65/66/67/68/69/70/71/72/73/74 proto zebra

Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
---
 ip/ipnexthop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 97f09e74..f35aab52 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -186,6 +186,7 @@ static void print_nh_group(FILE *fp, const struct rtattr *grps_attr)
 
 		close_json_object();
 	}
+	print_string(PRINT_FP, NULL, "%s", " ");
 	close_json_array(PRINT_JSON, NULL);
 }
 
-- 
2.21.0

