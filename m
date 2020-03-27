Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF377195013
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgC0EdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:33:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53486 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbgC0EdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 00:33:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02R4VWae018267;
        Thu, 26 Mar 2020 21:32:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=ZsWmBkdOgGMNX+Z0wvHmi5EkFCizwd4qATeuO6nEFvM=;
 b=tTOnoCNM6R9cyDq9pppppI8M2m+l71gKRIdzpyJAQ2irhqgOGc6zIZysTqWdX+XkltHI
 LWSfSnhCa3quaMcqLAUn9H3hdP66psa0UN33/zMyg2uF2kwpaOhLHzVHxyRwHUoMtBcg
 hIpf2Bu3IFoH4d0MmYABlSLy0Upo2ecLGlSVOOZoJY2FqadtprHuHGag1UlN2TWq1PUf
 ifLsEbf3TbufKdLLmB7gtBWMVu4VFvxB4RoD9BPUJh8qKKjuDasjTyZDxAEfhBUwGXfK
 KDo8PiGG0AQ4+IMzaO3rM034xcP9BWrXsc240HBs9z5wRFfpjbHIL27YIsDWKRkt6F+I zw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpcyf4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 21:32:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 21:32:56 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 21:32:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 26 Mar 2020 21:32:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BO+zuHFPBVOHlOSxRHmxfOZMJrB77c4Fxt1I7CXkexjqt1NGLGVGCsyj4f+u/jWrzGGTnIBCSsdX3I5murt1RxPztVqvkZAAk2DXoDZwO5OijsKe0crqY4a/vb0fzKX3cJrfI9X+7XPOPSqDLlz819GQD9VQYuJct0no9HyivRPiZElCxgO0TECE/HQHzUerOZTA9HrbUzw2O/MVPPlv4a7Q9vEy8omaga5M2ikN9oa+qJTWOptBDPaPVKVWJJ08GFLxAnLqy10mN0f7W9PcdfpSZ/uo++w8C7ztjdM91xVUOPJcAQoeOIHfC0SN+mCSEznqd8E+KgtGQ6Wn29VXJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsWmBkdOgGMNX+Z0wvHmi5EkFCizwd4qATeuO6nEFvM=;
 b=Oi5y4LOx4RVaP08D8KEGewbKE9QslERJZWjm4xJAWB9h775Q/xDEJvt8X/giMIFSLBd+6+GhcY99/6c+dMHnpupWRj7ESYR/T6hNSmfvPdVT9JC3HoPw/SsQdz2l948NsRPMS5SUyEWwr3ewRafbZ7ViHK6yiSpmkpXPXLlhp0H2iiG6kE8fNJT6cJAEXawvg00DuFJklZkxctIuURXo2IIEEUZmGcodMrWPMOq1bm51Ik3nRkACiydzuWZYFHCOA/1nBkg8YhJJcwrXjmkWPiGnV4vDtnb2AnIa+eBmuiOmVqHh2r0dwmQTRx/jTXEz9Dn8DGVmWLRf3u3KtKZ4IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsWmBkdOgGMNX+Z0wvHmi5EkFCizwd4qATeuO6nEFvM=;
 b=drQJl4bWjen4xgmGE7rPwQqDhnLfdA+E/KFMZ5k9bzuMBV/yQmwPzezmqJuO8AMrq6O7RSGA8VrUWjp/vwe2SaL38OZcAFOe6EDkzA+7sc6gV4e09kd8QxPQzAivTOHqSe4ABT7N2yNYuWS9ICA1DYY8acKqo+GLHCRAFiCb7fE=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (2603:10b6:208:103::10)
 by MN2PR18MB2479.namprd18.prod.outlook.com (2603:10b6:208:106::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Fri, 27 Mar
 2020 04:32:53 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::1c1e:d0bc:4cbb:313f%5]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 04:32:52 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH 5/8] qedf: Add schedule recovery handler.
