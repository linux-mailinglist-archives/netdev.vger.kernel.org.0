Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E66E56BEFC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbiGHRnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238960AbiGHRnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:43:49 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130135.outbound.protection.outlook.com [40.107.13.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092186050E;
        Fri,  8 Jul 2022 10:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e34Icj0pO1UpuNI+tp1WNEaKQOp8XdTSKhEprHQSFWKqwCDMxu65p70NndyAFY/+DsNdifAFwL8HKNxmM4JFtIx05RcgWoL0x8TNxL28Vp7eZ0j9IogCnwRagf0VgGKf/4MXZSZluTPtd9tqR9VY5jglXfkQPRsEFeWNggZysWUS6clE/MvE8BblikDpDcyOo2hJneoXi6N1Af06Hz6FYsDDx6EpyqOD5JO0B8n+89Os0CXri9M3hnR+ZxsP4leO+BvhOKiKJrd/9QM/LOnb+1Giw/DewmJGFHxZGNVjzLGGz410G6Jg0GBL5kNcy38+TaJNYuhCkHQ0k5/n586iTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8A8aYCRWA0FKlAWAeDvYgRsvaBt21Mm725cf6oIA6fg=;
 b=In6LpnZidqMGsCr3SQOmP2cR2WD3HwrtDtMtOBFXFwLdaSznACAx/5sHAA+otVoGbVZ5VlR3mZlGEa2/oUrIWDUDIg+yigqxfT0wEZbfXG92NdJ/AkVYGlXsKqzx3ZD+BT84OwYkKWaSrMUmjXW1ycVnlM5mE4e9cxhkIHGlZO/r5vGBoxa/mnpNMRGV8S0uxQvMfQPlt1lrB70IjLxi8gA0eEj8R8ljxAxf4OTSsYedQhWsfEQ5tb0McizFOXpaqjHNYRlvz1knUAaYKA0thvVupTELtzczTq1DoBxBd14OrU/wEp74UO2YipR6R60/HNjnx8X61Fq63vNqTcuM7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8A8aYCRWA0FKlAWAeDvYgRsvaBt21Mm725cf6oIA6fg=;
 b=A/yvMa4J8HK33FRVJ4wWHa3VDWkKqWB1Hs2nAxwiacTqyPy2aLLzi3HbgObRqsMZoSnn4AqJBXfXSINYlA0AvV0JfMFA+QE/Yv4UgCfU6UHXV9LT7vcPEGVuSvbVqRrJq0BcD0Z/IIuMcKC0T4OrRuncdF1OtG//i8irRL1yOB4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1414.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 17:43:41 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 17:43:41 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V4 net-next 3/4] net: marvell: prestera: define and implement MDB / flood domain API for entires creation and deletion
Date:   Fri,  8 Jul 2022 20:43:23 +0300
Message-Id: <20220708174324.18862-4-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
References: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0045.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fa87b1c-0941-49f0-72c3-08da61096594
X-MS-TrafficTypeDiagnostic: AS8P190MB1414:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PG84zj555yT8li2Wz3SBEULAAU20lbOFey83swZmQHspVf3R7Vo3cG6CS5dZkoC0CBfHngI7aCaJF7NyImM1aBVgmEo0mE39OWdP3/uGGnk6+PW6a/G3s2fjKV5fz1El2knwfOsOG9c1gPYzAL+bt0m9SmXgnNQ+WUCguCSEk+s/YEATK73rUFXH8YE/R/fPBtNGVY77+3K5tW0pF8PNJOfV8cmg1LdLwcXQs7kBNfmfcjpjJv1lXADcjhPsGzYIOFaaQGWo1c/ErDpsOkCu/pBBYMadC57t+lbLZi+BbUWjMFtwoRw9MWYDVCyk9i0skprtaO4Z4xVyjvfHEXmWDtA1QO2y6sHXgS00Ly+T6siQoj1lpqfLX9Kx92myp/8KtS+NrwigHJ9n3DLY0jrWkhopHX3lezLQJ+xhS0p3C2n+XYnVBOMnQsikT+JQywgF1NWzo1ZT0QYSgIe1zx2ubMFC+FT/R/GIEvpJWT2ek9hmDtP+fTBJqLuijuinCMHn4jKoI3fS5WhEFRVSBQa1TSekHleXOw0b1/kuZj562HoWFAAGwR7XsRCTbmY5lPLUbXhLNm7WJ7lN+oVzXQ0zMMbMtqOPrlc9FVB2gQ5ZSNKmGvWUQQaSlVLWqoQ6QpS/VQ+2vkaU4z64dFXupKqCPgU+PU2wIgPuvtfj9ImsvyDv5nL85vV2Kjy7RpXBsmQt/G+Ulu3sqKHkeS4v6ZPG6k/S/uKbP3DvHWo4c3tZs8CeNfTSmjSgt2+LiiDSN7hyPxXGeqQ4KubpLXx1qhHLdTjW+V4xmj6js00vQo24BYr5ediBAhxR/1ppi37PRTrr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39830400003)(376002)(136003)(4326008)(66556008)(2906002)(52116002)(478600001)(316002)(6666004)(86362001)(6916009)(36756003)(6486002)(41300700001)(6512007)(6506007)(66946007)(26005)(8676002)(66476007)(1076003)(83380400001)(38350700002)(38100700002)(2616005)(44832011)(5660300002)(8936002)(186003)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WTwdqW0Ns5bCVGZLA6hMVGfiVC3yjQn5cF7PNO/9IeZ0mBl0vCNPkUA/rUwa?=
 =?us-ascii?Q?fJ3K0Hm74JyXXUyleUguzSQc7FpkGX4aQHFwG3WDxO2f+vU+N/w3NwYg5Hcx?=
 =?us-ascii?Q?j+SE3BkfMjYdH8zmN3uGk6Oln2nYVOQNtCjC+2FSCk2ssBhwjQ6zld6pjuV3?=
 =?us-ascii?Q?jbfNqSqv100KtYkPBn2/4sbsjAfBYx+/hEIrFy+1zqLFn7UORTJW3xcfQ99O?=
 =?us-ascii?Q?bNQWvXizESqYEXDAGrPObInzmoen4LA2kt6UEuOXwoO+d/xGYrBfI/+dqLOd?=
 =?us-ascii?Q?MEAZzK+6pgXMmpTqo8YOdmU16hq0uyEnM3eegj2FHnrnNEnIQwCdpTX40SOx?=
 =?us-ascii?Q?D+uCWq6RccLPBBvX6heXma5/vFkgalRtEkIej/CDXwR/YtZB8BUDFB840zPo?=
 =?us-ascii?Q?jGd//x7SxeCrlNG3OZri2mWluV9QK4IiUnaiKNys8RjzqACwT7ytfec+ijvy?=
 =?us-ascii?Q?ECVppf0zDaWChoHkqr9wVP1QM/q4W1R2tiSwTillDgPea2JpieiCECnQt/Mu?=
 =?us-ascii?Q?divflIGa+SbuMDr9onMC4rJhBCd8yKhkEa3frq5H3uAxqnuvZt9V5NgprQ/A?=
 =?us-ascii?Q?2p3ZEHJCOxqGgcVmmnfeF3kJCDTLOJxgIHSFagl2rgA04xrA80eIZNI/PQKI?=
 =?us-ascii?Q?cS4n4U0REjdbBUpj7a8P7bOehI255gUEN3HWov3DXS3VIRhXj8TB5ZCRCbQQ?=
 =?us-ascii?Q?aNyPF9PBwAro2gCvHK+Y3SRKwym479uur0amjKmDrFndaEHj7PnLhc9LEVzg?=
 =?us-ascii?Q?xBM86HdTEAzI3j7Zw3lN5BvcAWv6QozI9MP5PMZASnZV0XAM0DUvtlB4CzYj?=
 =?us-ascii?Q?a5Re8R9/CD5dFoO1NLCb0uw+qkIyq3tY2VPQ8iaGuJx8aNCZF0jpln/xJm+W?=
 =?us-ascii?Q?HEtsggkrrrlWZZap+oisQTf/igd0TbnhxhmH3ZpVjhonOvS5INsjqxdkItoZ?=
 =?us-ascii?Q?ugKaLhNQ6TNaCXZPlPCl5qLVOI4xCH8Sq/2Uuw/YIPtFz8+SEalruK1AIemD?=
 =?us-ascii?Q?cvWvFFxyMwnQQ0d4ovPo2cSKi36d0100gTL3u584lPJtOxSFnNZQQXV0Lx5d?=
 =?us-ascii?Q?/r6jOF4aK7sCCHJsZJhY971Rib8LyWhVgRHH2Y3RY0MgAO5HOU6j/MAIxdly?=
 =?us-ascii?Q?1EHd1LTcy5M460mY3nvKgNvxuNNtMFi/ytLWAWcST1oj0FDkMDuxVuTUnt8Q?=
 =?us-ascii?Q?MPheKirz9sRHiKAli9sBxoxrD2TMVjJTCTc4+SgS5MHJpJtyGp8DS9NQrCv3?=
 =?us-ascii?Q?D9bm9HgwGCi0SDZUE8yVD8hLSY6Dy50quQ6jCHb61NmGdGg75UQU6JZgtF2R?=
 =?us-ascii?Q?Dz5xYp3/a7I+3H5xrdQgQVro0joojXc+JwYi76od7CrPzKCXAHQhpcXtwvwk?=
 =?us-ascii?Q?708rYZyTy2xmXNGWrC2Lr87It0oI9yObvZRHT8Q1F5ch+90QfycIjKiPnx3Q?=
 =?us-ascii?Q?icsRYZjdY7Hr6kBr2V1nl8HdMiBlsuptl25V4Z9IEK0eJLM1Bl2UkLoDWnTN?=
 =?us-ascii?Q?7O83ISv3gKWKNj5kt9nHipDWR+GQFEqBMZQpacgYk8vTXaLa+GAuwreEKVIz?=
 =?us-ascii?Q?oJzJAW+0rgzv4V8b07kUcQVEA2BMaqvzoi7rZR42KkDN7vBJ0EAwJsftDE9F?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa87b1c-0941-49f0-72c3-08da61096594
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 17:43:41.4267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cV54rAt20IPI/M0F1wWIrLgky0MKvjsZmercMz2ne7jtpivLdi3rObGUKs4E8EXEgikuwOMf3jkVOOCoEz9ypLNm6ovHoVZYXWLDRoKRwf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define and implement prestera API calls for managing MDB and
  flood domain (ports) entries (create / delete / find calls).

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  19 +++
 .../ethernet/marvell/prestera/prestera_main.c | 144 ++++++++++++++++++
 2 files changed, 163 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index bf7ecb18858a..f22fab02f59c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -369,4 +369,23 @@ struct prestera_lag *prestera_lag_by_id(struct prestera_switch *sw, u16 id);
 
 u16 prestera_port_lag_id(const struct prestera_port *port);
 
