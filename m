Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302B83E5712
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239144AbhHJJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:35:24 -0400
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:52097
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234188AbhHJJfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 05:35:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rb6bWnJL/Jt5Xvph27YTqJEkSpHJZqeLVRqpS9LWu0emy9ovJx+ucGG6W3gNWDywqznnW+E2qf07H8XauTUmY15PMNGe6NrKLsWBh4x8xKxT6R/DsjMCHAef0FCmQVRW5mkJtLk1frYxPQIopsbZYd5dGlaRt1XL3zzcEL0KIwkPakOyb86mEaNA9aoMANR6QXgxcKV/Il4w0UQLrDpqn+PivLtuIyctNIjpLvT6OINbUJAp8v70ywfuMEcsX49mywqBw8XZ41KzAD2PJ2BCqamNCa7nioMYSIunfQrBsqPMfZuOJycWLV5TgKM0Dek5FxHSmANZcRh1hAeqm3IQOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApJ5sLXC4cfgLIM6imu8gADWDLGOZAxD4WkS0TCOmFk=;
 b=nTkemH3MGNwKhJskJl4e9eKZyFssr3el/vdT9arOHkPGJ/rDeCkWLKoGU2z6CoGkxg5SAOIyPrEdP9BDi8EuWqp/TLOmpGIM898VGk3TbR6MHfFAJl44vTLkodpV03WuQWNd79F5d83lOhJCIZar4jOpTqUbI+Pq5Fpr0hcLfhY8bxoXZDzufAztfpjy+cfAhH0nAH54Tt1pIyfrMTPvMMTJICLcUSfm6dJUpKoN5Og62NXzBOzRDmcEZyCwKj4ycNqT68Ah0WIi5rJSVK5kOjx5+uZlVm44Tn8GiOfxs4YygJaDq1pd+XPGFAU4zsK1dytRMCpnpBfUWAdrmeC9+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApJ5sLXC4cfgLIM6imu8gADWDLGOZAxD4WkS0TCOmFk=;
 b=XHo4+Lc6UY72wxWYr9xyMfVcnHdeIHnvIRiv9Sk/sBQ4FApyfg27JBKeKLv2x6NYW3DrBbX7EZ1e5SKRjPKq8kE+lBA83vz3u45J1b1NMTICaipKCjU8AQvpk2IfYyBWToZ4+SrW9UGFQoHc9VAugio7JT7rfdjwDOq/G/ZGyY4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 09:34:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 09:34:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Leon Romanovsky <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Thread-Topic: [PATCH net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
Thread-Index: AQHXjSAoM5FylMZBM0itAyPu8B/6WKtsTdGAgAAX6QCAAA/AAIAABjsA
Date:   Tue, 10 Aug 2021 09:34:57 +0000
Message-ID: <20210810093456.3ojqgvhe6ivo7sdr@skbuf>
References: <20210809131152.509092-1-vladimir.oltean@nxp.com>
 <YRIhwQ3ji8eqPQOQ@unreal> <20210810081616.wjx6jnlh3qxqsfm2@skbuf>
 <20210810091238.GB1343@shell.armlinux.org.uk>
In-Reply-To: <20210810091238.GB1343@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7288cdcd-b889-4044-a992-08d95be21e3b
x-ms-traffictypediagnostic: VI1PR04MB4813:
x-microsoft-antispam-prvs: <VI1PR04MB48132B08AA12EDB0B9B1D7AAE0F79@VI1PR04MB4813.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n7IBXFFOOBzvdblMsAiCBQcyjJDfMMA6LNhCvZLDOtd+k5OI437OD6Ues+1+7QxfoApi6ihDO6rG2rCx9k0BfBL6XDjgkOhZvuRSd0AzQvcLrPwWeP7h7p9gjexQc3sxHQoxZCuKIL7YUmF9h26z+NEQpiMnqmf6eDO2VJaszEBqqJD7nmePuX9iy4fNC0yaNxpI811tv5XzD7zMuNJmBoCwSfmaj18Qve0EFHcdKmMkjJMFABnIm/WL5o9Rz27pHOPpquMid6tgKr0nknoF9EtytePaFddBdP/3RwzGg89w8djqZ7vRSp5akjcvbRYaoXBwc0/jK5Seo9qFtM8X52mpiPSMOI7EnW59uGMrWqItwJEJoOMV8xKCJQXI1a9GKqoORQW57UljG7NDPqoveyZsusrYtm9Zhw/ZHxE6WKuDgxqWle1MPXYFHZfi+RL5Bv1WcOlCTtML0D/Em9f49mNdg3POvQ7rwg7MXDGxZOSJmUFbegj80M3KeloVvpmxi2LPj0idzkTbrFRt2//7qgr2IxhBjh6yWsq3zXAVegobOCAOT7qiA/u0cdXCLcrfeUOr03fD1TSflhQihWVA0FieJXigRf6TnhhNEoTpT/DB/Wc96+M655u7BiLlDnX6YeIuOrLU656G63dGX7eK2EgFGFKNupuVrwV9JtPCIB+wBc745+vEnnUX6zTDZqOUqMa0uOh7uIeYTlmjag5ifw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(396003)(39860400002)(346002)(376002)(136003)(38070700005)(2906002)(6916009)(38100700002)(122000001)(83380400001)(66946007)(64756008)(6506007)(86362001)(4744005)(76116006)(91956017)(6512007)(66446008)(6486002)(9686003)(71200400001)(4326008)(5660300002)(8936002)(33716001)(54906003)(44832011)(7416002)(8676002)(26005)(7406005)(1076003)(66556008)(316002)(478600001)(186003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AdFSMIBUQ/cYhDRjaF/PJSR9ehCeLT+pN9T+UYnTxAqjKOHlGJRcBKRF5FV7?=
 =?us-ascii?Q?3dm343Dr6AlURBdKwIn1K1UY1VcWY6HpOvP/lvs/0EWL44FfcdVGSpq13N+8?=
 =?us-ascii?Q?VgYYyJHSe4xhXyknBx0F5RaEfUy+Nox8JV8jPbDKguQdJACNAHxphw7ri7Z3?=
 =?us-ascii?Q?vzYiojlLNaN+ZKWZAKKO+F6TYO0D2MNdWeEtmjnN0M4/+zb7JCvGGQuLJCPZ?=
 =?us-ascii?Q?wh4yHz+bDENkDgek6HWWqLJgIscsn+KJnb9OLtZ/PNMOU//PLyM1QASJ18Ng?=
 =?us-ascii?Q?1s1/Itde42xUS8ldvM8taaejziZJC9T2DmHufqV02s43LJQuzFPULj3yOEL0?=
 =?us-ascii?Q?TQKkRWWU+Le7YVwsNYjGI/7sJW4NsZD2qIqbHCmaQVOZMsSer76t99jJsL8U?=
 =?us-ascii?Q?QKB3G9TNX5ldWGkNgatKsI4i7J5JQnX/At6oBtPV9oYaj2NPMLtkFRLRH5Cn?=
 =?us-ascii?Q?KYQd+UTtrh0QO+D7BYkLgSBpX4+B1sb3y2SH7/NTdZyspkmvJAOcyWJPg2mk?=
 =?us-ascii?Q?Qff6bsEclqZ4cQUlqLbNYhXnAkhmT4Ffphha9NFuC7YaVFd2/MTc70rsB4Hl?=
 =?us-ascii?Q?0Fu3CJCrm+9HJBSr53kVCv4SCa8Lwh2wKeZcaLjryb7KJaXO0HcdrYTnGD6N?=
 =?us-ascii?Q?tBqc8CgDtLFIPbVg7o0Ag3rRCZGMgPxFcDSNB1/VVvZ0WvQN7K8qdmpd9zD5?=
 =?us-ascii?Q?3EGemSYAMQAIM100mAE4XQjNFblFiNSO4Uf4HiURTr7rLWLVbouc743+nw07?=
 =?us-ascii?Q?NwsfLAKb1QSjkJGJ9xFLlFXZhFvbUmpzKl4WLYwialNIuZ+G/6Ti8dA1ThQr?=
 =?us-ascii?Q?LXlIVbLQuNszIGiSeW3X/OReKrw4cyFcbzp933/oJ5NNGqaHqO9ZivuYa9Fg?=
 =?us-ascii?Q?vHiMbsbE63mGlQZCrtyj4sSMPaveHzZYOhqPQknrHAq6Vr1ZjKSMo08kCdGy?=
 =?us-ascii?Q?T3FFBG6HcVYRQBQRJtTf9mrRghsCN7R6J2Kpwbd0MyIo0M7ToQp2gwMUhg9J?=
 =?us-ascii?Q?d28MwX9w00iNM52fsMKZNMgGhmMuSH83sfrI/2KnT02LAACjgFYyGfIGAFnw?=
 =?us-ascii?Q?1LyrENaQVKrxPBYLzhwLlL1KaJttdLcW+zPra0zuPMq0yGTlW2rcb/ntYVZ/?=
 =?us-ascii?Q?WbXL+F+KkzClS/1eokTyJtdlduQTahrMCG2O/ZQKdsTu4G1BFasgYHuQtKlF?=
 =?us-ascii?Q?vzsm47KKzKcB+Ly6z/L4DIu6ASB3s86MvJQ251tZoZtQ2J8s60QY1D4kRd6M?=
 =?us-ascii?Q?B2k0ZQ9f70/rlXtWOS9lbPN2K953rCWIeQnOsn3prax/9Vnw/KAm10PdvZqw?=
 =?us-ascii?Q?DbKH4RXmEfaEMrKZDfGBo2Ty?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <191EF1BC60CEDA4BA54D63A66D8A2290@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7288cdcd-b889-4044-a992-08d95be21e3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 09:34:57.5929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jot+X/jf4GTXyalIHpWZ7ajCVmN4bZQBGRT6bNIfdd1nD7N5agkvggXKd3UTcy6Mq8NJYvGeO51u+ndF38+ORg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 10:12:38AM +0100, Russell King - ARM Linux admin wr=
ote:
> There's a difference between:
>=20
> 	struct foo bar =3D { 0 };
>=20
> and
>=20
> 	struct foo bar =3D { };
>=20
> The former tells the compiler that you wish to set the first member of
> struct foo, which will be an integer type, to zero. The latter is an
> empty initialiser where all members and sub-members of the structure
> default to a zero value.
>=20
> You should have no problem with the latter. You will encounter problems
> with the former if the first member of struct foo is not an integer
> type.

Ok, that's good to know. Seeing that this patch has not been applied yet
I'll go for a v2.=
