Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812A950D7D1
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbiDYDtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240992AbiDYDtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:49:04 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989DF186C5
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:45:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iexywxTSjKpGFeVq4+1oHdppZJK7jPqkBP2+rbxqdL0zbh2l9TPI+Hc9KRA6Dv6hzl5LIsrfYrJPBMvN/aVAtWTMo67bt59AJYE/OYzAoYG8t4ORkWnxDkt5XXg1unf01xdy/tto/989P/Ayjhx+1aFkUPcOc3mrQw8ZwNLjqAtFJT5D/2DR77myebz4Km224ob1U0mQeFAHwykZ0smQP23AyS7zJYQJqQDlvCg6TDrRivKFATBRGstRdW6HANSDgNCRDqePROeDvzmRgwxSvSZT0W/4k2h/h0ovwWe0L76Z4avZdtt2aLzxT5RPB8tmuGIkvWigiqq/NliVZl1b4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2G97eygCVXG8WLb2AF30bA1N4vugeGp653p6gIpRfL0=;
 b=cneS4PGD73keIgrpGoJCPYOTDxGoeAmpeHBrgUsb/ylGZnKzvZJ0jFI8cDPq/U4PaLCZ7tjbJLYd8VTbSxLQLEDTiAepAiNZu4RBXXWCiCTaXs8WgrdftDR1Np3W5GTqpBeBjqA1gwdU/bsaVz4SitwJfJtBp7vlU3onuixQWWH/+oSA6SySk4254LydnCh8xjVIG4H9lCgzH7K7R/Vw/4EpNbnX26gquVKWlPxunP2l/neYv2zFEDv6pQ4oyIcZ/lstSwp3nhcI/jCK7/0HSSJ+N0torYL8pxSqE5JoFbN91oYxUbqNmEKZpNsIelXEVet8sds7g5HF7utoANQ8Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2G97eygCVXG8WLb2AF30bA1N4vugeGp653p6gIpRfL0=;
 b=ZXkJDkX34Z1ZNn7FKxBIKU+Y085hsvM9HSS4DtbcyqOGEMSx9egzdHOtNwuy6FQh6a8uoK3aGxiG6DAeK6W38PaVYjPQf1i31fFC3LZkFhdzZyDk1IHrgkn6O6a0Lyth/A4Qd/aD+YLER2UgzINVILCc36JNIxu5jLgiBqn9mwHg2F9Td96zp3Vztv1Z4BDyIUirA9wWDKOL2Si/AXeRDFcZofT4dtjMgA75xsNsgJ0UZubocEh1AucgZ2FFzTiCf4mGi52zFQar/zf5EHupuIvqRmaSOLRUeLP67trrFciliDO0VqFV9eoRqLp3cLHlF3+ZDH1oYByLJibjhVbfLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:45:54 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:45:54 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/11] mlxsw: core_linecards: Probe provisioned line cards for devices and attach them
