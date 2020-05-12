Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41E91CF5A0
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgELNYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:24:44 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55860 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729461AbgELNYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 09:24:43 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C8E96200E6;
        Tue, 12 May 2020 13:24:42 +0000 (UTC)
Received: from us4-mdac16-58.at1.mdlocal (unknown [10.110.50.151])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C7837800A9;
        Tue, 12 May 2020 13:24:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5657A4007C;
        Tue, 12 May 2020 13:24:42 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1A26B140053;
        Tue, 12 May 2020 13:24:42 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 May
 2020 14:24:37 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/2] sfc: actually wire up siena_check_caps()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <fccfbce7-d9d8-97ad-991a-95f9333121d6@solarflare.com>
Message-ID: <65cdc56b-6101-ce15-c6fc-e02291126a0a@solarflare.com>
Date:   Tue, 12 May 2020 14:24:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <fccfbce7-d9d8-97ad-991a-95f9333121d6@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25414.003
X-TM-AS-Result: No-2.483500-8.000000-10
X-TMASE-MatchedRID: qkiRFh4owgXxE3tIpA2Mw0hwlOfYeSqx3V4UShoTXafalJpeFb3A2Iae
        EkIf7bS3vq4iZZ2piYNTvVffeIwvQwUcfW/oedmqPwKTD1v8YV5MkOX0UoduuU/r0zdg41j+cdQ
        cKpNhse3ZfxIlRtpm4wD/U58aWgn/DPIzF4wRfrA5f9Xw/xqKXZwhktVkBBrQxq9PbUOwsP9QSF
        bL1bvQAVgXepbcl7r7cIM0w5eGrBf6LMpNYhrLwSqwKl8vgqmLhD74XMAjP5XbZghhRnZ8p4HYv
        u6Saa22eNxS5f0IY4EjMUJ0Ny99ViIpVL/C3eRYMcKpXuu/1jVAMwW4rY/0WO2hZq8RbsdETdny
        MokJ1HRyBhhCd0s8837cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.483500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25414.003
X-MDID: 1589289882-3sT7Lkm_T-ZE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assign it to siena_a0_nic_type.check_caps function pointer.

Fixes: be904b855200 ("sfc: make capability checking a nic_type function")
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/siena.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index ed1cb6caa69d..d8b052979b1b 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -1093,4 +1093,5 @@ const struct efx_nic_type siena_a0_nic_type = {
 			     1 << HWTSTAMP_FILTER_PTP_V1_L4_EVENT |
 			     1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT),
 	.rx_hash_key_size = 16,
+	.check_caps = siena_check_caps,
 };

