Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA69925DB07
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbgIDOKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:10:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730506AbgIDNp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:45:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084Deqw8015691;
        Fri, 4 Sep 2020 06:45:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Fuj06RBWm8e2p9IvWZg20tK6vNENqVEj7h5Pxu4XjiE=;
 b=Q1GfJFbDS8yI97YVeWiXNZrYZ8JojsQtcEwTwsiLX0Hkm3A3vG70/zc6FjwwwRTwt0HQ
 jQ+u/sX+qPsm7yP0m+OTIPPX6KAiVAkV9Zr4DDsKyvuMdLQ+WGk3C/1FD1fzJFRqqO5k
 HKB1LeEYtAGjPccClhZ4HSY7aXitHW8bGf94btPxyHBvPpDNuTRqfBhKYzZtMT1tJUVm
 KqrtmxvJ4OMZgEuwytKA9HEZyurE6jaXeYpPKb4V+Wh6JbfPum8newP/4CB+vkzCxJaS
 2Yhgs7QOS4uHT0AzTbg8bjTgAvhBM6E3v9uCWe7zWPmXDSMYfXl9LlHy5ychrNB09P47 qw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqtsnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 06:45:44 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 06:45:43 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 06:45:42 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.55) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 4 Sep 2020 06:45:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+YmGopJfmctFzQurCn/glpfse8HG2glw9zVzS8nUCOOHXB6EKxGLjkGesvaaYkQuk0mfZBmmp7i2U/IjhvnvD0W1IsOvwAaTkFKWpBuKgPQdBfTw2kayy7H3Bk/1wOk5t3MknZbmUSZs79LlqlE2kuB/m1Y8Cf8uwzeTirilYnvI7PeQRVVKxeiCQWnLe21qplaqtrpYzTegKumfZ/EslZAWQ3jWEJ5H4XZhgG/EK57WiT6GACU/G5EwN8gGOmyJUZvRKq2k0FeAEfJ1rs8VC9qdgJ8tQLic+Rkr2NxBX2CLzM4odwhLZnn2X/M7xl5FfHi1MyI5hHN7Hi0TA9SNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fuj06RBWm8e2p9IvWZg20tK6vNENqVEj7h5Pxu4XjiE=;
 b=JAAdbULYKxYuXBFq7Fo2k4xjVg6R4I1QoV7TuLV5E0OznTAc8dwOq9xqqMpf1OE54fohxvjn+7mHlYtQw2/TeH8uvbJXCGr9XHvqfg29d5QvBfeWm/0oDsWidz5Nu+0VeeoguZhBEdcrVx+/KEdzwQiFCP6yhUfTJfSDFnTPKdcQoq/Km6kBD5JyK50lXdTyQDPjcuwodnCSCTCZPt0KHE78jr8ivswr1lEhtXScq6HiRCXp7lQ2i+uRz6V/VSQE4aTq8HjLELLWx99kD6NuFGvuYHOJ26bP4eB2BYOfJ8pmm3gDiO1bTj1dZta6Y/9zDYUZ6Mkfig0NklLKKg8cKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fuj06RBWm8e2p9IvWZg20tK6vNENqVEj7h5Pxu4XjiE=;
 b=hBnzob5N/YFtGeVfFz63Yse5fPY0ZzwmjZutAtj4kpC2PonXSJ5RXGYyTL87Su4aBSgnqP0e5HprPvnn65j3cl4WZwvCt+nkPxu8UYcF7YxcwY6+0Dnh0YPJG/ComaTdsqb6u5bUmdY8cHiwypZlCwzQ0j8FEHe1sFpBhluV1hI=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BYAPR18MB2790.namprd18.prod.outlook.com (2603:10b6:a03:107::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 4 Sep
 2020 13:45:38 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::1cac:1a9f:7337:34a6]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::1cac:1a9f:7337:34a6%7]) with mapi id 15.20.3348.017; Fri, 4 Sep 2020
 13:45:38 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Suheil Chandran <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>
Subject: RE: [PATCH v2 2/3] drivers: crypto: add support for OCTEONTX2 CPT
 engine
Thread-Topic: [PATCH v2 2/3] drivers: crypto: add support for OCTEONTX2 CPT
 engine
Thread-Index: AQHWbMTfW+P0JoWQZkyWfmrU0nLSuak1PvSAgCNkG6A=
Date:   Fri, 4 Sep 2020 13:45:38 +0000
Message-ID: <BYAPR18MB2791C6451CDE93CA053E0208A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-3-git-send-email-schalla@marvell.com>
 <20200813005407.GB24593@gondor.apana.org.au>
