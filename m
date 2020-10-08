Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1355287322
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgJHLKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:10:35 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1982 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbgJHLKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 07:10:35 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7ef3720000>; Thu, 08 Oct 2020 04:09:38 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 11:10:31 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.51) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 11:10:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lv3TeQU3qwoyqCG4UIVBA4Ta/hUisyjHdludKKb41i+7OZ60cB888Q1XRRzP35677HbePAXioMbTu2s68+M/PVMp0RlT1XY+8chyfmPDIy8clQv1Nsn9Zv/JwEqyWDxR9EfsbFBamY47xzAbkK0LNPoOg2fLxOf9SSTIY3NhUQfOAAfwlsW1VEAhLVaEqKfauu05WCgEkPQ9GRGFPcHmROBo/3H8UVSQj8c3oSZ4wggcosnftgerBbIMHdZ0pJvQIwCRTka7CeVjA8Y3XdfVQix4O3qJlVk6Tdm27j9lKtvvM1dwTsUkB9QXX0EGcnr23EnKthF6WUdGZcHEsXhURg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zf2FSHAzPFdFnqiX3nFaoD2d7167WOp+iJrEYnsyBzo=;
 b=GZP3sTpO2ghbe2IaBY3Zbf9PE7JvRXIazF4zn9G4IkYsXlAlW7o+jziXWWd4Z91f6XRc7g0yz5pqe4idhcUWhhYr6AA3uAbYhUA2Ei4+4S3N5qInIS7FqVSaWFOpVDy57x37CvKhyBAaXHUheMQ+poJtQuGpTCzmvLLjAXUKvl/y+uIRzZFZy92Tq0RgLD9VggzfRuagf2MJ771m5gp5jt+5WBRKcT4UJC/sYmnM47d8I+Rh1gf6C5AHFhUCQgASUBGrVPiWBDpok5gFAnkeOVotxN3tf6o8+gyXiorcn2RGjmRMX9PErKPWZDf6ThpYGpAN2Bit71rnp71SiqLqXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 11:10:26 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 11:10:26 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm05cPW7H51WMukmCocLPE63Nf6mKKyGAgACGC4CAAB03gIABpCoAgAAWQgCAAAuCMIAACwKAgACP2oCAABO3gIAAB+wAgAAKeACAAAOTAIAAISEQ
Date:   Thu, 8 Oct 2020 11:10:25 +0000
Message-ID: <BY5PR12MB432291F0683A2295170C2F3BDC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201008052137.GA13580@unreal>
 <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
 <20201008070032.GG13580@unreal>
 <CAPcyv4jUbNaR6zoHdSNf1Rsq7MUp2RvdUtDGrmi5Be6hK_oybg@mail.gmail.com>
 <20201008075048.GA254837@kroah.com>
