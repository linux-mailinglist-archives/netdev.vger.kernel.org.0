Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AAB17BE03
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCFNQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:16:27 -0500
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:32801
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbgCFNQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:16:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mypCR85JosUKZ0EHSH+AaOJslxmfoNw0cnwjgJkLksMSgqU3tSzXgvnid6XaezvX2pW5EwdQxXzK+kl+Wsj7qQwM3+MW9UnrVZUJPE1RNetuza3tcG+6ym19ijKMKte+zHWrrm/5n7nZ9OXCEHzUVT8zRfa6NI5hvZrn8O5Z7yTmL8K66RFXx0ZTpgoLKh+V7DtK5qSUFAPuea3DGDZH9ZKVBN4EHL82r45u3sP7DzeZWtMwgwoZP/S8zxq2rzKjkPxxs9UXza4IZiSu53XXQWyCzJmlb3LsEbelolwYe3ecZqfaUN4p+kc/QV4f6LgOYG16If8t5o5tOCZNESGifw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdGqoc44J7VGXiujuxN/42Cz3Z7sFUU/OgZlF9L0XwM=;
 b=WQRt9AheQjZCR9pyYrcZWSCB7ewgPaNTessR3o39djloearum3EVsEm2vu88vesy1Ovy9SJTSvp5xuAPGEGKdDrNGQlkErQuS/i9BXbG56MXcWPT1CakgbprQ2cjyI/7k9nrUEoSEKlHuIAPbsdPVxNYWILSkX4zUOmqmohxjw2DB3Yrb78hIfxSOCP1ixv0YNG/vuS7vH2pRlcnZBmzGjMw15XLkrpUwFtoCzlaKqhb3NsLm5HL1BdCdFbxj74fbTFrJ2F3JNGiGNz3GM98LqRA7A4e57UzkgUiyammCE5JwV5qcaR//a5+nk/6GkCoVwBnicxGZjWyhQEYFIthbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdGqoc44J7VGXiujuxN/42Cz3Z7sFUU/OgZlF9L0XwM=;
 b=U6MLQ14cJXUC9scZMkT1eiizn2lB93zFqzKkEQzjsYZ8pUarAKBDr/4xE4pWIZy9bsOGB/zUwog+ayuPFfy4Yyx+oxP19hMvNoQssMYX80O1TnGuUbLXWVaKkWNgRXsAb9w6uflltEe0UWA1BRqVLrtmqzA0zkQCh4SnPVugHfY=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6527.eurprd04.prod.outlook.com (20.179.233.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Fri, 6 Mar 2020 13:15:52 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:15:52 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  8/9] net: qos: police action add index for tc flower offloading
Date:   Fri,  6 Mar 2020 20:56:06 +0800
Message-Id: <20200306125608.11717-9-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:15:42 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 886ed603-6555-4180-1657-08d7c1d07e74
X-MS-TrafficTypeDiagnostic: VE1PR04MB6527:|VE1PR04MB6527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6527DCCE3DF622C92F26DEFE92E30@VE1PR04MB6527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(189003)(199004)(16526019)(186003)(26005)(66476007)(6512007)(4326008)(36756003)(66556008)(7416002)(6666004)(86362001)(478600001)(1076003)(81156014)(8936002)(6506007)(316002)(81166006)(956004)(5660300002)(8676002)(66946007)(2906002)(2616005)(6486002)(69590400007)(52116002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6527;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 196VpvJekBonGkwa28ZAmsJTensPWh98cE8FhWAy2JU0deMxuQwoKDNxqHXrhosBosxkXmEtdib1prcESj6GNLbMtn7Pf95AoH44yJVrUjNRn7V/agE1FnraagCH//ixytK7LyBhcbxqssoW405yHYG7GHycm7aPv4dYoaRruaOzt9mLHNlokVNrJMfqkoZoPME/FJ4lSArvI0TNiF/kgsbuuaXrkNCu0XYyhJxVemuqOePO1reJNyvXvuXQMWEPtQo8smfzpbC5I+sMNuNa6lZfm83rWlMvVLz71bEgw//fdUCv4YckKbo7auNyRQnk4bPXh+gaqykTDFsLCGJK4nGtOQE1+Z19dPMtB76Ts7gTIc3nooIChPVRiI5ns2ZZfY73cYfI9Bz8KXHj6jEhPv3TrjcqVGtn34vRroMEogDaXsMrAuZrs5B/8W39aFRqBW1C+CKU6/kLXkalUS8mGmR8r5CPqXgDoKKNusFPD9rrgdSW1msVjNxae8DitSQbTnXfMGIRMr/8Vpic8dmU1Q==
X-MS-Exchange-AntiSpam-MessageData: d59d+B7eu5Bnify2nQi+/TJWeCXrGXFuTn1v+j6xeNiHX/WHdRIgyL9yt5hKo0eLufPWDPCj0x2+gR/L9d8oES0tSR1a7kpJFC1BctMfa690nt7iTot/Ts5BMo/ROu0TZ67PX+53V1B9IDNgKbFdxg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886ed603-6555-4180-1657-08d7c1d07e74
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:15:51.9837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZiRKh4Ph7mfbt4459gcnXh7XMJg41UrxSCc39MGZuPbsW3k9XR4j7od00HrNblKw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware may own many entries for police flow. So that make one(or
 multi) flow to be policed by one hardware entry. This patch add the
police action index provide to the driver side make it mapping the
driver hardware entry index.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 include/net/flow_offload.h | 1 +
 net/sched/cls_api.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 54df87328edc..3b78b15ed20b 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -201,6 +201,7 @@ struct flow_action_entry {
 			bool			truncate;
 		} sample;
 		struct {				/* FLOW_ACTION_POLICE */
+			u32			index;
 			s64			burst;
 			u64			rate_bytes_ps;
 			u32			mtu;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 363d3991793d..ce846a9dadc1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3584,6 +3584,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.rate_bytes_ps =
 				tcf_police_rate_bytes_ps(act);
 			entry->police.mtu = tcf_police_mtu(act);
+			entry->police.index = act->tcfa_index;
 		} else if (is_tcf_ct(act)) {
 			entry->id = FLOW_ACTION_CT;
 			entry->ct.action = tcf_ct_action(act);
-- 
2.17.1

