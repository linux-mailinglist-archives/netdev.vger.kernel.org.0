Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D321335D232
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbhDLUoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:44:14 -0400
Received: from mail-dm6nam10on2139.outbound.protection.outlook.com ([40.107.93.139]:52096
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238563AbhDLUoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:44:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/yPvKv/dfCLU6xFTOF4wpta+fO0zGfim+WXqkhNDb41/YDKM/BdZxeRQnyfXWcaZE+c3+dAFX5XlnnHzn8NBH7xxOoOUcCMDWlkv+2md8e+PFkrBG2/7EU7dA0CxZ76fOyiK6pG78gbbTsSYI831KRw4pYnHVJyHiCtmcUcjJF75RWE2b+B069hGU0N4BOdc0bAHTuZk5t6hbVVP1qnUKp8BNv0B70BNN9NkoGeBfTm0obZ+HG4TWEH24c5N+CXgu6CUroiCPbS8xMfBpWfr9ISyCZsKxbL6UFB6P/je+NeaQLcYz+vFOV4GChrcxBB3piGHMJvxFFLiZ47DdvHfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piQ4IcIlv2gdBIcNnc1WphQXH0ptjtRXxTDm3J2WgeM=;
 b=BdH61Y5Ky3VgrXmXBerqCEH4RT8yQiOKj4nT7Df9bE3XCFQklY4i7Fs993G2f/rTRdMgZydglkH6HIqN/hFztjU4jExGxBMogTpuZ+K1bJLo1HxrlVPgDTxfMcep27JXRm6x2sJS2k/1zIvn66vj6G12IV6wI0E0JVJskHXcj9bMl/WGJkFk5ILoIFQzmmeZVEge/2wC9+4XPui9jXZZaxs6rzL6DT64bZOC+5RjIypnFHP39axiUyEqCWae35w+uRZ2v3aZLBAzt1O0bgnItUA9D5OfqMgmKl3RI5JSYh5uE4duuCk07Hmmo+EWY3MVxoMjiL4J5NLbCRMW3TCRDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piQ4IcIlv2gdBIcNnc1WphQXH0ptjtRXxTDm3J2WgeM=;
 b=g8oac+0Qy2bFa2L0NURMRls4UKD2P/EgXTMAhZ4a81+EG7Qa8RjY+QpUgtVIrMvzyB1OWLZE74AenSfNHkIOXFcV/ATrqIyVJjQF4pBAwIA446DFM6GwlUs39/YHLoqg/Jvgi+r3D9V2/4YPQaZvP0lsWsan32DZX0gOQQ8NeZg=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0751.namprd21.prod.outlook.com
 (2603:10b6:300:76::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.2; Mon, 12 Apr
 2021 20:43:53 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.005; Mon, 12 Apr 2021
 20:43:53 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXL8icok+TxRuwHk2RzEnwF60u5qqxWR8A
Date:   Mon, 12 Apr 2021 20:43:52 +0000
Message-ID: <MW2PR2101MB08921AE42035E49BABB19C19BF709@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210412023455.45594-1-decui@microsoft.com>
 <20210412112109.145faac8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210412112109.145faac8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=53b59c0c-60e1-483f-96dd-85bcc846cf2a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-12T20:42:24Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:6473:731a:ac25:3e78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb9e4bff-ee52-4044-12fa-08d8fdf3af2a
x-ms-traffictypediagnostic: MWHPR21MB0751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB075106165B1246CBBDE120B8BF709@MWHPR21MB0751.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WCxeCFqfgW8ATnTxOWDHQp2vUdmvyKGVAbpr/4Thf40Os5VPVwVov3vXKEYlkd8AH76CsZMpchhzv9y6/LSqMyvwlDoAhTabUDJT0Wh1MJJffgqa3VnSKC0NODVXan/KA1zZGdY1y87mbruUNsq47WPHONS/Sk4ZfxgNj4cDjfEe074qZHDhLG3UoMn+7QXtYC3nZT818NxzuaUKCFfhkjQOBMAIhY8yWPCWm1RBFkPee4n6i5nCH4YmZoe9IUVN0LI3LDdotq4hfrV+2727SwGhSGnaojwIQ15dPIY3usQsMF18ShyoC4aazRHAa08fIZIrZohSL53HzyIu2AMmy8iMxEGgJh5sOwxN2mofX7MOnUPxxpFNDFPCKnzXrul2mlEhhUssqdATrcBiaXl5CkNgXf+Jmo65wAvef9ZT6fKi9F7mLqnlMkxXAPKNk5plyn3NH4Y3OqUlgLH1r4rI5X6c9XkdqfA86pvOaLyBCVAuS5S1W0qzLk4atRXHUtRpRu2Hf5oA2V3pCJBSGEuEoYbD5vHFQgr5RHEH89Ytil6kT4iBTBkqzTJhxrUGz9pKU0Dmq14Rxsk2x8LEf1xbs9MJag1RcYkdf01CO7IGGsQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(47530400004)(10290500003)(7416002)(83380400001)(478600001)(86362001)(8990500004)(7696005)(82950400001)(8676002)(9686003)(55016002)(82960400001)(66476007)(66946007)(54906003)(6506007)(64756008)(316002)(38100700002)(6916009)(66556008)(2906002)(5660300002)(52536014)(33656002)(66446008)(4326008)(186003)(71200400001)(76116006)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+k+o64vN5/e9fHQ/FJ6qjaSbNH0aYkoXEvaFRF5tQq3otj6nYbldUJqFdCvp?=
 =?us-ascii?Q?DSkcAEgrp9+sCJQXnU9pCPpnHxS660CuyCPj1OQkI6053/yr8C8Yj3CqnQWk?=
 =?us-ascii?Q?FU0LCzca+Bi+5JZQKvGUjuHX2kyU6TZsh0XEHa/T3EPOdr/e9f5d9zUqzllO?=
 =?us-ascii?Q?2J6JrjF0J4h1/RinU3zdLiv2lDTfWSaHHL8ajIKzXXF3DNAX73eFK7tddDoH?=
 =?us-ascii?Q?WdpnqF0xgJjakYdmrIPlArlHGDzzwHa//igjcPxJ08GP/3ifkaLDDpt7xnRW?=
 =?us-ascii?Q?6LkLi3gQZ24FQSLCzvAHoUyQSsCN7Y3zZCmlpZYFVgwgcFBIYNCNQdoXKB3w?=
 =?us-ascii?Q?LuoFXEEUC4S0hu48olTdpnD67DO0OSqRAyLma47UyGq7qugEBtIXlmu/yJfv?=
 =?us-ascii?Q?Ug+R3PaGTFaBkJRz7kSW4TK9F8aa5rvOWg/erzuyPmWxBU+OShFoFi4zfp35?=
 =?us-ascii?Q?jrnX3bJriatQLjXFh13tfPrpO3PTx9rIyFtldVPN0LJaR7Kxs4bqybE+YpyM?=
 =?us-ascii?Q?oK1fx6ijj8bGJMvbmLoe/PSgeV8Ml9tkJCllQsu13BbAdV3cOCsbrEN9hOUt?=
 =?us-ascii?Q?3wShVxGbyG8CBW3gUI1rgCtC0zMOy5sfWyRIhakNhG6s8WLChe6OjBzciAnn?=
 =?us-ascii?Q?K7dNXhQrlqKrpjQTvF0FVQ70lo3L0+vq3GMNwVn24WYoWckS9ZXGkt9eXmrV?=
 =?us-ascii?Q?VStuMuAS76ByqzEVauSYQhTJfL3PX3ARAquPLXdvRhTvtowbQD+4cNfjqgg2?=
 =?us-ascii?Q?JGgg7rx+HCUxFkjMuFzadnDaRzSekIam5kMvzX7xv8C98e9BTE0IfYqlb8B8?=
 =?us-ascii?Q?UUfj9R7vZtcRVJuFO5PjeaDZChakXk+TuWHM4sBMmyheOYMCwgw59aHyxh/i?=
 =?us-ascii?Q?648AgaS3gjvt+Y6THrmeNaDw602PEne0bltg5fLnfdXf1oaMlqRuKUH4xW1g?=
 =?us-ascii?Q?PhzUN/AtsJMXfMbCaqTyNpDVzqi0dkHd1g3dG/VyRbyzaUIDpU8M536ZeG1N?=
 =?us-ascii?Q?JQRzb8C/7l6CceKSTkCUzEnaKFwb69Led3XuqH9j8YdVZ70RZKQ0oGR39L4f?=
 =?us-ascii?Q?8QdYL+vMYz8dqxnVgMNu5VoGN6PC/rOJOMk28RsKxqtcvalnz9P1oQ+tg8ew?=
 =?us-ascii?Q?KWCPyyRBL8FeM4phXS1JscEfB3qafNJfPO3Xfv1mS883TtVmIXefRCap/Z8z?=
 =?us-ascii?Q?l3rUM2mkx8bF0hW7T+RaNbMZ1ik7T3NuD/+vQypvsLgQo3Km2OX7OZcQJsF9?=
 =?us-ascii?Q?ExOg7ZYaWtzR+MHmYdL2KZSCzd+ZNQbpeOnLXmUXpXYnpdKhGKzQeG2oPLnD?=
 =?us-ascii?Q?U99FKGsrZjM5jvTLeL0i+yXY89Un7VmAXzrxz16AZ60HKzqcOeawd0i8wbrN?=
 =?us-ascii?Q?puCBrP7Ni/Z4U+mr8tR2u7ze1UyT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9e4bff-ee52-4044-12fa-08d8fdf3af2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 20:43:52.9676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FG2MkIivJY7EFRiIB3WBNhOyeIz3eBc6gj6sHOQw3hNo15DKfZMsWVVz6htcyfX0s6RLN4ZlTvxvXeeFxmWjdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0751
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, April 12, 2021 11:21 AM
> ...=20
> On Sun, 11 Apr 2021 19:34:55 -0700 Dexuan Cui wrote:
> > +	for (i =3D 0; i < ANA_INDIRECT_TABLE_SIZE; i++)
> > +		apc->indir_table[i] =3D i % apc->num_queues;
>=20
> ethtool_rxfh_indir_default()

Will use ethtool_rxfh_indir_default().

> > +	err =3D mana_cfg_vport_steering(apc, rx, true, update_hash, update_ta=
b);
> > +	return err;
>=20
> return mana_...
>=20
> please fix everywhere.

Will fix this one, and will review if there is any similar issue.

> > +	netif_set_real_num_tx_queues(ndev, apc->num_queues);
> > +
> > +	err =3D mana_add_rx_queues(apc, ndev);
> > +	if (err)
> > +		goto destroy_vport;
> > +
> > +	apc->rss_state =3D apc->num_queues > 1 ? TRI_STATE_TRUE :
> TRI_STATE_FALSE;
> > +
> > +	netif_set_real_num_rx_queues(ndev, apc->num_queues);
>=20
> netif_set_real_num_.. can fail.

Will fix the error handling.

> > +	rtnl_lock();
> > +
> > +	netdev_lockdep_set_classes(ndev);
> > +
> > +	ndev->hw_features =3D NETIF_F_SG | NETIF_F_IP_CSUM |
> NETIF_F_IPV6_CSUM;
> > +	ndev->hw_features |=3D NETIF_F_RXCSUM;
> > +	ndev->hw_features |=3D NETIF_F_TSO | NETIF_F_TSO6;
> > +	ndev->hw_features |=3D NETIF_F_RXHASH;
> > +	ndev->features =3D ndev->hw_features;
> > +	ndev->vlan_features =3D 0;
> > +
> > +	err =3D register_netdevice(ndev);
> > +	if (err) {
> > +		netdev_err(ndev, "Unable to register netdev.\n");
> > +		goto destroy_vport;
> > +	}
> > +
> > +	rtnl_unlock();
> > +
> > +	return 0;
> > +destroy_vport:
> > +	rtnl_unlock();
>=20
> Why do you take rtnl_lock() explicitly around this code?

It looks like there is no good reason, and I guess we just copied
the code from netvsc_probe(), where the RTNL lock is indeed
explicitly needed.

Will change to directly use register_netdev(), which gets and
release the RTNL lock automatically.

> > +static int mana_set_channels(struct net_device *ndev,
> > +			     struct ethtool_channels *channels)
> > +{
> > +	struct ana_port_context *apc =3D netdev_priv(ndev);
> > +	unsigned int new_count;
> > +	unsigned int old_count;
> > +	int err, err2;
> > +
> > +	new_count =3D channels->combined_count;
> > +	old_count =3D apc->num_queues;
> > +
> > +	if (new_count < 1 || new_count > apc->max_queues ||
> > +	    channels->rx_count || channels->tx_count ||
> channels->other_count)
>=20
> All these checks should be done by the core already.
>=20
> > +		return -EINVAL;
> > +
> > +	if (new_count =3D=3D old_count)
> > +		return 0;
>=20
> And so is this one.

Will change the code to avoid unnecessary checking.

Thanks,
Dexuan
