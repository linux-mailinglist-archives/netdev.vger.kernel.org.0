Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B97347D96
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbhCXQVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:21:07 -0400
Received: from mail-eopbgr40048.outbound.protection.outlook.com ([40.107.4.48]:27520
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234672AbhCXQUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:20:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7/+Tpu0XbvZdCPIRD5yziu5BtwkZfxjpI5mNZEXR1B1YvX7xasHC9li7ig3FujMA8IO4s7qDDIm7ghRwmoiYqC+g53fZJDCvItKPJCeBY03whMEjnWd4jT4mEA574TMMOCNsuhGQfVmE0KtNLKxBdCHKD3qQqfODNxsaoPvaS26VGKKRzyhnkc18+vIp0wHbssADxh/kF/2P4vMY+APsTtXFTkBolFU6EfnBbXsQL2P8U8DUgkcdAw/QDEe3cDpQ+K1WEUvLbTXpRH6R3pYWaXCtB2wWxigq7CnzW0EwbqAwuxgo9GDM/tlL5ka3uJEYdljNoMIl0NvwyMr2zAymQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWeIbo++I9AXRKfcJd6TAW9nkCYP+WOOMY9VA3poS5k=;
 b=ZObyZrbLV1EExchMt5OAnL5L/uiBI0dvaZaVgQAxRlQgZ95MfHGxgP4vMn9l0AhxuqvK8cOhMoDuKIU62/DR1V6dEYolwR6LWUrnUZbnLqUgD22zmYIVBHlzzfmfmBj7tx7zAp3+4gJ7I6dSCd8LplpO9GgS/AoPqktA2ahFE0Th9XRSfcavlynWaiBgoOEk1jq6QYNHcw737qGAunZgqMxgjWyLCHfDIkB9zwy7UtsWdRBiZgzhRtgoFM9oIZilITsf+TC9UaPeOKDZE0/Y5nYqptn5YZxy8JYPEVFCWInUDP6fzaMmgmEMwmQ9Husf5g9vRSscwnMYA3sFdvMJ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWeIbo++I9AXRKfcJd6TAW9nkCYP+WOOMY9VA3poS5k=;
 b=ZbKXV/U7yLN4oMgOrQu62dZborNEj7nEcNAlXXj95zBk8ql/Agb+Xv3Yy9lAIaF1p83DSbgA34/1rlahOnuVx0EqJOgVgbHGCHK/WVII9Vk+3EXFcQ2yH5GuUDYzQcYuevqejpyk8IsRv1pftldf+gvmMK43/UFvyBIrTf/LkTc=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB4754.eurprd04.prod.outlook.com (2603:10a6:208:c4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Wed, 24 Mar
 2021 16:20:35 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:20:35 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next 1/2] net: enetc: don't depend on system
 endianness in enetc_set_vlan_ht_filter
Thread-Topic: [PATCH net-next 1/2] net: enetc: don't depend on system
 endianness in enetc_set_vlan_ht_filter
Thread-Index: AQHXIMSqgW0JfY2ask2PEagsM/n3NqqTUUvw
Date:   Wed, 24 Mar 2021 16:20:35 +0000
Message-ID: <AM0PR04MB675429E748B9153CCC730ADA96639@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210324154455.1899941-1-olteanv@gmail.com>
In-Reply-To: <20210324154455.1899941-1-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [79.115.161.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04763fd9-9c12-4e76-826a-08d8eee0c135
x-ms-traffictypediagnostic: AM0PR04MB4754:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB47548CF53639AD56CD74483B96639@AM0PR04MB4754.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vpp9D6+ZFoj0jijEN1SgPKQ0CUaQbSDZ74o0OpRZkxlP3CvfXR5rO+1bf7cQ/KH0BbPkDMPy7tZkafE/1RCUFDSa+9Tvf7lECHPu2j1IN9UjNen6MCZc4icwXeEx8WYjzcsMn25SrcUwm0WzlfkmZ8ucihw47r/U5TP8iiHDIHzwuata8+8I0+5LVEfUAl/pZOD+MKBNzb1gMoAKH3l447STAo4TVzmB46t+3Had7UxEfhbqFj8a+rk+lECba5qAth+fHbJZ9TkZJD0Gy44bzY4073w/U3EPlWsLyywE0jO6BSnRIy43mkuC5+tqLPNs9pWiHsJoKwjM4OKJOO5lzA8L9P6DS8jo1GrEA08vMwqns/VvQHJL/vFOfWv7MIQP/4IwPnYmqccNekmDdTq197G09kMT332pjYZl2aJjLDRlNNl4N7dZSnUT7pnmbh/VVa+pvT3bP+evINX2YRs0JZp4YDPtIXWdGjf45/WFG2xZFGCS0CvRsNY4oZZ16T185cek/sThf9fr4Py9i43sUz2w3w+vf39gH2xOl4Vv/3yRV5wqR4dZSdvX6n4FVXYFhs+OXcuCZ/4yVqrv7K3KSX8JUC88RU1LrtEjowl9d51C1+ABUSdmR8uDDqcAZYpH3NqHa8OfXh+uNW8ZPeLKNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(478600001)(6506007)(86362001)(76116006)(44832011)(64756008)(4326008)(66946007)(66556008)(316002)(26005)(66446008)(66476007)(110136005)(38100700001)(186003)(2906002)(9686003)(5660300002)(83380400001)(8676002)(54906003)(8936002)(33656002)(52536014)(55016002)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?P5gy8FEE+N596j0UmzAS0wd6Sj6XCM+gJ0sWYN35x/f1v0YXdHJtRiJfth/1?=
 =?us-ascii?Q?E34sDldcFuIKWU+JTyZFIaVXrsTP9M4tX6/G5JJH+Egy03UnJNj9n41is4US?=
 =?us-ascii?Q?V2oU2mFDjAbf173W75/PtpYy6Z7qu4oLi6XZ4tBVSNZQ/yQwVitXyVGN3uiF?=
 =?us-ascii?Q?1FkXxnLVmUMuFrsxiD5fMQpBAn2zL+v2wFxuXSUiRdCgV8Z3XNKZ9TKhzO6B?=
 =?us-ascii?Q?SIy5tdndarZDB5bn3T3R6UPDo7KDIzsyFtsK+D6LjrzruIyTHm1zyFE5DCCn?=
 =?us-ascii?Q?Y7fsDZIuaBUSynPNBIj9Le+RAk8cdDevwAQ2vIj5qTljj41ijGCj0dcTBK2K?=
 =?us-ascii?Q?160yq/2I7WOWINQtDDZgqqwQnqODg+pocow9igw8/WR+3p/v/FBtBkbK61fM?=
 =?us-ascii?Q?5HFEtIyagGoaXkQa3qNmq0Tlb2fYkJmvzaKz3v7W+IPLofMRxpuYTjuxDL3d?=
 =?us-ascii?Q?npCrKJxhaHni4BYiSA53FRpwMbwxdV76kIw9oBD9sasBbAzP9xlocGrYbtRP?=
 =?us-ascii?Q?6chKMMn//UsIsdxbZi0n1PUlodFW9bwl1y3MVM0xYR9DSnQXTwz52/WUZR8D?=
 =?us-ascii?Q?3rfjaK4hbruqRQb7YLpLtwoX02278WIiCF2q3zcfFQ5CmR6Sk/XEuWOVJyy0?=
 =?us-ascii?Q?wG2CUdCJs8DhQDXUPhpRFmiVMmZ8ZODN8HMuhWq2LWeU/5WAxodrF4bZW0Zb?=
 =?us-ascii?Q?JpKr/zvstRmrwGWlx7ypigMXEeamO7eJJjNC8Vk7Ti890Q3WahdG3AvOhTQF?=
 =?us-ascii?Q?VEau5+xNtDrrCuevSJNa/fdR+rmy/3uEKI9x2TrwQIj1ce5BDwBO9eESMkX3?=
 =?us-ascii?Q?OK7+D4uJ5TJ/I40LrBSz0MfCLyrx5qhScSkfhPeniOwVHxfEE3Wa/1lFLwOo?=
 =?us-ascii?Q?flova0N7z5TeqlBuCoGqEqIO/7cmcxp2AsYiMbmo9liHHxKZ7o3c67ORAZAo?=
 =?us-ascii?Q?4SpYVl+xmSPtkHMcS9C9JY6iY9I5BZsXJ0MU4NgaaEbyE3mp1PVwpzxzrqN/?=
 =?us-ascii?Q?FaULJ3D9er3x5ct75j6RTWCk5hd30Vusn0aoqu4xqtgQArew1BbquQQOS/P8?=
 =?us-ascii?Q?ObejXrBBIB93Ikz5L9XDxls5E4geq6o3cM4ghkBDUk1W7ZbDv9LW0fl6eaaD?=
 =?us-ascii?Q?XyeCFcJ2/N8UbCVLM8Mn460UVinSDFawdva+ozDkeF0urJTcXGVfH6gCaM8f?=
 =?us-ascii?Q?zLb3+l0jjKFrknnhOh5HkmvU6zSNw7SIGgRtECVIhq5RD0ici+t8wdLt66Es?=
 =?us-ascii?Q?m/Y2yba2aHg0zJ4rbv6POBIRucx622Bvp29N39NwPoKRcdw0Vi03IzV19e0Z?=
 =?us-ascii?Q?oS8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04763fd9-9c12-4e76-826a-08d8eee0c135
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 16:20:35.3040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ELB1ivL7Ufi3BbLdC2Ax9spHkJIl1J2/dY2of/0kyQjIoB1Vlxxs/LQvBMTpTVbAsNd7rEfmI87dKLPt2inyYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4754
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Vladimir Oltean <olteanv@gmail.com>
>Sent: Wednesday, March 24, 2021 5:45 PM
>To: Jakub Kicinski <kuba@kernel.org>; David S. Miller
><davem@davemloft.net>
>Cc: netdev@vger.kernel.org; Claudiu Manoil <claudiu.manoil@nxp.com>;
>Vladimir Oltean <vladimir.oltean@nxp.com>
>Subject: [PATCH net-next 1/2] net: enetc: don't depend on system
>endianness in enetc_set_vlan_ht_filter
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>ENETC has a 64-entry hash table for VLAN RX filtering per Station
>Interface, which is accessed through two 32-bit registers: VHFR0 holding
>the low portion, and VHFR1 holding the high portion.
>
>The enetc_set_vlan_ht_filter function looks at the pf->vlan_ht_filter
>bitmap, which is fundamentally an unsigned long variable, and casts it
>to a u32 array of two elements. It puts the first u32 element into VHFR0
>and the second u32 element into VHFR1.
>
>It is easy to imagine that this will not work on big endian systems
>(although, yes, we have bigger problems, because currently enetc assumes
>that the CPU endianness is equal to the controller endianness, aka
>little endian - but let's assume that we could add a cpu_to_le32 in
>enetc_wd_reg and a le32_to_cpu in enetc_rd_reg).
>
>Let's use lower_32_bits and upper_32_bits which are designed to work
>regardless of endianness.
>
>Tested that both the old and the new method produce the same results:
>
>$ ethtool -K eth1 rx-vlan-filter on
>$ ip link add link eth1 name eth1.100 type vlan id 100
>enetc_set_vlan_ht_filter: method 1: si_idx 0 VHFR0 0x0 VHFR1 0x20
>enetc_set_vlan_ht_filter: method 2: si_idx 0 VHFR0 0x0 VHFR1 0x20
>$ ip link add link eth1 name eth1.101 type vlan id 101
>enetc_set_vlan_ht_filter: method 1: si_idx 0 VHFR0 0x0 VHFR1 0x30
>enetc_set_vlan_ht_filter: method 2: si_idx 0 VHFR0 0x0 VHFR1 0x30
>$ ip link add link eth1 name eth1.34 type vlan id 34
>enetc_set_vlan_ht_filter: method 1: si_idx 0 VHFR0 0x0 VHFR1 0x34
>enetc_set_vlan_ht_filter: method 2: si_idx 0 VHFR0 0x0 VHFR1 0x34
>$ ip link add link eth1 name eth1.1024 type vlan id 1024
>enetc_set_vlan_ht_filter: method 1: si_idx 0 VHFR0 0x1 VHFR1 0x34
>enetc_set_vlan_ht_filter: method 2: si_idx 0 VHFR0 0x1 VHFR1 0x34
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
