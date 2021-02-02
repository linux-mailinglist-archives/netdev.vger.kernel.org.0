Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131CC30B996
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhBBIYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:24:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61344 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231324AbhBBIYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:24:04 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1128LG17025656;
        Tue, 2 Feb 2021 00:23:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=GXOw1XX+xcWHPvVGJwVRO7M84C3sqfPQ5PkGyT8A/v0=;
 b=c7lUJJnUSIwRwf46iYYrmzW4WLCZZg8coEEfYDHxqaH6/TgjAcHySsg3vvIZefBFxax5
 x4eRjgCnUu2yQppzW7ii1bH/t5beHgDrWA7l0+F2JReYPlPoQq5M9nvqsa4LXlxK59A3
 aUp5R3updiaoMcUfVp9w+mkwM2siSZiSlYCIPrmYgkx+H21kMAU1gAkvDvoEGlve0ike
 OS6w4ezjlBdSiidR0eM1bhkowmWO8muNQPjZO8IFsvYq/IfFuL4zu7QNW/RWg1PB2Ig6
 zRfEAH/iMbnr+hcXlQfsdc26PF43+sRq21yld695d+aDiivL6axORUrHnGLDnqQQZnCm ew== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq6emy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 00:23:11 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 00:23:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 2 Feb 2021 00:23:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LF4110eb600ZhPulG5LYhD7kjtXOOYUNrEEcG7/KrPC/ekOH1+DzBbqfzF/ggVDIoz4+8bvMi3dtZG6qSJm9FtxDm9yazlJP8txyZaxNB+XvZOV5WOVqViBXR4kX9n3fHlWb+WAHMz4tCcmU5aT/XiX0dfOG9H+qgeHNDmzbi7nvsj1bWesXchXUNNLV6lamT7PbKTzgvH4W4nTVHJCOxBTha04ShIWReFZSiXgVnKUDBjgYhQJ7lSpwkhpiSMYJqIQKCiDwQA5jBaaKYGBJ7pZ0/oLjO3H8Qw/2OplzvNuuBulqh7rQovmYb46Bfh9UaHfyNdLMzEVgiw6Q5eB7cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXOw1XX+xcWHPvVGJwVRO7M84C3sqfPQ5PkGyT8A/v0=;
 b=P6EFCLEM36TJN/gx4/ND0tiZYiY+GQSniakCH0Ps7Cx9QWFEVPHTu1Uftv9VxtAPR84bdZ8l0YkBJp5oMBOznWO8jLLUSonr+9Z7ERnglZ3TdvstGqiJem1D/HS75oAPgjyeq9w0lTrGhI69vNRMbsdaLS9CebjTdbk7lxy1AYhuqTHRahf1GbejYZuwFzMAt9qRbhSJ2crJA75Z7QLpenO7ZotsrJhu0aLUbj3jMLZuC8haCj+R+5PuifOlGrsntOZC7nOV9b/5kjA2rNlvLlkmBiLY4B6mbD6QiB9r1kRA7HVf5ZKsc7G2gH3l4bc7YRisINHwR9emT+e0eKH5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXOw1XX+xcWHPvVGJwVRO7M84C3sqfPQ5PkGyT8A/v0=;
 b=fSXFYruQfp4IyJt/JVIlqiN4omVi0SepksNKNDrrsx22LquZqAppfBrfdtFgRFqYGbjQ43zYUFFRwP4/S1UCK2CWrkJtu1C3XizgRQ8m7L4aqcigbqXe2g3BXVmhklGeGp0aXXiLLYV/fL5f4ZuFtLH0jKyMhyR9H/xS+j0h8jA=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3924.namprd18.prod.outlook.com (2603:10b6:5:340::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Tue, 2 Feb
 2021 08:23:09 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3825.017; Tue, 2 Feb 2021
 08:23:09 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v7 net-next 00/15] net: mvpp2: Add TX Flow
 Control support
Thread-Topic: [EXT] Re: [PATCH v7 net-next 00/15] net: mvpp2: Add TX Flow
 Control support
Thread-Index: AQHW994sgQfzUkJwE0GqPEw6j9n9OqpEEjQAgAB3I2A=
Date:   Tue, 2 Feb 2021 08:23:08 +0000
Message-ID: <CO6PR18MB3873C1896F5C9B8E172B7F4BB0B59@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
 <20210201171602.5a7583ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201171602.5a7583ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79f9ca58-f580-4bdb-2a96-08d8c753c5f2
