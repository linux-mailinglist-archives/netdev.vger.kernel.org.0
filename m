Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413122CDA4A
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388407AbgLCPpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:45:17 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46660 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387680AbgLCPpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:45:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B3FOogQ030868;
        Thu, 3 Dec 2020 07:44:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=yFn1nLkIJ5C0xbgMGlJS1cDAcSLtWDDhb/E/c5g/1eU=;
 b=TV21MkVQeVmGeH+u8SQiWJBiBZkz2rEiopkf9R9yUkVAZUA4E9VGtn2BQj+/QlQ+yyve
 ZnaXXINod3L8cQMtZ7w+E+jXr+1GDCxBdFHuyJrVcIUAXrYciOCp54jVa3+gveAXRKCW
 sD95QdRqM6BrpfKqLVWpY5M1zPbLtTOS0UbFTzlvko1/WNmoA/vHXaahjkeyupj0+vW6
 XxFzNjPwgJyuORa5cPxK2mrdx3ZsovfbV+pKsFN30ZUMxORAZtONkvEQQvEbKq1xAf1p
 MZaWkuqHoH4BhDhE0nHhz0g1gH/DYi20ZwQZFBkqRb6zVxDMfUb+wOxhOgLoQ6HwVpT9 AA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 355w50e53s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 07:44:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 07:44:25 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 07:44:24 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 3 Dec 2020 07:44:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEFpNmFO3dukG0GdhjwUgrImYWHQm5qzHm+Xk2lA7ghkrEvFyIEJC4iRDCwjvKoXlzFpiNXq5NQxiuQupkmHz5pSVoQWR+eX6JuJM/yLESWVcFVCPlRO4d9aRQL2DrQUdev1wWyrTkQtdmNcfSfTVyUWMnNw1abo3AF6aywQb6piNXx1xizrinZZm1Mn4qzIerf/oWFl1hEATH603Kxp6WedvnHuBZh4bG7BksEUGcxMMWMCITtWH6tn2yiuyyco8uSi9wFrYv7upAhvkJn6/Sr7iPBOBLm5ZHI9boxThMlNaLcxT2PFk7OvGO1pgTAXUH8TZ0khzGUXCllR+Tjp8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFn1nLkIJ5C0xbgMGlJS1cDAcSLtWDDhb/E/c5g/1eU=;
 b=lQxYYiUr01nDoLUYrP/QNwjHRLZ87KcxGYunW7IVYeGRPY6w5nYzYHAB47Jy8/MpwVyij6ktE75UG/jwpmmcEmOsA/Pdl2PqL2HPDbhn2F2MC3wP66B0uCYT+HbhsavI9in7O3ED2TLQfSuYyyKCy1t/RNs88O67Q1jr0WvsSBatNM1KWiVbRFrkRF2GFQIzTNtmULO9k0FxL1tsxEqHPAOn66u7Aaih3aNHelGdPyDs/IGsXLXAAYLNmK3uZ/O+OOMetnQ4PM13rewh9+A0ajVIHYN/RY5u0V/yk3WktTv3Lkvy97+jbJ2yhxQRzupyoai4tvPd9BJyBbAUv01Hxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFn1nLkIJ5C0xbgMGlJS1cDAcSLtWDDhb/E/c5g/1eU=;
 b=ThFf+ePq6ZyHYg7lqAzyGeiHIGdq8Id0QGLgj2vPB/v2HtOKtREEo5BvNQOkUM8A4i5a3o5fNT8BN9Ai+ImG8Cf8GWpYepMV1ITqBUyniQppT/iixPClDqagfrr8YZ0AZG+HMIDWw0MjEl8q9DVrZ9HPuYka9u2j9+3E/G9WGWw=
