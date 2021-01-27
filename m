Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40D7305F2E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343502AbhA0PMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:12:07 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58494 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343585AbhA0PLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:11:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10REu6xc018082;
        Wed, 27 Jan 2021 07:10:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=8BpgRvwicqw/o9+tTy0zco0lgLaHcuK+HD5p6+r5EKs=;
 b=CXBpFIqQUOzYkAFvniH7WMjWhT4h5RVvksAf+xOjNAhtsVIvqKJJTnCCxVm2IBx66PDb
 gEah9elAxDAJXGa+ND3rSuHISKAyx5MvxTkaxYaCP0z/ebRLD/zbIEd39x/n6FJpnlZ3
 IdLPt3fuYUiy5aHv9lqL3733VjlXCpTckVyqieLv0a/9QM+Ow13XQ/hbBKe4UsU70QOS
 VxVNkL6FfOCPZzjNfRXX+yOPWT+7OChc0tXlzhFMXxRCPUNKMa4PohEqRqU4cvwH2Aqg
 z+Fh+4N8hT78YL8/5eVVQSbYAU8tEz2GNbEtPHZeA2PycwoIqZzjmJDzUIYQZBkdSnH1 Wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36b1xpha8c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:10:15 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 07:10:13 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 07:10:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 27 Jan 2021 07:10:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhP8FA6HqtpiYPg7P9KckDdmJLhzUpnXH0/5PGB+qdgTT/CY64CFXzPzSUSXUiplfJD+FfSW4SQZcPX9JmH95S/AJT/EjqEgwbahGHgz8lDFW4MV/b/b6GkhMG6hfn0O1zJI66grIM4qBO407SeqgH98jMa9Ug5CHJpXkhQXYgXrbYWuWrf6t9ChITUOT0h+04XMk5iF5t02mtz8DSMs9bpgjZdsw2rV3yaKzf3sLmdZpaCWeVGe7jsm0kCgoUke808/1mpG6BtCzaeEn5zlNzHHejmloR7RN+Zw4rz+50EPGXqTSsUkzAC02la01XFE0Z57gv9+sFeo3BxZ9b2PsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BpgRvwicqw/o9+tTy0zco0lgLaHcuK+HD5p6+r5EKs=;
 b=IvG6d/TkQeVa1tFlOwUiozUJV6DIWJjPxUCkVFe8WklinLDZWpRllinplYydQ8G5SVFmLUkPoOpoXhNBJkEprrJGDR+KStqUudluZqoAwe4akvL68Gjh1XCK0XmTYSMmMD//8xTnPm+A861+5mfrytH0S4ahQmJ7I4djuxptklKQCywRLc0OpJlhA3oPpZbxvQLnz3DVpc64gavDEJ36StxOJhh/uMXUrDfmA7gwvPqOEFW/t81Hp+mwy1nVmMZb5/H3tG5td4q+SKV8mrIKGhaICW0qVYfRW0dhROlLXlGLRaJp0oOsVzrKAXKeO4VMydc5f3Ur/Cu0+Bx+i2pOug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BpgRvwicqw/o9+tTy0zco0lgLaHcuK+HD5p6+r5EKs=;
 b=Q0LYqOiFe4YmG3Q4y7Xsh6VsAZ370pTlPZ31ESK0a4x/5NNhygV4DSeZw5s95RYXQEzsO0P5Dv79LEHmz5gI3BpyRac5NEIYT8ayjIuTAN07+zHI/ZomVnKXFq6dN8RLLAmpKMcz8JVYr5Jt4KsTfXOfDaFZOUsmYq4uaTneNCg=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1503.namprd18.prod.outlook.com (2603:10b6:300:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 15:10:11 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 15:10:11 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
 firmware check
Thread-Topic: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
 firmware check
Thread-Index: AQHW9KHjwS0UHLuva0e0y+cDZ3p/aKo7gciAgAAH8aCAAAcogIAAAiVw
Date:   Wed, 27 Jan 2021 15:10:11 +0000
Message-ID: <CO6PR18MB3873983229F0F664A0578A3DB0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-20-git-send-email-stefanc@marvell.com>
 <20210127140552.GM1551@shell.armlinux.org.uk>
 <CO6PR18MB3873034EAC12E956E6879967B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210127145955.GN1551@shell.armlinux.org.uk>
In-Reply-To: <20210127145955.GN1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07e2bd83-5764-45b0-7aee-08d8c2d5a47a
x-ms-traffictypediagnostic: MWHPR18MB1503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB15039818F564E2A0DCCE1F00B0BB9@MWHPR18MB1503.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vk4pJ9yi9KVdGrhIAUHlam8OrMgqDHPo9rcAhYzatdto/tkETHYEYK5qy3mWcJW7kjzgNyFMeWyu9KeMsJkU9VZpzIyCR0WgBMEtG0eZib/G9OY2ZcEl2bQ3KENqxO1EEfyyD4S1fpxS4UpuVyxFAqQ/oo0M/yva/UUpdMmc6OcH/I2nPh4ZMbECNWLNijbXhRrB3KwuU8FYTFZjWFKQgVyfptxlfGlHIsx1KzPZu0FZBkGKjNownZn6o3pPZTi4ErA0yBmVYdftBfzwimZZW8g7W1cO+0E6dc+ahL2DmetOtBwDbwK7YJA2wYSdUV0oAVWLlM5EEvsIK6G/SXOUXEasvnudHzIqvEGjWT4Q7AKmGbYuWTyd90Co/juYchkxBPKrheaiNhwFK1IBJ3j6pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(316002)(86362001)(6506007)(53546011)(6916009)(66556008)(186003)(66476007)(83380400001)(33656002)(4326008)(52536014)(26005)(8676002)(2906002)(7696005)(478600001)(5660300002)(66946007)(66446008)(71200400001)(8936002)(64756008)(54906003)(76116006)(9686003)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KPziBPgP5/NfnLS94Jvmcf+4n3qbxc611qcs3XNYBWQpczVZV4d5YnpFR0iB?=
 =?us-ascii?Q?efK3FxlP13SORcqE1CKWxoId6Htk0SymnlQ/uyxqDq13+Tp7iAwM9Mo+50Zn?=
 =?us-ascii?Q?NVSIzGGRyCJ3h28EykVR7y0/fr6T+7WSIvo1vO1layeK6U9GAACFDi3v419g?=
 =?us-ascii?Q?4H6qPvPJVXBwdpjKQ2TdP/bV+p5To71Zstn63FZ3MQoOuAcRLS94aKM70KZn?=
 =?us-ascii?Q?8Nr1+X6WBBhNXUiTZrKVwakhO35UinK+xDTYxCkMFpDtxIbrc262L55phikR?=
 =?us-ascii?Q?nHInisMoBOGBB5vuoxbG24C/IeW+Pyt7DBD79rZwJDmg/bQ6yayWlYgoe8Tz?=
 =?us-ascii?Q?iY86E/lLPf5EkSlSygKjSGEc+x2gXq/PzxujFGsxWDtagGSLKp2ESjMuD6V1?=
 =?us-ascii?Q?y7j/vSKDncVbUVdwvho77ZcRfnLNcas6vW16scYhnXqsniwvedJ7yZMfOEiR?=
 =?us-ascii?Q?AVKm9JvBV4X13rdQmJbsZ6FwJAk8dhg3rM4u/TOqDbcObOxCP4plx4oaQ77F?=
 =?us-ascii?Q?v912hgiK5P3R8I7wkLywmNySW23vI0+WhAKWxfR2B2oYzYXxmh7w+nENUbjj?=
 =?us-ascii?Q?WHXBuQLEMZGjfBolfew/6ueEsrpBzPy1Y2d1LVUkf7XzNzYesERCY+bSVBdK?=
 =?us-ascii?Q?h/ExEAMVnAih9HJzljJi1JQ7dw0y1ZEHxbHPIWZOxTt/zU8hjSE3RXjEq3pl?=
 =?us-ascii?Q?yhfSzM4SdnOrX6l0Wy3CmmwtzOfeqEH3rMeutaF/Ynmy3ASuJrkcrX9+/7qI?=
 =?us-ascii?Q?aoWyEKD1eArQT2DZiui7IJ3+6UKlrvsYoVct5D+mS8jQi9pupi2+ckd3zUb/?=
 =?us-ascii?Q?4Fa9eEToA8gQoqmB2C7cXlBIPbuKNxrI9jM0K7RTBmnXK70jkTZhwKa4S8oh?=
 =?us-ascii?Q?9b9QD74UdR5UDInr1HTJHmxOSIWbXZbJOdfy8x0ou1+XAZVJGl1JPL4+VxB8?=
 =?us-ascii?Q?UVRcBjdS/5sUHm+snbkMWQmY9ZR5DeCUGTNgJRGNpmklovrN/9P6IoOSxiEq?=
 =?us-ascii?Q?85w/0Yj3g17XbwCPRd5FuPnHOtrXt4MtHi031164PXMHgK7dZ9AlAXKdCgq5?=
 =?us-ascii?Q?qSdfyQNp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e2bd83-5764-45b0-7aee-08d8c2d5a47a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 15:10:11.5531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ppl8M1wfeYki2BHn8naOdOimsgNZoy7W1Qe43fJIvP2mEWUiuoWpT/77GvIV/unbnz4cm6x2aC5OeFJaDH2t4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1503
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Wednesday, January 27, 2021 5:00 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan
> Markman <ymarkman@marvell.com>; linux-kernel@vger.kernel.org;
> kuba@kernel.org; mw@semihalf.com; andrew@lunn.ch;
> atenart@kernel.org
> Subject: Re: [EXT] Re: [PATCH v4 net-next 19/19] net: mvpp2: add TX FC
> firmware check
>=20
> On Wed, Jan 27, 2021 at 02:37:34PM +0000, Stefan Chulski wrote:
> > Your mcbin-ss is A8K AX or A8K B0? On AX revisions we do not have FC
> support in firmware.
>=20
> How do I tell? I don't want to remove the heatsink, and I don't see anyth=
ing
> in MV-S111188-00E. I didn't grab a copy of the Errata before I accidental=
ly let
> me extranet access expire.

You can devmem 0xF2400240(Device ID Status Register).
#define A8040_B0_DEVICE_ID      0x8045
#define A8040_AX_DEVICE_ID      0x8040
#define A7040_B0_DEVICE_ID      0x7045
#define A7040_AX_DEVICE_ID      0x7040
#define A3900_A1_DEVICE_ID      0x6025
#define CN9130_DEVICE_ID        0x7025

Regards.
