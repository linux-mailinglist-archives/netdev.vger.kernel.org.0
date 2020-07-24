Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7590A22C8F3
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgGXP2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:28:37 -0400
Received: from mail-bn8nam12on2134.outbound.protection.outlook.com ([40.107.237.134]:64737
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726326AbgGXP2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 11:28:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqMkKCNCx781LiZ+TY69Z0OW4IW7WbkPaXzAVMNb7rh/NnmlfdUZfQZAK6Cs5nXGikLGBRDL0ZdwJ+hHreNL4/hRVL1ksPPSd/y41K2zQwji5g70qkWpy/7ntcynG7sewgPAlyFyfY8SrfStqQM5Z1GZFqsrxNWctpAyNBtWuT0WA48Nlb9U/ZMAMlR6kHqGEY6rIHb0abPLT2puHRS2daXsmYGdi7+QJxLyHqlcCzMNO5dGfsSb9X43RIOizl5bK4Pt9YYne1VdaKRLvE6hCt09dAMP2vQqP7H/ZFJMRwGULE9BAIkdxaJcoHqMq6D+x6jkN7pOcxn8mk0oQan1EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fi7KdF/ODaS4DJWydRk/nlPUF8EYggMz8OUpUmwcfEg=;
 b=ntcK99rO4uFV+7ZTgKr2l+JR7B9XSq/0Qr6dYNPO7GKYM4u5gbkfLnkh9F+g59sPnexidmZwrB1UfbKR3baWshQaqSK2CXUl/OEN3GFv9yAjWd2VrdvILrKK2vIEvLyvKJu+pXj9xgapzDAPeUp4iUvEE6UfkD0WwTlce7Asllu3s7zH4Bsm0H6sgvbAKbOx7h/n7z76nquYJ4Nn3WE8HarwJOX7uxDx2FDjZy4FLuXvHreR5j1sGQkHFi1eher1A6CVNRpDNde/xJU6hM+yU6pvfp6UucZYiDJDVaIgDEkotJxf6ZXDn28UX9txkqZBhsQScwoBrEqUC7nQt5FM7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fi7KdF/ODaS4DJWydRk/nlPUF8EYggMz8OUpUmwcfEg=;
 b=hPQcAr4I2Zy/KsQx6f7JvGfT6LcaMnFv0tuOUMm+6YXWIm8Z5EMEQhRT1aZo54YhbyQn5Lw7utCqr/njJKTSoZ+zgctO4xU4Cer2nj/WyguMj5M9ocW5679bCessdrNMBteIpah9P1d6P3ErQDBm78FX0ZLWpS8r0z6odMlpwK8=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by MN2PR21MB1453.namprd21.prod.outlook.com
 (2603:10b6:208:1f7::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.1; Fri, 24 Jul
 2020 15:28:34 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%5]) with mapi id 15.20.3239.011; Fri, 24 Jul 2020
 15:28:34 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Chi Song <chisong@linux.microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
Thread-Topic: [PATCH v8 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
Thread-Index: AQHWYXDtZan1WVS5t0+fJ4F+yHCxU6kW2yPg
Date:   Fri, 24 Jul 2020 15:28:34 +0000
Message-ID: <BL0PR2101MB0930A3C7BF5FFFF62031D004CA770@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <20200724041426.GB25409@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20200724041426.GB25409@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-24T15:28:33Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e472fbb9-0a8d-4119-af59-4db1518b7197;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 995e9c0e-1efb-49e5-e6a7-08d82fe63aa3
x-ms-traffictypediagnostic: MN2PR21MB1453:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1453A2612B1F1E2F140F4A5DCA770@MN2PR21MB1453.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:264;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HEKHB1GOrweEW7fa6g2YWUtUbSZO3Oc9ndqAu7kvL/mKyjheLE0efS+U1+TYjzw2UnpKG4/4fm+KaPCwju6uJhnynCkaMa6Ftl6t96EuKDu2rKsdHRfZv0nSRhRa622GWKI+HyTMn1iNKliKLRAfrlUG9nH/oxSlJreuvm9uLjbNOkI1Uka7VacrtfqUnP1+WKuSPu8dxY/Gqpf+BLTSa4HiboyYquZKZvrg57DKYHRE3ZI67aALlYHs9YJd/3bpF5n0gbsal0kCBNF3rvaIUtTh7DGEpfPCy14hdlcl8+VFi9PuuIBz7BIlvoDZ+hL9v5yaohuxANEqT82nnJY1Dw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(71200400001)(186003)(26005)(10290500003)(478600001)(86362001)(66946007)(2906002)(9686003)(33656002)(55016002)(4326008)(82950400001)(8676002)(76116006)(54906003)(4744005)(82960400001)(66446008)(110136005)(64756008)(66476007)(8936002)(83380400001)(5660300002)(52536014)(316002)(6506007)(66556008)(7696005)(8990500004)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fXbVytsaX68FCX4sTSrEVPKEmAlnk4h4eTRoZVZCyeRJXD37+IKsHxsa30O3CZQ0gC2lSVTsC3AIa7854scpoZS/sFQ5x62893C/+FH0XkDQK2Kf0IEW2OeGx2Gvp23SYjYzigBY8fDacrCtTSwuFucmibdXb4ZuJPS8mGEhf9iXuk6DHkoxltaebzAs4+P87iV5PgG8lXdDj2XrBRfCA+FmVF+IPwFs4eI3sDyEXLXA0ja+vjs5VKtBfcEGg97c4nLgEygCY9NI1VPLQ4UHAjpQLyJsNyE4LvXrNMovXd9iCsfPGfOw9zhBTI+WRcL467JNWsqEkx8md62mLplqCXGYDF5T+90mjIBhtj09iW7X2dzpowI6I7mUpYh7hORSohmUexfxSU/UI99Lfl5LQW3hle7fHQoKf9q61m+zVDFuDj6zZY+klssGs4H5mPO5mkT0BY/H/M6Qj/89RHHPdCv3ez12KMODT06KEdFSDg18VDuNlJGFdCekWLeSAXfmuYekgmKnFD7BJf7N7flgDL1F7mxlupc8R3HKK2tCUQWSCw1K5C4caPAgo2hOOMBInyjXuQPewalr5wGxgypWtYv+ZWdfZiBQyf241STNlti8zjaPo4mVPFtgDe4gGxMhicURuZsCKWaxMNi54PjH7A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995e9c0e-1efb-49e5-e6a7-08d82fe63aa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 15:28:34.4099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZddrgJyHJuEQn6cgYn4+i4hADFkeClyhfx/F7CruUnYXFNB3mfsfeL6uGQWrxg/wsSOVNCWMo9e2zRVgb/Dr1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1453
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Chi Song <chisong@linux.microsoft.com>
> Sent: Friday, July 24, 2020 12:14 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH v8 net-next] net: hyperv: dump TX indirection table to et=
htool
> regs
>=20
> An imbalanced TX indirection table causes netvsc to have low
> performance. This table is created and managed during runtime. To help
> better diagnose performance issues caused by imbalanced tables, it needs
> make TX indirection tables visible.
>=20
> Because TX indirection table is driver specified information, so
> display it via ethtool register dump.
>=20
> Signed-off-by: Chi Song <chisong@microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

