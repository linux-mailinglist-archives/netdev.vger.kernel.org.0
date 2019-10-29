Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5B6E93DA
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfJ2XqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:11 -0400
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:58478
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfJ2XqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqIR4YDm/eKt3awrMEOxEMTfXHMOVUapB+4OI6kIvASk7K7BEplPX2fGPGX6CCJDI75eLBAJmmzI/MWO5k9gHYqWJE710fdKQLANpPc6t8C9TVvVDmjLFth0Qggl97t87yLd0XTJgZeR7G+nRAwmBa2uDMNx+q4VMLYvQj8JPRlNcBT4A4MnY4mqybnBO2CZegcP97+S5zrmrowlO7B2kNepg3nV5SFxH+u5+HucqgGjcA0hUQjLOvAJ4mCRIkYrftHoUotRpXJfoAaVKiRM3VIf1v9+V3/LzBctI3c+ajXH9qIQqAyexxyArs3Mn1gRINcE8yUDxqIuGZN0BxYybg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBCIR60K3WMHBJjcllZ7YBoVZNNxzrbohFUYITnRV8k=;
 b=BwTetiIdUji0BYRUwzWl3e2wXGmOrdN6e0Xwb9Yu3xt2QXo9BKKqx4/qAZakH+69j/Hq1pWxlLV5nUs7KF/xtHhSB7Qu79CWHr1hcvz81L2EEw3+Am8qNrMOxGb9kOnearE1Nq5JoIfnHNUwCRSW+JapSi7UUIT0lVUE+P4sPxlAcUHCWUP8V93dztSxM1vsVWqSZe4eiDyPazLZrdVQkvY6J3u8JvfHKNw8FaC/vGq8r8G2+YKUmSB/9Ix7d/LVZXq5ha/HV0opLAr7NERxKCzXKDfwn/AGRj0da7plsYHOU0yhWMYlPTwuPLyfLETxeYtWxHmVTgizQM7+hefaHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBCIR60K3WMHBJjcllZ7YBoVZNNxzrbohFUYITnRV8k=;
 b=GxS90Uk4QU2Sx/z6ep0H8pg2iQw5AbjBq+2fPXF8Db8qvaKC3HIKBXuCJIOb47BIb1PxopMM8cl2v0lo9tH1D5MSbYVO9IxCA9G/Jhd33RT87WnBZcVW/IbLnyAWWxbPsbxy4Eco/u0Kx2NfzXlNfAgnHBL7CrN4LOIlMX73Bxo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:45:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:45:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 01/11] net/mlx5: Fix flow counter list auto bits struct
Thread-Topic: [net V2 01/11] net/mlx5: Fix flow counter list auto bits struct
Thread-Index: AQHVjrL/hBDesVKTokatO6WNhCd/1Q==
Date:   Tue, 29 Oct 2019 23:45:52 +0000
Message-ID: <20191029234526.3145-2-saeedm@mellanox.com>
References: <20191029234526.3145-1-saeedm@mellanox.com>
In-Reply-To: <20191029234526.3145-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:a03:117::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 17625fdc-77e2-4e20-72a4-08d75cca2220
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6157D51E3FE5BD6EF25624FFBE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(11346002)(6116002)(8676002)(54906003)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(446003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(76176011)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IeX64HEYSS6Zyrbw3er5Dhu4ktn8zQJpWAzgDMtfHUp2Qipw7mha6x8p1IacODImnVBjUgCM+0izCdVQRXEd7CaKgmwc+wtJivbFbP9e+oLISQI6ji08AZ1Y5H9Mc3ceyP6LZvIj5Mfie+72ceApNsRfryDve9eHZ3GrAGzG1/jNyi3lvQXw26OoFRokgQ98J6qv5QIk/Ek+VAnu5cfFzw3cVPu7IH6t2rXEEH8G/4DlJUSC7V1A12fxyehSwPhtkV9vKekgQYODCnNk+XIPxqByEEnaEq1NLP9CHsjFxI8QI1e809xDNsNj6reEzabC+PUkFzdHMfUIv3ZKgfFcY3aaOwy2PRWRSMdn01kMnqAQXcPGfX2hONteW5/0L5dwBqwwzZTxAJnIun6ajCIP4iBIy1wqWKxexL2vUZFRtQyrNKYf3lx8W1dFi746uP3D
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17625fdc-77e2-4e20-72a4-08d75cca2220
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:45:52.6502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3q/84c3JshvHg/K7T4hqlIG/S+9SAOTvHEhKWDuCfKcGJtD0jp2+WjKioNaxLU40dZZul+DyrAGC4pn/LgnEMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

The union should contain the extended dest and counter list.
Remove the resevered 0x40 bits which is redundant.
This change doesn't break any functionally.
Everything works today because the code in fs_cmd.c is using
the correct structs if extended dest or the basic dest.

Fixes: 1b115498598f ("net/mlx5: Introduce extended destination fields")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 138c50d5a353..0836fe232f97 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1545,9 +1545,8 @@ struct mlx5_ifc_extended_dest_format_bits {
 };
=20
 union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits {
-	struct mlx5_ifc_dest_format_struct_bits dest_format_struct;
+	struct mlx5_ifc_extended_dest_format_bits extended_dest_format;
 	struct mlx5_ifc_flow_counter_list_bits flow_counter_list;
-	u8         reserved_at_0[0x40];
 };
=20
 struct mlx5_ifc_fte_match_param_bits {
--=20
2.21.0

