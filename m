Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7EC19046B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgCXETZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:19:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58587 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725923AbgCXETY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585023563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Hi/88CwN5ak09GkxfVlq0cgk2+svSD4/AYQ4P2AgxU0=;
        b=Cn43S2HqnN87juGho7Jp79mhWuMMDrdvs/Q+v4euQlBO2CXO+0l4EF/sZj6bLQRc1NonQF
        MWqM9fd1+UUn8hS0GGuinGFZvL4zivGi8PbUhacOX0Wt2bQTGDNoYttxrG+RYU1FHxLOV3
        lwyVQkj4s2RCzEPayZ/sGTirEi0Tyqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-JTiFlLUyO7Gk8TvKhFJ9Xg-1; Tue, 24 Mar 2020 00:19:19 -0400
X-MC-Unique: JTiFlLUyO7Gk8TvKhFJ9Xg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02BDE800D50;
        Tue, 24 Mar 2020 04:19:18 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEE27BBBCE;
        Tue, 24 Mar 2020 04:19:13 +0000 (UTC)
Date:   Tue, 24 Mar 2020 05:19:20 +0100
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH net-next] taprio: do not use BIT() in TCA_TAPRIO_ATTR_FLAG_*
 definitions
Message-ID: <20200324041920.GA7068@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BIT() macro definition is internal to the Linux kernel and is not
to be used in UAPI headers; replace its usage with the _BITUL() macro
that is already used elsewhere in the header.

Cc: <stable@vger.kernel.org> # v5.4+
Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 include/uapi/linux/pkt_sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index bbe791b..0e43f67 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1197,8 +1197,8 @@ enum {
  *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
  */
 
-#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	BIT(0)
-#define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	BIT(1)
+#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	_BITUL(0)
+#define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	_BITUL(1)
 
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
-- 
2.1.4

