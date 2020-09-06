Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D825EC3F
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 05:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgIFDGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 23:06:09 -0400
Received: from mail-eopbgr1310124.outbound.protection.outlook.com ([40.107.131.124]:6174
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728257AbgIFDGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 23:06:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDAPRLyOxvFrkkfpjVE4ubMffeRti2XJaG5l/r61pq+t62zy83POMTSvmu0VumGVIOWOsgvmyNJBUHx+n6CJ+VpY7mqE+TALlKDxdr6bJ5ax4wSgoZHkHcU63unhS5KvhpgdlT8zGXdqf3TsE5gUHuR3MzUcTFTHShahi2GRlV12CeE3/54pINtJhUGytzydfB/L0rLBbXHYT0p6s/eKRDAm95RM7vIQbmBEIMhim3Efw0ckbRYASL1PwQ18cD6Q4ZyNAcDb4J2St0mGlf+bFuR2STWRkm6t5UVSviZy1vmli1sqkfBHQsNftk0tnkeW50nNsFGTB1nISU9vDviPcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gUmpkpWadBQcVnnqWTfnMX9TQ11ck8d09AL9r9Uzaw=;
 b=oaDSi35hOb6DBmZKbFV9SDPKBiU4LvFbhVjBOzlnEY1RYfzCDD2iGEJk8XPjAwXYHj3hnGLM9kYvsECRjWlOX5BPoppqywMZvmUblG9uaLuIFbi1R47w0luRi05MFSvj2LFNt/2HksazOzfD6LWEe1plk9kijzFyHbMdLtjX3zNbhpEjyTQDRaYt0AAXTLLqHKajUNxdd/hVBH3bNifmEbyNVOVunUHWppy1wVH4MYtZInVMtqrdquvW+12XEL4AJue+yZoHlB42E3MGm6SGylh3SsINj5uUzUf56oPbhb4Rh8CLY/B4s4BYoYAJazKYxFMVq5GblloH0RrpmaBqtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gUmpkpWadBQcVnnqWTfnMX9TQ11ck8d09AL9r9Uzaw=;
 b=O3wTivthBU3SBCYYwvW/SmGjHNeYI0lvbV/seXMK+vIZpfr3aea+aD0PZwGIUYpoAOx113alCZey6jbiu33K9XDUhTl39rVdQTAjM6vfOpFH26QCSezCpMcBPaypdrOIZXxXqLPtwB5JABRNN86RjN1+qwj+wyyS7eXHL4kNa8c=
Received: from KU1P153MB0120.APCP153.PROD.OUTLOOK.COM (2603:1096:802:1a::17)
 by KU1P153MB0104.APCP153.PROD.OUTLOOK.COM (2603:1096:802:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.0; Sun, 6 Sep
 2020 03:05:49 +0000
Received: from KU1P153MB0120.APCP153.PROD.OUTLOOK.COM
 ([fe80::800c:633d:2d74:4f61]) by KU1P153MB0120.APCP153.PROD.OUTLOOK.COM
 ([fe80::800c:633d:2d74:4f61%6]) with mapi id 15.20.3370.014; Sun, 6 Sep 2020
 03:05:49 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: [PATCH net] hv_netvsc: Fix hibernation for mlx5 VF driver
Thread-Topic: [PATCH net] hv_netvsc: Fix hibernation for mlx5 VF driver
Thread-Index: AQHWg9waxn3spG+TLEOE6i32cCwrKala5JwQ
Date:   Sun, 6 Sep 2020 03:05:48 +0000
Message-ID: <KU1P153MB012097D6AA971EC957D854B2BF2B0@KU1P153MB0120.APCP153.PROD.OUTLOOK.COM>
References: <20200905025218.45268-1-decui@microsoft.com>
 <20200905162712.65b886a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905162712.65b886a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=11b1139d-3963-4435-8fc3-3579038ac03e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-06T02:33:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [73.140.237.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 19eb6bd2-2de9-4377-1970-08d85211c1d8
x-ms-traffictypediagnostic: KU1P153MB0104:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KU1P153MB010489C2146CD5177DB0C93CBF2B0@KU1P153MB0104.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qbB5MCFHyECCJ6UGbmgbEWWNJLGJIzTlR8Jx6XNTY7HAicbQx526rpiku4RImWGijUw0pjzYE4b7AX8mVOFKf+2b/mRjMSBK2yKibrsv5fZCEVllss/Wfv6fZPKE7nv63SVjybBrNWamTaucG6XX8tUAHkYdc8SvjHkJ24FsNMFX/9/kIMwgAK+UfGt5mRhU2C9LA7ciQP3gZDVu9LdEaGonHjlQQfmRX2JPR/f8oKnyCEzg1B/cMakThtTrtaAgE2SvFn7jr/CU8UMUvLLdC5q2cMmawZPy5Z+Cosgp/Mbe9TBHdW3+PuRjnFQxIA/yZfOFUAjzq0Uagpx6xDkLhydr9k6cUMBTqUP8ELXyIDtRw+U3HIoi8ZrD71koXuXM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KU1P153MB0120.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(66556008)(82950400001)(107886003)(33656002)(55016002)(4326008)(54906003)(9686003)(82960400001)(6506007)(2906002)(10290500003)(7696005)(478600001)(83380400001)(8990500004)(6916009)(86362001)(186003)(66446008)(64756008)(71200400001)(66946007)(66476007)(52536014)(76116006)(26005)(8676002)(5660300002)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DvLqs8xqPMYN9+9H1Rf2PLHKviaO5VPltV1WiPKr3bxQTyxjoTF/5xN92FdmX9XnviiGjAiaMVg/fNgwSopIGNrmaoni46ywCO5YPtv9i32dlGowghHSJIseRiSq1hpv08pv1JKCdNFoZBXcZoBwAj7wlD0ZCqY8aHq0uiHs5urAcchIESp25cMsGr/NtCvICKqcXsGJz3d8T4AuXQC9GQWSo7pLYPzG78B6OcX3k71T4kVu4UvY5TTK0pAq2Xmbtdjr9QNfCWKraxyOpV1s5GFLIb8xTFmNSKvGPg/9/IADV7xHkThl2nxc3+qNTzOrB1YFjm2T0vZTzA2ShmdRx7NPum1VxcCMnKI8+rJzPl7YMo8OSiQ2j6jUAHBRvaJT8PNQfW9fVRbU1CBF1ixPRaYdo0iCOdfLYPSJ/lfYSpU5iX5J53IPF7fwgG+IZkL+XSgnPNvnevcKV5RBrAKSLrr3Z4piyKqAFEN7UFKVvea+rNq5kAuOCUT9mGlAFjF197Lt9DWthqSQAbV0+RsgUjUZ3nFgkinVTghc9+aUmcO4EcZJVgWVp2C7J/MyuFKuZ3mDTMfHnvF7OVRSwkn3zBb4aKX7AaATuRtO3vyrK+vVBr00vdC23lhvhJHvYOjxCm/m/EDaRgz+3n/Q1rOlhQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KU1P153MB0120.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 19eb6bd2-2de9-4377-1970-08d85211c1d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2020 03:05:48.8804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ucKJjxPNBa+MYSZTY48fZpHwFxdXjHHhWfktB/ngxDk1yHDuhX3JMQ6FeE+1C0FEbKGw8vBGbN5gkOoNsZ1E6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU1P153MB0104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, September 5, 2020 4:27 PM
> [...]
> On Fri,  4 Sep 2020 19:52:18 -0700 Dexuan Cui wrote:
> > mlx5_suspend()/resume() keep the network interface, so during hibernati=
on
> > netvsc_unregister_vf() and netvsc_register_vf() are not called, and hen=
ce
> > netvsc_resume() should call netvsc_vf_changed() to switch the data path
> > back to the VF after hibernation.
>=20
> Does suspending the system automatically switch back to the synthetic
> datapath?=20
Yes.=20

For mlx4, since the VF network interafce is explicitly destroyed and re-cre=
ated
during hibernation (i.e. suspend + resume), hv_netvsc explicitly switches t=
he
data path from and to the VF.

For mlx5, the VF network interface persists across hibernation, so there is=
 no
explicit switch-over, but after we close and re-open the vmbus channel of
the netvsc NIC in netvsc_suspend() and netvsc_resume(), the data path is
implicitly switched to the netvsc NIC, and with this patch netvsc_resume() =
->
netvsc_vf_changed() switches the data path back to the mlx5 NIC.

> Please clarify this in the commit message and/or add a code
> comment.
I will add a comment in the commit message and the code.
=20
> > @@ -2587,7 +2587,7 @@ static int netvsc_remove(struct hv_device *dev)
> >  static int netvsc_suspend(struct hv_device *dev)
> >  {
> >  	struct net_device_context *ndev_ctx;
> > -	struct net_device *vf_netdev, *net;
> > +	struct net_device *net;
> >  	struct netvsc_device *nvdev;
> >  	int ret;
>=20
> Please keep reverse xmas tree variable ordering.

Will do.

> > @@ -2635,6 +2632,10 @@ static int netvsc_resume(struct hv_device *dev)
> >  	netvsc_devinfo_put(device_info);
> >  	net_device_ctx->saved_netvsc_dev_info =3D NULL;
> >
> > +	vf_netdev =3D rtnl_dereference(net_device_ctx->vf_netdev);
> > +	if (vf_netdev && netvsc_vf_changed(vf_netdev) !=3D NOTIFY_OK)
> > +		ret =3D -EINVAL;
>=20
> Should you perhaps remove the VF in case of the failure?
IMO this failure actually should not happen since we're resuming the netvsc
NIC, so we're sure we have a valid pointer to the netvsc net device, and
netvsc_vf_changed() should be able to find the netvsc pointer and return
NOTIFY_OK. In case of a failure, something really bad must be happening,
and I'm not sure if it's safe to simply remove the VF, so I just return
-EINVAL for simplicity, since I believe the failure should not happen in pr=
actice.

I would rather keep the code as-is, but I'm OK to add a WARN_ON(1) if you
think that's necessary.

Thanks,
-- Dexuan
