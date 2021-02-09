Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1E93157CA
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhBIUhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:37:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9122 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233170AbhBIUd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:33:59 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119KTvnx030468;
        Tue, 9 Feb 2021 12:31:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Fy/lv5EgL/u/+mnZ7tYNIWmkDSm4YLxlq4YzDZtXNHk=;
 b=R3MzQ0VtySOEvTK2RvMJhLulVin391O8DN6jqj9x/H79RDNCHcGfYqzwT6Gfi1njMaKS
 Oltyjtb8q/DVkdimiSREczAtXhBl+ogGMIRW6xKmckcYu0vZFWuDrM4NiXS5i+TUjoez
 F+KEczIPPOecFhtE8BslZLkHLrK9dgFiISzHZhbX5s2sjttNoqqwA/YFRAfroH8KWLSg
 BhRDQU++bfQju41zvkT96CTuRN799Vn4Mg5/Drg0WROs0VM7TYIgFgSPXUYIEiSO30e9
 YcSHphv+bFR4ylmsmcjR9BbVq70QBGGYi1sJDb82xmfUYCm8ateACSZ4Wz0vU2Kv9x1y CQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrj26u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 12:31:36 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 12:31:34 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 12:31:34 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 9 Feb 2021 12:31:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXGhmmYwA32MOymR1mCqzM0+sPWdZfY0cVxdhRQZTx1och3zBX/rHqHBirI9oz+K+/WaUYMGxELRzry17424ECDDPI10rXEZ6i5Hba6erez1frXNiQurN9AjmG6yMUryWmbjSOZuQ6cRy7mPqXxAigEfuBRFN6zgf/AgYnisqxCjcHAy5AeVCSOfTEAX41Dd5U6uKyU8sne5DRbux19kijIdVlEa0t9sqOQFNFk3OwyMBBo6uNQalwjC12lBoB/bTshG1C0Mi4Rwww7x0LbXToh0fpnnvz8CLfqtheVbouoRQMKPKBeGH/zvtVg551CJ2x2zGV4vlUyrGMorddl/HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fy/lv5EgL/u/+mnZ7tYNIWmkDSm4YLxlq4YzDZtXNHk=;
 b=KHlXvOL5Og3i600nzbKJK3dklkLPS3caBIpFRucXo7tBQ6YogSPJl8Bwh5k0JfCyNdEXvu6CHweiVG8qaw79eu1mrt8TUGoaUB+vI+NPI8wO94wcYpgs1hbhPSL8fIWTJmkR5lzkEj+DolyMgkXQ90x+b0Lq4p4y3Ln6QH7ngvmfaIpZSJ3nGAPi4a2F19+57v4YguK4vZjMqh9E7oxctRr5eHt7B239lbgat1XuLLyIh8H8zM3gYOrdOALq7WOgDZ08aQYLI0VSnG1qwf6MUg5eyyrhMnZArCDTR9Vyb+TIXTVLdx1wF30tQYQnOfA3mXPxJ2zAGpGpTyUGrLNaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fy/lv5EgL/u/+mnZ7tYNIWmkDSm4YLxlq4YzDZtXNHk=;
 b=fDOfeV0dSo9rOuh2f5a2aL3IThEveVKr8/H6d0BeK13qCIrDWDMBlQqxDklHdOWHSTDXwruRvEEjDF9gj+OA9glcL57m+/8edSJ3Bf+4ub7G2nNEmgvmQCPsu8mrjtOsDBqcHK2lXiRYnnbblpo8HOiTr4NPhHzbgaI43hHegaM=
Received: from BN6PR18MB1587.namprd18.prod.outlook.com (2603:10b6:404:129::18)
 by BN8PR18MB3009.namprd18.prod.outlook.com (2603:10b6:408:99::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 9 Feb
 2021 20:31:32 +0000
Received: from BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::addf:6885:7a52:52b0]) by BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::addf:6885:7a52:52b0%8]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 20:31:32 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG
 support
Thread-Topic: [EXT] Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG
 support
