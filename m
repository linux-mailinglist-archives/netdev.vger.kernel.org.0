Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57CF2F08BB
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbhAJR03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:26:29 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5908 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726250AbhAJR02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:26:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AHFTWV020044;
        Sun, 10 Jan 2021 09:23:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=t7sT4LZ/vVHJI+cbMhenJvZq63GCCYX7VwUZ4nnmLrQ=;
 b=TxdoZukk/pyUI0sc2A1R05iLCMyxO4d8j4nMuHjxZvDZzmtJecl/kAy+4J+jocysNLjW
 cEOMOSM5jJj5c3oXj20awPAc4Os1Wtae+WdLxVv4MM0zzvhxU3EjOy+veOWdh4DJk/uf
 bYvtYtjAknu+RnQGOCtl8HCKBnSs5F0BWUWBw4fjW+Rd/q0oP+qSPoBb+ByBslyxX+Eo
 JMLM37vxG47ZKD8HfFRHWoGxPgbfidMwVLD/+3aT0ar+fKNO6r5kL6lZgZNj2vUQ4uvu
 cslgbQSITmdSxkiIaD6yTjvRgac1ojnU/ikEHjkdhTXRiZeFi6ahYTiUvfIlpnxgZIcq 0A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpj12u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 09:23:38 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:23:36 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:23:35 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 09:23:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YD0w/b9QNfIk7qH3r322C01TvgXsbG/KKnnFjDqrqrBtfuorx41W0l8Gy1rPA3zYh9QEHPGAUhpznqx9Kuy3nFcGgy94NHvRb2OKEuBjMXTS984zmPu31uH+iTak0k/alGXvdqj3PyhEVfRGTSYiVGty3jmGKerzwImDlKXDby9ImlqknRtav00ZDtIr5qmNw8rwYAjplLND7qjNQUzHjAOG14bnSKwq9YKz+fPU3voCZY+9de2Xq0a6T4NCn/V3xsA/uTEq/I+mMW+rW9EJcNze7JVcxEyyG6D2Pv9O3IIS6+/4+7gRXUbZK9i+0WFhml4Fl3aC+JiXVJp9D1fA2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7sT4LZ/vVHJI+cbMhenJvZq63GCCYX7VwUZ4nnmLrQ=;
 b=WWKTUOVcwfF8it5WnJ6EHJzHOdXcJ9vgL7E6kY5Z5z1usLeJAFY0MRKhrgXsekGWtJY/TfGEHX7ZKo2ABDVX2pL7Cxkc3e/IFMR+aLvqb73luJxlSvT0Gu1RRXALHuOHmNVCCW7FMuUh8IWUhx6liWGVO5quCJr4Gufb1BdrnamxvF8zEJTqsyj6fTld3ZeMZfMrQb8avz8kS9aguDw8iQ4Sz0f0cChRDSpk8ZaFSVbfrZohqlsPee+EtRhG2cB0nWl7PGV8YeyeC+CY6uefJuBiy1kW8buEglgvT81tzjl5j4KSzaK9f1XwDSIpz/rdWeF0XIml9inWqO2W7Q+EOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7sT4LZ/vVHJI+cbMhenJvZq63GCCYX7VwUZ4nnmLrQ=;
 b=Ei3yuV/FDhQmyBoyKmNFVcJuJY39eQ+XLe/DD40aIz4HbfZy3+YsVlziXbv/X7SbMkZFPoDfAzbxNLpINp7UAy2WfQu7Vub5pc4UcIgSZnfZsmin11jyh18d+yhMHIB6RkKs1NOmcVeGDH3UFrjaa+HYimuqt4jg1WJU+euBhIM=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1503.namprd18.prod.outlook.com (2603:10b6:300:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sun, 10 Jan
 2021 17:23:32 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 17:23:32 +0000
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
Subject: RE: [EXT] Re: [PATCH RFC net-next  06/19] net: mvpp2: increase BM
 pool size to 2048 buffers
Thread-Topic: [EXT] Re: [PATCH RFC net-next  06/19] net: mvpp2: increase BM
 pool size to 2048 buffers
Thread-Index: AQHW52W7248KG+94J0qbFfsErMima6ohGPOAgAACQxA=
Date:   Sun, 10 Jan 2021 17:23:32 +0000
Message-ID: <CO6PR18MB3873037AADDF8236985FF055B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-7-git-send-email-stefanc@marvell.com>
 <X/s1p+0xCOi+BYWO@lunn.ch>
In-Reply-To: <X/s1p+0xCOi+BYWO@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42391c88-d9e9-4c43-e78d-08d8b58c7431
x-ms-traffictypediagnostic: MWHPR18MB1503:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1503D82E934555F0DA1590BBB0AC9@MWHPR18MB1503.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xda6NywAjYYf2RyWecAWJ3yxXrcYsS032cGMlsutkuccLcqcInkhs6IsVyWuURbYoZiYFqN6B0q4sNM3VTndAowq+jHJQPmfN2SCzDa+TJiNEkffNym49HGErQNeTMk0ObSG8yLQQK1OMVgFc5j3VifWNSh4Qe26JGDPqLOKXqw2NgKoCG/O8P0ajhs62vGiewMK82NPyJYCBvChW4kHfMpxiWa4RJv17MMupweV5xAuBwaNmjJOjXKLdj1xoKWqmYRreJ2YlkBGJ/M/HgwN6n+Cc1VypByRYw/EvgYYgdAtE+4ZrYiKGis5BzW4aOvXIsvQ4eNH6Hfhw2R5c3K6+TiJddv4q0do+XsnYvlXaJctqgk+kePu+AV2qbbbo4RwbLt4NhXJ3XieiesQ2Kq3pQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(76116006)(86362001)(54906003)(66476007)(52536014)(316002)(6916009)(7416002)(6506007)(71200400001)(33656002)(478600001)(66946007)(4326008)(66446008)(8936002)(64756008)(66556008)(26005)(9686003)(55016002)(5660300002)(2906002)(83380400001)(8676002)(7696005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ohdUc6LjtWsY6XTDhMUnjA1sBW+bIc1RVcyqCEJxcXXZv7LIxqgkXiMUYGVr?=
 =?us-ascii?Q?Z30fC3E297cz6dkhPITetyrU1YIHIU8JPGixkXgRxlBD4VjXKQbA1iDCuXzM?=
 =?us-ascii?Q?hjnkwPZqxJi6O1lR7d6pecltwce9lp/kC9vF5/Pj1yQBawq5DO8Jo45Llh9c?=
 =?us-ascii?Q?hzyqB9x7/HCxLGomLAv17qGxnHvGz1LfOZQGbfOrGoXAwZDG3egU4rPZfUQn?=
 =?us-ascii?Q?ICR2GLzNp8ejK52umY++qfy0oBOirMr8EK4NEihQvmOBIYACNctsOOxPQDCQ?=
 =?us-ascii?Q?3rHIGjiMHlIndHxzOXoogE9vFna/V2ATwmKaX44PZwoJM/GEZ8rh04KgQdlf?=
 =?us-ascii?Q?gYt+6C2p97HggUrjlJQhhQEhvcVeT07tM9zpnMLilB0d4HScIJgoEFgQzQ2l?=
 =?us-ascii?Q?xDoIQWNBViOYCppBAoXNjETPhOk0PgG9UQwdjewecDP9heOpMyiTb7OV9e2r?=
 =?us-ascii?Q?0emncoI6d+XmJVZI3iroPspDafpSraCVNPhuk0XjxTLgzMZDUtUgNXm/6foi?=
 =?us-ascii?Q?2PpGcheu2IpkvOP1Zqj5rnSnc+wbbTtbDqLa7rZ/cJtx4fbALpHoVvkZkk43?=
 =?us-ascii?Q?FADBrnbX6YOqjCh+rX+wjqTHQk8EuyEGxNVL2sHHSr36kkknMl4qsHAn+wSw?=
 =?us-ascii?Q?ePi9lfVwaOPNj5+552HCrxc2jrEelD3sZZxuYs11xwiVkFSiAVUjdapWDkKa?=
 =?us-ascii?Q?yLwe+/EdXBHDL533MX0tQi5ODmNsT77QpMSIWqYHZNlvLyuVo/+UKwjprg54?=
 =?us-ascii?Q?2YltUFFA/gwGmRmwZsp1mzB+Dahl7fWuG2/yKRWhQYH31MS8Sr+rWgMblUMJ?=
 =?us-ascii?Q?AUngGqac+wqO9O607nwM+RLpx0cx+cOK0eaisuAoQtHHmyNYceUAqVTr8H9b?=
 =?us-ascii?Q?C9LgxEBiCvirb8IwRK8QAKPBKHSbgRtRzexhIVOvIg+l+AEdIH2XRG06OIxZ?=
 =?us-ascii?Q?ZD/YcBya7G2JVhAtQi28YfDGhoQyKQpY92ujubtUDxk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42391c88-d9e9-4c43-e78d-08d8b58c7431
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 17:23:32.0967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9afs0HlkOVpjxSxvk2kJ68OhI7+N/TEfcqxDL5oVt6bWWHK4xf9NczZb1hLDLBQeU+//3bV4hvEGZ55xr+vkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1503
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> External Email
>=20
> ----------------------------------------------------------------------
> On Sun, Jan 10, 2021 at 05:30:10PM +0200, stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > BM pool size increased to support Firmware Flow Control.
> > Minimum depletion thresholds to support FC is 1024 buffers.
> > BM pool size increased to 2048 to have some 1024 buffers space between
> > depletion thresholds and BM pool size.
> >
> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > index 89b3ede..8dc669d 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> > @@ -851,8 +851,8 @@ enum mvpp22_ptp_packet_format {
> >  #define MVPP22_PTP_TIMESTAMPQUEUESELECT	BIT(18)
> >
> >  /* BM constants */
> > -#define MVPP2_BM_JUMBO_BUF_NUM		512
> > -#define MVPP2_BM_LONG_BUF_NUM		1024
> > +#define MVPP2_BM_JUMBO_BUF_NUM		2048
> > +#define MVPP2_BM_LONG_BUF_NUM		2048
>=20
> Hi Stefan
>=20
> Jumbo used to be 1/2 of regular. Do you know why?
>=20
> It would be nice to have a comment in the commit message about why it is
> O.K. to change the ratio of jumbo to regular frames, and what if anything=
 this
> does for memory requirements.
>=20
> 	 Andrew

I don't know why it is half(no hardware restrictions for this). I would add=
 to commit message new memory requirements for buffer allocations.

Thanks.


