Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EEA2B5AA1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgKQIAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:00:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33126 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726524AbgKQIAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 03:00:11 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH7oWle000809;
        Tue, 17 Nov 2020 00:00:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=qYl++5DRggIhbHCoGbH2UvJIXwlbSw5LfaH2YXVjw6Q=;
 b=DWkj+ra/NG+kiCc7p1ES0ohlzHZlGLrMOy1dSlAsfwEZgGAQB6Ly9Mngc/6judW4z/BO
 4YKOxB2W2KOlxvmXhgF6FtpdqTqZLyJ8SsQoPDvu+pSmdRO6pmGsDhVWvD45ysG6tYj/
 6gSuWztUOQ+XWJIkaT3ChMdFv73L3XvaP0C88qFB4L2026lMjQ3r/1N0sACWtuAVD+2m
 lfj8pUxHTpXHhNGjZctNV67pMRnA8TNjZs8o9ULNyPqG6p1Aa20uhep0tk5jVevorhBn
 rxhl4LtKgPdi8JtZYei+yk222QjWqo+6zjBEyKoLOJUtoxNqPElOWF8yibqhsB8b+Zqz Yg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdfu0ekj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 00:00:00 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 23:59:59 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 23:59:59 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 16 Nov 2020 23:59:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtQL+oej3RTkRPYJzGS7VTuWTTt/CQHA7X89n+RhzHPcm2EOBqVJnO2uv1PrfHfExNhG2QgopDCgAF3PD4ArSfLKfHICz+D8a8hez+84bIQH5guevlTFlw5CrHbjjabLghZGqkXFo2qe+jU2Aq/AP34JbNl6YaskmFxXojt+Zadt3XE6SPg0XkSy039WS/1qkeSZxdujdQiNAsUJlpC9kl0ihXCfYNzDqCYu7NDHZ+cC9yXiI1gQaewMWBAtw2IEcVh/5uvF53ecxtqjT3/mRW97HgQP48o10A77Ob/9VhgTbVbcjfYsSipfe/HA6AdlZFLy9XmBVx3kdSP/VTVTuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYl++5DRggIhbHCoGbH2UvJIXwlbSw5LfaH2YXVjw6Q=;
 b=I3kWNK+FPSrf1BjsLNrwgn2qJp7Hh4OLrTyB0mwrUjCSPdrzbKkhN95Voy4oDSzPPgUJsl2AJNIfM6785uvAyLyJ/3RF/bHmQz4SZSPV8iDw0yWWlFqCeSWD3Mk2TzsIycVjb0cPVvKwcb0yIIXJYTGZ9tW50my5Z8vtzBx3+5AOBYUh/gXgjoDLAlpQj52F1PIukCqytytUZTRy9k2xQDWJJxMhEw5WbGY2+umzyFWbCeqZp1GMc8BQGMdfuk1J6it0YwJq3/j0UCsu1ruptkly+ZPGqjX9iuCODY2OjiB3Zm7p5PBlXTVSzpcD6namwQjQYKirGeWx2KF12vPXHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYl++5DRggIhbHCoGbH2UvJIXwlbSw5LfaH2YXVjw6Q=;
 b=faD/8ZvkO0pswKSDIDoBnEXEGIpWzLl6OFHjnAIXuXaPiFg1exalP2tjN7wezxcD42dKAaSPsetO9co5JcdjgmnW9A1+U4VXr6G3KHXrPtgN2ISt+V6VL0LhybakFi9Jt91q1J81Iyh/SVNwSXVpOazAmKarhdzcdpJXVXxwd8E=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BYAPR18MB2375.namprd18.prod.outlook.com (2603:10b6:a03:12d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 17 Nov
 2020 07:59:57 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2%5]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 07:59:56 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>,
        "Lukas Bartosik [C]" <lbartosik@marvell.com>
Subject: RE: [PATCH v9,net-next,12/12] crypto: octeontx2: register with linux
 crypto framework
Thread-Topic: [PATCH v9,net-next,12/12] crypto: octeontx2: register with linux
 crypto framework
Thread-Index: AQHWuWtZWCV0HlTiDEu+re504pT8q6nGRbgAgAQKKwCAAauVsA==
Date:   Tue, 17 Nov 2020 07:59:56 +0000
Message-ID: <BYAPR18MB27910E1BA481946189F00766A0E20@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201109120924.358-1-schalla@marvell.com>
 <20201109120924.358-13-schalla@marvell.com>
 <20201111161039.64830a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201113031601.GA27112@gondor.apana.org.au>
 <20201113084440.138a76fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116062606.GA29271@gondor.apana.org.au>
