Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8D321BF6F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgGJV46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:56:58 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbgGJV44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:56:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TM1QdaisJsBo8K5+4x5J9vx8zZDLPAQpqu/9Og0p2rWFlqE4GIwH+dadpV4nh3RW+3vszshCClYBSsEqtwIRdHiI1TRIv2uzt0s8R4QsM05m8JkDSDtnWRaUI7Vle0VdHMP3wDpczVbCNgmAn5J33u1GrQC0ZiYFwzmb/GMhiU1USOAInDYe5fP6HPu0JiWIbd2AEAJKpaFdP1wFSC0Dd78kaPxtlLWXEn26OWtR5Deo4WSwqeXPCCH6OGoGCrDFXp8ISWlhtmOR9bRI+bdCf4K+49fhS66wwaU8UpMwLIiq313U00VpkjhrlmuDiUvKa1NZaKeVmn3LMylHSOOseA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZKMnppMRkLqXvleDJ77kY/DVYbXkUa6wNw7TiG+C8I=;
 b=lE4dd5FQav/jEgnoPUZGjX00rp+jKuWqrzCiQHkIgV77sEn+n2wC5j6yOO/Tf9inugZC+3EZfmaufCbEyupaCQtqHFMW6NpXfl1hI/GmNqGkxMayNfS2awkm8j937Q4UYO6hkBF54esbw55jf7ET+aNnDoFyChA4bpRhxdg6Lwx5/AgTIfd6M5GgDfdSvUxiiiCBI4rW/YGgoHzQMIxubQ9qvTaIRQfu9Edcy86BM8xk1eyUlOaBcF2HjXYA4tmPiw6t8+EHXbU2aj8Lb+iYSh/oMgENeYr8AOd7605aaI2vbsugyQsO70ru2N4v/nvHzMuiPW4Mvo7m7D5Qld+8aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZKMnppMRkLqXvleDJ77kY/DVYbXkUa6wNw7TiG+C8I=;
 b=DFfxs1goDmqfVz9oTl9ba/ed7o5cMiAbj+HZqMWUlQr2r2VbPBmAD3ogPkVsXttk1uz+JpCQ/plWoLc+1F9ajpOFDRGjx2RP3DlTbh9JBTkrLw5yIpEumI2Xa2UmkUfIHv0Csskkqa6wkWaXH8C5OTNBkUDYjeqmoyMwLSxy9c4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:47 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:47 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH net-next v2 03/13] mlxsw: reg: Add Monitoring Port Analyzer Global Register
Date:   Sat, 11 Jul 2020 00:55:05 +0300
Message-Id: <9dcd15d7eb93717a519b949b71e7d754b83c5392.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:44 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eab0f0b0-9c8f-415a-c423-08d8251c240e
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354A9211AF06265AA4A481DDB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d8PU7L/lvoLgqiQDo1iYXsTFt3VVafNBlYLrf5fh5sTzFRVbmRlyvmVNIOmuQ/4VgeL3V0gwyy0l+EsVzI5VGNRgJ9kAH1ZPDKcE8ajS4zz6nN35EvrNwj20Hyw9pS6u3mo3olm1MxT/J9MJHcGd3DWpImFthy87Gx2CKdYP7ttxNDFWzcjXcsUb5jG5G9MjWembdYdd8D0g4PibBDKNIPuBqBJIwfSoVDZaYVWEtLob4LROpFpVzCFKz8vEBnatiWHM6bnNCzU8YDrswV4vdvHdz86Si/fhEcZnBBzzVtVSts0mfvazDd/J4Uq0XQpVzBw5lIuqyCqQn2S3M0UsKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Z8HRHH1rbzIzvu/NL4WpOdJw1e0kX0WVpWSkzrBnWxojg7fh44PUfPx136RdrGSNQT30XSDbeLIfiX+7OqDLVIrAduJZYYaQIdaEYuTva4+NDCpCW8Eqw9woIFHwwZ1AeDnlsIxC7vusX1ge2uFjYApobpb5Yt186N1j89hAbuKnVGRpbPlv5q8Q9L4M5EXYGpx5Zz2ZYJHlPS4YTopAX/KGtqPCNBXWFPnuYD/fnWIuW5JmLpdk0C2n28k4bfgz4JZCClWvynQ9c1aQcK6nY7gVQ4FAj7o7UKUjPRnrq8yY+JrPqB1k/DG7TrFgH3W5dQaFJOe70Fjp2LDVzBCA4imdjasQJfTrBk6LRjpUQJQPu24le9aEizikLGl/HOU3dUuHHMQpZxAzDdDWAtf7ykBn3gQw77lN10FDu6LxDpH4RFPY5Va72eD8uexmSv7UuaCZWTIogsWixrQ/FWS+Vrdwe3IGV5aWzfEtB513qBGEOo3dEMSAJdzwuzJC3k+g
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab0f0b0-9c8f-415a-c423-08d8251c240e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:46.9623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p2IV3wfUgB1SYTanYMm5gq4Tcm+ErEFdAspjaeEZ93exKl8B+DOuMkykLQgx5sRie5E1zhKdP73YYzYU2ckHXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

