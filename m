Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853B031286C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 00:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBGXjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 18:39:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64070 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229522AbhBGXjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 18:39:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117Na9xG031945;
        Sun, 7 Feb 2021 15:38:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=LrRPHKtn68E5l4Jnw4/Vc+yaMoXcqXAcaFSi9hbxKVw=;
 b=jEhOwtMj13x+5eBZBaeEVq+RTvI3KIds+y/roQHBSDXX53zG1ULry7RvTQXiayhCW3EX
 Vz1YV2v9OHnFWjW2p6yCSlFwUm+aD4Ockmsb3ZGtVFeptcR/ChczVw0B8xXEea6AI+Bz
 TjKmDgk+TlrGIpVC6trUWZ9Kd106BtU6dZ5ZIdf/im8CDITgJ92lEhFZT+wNa+jgzCgX
 bub1fvM3dG2mOMEusX+XuMc/hyV2l3YwMDTDOtEdwt+KvR/PJ3rLVdPIy6JkLHH8zVEV
 dM/kcQNgkilqViMdruMD211WfazZ/1e1ef5rR+qswxGRQdeoLsR1oBcLNvhbb6wbCsSX Cw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq2tmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 15:38:40 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 15:38:38 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 15:38:38 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.51) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 15:38:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cp1vV7aggIQcd1H0DUDeoTKBxwyhMU9XRIppT1P8BgwVbDcKUdEX1sxJjLxSHzYflGpELZnKTg/L1S8WLV5P1Bfv4H/FjhHAxaKg4TtfU7SwFkc37EdcIO8xNzsH1OPNQdVduGlIETIkseqMrWXYDNVPYqsZUtUzA+TjMlTNDf1Uy92ZONcXfrSC2QEaadvPk9j7Gu0Bwldhurf6QNrUV8qpXQ6+Uz/8VAkrQiZ/UcNOKkDKWmADGtB7HE97A3eCRAFgx3RtuAv8yBLd8Bl5OtV+gLf2PhkA2okLN7gWaVbJTNbyl80fyhnEBsAG9KSwJFmt7ZpYZdCUAnXzNmvqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrRPHKtn68E5l4Jnw4/Vc+yaMoXcqXAcaFSi9hbxKVw=;
 b=ZRWehqwWHTrMoHqI8GmiyBUAbue7wo53UmSPU/7kiSF++6KzHyl5gthCQ1/71y1j01Bx/Hj+qGalQ8Xrd0o5kibm7LKQ7tq5ZEsS5aWfsW22VprspY9RDOPwxyhXHntiia/zV9+8oHT+ZMIz0hNSwqqE51K08vMuqqD5IWoxCt589M0iqlwOF5W8YI34qfgSzgEUE3z1Y+lDA8YXMZdnELAwlz5nbgyb9qsvTIRzN4g8YGRLK0Ti0Jy86wyadSNeSPBJvghOwPgZ52rvNYuL9jxcQLjkz/3BQmCrGRxcsA/EFflHmgunZFjRn05eaefWSNOYk4ulvzdpj0DrIkZ9UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrRPHKtn68E5l4Jnw4/Vc+yaMoXcqXAcaFSi9hbxKVw=;
 b=NdDMSUFGbq/44/KqhLfb9ROZr8Zig7AQpVWMDsHPsh3CH7wvDyAOVlc6AxNjq3m8hmXAtpv9tDa+xCjapvkg5lK4azhKBhV+OOj87Msgd7jupqEcXt94T57+WIZBoOaKHH4jXq+8lDxqSeTZaD+IXL9wycNGsOuPbb7SvqupQw4=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1567.namprd18.prod.outlook.com (2603:10b6:300:d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Sun, 7 Feb
 2021 23:38:36 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 23:38:35 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v9 net-next 01/15] doc: marvell: add CM3 address
 space and PPv2.3 description
Thread-Topic: [EXT] Re: [PATCH v9 net-next 01/15] doc: marvell: add CM3
 address space and PPv2.3 description
Thread-Index: AQHW/YCVEM/a7qVSBEShcBbeU0Km5qpNNcmAgAAjpAA=
Date:   Sun, 7 Feb 2021 23:38:35 +0000
Message-ID: <CO6PR18MB3873A4AB04F20661ED3FDF04B0B09@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1612723137-18045-1-git-send-email-stefanc@marvell.com>
 <1612723137-18045-2-git-send-email-stefanc@marvell.com>
 <YCBb2xWGXjNqBWPl@lunn.ch>
