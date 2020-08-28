Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D12B256003
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 19:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgH1Rug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 13:50:36 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37452 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726851AbgH1Rue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 13:50:34 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7FD812009D;
        Fri, 28 Aug 2020 17:50:33 +0000 (UTC)
Received: from us4-mdac16-14.at1.mdlocal (unknown [10.110.49.196])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7D8D26009B;
        Fri, 28 Aug 2020 17:50:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 203CB220064;
        Fri, 28 Aug 2020 17:50:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DE747300075;
        Fri, 28 Aug 2020 17:50:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 28 Aug
 2020 18:50:28 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/4] sfc: fix unused-but-set-variable warning in
 efx_farch_filter_remove_safe
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Message-ID: <3657cf56-7932-b7a7-c1a4-ccb09c22aca1@solarflare.com>
Date:   Fri, 28 Aug 2020 18:50:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25630.005
X-TM-AS-Result: No-3.676100-8.000000-10
X-TMASE-MatchedRID: h6XSCbWy5yZ4iHWtbxtYeXTzPL3sqyAmhnpDm0ThsHRUjspoiX02F8uJ
        MhEV0ko3epaZg6Zo1fBTvVffeIwvQwUcfW/oedmqPwKTD1v8YV5MkOX0UoduuS6Zl5fVYhDwTQF
        fM0Uvf4yx8v2Vu083cJGTpe1iiCJq71zr0FZRMbALbigRnpKlKZvjAepGmdoOjz5CgJ9QnBgNlP
        BKL2AyuO6hzTSOn3i99pQ1094uqCOm0UjKKERfTWMy62m1hq8PleFQ+isISX4lhxsZ4KgbwIH1U
        RjLiLhB7X0NUj756kyalV1F4xrI89hfrwWZbOCvsmqnO4HNG+XDa0xNKDTHvg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.676100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25630.005
X-MDID: 1598637033-H-z6NqU3_9zp
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to some past refactor, 'spec' is not actually used in this
 function; the code using it moved to the callee efx_farch_filter_remove.
Remove the variable to fix a W=1 warning.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/farch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index aff2974e66df..0d9795fb9356 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -2589,7 +2589,6 @@ int efx_farch_filter_remove_safe(struct efx_nic *efx,
 	enum efx_farch_filter_table_id table_id;
 	struct efx_farch_filter_table *table;
 	unsigned int filter_idx;
-	struct efx_farch_filter_spec *spec;
 	int rc;
 
 	table_id = efx_farch_filter_id_table_id(filter_id);
@@ -2601,7 +2600,6 @@ int efx_farch_filter_remove_safe(struct efx_nic *efx,
 	if (filter_idx >= table->size)
 		return -ENOENT;
 	down_write(&state->lock);
-	spec = &table->spec[filter_idx];
 
 	rc = efx_farch_filter_remove(efx, table, filter_idx, priority);
 	up_write(&state->lock);

