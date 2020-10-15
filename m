Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83E928F1C6
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgJOMCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:02:30 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64036 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbgJOMC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:02:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09FC0FnG008580;
        Thu, 15 Oct 2020 05:02:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=qO5dU0aVhHg7+L1vu7xDV2vwveXHEQhnSOWZzEF5F5o=;
 b=X6A3KjabttMLHNcI1RjiQxX+Nwx1NiVccVfYwRAUJxX2blM9V3Q9lDsV2qQLREzF7ssK
 izUbbJxijCQDW21FjSmAMZYTZHYVtrpz6fPis0y+oHIrZgXtYh05QGpm+EfZ9ikF5CwA
 +NyPiarAaPJD8lK0BFU+nCc/jVhMBF4sjOUfjIzMVrEU1sbXEirlBWLGJsGWKKkjLZCn
 D0iB6NpGccDoz9JKPlxy/5oMbiQQVxhL/wesMZV2uXIE4/bNby1efyH2Pc0f/fEofBWY
 thjPsPcNsp9cF8z1XHuSpicdBuc8lSa9Qk9lqPqSjDyNt8Zs7va4XgYJ7AQ6Hd4vasNk 5Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 343cfjjnjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 05:02:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 15 Oct
 2020 05:02:12 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 15 Oct
 2020 05:02:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 15 Oct 2020 05:02:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqjLVVGC/aci9866m5guoXF1OneHC0cNxA6fJYO+9vWNUvgK9Cy96JsB3bSDu1Xwzopwqz58cFLMkk8u+ywDDAgxdfeGWif9o7Yvgu75cUXGK/IbyEINgJjcQR3dOWKnWs4+SNmcJ/NCA7QupSylRsaVF0BaJNz+4iGX6L4r85NQTf0atNtouoLWPpX4CL9OESFcBJuWiegv4MuUkGbNBYDpk/HVBLlP48I4DzPQijn7qvW943T9F23m7iN7b+ePM0ZMqmxML4YKI/kHVQMsjxb7mTAdS0L9c3pd49uW0zaxp8nass/Gc3Ry2qmzaOg0+9xk3f5lcUhK1BTEgSur+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qO5dU0aVhHg7+L1vu7xDV2vwveXHEQhnSOWZzEF5F5o=;
 b=C+7R2OBQv71EKic6SLjRGrdVYTSfxPEjN2zYWX9cyYEURlg/RWrYxSvcHAHj8tgm2vmogVHN7Uww4IXPmxDb6P2vYHJ5pJjJCC2A7HwAq8XgjqeU9P6jz1dHu2CSiL1WyVSho/EGg6SYZwP8t7KwCGyomijitZMgDRs/vphkn/7WwSfXSozgcLklzan8Qb6nVedUnRsHrRoa9fgQWMA2unYMWXcOhRdqj2QsJtMSRFGvyxhGFAQbEiQmfbjAZlyQO/fQTbH1mAvv03ZX5Uu8ek2dHvxvhy7v0T5zDVQpQhzeMBxI9jG1DDt+M6eFvZB3EltDhinB9AuoVQf2hQia3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qO5dU0aVhHg7+L1vu7xDV2vwveXHEQhnSOWZzEF5F5o=;
 b=GF2RyeFbXyBbo8iKYUrCcivzmpIforPZgBNmaWgdmanJn+zVVMsPsn682jTdL/WmaJ1pOdlT2ZQZuiKuuA/0r+hU3hxdA+jG5s9Y7bXGockf73VkxwCXEbXIu3gn0Zq0xGbofiWjbS2jkBdgMM+4r9R3JZZP2XRumgwC8Shh1FI=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BY5PR18MB3124.namprd18.prod.outlook.com (2603:10b6:a03:194::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Thu, 15 Oct
 2020 12:02:10 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2%5]) with mapi id 15.20.3477.020; Thu, 15 Oct 2020
 12:02:10 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>
Subject: RE: [EXT] Re: [PATCH v7,net-next,04/13] drivers: crypto: add Marvell
 OcteonTX2 CPT PF driver
Thread-Topic: [EXT] Re: [PATCH v7,net-next,04/13] drivers: crypto: add Marvell
 OcteonTX2 CPT PF driver
