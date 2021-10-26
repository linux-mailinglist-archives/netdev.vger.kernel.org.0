Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F323343AF62
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhJZJsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:48:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5236 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230174AbhJZJss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:48:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q5oD4b029442;
        Tue, 26 Oct 2021 02:46:24 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bx4drthfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 02:46:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hT4x7pERTKmgpgP3kdWGGucbA0cRUfZLDAAjxuacpQ4zqO7Trmb0Y1CULJS1A6OqBvj3+61UXJC9T0TguXwbv5/rhKxAWlw4JHkXYCjqndBziJX7SbkfRrZgY72bKjDwpv1szbEzt2YxkDzEgmXTwYt99kKoKbQNjPFSRWCqB3VDm3QWF9+6+h2srgiRp054B736gjag0i9g0gSRmoOxlMeArCY/CxfeYzdUmQJNm0dk5bpVvlIfnckk4KJNx+Sutmlp9Od09AEFRTHN5+nd/gCLus1lReTbfAf7WkyXiRXsAEYNhhtVAFIwn2VQEhxzvwdbOuRmYofZlhi3s2jb7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQ8hyivBiVHlhQR9To7XFoPnolPYjjHSz8f1um3feBc=;
 b=ev+vv2NW1dLcUJ0sKwNHUPvms5xRqolP4vnwyxthKMv0ilXns+lgLl59rhJaW40nKcH4pCsX0TmV762eLk8r/8e8h6uvLjihfoJVYR3HIf7iw+YOkHxVthjeMejLmwRrBxHqJvD2VIv37EmmIK3t6D26hn/9dvtTs68Fmg4aufFoS4HdplWfxPVQkhZAE96WDOfC88I9sV4EMjA9vY03gKGT9tpiJaZjsdkH+vUvljSzlbt7ptR963pVx8Ze+aTFUwIPWW4AKgOe9v0q5XQigp22EAFGSHizDgkOP/T+TDjCvP9igRJsNxPpV3WFXP79gKdIL/jmCgw52FymI1s0zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQ8hyivBiVHlhQR9To7XFoPnolPYjjHSz8f1um3feBc=;
 b=tyT+tL/+qadIMPu07bbj6KuN201KtRUJErJV7LIR3RfpvHDAoDQrkkL+/lWkUza0r1GCdo3pTQb9t4cUzA6QBiDkzS/LOtybacG6dra50wQTngge8ou0JlG9wEUycJl9kzUSAOzvMPsUjegT5Mwv3DM910VrhGovWMIBrxyeTFg=
