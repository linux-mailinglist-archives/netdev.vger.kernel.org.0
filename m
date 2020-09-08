Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB86261BCF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgIHTJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:09:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57138 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731031AbgIHQGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:06:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088EFQHN031968;
        Tue, 8 Sep 2020 07:20:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=lpTHgyfaIHjsTTlbjwOHJoPpeN+wwHZnZ/R77lFmKP4=;
 b=VajgAGxvhSaerGzsuKT0YtSBF1RmkHScH4GBG8zwOiw7p2zoLrw4yuOWkfGNcfZjURlF
 Qxv0zzLYkllJvwbBDxRcZ0od9zxU8uW8a6osTwX7WTFJnX7skWyZsOdZmPq+rZbZI4zh
 cyDP1xy8tmssOdqEGOB+7JA0byxKBaX/mZeCZBamYE65DE+leauK5ub5z4LrtRJBDQBX
 vJMzpVUKpxfJEa++YyNG1g6ysVhQRScEtpqjNNNU0/Mgt9xtDAWqkNwgF5+n0i+Jleqq
 DkVW1z7x5i/HZKBR+FxaoBh9bL5EPdGz+yQOmJOXq9nSraZqPBcHiG0vnkiqGUI5+j1o 0Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pus4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 07:20:56 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep
 2020 07:20:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 8 Sep 2020 07:20:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPkHc8mfmsDPFYLDbtTSND+f33CHSIwLDkmYcq6X3q7K7tQwk4iLhhnkoSATP128+J1xabB8ebxnbwRbrlO65vopCNkCG7VqEFYxnURGvbanBsb4SPTZkdg3/ANqGT2UHf0h1gqoMfgfDpqOuvt8SBjsHLHsSkbudjltQM1/99bPcOceCNCrOwOopVsPNcng7BylzlOpKn1ckIsIPqI6IW/xIqJxX8CWLTqC7Fx6lj8/hBU2hinyBuID9J+tdzaV2p521PaVzjkAn93/5u2ukTqE+j7ibSlZwge0QV+cCRl9onG6Sj4kX7hmbhI0YUFwCXEqUhM9HiwcBi1aKvKZRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpTHgyfaIHjsTTlbjwOHJoPpeN+wwHZnZ/R77lFmKP4=;
 b=Or8dfZIONRxQz9W2O0v8HGs22z9w43MPH4lSyVLey/PA24fPDQn3HeC+aWfSYF6SBuWN0gJNeQuv3IEGgykZlvYn+OLCa+n9pBQ6Mm3hivBlKV9gmC58zRvHZHxdb+j1iFxi6+/cig+G56i/1HSyWqmspOASyExZ6EXoZtjPzH1a5w7RVcGAkXXQUBhyjZ0YRbXjVeBTbVy1J5UnxQlhpH5k0w6NJT1ktlZ1g/Ag473GK7QofTzSS4iRigQEKk7tRDq84vqhINtlhO85rKv3dOA4E4e0Zud997MO0DYOvq4zcI+75UZPDqVQaqbbd/LT3akrP9jitrbxykVixEIz5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpTHgyfaIHjsTTlbjwOHJoPpeN+wwHZnZ/R77lFmKP4=;
 b=Gujus+bPRiyj2AiPRNWFG4ZvEK2TZfyAfkH2wSD5Cei2nZwfD1tDhXSq5R9rw1a/IM+iHlJVExvP/SBUTpQCgKbL9IkyWvdDtJcfpkUqz9PAgDXejS36GakZ+RFHOHD25j6iNpFFTMK7E36Wz1u4DBLluf+a5sKUBtF4vF8FNdk=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BYAPR18MB2856.namprd18.prod.outlook.com (2603:10b6:a03:10e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 8 Sep
 2020 14:20:53 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::1cac:1a9f:7337:34a6]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::1cac:1a9f:7337:34a6%7]) with mapi id 15.20.3370.016; Tue, 8 Sep 2020
 14:20:53 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Suheil Chandran" <schandran@marvell.com>,
        Narayana Prasad Raju Athreya <pathreya@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
 OCTEONTX2 CPT engine
Thread-Topic: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
 OCTEONTX2 CPT engine
Thread-Index: AQHWbMTfW+P0JoWQZkyWfmrU0nLSuak1PvSAgCNkG6CAAAgsAIAABVvQgAACMACAACbEgIAAIhwAgAW6ZAA=
Date:   Tue, 8 Sep 2020 14:20:52 +0000
Message-ID: <BYAPR18MB2791E9E6B435E27E8143836BA0290@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-3-git-send-email-schalla@marvell.com>
 <20200813005407.GB24593@gondor.apana.org.au>
 <BYAPR18MB2791C6451CDE93CA053E0208A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
 <20200904135044.GA2836@gondor.apana.org.au>
 <BYAPR18MB2791A52DA3BF1D7BE5574F99A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
 <20200904141744.GA3092@gondor.apana.org.au>
 <BY5PR18MB32984DAF0FDED5D9CD1BEB45C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904183834.GS3112546@lunn.ch>
