Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467A723AE30
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgHCUdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:33:31 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:46554 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbgHCUdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:33:31 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 985A620063;
        Mon,  3 Aug 2020 20:33:29 +0000 (UTC)
Received: from us4-mdac16-2.at1.mdlocal (unknown [10.110.49.148])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 96E22600A1;
        Mon,  3 Aug 2020 20:33:29 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2B2D722007D;
        Mon,  3 Aug 2020 20:33:29 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D37B080069;
        Mon,  3 Aug 2020 20:33:28 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug 2020
 21:33:23 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 03/11] sfc_ef100: read Design Parameters at probe
 time
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
Message-ID: <827807a1-c4d6-d7de-7e9c-939d927d66cc@solarflare.com>
Date:   Mon, 3 Aug 2020 21:33:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25582.002
X-TM-AS-Result: No-6.912200-8.000000-10
X-TMASE-MatchedRID: EacATdqaQAALYCfOeHh8DjQ60lWQoG0rUzwbjSjBu8oMhhD4aDyhmqlO
        2ekqlDI6R7vEOuechPalvp1fR7/0cJE4FU2ZdQO4J2be3zx+/IXo2Cux658RNyNGK7UC7ElMkrF
        bakGQlLOtbvTZLoYFq1O9V994jC9DBRx9b+h52aqcVWc2a+/ju0tc8DbogbSE31GU/N5W5BCshW
        1Z4+VEkShJ0SoNDv1XFlstIIdIlIqDDCN+W+LMCasjNHD8MNzMa01mhnn7t6QELMPQNzyJS/I8k
        vclw7r9gWBWfbSzlIxX1JbviZAWOD7WZSHHb/5MdXu122+iJtrqobkz1A0A7U4QgsE4F6YvKHpS
        M6RPsvIS/kWI1mzgCnOvtc0MMD6w8IpFUQRhzYlN8YMQkdZHW6DzzrtsjCZTjiLABC6i+1ih8Fn
        /K/Pq59n50MPBTQBBd2vyAR/hu0+39BLh6Bkc7oOsh+/HtOZFccy0Gdkm5+Synk7TnYzMum8CWe
        5rQ2btiDFPhJ/RPOcLUNc6hf6qqRzMQ+uqdjzCSMFvyr5L84LpSt30EpL0kSZ64w1JA4nGa0he/
        2HwBSa1JtXUAyqYgCjDJ12jkXLcmw72jSYg2inBLypRtAo4yFoR8WAKiZ2PkOBHeeXGAHo/J5SK
        nlHdbcosH3VTwRFRPGiKt6R9GUwSjC5c65mLwBIRh9wkXSlF9teeW6UfkyB8Tu6cvkQQvGtnb/J
        eB4FSjVpI84qMkoq/NErVbjJFCAUKfnD5eilYngIgpj8eDcC063Wh9WVqgtZE3xJMmmXc+gtHj7
        OwNO2hIFEOnNzicGlB+Yg38mL2YOeP1jHIh0wj0w0afb1nEhp59yRCoWZcVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.912200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25582.002
X-MDID: 1596486809-P70_bbdbF_m8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several parts of the EF100 architecture are parameterised (to allow
 varying capabilities on FPGAs according to resource constraints), and
 these parameters are exposed to the driver through a TLV-encoded
 region of the BAR.
For the most part we either don't care about these values at all or
 just need to sanity-check them against the driver's assumptions, but
 there are a number of TSO limits which we record so that we will be
 able to check against them in the TX path when handling GSO skbs.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 216 +++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h |   4 +
 2 files changed, 220 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index c2bec2bdbc1f..9b5e4b42fe51 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -515,6 +515,208 @@ static int compare_versions(const char *a, const char *b)
 	return a_patch - b_patch;
 }
 
