Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3473D114410
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 16:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfLEPvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 10:51:18 -0500
Received: from mail-eopbgr40074.outbound.protection.outlook.com ([40.107.4.74]:63710
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726257AbfLEPvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 10:51:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTTZLKH+4Ab3NHchLqR/ZjUhOCYfclJQz5oxuljRVAcqUTW+3jiZ3frqUt1dUQoKrmqqxLXFAle+fLIKymvQfud4n/GG3Axthx5kax9MZ7aRQu8YDjVv+0lnI1VjdKoGK9pvsevgNIBxca8A46NbgfeXDLHP+pemfhzvz1a5Ll7GKmeo+quJI6waNbdKPvlynAwPKR9mls0HicZ/e3dMf+uExkBwTjnQsayBTX65KHtK+CPduI2jIeXG8qCyeJDPcxgae9tkmee8yvHn9lLX0SShcyKMYsImrauFFeOmnPReOSyQ/J9G9JaFOYr/67F1mJoCH/CqiVUsUpAqrdFXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPwa8YClzj1sBR/jhGOwNKtEuYJvVUvidqysfE2SDXQ=;
 b=FElDCioXwMwom+YDJvu8nw8G+HkLhO4knQop8BrAdZhmalxkbEvIju1f9nPDniWCXpeLFZDhqAh8s0Wt5wUd6eZOYfP92jVCbd69aEHUtAJYWkLP8TGcwEygF9Yviss+xfIbXH4nR9WWCDI39Bt5Okv4k9IU2oGnt/aiKMf/jp7Y3UP8Q9Uz2/ur68jcjzZhMH6ErdNiFEnj7HeKJJnZR7F5eW8X94GA5kjQFjJqsrvn8CgSOua1JXDExIEnUjm7/XzLdQJ6wFQlp4J4SVRe+1/8Ze1T0TKeHJdSl/icTiM7WY179OUTUKGIV5u2HdBfev+ig071YEvMYiInMiyoNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPwa8YClzj1sBR/jhGOwNKtEuYJvVUvidqysfE2SDXQ=;
 b=BzFuKsFqW4MeHjgf2dS1ma5aa2IVazhuBlAGkHtiuKWBTMGTLD2DgKvPKBsjaE7Vg90+Nohr7ZlkQPeZsy73LzimjgXIKlGU3DEb5+qHIBw162jshsHFJ4nfE16wL4z+tAqGdt+nniNABizeQaWPmjjKLyr6PpXU5s5AJM+C9sU=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4851.eurprd05.prod.outlook.com (20.176.214.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Thu, 5 Dec 2019 15:51:12 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e%7]) with mapi id 15.20.2516.013; Thu, 5 Dec 2019
 15:51:12 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf 1/4] xsk: Add rcu_read_lock around the XSK wakeup
Thread-Topic: [PATCH bpf 1/4] xsk: Add rcu_read_lock around the XSK wakeup
Thread-Index: AQHVq4PRxDWEP0FUaEaxvK9Arnl1rw==
Date:   Thu, 5 Dec 2019 15:51:12 +0000
Message-ID: <20191205155028.28854-2-maximmi@mellanox.com>
References: <20191205155028.28854-1-maximmi@mellanox.com>
In-Reply-To: <20191205155028.28854-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0044.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::21) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 33c4aa0e-6b6c-458d-365f-08d7799af41b
x-ms-traffictypediagnostic: AM0PR05MB4851:|AM0PR05MB4851:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4851FE6E415FCCB333C490DAD15C0@AM0PR05MB4851.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(189003)(199004)(6506007)(50226002)(6512007)(316002)(2906002)(81156014)(8936002)(102836004)(99286004)(8676002)(4326008)(76176011)(86362001)(305945005)(25786009)(64756008)(11346002)(2616005)(186003)(7416002)(54906003)(71190400001)(36756003)(478600001)(52116002)(14454004)(81166006)(5660300002)(14444005)(66476007)(71200400001)(66946007)(6486002)(66556008)(107886003)(1076003)(110136005)(66446008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4851;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GOI8bGnHmHESvwR8y7ITBz/0ob+8vygSKBg/XxIA0Spniy0UcxCfJ6D1hNxeUhNgO/HzzaKeoBgwfzhLa4ZdiVnPlua+L4v5ct2yvfqaWCMr0skShEq9keg9O8thF2dXMs7+bTJ0sAgJ6eSO16GY3Xa6rTy5kKO39lN/Nlsw72lAkzG2ImhwcE6v8V+bBXEwcqUE1ZpYpxjOeuxohTY5bPSaWt/nvaWPIPfF3prRDd8PKbg2+bO7Y/rByonkku5VhLXcAjlvcs41p0HFJ5+ciaGZoK7UgX9fOGlUaaCSIqu20dMtFyZVKV1sdH/u0Sdo2dIQjUFTFu+dN0mPiivfjUVgVg0a7gR6sFVhlzb8+2KKPcjf8hhw4Wscl7UsibnVso6Vf2iNW3c0y5IJYBtEwkh15vOXbXl4W8KZpftafJ2gSmVJybQ7Cfl406C7mAhu
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c4aa0e-6b6c-458d-365f-08d7799af41b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 15:51:12.5492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hyS4cLf6ah4qdp+QPCXZA+LT2A7s+rVle+AKojoR/LPza3ou74kBzW4cRhluFA7u7ZcgB5PjwrEgDz5eW2IHgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XSK wakeup callback in drivers makes some sanity checks before
triggering NAPI. However, some configuration changes may occur during
this function that affect the result of those checks. For example, the
interface can go down, and all the resources will be destroyed after the
checks in the wakeup function, but before it attempts to use these
resources. Wrap this callback in rcu_read_lock to allow driver to
synchronize_rcu before actually destroying the resources.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 net/xdp/xsk.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 956793893c9d..d2261c90f03a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -337,9 +337,13 @@ EXPORT_SYMBOL(xsk_umem_consume_tx);
 static int xsk_zc_xmit(struct xdp_sock *xs)
 {
 	struct net_device *dev =3D xs->dev;
+	int err;
=20
-	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
-					       XDP_WAKEUP_TX);
+	rcu_read_lock();
+	err =3D dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, XDP_WAKEUP_TX)=
;
+	rcu_read_unlock();
+
+	return err;
 }
=20
 static void xsk_destruct_skb(struct sk_buff *skb)
--=20
2.20.1

