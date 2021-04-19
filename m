Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3030363E83
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbhDSJb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:31:58 -0400
Received: from mail-eopbgr700065.outbound.protection.outlook.com ([40.107.70.65]:18528
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232440AbhDSJb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 05:31:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e14/KkIj23k2vlUovyKGSLhHUMyLX39Cs9LoihLdlQ98GUKTLwpj+8V+S4G7O78tnbFrQk0vVi+FfnjqSPKlYZuARtezED2+JJ/6ipq0yWkjWkzpnJJn4NNqdetzJe+OpqTaHSNxNls9pAbst5lPj75ExL/Dtwsi4N+VFy9vmYvNXhuUebQNko5YoxFAjWxWQPmTRqtaCIZoJoJ6fkw7pS0AI/0wBgqew3FJFJBBXuh2THj7+w7Wn+gqetVuDrbaBg/GFzV/hqSSsJk+LSpb0jeAeFM2DyMY09qs02VxJkkpcGMrBr78ViXdhBFhj4pCErpErsLYg2QyzhgJXr3BJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpLekaCmnQjQpj+Epq8Tv7ojo4ky48ahB0UBNCna/7U=;
 b=fif+NPkQVKjeb2uJ6zeH2yIVXXWnZY/o0/Yhb/NTyDmkJmOuvoQ2uO520Olg8O7RRoEWtM/s8gMhVLo8fINnFn7E0HciGXPyE1n+6o5YIcS4m6zEUDd0ztuJ3sZT0b91Qf7J/BTqyZ8hGqIYnULkmWoKsmie4BBh7clt6AT+VOt8dtmyFIaSNKwUA7MVj8D4u1FglFw1duvDGur8yH21Xhh0wCXmjYcIaT0kSdFt6uDd++Z0gUxgc27VVjGr4iCw8MxUvdt6aZA7vbdyoMZtG2+lL2jO/bJjYwEsjGR7zhVX6eMQlZNpVyi19D2pASVYRxb4VjtkQYxX7F3TgK49Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpLekaCmnQjQpj+Epq8Tv7ojo4ky48ahB0UBNCna/7U=;
 b=TFVJCXgH8DsDt3CULzGuXnbLKyOAEtONvOdS/pFlSCIZi35BTy56WtwJV6V/iFrNwgLFOTPEmpBlc/ylv9+UUTg3weEh5hdRCBCSyEWsokSyLc6Ma4moPDBHa9yl0O1Is9bgIeckeKXrte9lABMBTL/vLYOcUyUp6EuWWUbhZJo=
Authentication-Results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB3419.namprd11.prod.outlook.com (2603:10b6:5:6f::32) by
 DM5PR11MB1481.namprd11.prod.outlook.com (2603:10b6:4:9::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16; Mon, 19 Apr 2021 09:31:25 +0000
Received: from DM6PR11MB3419.namprd11.prod.outlook.com
 ([fe80::5d18:2208:ab30:d880]) by DM6PR11MB3419.namprd11.prod.outlook.com
 ([fe80::5d18:2208:ab30:d880%5]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 09:31:25 +0000
From:   Liwei Song <liwei.song@windriver.com>
To:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        jesse <jesse.brandeburg@intel.com>,
        anthony <anthony.l.nguyen@intel.com>
Cc:     David <davem@davemloft.net>, Jakub <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liwei.song@windriver.com
Subject: [PATCH] ice: set the value of global config lock timeout longer
Date:   Mon, 19 Apr 2021 17:31:06 +0800
Message-Id: <20210419093106.6487-1-liwei.song@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR04CA0071.apcprd04.prod.outlook.com
 (2603:1096:202:15::15) To DM6PR11MB3419.namprd11.prod.outlook.com
 (2603:10b6:5:6f::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp3.wrs.com (60.247.85.82) by HK2PR04CA0071.apcprd04.prod.outlook.com (2603:1096:202:15::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 09:31:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e3f377c-1fc0-432c-214f-08d90315e6ac
X-MS-TrafficTypeDiagnostic: DM5PR11MB1481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR11MB148153B9FF5E18E361BEFDD29E499@DM5PR11MB1481.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pllgNun6KOT1Nys/GZarRz5SfLZKpZuuIBSgAebt/RiCbVTObY8/3rr6KDHssKtD4UGr925xPxkcTfGKdj/ObWHNdjztuTnrPD//hdAFKBAdDbkjenflDiXEdrlZlAgSqEFwijvWDcCsxowl6XcEUB9uD7NM3bDvURKcV8qerxIUYtDjtLWpsPHaN70M9hccWjVHj7r0fJ4h1AkCA0QJWL60xOG78t6+doLOdCwu+gNT1knIqsUrTsJf60IMgmYPqHlAck7ys707URUm/AzLedt9WjeOVQ0XTe/FIrOjuz2KHLWJROBGp23v4pJelEvwCIJbELvId4jCV+P6E8RVJMKIBNrAyxpIVXuJWifcWWZvuPZqD0nH5sIdzCTXJ20ZEZbjwDaYt7bYvvlCWEudfdavpNeGVgg6+Q/zkj02JAoeZXSY8g/1TrNalOOwlKiFxguTbsp6kQH/uF8S3KrDalPShMRUGMYHXznn4oB5gLkmBxE9EpAz0Pn7B1keS2EiwxJBhJ+cpZlr4qPFq9JLrGW1XZwP2SNPcemT82IHtAN+ft7srUeYT+L0LUh521iQMWHNESQPo1X7zfsVUCXKZJu+RfmcN/m6e+FWNLL4lUq3BIf+rWGUmk0d1U+xDd38NDgFmX3hv2aNLGyTBI/spbcDUbjlZGN5bwDtmIqKV60t7F5pHQ1dHEkTIlcabECi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3419.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(39840400004)(396003)(186003)(86362001)(38100700002)(8676002)(38350700002)(66946007)(2616005)(16526019)(6512007)(6666004)(44832011)(478600001)(2906002)(1076003)(52116002)(83380400001)(956004)(8936002)(26005)(4326008)(66476007)(6486002)(5660300002)(6506007)(66556008)(107886003)(54906003)(316002)(36756003)(110136005)(148743002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Wx6wYJ4VcDfDaL4+rcg1OF2ccYjdaDnrEvqr+gSd8IkTdlE4yoEJBT0aJmFL?=
 =?us-ascii?Q?yjw3AbnpLdBcbrzQq5agsM6zsnnqLzG21WkxJuJL2/7maoxfZlRNNGiy3K20?=
 =?us-ascii?Q?jKfQTAp+XH5r8vD5z+kBMdMXNJWytUIv6UgipSvMVQuYeFKHIGTcp2qwz5aK?=
 =?us-ascii?Q?XmdbRO6uVeNvP9T0HXVOqcRYxY8ZZNxLaYa4ftS/jbDggVLe+VyKa8+s9lva?=
 =?us-ascii?Q?yLm8xnjZKgkAJOZ++HEoppvE0NPBY6OoxsSavcluqfl8WuEOlPTVuY7pioVB?=
 =?us-ascii?Q?xnDJEn0BHHIAPxfPEZqhIzK8QP9jQNdYQW191/MKBOvuOLbdgRGcMyTch8S9?=
 =?us-ascii?Q?uxd/a35fBCwhRGf25D8feMtgrr7faySbqRqm/e8tb5EOf3fEneFG2yah7ind?=
 =?us-ascii?Q?Ou0WJuO9AdLrji+xB8FHpg8UQbXcG8ymHHyUCQBnJjEZK30D74bU90wqjmka?=
 =?us-ascii?Q?iD+2bsIH6sU36pm7zqJDwV7FVJb/KN8WwwEMKxEZ+ghBCTpRtQGV+YiS0fMk?=
 =?us-ascii?Q?Y4WhGXRaLVMDkLiFyI5cLNikww5otmcaJuARDey0Fkw1MAu5bT2Rud1cVc+w?=
 =?us-ascii?Q?JGI0mIwwnXprZd/KZBCxanzOm60AYWgzB3hooTO7Wbm+A5XnVXFWZ7JxNMmM?=
 =?us-ascii?Q?Ln7xu/s4Qk4BOqwONID3Mw50MEIK0bpRp71dyZOmBSCGcuTNByxuYxD7LlIu?=
 =?us-ascii?Q?sk3lIjLqT6pftzFnW0ZpiVkXMGnHViVjMvIWE2j+Lzs2TzU/DRMDFyZTW1E2?=
 =?us-ascii?Q?nvEB+Xa8X64qHBg4svhq18QyYN4e5W90azqk/TIdqOBJ3Z2A7zJoEPbObrJL?=
 =?us-ascii?Q?9/gm69KKctaJAWTMaF18f2VW7hcU4KoI/p2tA8UHp+r5oHGWhW0A/989APNV?=
 =?us-ascii?Q?2ONdLLZ/r2XNmqgYLmuQ60mXmuFf7DaPQB6P3zSkNcApYk2TVeHqngDrsoch?=
 =?us-ascii?Q?Pwey8JK1zskWBabgSYrCslRwvbC4IPN1MomkJC8HcYlrKzsiv3EEWaHTA6Pb?=
 =?us-ascii?Q?GIT9Pl5YnP08wD/qOrsA7B/e/9CORTGIzcVlG/KjGbQQjua8J1/0a010qG7T?=
 =?us-ascii?Q?MC8SQbEGICZ4jq8fe9al0NM5BAAbEepsQjcDAM3AutUIKVnt7k191WgAQYC3?=
 =?us-ascii?Q?+R/9BTjGPLgHMRI0i7e5WRMtO9HAvF9mvnKX4BwaXs2IxyAV0LPPaBS+BKF9?=
 =?us-ascii?Q?f9031pwBIZ8pN2MxcsCveUUvPZYshRd732o9j08OvVbTJRKAhcpvTe3A2jKd?=
 =?us-ascii?Q?j+jSUHkO7Z0lCyTt9C6sYwyCup63ew3tpCueLNLwhQBgBD6Q26D5TTyRalgR?=
 =?us-ascii?Q?dWPT4KzAaZRUushm4N0aOFcm?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3f377c-1fc0-432c-214f-08d90315e6ac
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3419.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 09:31:25.3520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KkNxJdm5922bqcyNnshnVGrI6o8SdXKsThOmVw571bGi25HNvqdUCfWl7gL4++ey7f5MHAvDa2pablVyEN23HCgUqPQ1rn1wtHSzSxKtIOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1481
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may need hold Global Config Lock a longer time when download DDP
package file, extend the timeout value to 5000ms to ensure that
download can be finished before other AQ command got time to run,
this will fix the issue below when probe the device, 5000ms is a test
value that work with both Backplane and BreakoutCable NVM image:

ice 0000:f4:00.0: VSI 12 failed lan queue config, error ICE_ERR_CFG
ice 0000:f4:00.0: Failed to delete VSI 12 in FW - error: ICE_ERR_AQ_TIMEOUT
ice 0000:f4:00.0: probe failed due to setup PF switch: -12
ice: probe of 0000:f4:00.0 failed with error -12

Signed-off-by: Liwei Song <liwei.song@windriver.com>
---
 drivers/net/ethernet/intel/ice/ice_type.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 266036b7a49a..8a90c47e337d 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -63,7 +63,7 @@ enum ice_aq_res_ids {
 /* FW update timeout definitions are in milliseconds */
 #define ICE_NVM_TIMEOUT			180000
 #define ICE_CHANGE_LOCK_TIMEOUT		1000
-#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	3000
+#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	5000
 
 enum ice_aq_res_access_type {
 	ICE_RES_READ = 1,
-- 
2.17.1

