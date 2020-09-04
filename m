Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6C25DFDC
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgIDQhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:37:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53964 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725966AbgIDQhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:37:14 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084GaX60013235;
        Fri, 4 Sep 2020 09:36:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=3WJLaF/vgrfWb0iiXxGzR5QOyEyxfTaK3rX0mSLQ65M=;
 b=etVhiJSt8wGXFgh1Fda+nWRgEY9vxYgdDDlz3UqKsePDOWHFas/b/Zs2E8CyzGiS1uuZ
 AEgge6LtFzaXdgdgzC5e8ooWr7pBFKBmUh2jqlP1lwwtku12A0Y6SU2wf/1/SSd36gvV
 jkW40Z2XiIQ2ngICY8XS5Ut1ouRlrTRGCWFLV3jji0Q/Gm1fe8EkyP6/FoZ/Z+71Uy0G
 E1quYvYY07Rn81rtVIg/PA/Ic9zA9np73KO9utghTNNZeOje0tKqnQih9uGEDzSCnwVB
 2MXZIvKeUm0xu+R/t4ABlJWDFca1WYOLvAaJJ0A1yUiCha7AwzjYQ1ADS6oCU9Jbr69M hA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqugqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 09:36:33 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 09:36:32 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 09:36:32 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 4 Sep 2020 09:36:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIEMuvr1i2gxtG+01Vf6xNL9m+odxQ8qaxH/ZZpCT3m9+8z82/AY+8Fvq4ecI0HHTjFarannA5IiHVcXM4G9t2b2+CuYGQN+wXl2D3Fsf+VmItTHpdnoM9tiSO+MA8kUSdFFa8/95wVYGLQvd1SpjjX50g1/+Omay3CT850oR6yHylwVJSRCBq178AdTn0zk36nvMfrNtopla5kf/AbMtxj/X4HDH1Ak2WHNCUONb+jKIBwnJ6q9S0XjXYYCqHd1xMmuXEhXQ8JQysqybBLO6726d8bw0cJC6RTB3VvGMil7IP/ZulzElIjGFx6MJVTugvLIse1pVRvCZWNIhimVjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WJLaF/vgrfWb0iiXxGzR5QOyEyxfTaK3rX0mSLQ65M=;
 b=KTBI8RDz63T7OVOU/Ncb902TBvqZOvO8/08sdiAGu72fkVELp2Nv/VNMnNxjlTzfkZDPc9+nPqc477cDtCjOfeHeTETOdQkpQTdKFazbYtfnTk20SK/s7lXkv9tO8BJV8t/Qr5HtHTEVXMiAJZgKXvkdvyw1KmYcqhKSo+23HpCYKIurNx5ojuPGY2R3eWD/PJhinGBQ67KnXYAvE2Du7B6VLuTyoCw+LmHFmpkqzgi4BY+j3OQldj4ji5mVu3/f/ahM7Xw2NCsk5XdrIcdKVL/9X0TeuR7afY90BbkiHMHHK2XPWX6kbAOeY8jeUqGDkx3sq9wWg42wZ3LJQ6MbgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3WJLaF/vgrfWb0iiXxGzR5QOyEyxfTaK3rX0mSLQ65M=;
 b=uPp4dXl2qMJcAamz9K5WeAgIQSZ/z5GMZSoIh2/m3OQB0GscRtAPXAlb/o2Pce7AewI/qfw1vrkzPvUXNQmb8r8goOkh3ZYuyHBTnchUtbFJMQZJP3+R6cmEtjEGl5tpIglwNUTAMpM40C3VGMvrwrLMz2TBOp/0uFAJsaVADh0=
Received: from BY5PR18MB3298.namprd18.prod.outlook.com (2603:10b6:a03:1ae::32)
 by BY5PR18MB3268.namprd18.prod.outlook.com (2603:10b6:a03:1aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Fri, 4 Sep
 2020 16:36:29 +0000
Received: from BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::fd34:4df7:842f:51c7]) by BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::fd34:4df7:842f:51c7%4]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 16:36:29 +0000
From:   Sunil Kovvuri Goutham <sgoutham@marvell.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Srujana Challa <schalla@marvell.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Suheil Chandran <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "Jerin Jacob Kollanukkaran" <jerinj@marvell.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
 OCTEONTX2 CPT engine
Thread-Topic: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
 OCTEONTX2 CPT engine
Thread-Index: AQHWgsGu3CNkyEntMkGdxaMs3uTiUalYf0EAgAAGqQCAAADiAIAAIuCA
Date:   Fri, 4 Sep 2020 16:36:29 +0000
Message-ID: <BY5PR18MB32984DAF0FDED5D9CD1BEB45C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-3-git-send-email-schalla@marvell.com>
 <20200813005407.GB24593@gondor.apana.org.au>
 <BYAPR18MB2791C6451CDE93CA053E0208A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
 <20200904135044.GA2836@gondor.apana.org.au>
 <BYAPR18MB2791A52DA3BF1D7BE5574F99A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
 <20200904141744.GA3092@gondor.apana.org.au>
