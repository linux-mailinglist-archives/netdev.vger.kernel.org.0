Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D042B43BB94
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbhJZUdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:33:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22550 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231545AbhJZUdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:33:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QHlTjv014652;
        Tue, 26 Oct 2021 13:30:54 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bxfv8jjca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 13:30:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQctOUEWF/wq87I7ezqepwhJOyZQm9BAAM0j1KnCSytsEjPTAmGFojQOg9jQNtwIjEPfXTtuYZr1lzndFodFN4rTE46Y97SU/4eaC/xIdpL9qaY26DI4c22N0ZKzM9z70WIUYP27DegRQVev0wyYj5moHLgzWTZ2cBHSIaK3LP4DpfqzDMV3rBeuLXqZgZY+0fR28jBA/a3XM8Ri8D7gLoJjQPapMFNNitFtSaoZ3kmt2KryJ3GHYjamEN1WlBcY/3ZFmFeL5tWvLnQpCydLXnF89wwnboVSNlI6lHf5oJgPYNLCrd6ZsiDN8U3cYpwYl0pr5gIKbdXtyO17sqFclA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SiyF9q1pVwxt+AS7lG6Lgz8vdAlrOwSMeDQX9trLuU=;
 b=g9zPIEXlu2gxTdD8td6L3TCNmSoeB0iQ8/gTehpzL2zw+QGqfjwvVgM9G1wR/2HbhTl9U+JqpiyMu7Eej7SbM24u+R49sn4QMuCLpCTR+QtT0eDdgPGvrCTY2YwMqkAzNzx3FuDevCHbXEHJes4keFKrBSVkkk7W1of0/vbtgdT10NepB13WjlfRTMJBJJTNutkPSuErkAVVBGLwkJmy38O9XS3UVvn9NLjxOcxdj13IO38i/S3Lq7Gs7y/j8jBeYrazlL8kp/1GTNJtLBq5j2jxknasfDH3jmClOOw36iNMwrbmVpLjDirsoBmZmfedBiN/FOI9RvcK96q5lj761g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SiyF9q1pVwxt+AS7lG6Lgz8vdAlrOwSMeDQX9trLuU=;
 b=bDxP0nrqrccHXFCFBlPaB8+2fY0ZnCFrbn35GiUBE9gxdmGlsF2FrnivFM9cmCHm0eskdqIe8d5WGZrGLZEQgFSZxDF04fuipNZwovtdrH+9hcjc6d4n9uys+HwuiFsIp1hx3BCWQiEBqSZ1+czdhhx5JBWZy/2InLvQbJWub1o=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BY3PR18MB4545.namprd18.prod.outlook.com (2603:10b6:a03:3b4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 20:30:34 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::547b:90a7:d7be:94c7]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::547b:90a7:d7be:94c7%6]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 20:30:34 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Topic: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Index: AQHXyqDh2TAr+aaEAka5b0KFvfxjIavltFOAgAAE/3A=
Date:   Tue, 26 Oct 2021 20:30:34 +0000
Message-ID: <BY3PR18MB461222692845B97A5624E88DAB849@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20211026193717.2657-1-manishc@marvell.com>
 <YXhfe1+HMyPJECJ3@kroah.com>