Thread-Index: AQHWoIajDK99I44HzUyBhzYIqJkQoKmXyrCAgADH6aA=
Date:   Thu, 15 Oct 2020 12:02:10 +0000
Message-ID: <BYAPR18MB2791A8B78FF0E3572C59AD66A0020@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201012105719.12492-1-schalla@marvell.com>
        <20201012105719.12492-5-schalla@marvell.com>
 <20201014165811.7f2d8ced@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201014165811.7f2d8ced@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.96.19.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb93e943-af7c-47c7-449e-08d87102254e
x-ms-traffictypediagnostic: BY5PR18MB3124:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3124293A20C1E4CB5DC51C72A0020@BY5PR18MB3124.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wla8QjcofNHaS43Pd2dR3ErnYHASV5elySRCk4dd9d7UFbxaGVQizRk0Ov57wdhl8plw+VJL13s538ld1G/8Oi9UlM8zCE0b7VDXtZV45XzKIjNLdeXtMCHTVnGbo6inmcXobW7HtK5wy5ehsxr3itxKfpjMsgxZ4IDT/rfN7pU39zgQtU4R+izn50mZiDplb1jfwxUoEAoaArhijJHCSnKfyycHl2vgxpsBsEXlEI33NMd7Z4TuPljqCfqRvYzCCDCx4ct5Um0hZPKFfYGKgXVLChfYai9850s7JVB92rMnEdvIDLVaB2y7BLZKz05hsHAc8GahoLhX09nmiNlzRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(66446008)(64756008)(26005)(66556008)(76116006)(9686003)(4744005)(8936002)(8676002)(186003)(316002)(71200400001)(5660300002)(52536014)(107886003)(86362001)(54906003)(55016002)(6916009)(33656002)(478600001)(66946007)(66476007)(4326008)(2906002)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Wv3LN3U2gd6tC1+p/cbMi7b6bypopZUD+ngVdFEVoch8LfgWCtgiyF2r/LEDUpQknniCtfVqHtMnCz5jZH88pANpQmnBmLi5NyPozMl18p2gMtZ9HkZmHEg/RnEIwystXuD9f2G6tRR8TvS2l8Lcu3iE/1Hp2E0REFciE3pRZoKK2ewcXZMtTXicjetjdurwyDHFSSeudEMw//cSGXNutTpMNfm91TyPVwH7T7bTzfC23qLZll8cS1OM2Yul6bFyUsPZnUQrHSpp4ArIMGY6JDhd6VbPy+7VfXiWsRd+VynrmvYyQfEe1K5Gtzo5byti/tYvrlgwpIryJbldtVymEeSrb8rTMoVnWLdqJDFUZ0XzUV78piKpMwz4GSUP+afvF/TlpCm99c+sdikV0zF7ic5UN68XoqBiCa4H8sjWP0sNGKq6C8DYH+UkfBI7LjLQcdg6Pq1EgJJ1JlBMKj8IrblJX9dZ7uEbXQ8rNlfy2+W1MmkShqk3mRqDrncAdCN8cXjus8Bx1GvqLQkARe6HAsu4OYxeuEcUWoNjvZaxulBkzkslWogThC5BZjx9JHbpNBxPLqrOZfIzsh9tcglBNWuM5SIVvogx0JQw+89UCPTTCCoehd22iliPNxwM4+/3mEJ7ARuagWy40jgUTdGpJw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb93e943-af7c-47c7-449e-08d87102254e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2020 12:02:10.1275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7MGl5nOOvvPUfvsdly0aURUuc5NfeeYHQbVESe6ASkECBtMOUYZmDh6F2GSnzpk5/f83bjGCf8c6AfZDvfNkdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3124
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_07:2020-10-14,2020-10-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [EXT] Re: [PATCH v7,net-next,04/13] drivers: crypto: add Marvell
> OcteonTX2 CPT PF driver
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, 12 Oct 2020 16:27:10 +0530 Srujana Challa wrote:
> > +union otx2_cptx_lf_misc_int {
> > +	u64 u;
> > +	struct otx2_cptx_lf_misc_int_s {
> > +		u64 reserved_0:1;
> > +		u64 nqerr:1;
> > +		u64 irde:1;
> > +		u64 nwrp:1;
> > +		u64 reserved_4:1;
> > +		u64 hwerr:1;
> > +		u64 fault:1;
> > +		u64 reserved_7_63:57;
> > +	} s;
> > +};
>=20
> AFAIK bitfields don't jive with endianness, please don't use them.
> The Linux kernel is supposed to work regardless of host CPU endian.
These are hardware specific defines. OcteonTX2 SOC and we don't intend
to support BIG endian.
