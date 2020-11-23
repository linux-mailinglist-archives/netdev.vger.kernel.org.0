Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45D82C125D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbgKWRs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:48:56 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16568 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbgKWRs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:48:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHfXd7007843;
        Mon, 23 Nov 2020 09:48:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=ijDFq8BFr2opN7tsAzH9IoOhpougPJDZpMZHrp9ACmU=;
 b=HitKXqSTxU/orvpwgzry7JTI1HyblWdVfqdhzjcCWZU3imnVuALRIi4VZXoMmr6S8KIN
 8Hc8+U64uHSbXVEQMa5v93NcNAEqpfDD6066BmdIEVJiyRye0yvNgCdwEkoMKd+WtrJT
 jhQoZh77h22mF0ZFBZchaE+mqKJa6WiA2xamDRjB0r3nrfuejqz0qbEWHmc+Hpz/DI3w
 1KDag6kLR9sjUbSwrNWA9jIpEDu99wsnkQzL7hoObbeV70SWxBfswAb7dWRv6L7/oTbm
 sLfiXyRg8LuIoYSmNTB1mvNYmY8SVtrFXZBAvoPnXLIv2u9uYCjUO60bO7VYCRBSOhPh QQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34y14u6sxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:48:44 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:48:42 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:48:42 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:48:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9dJuu2+FmkxI1ROcD7pjt09LCzfaNXs1ucnNVHiRsxA06DnH1TKx3jmj0Ox6y4jJytZZM2ckxZpDTQBXnzCDKuNJtd1S2k1SAtXsGTGULhT7rD1oeYmNaMy483a7dhbvYVZnj9iCjuJYSV+4CKcEczl/L9TUsRNM0ZbHa7E1sFWwHU+ClkrAAC3Wr+Tzjbv6GevUkfCAlIJgpvgzCsHhkrEDZDIF4yiC7jzqUyhUJqNnnZM6cSp19j6JMczVJ2TsESVIVXfO0tYv4If/6mKY4V2l564DlWsSHjDriaHfbEFzO7/do2RuWoCYAfwPeboOMcj0vXevJTDKARcHekJqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijDFq8BFr2opN7tsAzH9IoOhpougPJDZpMZHrp9ACmU=;
 b=dVvXTXwUqRt71cbHbQdiYyOWmZRaHuDWY2HFkYoRigzIOPgtNT8OoJriFCwFEtvwCtA8xoF5ekE7HQroksoJ3Xp2xkIlYSQGR4EtNRZeEb02XvOxTSEkmUJo1gAyrk4pXFUrDsiCjPHDfGylxHJhh3cUIQddU/igwnnNyrHa4vERrLFebEd5mozvIQyQK2LbguJG9CcC5pOHD03b7MKw/tEUznfi0UIg0+UiQP3Ge7QbcXDSr+3seuSXa1F/kNgt+oedF4fnK4c4KD7l3MnypXd8iiiO+DuvMGtwdYCPg1sQwz2/ltKn1ZguqZcHHxMyYQ48l8Dc58LQQ6j5YINHww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijDFq8BFr2opN7tsAzH9IoOhpougPJDZpMZHrp9ACmU=;
 b=V45zGFaUbzU0DORJoojGEacyyi6JQMX/RKYeoieJzHW9tV8ix65MCiLYwHDwNsSn2UiFSGKTmF1NyacgevCsV8EpKRZWiKf3oykCL1fIZcRnW1Biq4H9p3rqFJKuP5itFNFSzWOGbQx/zsPaeYthHVNzBzZ3tqW0ea6bKXkRZmU=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3546.namprd18.prod.outlook.com (2603:10b6:303:57::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Mon, 23 Nov
 2020 17:48:41 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%6]) with mapi id 15.20.3589.022; Mon, 23 Nov 2020
 17:48:41 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active ports
 only
Thread-Topic: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active
 ports only
Thread-Index: AQHWwahlp9Sv9guVI0awfVNHHhZxM6nV0laAgAAAoWCAAAW3AIAAALaggAAEZQCAAAETwIAAGmOAgAAE9lA=
Date:   Mon, 23 Nov 2020 17:48:40 +0000
Message-ID: <CO6PR18MB3873F0E32B4EC9565B061995B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
 <20201123151049.GV1551@shell.armlinux.org.uk>
 <CO6PR18MB3873522226E3F9A608371289B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123153332.GW1551@shell.armlinux.org.uk>
 <CO6PR18MB3873B4205ECAF2383F9539CCB0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123155148.GX1551@shell.armlinux.org.uk>
 <CO6PR18MB3873FC445787E395CCB710E4B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123173005.GY1551@shell.armlinux.org.uk>