This register is used for global port analyzer configurations.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 52 +++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index aa2fd7debec2..76f61bef03f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9502,6 +9502,57 @@ MLXSW_ITEM32(reg, mogcr, ptp_iftc, 0x00, 1, 1);
  */
 MLXSW_ITEM32(reg, mogcr, ptp_eftc, 0x00, 0, 1);
 
+/* MPAGR - Monitoring Port Analyzer Global Register
+ * ------------------------------------------------
+ * This register is used for global port analyzer configurations.
+ * Note: This register is not supported by current FW versions for Spectrum-1.
+ */
+#define MLXSW_REG_MPAGR_ID 0x9089
+#define MLXSW_REG_MPAGR_LEN 0x0C
+
+MLXSW_REG_DEFINE(mpagr, MLXSW_REG_MPAGR_ID, MLXSW_REG_MPAGR_LEN);
+
+enum mlxsw_reg_mpagr_trigger {
+	MLXSW_REG_MPAGR_TRIGGER_EGRESS,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS_WRED,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS_SHARED_BUFFER,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS_ING_CONG,
+	MLXSW_REG_MPAGR_TRIGGER_INGRESS_EGR_CONG,
+	MLXSW_REG_MPAGR_TRIGGER_EGRESS_ECN,
+	MLXSW_REG_MPAGR_TRIGGER_EGRESS_HIGH_LATENCY,
+};
+
+/* reg_mpagr_trigger
+ * Mirror trigger.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mpagr, trigger, 0x00, 0, 4);
+
+/* reg_mpagr_pa_id
+ * Port analyzer ID.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mpagr, pa_id, 0x04, 0, 4);
+
+/* reg_mpagr_probability_rate
+ * Sampling rate.
+ * Valid values are: 1 to 3.5*10^9
+ * Value of 1 means "sample all". Default is 1.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mpagr, probability_rate, 0x08, 0, 32);
+
+static inline void mlxsw_reg_mpagr_pack(char *payload,
+					enum mlxsw_reg_mpagr_trigger trigger,
+					u8 pa_id, u32 probability_rate)
+{
+	MLXSW_REG_ZERO(mpagr, payload);
+	mlxsw_reg_mpagr_trigger_set(payload, trigger);
+	mlxsw_reg_mpagr_pa_id_set(payload, pa_id);
+	mlxsw_reg_mpagr_probability_rate_set(payload, probability_rate);
+}
+
 /* MOMTE - Monitoring Mirror Trigger Enable Register
  * -------------------------------------------------
  * This register is used to configure the mirror enable for different mirror
@@ -10902,6 +10953,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
 	MLXSW_REG(mogcr),
+	MLXSW_REG(mpagr),
 	MLXSW_REG(momte),
 	MLXSW_REG(mtpppc),
 	MLXSW_REG(mtpptr),
-- 
2.20.1