Received: from MWHPR18MB1598.namprd18.prod.outlook.com (2603:10b6:300:ce::21)
 by MW3PR18MB3594.namprd18.prod.outlook.com (2603:10b6:303:5f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 15:44:22 +0000
Received: from MWHPR18MB1598.namprd18.prod.outlook.com
 ([fe80::102b:6c9e:1bb4:7295]) by MWHPR18MB1598.namprd18.prod.outlook.com
 ([fe80::102b:6c9e:1bb4:7295%11]) with mapi id 15.20.3611.025; Thu, 3 Dec 2020
 15:44:22 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: RE: [EXT] Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Topic: [EXT] Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Index: AQHWyVwX9p+TCf2pwEWbloXbKFzXAKnlcGAAgAAPsCA=
Date:   Thu, 3 Dec 2020 15:44:22 +0000
Message-ID: <MWHPR18MB15980930483CA2F0BB657E95BAF20@MWHPR18MB1598.namprd18.prod.outlook.com>
References: <20201203100436.25630-1-mickeyr@marvell.com>
 <20201203143530.GH2333853@lunn.ch>
In-Reply-To: <20201203143530.GH2333853@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [93.173.69.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0727983-3a35-4fd1-dec2-08d897a24e3a
x-ms-traffictypediagnostic: MW3PR18MB3594:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3594C0E7B47FDBDF27FD34EFBAF20@MW3PR18MB3594.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X7PwmA0AFnkhQsybbz/TW44qyShqwQADmUsug1ymdwEFaHv/uAkQ9CtvVp19ynERHh2ZaBCK2vPBh39ZjwvD9oIS0y6Xy7fMrZ0T3dLV/NY7NWM4kuXgsrZozWVOTZp3Zq80DB0cQErbfO1bhiSOzxyIkozkBByjG+q7rw7SsYh07XNkjCq90MoVKd9XUP0MGVcTkE9ErF3Ya2zLklJy4Xg1NlX6CKyYSoJzlKtOWqvKraTt4pLaX7hqKufW0TE6DZ/6z8aMteQ5jZ0YIDE7OP6mthxm/uIstzOO9rGgW9JZhVM5Qs39RSrSQ8al2T2kyhsyb42Irj8IK95BWC00AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1598.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(316002)(9686003)(4326008)(6916009)(8676002)(107886003)(52536014)(4744005)(66946007)(5660300002)(2906002)(55016002)(64756008)(76116006)(66446008)(66476007)(66556008)(8936002)(26005)(71200400001)(186003)(86362001)(54906003)(7696005)(33656002)(478600001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ENnqeS1CNIHpuGuI2zOtfOFV7+sUhytCz8xWoqmaihQ7C/dGdm0ZOqlyMSIm?=
 =?us-ascii?Q?PJEP71GafOjpOPEKSYrbrwK/bj9BQ5WKcP7GihnqgljfrPdPsGtIwkKjTY6Z?=
 =?us-ascii?Q?dEoK70pC1PRmIQBq/ArncsvG/0vaZD5Z4KFcLamdooTsdfpCNxEwAfTYbIiE?=
 =?us-ascii?Q?vYilDQbiX6iOoghSu48A3lQpgqCkzOzdMGXAFOM6KhdwqXTsBKS6ofW5eCWu?=
 =?us-ascii?Q?bjHfYjIE094hDeh6PDBB5FFINGgPydaTC860CfWGcOz3cISEd0WO56L9WFmd?=
 =?us-ascii?Q?RYGBWgBK01QemzoHDi+RdAZx2nUoazDGjeoeiCSfz23/8FVkhPEjfS0+ZInU?=
 =?us-ascii?Q?wo1p7yAaq+TaYFuAjQcKmyrT7rH3U3XanAE/sZYxjC7tDp7LuOVA5gCBR7N8?=
 =?us-ascii?Q?o57qi2n5+O6trQl+ZV0FiV0SwcBIC/p9cSGh4nYRThfJzt3HYVf+gqg4zxsN?=
 =?us-ascii?Q?mIUCgNNb6xx9jxoQpmDuEAaGDelWCWEo00DAETyOae5DMICMmHuwPrTjuRQc?=
 =?us-ascii?Q?Fk8rEkV/7SaiJlZhJusl13tEDH03FtKLRciP77uMFZ5rOIePAXu7a8CVV0JF?=
 =?us-ascii?Q?fAavQ4/rKpDd7SG84LwK3uz/955FrxrGHSYEr3ZT+wtuDM+Ztvsym8CjJX56?=
 =?us-ascii?Q?tTodgrTjzGXYQBgIdgGs2APyGnWGn3eyctYh4hPIRr9xn7IsfD75SneEggrl?=
 =?us-ascii?Q?8OYBvg9qzbt5cp9LdLgO9fC2TciZqzKWW6a7RnT+OJoverPPCPdpF6wEtHd4?=
 =?us-ascii?Q?Vk1dW4XluHbRYAIBAnmOgpR+UmKEUlsiWFxbemh/G+uRP284o8ZVWT1oykgR?=
 =?us-ascii?Q?rxLfQkS1PCEVnzKZKq0Ki9c50m+0ysR5w71/4tlduR5bRgN33q8dhnNOiCqB?=
 =?us-ascii?Q?SzCtzJ7OrFr+fqKGgQlYK1DhlDI68z0JiMuWfZ1kdFZOkimq2JABgpBOQzSP?=
 =?us-ascii?Q?serI1wJ4MvV1UFb6xbchemhKUzmByCVnQXItbeiJgbM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1598.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0727983-3a35-4fd1-dec2-08d897a24e3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 15:44:22.3643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9c9y+VtNBmmyeDVlBYHVbEf0zWC9BgahLto9IVeYSj/9CYhA+PGBkbTK95jd5vRtufShzsejWI8dWOV1Cg/xBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3594
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_08:2020-12-03,2020-12-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 04:36:00PM +0200, Andrew Lunn wrote:
>> Add maintainers info for new Marvell Prestera Ethernet switch driver.
>>=20
>> Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
>> ---
>>  MAINTAINERS | 9 +++++++++
>>  1 file changed, 9 insertions(+)

> Hi Mickey
>=20
> All the commits came from
>=20
> Vadym Kochan <vadym.kochan@plvision.eu>
>=20
> Has Marvell purchased PL Vision?
>=20
>     Andrew

Hi Andrew,=20

No, Marvell didn't purchase PLVision and I can understand the reason for th=
inking it.
PLVision and Marvell teams are keep working together as partners on support=
ing this program.
Vadym Kochan is and will remain an important contributor on this program.

Regards, Mickey.

