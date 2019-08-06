Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8F182AEF
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 07:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbfHFFZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 01:25:54 -0400
Received: from mail-eopbgr1300110.outbound.protection.outlook.com ([40.107.130.110]:26688
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfHFFZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 01:25:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFGQgQse6h887TDJIfsMj477R5P2Nk56QkCCiHCrrQxqd8ZI8WonP3s9MoGFN9FmqE+8WizsMfOSk4KqKD8So2skf80J/Rb9T8qIg2An8jSKswMQeX68wFgJ5AXX9d9pPBURIuT4uel8pvFMn+jtg5pend1V9neNezdCzKZ+3OAh+H+27UAXw0lO4rTFyiI56PbJQ6vHab+CncVvxJuG9snFPvsiyzJ/SrEa/UkDWkFgH4Lx6UEnpS1S2x23mR6By80w6A/iblkWi+nNnV7pwWRfd4tXLwZIHm3/YjDoZyntglLbCbWuamN7yqL8UqcdXN8zC1CsTq05JH+1XYObmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W92Wrldl8hKRAlWzMNUAZBripsa2WX3YSMndAPEzq4A=;
 b=Qv99a+7k47ZB93sUH5LV7OK4kYTDPqYjiK8/JyMZW+nn4CBb0IUnMQKwOeUMOl4mZWc0Z4AJuseGQmnbtdrVRG10L8RxrFnzkzP28PLcQPNfShirhJ/g3pZV6tIS6iZrRtKAeJK4Y0w5wbkDo6zzkkaSH0gaThfa9LDVRvgKIgDsBINWbmwJeL1ntXuqOPo/2zU5APNrNwo5qdwvMT+gp0xX5c+ld+nK4x55bjaJE8no1GPW4YsrlW2BIHEDNkbYjohMNltsfJhTN8tjRMnIlqI2BE+Q4NMs0rSdU1KHkmu81WDVk1gH8iB+GDJIARFKtcrSVeqYLlSxAX4oEWWv0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W92Wrldl8hKRAlWzMNUAZBripsa2WX3YSMndAPEzq4A=;
 b=kOmzyXaxjceJM2sT/xU57h1CT6UmjZZxs67mO7DP86NIQx66exVWPyBVbaSIDmD0Jksyv9y0QhlaOR//C+GmE2oDs4UIk4KiyjTBCne37GiNWuqPxNYMdarGOOGhfLFWK4kVB0Cyqssmag5u7S2GUFldws4oGo3aojhEMTzZ7lQ=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0156.APCP153.PROD.OUTLOOK.COM (10.170.189.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Tue, 6 Aug 2019 05:25:49 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Tue, 6 Aug 2019
 05:25:49 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yidong Ren <Yidong.Ren@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: hv_netvsc: WARNING: suspicious RCU usage?
Thread-Topic: hv_netvsc: WARNING: suspicious RCU usage?
Thread-Index: AdVK97JbsdQk75jSTeGC/HNWaEL3qgBH1GsQ
Date:   Tue, 6 Aug 2019 05:25:48 +0000
Message-ID: <PU1P153MB01690E2762549221EE9D960DBFD50@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169B7073A4865D50AED9EE5BFDA0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169B7073A4865D50AED9EE5BFDA0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-05T23:55:44.4679731Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1a064ef1-8d65-41ee-93fc-f62f22dbc6b5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:f805:f5de:9ada:9d42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4849ffd-e377-4e79-461b-08d71a2e8a98
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0156;
x-ms-traffictypediagnostic: PU1P153MB0156:|PU1P153MB0156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB0156DDB3CB0DAD9C50DEFBC0BFD50@PU1P153MB0156.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(189003)(199004)(22452003)(305945005)(256004)(14444005)(66446008)(66556008)(64756008)(316002)(6246003)(66476007)(66946007)(8990500004)(4326008)(10290500003)(1511001)(110136005)(81156014)(5660300002)(76116006)(2906002)(55016002)(14454004)(7736002)(7696005)(52536014)(53936002)(6436002)(9686003)(478600001)(476003)(11346002)(446003)(46003)(8676002)(74316002)(2501003)(102836004)(33656002)(81166006)(6116002)(229853002)(6506007)(99286004)(76176011)(486006)(4744005)(10090500001)(25786009)(86362001)(8936002)(71190400001)(68736007)(71200400001)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0156;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eALOZQrMCH81HvWkksEcirz/R5DBvV8ld8Z7ImT4gyfOdZD7rGBQBlfP7t9dN4IPL+fIVUx3b0emiILzdYTTgBmNQxA6ALdVSaWMsrGh9keII7uvQyZMPjJitRRch1ry5PEqUe4m/LS9Bxh2eUl8FqlzVdhU4EvX3mNzOhPees6PnMQQJyM/Y8aizYPju/aks2Y4FtUqRY52RMgJgBsQRpEYpwCbCGo2uqbCnm83saGPz85Za34HDpitiTYq9eyMnV4ettF6k6Da7hWMPsrrvZU92jTEoJ9g5u1t7vE1nVYTuw1jm8e5JedXTWHzYUUXt8nqC7Rl9Z8EzytKhvtfBw6sH6PrLomQ/lPadyEUTuHmMuIKDRc0/Sc5T+6+qkseI0//RdgJzYV3xZPEx2jZ3zA5JKl0SDop/HMSYIkwtxI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4849ffd-e377-4e79-461b-08d71a2e8a98
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 05:25:48.8829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XZ55HjwqRh5XDafkRgA2BbleZ7k4wMaZYpd/+n/Jyhpvo8B9NvV3Ntf3NX3QGeyIk+F5zvGkcLCvZ7qVMHD81A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Dexuan Cui
> Sent: Monday, August 5, 2019 4:56 PM
> The warning is caused by the rcu_dereference_rtnl() :
>=20
> 1239 static void netvsc_get_stats64(struct net_device *net,
> 1240                                struct rtnl_link_stats64 *t)
> 1241 {
> 1242         struct net_device_context *ndev_ctx =3D netdev_priv(net);
> 1243         struct netvsc_device *nvdev =3D
> rcu_dereference_rtnl(ndev_ctx->nvdev);
>=20
> I think here netvsc_get_stats64() neither holds rcu_read_lock() nor RTNL
>=20
> IMO it should call rcu_read_lock()/unlock(), or get RTNL to fix the warni=
ng?

I just posted a patch on behalf of Stephen:
[PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
=20
Thanks,
-- Dexuan

