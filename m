Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DDB9A311
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394070AbfHVWhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:37:18 -0400
Received: from mail-eopbgr750109.outbound.protection.outlook.com ([40.107.75.109]:63906
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731896AbfHVWhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 18:37:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNIUVie/oR7Etw1GnG14nj04E+uV/Um2uzAiYoxk0Sd0qXAiXYmB4GjV7hm9iDcoYdpii+j03gTP3suxBLP9r9yQHFL5Sq9y9q/VDWdyD3NrH21USO/zd5N6X9gai5g6reYr+2kjyv5DCOiidP0fxfL8MWrPFwcxvG8XfK1Qnr6l0pTKDWZSmkh3fyFTKOrCzeBYzVWH5+CTbOAnowGKnEUqf953cAbXMh09cSctHFjDPcEcECqxo6+lkw6GbL7X+8h1SXE2ozS5dztqN2LJ+SvGk3CObkf7+Pc0jLyi7Y2Ys3BX1F6OaTH37G/Haopaaq1nz1xFraT0M8e/7WQmeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcWcos5kH+Z9Txmo7sMGGUyeUO4Zz6DW1DavW2ryZ2Y=;
 b=H8W7phbBHXU8UIzwey+xJgPPD5dxdIeRZzL0p6E6Daf4xyoSwYR5IDpMFPo/lzBgZ0cGaNJWuSfQvwRjrFw6HlW/1Iko7pdo8/Xikil2HYHtcJg3Y4af7O193+fkC7SI+mbIYlQ8wHYp5J6Yb10aJIJV0yFnzN+G3IpLk9j6b4lAmqsC2kN5NLygrXvJUuOTcnfCh2+GAwgnWA6NFoADoNJjgauCl3v+g/vS6hpD2kOZQNDBQXVDwXEouxVPvuFCgoMUBWbbVtuLJPhO44okVpG8VcrMookMiJdAfapsRct/uwlbWRekYrzCphwn74Gjo4X2MPJgQjnKbKZfeqrRAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcWcos5kH+Z9Txmo7sMGGUyeUO4Zz6DW1DavW2ryZ2Y=;
 b=TV4YXXeINxJ0tNYbPinKbqk3JKWreKast0578411wK/oyMdeVGA5ZOLmMjDgK2FHAYoS8E2yy5SzyPKsYKfGpCdQi/ntpvxRf8KsawhSZJ/qsUEJRAXyZzNkP1oRIC6Cg8fNnqDcW2633I7A0xGoZbilWf0dTVZa6MYJNFH6oA8=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1355.namprd21.prod.outlook.com (20.179.53.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.4; Thu, 22 Aug 2019 22:37:13 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2220.000; Thu, 22 Aug 2019
 22:37:13 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Topic: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVWTieJNg4lNlPokigzqQxpEz7DacHwLuAgAAAK6A=
Date:   Thu, 22 Aug 2019 22:37:13 +0000
Message-ID: <DM6PR21MB133743FB2006A28AE10A170CCAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
 <20190822.153315.1245817410062415025.davem@davemloft.net>
In-Reply-To: <20190822.153315.1245817410062415025.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-22T22:37:12.1902391Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=717993d5-c347-4617-9f74-1593d8091523;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [12.235.16.3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d1bc798-2f32-4b0b-2be4-08d727514728
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1355;
x-ms-traffictypediagnostic: DM6PR21MB1355:|DM6PR21MB1355:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB135504144E2C2AD934717175CAA50@DM6PR21MB1355.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(189003)(199004)(13464003)(33656002)(6116002)(186003)(256004)(11346002)(486006)(6916009)(55016002)(8936002)(476003)(26005)(446003)(14454004)(71190400001)(71200400001)(76116006)(66946007)(66446008)(64756008)(66556008)(66476007)(6436002)(7416002)(81166006)(8676002)(99286004)(81156014)(102836004)(478600001)(6506007)(53546011)(9686003)(66066001)(229853002)(7736002)(52536014)(4326008)(6246003)(316002)(305945005)(25786009)(10090500001)(4744005)(2906002)(22452003)(54906003)(74316002)(53936002)(8990500004)(86362001)(10290500003)(5660300002)(7696005)(3846002)(76176011)(42413003)(142933001)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1355;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Eh/0m+CmRIrTMgggkHUaNW6Btijkt5cmKY7p6w7vDgkoDtLOY5MdTHlKgU975sHGBp2pOYf7OBj2KUmlttP6YvFBUqSoumM+96bwPcdJ6e7ZqUeeL7sZ0HnKjtdgEXAqo8W274N8zmAPndglkAgTFXYwZ8e6oUELyp1XEuivMBi3Ow5bEO7WvWKbHUXHS7ZnCkdqNPS5LJJMZctqf5T4pGiY0avBlLYM9m1Oxp5m3xAw1BypeCb+JlJWpjJug2tB6Db1ljmSj+/3A+UJ5DBEAeqTxu1+MoBo/omvTD2xepdIIZPY2rkW94Rj60ufvF918WTkKe/6axA5V2N4ncNffP2B+RzaLbZjjPVS2aOMd31pemc5EZTLvce5hU/KZSkkPSjL24EthMWCq5a0/uV9xo7zp57RdxS1a2vD12Yev/c=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1bc798-2f32-4b0b-2be4-08d727514728
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 22:37:13.3275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cg2vD7V3+YnYFxrkl3zH89Ksn+bjEjeMbw0e7Kxi1tkQOc5Ra/Ue+RHE5lBnnyTbI+VUPvKkktVFnPw04a85Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1355
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Thursday, August 22, 2019 3:33 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; saeedm@mellanox.com; leon@kernel.org;
> eranbe@mellanox.com; lorenzo.pieralisi@arm.com; bhelgaas@google.com;
> linux-pci@vger.kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e
> HV VHCA stats
>=20
>=20
> I applied this patch series already to net-next, what are you doing?

The v5 is pretty much the same as v4, except Eran had a fix to patch #3 in =
response to
Leon Romanovsky <leon@kernel.org>.

Thanks,
- Haiyang