+enum ef100_tlv_state_machine {
+	EF100_TLV_TYPE,
+	EF100_TLV_TYPE_CONT,
+	EF100_TLV_LENGTH,
+	EF100_TLV_VALUE
+};
+
+struct ef100_tlv_state {
+	enum ef100_tlv_state_machine state;
+	u64 value;
+	u32 value_offset;
+	u16 type;
+	u8 len;
+};
+
+static int ef100_tlv_feed(struct ef100_tlv_state *state, u8 byte)
+{
+	switch (state->state) {
+	case EF100_TLV_TYPE:
+		state->type = byte & 0x7f;
+		state->state = (byte & 0x80) ? EF100_TLV_TYPE_CONT
+					     : EF100_TLV_LENGTH;
+		/* Clear ready to read in a new entry */
+		state->value = 0;
+		state->value_offset = 0;
+		return 0;
+	case EF100_TLV_TYPE_CONT:
+		state->type |= byte << 7;
+		state->state = EF100_TLV_LENGTH;
+		return 0;
+	case EF100_TLV_LENGTH:
+		state->len = byte;
+		/* We only handle TLVs that fit in a u64 */
+		if (state->len > sizeof(state->value))
+			return -EOPNOTSUPP;
+		/* len may be zero, implying a value of zero */
+		state->state = state->len ? EF100_TLV_VALUE : EF100_TLV_TYPE;
+		return 0;
+	case EF100_TLV_VALUE:
+		state->value |= ((u64)byte) << (state->value_offset * 8);
+		state->value_offset++;
+		if (state->value_offset >= state->len)
+			state->state = EF100_TLV_TYPE;
+		return 0;
+	default: /* state machine error, can't happen */
+		WARN_ON_ONCE(1);
+		return -EIO;
+	}
+}
+
+static int ef100_process_design_param(struct efx_nic *efx,
+				      const struct ef100_tlv_state *reader)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+
+	switch (reader->type) {
+	case ESE_EF100_DP_GZ_PAD: /* padding, skip it */
+		return 0;
+	case ESE_EF100_DP_GZ_PARTIAL_TSTAMP_SUB_NANO_BITS:
+		/* Driver doesn't support timestamping yet, so we don't care */
+		return 0;
+	case ESE_EF100_DP_GZ_EVQ_UNSOL_CREDIT_SEQ_BITS:
+		/* Driver doesn't support unsolicited-event credits yet, so
+		 * we don't care
+		 */
+		return 0;
+	case ESE_EF100_DP_GZ_NMMU_GROUP_SIZE:
+		/* Driver doesn't manage the NMMU (so we don't care) */
+		return 0;
+	case ESE_EF100_DP_GZ_RX_L4_CSUM_PROTOCOLS:
+		/* Driver uses CHECKSUM_COMPLETE, so we don't care about
+		 * protocol checksum validation
+		 */
+		return 0;
+	case ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN:
+		nic_data->tso_max_hdr_len = min_t(u64, reader->value, 0xffff);
+		return 0;
+	case ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS:
+		/* We always put HDR_NUM_SEGS=1 in our TSO descriptors */
+		if (!reader->value) {
+			netif_err(efx, probe, efx->net_dev,
+				  "TSO_MAX_HDR_NUM_SEGS < 1\n");
+			return -EOPNOTSUPP;
+		}
+		return 0;
+	case ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY:
+	case ESE_EF100_DP_GZ_TXQ_SIZE_GRANULARITY:
+		/* Our TXQ and RXQ sizes are always power-of-two and thus divisible by
+		 * EFX_MIN_DMAQ_SIZE, so we just need to check that
+		 * EFX_MIN_DMAQ_SIZE is divisible by GRANULARITY.
+		 * This is very unlikely to fail.
+		 */
+		if (EFX_MIN_DMAQ_SIZE % reader->value) {
+			netif_err(efx, probe, efx->net_dev,
+				  "%s size granularity is %llu, can't guarantee safety\n",
+				  reader->type == ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY ? "RXQ" : "TXQ",
+				  reader->value);
+			return -EOPNOTSUPP;
+		}
+		return 0;
+	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN:
+		nic_data->tso_max_payload_len = min_t(u64, reader->value, GSO_MAX_SIZE);
+		efx->net_dev->gso_max_size = nic_data->tso_max_payload_len;
+		return 0;
+	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS:
+		nic_data->tso_max_payload_num_segs = min_t(u64, reader->value, 0xffff);
+		efx->net_dev->gso_max_segs = nic_data->tso_max_payload_num_segs;
+		return 0;
+	case ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES:
+		nic_data->tso_max_frames = min_t(u64, reader->value, 0xffff);
+		return 0;
+	case ESE_EF100_DP_GZ_COMPAT:
+		if (reader->value) {
+			netif_err(efx, probe, efx->net_dev,
+				  "DP_COMPAT has unknown bits %#llx, driver not compatible with this hw\n",
+				  reader->value);
+			return -EOPNOTSUPP;
+		}
+		return 0;
+	case ESE_EF100_DP_GZ_MEM2MEM_MAX_LEN:
+		/* Driver doesn't use mem2mem transfers */
+		return 0;
+	case ESE_EF100_DP_GZ_EVQ_TIMER_TICK_NANOS:
+		/* Driver doesn't currently use EVQ_TIMER */
+		return 0;
+	case ESE_EF100_DP_GZ_NMMU_PAGE_SIZES:
+		/* Driver doesn't manage the NMMU (so we don't care) */
+		return 0;
+	case ESE_EF100_DP_GZ_VI_STRIDES:
+		/* We never try to set the VI stride, and we don't rely on
+		 * being able to find VIs past VI 0 until after we've learned
+		 * the current stride from MC_CMD_GET_CAPABILITIES.
+		 * So the value of this shouldn't matter.
+		 */
+		if (reader->value != ESE_EF100_DP_GZ_VI_STRIDES_DEFAULT)
+			netif_dbg(efx, probe, efx->net_dev,
+				  "NIC has other than default VI_STRIDES (mask "
+				  "%#llx), early probing might use wrong one\n",
+				  reader->value);
+		return 0;
+	case ESE_EF100_DP_GZ_RX_MAX_RUNT:
+		/* Driver doesn't look at L2_STATUS:LEN_ERR bit, so we don't
+		 * care whether it indicates runt or overlength for any given
+		 * packet, so we don't care about this parameter.
+		 */
+		return 0;
+	default:
+		/* Host interface says "Drivers should ignore design parameters
+		 * that they do not recognise."
+		 */
+		netif_dbg(efx, probe, efx->net_dev,
+			  "Ignoring unrecognised design parameter %u\n",
+			  reader->type);
+		return 0;
+	}
+}
+
+static int ef100_check_design_params(struct efx_nic *efx)
+{
+	struct ef100_tlv_state reader = {};
+	u32 total_len, offset = 0;
+	efx_dword_t reg;
+	int rc = 0, i;
+	u32 data;
+
+	efx_readd(efx, &reg, ER_GZ_PARAMS_TLV_LEN);
+	total_len = EFX_DWORD_FIELD(reg, EFX_DWORD_0);
+	netif_dbg(efx, probe, efx->net_dev, "%u bytes of design parameters\n",
+		  total_len);
+	while (offset < total_len) {
+		efx_readd(efx, &reg, ER_GZ_PARAMS_TLV + offset);
+		data = EFX_DWORD_FIELD(reg, EFX_DWORD_0);
+		for (i = 0; i < sizeof(data); i++) {
+			rc = ef100_tlv_feed(&reader, data);
+			/* Got a complete value? */
+			if (!rc && reader.state == EF100_TLV_TYPE)
+				rc = ef100_process_design_param(efx, &reader);
+			if (rc)
+				goto out;
+			data >>= 8;
+			offset++;
+		}
+	}
+	/* Check we didn't end halfway through a TLV entry, which could either
+	 * mean that the TLV stream is truncated or just that it's corrupted
+	 * and our state machine is out of sync.
+	 */
+	if (reader.state != EF100_TLV_TYPE) {
+		if (reader.state == EF100_TLV_TYPE_CONT)
+			netif_err(efx, probe, efx->net_dev,
+				  "truncated design parameter (incomplete type %u)\n",
+				  reader.type);
+		else
+			netif_err(efx, probe, efx->net_dev,
+				  "truncated design parameter %u\n",
+				  reader.type);
+		rc = -EIO;
+	}
+out:
+	return rc;
+}
+
 /*	NIC probe and remove
  */
 static int ef100_probe_main(struct efx_nic *efx)
@@ -536,6 +738,20 @@ static int ef100_probe_main(struct efx_nic *efx)
 	net_dev->features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
 
+	/* Populate design-parameter defaults */
+	nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
+	nic_data->tso_max_frames = ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES_DEFAULT;
+	nic_data->tso_max_payload_num_segs = ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS_DEFAULT;
+	nic_data->tso_max_payload_len = ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN_DEFAULT;
+	net_dev->gso_max_segs = ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT;
+	/* Read design parameters */
+	rc = ef100_check_design_params(efx);
+	if (rc) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Unsupported design parameters\n");
+		goto fail;
+	}
+
 	/* we assume later that we can copy from this buffer in dwords */
 	BUILD_BUG_ON(MCDI_CTL_SDU_LEN_MAX_V2 % 4);
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 6367bbb2c9b3..c8816bc6ae78 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -26,6 +26,10 @@ struct ef100_nic_data {
 	u16 warm_boot_count;
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
+	u16 tso_max_hdr_len;
+	u16 tso_max_payload_num_segs;
+	u16 tso_max_frames;
+	unsigned int tso_max_payload_len;
 };
 
 #define efx_ef100_has_cap(caps, flag) \