In-Reply-To: <20201116062606.GA29271@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [49.206.43.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03b8091d-8f51-498e-8bb3-08d88acec667
x-ms-traffictypediagnostic: BYAPR18MB2375:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB23756D7E06369267F990D3DEA0E20@BYAPR18MB2375.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0nhi8uxtiq/PKpHe1EkUXBe4UyudCcVnwg32iVuYW4H/La7EvBE+VxuCFk0wuEJaFxKGu2V2ZzyipX6xd7KCm6ku4tfuWqmA3iQCNd3QQ/De1RgIh4i6U54atrw4dHG+Xx8ofhEc+LgJ2DOmnKzWJl+vgTeQF2gkTvv3MaJ/Z4GI668w2Ji4bEa5T8gA1E+VzrV9MaiIuljCMyR9/lGa1bI162mIuEg8Qss1U3qXkNx3tY0BDcEIwakfEYuffsqgZKs/cGpxW1JB9SyXE9sOhDCwMFBowVOr8xYBj7igl07DxoQ5DSl/QVlNNurgN6gx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(55236004)(7696005)(4326008)(6506007)(186003)(26005)(107886003)(9686003)(478600001)(5660300002)(316002)(55016002)(54906003)(110136005)(8676002)(86362001)(64756008)(76116006)(66476007)(2906002)(33656002)(52536014)(66446008)(66946007)(66556008)(8936002)(71200400001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /lLK3qRmCCnRmNO0t5JxGhnUTCj3lPw5DQfJpT7xDWjM4pqpM/E5JpupVrmE74x+WQ1/NVkgY6G5SGl/4g0VXAtL0CTpGBOy3NvW1dtUT9fYotxe0G0r+wx+ERUTCocrchQhIdf/u/6brWuYfJGlnCeN7pSAneLzPRa0AOYdg2uygN5CkWKaTGqFWKrlKDH642UvwNMXSa1DcGW7zQuDfNj8e4o1XFhgMHoqOa27lIYRAe3AFOQC3ERoJyORy6WU+zfkVggFOwR3Nk/uqIMUiiPt0rHHEyZ5lhkdAi1GZ1cfUcr7km42X94mcTiLNn0rM7n9k0bHAIF0dpLOtptSdQBsve07fC9+9fgs8KqBHUoS/HTjDboD4SxWScj/2KdIblt2YFAG2adXk4tssQyBIXUtZm40urWyZ4hcyIHviI0AkVD1/9Xzl+jQU8VaT8vWNLT37sobh0wCWPrqjZ6nSi4dDuQWc/vPmOjqBZMtw+5UI1GRN2y8WUK/gKq4ZAqDmFkMRMUrAS2vEgIc+gJ7SP28czfVrWEAag2orV7AOjM2ZQYatvG28K2JcY54LZywFgYZ/rzCIVYv6Y6vlOXc7zZ3Pv5TvQYrHp8LpsByUYHsTWHpnQwu8v3t0DU1kwJOTurRAKGFzyt7xNywIGoo5LuUMoSDKEIxA2uLX8rh/iPXLZhxvaQ22vGKpJv6FzDYkLYspklS+ONL1n9QZGvG9B5cljgVWqVOtTUsBP/OmfYwYJjRHJmKSjN8WiTiW6/TVeeGhwl9eCJO9ewPRc8F8zkAFE93jtxC+o5+/Mmuq24TEGFfWyNyRIDvBHDUS3RWA5/Vs+oTgFzDt7Sh1pgH0DmbgLTB44CauPDG/46GSRit/liptmqlmUmvVPx0gCpmivpsIEhrWv2KZrV2fkkuoA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03b8091d-8f51-498e-8bb3-08d88acec667
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 07:59:56.6867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFrlbQQVVkuWTeHAhxZeUpcgUbAKjLIPd6YLRB4i0FvdzSZxWP5yD4Q8zAbzudkq11i9BxQCW8Qex8CZ5dFA9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2375
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_02:2020-11-13,2020-11-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Nov 13, 2020 at 08:44:40AM -0800, Jakub Kicinski wrote:
> >
> > SGTM, actually everything starting from patch 4 is in drivers/crypto,
> > so we can merge the first 3 into net-next and the rest via crypto?
>=20
> Yes of course.
>=20
Thanks I will resubmit patches 4-12 on crypto-2.6 in the next release cycle=
.
Should I re-submit patches 1-3 on net-next now?