Thread-Index: AQHW+34dqeNi3qeAj0SumJjdXBCv2KpOsW+AgAAT+ICAARriAIAAPIIAgAAh5tA=
Date:   Tue, 9 Feb 2021 20:31:32 +0000
Message-ID: <BN6PR18MB158781B17E633670912AEED6BA8E9@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
        <20210203165458.28717-6-vadym.kochan@plvision.eu>
        <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v9b249oq.fsf@waldekranz.com>
        <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YCKVAtu2Y8DAInI+@lunn.ch>
 <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [109.186.191.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c0df967-ea05-4796-c9b5-08d8cd39b01c
x-ms-traffictypediagnostic: BN8PR18MB3009:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BN8PR18MB3009036AB2A01EFD615C0872BA8E9@BN8PR18MB3009.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nWhutGgcyP/sHLieGeuOgRH9hgwXrnuzw9SLB8wLw27Iq9WPwVYX7zHB8njZVYLgy1wjX3NOFvSSQwJyz6yDXsMnKX0VTalmNSJIeJfN8kS9ZSAjRrxrylhuT+R8cGBefRTicpmr7twHqTcTgYezFRxCTpyZcYYdg2Vno4ku1SsIfTOrEgLNAp715h/yfHORe/Wz56ZafYbumDek9pv+bHIjS/1yATg6k5JHiUx+BKfGQmJXvMVB/Uu677Gq4r1LBCodQRrEvFu8r8SnJdOY5ZNAZxkJAByZsG1bwehbf0zxD1L6UceoFlf8bKBxRFbQ1BHXAieQ4CQCsq8sdrDkL7Jwy5VUZ8jmYgS3oAxmiAclIjmsPUQd7fbPbzuhTfOEo9vu1H1tImCehwF7ESRoixm/7XxgrDpnDtW8geas4y+nVWQbniQPH5cPhaFfvY24iMQQpvDFgC0pJxz0CVudf3+fW0k6JWYkdcg82n7X4JfBbxtOgIMl22wyqXTmlf4BMLLXVZ4kZ3W6TfCECZK40w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR18MB1587.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(52536014)(64756008)(5660300002)(66476007)(316002)(110136005)(66556008)(54906003)(66946007)(76116006)(66446008)(186003)(7696005)(6506007)(4326008)(55016002)(8676002)(2906002)(478600001)(9686003)(33656002)(26005)(8936002)(86362001)(53546011)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IQMgjs11h40O/ezn6fJY269cN55fo+havl/oqfXmh6cLIXOPmZp9lCRLqrvw?=
 =?us-ascii?Q?MFYXmnVzcX5twD//7qgJW+l7F/1nDuFeAvnlQHZjGv2jsR8Sgh/3o7nkst2Y?=
 =?us-ascii?Q?bXH+KISo8yhf1cXUJhVAbvnEWy/BmhhhWPrF9XNHnlvbNAqdscrv4futn6um?=
 =?us-ascii?Q?OKq5vnmc4wvzqB4czW+9mt5C4V/Q4uI7S9lo9SdPi2nGXK6WXcRDn8cWDX7M?=
 =?us-ascii?Q?T4zemD/gcqoXdjmQWM2n4iL97ALUg5GGqTcivBcU7K3mnt7GmbizWgSltgJa?=
 =?us-ascii?Q?yneydoxGb743s5AgZ0rZ4NjuZFLGDFbhA4eId7DmpeNoJAT3FiJLdDQFz6qV?=
 =?us-ascii?Q?OXSpyApRlytD6/HsNJs1ai5T9ANiTr8B2AvVgepaLWy+iZlJ6G/ulzqv4v/Q?=
 =?us-ascii?Q?2SEY3YDKHtEaRMNJx1AqWVatLWqy/YiM+w8qPUwEvxuSV9Mus+MA7FJkbh7/?=
 =?us-ascii?Q?uwjCFr95Y4zriEmJ2EO8k4NrD/nt2u4NKSZrjxyZDFFg5Vq/cx8NovqYazxR?=
 =?us-ascii?Q?2mnvk8guFQOLQv7rCKa6iIBGzv92mupmiAWkS7EeBZSJefRKXc4MgIZjQS0W?=
 =?us-ascii?Q?EAHjLRdoQCRPnePYxD+dwUBg7GuIjxCyi5yRVUGrWFPhvSFTlbPPBkXWbqww?=
 =?us-ascii?Q?adON7513FP7PlIY9JzZogX+WjLM6OrW4jcvrcwoEdsmH8FQnXGzsmSw0jpSM?=
 =?us-ascii?Q?7f46Afcy1RcmTG87owT1bAbcNGquXyHqKVbQBeKXlJXkmPoiSZS9+7koH3CQ?=
 =?us-ascii?Q?oZ8QcKvJFep9FtT71n9JoTEBe4aV/V8mPyymEF9D4xMM7zjHuyR8uYi8OetC?=
 =?us-ascii?Q?KBNa6eceteSPgUyjD0bl3vrZ7mFzleTqu+y75BwQlQkQb9h3h+oyUUtxfZp2?=
 =?us-ascii?Q?JSfGTjlTgCLEgZVGvQQ5sLhhU2ZfcWjXkTsySYl3ujY0cJfc6cdNraWqFKJ0?=
 =?us-ascii?Q?r+lmpYupZ69A1Vq3DwPR1ubfI2pctRnggd0J1AE+sNffhtrxFXLAHjajLJPO?=
 =?us-ascii?Q?iurlElWY5IFKMWvgnN5tauLESCERmSBb4A1ySdHn/pwSMRDfAT5arxfIBC9g?=
 =?us-ascii?Q?9MJbgAC9vEU1cGMdLEVDxL0qR+MH0PK10AmVJAb7c4E8alVOP0T/+BUlgw9j?=
 =?us-ascii?Q?v9Rl+h9s4fHe3qpJLLG8VFJVjLqChcxjMbueeYm7ZZIpZ5rljx35B+Bs2LFI?=
 =?us-ascii?Q?ZvbLvmmq0nrPEOg1Kw3bl/xjYeGrI/Fj6WOkWAwZCbB3ceM/dbI1mYOzLrxh?=
 =?us-ascii?Q?qRgPZw0QFgddIOTsUzrT1aqrNTJxtBkfrif8iSYZ4K8/Aaif1IywYz3d31SL?=
 =?us-ascii?Q?+aauWLvWPM3/Ts2hqzEkq9OJ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR18MB1587.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0df967-ea05-4796-c9b5-08d8cd39b01c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 20:31:32.3162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H28g5bfhm/eVrr5DDXQ7Y9C9WrvecxiNU55ibfs1gEU6fRsgICOgRd8Nnt8+oR67p2De6M2uF6ZeG1LCG3JHyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB3009
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_07:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, Jakub, Tobias,

On Tuesday, February 9, 2021 7:35 PM Jakub Kicinski wrote:
> Sounds like we have 3 people who don't like FW-heavy designs dominating t=
he kernel - this conversation can only go one way.=20
> Marvell, Plvision anything to share? AFAIU the values of Linux kernel are=
 open source, healthy community, empowering users. With the SDK on the embe=
dded CPU your driver does not seem to tick any of these boxes.

I'll try to share Marvell's insight and plans regarding our Prestera driver=
s;
=20
We do understand the importance and the vision behind the open-source commu=
nity - while being committed to quality, functionality and the developers/e=
nd-users.

We started working on the Prestera driver in Q2 2019. it took us more than =
a year to get the first approved driver into 5.10, and we just started.
Right at the beginning - we implemented PP function into the Kernel driver =
like the SDMA operation (This is the RX/TX DMA engine).=20
Yet, the FW itself - is an SW package that supports many Marvell Prestera S=
witching families of devices - this is a significant SW package that will t=
ake many working years to adapt to the Kernel environment.
We do plan to port more and more PP functions as Kernel drivers along the w=
ay.
=20
We also are working with the community to extend Kernel functionality with =
a new feature beneficial to all Kernel users (e.g. Devlink changes) and we =
will continue to do it.
By extending the Prestera driver to in-kernel implementation with more PP f=
eatures - we will simplify the FW logic and enables cost-effective solution=
s to the market/developers.

Regards,
Mickey.