In-Reply-To: <YXhfe1+HMyPJECJ3@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17bd5c5b-75a8-4021-b188-08d998bf767b
x-ms-traffictypediagnostic: BY3PR18MB4545:
x-microsoft-antispam-prvs: <BY3PR18MB4545A40F6A6D26A68C451921AB849@BY3PR18MB4545.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g43fnVr0la0HnjCp80vP/nB8g+I7iI8iOgH1dGRSHdMcw1GxLVKF/hoALA7fmtNqrel/1UPjxHKcLA6iq5lMLyPstbhzbGI95j1AhkY5madx+a+/1j8WkV6qzp80wnro9V3na5yRIcbmhA3LMGd4nr30nOF3TE/QS0ZPK/RJAE0mfRXgSSL+PtREozlI/KGiD6Gu2Qh3q3aWT0sfUrvdL1aoTaYrRcYePVePUlvGO3LQJ0Jdv9ETUgmBTllr+9bCy+jrFH0h2+wnN8AdSv6WfAeGUAQwFAa9tLH2q8Gl5NFaLZkS2i6t95WvfvgV8ncY56n/wyfWxDkHYdeP+BnoETxQieiuOXlcde5z6qBT/n5m7leUCEw6n9ufHgFhTOQ6IcFbp71egw5Av1rmjiYZEs6j7JB73AbIS1Dl5BRM8BWDPucfU6XG/WRxbpDtnhF83W1F+Mv5a0YqLbu7vgTICeCUeS6deAQWaUaYrFm9MFLhPUAx4g1A3geXhJYL61m1mRzGQnuBb6TDoH79PQYsqbUPr2zHNEjBrKN28Vxsqtjci9K0dM6qcdZoQrDWm3DL6o1waKwzHMLbFvxXhTRXZktc6Vl1Fpik7dAvXzlMhrOEyAC8ZthKuX8r1I2Y32p3rwsy/BMlhwyyhlCLLEd8mpRw8QB627jfIyTQpSIaFd2AMxP/0fumawHd5CwIBNrazR0rsE1UlZpnbbwGwAxqLeoswbqu+mjsOOYvg3wuhNmIyTg8WudIHQq5MfcQM1AYm1eabmszb3fpDy6pXcDoUYZnYUkr/LvygwxMEkwEFpo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(53546011)(54906003)(122000001)(9686003)(38100700002)(8676002)(6916009)(33656002)(83380400001)(66446008)(316002)(2906002)(5660300002)(6506007)(38070700005)(52536014)(186003)(71200400001)(7696005)(66476007)(508600001)(55016002)(966005)(8936002)(4326008)(66946007)(76116006)(64756008)(86362001)(19627235002)(66556008)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/4IQZ5U4L1WOCU33R0jlVYocV8HnAv0I1Xeq+63C6AxQQ2GUyKECASx2+3qV?=
 =?us-ascii?Q?d1kRUzEPTTUW+1QTN0PsCFNIGg+T6AXt39RcoJOKBRd00JSa5gVEp8VOXZ+a?=
 =?us-ascii?Q?H5LxBtMzsm9mV00N1KGZ0QAQhnvLDNQcjxllHqICWK8AYT6+L+TivfREmtsD?=
 =?us-ascii?Q?QY+FBiuDiLADXpouONC+nynI379j72Yrdi8dd9x9hTUVUQrePBVd088nEXKS?=
 =?us-ascii?Q?RZHAeVLlmmQFkADAUmtrZZa0txyBDoJQQEWdA3d094KD4KeSzzMvropymn5E?=
 =?us-ascii?Q?Dnc5n8mg+nMB03Nxsn4xJ94+qldmP8+GS/mxX/cfS6YEuSWhAq1Wl1FdkZ0K?=
 =?us-ascii?Q?5QHlMKP3IGsFmi7U9HSqLHMTAhikX0mz5c4QySw373Ou8K6B8SVX91KRCZik?=
 =?us-ascii?Q?gxfNjcH9NyWE71AowAmq3/0eg/G72aVG/G44JJuvsgSMA+x/RIz6tA8NPba3?=
 =?us-ascii?Q?31nnfelhb2GH67EiEnzIN5l7kCmgm1wyubjD9TEWfouQF2dCp0RvtszDuR0K?=
 =?us-ascii?Q?jJYCUsTqtVOhrYkDSQPFdyiqDNTJkapoyWSyDRLzHA4CTyDuwX796+E5gESU?=
 =?us-ascii?Q?YlB3wDzmhK3cCZYoBvLY3KqheZDhZbghjA4PFT2rT10xh97ZbGaa0C/JszsS?=
 =?us-ascii?Q?23FTor9Pfv3osrDks5rTIRzSVgzsZywGey9PckpZBi762fpiBKeB8WIWUQ4m?=
 =?us-ascii?Q?EZBLZeq5WJOOUUhD7XnKsu2Ovz9yCSBW2794wxifAL0Lj78Q9Jcnoz+9NjwV?=
 =?us-ascii?Q?37Z8HOyaMAR9cuwdSnAmvS++A9UO4zR5yVjow7TbrPQDmDps9cx/WtE9ddOS?=
 =?us-ascii?Q?s5M2vJLMKj6sQj2U6lcgDTdWo+x8cIgSmJH3ZkstRrjavq71GstyG8yB55PJ?=
 =?us-ascii?Q?7F+66Veqma4KoKrQ64V3anC3gkQdfn5ftSusCDHYEOwyFapkm7ugO+YHA5OJ?=
 =?us-ascii?Q?R+d1by2xuprx5EwAFMhvbarhXdhxHOmIzP+3jbOB85UBsGXaQoe1wD38B7au?=
 =?us-ascii?Q?c2DMuJv7KqYjp8modM0KKL0Q65tZznNbZq8tF5m48XYpsgZ6C9nKLtKkHt3x?=
 =?us-ascii?Q?sgL3QeAGQOFaVP+8KWL9dar73OTH7xVLZ9ckGmfjWMxqvrD74HB8qeqkKgs5?=
 =?us-ascii?Q?3iIOCw8jX63bNwvRjMGAE6zuslIbJ50sCk8f1V5LBd+0EOE/YYEeLPWnATL3?=
 =?us-ascii?Q?k3UFitw8A/0neaF+xIgCjm0R6v7VL7lhD1QgSX+V+nP800Ph1cHuX+Qw8lkW?=
 =?us-ascii?Q?7oHmgx2DuhEUtGSf3cOVSfE9sEy5qA60Jc/P/dfQDgyBkFvYMUxM68B+mTro?=
 =?us-ascii?Q?MKr4RqQI2HMzfPKnsVQO4jWB8kwAyaNO0to5Eucb+QU4IG8Zh7tFfaro164N?=
 =?us-ascii?Q?wjdeIS25v8udEpZi9/scdwKCR1lTImaVCa/jPPx6ppwm/d/RYAaxWYmE/v2G?=
 =?us-ascii?Q?gKjBjf4RAyxETZZn89vPWPOVPWQPvd01MzzREqtZBQtsTPxC0VVdgUpoCqwV?=
 =?us-ascii?Q?71CwYukBPNdtq7yLjKGL3MTaRL6uIHOysEQB9bNJ595/1HVuM4pkhgwSe9q4?=
 =?us-ascii?Q?YOf7XQujpnCbwhwaDMeMIZKIkferQTMWwfvPLNS0y+F65/7btZTZOVyxPdNU?=
 =?us-ascii?Q?ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bd5c5b-75a8-4021-b188-08d998bf767b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 20:30:34.1946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UrvI3Ov1UyBjcVUmaPduCa9PslVeZVBpVUi8BorCWlNCCF43bz8O8lGShbE9RnKthFv7kdXdDCK//Jym7ls46A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4545
