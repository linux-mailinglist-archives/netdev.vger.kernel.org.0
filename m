Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E0922EB9B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgG0L7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:59:34 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55176 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbgG0L7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:59:34 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0FCD960085;
        Mon, 27 Jul 2020 11:59:34 +0000 (UTC)
Received: from us4-mdac16-45.ut7.mdlocal (unknown [10.7.64.27])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0E5258009E;
        Mon, 27 Jul 2020 11:59:34 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9504880051;
        Mon, 27 Jul 2020 11:59:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4DC3A1C005F;
        Mon, 27 Jul 2020 11:59:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 12:59:28 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v5 net-next 12/16] sfc_ef100: extend ef100_check_caps to cover
 datapath_caps3
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Message-ID: <1a29c7b2-a8a2-e9ab-a24e-ff2b41450068@solarflare.com>
Date:   Mon, 27 Jul 2020 12:59:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25566.005
X-TM-AS-Result: No-0.537000-8.000000-10
X-TMASE-MatchedRID: HGvy3W1xOqbAFhNmLe+SeQ3Tep90J3uQjWxMBBCscchjLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ5JHng0ZlUyJLlmMfLNiukaCSe
        XNitdbfG+9mDuGGWszugtChoj0LN9krMo37I6x/7M0ihsfYPMYeqhuTPUDQDtqRCprJ0QRqpkkl
        sSINyH/CH6jxfQvhjo8S2oX7mSTl9qpXWtxrBsQZ4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTtHtexZ1+/9PljTjvZfyEznZSNbW8rBO89uBHytVzfNYVh717v4DahtIgg0yU7BE/Mi73u
        kOQeL3JiOZNXtMsQsd8x1HVmj3L//PjlqgvcSwB85uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwv
        JjiAfi8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.537000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595851174-Jx03dOmNkmyg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MC_CMD_GET_CAPABILITIES now has a third word of flags; extend the
 efx_has_cap() machinery to cover it.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 9 ++++++++-
 drivers/net/ethernet/sfc/ef100_nic.h | 1 +
 drivers/net/ethernet/sfc/mcdi.h      | 4 ++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 3fb81d6e8df3..bb246acca574 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -128,7 +128,7 @@ static void ef100_mcdi_reboot_detected(struct efx_nic *efx)
  */
 static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 {
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V4_OUT_LEN);
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
 	struct ef100_nic_data *nic_data = efx->nic_data;
 	u8 vi_window_mode;
 	size_t outlen;
@@ -150,6 +150,11 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 					     GET_CAPABILITIES_OUT_FLAGS1);
 	nic_data->datapath_caps2 = MCDI_DWORD(outbuf,
 					      GET_CAPABILITIES_V2_OUT_FLAGS2);
+	if (outlen < MC_CMD_GET_CAPABILITIES_V7_OUT_LEN)
+		nic_data->datapath_caps3 = 0;
+	else
+		nic_data->datapath_caps3 = MCDI_DWORD(outbuf,
+						      GET_CAPABILITIES_V7_OUT_FLAGS3);
 
 	vi_window_mode = MCDI_BYTE(outbuf,
 				   GET_CAPABILITIES_V3_OUT_VI_WINDOW_MODE);
@@ -346,6 +351,8 @@ static unsigned int ef100_check_caps(const struct efx_nic *efx,
 		return nic_data->datapath_caps & BIT_ULL(flag);
 	case MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS2_OFST:
 		return nic_data->datapath_caps2 & BIT_ULL(flag);
+	case MC_CMD_GET_CAPABILITIES_V8_OUT_FLAGS3_OFST:
+		return nic_data->datapath_caps3 & BIT_ULL(flag);
 	default:
 		return 0;
 	}
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 392611cc33b5..7744ec85bec6 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -22,6 +22,7 @@ struct ef100_nic_data {
 	struct efx_buffer mcdi_buf;
 	u32 datapath_caps;
 	u32 datapath_caps2;
+	u32 datapath_caps3;
 	u16 warm_boot_count;
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 };
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index e053adfe82b0..658cf345420d 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -327,10 +327,10 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	EFX_QWORD_FIELD(_ev, MCDI_EVENT_ ## _field)
 
 #define MCDI_CAPABILITY(field)						\
-	MC_CMD_GET_CAPABILITIES_V4_OUT_ ## field ## _LBN
+	MC_CMD_GET_CAPABILITIES_V8_OUT_ ## field ## _LBN
 
 #define MCDI_CAPABILITY_OFST(field) \
-	MC_CMD_GET_CAPABILITIES_V4_OUT_ ## field ## _OFST
+	MC_CMD_GET_CAPABILITIES_V8_OUT_ ## field ## _OFST
 
 #define efx_has_cap(efx, field) \
 	efx->type->check_caps(efx, \

