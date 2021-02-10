Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4195C316C13
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhBJRHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:07:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56110 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231950AbhBJRHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:07:22 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11AH65pY009726;
        Wed, 10 Feb 2021 09:06:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=QyUsXPPL9up63bkB6J0hFJk2i0ab3KPiqkOHczsmlDc=;
 b=Yfj8m3fK3c2THJ4wpFGD0zqbPyQHYx6vdhaPbWlQjh/RPSUxqHBK0pK+3U4aepaR7E1D
 QzvtLYz/kMvkHjLObcUGhxHX5ACJKWZvUKyiHRxYUaptTOZrM0jSRdxqr4vcNqhWGe65
 3sDYj7aY/BS/T5YTQbLcrfzjbwdo9dwIkr049qfD7jmJHMuFXloa7aoMsH8Lt4Dt8j9h
 NcdLQFiORnt70CSQBJ/vVwDuGgeZ5I9RDmmizEOCRmS9wOLv4YYaZgGrjv0p+eP/WDs2
 Mp+RWc+e8R5cMvYQJkMp+lmapLH5lBmZQ7VKWncCW6o0AtWCx9sIAS4MvABwjtM78bSI sw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrmk93-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 09:06:35 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 09:06:34 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 09:06:33 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 10 Feb 2021 09:06:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+qxB4UTjiKgkc6J5Q6uDVTISUa1EMWAt/MqfRA0SDM17nBTFb7AlqdKNoojN+/DnHr02tL70te4mb4s3xZunZyxuce5SVOict6T7pisKIdt6fYg22k+aVnWjQRGiHbgcA4TaxXwHsfKub+0XIYTtOuwNJ6UsQLKOKF8NHhrUp97HFIms90qq8oqRQslk9q42CwbqkIkdIhL9r7t1YaU5yQMCmDOGi3xYxKpToFLLZJUhWTiIu2VEvoHUaIrWMF01H1+uU+qbJ5nU6atWkhXPjk0wgmMULO9Vrhwcu3zOLCEZIe4eD4EP9BIXiCUdpU/HyhrneLDGiYGy2E+9vI8Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyUsXPPL9up63bkB6J0hFJk2i0ab3KPiqkOHczsmlDc=;
 b=faklrMH9gF6fVCpPQfOBxZV6AcBaJL3P+HF4bK0OzvCus9hRhh2yJgBkr7BqAZTPEHM43fSYKhCW14UdXeemnH3odiT7BhgBUNwgRmMQxYo/ctqhXwvSxUTysGbq3c49rZHIGW3km8vLACkjk5uiSQjb1X3BUjTLIPhZx3xJocuRKQeiZOBQaGPWLL++QPQ/Pfu8lXhOgTzGT5BJoTsqVnFqPHYf8M0dhVg26PLJpkyQr9jIUgcAYW4VZfDn5y3UhVfcRgK41HpbtJ0+hIfRpcjmxhm961Z0UcbXFzLnXM+sfsQ6f1rjoe6qLYWYl6IMzhqmUW3TUlLF7tDknsV2UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyUsXPPL9up63bkB6J0hFJk2i0ab3KPiqkOHczsmlDc=;
 b=GOtqCl2A4i1CCUHqJOfsgL966L+3MR62VNwECtelpdr8ylYs3DiPeXXhdubUFBMLmem+CBF+0FuXJqYi8rI+SlySEDRVROpzm3ApOHvmnfHap2+ajdOMbHX7cFMQNngnNLjGR4FByCjlK99mtSeuEnySGpWUF49R1KRIKLUa8BM=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by CO6PR18MB3794.namprd18.prod.outlook.com (2603:10b6:5:344::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 10 Feb
 2021 17:06:29 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3846.028; Wed, 10 Feb 2021
 17:06:29 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [Patch v4 net-next 0/7] ethtool support for fec and link
 configuration
Thread-Topic: [Patch v4 net-next 0/7] ethtool support for fec and link
 configuration
Thread-Index: Adb/zYiiwFGIBLldS7ybCXOIX0hEdA==
Date:   Wed, 10 Feb 2021 17:06:29 +0000
Message-ID: <MWHPR18MB1421079657254DAD7B37000ADE8D9@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2401:4900:3290:2ec3:4ad:d84d:e831:4d5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1dd7e767-83db-4de1-ff65-08d8cde63551
x-ms-traffictypediagnostic: CO6PR18MB3794:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3794BF68199D438CBBB83AB8DE8D9@CO6PR18MB3794.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3lNMXWdmoXjqOkCiOVhHcE5YtpVYqM2f8RpibNu3WYwH9G9CCfA8zYgklx1Iv32AfjvMQTGvjfHoxjDFunH/+zgE/l9W6/ZkRcB95LwUANTL36/6Ex0CzrLA2ClqyUodqLCuzRV0KJkW+nRbqEhaE/lAnUbQ1TAlMeSc5gOu2ucfYBM/ZsJFmvwUiduExK1o2uCQXH+DzuVcVLHs+myMKONBvgFT4LgCSVIrpraLfo+osj9bUH+5nUzhuqXSNNUSjh4VJ2KmX7y2X4p8N9i7KPXfVMV6t6ymMEo3NX2ewapEYga8mgFxVfy5vfGZ4ke0BQ63AiRajjET9RlW3X+QGHc5H7nJ1qAbbbLpLT420ix/SQmUcyiSoPbcTBqd/geyqmmVRV7/qf1ZrTS/XQ2+SYLfqEdy+X5lcQpQweHE7TnQoRBJ4IbF3tIMEQD/GqqLGCWdLejtH2vDUaCE3uRmKsDf/W0TgW3ZZnFyUgfmrUyF0p276WSXbfJdhP4vPC5bUWNVuyPehvgJnDgoh/ZdZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(396003)(346002)(376002)(83380400001)(6506007)(186003)(53546011)(86362001)(66946007)(66556008)(71200400001)(52536014)(54906003)(7696005)(316002)(8676002)(4326008)(33656002)(5660300002)(8936002)(478600001)(64756008)(2906002)(107886003)(66446008)(55016002)(9686003)(6916009)(66476007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?t4MYuprmDeqAaWj9h0bvBcmP4PYu9LVJTbgWpl0ZFEMrD50U8VG5tZZ2Fspm?=
 =?us-ascii?Q?KU/ekg+P4j4Rqw/ldT2MWr/brQpgE78S8VI7Up4LqJpiA1jRxBMduRe1aHtg?=
 =?us-ascii?Q?MqRL+TX6o1MPPhHKG6zouG8MSBXyNtnPNwD4/EQ284UydOqluwS7zkCu6lNR?=
 =?us-ascii?Q?C8/6CIGt+MolYkrYMAMGiof3caa3NDwTtBhHUiHKjM7jojsXTZb+oIH14P5c?=
 =?us-ascii?Q?tyXfwTMTSGTryrolQCFMBnrpaKei9Rj87iYPrPCu11cu7Sky9yDy8ZEfQor+?=
 =?us-ascii?Q?4YDCgyBfdFng3PXDM4Wz3obvzVDxzbTZtVC1vk/I234PU8dGTu/EwO4AmJIZ?=
 =?us-ascii?Q?u5Pa41099B3BDntCSc58X/EYx2UBVUxiQ6VEKM9BioxEHp6nw4x/8Uh2/sU6?=
 =?us-ascii?Q?bEQTFf6KSNDSCdW2QX2HwBVbufzUIu6eHEtftVrINXHwZC6zg7V8XPTWCGAN?=
 =?us-ascii?Q?8qR6AUd3f8GCkqi0RwMgMwGV1SilNED4LGd0w/LUimrAPJ2MzwuI6UUBIqDb?=
 =?us-ascii?Q?6YUnBuihk24fMwZGjRTdGOVKJ1KqPWn5d4+SmI7ehDuXox8xX/oQG3SQWmO5?=
 =?us-ascii?Q?66oL06Ai/+YAgxc3h57WdUF+JNoaoJmi12fd0qikpSMWf5DF1FaKckydS6OI?=
 =?us-ascii?Q?FLsBlO2dBSQEcYCMdZg8XhcCuFm6zcbV8hRR5UjC83Xyfrxj7t9oEePZVZKD?=
 =?us-ascii?Q?Z/i0bvxRDO96pKth/a99pH3aWeh8XxVPv/UVnOLdEetLtNeYDuYrIbc/cGs3?=
 =?us-ascii?Q?aEUHVI3Z9aKcSyVNVJwdDsS/OrrXsOBBs4XGu+oe6ixLsDtRaeGMF6Yj3rr6?=
 =?us-ascii?Q?Rl99ly1oUVnzCmA2lXM76m0WMdp3hG+XVvTvihr5dynKfwUsfw1RnMhpYuY2?=
 =?us-ascii?Q?E2OeOkhbG8PUwUyaV4Jxr13OLhz+z0svb/9G7oMhaFUMp0i6hXdDFEmQCVY8?=
 =?us-ascii?Q?ne2hD99ESeFLA9LkE8NfoyEMmf1ACMtGuUFu3UMzXdxc7o5uyxiT9yypXoJM?=
 =?us-ascii?Q?Brj94jS52jDn5daA4iXn8Rag41lsTJkeSAeRHUJzCTqdehyN02LgpQpm+vG7?=
 =?us-ascii?Q?LM0/n8dcn6pIJi7zpiFUWGoF/sE6/EOkPKZA+FH5ZTadUyO7TYXXi1tQJ+Gq?=
 =?us-ascii?Q?9n2NKl5AEVR0L/m9xWllgdvsuczWMtnsJAsz8yN69V09Oh32KMXyog1//x9F?=
 =?us-ascii?Q?ecUT8U+/L0l9omXtR2D5UnQb8M4z2pvlpoA/qv5t2UJ6txgH4eNwK3TSuGsM?=
 =?us-ascii?Q?1IfBcIgs6hm2eesBXALzC1AqfblG+2VP87LoK132Ku3+bUTORABtUEgQI1VT?=
 =?us-ascii?Q?d/hOPkBU9KAInfnxe/KDE5zbof1bISjCiDSAuL+tSLNFlzhZJm59UAHpCDIs?=
 =?us-ascii?Q?WOE0OUikyKh265a/bHZ0m3SpqMq4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd7e767-83db-4de1-ff65-08d8cde63551
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 17:06:29.2374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n63XofW6ybigEesVDHNyPNx8Ggs/vUu2ks7N1LqW27gqB0uTjVJ0A2gapq09y5kvIVRlUMDiCmlXB2qKZdOINw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3794
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_06:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, February 9, 2021 11:56 PM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; willemdebruijn.kernel@gmail.com;
> andrew@lunn.ch; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Linu
> Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: [EXT] Re: [Patch v4 net-next 0/7] ethtool support for fec and li=
nk
> configuration
>=20
> On Tue, 9 Feb 2021 16:05:24 +0530 Hariprasad Kelam wrote:
> > v4:
> > 	- Corrected indentation issues
> > 	- Use FEC_OFF if user requests for FEC_AUTO mode
> > 	- Do not clear fec stats in case of user changes
> > 	  fec mode
> > 	- dont hide fec stats depending on interface mode
> > 	  selection
>=20
> What about making autoneg modes symmetric between set and get?

Get supports multi modes such that user can select one of the modes to adve=
rtise.
For time being set only supports single mode. Do let me know if you want me=
 to
Add this in commit description.

Thanks,
Hariprasad k