Thread-Topic: [EXT] Re: [PATCH 5/8] qedf: Add schedule recovery handler.
Thread-Index: AQHWAz1ZcI0HmzhzSk6zCagYUxvzdqhbM+2AgACm7hA=
Date:   Fri, 27 Mar 2020 04:32:52 +0000
Message-ID: <MN2PR18MB25270CB792DECDD9D2E0CFB0D2CC0@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20200326070806.25493-1-skashyap@marvell.com>
        <20200326070806.25493-6-skashyap@marvell.com>
 <20200326.113437.734459979907572755.davem@davemloft.net>
In-Reply-To: <20200326.113437.734459979907572755.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c662455c-1100-4969-f587-08d7d207ea12
x-ms-traffictypediagnostic: MN2PR18MB2479:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB24793309BAFF3029859E1A60D2CC0@MN2PR18MB2479.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(478600001)(52536014)(66476007)(5660300002)(66946007)(4326008)(66556008)(64756008)(81156014)(55016002)(81166006)(8936002)(8676002)(66446008)(9686003)(86362001)(6916009)(76116006)(26005)(54906003)(186003)(7696005)(33656002)(2906002)(71200400001)(316002)(53546011)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2479;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1h++wTbWDY31ozdTCy8GyOdmUu4THfihiZwdBqV5hhtMiaQI0635StWHMXBO/GwOF0dkxGyeFPR+6GldUlM31IZ7t46xA9f5ufEnRrRGzduw2aclkj6mcR6+piUt/WLKU001N60Sgz3gy8VXry9OzsHvhnMM32b0Q3udrLUgwOVOf55jAVDWy8UNZqVXx+LxEkoXPEUcRaSceiZoDXKT7LZbfd8GFxhRK1AuDUCLuMRTxxiQew+hsT0klJWvRTb5kghKkuKAoqz7yGu35CPdyHIVS/524rwY3aqGpOm8r75YZVmnmviduvS9O3Su/tm6AW1ejfTvZLsn7A+i9kSRNdtpjAa0cKa7pW3u4n5L2rlj+KsCofndZ64YKsFt2Lk8nB/iDJdxdgrlIgS2LJj6OxttULJ0TDspA85IeopKC95pKM1EvVkVE/5cFRWSyxIi
x-ms-exchange-antispam-messagedata: knQpf+FN2i/CTjlLtNC8OJzBZkynH6e8Ub3+8a0YJb2U/7ITWzflsSg2NDOC+O0p5dOpfYcZoPQw0+XNZNQqUq3YwIUx24hOPsbo/OHuGXuoNcOwg2HnPh7orh7Gp0X5Tr3n/tt93/rqlYzgnbTZRA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c662455c-1100-4969-f587-08d7d207ea12
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 04:32:52.9509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p1W06TGOmA4mbDVqCsfxWzFQszW44lFEaIqLqn2j7KU7lWgFw+vkVcsI8yYkppi16Wk2cvx0JETyttRkzZg7UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2479
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_14:2020-03-26,2020-03-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Friday, March 27, 2020 12:05 AM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: martin.petersen@oracle.com; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH 5/8] qedf: Add schedule recovery handler.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> From: Saurav Kashyap <skashyap@marvell.com>
> Date: Thu, 26 Mar 2020 00:08:03 -0700
>=20
> > --- a/drivers/scsi/qedf/qedf_main.c
> > +++ b/drivers/scsi/qedf/qedf_main.c
> > @@ -3825,6 +3827,45 @@ static void qedf_shutdown(struct pci_dev
> *pdev)
> >  	__qedf_remove(pdev, QEDF_MODE_NORMAL);
> >  }
> >
> > +/*
> > + * Recovery handler code
> > + */
> > +void qedf_schedule_recovery_handler(void *dev)
>  ...
> > +void qedf_recovery_handler(struct work_struct *work)
>=20
> These two functions are not referenced outside of this file, mark them
> static.

Thanks for feedback, will wait for other reviews and will submit v2.

Thanks,
~Saurav