In-Reply-To: <20201008075048.GA254837@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [49.207.195.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3ca7299-1379-40cf-c454-08d86b7ac237
x-ms-traffictypediagnostic: BY5PR12MB4227:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4227DD3AFDD00EA4043CA65BDC0B0@BY5PR12MB4227.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VZkRrD/whRpxqtZumw83OtdOdPx3ZwK0XLX6BEB3La4tupYv3rWhyLVgwhJBLJZsyQhsyixCzKnn46VoRB/AuLfZqIwAFgrnmAi4XBaVCDO9RUuMDVmBlD2UW/0jJawgY16EZePALHe6r/pgViW6yeA+dHpsZk+vhW8BNg5edbfwSotupCYAbUqxvnPHe7fJc1Ju99WuyrMZ8WRYd+hQxgFZw1FCBx50a0+PDEAFkmsdmiGWYZnXOmL7Al6a0ERk19uJZqiFyDZFg154d5+5uv56vKNaxpqYK5v7zngvpaTEwauIryvtZyWY5fIxbsnaeq0E/kMcDejYyosdNz27XtFkcwEjyz296+/Oj9VGoGZ4g4w0Jnx+xRpjPzG0QvuhDj+wjgchKQ9OeApYlxxrBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(2906002)(5660300002)(186003)(26005)(966005)(8936002)(7696005)(71200400001)(54906003)(55236004)(9686003)(83080400001)(478600001)(7416002)(8676002)(6506007)(53546011)(86362001)(110136005)(4326008)(52536014)(316002)(66476007)(55016002)(33656002)(76116006)(66946007)(64756008)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YJkvRnVrlDnmTRbfD3tRpxeraCV1yO/O/z+K7iigkZP1NkKutDfDkap7kIOw4Mobv6hSjI/h41tXoPoVhFgtNn+gMDy6WQivhoJgUumXzDbHnMssQHJzuvmQIoO+zC/7EVwZbv7pXWV+t6UoZok1mPP5KMJKrqwgFPqDPeaDoxnZ69y+5C1/lB/WD1Z1TCPuTd0M4zyh3wL0/+U9JyT4DErXWMaTJCtxqzmTeP9whzdbqA5imSW7k4uplDblyp2/GbJcOaUCUzuT1I6v9d6fflZE5IWPXR6SVAnFlBk1iKqqZZCbdGNmt1e1Ptv5mCrsqapeAHZNFSYxWWugrjSGjUFIj4e0Djh9yEVRIxD5D6yz94uI6TaFMSSmLF2j9TV/zk/+unzWslj4G7svHD/F7WxiM1PXb18G3rU0hJjZA/qJVAS8tB0LDa2izAKONyX300ziy7pVco/cguXKIA5Ggsp+6kJrZbEfg8x/e8G3XcXb+tJKPaCQdJ1Dra04YuUZYskk5mMWF9xMzODXbRo1FjyrhWuRwr0FcQmWzzSi3a5A/4R5knzZpwPRfu3DWSXi5lziks01cScHJPFqylzTtP5dH/LHTSWdcrSAdu+Vd285vLdkWnwVPmKPDT50EbwJu69kDpXm7/+tvsRN7d8n0Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ca7299-1379-40cf-c454-08d86b7ac237
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 11:10:26.0158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QvvI5ggyd8z56F6PpiKN/auEkymlKQFQu9xsm07T6FLZPSZAtDgC2Jy8qc83DbFOEKKy3aAXKE4BZqdBSEImyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4227
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602155378; bh=Zf2FSHAzPFdFnqiX3nFaoD2d7167WOp+iJrEYnsyBzo=;
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
        b=LDJMzwejyu3tfoy0ZK5X9TRqlF3pAFq/kAms1L17EbHcwwMbd+I0cXxERZMzUZ7uz
         v6P2rFZydfstRfGUw0ah3x7EDiHyeYhWm5BSD+m3bolwP024rgOVjotdtk/eqvKMM9
         HxVDREKxIAQoKC0QvhbsKCJZOdzFHcoqQoH356D5q88CP85iMCNdS2zqoPIXSPZHeZ
         HVvqTnKS7JZ4nbQt0dp+3JCqv36sIHVwu+wUScq2nlU+8pKlUN5HZmG2JU8exjRgm0
         u2XHeu0L/DwbTCt4VSiCpFiOhdGCmhPqXZBXLllJmGIeTmRKK0Mn0msJpIZGBytEkL
         w1G7UdYULB6tQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Thursday, October 8, 2020 1:21 PM
>=20
> On Thu, Oct 08, 2020 at 12:38:00AM -0700, Dan Williams wrote:
> > On Thu, Oct 8, 2020 at 12:01 AM Leon Romanovsky <leon@kernel.org>
> wrote:
> > [..]
> > > All stated above is my opinion, it can be different from yours.
> >
> > Yes, but we need to converge to move this forward. Jason was involved
> > in the current organization for registration, Greg was angling for
> > this to be core functionality. I have use cases outside of RDMA and
> > netdev. Parav was ok with the current organization. The SOF folks
> > already have a proposed incorporation of it. The argument I am hearing
> > is that "this registration api seems hard for driver writers" when we
> > have several driver writers who have already taken a look and can make
> > it work. If you want to follow on with a simpler wrappers for your use
> > case, great, but I do not yet see anyone concurring with your opinion
> > that the current organization is irretrievably broken or too obscure
> > to use.
>=20
> That's kind of because I tuned out of this thread a long time ago :)
>=20
> I do agree with Leon that I think the current patch is not the correct wa=
y to
> do this the easiest, but don't have a competing proposal to show what I
> mean.
>=20
> Yet.
Please consider the approach of ib_alloc_device(), ib_dealloc_device() and =
ib_register_register()/unregister().
(a) It avoids driver calling put_device() on error unwinding path.
(b) still achieves container_of().

>=20
> Let's see what happens after 5.10-rc1 is out, it's too late now for any o=
f this
> for this next merge window so we can not worry about it for a few weeks.
>=20
Ok. INHO giving direction to Dave and others to either refine current APIs =
or follow ib_alloc_device() approach will be a helpful input.

ancillary bus can do better APIs than the newly (march 2020 !) introduced v=
dpa bus [1] and its drivers which follows put_device() pattern in [2] and [=
3] in error unwinding path.

[1] https://elixir.bootlin.com/linux/v5.9-rc8/source/drivers/vdpa/vdpa.c
[2] https://elixir.bootlin.com/linux/v5.9-rc8/source/drivers/vdpa/ifcvf/ifc=
vf_main.c#L475
[3] https://elixir.bootlin.com/linux/v5.9-rc8/source/drivers/vdpa/mlx5/net/=
mlx5_vnet.c#L1967

> thanks,
>=20
> greg k-h