Received: from CY4PR1801MB1880.namprd18.prod.outlook.com
 (2603:10b6:910:7a::19) by CY4PR18MB1111.namprd18.prod.outlook.com
 (2603:10b6:903:ab::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:46:22 +0000
Received: from CY4PR1801MB1880.namprd18.prod.outlook.com
 ([fe80::b4d9:80d0:2699:91c]) by CY4PR1801MB1880.namprd18.prod.outlook.com
 ([fe80::b4d9:80d0:2699:91c%5]) with mapi id 15.20.4628.023; Tue, 26 Oct 2021
 09:46:22 +0000
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Subject: RE: [EXT] Re: [net PATCH 2/2] octeontx2-af: Display all enabled PF VF
 rsrc_alloc entries.
Thread-Topic: [EXT] Re: [net PATCH 2/2] octeontx2-af: Display all enabled PF
 VF rsrc_alloc entries.
Thread-Index: AQHXydK7NCPOoIP/2EWYtISleysYsqvkeJUAgACQMnA=
Date:   Tue, 26 Oct 2021 09:46:21 +0000
Message-ID: <CY4PR1801MB18806010B68EA7EAA5FF858E8A849@CY4PR1801MB1880.namprd18.prod.outlook.com>
References: <20211025190045.7462-1-rsaladi2@marvell.com>
        <20211025190045.7462-3-rsaladi2@marvell.com>
 <20211025180924.4e072ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025180924.4e072ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f86028d-c53b-4442-ac9e-08d9986577e2
x-ms-traffictypediagnostic: CY4PR18MB1111:
x-microsoft-antispam-prvs: <CY4PR18MB11116A204373CC19C826C2728A849@CY4PR18MB1111.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mvQEkwbGKhN6/6QfBEkGN4ITPQAqb/bfQfXBWTo4e6szt5oVzgiSH5NwnpCJJnGF4Y1DjmKrhc+ECn9j4gmNFvsKxkdnqnBOYOlgr81J2qGm+tuq0kDz7j7zBz2XmmLfudNPajiTsc7UYNthPDfJ0JYDlZ3Yc/v6KhJViSYpBCXfdvZY7VLAJwfCyQsNWJNA3/UyaqNyn+/3jC3+IC0s/6uecnzqTkd7goDW2z33MHVKSq8Lz+QEToYos2iqkt1n9RFKv2kJPyUHRRaXkMdPQs04xrbZafZFir1aQsKpV86Ze9q4YnR0MgOiI276dKybM4AZaXr3xCUa4xGVq9CkJdjUcT14gIA2oEtRQzuAaXHA7raVrARz9P1aybxr8alH/6taamB1OurS5/28eHVCDxVkAP0vBZlfEyxBkDauv7slbc76Fw3fHSQtc8ubirJO5wU+RaN6T/Gr99rPJoMp1+QtlIX+uQMZFCKMfJZmgstmkbSPf+8RfdhtEQIugKhDx9wWp325dmjTLn7/w7VHCzzczCkajEqXyzJoNGNvcmNbD0XMH+1vQjU87L73vSOW83wl+peFOAsUgaiAh6BphST0nrb/Y5ezVwbpPhh6JMe+ALaIrxz87C44aKFq7TGG1OhV5Lx0MlEB42oXIx+n0vjLeMMLIJKWJwSTe6FldOQfewNJoioqwqLQIYTDNydl0YPga0to7pL4kf5m3fjlRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1880.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(66556008)(6916009)(66446008)(71200400001)(26005)(33656002)(7696005)(2906002)(5660300002)(76116006)(66946007)(64756008)(86362001)(66476007)(38070700005)(52536014)(4326008)(186003)(122000001)(508600001)(83380400001)(9686003)(6506007)(8936002)(53546011)(4744005)(8676002)(55016002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n8H5tFM+UztWFfj8hj5sp8qHvnAlmxpH3Xonm4I0mXby5i3pQDoSRVptO7U2?=
 =?us-ascii?Q?O1erLVwfntDxYJD8VR/HstIcqqg6LOCnjXR9Hf0gTiKMFg41DXgSg3n71ljQ?=
 =?us-ascii?Q?5stc1W2TmMfq/eBXaYF3LtH98uqnMbdbf7elNJY62ejnPhLvND004m6xnvqD?=
 =?us-ascii?Q?nr2tXCAlWPZmLepep1Tx76uouYbwOY2mZWJDrliyZrS+pwTKLxdHU8jG+dNT?=
 =?us-ascii?Q?P/K720V+vi7/5/K0BpiFozBI7o06Fhlf1WAA/HukMQl51pX9Ba/nxDeV85FY?=
 =?us-ascii?Q?ny1kZgDRb3ecJ/QboGV7uttWaKcd2vgGpdqJZjms3VSYTwqtfuD73CPm8Dm5?=
 =?us-ascii?Q?hxEvCy715MFfE9a7OcqPn6wrtlfAsez8ZPMUNh+2esZh1UIwQL7Sz3+1Ut0I?=
 =?us-ascii?Q?x/eK27cfoP6l/HEqGekrh6PN5Qjk/Fl5/68bb9Yp245cbb+wTl9h8uht4jF3?=
 =?us-ascii?Q?/zxDwOIDMVvp6i1bYNPK+gmkfn/SRt9WNcsyoUJuDSS+53r+X8yEjjBtwg2G?=
 =?us-ascii?Q?0ls5/OsRzKFFOxeL4n1Ah7VJpvkzBJckzl7+ta+NJ8PEbH57yy+wwrVTn22/?=
 =?us-ascii?Q?eqAhjFb5c6zoc7etOR5pVNHPxtnR4PoF+CuliCr4btOyJeLLHcD2s+ORNmBa?=
 =?us-ascii?Q?bMFXj4Az3w4B+VXWkxEFbTwMyqO+ZlPSDxWiONiocXp49a1edhLPufKIpHHt?=
 =?us-ascii?Q?1cNUBqznnR00QYsbF0OvxknlqNU7PivnBGq0qJ3rwW0UeIb6ZAIprOqKYezl?=
 =?us-ascii?Q?lqsb0P0/KgIUF7n3C9dCsFXax2jYNQF8nBkj/BHeSfO+5lbO41PKuVe+qca8?=
 =?us-ascii?Q?3Wcn/nBuBmYxfflavLRnjtMtsq1dcu0RMnlB0O6o7lpuuMC2ldmINEhXGyDh?=
 =?us-ascii?Q?PvwA7DT1ENDg8EBfcpfBBbon+h4BPm9RwsD2tHVHlMvGsgdkVeFOBGrWnuqW?=
 =?us-ascii?Q?FH1B8BsJD0S20deBz1BZD60fmQzX8TCPZVGdHEJbAkGYCCiKox/ATe8gPXvo?=
 =?us-ascii?Q?tFbUaDcn9PsyyWrz6i/r6Gf73nr35CsPKm4gfQBomtKdwaCvIMj9nXk1FWDh?=
 =?us-ascii?Q?pw8Y3M3psyX1bEOAJ5XE5xoeZ0QjtXrIn8nJyx6Ro7yMarBb8XZW6i33WH0t?=
 =?us-ascii?Q?wDjVg1pEimfnteanXxTvsDqfazVnqzpOJfw9cpzQz9cfEfInx++I15kXqc/e?=
 =?us-ascii?Q?kvl0TFprXG28vBAywTgz3JTPFm2b+Hv4+1KxbIocRnrtRVXBxUTV0ra6x1v3?=
 =?us-ascii?Q?7rlo/n9DXK4nCouWILOyXavqcaMU6kF/G71B3LnzHoCVDTrzxAomBOiuJytj?=
 =?us-ascii?Q?iGNz3Nfs8HVBZA3OMZcPe21leHe8c7NYBLXvOjPBa2ugRDY53ij55YLu+2bN?=
 =?us-ascii?Q?KpZG9GeNG2O3m6NwHk41SSo0wgiOcmFjTMO0jCha7AkULyskqF9nCOMPeb80?=
 =?us-ascii?Q?OVjzv7qOmv39C0Ijzmu1dlfKhDCxQQXUa272GdyIYE/qfk9xGzGZV1yRXLGc?=
 =?us-ascii?Q?1Z1peYFNYzA2axKbbQjkH5eD3PH8880Y7VoxF8rZj2cpVVi9CRu8+ShFnM99?=
 =?us-ascii?Q?MPMR40Ill8scZHi4iopPt1B9ittkEbAt2uI3wk5UHmRtDxN3bcVPul0TG064?=
 =?us-ascii?Q?Fw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1880.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f86028d-c53b-4442-ac9e-08d9986577e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 09:46:21.7600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QF9LGkWwxPU2a564BQqIGsH1wbXdFEV/ysDQF3P9/7vzIvvkez4cfuByHILz+qGck4PvqqNm9VwGzvM/xILigA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1111
X-Proofpoint-ORIG-GUID: nLvHBT9QB2fkEdZ1PtQVEpl7dRbOYs8V
X-Proofpoint-GUID: nLvHBT9QB2fkEdZ1PtQVEpl7dRbOYs8V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Please see inline.

Thanks,
Rakesh.

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Tuesday, October 26, 2021 6:39 AM
To: Rakesh Babu Saladi <rsaladi2@marvell.com>
Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.o=
rg; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Geethasowjanya Akula <gak=
ula@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Hariprasa=
d Kelam <hkelam@marvell.com>; Nithin Kumar Dabilpuram <ndabilpuram@marvell.=
com>; Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Subject: [EXT] Re: [net PATCH 2/2] octeontx2-af: Display all enabled PF VF =
rsrc_alloc entries.

External Email

----------------------------------------------------------------------
On Tue, 26 Oct 2021 00:30:45 +0530 Rakesh Babu wrote:
> Fixes: f7884097141b ("octeontx2-af: Formatting debugfs entry
> rsrc_alloc.")
> Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning
> status")

Fixes tag should not be line wrapped. Please fix.
Rakesh > ACK. I'll address this in v2.=20
