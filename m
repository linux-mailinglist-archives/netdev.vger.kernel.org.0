Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BC626685D
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 20:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgIKSo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 14:44:56 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:58684 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgIKSox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 14:44:53 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CE89C2004D;
        Fri, 11 Sep 2020 18:44:52 +0000 (UTC)
Received: from us4-mdac16-52.at1.mdlocal (unknown [10.110.48.101])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CC0FB6009B;
        Fri, 11 Sep 2020 18:44:52 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.7])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 704CA22004D;
        Fri, 11 Sep 2020 18:44:52 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3B3164C0066;
        Fri, 11 Sep 2020 18:44:52 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 19:44:47 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/3] sfc: remove duplicate call to efx_init_channels
 from EF100 probe
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
Message-ID: <e6b38cd6-a9cb-91bb-9602-0cc7f3980801@solarflare.com>
Date:   Fri, 11 Sep 2020 19:44:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-0.505500-8.000000-10
X-TMASE-MatchedRID: VMzsFfHySHOh9oPbMj7PPPCoOvLLtsMhS1zwNuiBtITfUZT83lbkENP+
        kXNq5kuZqgyzmJ7g5Yn0qr9Eb6XCu4zXmvx1b/a8EJ5u/MTQeYd9LQinZ4QefL6qvLNjDYTwIq9
        5DjCZh0wUGm4zriL0oQtuKBGekqUpUfEQFBqv0mffJANE7rzNfVrm/K9YoSETNi2NbVKQEJiLv6
        tAfOunqQQgH9T33Bxnf+L8OZiRQm+8eRmFY48L+5giy0bPLcF4L6Quj+EPJ6rtfQ1SPvnqTJqVX
        UXjGsjz2F+vBZls4K+yaqc7gc0b5ehxodtyrclRwL6SxPpr1/I=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.505500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599849892-KI3BvsZy1P2w
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

efx_init_struct already calls this, we don't need to do it again.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index fb7752d62ce0..3148fe770356 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1200,10 +1200,6 @@ static int ef100_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
-	rc = efx_init_channels(efx);
-	if (rc)
-		goto fail;
-
 	down_write(&efx->filter_sem);
 	rc = ef100_filter_table_probe(efx);
 	up_write(&efx->filter_sem);