+struct prestera_mdb_entry *
+prestera_mdb_entry_create(struct prestera_switch *sw,
+			  const unsigned char *addr, u16 vid);
+void prestera_mdb_entry_destroy(struct prestera_mdb_entry *mdb_entry);
+
+struct prestera_flood_domain *
+prestera_flood_domain_create(struct prestera_switch *sw);
+void prestera_flood_domain_destroy(struct prestera_flood_domain *flood_domain);
+
+int
+prestera_flood_domain_port_create(struct prestera_flood_domain *flood_domain,
+				  struct net_device *dev,
+				  u16 vid);
+void
+prestera_flood_domain_port_destroy(struct prestera_flood_domain_port *port);
+struct prestera_flood_domain_port *
+prestera_flood_domain_port_find(struct prestera_flood_domain *flood_domain,
+				struct net_device *dev, u16 vid);
+
 #endif /* _PRESTERA_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 4b95ef393b6e..04abff9b049d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -915,6 +915,150 @@ static int prestera_netdev_event_handler(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
+struct prestera_mdb_entry *
+prestera_mdb_entry_create(struct prestera_switch *sw,
+			  const unsigned char *addr, u16 vid)
+{
+	struct prestera_flood_domain *flood_domain;
+	struct prestera_mdb_entry *mdb_entry;
+
+	mdb_entry = kzalloc(sizeof(*mdb_entry), GFP_KERNEL);
+	if (!mdb_entry)
+		goto err_mdb_alloc;
+
+	flood_domain = prestera_flood_domain_create(sw);
+	if (!flood_domain)
+		goto err_flood_domain_create;
+
+	mdb_entry->sw = sw;
+	mdb_entry->vid = vid;
+	mdb_entry->flood_domain = flood_domain;
+	ether_addr_copy(mdb_entry->addr, addr);
+
+	if (prestera_hw_mdb_create(mdb_entry))
+		goto err_mdb_hw_create;
+
+	return mdb_entry;
+
+err_mdb_hw_create:
+	prestera_flood_domain_destroy(flood_domain);
+err_flood_domain_create:
+	kfree(mdb_entry);
+err_mdb_alloc:
+	return NULL;
+}
+
+void prestera_mdb_entry_destroy(struct prestera_mdb_entry *mdb_entry)
+{
+	prestera_hw_mdb_destroy(mdb_entry);
+	prestera_flood_domain_destroy(mdb_entry->flood_domain);
+	kfree(mdb_entry);
+}
+
+struct prestera_flood_domain *
+prestera_flood_domain_create(struct prestera_switch *sw)
+{
+	struct prestera_flood_domain *domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain)
+		return NULL;
+
+	domain->sw = sw;
+
+	if (prestera_hw_flood_domain_create(domain)) {
+		kfree(domain);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&domain->flood_domain_port_list);
+
+	return domain;
+}
+
+void prestera_flood_domain_destroy(struct prestera_flood_domain *flood_domain)
+{
+	WARN_ON(!list_empty(&flood_domain->flood_domain_port_list));
+	WARN_ON_ONCE(prestera_hw_flood_domain_destroy(flood_domain));
+	kfree(flood_domain);
+}
+
+int
+prestera_flood_domain_port_create(struct prestera_flood_domain *flood_domain,
+				  struct net_device *dev,
+				  u16 vid)
+{
+	struct prestera_flood_domain_port *flood_domain_port;
+	bool is_first_port_in_list = false;
+	int err;
+
+	flood_domain_port = kzalloc(sizeof(*flood_domain_port), GFP_KERNEL);
+	if (!flood_domain_port) {
+		err = -ENOMEM;
+		goto err_port_alloc;
+	}
+
+	flood_domain_port->vid = vid;
+
+	if (list_empty(&flood_domain->flood_domain_port_list))
+		is_first_port_in_list = true;
+
+	list_add(&flood_domain_port->flood_domain_port_node,
+		 &flood_domain->flood_domain_port_list);
+
+	flood_domain_port->flood_domain = flood_domain;
+	flood_domain_port->dev = dev;
+
+	if (!is_first_port_in_list) {
+		err = prestera_hw_flood_domain_ports_reset(flood_domain);
+		if (err)
+			goto err_prestera_mdb_port_create_hw;
+	}
+
+	err = prestera_hw_flood_domain_ports_set(flood_domain);
+	if (err)
+		goto err_prestera_mdb_port_create_hw;
+
+	return 0;
+
+err_prestera_mdb_port_create_hw:
+	list_del(&flood_domain_port->flood_domain_port_node);
+	kfree(flood_domain_port);
+err_port_alloc:
+	return err;
+}
+
+void
+prestera_flood_domain_port_destroy(struct prestera_flood_domain_port *port)
+{
+	struct prestera_flood_domain *flood_domain = port->flood_domain;
+
+	list_del(&port->flood_domain_port_node);
+
+	WARN_ON_ONCE(prestera_hw_flood_domain_ports_reset(flood_domain));
+
+	if (!list_empty(&flood_domain->flood_domain_port_list))
+		WARN_ON_ONCE(prestera_hw_flood_domain_ports_set(flood_domain));
+
+	kfree(port);
+}
+
+struct prestera_flood_domain_port *
+prestera_flood_domain_port_find(struct prestera_flood_domain *flood_domain,
+				struct net_device *dev, u16 vid)
+{
+	struct prestera_flood_domain_port *flood_domain_port;
+
+	list_for_each_entry(flood_domain_port,
+			    &flood_domain->flood_domain_port_list,
+			    flood_domain_port_node)
+		if (flood_domain_port->dev == dev &&
+		    vid == flood_domain_port->vid)
+			return flood_domain_port;
+
+	return NULL;
+}
+
 static int prestera_netdev_event_handler_register(struct prestera_switch *sw)
 {
 	sw->netdev_nb.notifier_call = prestera_netdev_event_handler;
-- 
2.17.1

