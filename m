Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9011343AF5F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhJZJry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:47:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60512 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233527AbhJZJrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:47:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q5tmeJ012639;
        Tue, 26 Oct 2021 02:45:26 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bx4dx2bvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 02:45:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lME0SoB42Kmcvd5+7V3O/EV7/5KB8lmA+TZE0CsQIQSvi+WGi4EKH1SgAMN6e60ZmCHKeZvFt1HaHVPdCG1/ZbST30yTCfK3XHxEAEEabwua7UIPTuAz4xJ6UYm3e96mkH9WnvmREEBylp0QUan6TFarnpq/Lza4+9TrMPtd1kLKbvpeZkcJA70SumMqILGtpe26dTVHamrK5xnBUKDNK4kV5cYLTi5pr0Ghukc3MtMGUZGNlFeCgsFTzwXh0LpZG+O2i6AFbLNGD8TKotqYD9aPlgPaS+xdYFB+S22B0brZxn9S7gID4ml6fz6xNfjJhGG9D91qaxPqSYCaB2npQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xgs+WesIzshZPOMWsfkx3mXunTOpwjtaP6NsiIgPJkA=;
 b=Ek27zkyI4wACQ2D2TfClXIhuLi1NajDDan0bOd39NsT8+RkRwtY26BYvZXNFvwOJ49xLRjzuABT7ekqbYVeNmarKdw6l0lFRCf7hyBTxcad1F4TkCumi676wXTxwhnBvb/porh95CPs94TWu1oSfLlkTWdPDfyaj3/i5ujTH7vNuRfb96mosH+jwukfAA1s0ITY5s33nrw+yT5kYTyVxaZBMwxzLrukfGWY+rbdMXRkozmnHhvJ2avawGeIF0BiQO93O3ekMGHXDiE78SpWaNImHEDR3DZXeX+G/jbTMe8HkWkrH6iyfG+2iUVXEGs8HdPt2fi5Exa1EUcKVrJIEnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xgs+WesIzshZPOMWsfkx3mXunTOpwjtaP6NsiIgPJkA=;
 b=mC3IcyxF+k4NFcsDQfZukF14dAvcg0W5UXIvVrmdFRtSvEnVPNHTvltyhw6M+kDMBmeS6/ngmi3mkPG+9F9yaJJCWpCk58rdRD21F79UkR25rMqhG8TRp9+5jM6aE+Iw30LVVW7zKXWGiNU7mIhCRr7YCnhlAcgGvyABO8VVyiQ=
Received: from CY4PR1801MB1880.namprd18.prod.outlook.com
 (2603:10b6:910:7a::19) by CY4PR18MB1111.namprd18.prod.outlook.com
 (2603:10b6:903:ab::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:45:24 +0000
Received: from CY4PR1801MB1880.namprd18.prod.outlook.com
 ([fe80::b4d9:80d0:2699:91c]) by CY4PR1801MB1880.namprd18.prod.outlook.com
 ([fe80::b4d9:80d0:2699:91c%5]) with mapi id 15.20.4628.023; Tue, 26 Oct 2021
 09:45:24 +0000
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Harman Kalra <hkalra@marvell.com>,
        Bhaskara Budiredla <bbudiredla@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH 2/3] octeontx2-af: cn10k: debugfs for
 dumping lmtst map table
Thread-Topic: [EXT] Re: [net-next PATCH 2/3] octeontx2-af: cn10k: debugfs for
 dumping lmtst map table
Thread-Index: AQHXydSl6TR5EIG5/U67ZbK1+BA9QavkeciAgACOqhA=
Date:   Tue, 26 Oct 2021 09:45:24 +0000
Message-ID: <CY4PR1801MB1880ED5830C59911DEF895718A849@CY4PR1801MB1880.namprd18.prod.outlook.com>
References: <20211025191442.10084-1-rsaladi2@marvell.com>
        <20211025191442.10084-3-rsaladi2@marvell.com>
 <20211025181345.64b1ff66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025181345.64b1ff66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61ccc960-7e06-44fa-cf93-08d9986555da