Date:   Mon, 25 Apr 2022 06:44:25 +0300
Message-Id: <20220425034431.3161260-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0253.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5064053c-9afa-4bbe-1db9-08da266e193b
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0255731DF5B403CB78A3A815B2F89@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EiMmPxf/AXPlxfkdmtZSJhQwwjYO21h6njty9gTdEta7fv4Ac/hMhjldZKQAaxFQ70Ro88BVZ5hQ1fZwFEYNR6EWQ3USlytUJOMHacP2d8re/SD4YtLu9mBJEve49squqzfk7HmlnfWiXs++wRzoXn/8Dd/E3MTWYnYjr9LlPlRA4q/qactfnNyty83NQ0balQzH5s2GbQgO7xCWCQU81Viftc6RDnDabg8MNsIqirTWxOGw/NlJLFMIN5IdClNb3nxKQYWc2Gmg+3zq62MmQanS4KkN8iAQ0N8tm9ihWt3rn5xp6EjZQut3XnTLH2or9dsEWxysjxOIrHwNYRg4s/ucsrZODjjy7c0cCFZT+MOxvTN7O4PskOGrR4kmJNroQQHSVaJzDv/RO6AyRb6L3HKpR5krxhtV0OraGlGm452ovB0Xfitk4lSQB7IkFQP5frhEYxhs9seiL7EAs3ICw2qpaPHC4OcJ+ceoFbdZUCOgz3SrRXCFG8+dBJm+eUqiruTBhABCJAZosbXINdn+joxn1LWLoKzLyvXhyxll+hk7zCA3EYOCdPAU5cJaE2r5JHh2o61BoYbWD5aKww0NaWHC65LF23uS6RIczepsHXIYnLItX8IlkIhwU0PwTTieNas0UU3Dqgc8CRP3lzrSTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(316002)(6486002)(508600001)(8676002)(66556008)(66476007)(86362001)(6916009)(38100700002)(66946007)(5660300002)(6666004)(6506007)(2906002)(36756003)(6512007)(83380400001)(26005)(186003)(8936002)(2616005)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z5gyGXf5PQmBAalMMEifam+F8EXW1xbxrjFnksJ5TduKN5VgmqrAZF5fivh2?=
 =?us-ascii?Q?O2zKzZskRyCDdByxWKgy+RdLKcDnBfSAbAX5Uuws1a8FFsE7hnPoknfTqHWT?=
 =?us-ascii?Q?LbNIbkKrSyXMgfzzuayXq3S1HMS6MXFT00beeaudx1sL9Dy6FLhVijCS4Wgt?=
 =?us-ascii?Q?xGqSr92EcqFPNMbUJPvD1+KPGsAkNjLRGs8v1bgfH1DLjDAOCS3+wVmDJSb5?=
 =?us-ascii?Q?SFgRxR0+bXhmG/tZDYVuJHh3gZUt6f5Xcus+cywP7ygz2eAJ54d4Y2dOqE6B?=
 =?us-ascii?Q?J6yRyMSF1GKVgZot2zeFbi/M40wVIqLTkWbh7l5cKebxQUEqAnbgYEvCmu4v?=
 =?us-ascii?Q?2dd7n56AWCY69Z+pXVI3w3jYdq/glpmOjVOvG1XqJPTkRh2c06O/BNV5eBPd?=
 =?us-ascii?Q?wWas64PNaZe5k1vXh75n1L9OX3jerhtRkmEVfjWrHDPk/javxit2dpmEasUJ?=
 =?us-ascii?Q?hkjyYBfwLoISlmuxmrathktSwJp+AJAIx1FkoBwCOUTL3LeSN7Rn+lPKHUGl?=
 =?us-ascii?Q?1jFiX0NhknXQO6UoDzcawy6xeu3Y86EAq0y5wvkJTpOUfUZJi34gZlE6VE6B?=
 =?us-ascii?Q?EYLrwEqoEMEN1N/b/d8kuHdbmczn9Ih3ZczMmTNtarDxkQkG0VoEHMSpU7pr?=
 =?us-ascii?Q?gh4Qtd9XI0osxVGurEYvVGBQPwhFafxJf9g+Q7srKYueGqJX7EhEFc4ELRNJ?=
 =?us-ascii?Q?dbOoLtmlfRccYHyM9f8hRmYEXEg4jpYLTZPt2/M66jLIKm8sRm8N5VUeeKGI?=
 =?us-ascii?Q?7DvDcaMT1EBg7xnt5iklwCxzpbYcS93ubBPYw6r2eIMRHgEo8T+iTa9kTnQl?=
 =?us-ascii?Q?0ArOf29fbh5yE+FeOL6m6hC27pfPqVkeE9jnSmwYXIDjcQspbjqFyR0/YQNz?=
 =?us-ascii?Q?FE3ERdsKrKLayWLajx2AODcRTwtCWDtWDlio7uVEzxFVWfHbG5UOTz5fNtGZ?=
 =?us-ascii?Q?DeJI24B/OR/2q/qHDBVRvaFAL7I0hho4X/tBFZVc3J+YtcDpfcNSYjivh9Hq?=
 =?us-ascii?Q?ImgiIA262eKAQIlh3RNk/djM791rnX450yb1O3/6nP6bdrC4xLA2JVHut2/r?=
 =?us-ascii?Q?9w0AKUIKgZ9XCNcA5xdigsEyBPsIjaT1wLXVgn+DU2Ua52fmFK+T8DYHJNZy?=
 =?us-ascii?Q?n+XpJrYccGt5dnSDNHoVErsLcj6iP4e4/dGgVVKUU6xaBPLwL/1jH1/evwPX?=
 =?us-ascii?Q?ZhVykHoYL7WpTWNAUBR+J+CZFuRGFog1Le7EDO59hi0cTHwihAauXeDzw1YX?=
 =?us-ascii?Q?SAiKb1zAMCULVgC/XN5vrXElpl66sltFCZeMYeKqObrRYO63X67cBNc3FRwP?=
 =?us-ascii?Q?qWqEOCBnXnRtUTYat7t3yik1/Ln03lo2muwrdtFweGiLz87WyJp9x3lq39Ap?=
 =?us-ascii?Q?xpGN1a/Qox9LHhNqa3RUWQbY/c8tnbilBmon4TMwh6TLhDVVET9zMq83XsUH?=
 =?us-ascii?Q?ehWPqY7WkD0hVXWlZbjKWtPIzwp4oxMYsblvGLKFfNpwnQQM793vsHnpkEn7?=
 =?us-ascii?Q?mvFNhSZTghJjIOr4wk1cDdR423rfO/BBzQumkbet2oBqznUOSfzSQGxhzbES?=
 =?us-ascii?Q?W8+JZl6v+rgQkofYNfCKZsbkzNmsakWNSwWbV3giHnQi3YyEOaMTxnqK/fQe?=
 =?us-ascii?Q?z8B+lZOwGMvYlfnYgWAT7tL6RJt5P+xkND8S+85/Yd+uSz/1yzj2SQ6P11TJ?=
 =?us-ascii?Q?STX1Jnqaxg2MdeoQzYwxMXDCfuHRga1x+HXCcYK55CfzOgqoe9ceW7U0uAUp?=
 =?us-ascii?Q?IFyCa6/L6A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5064053c-9afa-4bbe-1db9-08da266e193b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:45:53.9783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1cLrs7Sh/Knrce/oipjOy8vwcf3AlTgBCF5rN6S17E0yV/I+s94YlFgjC6l5J86Tf0vw4PiZ9y4cJHYp78XKHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0255
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In case the line card is provisioned, go over all possible existing
devices (gearboxes) on it and attach them, so devlink core is aware of
them.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  1 +
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 99 +++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index c2a891287047..d008282d7f2e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -581,6 +581,7 @@ struct mlxsw_linecard {
 	   active:1;
 	u16 hw_revision;
 	u16 ini_version;
+	struct list_head device_list;
 };
 
 struct mlxsw_linecard_types_info;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 5c9869dcf674..9dd8a56add4a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -87,11 +87,101 @@ static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
 	return linecard->name;
 }
 
