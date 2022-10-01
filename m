Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBB55F1B69
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiJAJf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJAJfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:35:13 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60119.outbound.protection.outlook.com [40.107.6.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27FC13FB8;
        Sat,  1 Oct 2022 02:34:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqyUGtpRRBDaSK1JfFBvksrkYP/eNYJhXqR/yn6rDt0Xn+pbQrztjAUfaNntIt9+vYpA8ppqAuGJ6B/ce+LgB9tfOfSKBWCd9CRLdKOGfJbWFdtkEZCzAkr1h6wdNNmcg3rK+oPlEylkJR6QTqdLGG0Sch6Pc8QBjzxYgp0FeH+AibA7vckagS+aFFF1ZYD4DcYHSW2xIKrEdFBcMU9lbwuLpBEckB3xYtOptl2hUDD/J3bLgheDLzlvqccvzdlQ61LQQxY0IVMJMGG0bKdg+rn3DhCSZOGMLd9yZtXNdyZjfjnkGweWDazx4OED4gVkPgvK/AhJpgq8RbpcSDjOsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzZ5pmTFpTYgRh9zkvuydu4yU6ZedKHkRiL2eV9+/Lc=;
 b=WU46vJue5Fs34y5fXmk1LnZu+Xq2iwvW3A2vPACmdGcEKtHDv3X1G8TbeeOXVXkzTCsKtYY30K3epOVz8JLMcbmfDb2gGlBnQUo/THz+GXKRj/CAVoH+bRF3LF0j0785gXazzn1SmqHkyp0gK38iMdhODjADJoVzeGKvvfttaLAs8wkWebE7/0Dex5Fu/csJjK0GHZkLqDmHy3DL3hxx6gss+YhAGLVCNbx1i4k1vPEVoaeb2PL1JU2zKT2drJ1iU4arT8RX7c+Gu+ubGnNmJ2akwnzXZqq+fGVOU2W+pP/ldDMKJQ3SMMEDz9DF8Z9wQ+EMn6/PfZ6uZyLn6CTK2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzZ5pmTFpTYgRh9zkvuydu4yU6ZedKHkRiL2eV9+/Lc=;
 b=OymoVoZv/xdrKyPcAycChZPDH2vkYHYPu37AHzS8LI1Mh5afELATfTzO4p7u6luCHZoRkjOoNPVfYER5W3wi9R+PgLqOyXcXAMUsduVzS07knuaogAY/SwBJJUo5UIKR+8QLJxo1+If6NuPvPdk4sPQrc1TLmkQU6HS2vieMzxQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:32 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:32 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v7 4/9] net: marvell: prestera: add delayed wq and flush wq on deinit