x-ms-traffictypediagnostic: CO6PR18MB3924:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3924ECF96487AD54F09AA82DB0B59@CO6PR18MB3924.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:312;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jonRS9Wv2cl0/xZ4a3yU7crDJPpEVnZx8DsnwiZeNNBggBZEhc1rct0Bs3xcR7LwU6ECLuSpvdBN7nnAp6/6p5FoAUO5IRGBr6WH/oR0MsIfaBKh/uYWAMjgyOoHKnxR8XsY7DdYivlTGDwhe42HR6JRyTMBWbvI4ssVU9U56wpMuqNjHVwXGcU/Tkf98coBlT3rBShLYeOehZCqVRKskN98QHBY4Z/1Pv4d5uzSb9Ax8CIt/JA0fqcsgXBXtoJl5rxZ2+KpeTDhCYJuMvU5LX2QvGDfTQRzIBRAYt+od6v1THGsvQTnOg95eKqxGC27egXI4eJATDN6TOfEx7DG3Y3f7OmJPPe27tqq7MTC4YhJ1z7d0r2Np+nxjwVks6EysnR+oGZDR46DTFXx6nMcvV3t6GeyyfjYM6SUHjwSg9n3ICAr0TqLmt5ytc3AQUcagpJPQlosJ59wdYEG7v8RvscMBJL4cvXpByjDDbVTyDZJq2f6IAKlX23cj0GrntTL8cxbaJCvYHfuqQKsTXgOI0J4G7sHH0kjp44KSlCqWF1Du31fRHrb+5NVucijSzSQD2M1E85XJDRvcUHGS53xUJ0zuHuJ/2ju3aW0kGjqEKU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(76116006)(478600001)(966005)(6506007)(7416002)(66446008)(8676002)(64756008)(8936002)(5660300002)(66476007)(66556008)(6916009)(7696005)(66946007)(4744005)(55016002)(33656002)(54906003)(26005)(86362001)(9686003)(186003)(4326008)(71200400001)(52536014)(2906002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vZ4gAyH1MIvb9FtYCYpp8T/MccXpdALNN5Du2+v35/H3hFmwp61QIUjvlpUI?=
 =?us-ascii?Q?g/ahfn+33Q/ZF8alvyh/Pin5bMJJFb8Ns63GjudMw1BGPGbOF4uf+z5KIhGK?=
 =?us-ascii?Q?GrArt8R9Hhx/MIM+/3jqQjRLYBDlIRh4XZ07dT78uqiYcvimVw3Pjry76yS5?=
 =?us-ascii?Q?ngmDqwtSqqI6qBO/m+VD9Dn/w1EmlgrONiBRuagAtEGFgxo14tw5RmSSrU94?=
 =?us-ascii?Q?wCRm6aZxTPAZNygV1qZL2pv/ioKuZESAbKJDR0h0NMb76u84BY9D9pCZb1kA?=
 =?us-ascii?Q?akA77RH2ml8fkkyuloBo9tOlrTUEzsy/MhxUREDYA0Cj196pXTK7dNu7xr2I?=
 =?us-ascii?Q?VX175RVkr3KkYjGxf4nWnEBnte0tnoSfAbSI+uFYpYGndJY66TNrT+RqLpyU?=
 =?us-ascii?Q?2W3UJbrI7MJiBlG4yBOb+wju5/qxh55yoRT01Y8nqPYdkpkdPJv5ipboQvCR?=
 =?us-ascii?Q?eVdmVyYB0g1XNHnAxgqA69KpdISebzBS84Pk90Tea6B2WIO2Yz7JmI5kCfcf?=
 =?us-ascii?Q?i7G7cJtviGg+XpoPeOpnEfh+sdgom9ZxQ1RKRAGlbwAbAxDlqP3TRH05+gWh?=
 =?us-ascii?Q?pZcBHXGefOjAdZDu8Xsfu5egv3q+0lXJnSOkSIOHs43DgWOrCa1SAu6WhOxS?=
 =?us-ascii?Q?1BI4e6ntHE1XsMGcZA41x/bDzdnemGQcVVYCA0M3UOoSsZLYlDus1Xd+XATv?=
 =?us-ascii?Q?rpxHSapjlAKf2YhLzAER3MSSvL01/P6e3Yp2kJzjHmSPyGYdC03X8DMBAuul?=
 =?us-ascii?Q?fjc6sG6YbGo5cVYUchGrzm3Cf+Qeq58jSoCFsQ8pWx6k1MikuckCxDkA4oMa?=
 =?us-ascii?Q?TZ82l3TpsYPfuIoMn0e9r0V4lA04vQe+lg3VJAfBF461oRcJMl3HPTAYZv1U?=
 =?us-ascii?Q?dRh9Fn0Y7zkxTjK/qTcYn/umI6kHIC+pnzXVeOx/71n4CAl0QwZJZJAerxoJ?=
 =?us-ascii?Q?MXiiXA+4d3IZF4nb/xQCMDFSCJ2DlXXFOvxRaOvnZWil2JcrZhcv2mPAYDb5?=
 =?us-ascii?Q?e6OOV7PRtdgRDlIJ4MlWccQ+sLf99Xl6lWUevjN6UTFNmkrHP7o7+qrWabHK?=
 =?us-ascii?Q?dG7W2ep4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f9ca58-f580-4bdb-2a96-08d8c753c5f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 08:23:08.8836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a1WkQjRLcVknIlqGDOvjQM8eMc2OKuW7jY5d+hZ5pK+TArwEBrXkZ+PWjvcUuAgZZqoTUjfa5CyIE2iw54TmfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3924
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_04:2021-01-29,2021-02-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Sun, 31 Jan 2021 16:33:43 +0200 stefanc@marvell.com wrote:
> > v6 --> v7
> > - Reduce patch set from 18 to 15 patches
> >  - Documentation change combined into a single patch
> >  - RXQ and BM size change combined into a single patch
> >  - Ring size change check moved into "add RXQ flow control configuratio=
ns"
> commit
>=20
> It still did not get into patchwork :S

Reposted:
https://patchwork.kernel.org/project/netdevbpf/list/?series=3D425967

Regards,
Stefan.