x-ms-traffictypediagnostic: CY4PR18MB1111:
x-microsoft-antispam-prvs: <CY4PR18MB111131485C57567AE248844D8A849@CY4PR18MB1111.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tOgXrX+Zy6AA9hWQLM4jZKU9+VsFeY8lRRT0pTcmkOe+xmipr5fKNLotOVKZgWiYO8B+HnH0YnE2bRo1gv5NkbXTLRgqmR0HLXEnfpjw1VogQiUcSVWKe+7FEnaTKLrOi8uW47I4a50gRDBB885sxybmq3bqW1aBeGdcNGeSI4M8qI7Qa9Z7rU1nV1Gq49Xgdabor5X31glXhKVnHhpLN4xWw8sXt4s7inPKDZbt5WUNbtO+/AU4C5rg3LDSfWKoQcsTJgY6PLRUbCcbRLBgA3ECcmp36nWqiCRxrKuRzcs52rfreS6aJA2m6QV1opg+kNOMuDRKZBsULKF/BNE+ZPBQcaAOAp17XbAmDTr9zaAtXg5QbmM2LLfkCRYCa8cx3BqSS4bcbBpqB1Y5MyD3qoKpaHOsiBy3ZPdbj9j1z+E+vb0NC+SFAizE9aN0JugWoKQO8wLLmWRe8GjFxYoqG3S87w0deps6y1w+eHmpIVx0tqhu19z2orbuL9sWjpGzDmd5mkIulONc3P+IYnr+JkXfQwpXhEatZstGnjVHkh7L/vjjgfRoShcL1I6tqH7JTSlAFBt1GCcmhGkJMKYHOnzstZoKfykCLLoBDcOzW0F68F5mBk/69qhOjumNBZm1ugHE74G7z4o8Mrflv8I5G4923Z78lLttlxwxu4sdZF8a/32pHvAl0GSwweE2WQjrY4fH8PZlIQfqIngg1CqMGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1880.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(66556008)(6916009)(66446008)(71200400001)(26005)(33656002)(7696005)(2906002)(5660300002)(76116006)(66946007)(64756008)(86362001)(66476007)(38070700005)(107886003)(52536014)(4326008)(186003)(122000001)(508600001)(83380400001)(9686003)(6506007)(8936002)(53546011)(4744005)(8676002)(55016002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jR4wmtOMuqaci6GqUwAmK4TbcHAjOl15mA+VvV7kbLEyl6fBSZ4e9TXfMkaJ?=
 =?us-ascii?Q?bNCkQx7i6ui1pWq4r70saxWWEnN+t+pVYi9gUu743s+sO/vXVV216leVOWho?=
 =?us-ascii?Q?P7trlV476m4lCjmiQXokrMyno1Wez/CSjfnJmB8IICZ3qquofMH4FphYakTg?=
 =?us-ascii?Q?1S8JvAYEHbn0Elf4x4YXVsGVe+GRzFvkyJgWV3p2CKHcEdR0YPd+VfIaJl18?=
 =?us-ascii?Q?/5PAtQUWK5aNhrvVsg0flSIWRKaBpQkzB42TUVDe7U6QCG2lCaeF4G5x7OwW?=
 =?us-ascii?Q?1GyhXgGxZrO+sPD/0omYHe8m9MaaRLdX1AOLhnq9ai0HcEnfCxNbXeAsytW7?=
 =?us-ascii?Q?BaoZYTeW7o5d2PbRGWjSem94apnBlZefHP/0e8VN34zcqpYUeGbknVsnezxb?=
 =?us-ascii?Q?cyQ12fqOZsC7LXNBfoEyqqquzYUIq0ENE4IG5XUTY6Vq1XeJfBZjcQuSkX17?=
 =?us-ascii?Q?wQ0kptx9lRY+I1qtobG4ayQGR9maLyd9XW3W+MJtwz55qnOSvHECTrHq9Hm2?=
 =?us-ascii?Q?DQytNha7/wAvEFJxaO1cTJfKjBlyWGF2wwFtlJimWcMhta1VJ/Lt4LjUCPdl?=
 =?us-ascii?Q?gJEffgHstozpT1OFcE+YnTgDY24ocGfnozTCY0SbxyqSk2v52R1oRIaXPwJP?=
 =?us-ascii?Q?Z5WpqzghFlBOG21vtnxncKi2tXPNVrehbRw7dHzEEpOvpmQmEU21aWZMWP67?=
 =?us-ascii?Q?o40Y1pyvXieBOf6EXFkMCb+dipKWCqlFNAzlrtGLGR5+tV8m7KJm0LyvXGdZ?=
 =?us-ascii?Q?r2ads8G7FAs1+um8IVj7EPupbc1Lh1wyhEawMTbJ46CayfS4bjTbhW5CbFsr?=
 =?us-ascii?Q?LjPRZA7km0rA2Ko4Y9P81I1nkCn5oOWg7LHR4ODwjJTeYd1TglU8G2JjxtcK?=
 =?us-ascii?Q?O6cWI0Fziz3NtG4PNclcDQc3xBtbZysVgd7C2mYgw0XSebb54bKLm8+l9BQz?=
 =?us-ascii?Q?e1k4ijAN2H1wWsfMJiPlwogKptY16h6lCUwEGnz+v6PWekwKwPIddSQ2Urzf?=
 =?us-ascii?Q?crJEOvhWK3vTj5FUFPsRQfJ25KwRQpBc/vXipm6K4W8IZGsWCQHyBp65zvGD?=
 =?us-ascii?Q?sZTm+mfXhX47Tkwc23eiILqkWHQ02nJugQiWXuXWo16h69dHcmBKGu6siEAF?=
 =?us-ascii?Q?d3fnl7vT8DVqcuQbV8UIda+iruCbhN/p4iXVRsd9yb7AgzeR+7iyhlrg4UUt?=
 =?us-ascii?Q?TxMTxoevXZDRUAOo1SrnFl/z30TcZ6KBG9TP07hnQcGHScmvpwszKEZLw2ZK?=
 =?us-ascii?Q?3y3G3mB4XDR5F3UnsHt2YrUaLQsXjIm407USQ7RRLsPvSpe7WKN1Snj5PLRF?=
 =?us-ascii?Q?PB7r4BsJiK/6Lv6HTNb7eMdCYFrf0hELcxFmAzFdtKQS5qbjzbKhWk0HeILT?=
 =?us-ascii?Q?xPH0xrChZGeW0Ia79mIu0qEVPgb7Wo29FcLgceWlMtpJLr0Rz9qxhoUgXk0J?=
 =?us-ascii?Q?CFgKFq6TdovM7xEGub51c0jUkTUFPdtxFKnxI4kmh1NoAVNPrIcpNc3ph1g3?=
 =?us-ascii?Q?68s0HT7vAyzBMVwlMIcsjgBDURTXzIo00UFNBxnRwA20jC69uYnOw8jtbQpW?=
 =?us-ascii?Q?8RlX7jwBbyVOwjFPTR4cB+jn9JIrmP0x2D/4f4zBpwh9MlbJaxTh83JaNYlv?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1880.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ccc960-7e06-44fa-cf93-08d9986555da
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 09:45:24.6849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0PPfH7yGbEEgb4m8zU1Ukav7MGZGmBhbSMIejAMPPkxQ0aWa5ZBKhitPAH1+k5tsiourY7hlCW+NO2zYICOIfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1111
X-Proofpoint-GUID: w7r5IzWvVtwk04qSiQpYxxq91vBJgS_1
X-Proofpoint-ORIG-GUID: w7r5IzWvVtwk04qSiQpYxxq91vBJgS_1
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
Sent: Tuesday, October 26, 2021 6:44 AM
To: Rakesh Babu Saladi <rsaladi2@marvell.com>
Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.o=
rg; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Geethasowjanya Akula <gak=
ula@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Hariprasa=
d Kelam <hkelam@marvell.com>; Harman Kalra <hkalra@marvell.com>; Bhaskara B=
udiredla <bbudiredla@marvell.com>
Subject: [EXT] Re: [net-next PATCH 2/3] octeontx2-af: cn10k: debugfs for du=
mping lmtst map table

External Email

----------------------------------------------------------------------
On Tue, 26 Oct 2021 00:44:41 +0530 Rakesh Babu wrote:
> Implemented a new debugfs entry for dumping lmtst map table present on=20
> CN10K, as this might be very useful to debug any issue in case of=20
> shared lmtst region among multiple pcifuncs.

Please add an explanation what "lmtst map table" is to the commit message.
Rakesh >> I'll add an explanation about LMTST in v2.=20