+struct mlxsw_linecard_device {
+	struct list_head list;
+	u8 index;
+	struct mlxsw_linecard *linecard;
+	struct devlink_linecard_device *devlink_device;
+};
+
+static int mlxsw_linecard_device_attach(struct mlxsw_core *mlxsw_core,
+					struct mlxsw_linecard *linecard,
+					u8 device_index, bool flash_owner)
+{
+	struct mlxsw_linecard_device *device;
+	int err;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device)
+		return -ENOMEM;
+	device->index = device_index;
+	device->linecard = linecard;
+
+	device->devlink_device = devlink_linecard_device_create(linecard->devlink_linecard,
+								device_index, NULL);
+	if (IS_ERR(device->devlink_device)) {
+		err = PTR_ERR(device->devlink_device);
+		goto err_devlink_linecard_device_attach;
+	}
+
+	list_add_tail(&device->list, &linecard->device_list);
+	return 0;
+
+err_devlink_linecard_device_attach:
+	kfree(device);
+	return err;
+}
+
+static void mlxsw_linecard_device_detach(struct mlxsw_core *mlxsw_core,
+					 struct mlxsw_linecard *linecard,
+					 struct mlxsw_linecard_device *device)
+{
+	list_del(&device->list);
+	devlink_linecard_device_destroy(linecard->devlink_linecard,
+					device->devlink_device);
+	kfree(device);
+}
+
+static void mlxsw_linecard_devices_detach(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	struct mlxsw_linecard_device *device, *tmp;
+
+	list_for_each_entry_safe(device, tmp, &linecard->device_list, list)
+		mlxsw_linecard_device_detach(mlxsw_core, linecard, device);
+}
+
+static int mlxsw_linecard_devices_attach(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	u8 msg_seq = 0;
+	int err;
+
+	do {
+		char mddq_pl[MLXSW_REG_MDDQ_LEN];
+		bool flash_owner;
+		bool data_valid;
+		u8 device_index;
+
+		mlxsw_reg_mddq_device_info_pack(mddq_pl, linecard->slot_index,
+						msg_seq);
+		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddq), mddq_pl);
+		if (err)
+			return err;
+		mlxsw_reg_mddq_device_info_unpack(mddq_pl, &msg_seq,
+						  &data_valid, &flash_owner,
+						  &device_index);
+		if (!data_valid)
+			break;
+		err = mlxsw_linecard_device_attach(mlxsw_core, linecard,
+						   device_index, flash_owner);
+		if (err)
+			goto rollback;
+	} while (msg_seq);
+
+	return 0;
+
+rollback:
+	mlxsw_linecard_devices_detach(linecard);
+	return err;
+}
+
 static void mlxsw_linecard_provision_fail(struct mlxsw_linecard *linecard)
 {
 	linecard->provisioned = false;
 	linecard->ready = false;
 	linecard->active = false;
+	mlxsw_linecard_devices_detach(linecard);
 	devlink_linecard_provision_fail(linecard->devlink_linecard);
 }
 