In-Reply-To: <20200813005407.GB24593@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [157.48.62.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ec3d64f-89f1-4aac-549b-08d850d8ced0
x-ms-traffictypediagnostic: BYAPR18MB2790:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2790ABFFCE3E0A4A73DE3266A02D0@BYAPR18MB2790.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uNYnOKbpR9zHQvx5myQbefIcg0IWnumLl0dcqs0IjmYgRlrcnUx01aGTAXO0eJOdcAdzBnAl4/uOUBOX+esVpLB6FA7cevn1NEkBrNLdI++gZ5Wdj0uhPCcovrFdAcx/ylbZcPFtt9BafidMfPF2b82LLMat1fgNZzHI6S1B8MwKNRMZ8Z3o3VIO/xC2+akXBVpeFZMJEMkhKLMRjAffQf252xrkltwJ9WTPq87DyYqgWZ+Nj1sLmUswStoft0jfSRnWMZs0ZVQyTexI1iVlEVQpRf+uLYc0nkXCzPwopyxnPLK/o33ZVruv7NgTATuMPpZCoIstbhzzEhaEOShacoEIJzBBv3GnsE6IJ+NnOjb+NbJazwBnHjlx3b7/83mVb4b4pXfGvxTAmjHdQ07nrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(54906003)(5660300002)(186003)(966005)(107886003)(26005)(86362001)(478600001)(52536014)(2906002)(4326008)(7696005)(8676002)(66476007)(66946007)(64756008)(76116006)(66446008)(33656002)(71200400001)(66556008)(8936002)(6916009)(83380400001)(316002)(55016002)(6506007)(19627235002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RgvOy21F0eUuTd4tCvjxdOZ+veez/ToVDFo+ZjXKlqGMFEYq2p0W3nNiMPvomNurc01gvnqlT67pWoeC5m8f1dsUJX75I/vuZMTaMRo1Ole0n/eqR/qlixikVsKbrRltT0eHGIXutA+H6gtbbpFMdtPPcPKAB5ms6vlsOQpLuKGdCuRHdbdVvg6BXuExrrv7HgkaIFX22pNE3MRnDKP8EvC03TgnxneKQ9PQ89hO7gTdWuXxkHq3t2rXjoibH1a8NGesxcf9Av0qlMqbuwUlDpM/4a2YbPhhaQCCHmeyGM9khk55UrtQ6RWwkhTW7aB56/VR4lslnlRQFoRmpgPHikt0YKvKkkwyIhhXz5EPO7CZM+V3e9kiATGx0FER2hJBLGl/Fb07sZiCS61VuaNGqGGiy/q6vwVkSohDwQBFpEFhjDdpyORFNR/o5vvPEMEFJ7H3xZ44hGqLRvouQysHO5Zf7tSbTpK2pgFxktOA8bFyxVICrnHg1k952irRVeBmVJzM93ju7XqhEei9Z3R33pyGZSb9vgXneV3D0Wg9YP+1avE7gjU4Sf7Xp91cVBetnMliUxLEN2JmvHSgRcnVoak4lH7NOpNQy/ImgnpWrcCatRb8un9iZfI0RPPBncGm1tNl6mUmh9zOf565vwxL/g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec3d64f-89f1-4aac-549b-08d850d8ced0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 13:45:38.2834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r5nVLMj+tcU6/h8RRhK242OYI+WHtgho2lZAGZMYB423Vnla2vCTu4M50b10gFLoJrJrOmyAWZISmgxkSEI0UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2790
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_07:2020-09-04,2020-09-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH v2 2/3] drivers: crypto: add support for OCTEONTX2 CP=
T
> engine
>=20
> On Fri, Aug 07, 2020 at 07:39:19PM +0530, Srujana Challa wrote:
> >
> > +#if defined(CONFIG_ARM64)
> > +static inline long otx2_lmt_flush(void *ioreg)
> > +{
> > +	long result =3D 0;
> > +
> > +	__asm__ volatile(".cpu  generic+lse\n"
> > +			 "ldeor xzr, %0, [%1]\n"
> > +			 : "=3Dr" (result)
> > +			 : "r" (ioreg) : "memory");
> > +
> > +	return result;
> > +}
> > +
> > +#else
> > +#define otx2_lmt_flush(addr)     ({ 0; })
> > +#endif
>=20
> This is not acceptable.  Please work out a way with the ARM folks
> to fix this without adding assembly code in a driver.
>=20
This block of code is used for LMT store operations. The LMT store operatio=
n
is specific to our platform, and this uses the "ldeor" instruction(which is
actually an LSE atomic instruction available on v8.1 CPUs) targeting the
IO address.
We add it in the driver since we want LMT store to work even if LSE_ATOMICS
is disabled.

Thanks,
Srujana

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__gondor.apana.org.au_-
> 7Eherbert_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4OoD5hcKFpANhTW
> dwQzjT1Jpf7veC5263T47JVpnc&m=3DXm4oQ3dI4peur80298SnMa5gz-
> 1rdAxVE1rwHkmHvc0&s=3D7S5Z2Mpq-
> th_W_KeJSQIOSo274CMg5UI0Tc9mkUkypg&e=3D
> PGP Key: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__gondor.apana.org.au_-
> 7Eherbert_pubkey.txt&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4OoD5hcK
> FpANhTWdwQzjT1Jpf7veC5263T47JVpnc&m=3DXm4oQ3dI4peur80298SnMa5gz-
> 1rdAxVE1rwHkmHvc0&s=3Dyf6R1d7GDuz4Wmq_7Z7GoPuIkewZfs0x8h6xXvf3b2o&e
> =3D