X-Proofpoint-GUID: jQCU8YeowW8NIdjeR4AAVa13YgRk7p_I
X-Proofpoint-ORIG-GUID: jQCU8YeowW8NIdjeR4AAVa13YgRk7p_I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, October 27, 2021 1:35 AM
> To: Manish Chopra <manishc@marvell.com>
> Cc: kuba@kernel.org; netdev@vger.kernel.org; stable@vger.kernel.org; Arie=
l
> Elior <aelior@marvell.com>; Sudarsana Reddy Kalluru <skalluru@marvell.com=
>;
> malin1024@gmail.com; Shai Malin <smalin@marvell.com>; Omkar Kulkarni
> <okulkarni@marvell.com>; Nilesh Javali <njavali@marvell.com>; GR-everest-
> linux-l2@marvell.com
> Subject: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Oct 26, 2021 at 12:37:16PM -0700, Manish Chopra wrote:
> > Commit 0050dcf3e848 ("bnx2x: Add FW 7.13.20.0") added a new .bin
> > firmware file to linux-firmware.git tree. This new firmware addresses
> > few important issues and enhancements as mentioned below -
> >
> > - Support direct invalidation of FP HSI Ver per function ID, required f=
or
> >   invalidating FP HSI Ver prior to each VF start, as there is no VF
> > start
> > - BRB hardware block parity error detection support for the driver
> > - Fix the FCOE underrun flow
> > - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> >
> > This patch incorporates this new firmware 7.13.20.0 in bnx2x driver.
> >
> > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
>=20
>=20
> <formletter>
>=20
> This is not the correct way to submit patches for inclusion in the stable=
 kernel
> tree.  Please read:
>     https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__www.kernel.org_doc_html_latest_process_stable-2Dkernel-
> 2Drules.html&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DbMTgx2X48QVXyXO
> EL8ALyI4dsWoR-m74c5n3d-
> ruJI8&m=3Dty09KAp_t8LlTicBDOtEO7pxmxWrH0D0JgMAieGU5RA&s=3D2fheQ69qq4l
> tmmFzYYyaQXTj7naqE87MTdo3bL9sJYY&e=3D
> for how to do this properly.
>=20
> </formletter>

Hello Greg,

This patch set is mainly meant for net-next.git, can you please tell about =
the issue more specifically ?
Do you mean that I should not have Cced stable here ? is that the problem ?

Thanks,
Manish
