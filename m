Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346523022BD
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 09:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbhAYIUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 03:20:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13986 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727204AbhAYHUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:20:02 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10P7FU7n030306;
        Sun, 24 Jan 2021 23:16:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=jJq4ygp82AFS8blNcgD4PIKjI5z/U4+e5F1vwKxksaw=;
 b=XxjmssKeBeclZo1xz+cIK4DUUSXjw0D+t5DOx6uws1ZI8olp9dkp1T8pnTp1vaiQT3gI
 g106NCOkRvyFqPpc5Cdu9qeLQ7jT9IkWsx2qOQlFEuozvNjuPS7+wvzINoeM1yfauA/m
 r6gOXGv2/F9HrUwD7dJ3fBs5z7uGGGdpRq4UFjTHo7083ou0gUForV4i2x6+a5yl4yNP
 PWEJAksglQXEPElpe+qMfIDdmDelN9mI46vV44eEDqEnS23UoomteEIWd7qUBUnPou79
 1EmkMYrSZmJ4a1xROdKWgI6yD/2RTbiNTDBbRT5lqhcxnHakOM1rsasZzSCOho8W1wfm 6w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6ubgjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 23:16:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 23:16:49 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.55) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 24 Jan 2021 23:16:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/A8KQiaydjUxd2NrrgYePHZy/dNLy1Cc5K1V5ZwO0ODpbXjFivDVOYB2gZh4mpFLkmjO2Njw1BCKVFpcAXvnZBxR2TtPR4Xmfs2v3aJAaCdSZNkRtbK4QTQlLzPvd4JXb/+KBmXR0XOgGYA2c3+ioko1dK6yGs8pLPNCkmEYswzKTkwx3Rh8fQRGVz/QJiXB6OwIvZob4Jlamqxg0e7PlfdxgnO3XpofVh5BII+UOQbbJ3/uHpvwCMp6wZWY726/9FpCT7UzB+VKzCVIchrvhBxrKqj4V6HuCTfpT/gi1D01OPZ41eIb8uNqVJfgvl7oY8y4+sVDCZyHdQVJr5BTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJq4ygp82AFS8blNcgD4PIKjI5z/U4+e5F1vwKxksaw=;
 b=IhvJfuTYDTKgqcfxp8kk4FdKAnfpL2H0Gt5UnkQF3HsWzfRbN+AUqh39GDJQ74u25GFqcFhqtwEzdvcSeoMtrmj6K1eWq018vv6yJo5bQvPphZ6sQ3Kc4SwiTanauG3yeW7HmTWQ7EY7Z4Hd3409rXuSBW17sQNWuU07GhuJPFF50koZGcOx0TK6/vHQaPDdjIxNI3lZh2yNUcrpZ5/+XxffrMC9n68p8GO7nsvdVv76Ds7EQyeO5n5oelvu1bYKkUbHoU8cnAUPngabNvE2Q0cGMunS7+xKyEweq+fvU+eP04AUAfO+ME4rulO4T6onwSoxXfpx1+Yjks03pXmV5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJq4ygp82AFS8blNcgD4PIKjI5z/U4+e5F1vwKxksaw=;
 b=n1ylGb1EsKTlYNJpTdU78z+0encbJL7+ctNsJ3NYmOTXsV4/WQsJ9U4osG4O9769RULYBP4mhN0CO5b8CJB6UcIKROY5Y4gAqDuKlw96pBXxxOBdfAdVKO9iITFs/P4+FCDX8lX4Ux7H8OPuhZw+V/L+xfQpogZgRPIQZ9QbS7M=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3921.namprd18.prod.outlook.com (2603:10b6:5:342::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Mon, 25 Jan
 2021 07:16:48 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 07:16:48 +0000
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
Subject: RE: [EXT] Re: [PATCH v2 RFC net-next 03/18] net: mvpp2: add CM3 SRAM
 memory map
Thread-Topic: [EXT] Re: [PATCH v2 RFC net-next 03/18] net: mvpp2: add CM3 SRAM
 memory map
Thread-Index: AQHW8kZbKEs3qTTDMUawkmJVCa5Q3Ko3Hd4AgADRgHA=
Date:   Mon, 25 Jan 2021 07:16:48 +0000
Message-ID: <CO6PR18MB3873091FEF05CDB3B22B1162B0BD9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-4-git-send-email-stefanc@marvell.com>
 <YA3Afgtq0thFDH6Z@lunn.ch>
In-Reply-To: <YA3Afgtq0thFDH6Z@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0b5c093-3a92-4586-4736-08d8c1012e15
x-ms-traffictypediagnostic: CO6PR18MB3921:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3921B42CA045D633C1089C66B0BD9@CO6PR18MB3921.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M9sZRLd/wSbzOglHo6wtVufG4yeCSZRBpTiPlRrQJOFoXnPVF6XFXzBzm5FCDO85/LVuUt5POuyOR9orKTui9Hv87WAMHeHUKGeGZCgM1zQ0nG7X9fXrspC8bp9jdxKiKw7on9s+YFTZjLc183WIESkqyo4dMNty/t2NX6UmWGqZdakz4RH+Q8/MG97KfzCy+dIgbG5PDrn5Y8i0Hvh4LB9M2IIfLRurkFIp+gf1f08IOxE3Pu6f28lxSElM8F1icNHKGbhJkJwjsF9rpwqXNn03uY2xL/C0xAIQ2yUN6O0DHrZyBi1Smb5yBvoivVRg6UB/DVLrTSQfg680PwQ/e0XyCW9wZ/pXMSaWi06ovkP46FJHXrpWKAxMu5You+cUp1ZKK67YJ2xx9zUgSX7+qQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(7416002)(8676002)(33656002)(9686003)(8936002)(6916009)(55016002)(54906003)(4744005)(316002)(4326008)(6506007)(66946007)(52536014)(7696005)(66476007)(2906002)(66446008)(5660300002)(76116006)(64756008)(186003)(26005)(71200400001)(66556008)(86362001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?R+ZH4sZSpmaWyKo5bxcrFRpjdsp6kiq2pIZ9fY+3OCxjYLNgKr4Xe/KNWXHo?=
 =?us-ascii?Q?cx6QowDRBEtAajFJvG+Y1w3IXufAg9Qk1NK6WMD49+IogpXSRm3kaQ7fljK/?=
 =?us-ascii?Q?N+SR+Epg2wKNtLG6G3BzK0ILJSotalpHksRNbMV0GiKzeODy1OY6SSXonC7Y?=
 =?us-ascii?Q?wssDCi1KH5tJvJscZuItLSpzc0oDwAIXki8SrfQEPp3lD/cpZGp+K781Oz+9?=
 =?us-ascii?Q?6twnDU2FPh4r8YQPdsfbGI/9UfYNjqn6CC93m+yINFZMSiMjL/ZX6Uwvwbes?=
 =?us-ascii?Q?uP9IDSmyKJOmWE9nF7s6vTGP6D+o79YBxmhXjWE73u9k3AXgH+/5Ki4qO36x?=
 =?us-ascii?Q?0BGKmw1nZ3/tMl+CMSJiQLSma++DwFPHE2HFg4jVdatw+OwdfTntGxUIqJFl?=
 =?us-ascii?Q?5suR5F7OGMUurX+m2Sk4Oo/CMbE47vJl+pGYG4pDUsJbg3lxcmVTpIjEp/BF?=
 =?us-ascii?Q?TRLlRFpyXQwmYqoLEm2jybPLtQhbWzhX090fDapn9z2uIVCVCPX8Z0NNcx+p?=
 =?us-ascii?Q?fBQpY+diWMRTl/Jq+fxxur+ZLBmIYgax5Uh8ttYpN2NZsRW3gjrHxCrY8/ai?=
 =?us-ascii?Q?4wASh5o9VEsMbNA9/ctyikF3mW+dVs9W7hf6lZR+k5j0jQIMnnvBEI0p81FY?=
 =?us-ascii?Q?PkEskc+VtFRpEe6WNwx9AB73Et1jxjBc47f7X9IOhAyYUSmDshUpOMbCRYCV?=
 =?us-ascii?Q?ZGN7eYExG4Yy/4iFuoTENahcKobtDtc9Dq939NkvosSVXyjLbtYHVARk+Pnh?=
 =?us-ascii?Q?SVJuoZ5OvtIGktjGYivDLAjAIkFg5FrELFEee8tnmApFdTIyV5F0ZBor/ZsP?=
 =?us-ascii?Q?bsZOudlLq2D5oj2miu+hPocqxoE6FA57FwdCQjr06MnEu3Izq8r8j+XWs67k?=
 =?us-ascii?Q?EgO8YeeGCCvreAXKcdxoXcjqOAc8D+fDC5L/D+ACg0/odLy+Ei0FX9gmfiEk?=
 =?us-ascii?Q?AnF7ZToRT0t+vN36FZ5BKUcjDQJV/k07uFMwOhLJHk1PdS6bYFv9BvUOr027?=
 =?us-ascii?Q?tgBmLER5WddmX3mt+cAHzkYmt3iCxuxbkJxikm/Tk43yTA4G7hJsmrjo0dEo?=
 =?us-ascii?Q?HVDgV7RS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b5c093-3a92-4586-4736-08d8c1012e15
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 07:16:48.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UCogETbrtIl3MDuDZXNKpgha5c9Vf3J5dJgd9tWG/yqC4IK/1EEeVLYoKTkl3uqmbStnZgRHnvyeEpjRP5tXLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3921
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_01:2021-01-22,2021-01-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  #include <linux/of_net.h>
> >  #include <linux/of_address.h>
> >  #include <linux/of_device.h>
> > +#include <linux/genalloc.h>
> >  #include <linux/phy.h>
> >  #include <linux/phylink.h>
> >  #include <linux/phy/phy.h>
> > @@ -91,6 +92,18 @@ static inline u32 mvpp2_cpu_to_thread(struct
> mvpp2 *priv, int cpu)
> >  	return cpu % priv->nthreads;
> >  }
> >
> > +static inline
> > +void mvpp2_cm3_write(struct mvpp2 *priv, u32 offset, u32 data) {
> > +	writel(data, priv->cm3_base + offset); }
> > +
> > +static inline
> > +u32 mvpp2_cm3_read(struct mvpp2 *priv, u32 offset) {
> > +	return readl(priv->cm3_base + offset); }
>=20
> No inline functions in .c file please. Let the compiler decide.
>=20
>    Andrew

Ok, I would fix.

Thanks,
Stefan.