In-Reply-To: <YCBb2xWGXjNqBWPl@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [212.199.69.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c04cc054-76b4-4791-dedc-08d8cbc17d13
x-ms-traffictypediagnostic: MWHPR18MB1567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1567EBED3B8EFA9530D119FEB0B09@MWHPR18MB1567.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /1qJSQwWDTZ8W0lJFCZ83//01w7hnydxwgv4DAZBBQ778IkTdGbWvoLS3PRRg42rFtaWZGg0xe9HLxOuYwq1/8mpKoydnxvDRUeVbGRWIFPwHU/2e6KnkLrmYRH1rLwtV8m7cZ6UfPHb4psb1GCC0BCK/6xVw105am+aJwO00HAzAMMe8vIvo6T3aMZXvFvu1CAPfeJS7/i5nYkiDOfHCo0Uj8gJeHDvMc+DJO727bORvsFLByR+z0h8F8KwVHcZy9KvSIIht01r0IajrXL0bluL/akJy4fOAoqrYb+mykaZPT1TxC/l5ZK+nd7sWNfpUllvhpXwi4t+/E7C8exdqybXMhiOd2ArUHGiBdH2qMV1MhKBBzYibPxQ0C1xoPfYqdrQ15iwKIag2CKCgGQYeGKoRi509yNgCbWiqk0oXSLKjCtr3Z8bWLoK019cRKxBd6T28J5txcxyrNHvyXibg/SsAz7QIZMs8pHqlH9g1t1g28Hp/s7hCX9oB4Z1tgCjsMvZ/SdydJdCIyJHoniLdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(346002)(136003)(39850400004)(8936002)(55016002)(26005)(6506007)(66556008)(64756008)(66476007)(66446008)(4326008)(5660300002)(71200400001)(7696005)(86362001)(52536014)(54906003)(316002)(6916009)(7416002)(66946007)(2906002)(8676002)(478600001)(9686003)(33656002)(4744005)(76116006)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7qm9WyXbX42iTe/eGKPSTq4Zv2mpaYWeLQ6A1h9Hfe+Umi9XFHMpo/RTy5U5?=
 =?us-ascii?Q?uSLiLK3e33zGTZ0UO26ruR1/UBdYNgYOjjJsI2N58LPf1IxQohqCdr/QXFnr?=
 =?us-ascii?Q?2dRfKzCLkjMpNi7hzSkzTk6X+Gbat2pI6OHS/v6IV/qJeOE5rgDzeQ5jUd+T?=
 =?us-ascii?Q?DLjb1d+VJpMxvSW78tAkY4iZHsvgbF0ERjoXHtqwfsd98pr4etCNqgTlcTU6?=
 =?us-ascii?Q?2Llva03v+ch6fGTnNxzZltdBgKz8aeDnNajxXf+BqSw4oJGUkJT29BQY5HhD?=
 =?us-ascii?Q?GLX+93xPeuAKW+GvSJD3g8asruoefndxgLKLqCSwesK4sjPFfX96eThfGkw9?=
 =?us-ascii?Q?LocedmngzNSibG2T8SsSSPm/H0dQMnHYTTeX7Fs4YgEysYuyi5MwiURACo9d?=
 =?us-ascii?Q?31ukyX7cTnJ5UtUP4qYMBFuNI/FkcZxU0RMYmNV9VVAeytuRDJVy/a5ZJGgm?=
 =?us-ascii?Q?QaFOSRILGi0ij0QYFprMcXr1kXtnpr+EZz80Z6PiMr6dFJr+GlFe563WnNIf?=
 =?us-ascii?Q?j8j5FocOeaUE0O+wQAlvxFgawqqp/P73dSoi4apnjqrFBcG5urOzXNepGzJ7?=
 =?us-ascii?Q?SlonksURgfJnghn5AQuT4qCx1NPfZ3FPgkCqLWajoAPbqOvkZNWfbA3eutDK?=
 =?us-ascii?Q?BIBTun7zITuG0VzOyS7wGvVf1pTGFk6fb8suRIJnwrl5f01L/BwZhHNrMQrx?=
 =?us-ascii?Q?v6C0tGoUrwcVn+t1xXG9TKt+WamuPH2yLgB+bvIowhZiJX1neUPY71KLuhXW?=
 =?us-ascii?Q?9unmyJpmpJD7cbjbSf4/HIZa74gv4DhGzHa75RZozyl8jAaHVfxmx3rqRWO9?=
 =?us-ascii?Q?HAFbZvCGYzWO2jvM5+YW8/8Ajz33AALyGaaVgphoTYqFWSX6rDvfh+D6HA+9?=
 =?us-ascii?Q?MOM3wVg5BoeiLjqZKyUL1ppvXMy5NSste8UTaVa2Rz0dTNKih9+Y4CKpxeMX?=
 =?us-ascii?Q?vrgRKz/C3osAbvUI/QAINcskPIKPZgBeU1Qpjr+yRQmpxtWOa/IilA2GSaI4?=
 =?us-ascii?Q?08lzPgzQaqJ/iCB6+l/j5Nl83o455NQZaN6sRW7IGhQJ74aC+/BdGYEInJhT?=
 =?us-ascii?Q?VjC0N3B4elSIc5MQoKizcrAO484ksxPAc3h9dZ0UVty+Z/X8lKYbStKqELPu?=
 =?us-ascii?Q?8vU8s68hEL5KdeP8MYLK6FifLJ2jES72OA7fHrbW+Q5mCMxMBJ3VQLwUqPFI?=
 =?us-ascii?Q?KA4FnZrd+w1td7GNdJGNUq4y/doHqQucQ1QBwEjVD16+N2Id9mNWzps30wXh?=
 =?us-ascii?Q?UGNaGO8XP5yJip9+lZeS/LxzimhGF7ZUabZDYq0jS8dKGZXH11dATwvurQMi?=
 =?us-ascii?Q?bQw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c04cc054-76b4-4791-dedc-08d8cbc17d13
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 23:38:35.7349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OlF/+YotM2TyC2g9/Zvf+SCrIqNEfWVdwUN+YehXSGH8cjL9bYApwperh8DxmaHHvP67McK48WzvDQP2KA2/aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1567
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_13:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -12,7 +13,7 @@ Required properties:
> >  	- common controller registers
> >  	- LMS registers
> >  	- one register area per Ethernet port
> > -  For "marvell,armada-7k-pp2", must contain the following register
> > +  For "marvell,armada-7k-pp2" used by 7K/8K and CN913X, must contain
> > + the following register
> >    sets:
> >  	- packet processor registers
> >  	- networking interfaces registers
>=20
> Hi Stefan
>=20
> Shouldn't there be an entry here describing what the third register set i=
s?

Would add it in next patchset.

Thanks,
Stefan.
