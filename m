Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1043F363A0
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfFESyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:54:21 -0400
Received: from mail-eopbgr760128.outbound.protection.outlook.com ([40.107.76.128]:37701
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfFESyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 14:54:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=pwAy9mI4fq0pLmirdVvA1Lhd1JDm6KRg4Bjh0V52HIuyiiq0O8CD0iCMAFbWauixPzg4Kge8JrULoLUZSsi6VQHvJWAmnRZ3Pkf7tzK9pDkurUf+7YECo/W3lxzPLizECFZRgfmi+ebmuE3Vh8oDqYGj0d7+pHtFr/k9HrBFMwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqzLo/XfLaHhOWewkYDN2s6cQTv3V5UVwX9i2ALwYds=;
 b=yM3NROrpamqc7t4WvV/RjQC/L9mg+4LHwvVCsmgpRj/R3hYnpbKg1kOfUF89DmJvLlwQNBTy4oqIih4eaVDuYwGeM+4lXJKAfgUfd9rF79RXf5bh3K9q7V1i/w/r/EMqJmzJM0vvyhvokZdRpWKClCRZWz0uUd8Y2aL+j7ji/y8=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqzLo/XfLaHhOWewkYDN2s6cQTv3V5UVwX9i2ALwYds=;
 b=WsiHm2Z2TPZQC57Ars1g1p1o4rwzvwfo+lUsmGT1uF+BuMww/HCoSMXA/w4MqMclAcnpK2VQeghAWMVeglmbuQpXyvmtFHv8nz56KABaGQft813Z1f7ylz6hpSxdvPbpdidf2S7pdaUmwG0z1VlhnOC+utzAE9z8M+Ob8l2zdvE=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (2603:10b6:5:175::16)
 by DM6PR21MB1179.namprd21.prod.outlook.com (2603:10b6:5:161::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.3; Wed, 5 Jun
 2019 18:54:18 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::942:899a:9cfa:ef99]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::942:899a:9cfa:ef99%5]) with mapi id 15.20.1987.003; Wed, 5 Jun 2019
 18:54:18 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: RE: [PATCH] revert async probing of VMBus network devices.
Thread-Topic: [PATCH] revert async probing of VMBus network devices.
Thread-Index: AQHVG8+rB8TiUWhGvE2+WaKfaYLfe6aNZ/mg
Date:   Wed, 5 Jun 2019 18:54:18 +0000
Message-ID: <DM6PR21MB13371A9EEDB55BFF96B8CA7BCA160@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <20190605185114.12456-1-sthemmin@microsoft.com>
In-Reply-To: <20190605185114.12456-1-sthemmin@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-05T18:54:16.3518715Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2f4015a8-1723-4eec-a720-8682a16c483b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7db79d20-9051-44b4-6182-08d6e9e73690
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR21MB1179;
x-ms-traffictypediagnostic: DM6PR21MB1179:
x-microsoft-antispam-prvs: <DM6PR21MB11790675C5E1C003CD2200CCCA160@DM6PR21MB1179.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(376002)(39860400002)(346002)(13464003)(199004)(189003)(8936002)(476003)(229853002)(2906002)(76176011)(71200400001)(68736007)(4326008)(53546011)(2501003)(186003)(7736002)(55016002)(478600001)(14454004)(99286004)(74316002)(7696005)(52396003)(6436002)(256004)(3846002)(316002)(86362001)(6116002)(14444005)(22452003)(4744005)(6506007)(6246003)(33656002)(10290500003)(76116006)(107886003)(81166006)(73956011)(486006)(305945005)(66946007)(71190400001)(52536014)(25786009)(66476007)(66446008)(53936002)(11346002)(8676002)(64756008)(66066001)(110136005)(66556008)(446003)(26005)(81156014)(8990500004)(54906003)(5660300002)(102836004)(10090500001)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1179;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4zvEAXOGxEohKmYzhXr46+UpPvTLtNuhuvD+/Jz/L9fcapucPBDdnAg2A0JAf+mUt9mDuwYpcB1hfgye0FxmaCfU5A/5rDUBunzfgn/HtgcfOKqsfEeWxSg9uEBPag0PmgdD3otBx6n06q74mEI8ZN2dkewghRFvy+ct6gDxt7JSPOcUDBnA7SKNthH6n2GPhr1oYDNWCUXeOSjycfhNWJIW3p3U7qpv1+MhbLkt5IVtPKkPHrxBaYl3FTd4qkv683+AxxVmFLm6KgY+COQzzbd3Ln+a3H8gQQCrpUL+hiecuaMgPs9IB+A3KJWLEbJD1kw2hnCiwwz3v3cQyQxn0s42G9+xfRA4oAg+T/yb5kjEvbeRfiNl/RSmQGKcBNRlbJYgv1LYl2g6da+w0cqV6CrIJIZQFhuQZahMdF0mFAA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db79d20-9051-44b4-6182-08d6e9e73690
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 18:54:18.0522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haiyangz@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1179
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-
> owner@vger.kernel.org> On Behalf Of Stephen Hemminger
> Sent: Wednesday, June 5, 2019 2:51 PM
> To: netdev@vger.kernel.org
> Cc: linux-hyperv@vger.kernel.org; Stephen Hemminger
> <sthemmin@microsoft.com>
> Subject: [PATCH] revert async probing of VMBus network devices.
>=20
> Doing asynchronous probing can lead to reordered network device names.
> And because udev doesn't have any useful information to construct a
> persistent name, this causes VM's to sporadically boot with reordered dev=
ice
> names and no connectivity.
>=20
> This shows up on the Ubuntu image on larger VM's where 30% of the time
> eth0 and eth1 get swapped.
>=20
> Note: udev MAC address policy is disabled on Azure images because the
> netvsc and PCI VF will have the same mac address.
>=20
> Fixes: af0a5646cb8d ("use the new async probing feature for the hyperv
> drivers")
> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> ---

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
