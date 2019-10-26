Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53789E59DD
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfJZLFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:05:38 -0400
Received: from mail-eopbgr820078.outbound.protection.outlook.com ([40.107.82.78]:56384
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbfJZLFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:05:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMwYqeSODO481B+yu6cGSnesrLsQ1ELd8tXbHdt1sMchDBzAxd9n8gM8RhooFgjxCzdYhI9hoW2dZ5G6BEDY4tpbr82h47wvvlPHv8v6ysNX7zNDbMJU3apoWq+zQbeLEetTvd6+B9qu1aonN/pCqzf3H1+FoBswD3HNfO+yALvEj+v81HAEWmAHYSyPnNwxTpHFass/xfOYkddiHuk68zX/Q5h7qJLD1n0RpV/1EsiKutHK6R1eDpuM98iAl2wH8oNxs+0eTmP0Lj+IwT//ABvwNzlW9vu/Qrq8KMMwJ3aSUFJQG+c62pd40QATgBgjn6abC3MHRQ7ndt3chMAygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64nl2G0Lu0BTnlOhBp/OeSfYwEuOpU7t84kCezFwwjs=;
 b=Mx1dZF+XLVvU1De5Mtes43033lk8VKyGSQp+VQQeTPJjvbKmxlKvFJPF6OhPa25MZ2mftPgtgQtVEOsaIHoSI5gRLd2hQf2Sb4eGExtO4iCRfXNW+CsGsrR7/awRs4425dhhZdlnvEcT72hEI64nmiVlwWM4ab4QdLtt8cHj57TY5sMsr4HaEKn1lx2Fz8Krj1D0wuPfn7m59hh4FWjFgagbfIR2yZ6wg5oKB0DIZJKqbDaYPlD1pKeWQSwFuqlxG1F7vD6R8BQMW+55o27a3UQzL13lmDGxSDihS42JYninKuNEl1MQX/IALXS283YfOMMEQuaFKEWbujAavWqpYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64nl2G0Lu0BTnlOhBp/OeSfYwEuOpU7t84kCezFwwjs=;
 b=jZrsf3wLVbvaPi0C7ceUDfPZyHxlevZIiSL/4NgeNVJjQvcP6tzUv8ryUzueEgXXtXlf4czWmMIvDAxveDBwU0UI60fEJiCICMzQlkAt0iDCu5QMv9yhhtmK/0w6Wmgw8+/jGPcW53U7colslkU7/LCIK71WOip72I0B4KhJfS0=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3587.namprd11.prod.outlook.com (20.178.221.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Sat, 26 Oct 2019 11:05:34 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2387.023; Sat, 26 Oct 2019
 11:05:34 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 3/3] net: aquantia: disable ptp object build if no
 config
Thread-Topic: [PATCH net-next 3/3] net: aquantia: disable ptp object build if
 no config
Thread-Index: AQHVi+1K4EPfMcUutUqgFc3L31RNYg==
Date:   Sat, 26 Oct 2019 11:05:34 +0000
Message-ID: <94c21cdff374078fa8c3a603d8d3d60dcec9537a.1572083797.git.igor.russkikh@aquantia.com>
References: <cover.1572083797.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1572083797.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: GVAP278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::25) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34731640-07be-4071-b0fb-08d75a046c8a
x-ms-traffictypediagnostic: BN8PR11MB3587:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB358785A53D73B95E613DD20798640@BN8PR11MB3587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:55;
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(396003)(376002)(366004)(199004)(189003)(386003)(6512007)(64756008)(66476007)(66946007)(508600001)(66446008)(3846002)(6116002)(14444005)(36756003)(26005)(76176011)(256004)(2351001)(71190400001)(2906002)(71200400001)(118296001)(99286004)(2501003)(305945005)(66066001)(6436002)(5640700003)(102836004)(6486002)(52116002)(86362001)(50226002)(6506007)(6916009)(44832011)(316002)(25786009)(8936002)(81156014)(1730700003)(8676002)(81166006)(5660300002)(476003)(2616005)(4326008)(54906003)(11346002)(486006)(7736002)(446003)(186003)(14454004)(107886003)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3587;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JbHIazariPF6byOhT17p+xnSpSU/kjL/D6GbESgwccT+J0f+CMIJweBtW9CyQb3ZHAyIFYWQJm7hlSDrwBUI+qpyoyr2lBDVhyIqJK2XCJu3oPTNHrhfzizy2xtN0/W5BNQSWoQzt4xVeIMkrroACJb7x7qrVXOFyiG75SxxMvRomwCsomT7AZ5LH/nfYJB0zygdmlGm3pUBc6ev0kMHw7ZmK7WO0UdUvB9nMlOS767KmPX4j5FHglbyaVnEcw+QJxmG0L4zQaOVgLaHYegO6HGVyw0xm/gWvdeBp5aKBrmtCXoS+o5//eB8ovnnKQXw8upENvt3epOdVbyVty6lF/X9hSE/V7UcALgo3RX6nwKOD0K8g0dbOasj02sysBmmaVUhW/orWbjAgrkKzYYq7HZ56BC3gTO+a/XXCrFUDyyGZKOdsPjMTKwsKmKWG0O2
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34731640-07be-4071-b0fb-08d75a046c8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2019 11:05:34.6760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i5P1N8yQ7Klp2Dzr/euSmW9TSrJ4jtqJlpGx206ISXhjfqjpEVRNfWGLRDMckvMZMLJJdvC2NtWLNAa8kAwsCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do disable aq_ptp module build using inline
stubs when CONFIG_PTP_1588_CLOCK is not declared.

