Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697DF28507C
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 19:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgJFRJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 13:09:16 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6386 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJFRJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 13:09:15 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7ca44f0000>; Tue, 06 Oct 2020 10:07:27 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 17:09:10 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 6 Oct 2020 17:09:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUgQ/mQQr1d4fRbCj75txwTEs+KimDCYQp94tbv1LEDv/Ob4VfiK55I3QNSpSrZXChWM81cA8TJE1rWg6WCoJbTyTbbGZKncq+8zEYbrMU6MApDIjQKp/C5zz9Rpa0VswUYwXDsvFgHRDrJlOkeDYPSw7vSuFcF76dgE32gvnRjvnfADaT0UK+GCRXywatNb63Nm1gfpL0JBNm5PF4y3dHzwxU0T9WTESiQ/HF8KWcupAuQ2ukbMSO56yXylavtLg4Z7G9T2igCpm1A03A9WQLiK6NdMH+ick3Tr2z/JE9EWH9v7cVqLcq8PzYkuPNWpdi3MG8LpnXfzTMI0meXQDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4SVRWD2qL3WMCNV/GLiTejMwr7QBvw7BhW6unk7yqw=;
 b=Oc/uQTimPP9eNMTKAZnE7WkqkdHWC/GbSn0VGjI88arlJfjhwaimn36Rb2aMwpV0lHCRLDT0956qm3RGqJuaRMOEIjC3+WF+xOaQp8lHp2Uin6ScS6n+odO63Z0zQZEx1kPvivuARNov31Aec7A8x242ubuGn9yG3N4Wf2Ne6HbZQQiBSe7em7/zQaoWung7XpG8DxlVGMDFwcnCib15UR8fQYuEsAqzOprDw0ljzKjh82YUxwIGsPfJOXcc+0RmimhpbDg5LrUVmgBVkd3YgRkYa9MjJOo9jlIWHXauqpbbfW2xZzjpGdcBU4F6lwepypM53g1tBKmSMP22Drf5Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2885.namprd12.prod.outlook.com (2603:10b6:a03:13d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 6 Oct
 2020 17:09:09 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3433.044; Tue, 6 Oct 2020
 17:09:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm05cPW7H51WMukmCocLPE63Nf6mKKyGAgACGC4CAAB03gIAAASRw
Date:   Tue, 6 Oct 2020 17:09:09 +0000
Message-ID: <BY5PR12MB43228E8DAA0B56BCF43AF3EFDC0D0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
In-Reply-To: <20201006170241.GM1874917@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d0dc7da-a5c5-4ab2-b999-08d86a1a8a24
x-ms-traffictypediagnostic: BYAPR12MB2885:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB28851A434CC1BD96E9E5D386DC0D0@BYAPR12MB2885.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Z/Rr8UVyH58hNzCWiFKAC92WtyAQqZS0/zsgP0Tr6vroKyVIslfsOMQXCDbx1/o6MH0RPxsF2V46ENh6R6Pmiff0BYr7CUzGJeZbbyNbweEJy5hbpS5sRl0ecyuQLq52qHZccEOPi8ir/1lBPsPWhWxnz8Ol9lZTjk4eFy5/J9uoSvE5ZPDA/XkcIqHtMhFAKTlhESZHddXNAY1Fmz4RMuWojgvcxUjlQul8R9irn4MLMy2veKr+2uZLVCQft7ZTGLSj57AfxpL/ckozCNX140ktMx7v6N50enizH4XCNBQKWt7QDl9pE2795drboKptFX1JZFUYKFhjd8c1cTLGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(26005)(86362001)(52536014)(186003)(8676002)(6506007)(4326008)(7416002)(9686003)(7696005)(33656002)(76116006)(66946007)(316002)(66556008)(8936002)(66446008)(54906003)(64756008)(110136005)(4744005)(5660300002)(55236004)(55016002)(478600001)(71200400001)(2906002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 4oKUvscTBulwSDtiU9ZFL+4yVIOz/rJ0mRueeqEgR8ZFcpT3Jje0AiNYUClyrz9Ap+W3C2emRZ5ymYwBuvHnIt73z3aly0UexnLKHFtel8iUZLqj3G5JBvCiJJeKgMHMZRJZD2jV3WZhHV3oDedLw6VaPWCXxBsMelP51H+ZiOPULN6TY6SNJiiHGpW1borrxG19ISO26qPYepVGADajM/9xAmSHvvaokluid+WPDYdxeW2iVjF1Mgk7W2v3b3gdhMcIFuWV5cv2xyl/PodMzyVMvCtJd6WdcsCxPfLENZxeR/sxGiEzr1P3n0qCTJQadFrzk+ra4wLOpjjyFd5Ddc7MRONy9WvhGvnl3joXO0KAHpgP3dYwIA5AiidwgvoI0hoP6rKm9NJooRKKEf95LlaFhxNZxvFr4TrvQyytFkWszISWJhipARNTDcphJ1akD27qCPxVYv4EwC/avo/ITA4eEcotryLYVgu4FPIk2z1JLKFmJaoSV6Zy7iTJNQAgMTffIUxiLfoLcjsvZTEZko8NKtJ51wPSgipnXq5odXGBdfHMvOwq7bRxlrNboJ6tt+WZefe6WJ94Yvu9rD6tRN1u3DDY7F6aIqzy4MWbiTUPp5Q0pI+BPSLjr6W7oDDp1CdrUNvQMwCa/oPWeduhIg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0dc7da-a5c5-4ab2-b999-08d86a1a8a24
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 17:09:09.0429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q37FTNwrlqWgH4Nv+3LQej8U/KdsNvoGaeXDdIrluiwUT3S2PKVzcK/iSgapWtAmXeZTJPjiOI60bMWYTvOBMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2885
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602004047; bh=p4SVRWD2qL3WMCNV/GLiTejMwr7QBvw7BhW6unk7yqw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=YDSS4YwfT44wRPU0Tg0tHaXrZ5/seWbd9LXZrUxyWsEC6GQGde2ZcochNcG4TuU/n
         /8LhHdqY+tsSAFRWxntk8SgfdUBUyjo53BX4ULaYU5lD7kSqRWXNOuf3pmpP588C5e
         2gLXWK39ZQlhnetKg1onfCDPm6xctAMUkLH8T96LoFicH8RYYSGgxRZBLVmIpdRhP+
         4rDzP1fQ10o+ni4wLNbrcErFgEcHTuZCp7AqG0pR8+hsMcY1dCEuiBGCwTAtdINh/r
         otOWaEGam+rb8wA3udyU7NS0eUNfgyyL3jrTLKk9vlcaL81fkDr+mWa0uy/8A1Ea9B
         bHnTGOJ5N5T5g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, October 6, 2020 10:33 PM
>=20
> On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> > Thanks for the review Leon.
> >
> > > > Add support for the Ancillary Bus, ancillary_device and ancillary_d=
river.
> > > > It enables drivers to create an ancillary_device and bind an
> > > > ancillary_driver to it.
> > >
> > > I was under impression that this name is going to be changed.
> >
> > It's part of the opens stated in the cover letter.
>=20
> ok, so what are the variants?
> system bus (sysbus), sbsystem bus (subbus), crossbus ?
Since the intended use of this bus is to=20
(a) create sub devices that represent 'functional separation' and=20
(b) second use case for subfunctions from a pci device,

I proposed below names in v1 of this patchset.

(a) subdev_bus
(b) subfunction_bus