In-Reply-To: <20200904183834.GS3112546@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [157.44.67.155]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c6bf6bc-0310-41bd-dd7c-08d8540264e8
x-ms-traffictypediagnostic: BYAPR18MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB28567CF2D022E8CDDA498884A0290@BYAPR18MB2856.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: THCoTJktkOJgLxPHQ+dp+cWV4w9BZDZ4N64rjsUZRbGnQEDyVwCB+Vm23rq1AmA0nzqZPzIiVUxESLEdtb6vbXms2d5dfdLLxsCr5WifMJ/8h1wCgUxW1gflm8JnjjirzVP+KpUCHXOFQ1LiOZs+oJRB9mJTrQIGJbu4RbsHeFKLe03UMuhUxhpGUy6W5FRs1EGyR7do7THxhUkYySVebTVGvVT1SbruroLxXOWUxOJvI3nE+WoePiNtpp/XZMvaDNIgzHellehv0f5YN+WOkcEZTz2+a6OUJPvnUsFLU9jzDHUi8QmE2k+pOzKvCTWj6b+W8dGToZw/iksWqe2wmUxjGQxakX8uBOH39U4CE/syFmh8ZlGjHLPRfAPS+0nDtc70XCgel1Kwd8hJA6OclQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(110136005)(54906003)(83380400001)(71200400001)(7696005)(53546011)(6506007)(6636002)(4326008)(966005)(2906002)(52536014)(9686003)(33656002)(76116006)(498600001)(66946007)(64756008)(66446008)(55016002)(8936002)(5660300002)(8676002)(26005)(186003)(19627235002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ugp/RmIjEsFAQ9Vcs0QS0xoWC/KAe0LNWzBFqtm8uWflVcuFAQFrAoQy7CO4faNK/JonJ26UWHgFSv5FzBSpAy7na/CbPOok8uLWeABHscxgGXlREOblSkI4Do4ufxebat93KVNoAX8xe+L0pKG8kX8E6Sev/u0miPXomrbk9NEI36ZCYN0mWZ3YgYGJRFHj1U97hmKX9J6X4H2305IV0fRRJ0ZKDJR8glQIIBpvZ8hFWs9zwiZnzUWRX2X8CqsD4deO8n27gif5EdA4E0pXgPGXMCD2blInN/Xul+x/l8J+8l8asfNBaZG7m6+ub/CnLTMTYdUi8H+FXbbTG4//Kfm+YyXef/e1so+No12C0qNOPDAqo9gr8lqKeLx1WTtEsJHW5CfIKdmfPqatADYT/9qxWD3pyIaecFK36HH/KqeT23ZknXdBQnt+tjJ8/5Ix3NBialak++jp73u0Gi5B6NGEe7T+gzceXSa2UIDww0nhkBW03gtMwMm4A4pj0Yfgh/xuS7eaYJ34NHklKil/TjcbxRCbJRBs6bGK4mRG5d7mrdJCv8deSJ43qaNRNiM1uVSeYb3gT1LQIuniEobZS0a3h4t5yEBCK+vNLHioIfjmjSzuka633UV/1HKb/qpNa5bBQ6K/wPG4WDN8yJsCwg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6bf6bc-0310-41bd-dd7c-08d8540264e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 14:20:52.9817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d86z1ZiMDt0zjkMlHypyUuhDPRXpynH4JC1c5f5LrLZrdhXXNWuuzdfaYNnajfHt5g9+i0wpgIgtLR13RFk82g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2856
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_07:2020-09-08,2020-09-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
> OCTEONTX2 CPT engine
>=20
> On Fri, Sep 04, 2020 at 04:36:29PM +0000, Sunil Kovvuri Goutham wrote:
> >
> >
> > > -----Original Message-----
> > > From: Herbert Xu <herbert@gondor.apana.org.au>
> > > Sent: Friday, September 4, 2020 7:48 PM
> > > To: Srujana Challa <schalla@marvell.com>
> > > Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> > > crypto@vger.kernel.org; Suheil Chandran <schandran@marvell.com>;
> > > Narayana Prasad Raju Athreya <pathreya@marvell.com>; Sunil Kovvuri
> > > Goutham <sgoutham@marvell.com>; Linu Cherian <lcherian@marvell.com>;
> > > Geethasowjanya Akula <gakula@marvell.com>; Jerin Jacob Kollanukkaran
> > > <jerinj@marvell.com>; Ard Biesheuvel <ardb@kernel.org>
> > > Subject: Re: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support fo=
r
> > > OCTEONTX2 CPT engine
> > >
> > > On Fri, Sep 04, 2020 at 02:14:34PM +0000, Srujana Challa wrote:
> > > >
> > > > Since LMT store is our platform specific, it cannot be generalized =
to all
> > > ARM64.
> > >
> > > I'm not asking you to generalise it to all of ARM64.  I'm asking you =
to move
> > > this into a header file under arch/arm64 that can then be shared by b=
oth your
> > > crypto driver and your network driver so you don't duplicate this
> > > everywhere.
> > >
> >
> > For ARM64 , except erratas other platform or machine dependent stuff ar=
e not
> allowed inside arch/arm64.
> > Also an earlier attempt by us to add few APIs addressing 128bit operati=
ons were
> not allowed by ARM folks
> > as they don't work in a generic way and are SOC specific.
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__lkml.iu.edu_hypermail_linux_kernel_1801.3_02211.html&d=3DDwIBAg&c=3Dn=
Kj
> Wec2b6R0mOyPaz7xtfQ&r=3DFj4OoD5hcKFpANhTWdwQzjT1Jpf7veC5263T47JVpnc
> &m=3D_Crtymahn2yLpOWm4M2GAuzClE9EQVX2165DSnCx79E&s=3DFfyU3YaCxgJRXa
> 2EzyZrTvnWFYh8K2KmifpZAQN0gJk&e=3D
>=20
> Maybe put it in include/linux/soc/ ?
>
 Okay, I will move this block of code into a header file under include/linu=
x/soc.
Thanks.
 >       Andrew
