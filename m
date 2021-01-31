Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0774A309DB9
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhAaMt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:49:28 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49364 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230424AbhAaKw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 05:52:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VAoJTV016695;
        Sun, 31 Jan 2021 02:51:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=gj6wGXMHpP4Rhll+g6zA8GpeuAn/aj8Ar1Ny5Ez/WGc=;
 b=Q59UXNBiWWxwqKGWZtWhSs4MM5kcOh/aCy8rFDx6YrqYcTVaWFvxUut7LWB3sb6OAPTd
 uNCpvtyI1GwxXhkDcRKuqnclTIWt8GcSwxwFHGaiUEv++EqX7/JLbvQ4qqG/KXg7D26c
 8SxOtKzkvZeHsYcPkGSJx6ytupv7+fQNor0p4aJ/DIw/54MfvAJPEEdCI8h6svLVZORO
 l+WFFSGrX5kPjffmDx6O7oDx9bmQfXgwJFAhzBnbSFX3HRhhu513daURjbJZFSnHqFSb
 jAODtQB36jA35d2DBpDJR/KUVFt+dzRE+CKRFLHG1MWC9FjjjxpOAalGwdxFUZtJhgHp /g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psskug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 02:51:51 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 02:51:50 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 02:51:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 31 Jan 2021 02:51:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNYb3TJa/+/fyZpIPSYdjQBFVIEota9+PseNfpZpp/3ZGP6NdFye18hpYThFItOOviZtptaapp/B+SIk8IBv9FRBx+WNXiReE6IiwR6jFCY5d3Lqi6rDfEV6Lf5rSO5OUe7JHn06qT6q27Q+Tllii3Ng4+efqWqEhoHMdecoI0ETHJf6i6770Kzhd5CQCxCwnFgMEwQDhi7XrZXZtByDShd6pTfyj0EGRTDN1++01lLfh4D80TzKdCZOk7LxcyBxCoLQjN5CPy61wWBv6L53VQF4pGZtEA+9ok+ZamveYWv/hSNTRbxJYhvUGmnRwDX40OEvfsOvWNqU/fxiEcZ0zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj6wGXMHpP4Rhll+g6zA8GpeuAn/aj8Ar1Ny5Ez/WGc=;
 b=O4K5hitMOQ+UOSU5AiQJ1L7oquFc84STa9G/l2kv+EUGdhk2LD/hFx+76c2oV6xPFWYKlnoFR9bhv0ZCbsVLMqP61v1PKbJTW5W4K+oXnAw7xLQVW6tRpr53ThlSje78mMy+rLKug/2+lOSDTng4jTru9aTp3DgVWC2UYRy81Jut3RcTBZe1IY3wJZk4wLZyvq1ICJhZPMN0Tajb3Y2U81U0PoOKPHrvyL03nogkM2GnLOKLAzfmXyaXsX3wMM6o8Ij4dPO7lqtSiv4XI0l4gR2Z5oZko/Boo9ItNHeXpGIF5mqztmWZrmpbzpWuQpdyzyEvjtsIRXj5JHObXi5NrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj6wGXMHpP4Rhll+g6zA8GpeuAn/aj8Ar1Ny5Ez/WGc=;
 b=GXSsETUpsXCehin4SrkX/Bjrqf5NOo4GbJgiRdZ6TdYSv4gelPCwIRpYj7OUDbbvTk9gmPBWz4/2HllO7cFhvNC5UaETt9WM+ZUZ1pcONkWRIdylyvWWJRloH/SL8fYjYwvbOBibBcCyQK0CJQTbNoVyz3KNA0Er3fZzLVOZVUA=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1613.namprd18.prod.outlook.com (2603:10b6:300:cb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Sun, 31 Jan
 2021 10:51:47 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.024; Sun, 31 Jan 2021
 10:51:47 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        "Yan Markman" <ymarkman@marvell.com>
Subject: RE: [EXT] Re: Phylink flow control support on ports with
  MLO_AN_FIXED auto negotiation
Thread-Topic: [EXT] Re: Phylink flow control support on ports with
  MLO_AN_FIXED auto negotiation
Thread-Index: Adb3t9G4usyHCBibTMyL4NZ1O9ab5gABQV2AAABBZWA=
Date:   Sun, 31 Jan 2021 10:51:46 +0000
Message-ID: <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131103549.GA1463@shell.armlinux.org.uk>
In-Reply-To: <20210131103549.GA1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71175d8e-4bd0-404a-8c3d-08d8c5d634b5
x-ms-traffictypediagnostic: MWHPR18MB1613:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1613A569F128FAAD96961944B0B79@MWHPR18MB1613.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lYipunPB6/U77P55c+xiNa13rNqXVj9Z1B7eohZeOxlBtEghoIvwx9COn3RKWl00w3PLFUdKS/V8myX0bxvX9Ib9WiPrJfy0kbj0EqeFJrI7hnBOEYlwp3zfIasIzHq5eR+v14lwpOXu6MyVW9dNNtxubiBr+fdCLURdXI1op4VACAhgzzvtWFXhYZWgEuS1+6vSa2NJRk1YDRwu/5QoiTvxKKbjvjotUpOsJeOG7qCT7XoGPSKqQNYQyi3HoBYBZh5vQkDgpRRcLpXOTUsv5YH6KwMmXkHReR6AbicdMt3faREfqZYinuOWSw8j8CoXQpW95CNrNSaBfXILeVkTuVWSFk+Fyt40dfEwTCvdcpvJgBiW00tZOZBPqwIQnP9vmIuGQJOr/2P2fQefoUUqdhfa8JgtFE5EcXhvwpJYTU0P87sSL/e71YKbdvr0px3ed9mkEgGUdKob/5tzAoPvxx8y8Cy810hiOu34YCCnImA9U2TlRNlb2t8QVvw70ITF54H+KmZLCm2HtN04e5JECQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(136003)(366004)(396003)(346002)(26005)(4744005)(186003)(83380400001)(5660300002)(8676002)(478600001)(8936002)(6916009)(52536014)(33656002)(66476007)(54906003)(64756008)(66556008)(76116006)(66446008)(6506007)(4326008)(71200400001)(316002)(107886003)(55016002)(9686003)(86362001)(2906002)(7696005)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LX/KQQ7x0VPKeOHKAlDxvABdRYD6/DWjcxz0QWyBWvJbUNeS32Ak7k6NoREA?=
 =?us-ascii?Q?+Mlr5VV6vRT5WQqda9EK3Q+lSQPmJ8cdYcbK/+liDJ3JFGuVwjudmfjxkEEs?=
 =?us-ascii?Q?ZX2mA/0hgV0Y0MdW+vIGnVK/BNvqdHO0xyzwSQ7qYFmELuFr7aJibAc2nA2I?=
 =?us-ascii?Q?dIRS5WsmkUMH7jSvtf/YLHtyVASfsBlT37hGA6Ek+BZ4HStR5vE3w5l90j6T?=
 =?us-ascii?Q?N0cpRGGkd7lzsfRCyRDUlvK3FRhibvKWpGN156Zg2/vdzC+2J8xVqFwH3jF+?=
 =?us-ascii?Q?3wCgT2gRx1gLS9aN2ZYoXlO2illoGjyfVpVjz1iF2rxmqOZls4O8TrhVX9sk?=
 =?us-ascii?Q?w/PgQzFaz37+8mUjw47COwxzFyKuJGsqz6vNSsp9R3m2FM6oR1g1OHFMhp4w?=
 =?us-ascii?Q?w0rrLUgcUfD0G62JmPv+N/aPNWBLu1sGtzPvaXJwCYFRTLgbKUXYy73DMqme?=
 =?us-ascii?Q?hHaRhNyA6D1/LjsZppdAkzypsbDgYgQSmmYNt4LHaZwq4kfaiKtLI3z4jA1z?=
 =?us-ascii?Q?OeBgqvC/pcucBVSqZLUhFtR1PLgxsAA0VdwwyaReFDKDzKRgkPGyaJMM6eh1?=
 =?us-ascii?Q?cDwOVGmuNj6xI8rJff4RueZaDsk9WUIBm9+meYvmmGgTh1jFmVstvjdnIZCV?=
 =?us-ascii?Q?zKqizPmMxF1WRuQXdRrPjNSjeO+dyX4fzROilXylq8FMrvldY3LS/AhiVxda?=
 =?us-ascii?Q?xiZBIjiOMl6S9uA4Wd8Sr61xvQBPs9QFPUD3p5ugQ9TwkduHZc90M7Jt3yyM?=
 =?us-ascii?Q?BRG/uriA/0gkWC6T7hrDddlYUHa2Osl1KlgnbMPRc27K/xyHaijiMOUqsKOU?=
 =?us-ascii?Q?0dov5G/SDcnOJjQOHNHEk5FZb0wx9cRf0I3MSHEDw5HT9CJSPIoBwcsOgBb0?=
 =?us-ascii?Q?6pV/RpTWHSXv1ZJ/5n1CWxmIocAi7boy8ETegzgPQ7INiKTzlub/Z4smFQbY?=
 =?us-ascii?Q?elOZ9QksVicPw8VDGE2kaGqo5snpczE7w5q8DLAx/EANRNwyFyQt9fEW/uPK?=
 =?us-ascii?Q?H6USsYicCvpAfyIDDt8DC3APM7x4qnE80Gu/6uykGPuZ/jnrSOV4ojz/tUKU?=
 =?us-ascii?Q?OE0O4HVF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71175d8e-4bd0-404a-8c3d-08d8c5d634b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 10:51:47.0065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /S79SBCyBbOSeinued89iNiCRvxy5Vzx2hwTsUrasFvV/4ub+zc+loP0GNLo59bJKX8NGcyskv1uYwueqpa0ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1613
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_03:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > Hi,
> >
> > Armada has options for 1G/10G ports without PHY's(for example
> community board Macchiato single shot).
> > This port doesn't have PHY's and cannot negotiate Flow Control support,
> but we can for example connect two ports without PHY's and manually(by
> ethtool) configure FC.
>=20
> On the Macchiatobin single shot, you use the existing SFP support rather
> than forcing them to fixed link.
>=20
> > Current phylink return error if I do this on ports with
> MLO_AN_FIXED(callback phylink_ethtool_set_pauseparam):
> > if (pl->cur_link_an_mode =3D=3D MLO_AN_FIXED)
> >                 return -EOPNOTSUPP;
> >
> > How can we enable FC configurations for these ports? Do you have any
> suggestions or should I post my proposal as an RFC patch?
>=20
> If you really must use fixed-link, you specify the pause modes via firmwa=
re,
> just as you specify the speed and duplex - you specify the link partner's=
 flow
> control abilities.

In this case we cannot change this by ethtool during runtime?

Regards,
Stefan.
