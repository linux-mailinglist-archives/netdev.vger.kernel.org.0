Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11E4132F19
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgAGTOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:14 -0500
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728726AbgAGTON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQQHw3CQggX7l8QZSxDceGobWD0ma9J3RfuN34QgAo/FNh/KBGQV5GjBC+dREKy2qcT6qxVFKJOwLtLczJbjSM2MINijaEmm2IjjhXj8ud8KYGjJ/CEm35rwwMPlq5a+OZSwjGXhW2opjSDnJdu02ZLRQBbfS8NgeRBUNjQewgUxXI/vlyiSJrWkSDkWfGXkF4fgyKyIYcLwSuigPMa2X+fgpKIMt7AbOBHwsK9seetevhjzGQwGOfVZORlQDr6+iiZ3xAi2Y6fBqT/WVThRk57LKP44zoDT7X5TmcUA0XSWn5YyUgxEW2QYJgPIiLHvyaIpWrffzSMLrVCaPKvL+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRLMYMthbd9Xqg5YbjZ4d/hqJarR+KTsQZcgbv5a2kE=;
 b=FZF9+fsCFVW4TZ7p9+lDkBNFZAIUT+IR0HpADZIGPIOPfsQsFyNTrmwiKN8D5w6xZWIk8wdAVgTAGfLb4b8eXLou7ENQrJj+Evogn8wlgcq50BRs7Ap+tW+oU8prlErFVLxbLV36kqzx56MpdnO72BeaDCmNtp3aS76FtWNH846k3mi598P2UGxWejpNAA7NGSjDRFdRqVKOao7fDajQMpN4XNp8I9wkai6ucnItjI/vbB1f94LBDl+wKgWZUUGBxGfH+TLFAEIJMoYhWayo2AfAlNYMT6aMwJ3fmD8sfcMWruYXz9Cc6BNg6bIFe37W6bjKza0L5OEnagIe/mUw0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRLMYMthbd9Xqg5YbjZ4d/hqJarR+KTsQZcgbv5a2kE=;
 b=V18FUQ4QFHH2sxx+lnzZ+4xvFkfzP9K+ENPj5ikM89+BXcUVbv/R1HzABsCUABwk4T5+VHskKLD4YvNoJ1v/9T6fhAXZBRtEnJn8WV+qHdyIaNWSyJMqWMCsyvxNQAZoox4C3iGVaWjCMVG0YsgjLTxZlQYgqZdBR0nBOTo4cAI=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:08 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:08 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Adhemerval Zanella <adhemerval.zanella@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/13] mlx5: work around high stack usage with gcc
Thread-Topic: [net-next 02/13] mlx5: work around high stack usage with gcc
Thread-Index: AQHVxY6iNHZ24W5b1kyKQWJG1DozAw==
Date:   Tue, 7 Jan 2020 19:14:08 +0000
Message-ID: <20200107191335.12272-3-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fdacf673-1009-4fb1-6cb8-08d793a5c56a
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411909FF9AEFFA1342B91CEBE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(966005)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: awJGIG2GSGcaBnstbKY5EZyiY9mk1FQH2r1d71oMZ/LWuTGi+QOJmG1BSf7N3xZOQkAtQyV4LwhfSxuNrYptXCVAwb3FGTYNkTa1KfUF340Gx6kJanqs0dJy8mbOEHtezTk6nlk0vUwrLaSpqBPjuvHiUh+pLXRcU1Ek5RHto6DVlMwzt2ekg9JhKeq6ZxUe9l/LIkXqxiSB3q6RjF1sWuXOB9cF9yhYBhq1a0O70Y0lmHJq7az8BKGpxq3+2qDy13rk5qHGGRy0xzw83mYD2zTihSkcZ9mKYC7Tb8NHFhWy7c8SfvCqQgyEF5d9xDLm5XBANKavwJ2CVR3zhjpZhfA3OZmTBDpf2qhd+KFSHqqgFnQNO3S+Wn7gU4ypo5mBHhJ5E9VdqyYJrf6WKoFsi3KhSP+gAfBfCqwN2ahEEXTzEwZ+gZBmPnOxwdBMQGZ8DQ1n1Hx1oGRezVSVu8PsJ2E7E9kA03XV2STR4SngmH8kGSwqHeRbri/ePDOSvhgVlFW3kdSEu6w9Q3D62yqiy4CK1YAlGuUwBzMo++rHDpeJkyJ3KMLuqhZS6CzyFBXVnq6pG2z0XDagIdAx6P6nRQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdacf673-1009-4fb1-6cb8-08d793a5c56a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:08.8207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Mw5u4fVRr9iupaCAiPzPcMi3CZAxlNG/MQZ1J56bKOr8KzS5xWydVy9CiVWI3IOGL9aVTLnv4f+RraeOlGYRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

In some configurations, gcc tries too hard to optimize this code:

drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'mlx5e_grp_=
sw_update_stats':
drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:302:1: error: the frame =
size of 1336 bytes is larger than 1024 bytes [-Werror=3Dframe-larger-than=
=3D]

As was stated in the bug report, the reason is that gcc runs into a corner
case in the register allocator that is rather hard to fix in a good way.

As there is an easy way to work around it, just add a comment and the
barrier that stops gcc from trying to overoptimize the function.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D92657
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 9f09253f9f46..a05158472ed1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -297,6 +297,9 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv=
 *priv)
 			s->tx_tls_drop_bypass_req   +=3D sq_stats->tls_drop_bypass_req;
 #endif
 			s->tx_cqes		+=3D sq_stats->cqes;
+
+			/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D92657 */
+			barrier();
 		}
 	}
 }
--=20
2.24.1