@@ -232,6 +322,7 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 {
 	struct mlxsw_linecards *linecards = linecard->linecards;
 	const char *type;
+	int err;
 
 	type = mlxsw_linecard_types_lookup(linecards, card_type);
 	mlxsw_linecard_status_event_done(linecard,
@@ -249,6 +340,11 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 			return PTR_ERR(type);
 		}
 	}
+	err = mlxsw_linecard_devices_attach(linecard);
+	if (err) {
+		mlxsw_linecard_provision_fail(linecard);
+		return err;
+	}
 	linecard->provisioned = true;
 	linecard->hw_revision = hw_revision;
 	linecard->ini_version = ini_version;
@@ -261,6 +357,7 @@ static void mlxsw_linecard_provision_clear(struct mlxsw_linecard *linecard)
 	mlxsw_linecard_status_event_done(linecard,
 					 MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION);
 	linecard->provisioned = false;
+	mlxsw_linecard_devices_detach(linecard);
 	devlink_linecard_provision_clear(linecard->devlink_linecard);
 }
 
@@ -840,6 +937,7 @@ static int mlxsw_linecard_init(struct mlxsw_core *mlxsw_core,
 	linecard->slot_index = slot_index;
 	linecard->linecards = linecards;
 	mutex_init(&linecard->lock);
+	INIT_LIST_HEAD(&linecard->device_list);
 
 	devlink_linecard = devlink_linecard_create(priv_to_devlink(mlxsw_core),
 						   slot_index, &mlxsw_linecard_ops,
@@ -885,6 +983,7 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
 	mlxsw_core_flush_owq();
 	if (linecard->active)
 		mlxsw_linecard_active_clear(linecard);
+	mlxsw_linecard_devices_detach(linecard);
 	devlink_linecard_destroy(linecard->devlink_linecard);
 	mutex_destroy(&linecard->lock);
 }
-- 
2.33.1

