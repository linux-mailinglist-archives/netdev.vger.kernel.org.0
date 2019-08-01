Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF8B7E3AA
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388896AbfHAT5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:35 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388883AbfHAT5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7YUhjZvUfifS/JhCGbRGM8ukfXJ3YtweRwZjWDihgBxqJUnryPQ2AoqUKBPZcfIXmEshuZ2cPpB0k0tEm0opfqtloyUFi+Xxhe6sNoTfo8MLLC6W0PLQ2HB7wa/nqU539YjVT+oYRYWqIyoMNbnAmfPAVg4wIBEFwy33Wjo8D+WooiK9vYtijAL4M3FCwcklf3+Fs1UsJ0zhcbRsgeUPFJskYhPVEzUm+Ld6N5SFrkUohLDuEc2XzpjrtHBghSb4kTF/J3E6gCa5tsYxhalsqeTBYZL5kn0zs/v95IZybOMvYWVVTpWhaWyK5itGqqTAkifpG5yh5Oiovtx8IUoPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csds7jEko4ytaAfIjg6dJ6R7kjQ9Kzgucx0Uy5Lmt7c=;
 b=Y7bEwKbeSeUecVkVW+/pVLqVJox1ZQizNIWLzXeMiUbw5WBCzraUsEL2O0YyTnFQ30MditIXDr/TNHSa21Tx4yowCQ7jGLBC/x5ZtVIFoV4TXxgDa2L+Ixl//HX0Gi9+0BAhqowKGhMyDATIhBn7d+yfkfBs0omUIA317Kd6f5OiyDY2+6G/n7nFb2HhH5GfL8JXP/NMtuUTyfnrghEqgSF9zG9bvjCzgUDvY/jc8z72UxhlEkoMjXdb9So4tnxSASzAiMlWp1ShMuFxZ18VQ8peX6CFAJni3fSPP86O4ygiMbV0uGiAUOotwIAt/wDkjDa/nB/GOQuUNQ4nbU/Xaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csds7jEko4ytaAfIjg6dJ6R7kjQ9Kzgucx0Uy5Lmt7c=;
 b=ZCmfUxKe6VqMQeVQacGbR8Hf5pddv+PCkIzVKNvsdgKPqdciz3931V6UF1FHUTGovYH5PiNz411aG+WAojzaO1YcgfAjGueg2IVABlwbP/ER+Y5HufWQ0+gEND/Ev83a/ndE9em7CpFSFLmfEh+qM/YfVp9TdOHdn8xT2SsqpIM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:57:12 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:57:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/12] net/mlx5e: Allow dropping specific tunnel packets
Thread-Topic: [net-next 12/12] net/mlx5e: Allow dropping specific tunnel
 packets
Thread-Index: AQHVSKNOJnK+7rrhIEC8zW6zpm9bIQ==
Date:   Thu, 1 Aug 2019 19:57:11 +0000
Message-ID: <20190801195620.26180-13-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f4e5bd3-e306-4281-8bce-08d716ba713e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759EC06E34608403C31877DBEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Xluaf1siF71GyjRIUaKCubI7/XnSGF3Q9sU9hwH9Tp3Z015MOoqygcnIqOqmG6fX73W+o5B77zNiZJs2MbY3MhjBZQ/tXQiWcsleWdhZnIDSdmKAaNcXalM3LUHpcjjPtbVhPWUBT+/j/mFSbQq9b/a8C30nNXtFI4MO0l+kJA7KxtjRbjd7p2gOgoeyemy1i/13BFy/rSXPJcptc2X2mKyAsnIiV8xFPY/XbBO074mKMKIpGyuvIlcOhrgvA9N+7H/8yxs+Yh26ZhTkTWiwSiybv3uOQ/9KOGDW5tE4PKMZHTiO/+k3Ki/GJ//2f4ARNUDuiiKRjG1ziRICrcEyQgBI9VyiRkkDlZDFu306I4lTo+lrHliKssDhkcZfNDI5dmyOEoWutl/shdPUpc1nJ14Ye3dnPOwompHDP1LK+Vw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4e5bd3-e306-4281-8bce-08d716ba713e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:57:11.9375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

In some case, we don't want to allow specific tunnel packets
to host that can avoid to take up high CPU (e.g network attacks).
But other tunnel packets which not matched in hardware will be
sent to host too.

    $ tc filter add dev vxlan_sys_4789 \
	    protocol ip chain 0 parent ffff: prio 1 handle 1 \
	    flower dst_ip 1.1.1.100 ip_proto tcp dst_port 80 \
	    enc_dst_ip 2.2.2.100 enc_key_id 100 enc_dst_port 4789 \
	    action tunnel_key unset pipe action drop

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index dc5fc3350b65..c5d75e2ecf54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2485,7 +2485,8 @@ static bool actions_match_supported(struct mlx5e_priv=
 *priv,
=20
 	if (flow_flag_test(flow, EGRESS) &&
 	    !((actions & MLX5_FLOW_CONTEXT_ACTION_DECAP) ||
-	      (actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP)))
+	      (actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
+	      (actions & MLX5_FLOW_CONTEXT_ACTION_DROP)))
 		return false;
=20
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
--=20
2.21.0

