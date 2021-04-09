Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBEF359106
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 02:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhDIAsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 20:48:07 -0400
Received: from mail-mw2nam10on2116.outbound.protection.outlook.com ([40.107.94.116]:2625
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232426AbhDIAsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 20:48:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1cj5LCmoCFhbDaSl2KkgGHvNZjI+mNpNhlynoV2FCczaq18i9VjeFmql0k7C1ocAIjICxoncq/pokKLpcjsVI85xhxtQdDLK+5b9KXJsDG55kwBZ/6qucH6Sp02l/3TpEQAO63Dt5wY16Zhf6bpR/jqJfaU8mdqS7Nneiuc/Rr9EIxq0jO3vvU/N7ACLwamkSCrpI444ERHqmT3wJT3W9QqUTqK5NaZcAnyiCmsmSpmyz9/XsdhyTMZdO8Anzay6L28CU6IZB2RFY7X0/PD9nb5YfgAZRQ7hKtSb/nlsVpKm5JpplhBhTeGzL0m/uoUDOdhTbjrlLfMeEWx4T/8iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0u94xaffqzUo+IhsCYK+AoMOnoYPRv354eU4FYTEIhc=;
 b=eQcZxYlrKsE4yUcZX31dukm1H0A58/dom21ZmuUClKgDLbtC8YgMWiO48hwd2z/ald2uk0oGCqNK96AT/4kMwTZ7pjDvU2nIQ6/JRNSpNZ6wxuBB051gbQA6WFDMayitLhJnJdkn/r4BLDfHQyqxpD30v4hZGjFJ756OYMfHfcWVI3X0zxV+8SxBHY5hlim4SRFv0933wTbk3yyASGRijSjOzEdGGSRSI3FFU+Pks1TlJshwtz0G6HMht6Y3QzCnDDaN93PuywzIeEmqBPHTnp2PXUlcj2aSpfYPOtvYaI4DwYPgSuvIQsif0CmK8PUND6ZHDQyAJS+E3VnelRu/JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0u94xaffqzUo+IhsCYK+AoMOnoYPRv354eU4FYTEIhc=;
 b=MHsVzJ1JsCTDYM1ozqTrIj9FlobOZQWmR7tdKekeP2eaL0QQ+57UbaZUZ7d68wC3Vov1d+S7O4CRX2QGrPQug6li/zc9oHldcTidF+KkDHsfHHzs9mzXowkMYnvvO4s+6GFYOKHVo/ykWNd1NB1kNnAwZ6KqwJaHRyTfGPAVet4=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW2PR2101MB0890.namprd21.prod.outlook.com
 (2603:10b6:302:10::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6; Fri, 9 Apr
 2021 00:47:52 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Fri, 9 Apr 2021
 00:47:52 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXLNFkZWy01RJh1EWXtFcKc+4EuqqrT01QgAAJMACAAADqQA==
Date:   Fri, 9 Apr 2021 00:47:52 +0000
Message-ID: <MW2PR2101MB08925118BDF20EFA9AAAC947BF739@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210408225840.26304-1-decui@microsoft.com>
        <20210408.164618.597563844564989065.davem@davemloft.net>
        <MW2PR2101MB0892B82CBCF2450D4A82DD50BF739@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <20210408.174122.1793350393067698495.davem@davemloft.net>
In-Reply-To: <20210408.174122.1793350393067698495.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4f4d65e0-b800-4383-a21e-8b2c02c82f84;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-09T00:44:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:adc1:3ae7:8580:9c8a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a30d66c-c9ef-4eed-afa2-08d8faf11b81
x-ms-traffictypediagnostic: MW2PR2101MB0890:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB08906BFCD532E5C6E14A7F09BF739@MW2PR2101MB0890.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qdpbD3mSgRW+TJPQH0p+i6z6Z53egIdBaqAxk9AD5uTpM9E0W9UlWDGABXhT9vTZe5yTT5sdz7KQN5dRwzBnmR5jLoCs2llMJA9uP3i0AJLpW2E3X60z6go6KluVoDfnSSsMnqkaDdamjCqQjk+DidF/vEdN60waHW9uwzAmckSCaPX/D/iypdBfx1SM8zFAAx5usnGDzqz9k6rn+5n22QXSAUYvvH3p/x6vDcMSaFOL/5VL96I+qVyWfk26GkZ83NFUc72m0QcuY7ZHBfF0v8klnrZlpU+YOotAW52jlX0zNsROisRvH45EDTn60LTZSKUzd5pSA8kMeWFKeR8I8HaH6HF9j6GlfzFNdbeWvhAfeqmLDBPU6SesYYECqnLZtlDuWkEKIwxImhIS4wZV8fecZfIZx9Iuj+RdSVbngkHzu/K6XjnUfxRL8HtHpm/ICViGMhjzNDehe7xaDU7QMc6xIWr9S1SejMkN9cyWsjUqJCtsq82WfFoZaFaQ1iZeQSvhlrXomm3nP0BadykLM8JvGV50ccM6z+22IvrJa+Gqb2jkIRUFnXt1yHX0/kMDsiUjQ/HiYfvqbk4439AdcejgAjWUB23I/0qDOHj8VJjrpD/DEHZek3TXlTIBGsdQhnNGYwjaFqOT+rVEMGvHKBwWym7iBNpVasdGhDXNQQnSyg9PNt06flfUnyJTJZAh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(47530400004)(316002)(76116006)(66446008)(6916009)(82960400001)(82950400001)(2906002)(66476007)(66946007)(9686003)(54906003)(7416002)(8936002)(8676002)(6506007)(8990500004)(86362001)(55016002)(5660300002)(66556008)(4744005)(38100700001)(478600001)(7696005)(10290500003)(71200400001)(4326008)(52536014)(64756008)(33656002)(186003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0pyfgsDO6QKbrdWWHaLli8TkktqbW3l4DxuttOxB8U9VXp72psyZ5DIV8zW0?=
 =?us-ascii?Q?+BXJTh5DXge+mRNLjFkqVc5Hg/utD+Vy0lmcNWW+mK1c+Xfhwxe8yrR5dzDO?=
 =?us-ascii?Q?3nMgagJDDNyQwb5H70fPg/c3tsucsmB1XPAhb6z4gWLAJlHXy+1CWHbHDETU?=
 =?us-ascii?Q?hsiXsr8XGJwITZiQS9LjkzltGP97xNPgwVhHEEDQWz6QnV2hhjCNwoz8rKlh?=
 =?us-ascii?Q?Qj9woAolu/v32eDbLiSrtMU2waOQ5cBRvAhxIsASPU9E/gUzGXlcE9vbOpr4?=
 =?us-ascii?Q?0G7M7In7ZDpHpEbTulkWcB018C+yg3+JiEA3iE4cwZwR2K3CrEgunGkyKrjK?=
 =?us-ascii?Q?0TJ+AhNHABsSzjLryW84uRmMbVSPL0AGsZJQw5M8cBqRLNpHd1TzcO+3xY0j?=
 =?us-ascii?Q?58Beei4No5BENGGLRGpbLDRVZxw+6Ho/+t49doKI5dtFvKEx/w9fnEL2yBse?=
 =?us-ascii?Q?QZlZUEwKI3gVzXC+DTys7+mqjQd9VUYwYgT0luRtVf4XmWIn030/yO9Q6Xqy?=
 =?us-ascii?Q?jE4SO9kdLv2hnso5c2gy7Z6YHcmcXvf79JpTfv8Kj+ECuk6wV5eXvtLhh/pG?=
 =?us-ascii?Q?DEVyAN0Fx2/bAdMLF6yoHfgU+KAb/2Ap6fTwTNNTT5w9rPc5yZD6Fa+ZT8Op?=
 =?us-ascii?Q?68W2zUIRCCGtgcAYckVxx5fcP8P0F5f4FDBj9ePCH71vFo/5cDyGmUdWjlNh?=
 =?us-ascii?Q?97kEsAa5Hayn5wMDRMA1ywe5YF5P52u96lx6oJwsJDtPJy3t1T3maknpyc8b?=
 =?us-ascii?Q?9Us3by2NV/g352J+Z1hXU0t3h9ggUvC+qrJUMqYLFhxcOpS2d/1OmoFM2dPQ?=
 =?us-ascii?Q?FpFuPqT6g82PtDnzsJ9QoHoDf81Wlijw2JLh5gJSLthiN5BqYp+AcI72zHIT?=
 =?us-ascii?Q?X+nZLw6R7htFcPJT3+tYOBZJvdCySi0sLGBajUJueJIaadp2McO7PhaUi/HX?=
 =?us-ascii?Q?9d7o7YjnFBhVHjjukrv10wR/zYRlVCPIyDBdLH6Glust/1YL54MlJb/y1dC4?=
 =?us-ascii?Q?UvED3TSHeG76fZLWNTiGz0UAut2wHEdzCQpIoAwhFtTGQISQ78j0Gcd+pNdn?=
 =?us-ascii?Q?dOF7h4jIKjgZwh4RffIYYjHpzJxpC1w6SGNPoIgIE9akE2GCnyxZEEV6YBCS?=
 =?us-ascii?Q?gWzS9qooPLghcj6yQEwA80dMRf46G8IeIzjo2/USeCMA3NcPRENFrMX43W88?=
 =?us-ascii?Q?ZAWD0+dJHAQxspEH2OFY5CZ3OzAQBD3TEugypTi0nLR0ljP0QdCu7RJBGIr5?=
 =?us-ascii?Q?z6WyfttV2CQlEvktul9BiERdx4f8X9+zzIO1ph7Xy+2hIw5yT/Rb5mGhyENs?=
 =?us-ascii?Q?VLgTmHe5cQaWf0dUAc9vNAO83kPkj5FabYtfbSPvGe0Xl5wPefXTaSihJ+Ed?=
 =?us-ascii?Q?JAPF8wp1gdDpuL47Dokm85T9tugo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a30d66c-c9ef-4eed-afa2-08d8faf11b81
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 00:47:52.6282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ByF0dCEvxKt1W4442nygFKHZV/k9zONnU7N2IB7Rob7V6jHiZ8eAziZywCduxNNKZcZbdAKr93u68RbMoDb16g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0890
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: David Miller <davem@davemloft.net>
> Sent: Thursday, April 8, 2021 5:41 PM
> > ...
> > In the driver code, all the structs/unions marked by __packed are used =
to
> > talk with the hardware, so I think __packed is necessary here?
>=20
> It actually isan't in many cases, check with and without the __packed dir=
ective
> and see if anything chasnges.

Will do.

> > Do you think if it's better if we remove all the __packed, and add
> > static_assert(sizeof(struct XXX) =3D=3D YYY) instead? e.g.
> >
> > @@ -105,7 +105,8 @@ struct gdma_msg_hdr {
> >         u16 msg_version;
> >         u16 hwc_msg_id;
> >         u32 msg_size;
> > -} __packed;
> > +};
> > +static_assert(sizeof(struct gdma_msg_hdr) =3D=3D 16);
>=20
> This won't make sure the structure member offsets are what you expect.
>=20
> I think you'll have to go through the structures one-by-one by hand to
> figure out which ones really require the __packed attribute and which do =
not.

Got it. Let me see if I can remove all the __packed.