In-Reply-To: <20201123173005.GY1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.66.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa2638f6-ee1e-479b-444e-08d88fd803b0
x-ms-traffictypediagnostic: MW3PR18MB3546:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3546C48965074BA27CF8D63DB0FC0@MW3PR18MB3546.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h0A9Ad2lvS6dmTlMrDFw57cZebVbw2tt6JVwD5HS8rm0CXuD1wZWlFv84/I6FyXt69Re2dTURC0NgM71juOhHxb2Amc/L+FYEHoUHjl8aRYpdSVGJOApO+sN0Za5+uS1r2iJ4S144tAMCHT01Z9pdz9j+YWeZY2HE9uV5vIBbwBjVZ2N4IRh1UxtH5m2ZUSdgxyZFpbkZixtbcuItjGx6r5242h1c0xOt/+4eqNS8F+t90fjam7e2b/3mdTY8iqPqpV9mXMXfqupGBPvfnFyc4IJLzwVrAlU20sr1C5soRZ8lgwQDlqgpbwrzpjWSisVAAqo7J8Vo9vuc0COh6z4sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(76116006)(54906003)(52536014)(8936002)(66446008)(66946007)(66556008)(7696005)(5660300002)(71200400001)(26005)(316002)(83380400001)(86362001)(6506007)(66476007)(53546011)(64756008)(4744005)(186003)(4326008)(55016002)(9686003)(33656002)(2906002)(478600001)(6916009)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Cw3magpZeHLAA4WPWHgYpaI/Y++yO0ldGoZ3aZtOB4sRpDGm+PaJaZVXrJFR?=
 =?us-ascii?Q?mGp+hBnW5t01ghxaNZfuuqvfMrIEMf0zY/nSztla1B9lwrIvLPZlFeodMGgf?=
 =?us-ascii?Q?wcVXl6NXTkI2Jqrn+Tw2puPSYUtpv+s1TzWxNS1oR47ibxSQWvXbrMNrm9+v?=
 =?us-ascii?Q?AnA+Xs2dWwO+PgZPgMVoAYigapdzXhmC7axRYj3qTu2BQE/lboEJ4glHQ/Ll?=
 =?us-ascii?Q?Phth5pNQTY1DTMa8o83aAFp/UTur02/T7IlfrFv/oz9Wm/youwYK777iASJT?=
 =?us-ascii?Q?bD8I+ejGYoZGKjqVUaai02zFAivloyUvC6BKrkEZKNQnQji9YFbEa0or3J7z?=
 =?us-ascii?Q?CzPxqNp/OBAcGm5QYly8fJVoNWpFvzw2hjPcJk3uP51QCM61WD/MneTt0Oeb?=
 =?us-ascii?Q?7+GMe+dv8Wo3LkS4ZrIkyF8nFL3L57RsEm8xiDpR4Xj0n1Y8iJ9P5iY4lkB1?=
 =?us-ascii?Q?fOu0z3ecEtCmwulK00G30sqa2bbzg2oK09dVXS3yHNs4Wo1PlerVhoefKxhP?=
 =?us-ascii?Q?euLkAVrvErsGfsadiJFW8uwy9pojOpq7pP0HoB9serZdDFzz5xUphpmTOR27?=
 =?us-ascii?Q?8kEiTXxoDREdV+NTQ1wtC7JiVLoxRWcoa+IgSdsrcGfS8I4VCYwblbe0PlTn?=
 =?us-ascii?Q?J/K1SK4LTQKpzL/F5pcqJr1Ix7xSBkj7P9ZZzCFfiyFo2kdZFWY8NiyFbLGt?=
 =?us-ascii?Q?5bZg5JHhc7qNy2LFw62goWf7st5GTDqvqJJcYx4jMCbi0CfTLcEYIGxAwe7I?=
 =?us-ascii?Q?ddUE9iKRTBBLMhEpNO64aeazLh9qxIX0BRvkq1h9MsCDAM12wLcyJxnwscjs?=
 =?us-ascii?Q?/kLL9CTuX8zYExU5REF6Vg9+jFUQrI60lY0/4gP46ZBpznBy/5bEThwceh7r?=
 =?us-ascii?Q?J33/TIzUBj9h3JhSow0GShULqwh8pu/TXH9FbylwkjVzOBv4iBqfVdaAPvvD?=
 =?us-ascii?Q?xjVtnoGATFel7aeNArhBQaH9BNVxu2y84dXT/SilrVM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2638f6-ee1e-479b-444e-08d88fd803b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:48:40.9013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XyPjM/djEfrDq8UmHSiG+E4K4xHwRQE6FAGpe4dPe3G7zqAiicoiGKvffF17AgevU7Eew8E8VyMqpjbwSGdMUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3546
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Monday, November 23, 2020 7:30 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan Markman
> <ymarkman@marvell.com>; linux-kernel@vger.kernel.org; kuba@kernel.org;
> mw@semihalf.com; andrew@lunn.ch
> Subject: Re: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active =
ports
> only
>=20
> On Mon, Nov 23, 2020 at 04:03:00PM +0000, Stefan Chulski wrote:
> > I agree with you. We can use "max-speed" for better FIFO allocations.
> > I plan to upstream more fixes from the "Marvell" devel branch then I ca=
n
> prepare this patch.
> > So you OK with this patch and then follow-on improvement?
>=20
> Yes - but I would like to see the commit description say that this result=
s in no
> change the situation where all three ports are in use.

Ok, I would repost patch.

Regards.
