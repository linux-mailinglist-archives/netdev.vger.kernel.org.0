Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFA5276552
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgIXAnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:43:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD36C0613CE;
        Wed, 23 Sep 2020 17:43:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fa1so697418pjb.0;
        Wed, 23 Sep 2020 17:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=QGiZuyOhBsyDMn34jUw4Mef+BAwK61DoxBfC7U80OjA=;
        b=hgQsr8S+HgIq8SCrnVjyY90PXVkIqHqEBBVhd9CkTZUvr6BENK9D+yrPsrwiKaUkU/
         qkKvtdrHMGU5fd2Q4UU5WGTt8xs5B9aM62jwHcbpXFJ8WNEy56DpJTx8VX2WlL42ZDwT
         O9oTKLAhmToLG8z5uw+qR/5vN+ghdx4OFWN/eZWdXYx1PioY1Gkw0L5PIlDaIr2tNwD7
         p2YqH+Iy70GNw2YsvW/g1duXdhb6BlmNZvGI5UZgqEg7w2m546qprNRLwX9MOIfBMlQo
         A8nZBLnnngCnkjEbjua+e2nQ96hMJIyL5n8JtPal0yBsC/kMhp45MQReUyUw8eXGpkwg
         r4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=QGiZuyOhBsyDMn34jUw4Mef+BAwK61DoxBfC7U80OjA=;
        b=ZqVg+UgPGjp6O4gAvZ6t+Caorv9RaYfMb2E7ohEkxebXQZP7KUVOKQfmkO1hCqeV3Q
         k/RQdTXx0pyk4t0knDlL3Vci8cXszQTKSsPbUQx+1f5/Io2oAIDxQ7q2RoUUQ8XAt9mp
         cG/nqny1s+8OQ2+gtYcTOPrEpEklJNWEdeASLPj9Lo9wnGkGOa07L1k5T8LhiHec+JMR
         qFxokfVpCZyVO5fOXq/CrTApT75XQljUw3b8TBixCwVvNmjzijnUovo2m0T2w5bCpgbd
         c8fkUjyGWCSbf60u1fqb+VoT55mZXckg/qI8NyGGwIAebVQce2HDFNFunUnto9Wn1PdX
         xZpQ==
X-Gm-Message-State: AOAM5331QYOmYZk7vTkZ2zmsiiz6AcUEQaTbdrihZPYuw4AmvRHX37Dq
        O9XUGLTA2+44yqVE3bEwsdI=
X-Google-Smtp-Source: ABdhPJyOuCA1tE3J6JV3ThR6U5W78vQRK6WeLpHcD6G8mdtgdHFKvkkimOU2x9NORvnjOlMdW/cnEw==
X-Received: by 2002:a17:90b:1283:: with SMTP id fw3mr1657560pjb.60.1600908214281;
        Wed, 23 Sep 2020 17:43:34 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id 6sm900233pgu.16.2020.09.23.17.43.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:43:33 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [MPTCP][PATCH net-next 05/16] mptcp: add ADD_ADDR related mibs
Date:   Thu, 24 Sep 2020 08:29:51 +0800
Message-Id: <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com> <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added two mibs for ADD_ADDR, MPTCP_MIB_ADDADDR for receiving
of the ADD_ADDR suboption with echo-flag=0, and MPTCP_MIB_ECHOADD for
receiving the ADD_ADDR suboption with echo-flag=1.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/mib.c     | 2 ++
 net/mptcp/mib.h     | 2 ++
 net/mptcp/options.c | 7 ++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 056986c7a228..a33bf719ce6f 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -27,6 +27,8 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("OFOMerge", MPTCP_MIB_OFOMERGE),
 	SNMP_MIB_ITEM("NoDSSInWindow", MPTCP_MIB_NODSSWINDOW),
 	SNMP_MIB_ITEM("DuplicateData", MPTCP_MIB_DUPDATA),
+	SNMP_MIB_ITEM("AddAddr", MPTCP_MIB_ADDADDR),
+	SNMP_MIB_ITEM("EchoAdd", MPTCP_MIB_ECHOADD),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 937a177729f1..cdeea3732ddf 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -20,6 +20,8 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_OFOMERGE,		/* Segments merged in OoO queue */
 	MPTCP_MIB_NODSSWINDOW,		/* Segments not in MPTCP windows */
 	MPTCP_MIB_DUPDATA,		/* Segments discarded due to duplicate DSS */
+	MPTCP_MIB_ADDADDR,		/* Received ADD_ADDR with echo-flag=0 */
+	MPTCP_MIB_ECHOADD,		/* Received ADD_ADDR with echo-flag=1 */
 	__MPTCP_MIB_MAX
 };
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index a41996e6c6d7..171039cbe9c4 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -11,6 +11,7 @@
 #include <net/tcp.h>
 #include <net/mptcp.h>
 #include "protocol.h"
+#include "mib.h"
 
 static bool mptcp_cap_flag_sha256(u8 flags)
 {
@@ -888,8 +889,12 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 			addr.addr6 = mp_opt.addr6;
 		}
 #endif
-		if (!mp_opt.echo)
+		if (!mp_opt.echo) {
 			mptcp_pm_add_addr_received(msk, &addr);
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ADDADDR);
+		} else {
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ECHOADD);
+		}
 		mp_opt.add_addr = 0;
 	}
 
-- 
2.17.1