This reduces module size and removes unnecessary code.

Reported-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/Makefile   |  3 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   | 84 +++++++++++++++++++
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/Makefile b/drivers/net/=
ethernet/aquantia/atlantic/Makefile
index 68c41141ede2..0020726db204 100644
--- a/drivers/net/ethernet/aquantia/atlantic/Makefile
+++ b/drivers/net/ethernet/aquantia/atlantic/Makefile
@@ -24,10 +24,11 @@ atlantic-objs :=3D aq_main.o \
 	aq_ethtool.o \
 	aq_drvinfo.o \
 	aq_filters.o \
-	aq_ptp.o \
 	aq_phy.o \
 	hw_atl/hw_atl_a0.o \
 	hw_atl/hw_atl_b0.o \
 	hw_atl/hw_atl_utils.o \
 	hw_atl/hw_atl_utils_fw2x.o \
 	hw_atl/hw_atl_llh.o
+
+atlantic-$(CONFIG_PTP_1588_CLOCK) +=3D aq_ptp.o
\ No newline at end of file
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.h
index 3de4682f7c06..bf503a40b6a4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -11,6 +11,8 @@
 #include <linux/net_tstamp.h>
 #include <linux/version.h>
=20
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+
 /* Common functions */
 int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec);
=20
@@ -54,4 +56,86 @@ struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *=
aq_ptp);
=20
 int aq_ptp_link_change(struct aq_nic_s *aq_nic);
=20
+#else
+
+static inline int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_ve=
c)
+{
+	return 0;
+}
+
+static inline void aq_ptp_unregister(struct aq_nic_s *aq_nic) {}
+
+static inline void aq_ptp_free(struct aq_nic_s *aq_nic)
+{
+}
+
+static inline int aq_ptp_irq_alloc(struct aq_nic_s *aq_nic)
+{
+	return 0;
+}
+
+static inline void aq_ptp_irq_free(struct aq_nic_s *aq_nic)
+{
+}
+
+static inline int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
+{
+	return 0;
+}
+
+static inline void aq_ptp_ring_free(struct aq_nic_s *aq_nic) {}
+
+static inline int aq_ptp_ring_init(struct aq_nic_s *aq_nic)
+{
+	return 0;
+}
+
+static inline int aq_ptp_ring_start(struct aq_nic_s *aq_nic)
+{
+	return 0;
+}
+
+static inline void aq_ptp_ring_stop(struct aq_nic_s *aq_nic) {}
+static inline void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic) {}
+static inline void aq_ptp_service_task(struct aq_nic_s *aq_nic) {}
+static inline void aq_ptp_tm_offset_set(struct aq_nic_s *aq_nic,
+					unsigned int mbps) {}
+static inline void aq_ptp_clock_init(struct aq_nic_s *aq_nic) {}
+static inline int aq_ptp_xmit(struct aq_nic_s *aq_nic, struct sk_buff *skb=
)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void aq_ptp_tx_hwtstamp(struct aq_nic_s *aq_nic, u64 timesta=
mp) {}
+static inline void aq_ptp_hwtstamp_config_get(struct aq_ptp_s *aq_ptp,
+					      struct hwtstamp_config *config) {}
+static inline int aq_ptp_hwtstamp_config_set(struct aq_ptp_s *aq_ptp,
+					     struct hwtstamp_config *config)
+{
+	return 0;
+}
+
+static inline bool aq_ptp_ring(struct aq_nic_s *aq_nic, struct aq_ring_s *=
ring)
+{
+	return false;
+}
+
+static inline u16 aq_ptp_extract_ts(struct aq_nic_s *aq_nic,
+				    struct sk_buff *skb, u8 *p,
+				    unsigned int len)
+{
+	return 0;
+}
+
+static inline struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *aq_p=
tp)
+{
+	return NULL;
+}
+
+static inline int aq_ptp_link_change(struct aq_nic_s *aq_nic)
+{
+	return 0;
+}
+#endif
+
 #endif /* AQ_PTP_H */
--=20
2.17.1

