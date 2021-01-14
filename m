Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2552F6591
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbhANQQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:16:22 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44050 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726076AbhANQQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:16:21 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10EG5QPS007737;
        Thu, 14 Jan 2021 08:13:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=bk+S2YXxyHdL4vh2HBvqgvEH1QnXSpyrcjSUi4d3/uI=;
 b=WhLLN5+6r7Nt+t1Ww99BsHRIZv/awUJ720G0A9ecwA3JAuCAwmZws2+6arzMr9VxAFWP
 bd62s7h8yofPCoFDJ1wz6OiuWkgaUcmaBvj8sOEiUGrMYK8ZWGv1dZMmFotnltQ3JZxa
 PTVJ9ZnQJpkHInhEfFbSjJBWOA60YYK65idXmuWQ9d9siTUFCvY3T2q8aM8yxuja0i5R
 /6w4sPX2mGoBbv7xwxKqZBgul86zlyrkBQVMfsBOatLAeZu13szLHEVGxSYiLK0MvcWC
 AqfCcO8nUi/bbC5wKBJFBtZUz8pXyp1QmsejlEv/NArXAxQNbmGEDkK/fBGrnf/0qY8l rg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpyfeb-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 08:13:28 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 Jan
 2021 08:13:25 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 Jan
 2021 08:13:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 14 Jan 2021 08:13:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QD7DCr7flMMYYOQjc3IGoIuqnQciw5mg8eTRVBfwCP0GBiuk83u00luSLDmeRkau0p8PVm/ZsIuxUVK0AajdRNTty82SiefLgQxQkGV8xZ+JDMr0wILE88H/X8yjb5+CCdKGB39SYU/m66V4cMAjW1q1A1cDHvdmO0w/VPB7dwSPOCDykSUox3o6edFbpMGYPgnvW4WXfsATNKhJQKun3ns97SEOXcRbP1ZlSjWD2YafHB8X4i15ir4r7ja5uFzXl3+Lg2cawzg295ROrxXcNr5qnVTCrPE+00CYsQ7B7SB6QdloAxLWvfGhSJSkRyzeqU0nxDsuZfS9VnnPoR3eEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bk+S2YXxyHdL4vh2HBvqgvEH1QnXSpyrcjSUi4d3/uI=;
 b=eOjFGyS7KMy3fgHab2t11wkbvh/jNj/5gCLKmwPjClwXWI6WS2LSqoGV8f27Q0dfoW2FNkhhW3OdweiAjXO1RDh572Me4nDhErRaI8dGFl7AxNG3wdishnZxS0CLYGXwWTSF1dtqXSmDY7gxweoU11RlKRqc/33Rldt19VI10Y1toK+WuPLDmPb/t6O/5KKe9sRVBrOUv0fx2a8w4dPWqXEf13OCYm6XLExauNlnvSHfqz4v6D6/Lum2sWw64D0OaVpmIqxFFjEfsrFSR0T9V+rt6jj3cvqNMNuc0tBeOxUqv2mOOolLriirZNv80k9e2Gpt+d02iAbCSVuSTYCA/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bk+S2YXxyHdL4vh2HBvqgvEH1QnXSpyrcjSUi4d3/uI=;
 b=mqGKCyd2+FUBJc7XrJHedGnbnbr0MswAQjQyKY/ELaQLNjn7RMfratVg2dMVtYwjrPw4nlBDsBJtvUtqfIoWvU7QM4EaCfpq3wB5r7d7S5S53pW9aaFeorBLQMGAMX0NZhjT6ecGf95li2SBwuX27tR3q5/OsxrgT9hduGwDmEY=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (20.182.164.23) by
 CO6PR18MB3907.namprd18.prod.outlook.com (20.182.161.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 16:13:24 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 16:13:23 +0000
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
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: mvpp2: extend mib-fragments name
 to mib-fragments-err
Thread-Topic: [EXT] Re: [PATCH net-next] net: mvpp2: extend mib-fragments name
 to mib-fragments-err
Thread-Index: AQHW6l0eElHi4bNP60GYR0wGPjrKq6onQ5cAgAAG3ZA=
Date:   Thu, 14 Jan 2021 16:13:23 +0000
Message-ID: <CO6PR18MB387365B7B1DADFF14150ACB0B0A81@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610618858-5093-1-git-send-email-stefanc@marvell.com>
 <YABm5PDi94I5VKQp@lunn.ch>
In-Reply-To: <YABm5PDi94I5VKQp@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b7b8b2a-e88e-4737-4eb7-08d8b8a75185
x-ms-traffictypediagnostic: CO6PR18MB3907:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3907308BCFE8F6D6FCB3A77BB0A81@CO6PR18MB3907.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KRtYOqdbteNbNeP+5Xr6AtwUc3iuTo79T4fJT9Gr6UzK5pUK0DNQLw7gkVYXT6uyayO3G7P2fc4NgT1ogWypCJKfqUG+pRN7I4sTzX39Q426YsvvXtfLgyJtSVCENRHGdCp7wepG70AbJ9YkCRtKMfbcenm8v1yKUajrmn6b5fMQHnXeMAgiLhHygNCXuTLMmcAuFEXIrPhYXFsrQATn/JglM1Jl4qOHol9Ct0BFBnDXO16g4F7Q4y+7CcNaOTFgYD6NOF296f+bj/ZBfgTLJmDz94+um9KWnYIltUZEco1s7GM5ocCja7LlUI6dogLeZk3CQIbPvYQc+qJn8l/avlLDqWaRtlqtdASIurXkNF01ihOjsBdmVTOgXPnZReU09AYO9RrFGxUFAH7nxTGCYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(71200400001)(7416002)(2906002)(76116006)(64756008)(66556008)(86362001)(66946007)(6506007)(8936002)(52536014)(26005)(186003)(66446008)(66476007)(7696005)(8676002)(54906003)(6916009)(9686003)(4326008)(55016002)(478600001)(316002)(5660300002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZUgfSGUoqLIJeexA0MW4DeawV45+oVZSIml2k5yeDv92LCZXaW+POA1pChBJ?=
 =?us-ascii?Q?gOdfuASw3M2Zuvlc06j9uoGYqYsRXhKPrRXUTkdqxVV9pl33/AbGAIug1+kQ?=
 =?us-ascii?Q?0Rq2cFhRmMcIzMJMuIsZPrrKuosTq0YivkHjNc7mGUv/PNbXgTlEfxMH7ARG?=
 =?us-ascii?Q?upmPtT2eQwDayYLkqrYVU6R0rwqHhgZ/6Hj9BIqIr/DffwBT7hR/g+UdHgHX?=
 =?us-ascii?Q?4LnyM4x1CJALnlda079WnEZf9d8MXjFVNNJfQ0Z0XihFmzHHMq/nIpsfk3fg?=
 =?us-ascii?Q?LKvW6ccTClPuV4UIdRB4g0y1fCX+GYkFsLhgPJsm2dv04t/enxQNQBlXqCiz?=
 =?us-ascii?Q?Hfvj39E4udIKLJ2Bb6G+OPxVnXxtX/t2pk/krfPVd0KV9IH7CHIxti7gQ77d?=
 =?us-ascii?Q?KsbUA2KfsGm9WUbVpTlCN5UHh6sQ2Dxl+SNnEg3T9YqxW6xlBN4rwMfcKkxz?=
 =?us-ascii?Q?BJ6+yDGb7T5dRslzKpjXzJj/G5opubvO70rr1FM0ExswryVYA6FfzrCFOb6l?=
 =?us-ascii?Q?2mHI/5tLYzICfxydpeQ4dVE/gwzV7/WqyjlLmhT5opcgRVDCeLQ89YhCRAkQ?=
 =?us-ascii?Q?GRujSUJ7S5Yet1fWhNw8NG0GyE6RRvoPLgw1e4nNflKrc83UPW1MX7HvILRw?=
 =?us-ascii?Q?SHUDLM2YHcUHoh1lSbCmEQ7RMhjcj1rS7bjeYPeaGFdizCY4SfK13J3Xe9sW?=
 =?us-ascii?Q?sHTKoaJEL2jqLC/jWDvV2Tef+slSX2OencAc76Rp26mx/dk3V3nphJ26Ua3Y?=
 =?us-ascii?Q?3LHYBRIYcrdOGl4kAN+KSBjuj8pD7OwkqLsa6/Cl/9pX8Y44FCsKNlP8znin?=
 =?us-ascii?Q?ehYwM2hLZI7FZhD+VG06tk7UIyc5AiHX3zoau+qqOuPX1pmzkpuiKneoZvie?=
 =?us-ascii?Q?AKsPXmsy7B7FkWflR8Vd46HPCXBhWnU6wLSqf3GcHKHdirMPK3HC+ehcRghS?=
 =?us-ascii?Q?Y5G4cgZ2zixXy38mcXujZ/8BSkbcpVZPalkzZ7J1/bo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b7b8b2a-e88e-4737-4eb7-08d8b8a75185
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 16:13:23.8560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rux/wfsfp1UOj6MzMQIAXlVCeyHaHBC1tx/4MQLoecMZxYulS7akdaqC0lGtYT147oiBfCNucX/kizCKICtVwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3907
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_05:2021-01-14,2021-01-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > This patch doesn't change any functionality, but just extend MIB
> > counter register and ethtool-statistic names with "err".
> >
> > The counter MVPP2_MIB_FRAGMENTS_RCVD in fact is Error counter.
> > Extend REG name and appropriated ethtool statistic reg-name with the
> > ERR/err.
>=20
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -1566,7 +1566,7 @@ static u32 mvpp2_read_index(struct mvpp2
> *priv, u32 index, u32 reg)
> >  	{ MVPP2_MIB_FC_RCVD, "fc_received" },
> >  	{ MVPP2_MIB_RX_FIFO_OVERRUN, "rx_fifo_overrun" },
> >  	{ MVPP2_MIB_UNDERSIZE_RCVD, "undersize_received" },
> > -	{ MVPP2_MIB_FRAGMENTS_RCVD, "fragments_received" },
> > +	{ MVPP2_MIB_FRAGMENTS_ERR_RCVD, "fragments_err_received" },
>=20
> Hi Stefan
>=20
> I suspect this is now ABI and you cannot change it. You at least need to =
argue
> why it is not ABI.
>=20
>   Andrew

Hi Andrew,

I not familiar with ABI concept. Does this mean we cannot change, fix or ex=
tend driver ethtool counters?

Thanks,
Stefan.