In-Reply-To: <20200904141744.GA3092@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [49.205.243.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b44adc0d-6d88-4c47-2318-08d850f0ad09
x-ms-traffictypediagnostic: BY5PR18MB3268:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB326854BAD5D7FBADF4CBB2F0C62D0@BY5PR18MB3268.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQDfTuD5/bpxJ8/TT3sd51NJjptN6ir/WNUSUdra4u3KyJX6Me6UUG6i8u1wRDsoPXo4UB5ssr/HmRhZBPUj4tMFObgASjjmj1E9mz24L5SUhvlb43z1PwlVtwejcSBR8QSuuIf/hsqwuV7HjW1heH/xcz3HLzYQz9cuhURjqxuOuaBl5xfI71xMJJGdjDUHnJwh4lKWk/nDyVjPeU9+XLwlvazinKvAffLXI8sYdJZHg4s94/G0Z/X5Zf98d8mrRmGzMN6JCrB7XLnLjUYYCvwgL4WoqS7jZSolYsVoAXUkDg82GUzgSHxIa62xcFi/LNCd8OtJlnhEWGdmxnezG9ayo1HsnLrUpv+hO17XA8NGvdLQcjF+XazvaKaEzSj6t5LUu+pguBMRxR60gOI6MQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3298.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39850400004)(346002)(376002)(66446008)(66556008)(478600001)(76116006)(66476007)(8936002)(66946007)(64756008)(7696005)(186003)(110136005)(33656002)(86362001)(54906003)(4326008)(26005)(55016002)(6506007)(53546011)(9686003)(71200400001)(6636002)(2906002)(316002)(966005)(5660300002)(52536014)(8676002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FX09sZRE18EPYLPhceWA1OqksdtYqMCeMdHyDkFy2V8ww9PCIfIFWMUCMyKL3KlZUAQWqSazf5Q0Qb3ii5pTdccaKvhsFuTYq7eda5uLhaWxgnxGKh6Zvv7lypXCnseH3vY9Xg4MgUk0X1JAGsJGhgF+7PEZrx4MupwOBK6y8l5q06v3+sV7PBwkV6ljaw/ohe+qTaLMpucT9iourpG+h5RofAwaBs5KrVZPG1Ia8W+DnQgxRX3UBNhjX+mA30wR5QPO4PSMNNM7XsF/6QKk+jIYkeez9Bx7per2PD4kOMmR9m1crZBLPf1xTuj79iA7nfQfOS6PkATqyIZ8m7VsZFSvVPupo495mDsqTnvKMEVnpAHhDMnUvLm20fZapUJTpwxWaIx4LJSWOm/J+oJjs0BATpLvasulXU4BuovIPMuUGtX/81qbRH7TObV+cOvsot5NNsXFr5n1fe+46+5IxjRjmhlkoWIoyEvfnT0g2JLN271MoT3ePL/XTq4HwHuBlOIWR0MfGoq9XgTIGuDJy1vh4xr7+mmQtboonnYBoaZNp4LmhRZNP8H5YrOuFx7JxudiyBjPVcCox5NJlvSPJcmMHj6PYveLZ0fd3C3ojsNPfrMxIzQt2HD5LKFuEAVon+aPfcXuK9LCrlhdq6f+7g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3298.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b44adc0d-6d88-4c47-2318-08d850f0ad09
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 16:36:29.7695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pHFm8aY9V2sZz5hLqLrZtrwNYyzkzbmATbKJTGVHVmwM5ElqtUsv2vDUFYSNg98DfDxPBrtIYqpatIqbNzEowA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3268
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_11:2020-09-04,2020-09-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, September 4, 2020 7:48 PM
> To: Srujana Challa <schalla@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> crypto@vger.kernel.org; Suheil Chandran <schandran@marvell.com>;
> Narayana Prasad Raju Athreya <pathreya@marvell.com>; Sunil Kovvuri
> Goutham <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Ard Biesheuvel <ardb@kernel.org>
> Subject: Re: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
> OCTEONTX2 CPT engine
>=20
> On Fri, Sep 04, 2020 at 02:14:34PM +0000, Srujana Challa wrote:
> >
> > Since LMT store is our platform specific, it cannot be generalized to a=
ll
> ARM64.
>=20
> I'm not asking you to generalise it to all of ARM64.  I'm asking you to m=
ove
> this into a header file under arch/arm64 that can then be shared by both =
your
> crypto driver and your network driver so you don't duplicate this
> everywhere.
>=20

For ARM64 , except erratas other platform or machine dependent stuff are no=
t allowed inside arch/arm64.
Also an earlier attempt by us to add few APIs addressing 128bit operations =
were not allowed by ARM folks
as they don't work in a generic way and are SOC specific.
http://lkml.iu.edu/hypermail/linux/kernel/1801.3/02211.html

Thanks,
Sunil.
