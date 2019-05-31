Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0359331439
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfEaRyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35578 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbfEaRyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:54:16 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD478A14DE;
        Fri, 31 May 2019 17:54:15 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.phx2.redhat.com [10.3.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AA4E600D1;
        Fri, 31 May 2019 17:54:01 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V6] fixup! audit: add containerid filtering
Date:   Fri, 31 May 2019 13:53:36 -0400
Message-Id: <fadb320e38a899441fcc693bbbc822a3b57f1a46.1559239558.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 31 May 2019 17:54:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the BUG() call since we will never have an invalid op value as
audit_data_to_entry()/audit_to_op() ensure that the op value is a a
known good value.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditfilter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 407b5bb3b4c6..385a114a1254 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1244,7 +1244,6 @@ int audit_comparator64(u64 left, u32 op, u64 right)
 	case Audit_bittest:
 		return ((left & right) == right);
 	default:
-		BUG();
 		return 0;
 	}
 }
-- 
1.8.3.1

