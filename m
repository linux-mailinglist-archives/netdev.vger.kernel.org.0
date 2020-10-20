Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426A229456E
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410596AbgJTX1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:27:18 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:5995
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404465AbgJTX1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 19:27:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkZTUK5vr1aFRrcyvkP5OtyIb6iApgGLTi25fP1vHH11VY4uRibrk7rvc+5ej3NwYezwPwEKT5h///NQkclXz6TRiguWRcODnVEoD/nMbg3k8wQUP/w4M2vBeK+yu0QWTjQeMlhADyHw8LK/4fjSbxjzaqz0t4EKu4XWBxPV8X7Png3z++wuH60IJYy6sO31GpTnDiVb29wxPTBK0wRjFsldw/CQRnG559mIrbTlV9e1BUZcHrM+husH6B3I1XC8T/sIMnSHKCNVIfl2uglTUzNQXJMc+5z4npOFlEA9kA3oobD/l+dl+1aIUVtGAPjPjCpDMA15tFw0UgD4OI2inQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=divFz0G2ajVCfUa0qUewQq/Tu144gf1HwCjBmwAxSXM=;
 b=GnVR78yC+f/hempjsFZXKweWFcmbYCepQAZ6SVadXfCwqK4C881SVaYNqW6y0un0UWhl9+y1r3s3TbbSZwXxDrdGYNQeEm6sli4w55mfqrW16mE+rRhfAz8a7A3WxjI3mE4uFh/HUqloiNEEz1gK7jNGTzGfRUFmywMgej8SYlzZtuS3y6VB2viMzDoV1HC+zi+bBW6aq7Hxc/dQW9/rCkcLKf2miH7IOmZLE+KXYI0nmUJNsZ2GjyDBM5VAm53yHnZA6VbkYW+G3fn/wrC8fpNWUuG0qSGPylgDx6uNgCzzYZ1gSKIDPlhNDUGO3/dRZp9MMsmcOYvIzC7Ua4qcOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=divFz0G2ajVCfUa0qUewQq/Tu144gf1HwCjBmwAxSXM=;
 b=pW0ETnBclm06u/KeaitdWdLn+Enq4BFVsVM3z/bRLO1kLO8zGnYbdTIxCW95XzbRDdCGht6JgSx8b3+24WhAicFyGpYJAIgSMT8nOEeaSs6WvUdBZagdOUy/saPFDrt72FPQHvssOJoObPfHjLN5n1iEqYYaLE1GmWEAg666So4=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Tue, 20 Oct
 2020 23:27:14 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.029; Tue, 20 Oct 2020
 23:27:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>
Subject: Re: [PATCH v1 net-next 2/5] net: mscc: ocelot: set vcap IS2 chain to
 goto PSFP chain
Thread-Topic: [PATCH v1 net-next 2/5] net: mscc: ocelot: set vcap IS2 chain to
 goto PSFP chain
Thread-Index: AQHWprMxGi9VamOEPU28heaWaxH4LKmhI62A
Date:   Tue, 20 Oct 2020 23:27:14 +0000
Message-ID: <20201020232713.vyu3afhnhicf6xn2@skbuf>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
 <20201020072321.36921-3-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20201020072321.36921-3-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bca08593-e796-4a42-9b33-08d8754fad38
x-ms-traffictypediagnostic: VI1PR04MB6271:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB62718272C018F303F51D5FC5E01F0@VI1PR04MB6271.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ByH6EAzbZ3joSTxHAwQctXpww434UfmX3yZ9S6akoJfM2AJKJ7pL8nfbZSB6aw7+mQeEcvj5NJzVId/7CoqYohgo/nvIyEC41nndQBeGQYlNtKOfdxJdgbC/OiqnPAUnNVQ/oAjG16IXSOKGuvFu6CpkZG7B+M1FoTQOwBjshWlYI5Db21V3D6NUzbJqNEwvHYh2iLULHzjw7UomAE6ruIQ7UBHpsIGdn2l6Vxo7ewHWfzvxpFqkY0agunH3GhMUsDZaBDLytBykSnbbh7paxjK2HbERq+zlrlNYDlsuxryvKB9Ge4TXz+YWVrqtS6L0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(6636002)(71200400001)(66946007)(66556008)(91956017)(2906002)(64756008)(6512007)(9686003)(8676002)(66446008)(8936002)(66476007)(6486002)(44832011)(7416002)(76116006)(86362001)(33716001)(83380400001)(5660300002)(54906003)(6862004)(186003)(26005)(6506007)(4326008)(478600001)(1076003)(316002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RitzU51SFH61ZsGNTkg9/M3ALmNtb0zQkMoyfZA/8WES0z2o2A9nPGkU9JfDBt60jC8FV3w4bhqNYolIxLv3qeaP4QTEhLtjZCpy+OcDw4t1kcCEsmiqtQ89Dta8M76ru9KdiIWKfCR/zIquLOGSp9qjJ5IioID7ZWRzUkYusksRdxBdbNFwm+Cw8AmfljxtblgumclNkoQyCvcWDxJdZ41/kdfS+2wCkM8BhoqoM2JXYnW6Kkf9PKFH1ajkSXJowYXL6l/ZidUPz4ZpYiLBG6xLnoQuCITMYq5IIHHo4KTBq8ksfL6jXH8ifG8XoAOPo0YefLgcsObSrIB7DDw87M9LbeIoYlY+HDugK5Mz4tUU5EiqxNIiVrC8TFfFuyKNf8n23dglyUUev3OwbOi+61OZ/XLfqqYZOtnUN7F5g1uD4U6Wd5tQEZLLyX++RXyoRaSbTKigzm/xOlPA0Mja2QWu2mQ+pZ9H2KlsREIk5fIoAPsk0m0s6c4WCSo2oMT1A2ZSxjm99LMjuoJeYDcnSqHBrF1NGHcBEYAxMI6YTXHJiPkS5SzqaLRQMSxyzf0/FDh8le1coo68AqPRSkm2pmQ2EzhiL/Tl2ryyA5niRvTE4cdswLlUJnV+8u28E/wIMlSN1OsmjWFQA2iV3TzfXw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7B2A85FCE3D2043BB69004FEE54A960@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca08593-e796-4a42-9b33-08d8754fad38
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 23:27:14.0910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tQYrr5OhAxduuupjONyxrjOv46FTe9riK58gBPWJzv2tOcZW7q5p9LX3bkAfVmKD5exQDQSxzt5BDfS5Etfajg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 03:23:18PM +0800, Xiaoliang Yang wrote:
> VSC9959 supports Per-Stream Filtering and Policing(PSFP), which is
> processing after VCAP blocks. We set this block on chain 30000 and
> set vcap IS2 chain to goto PSFP chain if hardware support.
>=20
> An example set is:
> 	> tc filter add dev swp0 ingress chain 21000 flower
> 		skip_sw action goto chain 30000
>=20
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

I will defer to Microchip people whether 30000 is a good chain number
for TSN offloads. Do you have other ingress VCAPs that you would like to
number 30000?=