Date:   Sat,  1 Oct 2022 12:34:12 +0300
Message-Id: <20221001093417.22388-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
References: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0696.eurprd06.prod.outlook.com
 (2603:10a6:20b:49f::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|VI1P190MB0733:EE_
X-MS-Office365-Filtering-Correlation-Id: da7a90bb-4772-4734-ae47-08daa3902532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLB1X0b4hQcW6kbRfMUxvK/6mFZil2aWuGZDqFIpt3WfDBoM0YEl6wDqRSBEKS8Mc2xlVDMTXwLnfARrPxI4YuK8JXmDC9hI0eb+TmhynqIDigGYmBmZWEnpW88JcmFR4g4f69MKyThqa6w7z6MXg17qtT/hBsDxldnDvH5yYwqZ+ojBOLcnVuaeQPt7QcTRyneH5mbYuWKcu1z8huiaTQMbVTHrM9i68+CKAsoKUZgAJgOg4Ti6GZhGRuYD7xS3Zv2eoeRLXh2CsuYPNQb/H1lrL9/cTo5rc6rtLWC6j+nsAND4oAvjcPVimAbR7O1CiNbrGXIwM3IiJCpym6rhqQ856ugmaZ0e5xnpZtb+/+dFYWyt1T31WuAbAjdiKdOY0FJtiP63wjux8l9Jy95aCz7exWivHjFWIIxYu8aWYN3X7UOAhCrH6hbiHAzVDXCLMSODTfAYUfnqB4dKiDqHWJhcUxdOqmPygjDEr7bTuyWkN8i81tzm40v/nSUEpoA1iiCpNFhAcQJ+31gTfj/WwLdRBae6t+IbH0PQql0TYNelQPD8opkgEfxEjNQ1KGz9dJ+hEnbj1pHLlsKsyM+zfofpCljIMfKB1LZblxdoc9REdnGf8fQxSmc65Byc6xysDLS+d4XoEEsSNZRgi++YNFevpw2VKgjWJ+mrQtZlyHVIhp5oFCssIaBUiOFx5OhhaqAlt2SFjTdGX/aHMjOeZd3euGp6LDaQ1XSSXgvp20d3U22ciqQFccUPl8KqiO1l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(7416002)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(107886003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M7uvSL586MP6BcchzsNKRS4FmvGXGyA8oaje46W+gb1XYm7zvFrwuq66SRhq?=
 =?us-ascii?Q?73EmxvwtyEIaVkTPXQQ2f3CX52fupp8D50mxSF6s4pRjeGzV/DWkIs/9E5hD?=
 =?us-ascii?Q?WMv7laXroC07hGyyvkEQUlnfUwiTrlr9VPME+6HNMr9jGcxXsxgIveYAVYCj?=
 =?us-ascii?Q?5z+QLRTdoLrpPnonPvLBhnNjD6GqTLsgIzNSCNQ0iH5KJy+62T2kgv+IuVY9?=
 =?us-ascii?Q?+6k/Gh/Kh/R1v5PvIHyjlJ+Vdj9cGS5LmbQH7Q09Ys4+TCfrJRPb77fGlXzT?=
 =?us-ascii?Q?wRbZ2a5XrmFpcBY6mr9HoTDbNtE+VFJg/FjFRgRPe/FPIpQjlUFEl31/0Sfe?=
 =?us-ascii?Q?C7G7x565zWI6SHLCfaL1UYOUJ42qsE2Uvi0C7/vaIHS29PIiY5L9E+n49d+0?=
 =?us-ascii?Q?jZziOT7lWzoCmPo5OGYAZG0oa4G4hy04M5GbdwDtigZ5wEy7OEED62lYc4hu?=
 =?us-ascii?Q?5973kPK1ZHhNkIHTbyQxiz/ExDyFbxhWwtSncAx1bCqf4VWRrOaJASoRKA3h?=
 =?us-ascii?Q?UtvlfdIS3R+9EDjKuhbUyGb8RQYuqjHEfT1+PFGfcRYzREQpNphJSEEmEq1k?=
 =?us-ascii?Q?ILYg3fKA6dcYm1NdNHzJ6zhcXngUx2Pq/8wAH93v6/4GUYzL8VUsTh3AvXmK?=
 =?us-ascii?Q?ifeHLehulVSz2EvVcHCttwWU8ralwpuR4eeUnGTKbAMtwTHUjJiHUHq41gXq?=
 =?us-ascii?Q?XoPC3pC/nQ4S0SZ4gSXP1zclKltdnWEAglnjeWR/4p49TIm0Eg77aaclERDO?=
 =?us-ascii?Q?zLB0n8p9Fz4PIozOJJIaCUirZiUtVGEKGJ+xIVlKoahW4s/nYR7wvD+rHH3L?=
 =?us-ascii?Q?VBMhB0Jw6MO459pvmC0niDpmANFij7vvvFxNIyNuqymg3afB4s5/esvskIRs?=
 =?us-ascii?Q?SaPlyuBaWAiaiZ4QM8WBJ1ZsrixaLtJpk3dvnWFhhxQB75zXAo7DqD2qLglY?=
 =?us-ascii?Q?uSUz9bgYcA3m9CT22YvhD9kIwYC1ex5hSbfa0wtCb3P0mqcZt9D1FyfeHcD+?=
 =?us-ascii?Q?2LnOQy/7PUzDkjA4IbNT56U6oM1RFNBwB1CjcB9+MP5LRFNP3P7XaQ3xIW3H?=
 =?us-ascii?Q?q0bWDBd2trXAJnh2Fk2c5jEObRiieJaVTSXOj7MNq0zZuG3goAVadPGEc47Z?=
 =?us-ascii?Q?Jx50vopgfIVHG8pjoCyM9P6ahdHiq9CZGZTyjGQI3ES5G5QD5o8TWgVtohLK?=
 =?us-ascii?Q?7AW84kJI783+WCM0kjGR70ICacW5mSlcPwlRDJhc1RAqV3AdZq5oEl3FCxPR?=
 =?us-ascii?Q?EOoPE4w66HXaxampJ94DMCyYm04BIwGZf3n50ng0I2d70BW+BkfMBHkdfC/L?=
 =?us-ascii?Q?pojko7W0gMgw9xF147l8/MuVPtmJk2TTa4L5+h5GECPZohK/UV7tyVZ3l2JN?=
 =?us-ascii?Q?40cRBY13WqOomiKQ7HWPg7UqoUBxRB1AN5nnUQqfMHVV9IURlYDXSTv3bxR7?=
 =?us-ascii?Q?YljCVkIGQbpvY16dKOEDeCxKIS2eIdwE/5ZiqARZ04shS7wdkX4/Oo6cU2CV?=
 =?us-ascii?Q?nizWdZ2BFnqoMXK9HS/oUJv39g7mvzRrA3LMYZxxUY4FODKorKhbfJ/JsTtL?=
 =?us-ascii?Q?eULjxZAxs8hfVnE+533mLYiuPh5BpPVEQk6crdVKFGajJxQnDRoi2ps3jjPR?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: da7a90bb-4772-4734-ae47-08daa3902532
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:32.2449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5clAu39+5WEq0LhXFG1VTFUCnheacDcBFGCMqfkfaDgkE7re2tq6rDMswjjMApzmSl3ds6dineVQ0mc5bmX9kL7cXfyoNWpcw1bi6y9/ieo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0733
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flushing workqueues ensures, that no more pending works, related to just
unregistered or deinitialized notifiers. After that we can free memory.

Delayed wq will be used for neighbours in next patches.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera.h      |  2 ++
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 11 +++++++++++
 .../net/ethernet/marvell/prestera/prestera_router.c   |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 903e2e13e687..fe0d6001a6b6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -367,6 +367,8 @@ int prestera_port_cfg_mac_write(struct prestera_port *port,
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay);
+void prestera_queue_drain(void);
 
 int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
 int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3956d6d5df3c..c0794603a733 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -36,6 +36,17 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay)
+{
+	queue_delayed_work(prestera_wq, work, delay);
+}
+
+void prestera_queue_drain(void)
+{
+	drain_workqueue(prestera_wq);
+	drain_workqueue(prestera_owq);
+}
+
 int prestera_port_learning_set(struct prestera_port *port, bool learn)
 {
 	return prestera_hw_port_learning_set(port, learn);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index b4fd8276bbce..9625c5870847 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -639,6 +639,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
 
-- 
2.17.1

