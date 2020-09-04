Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E177F25DB25
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgIDOPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:15:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16472 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730318AbgIDOOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:14:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084E4VSi015486;
        Fri, 4 Sep 2020 07:14:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=PtiiTWnhNqvjxHAJTIgt8Q9uB4w/beFocAkPTq90jxo=;
 b=K2aAU/AMf3KXWO1u0thpSrfSvWE2Oaqn9+ucClt9ejnvh31hl6VpzXyLYau2KMidVH8i
 ShkdWfeGcisGzS97rT1mfGkmbwhFSZlnpcFkB1kyWlN6ZlU7f4pddYVDG0CtlV0+A1Nr
 U2rhXwat1+l/IFoW9vUTjSj0J2kjPbra9il5ieoKVYoYAFju/4TxpM8O8rLAfEonEaSi
 dsbxlUMWiPGbTURaD6ZdZyA3o2V5TS5saft34lWeaA1zogQNTfCLS4zZT0Td3V9PE1fP
 Q7LgGr6E5g1IoK6TxgJfR/RQVfEhWLJCHwm5iUf89iCHvypgpaX2qu4irduQhB9rhI/b 4g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqtwjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 07:14:38 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 07:14:38 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 07:14:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 4 Sep 2020 07:14:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATluLDjw1COMeGfA/Au3Yb3thjKiZDgxH7aiq4b9UUQJBwGz7e/7Oa9kLqRB7J67qxdw6Hle6vv7P5xelquu9TuF5HDqgTpwO1fIMdTaHxwrspSlAZZao/b15uQo5KjOQ6eBZpPTzBin2Xd/IY9NQrwnpg+ksPdtv5/aO3//6HDREH+LWvbNHyGpQuwneTtrz9uBp5cFFtD+WSFF/Msa9hxNzJ2g4Al6kYDE5kO0vCbNoRnES9oXPVodOvgtHtYqIubGU1XSkb2ruYnYmc646Vapk2/VDMqxfCd4SwYkwaoayXjD/JRRXiSWnqnq5SeCTLS8VDwerVTLjd3xgRR2cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtiiTWnhNqvjxHAJTIgt8Q9uB4w/beFocAkPTq90jxo=;
 b=LPLkVmOnt/D77kTdJ4dZ3LIcdeNVoWMnhvwNVfp2FRwkkSRJwVj3JM68gixFTBX4Duoit464Wl83QglZCr97zCHewtKJg71p2r8R5IexIQSjlSPmbeJpDifEAt5xrPWLoBFXZd5GKhoVlhFThO9Fl4Q2KkirfT068STU+NHQmR1cNUyh5yXw7mHKSdl3agSB8trygGv01VXpapvaPtUXRBBv3hn0Oa+k9SXtVBx3ltXjSMp7aTTU9Fui+1EjhTCwyt/djEgT8ttBGFeg/mTcakCiEBRKCVizFM/Lmhql245kTp56KdZTrUvEPkYL0SmAnw2PWIf1/gZ0PgQHRrvFWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtiiTWnhNqvjxHAJTIgt8Q9uB4w/beFocAkPTq90jxo=;
 b=AdluOnbNQdHvs6QLeH1R6mgcWV+kto0AVQHWM26SK/iBHyWE74x/p2gWQ8bzObqHKOy/SFP+9x4bRJq99Vv73gs0FB/vsGKZlnbm/2/5VA8fNT3y6/S+Jldy7Y2LG6YKf6dXdv9u8bt4jq59FFANYqTJrT7ggxcqskVC5j9yLT8=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BYAPR18MB2406.namprd18.prod.outlook.com (2603:10b6:a03:138::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 4 Sep
 2020 14:14:35 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::1cac:1a9f:7337:34a6]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::1cac:1a9f:7337:34a6%7]) with mapi id 15.20.3348.017; Fri, 4 Sep 2020
 14:14:35 +0000
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
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
 OCTEONTX2 CPT engine
Thread-Topic: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for
 OCTEONTX2 CPT engine
Thread-Index: AQHWbMTfW+P0JoWQZkyWfmrU0nLSuak1PvSAgCNkG6CAAAgsAIAABVvQ
Date:   Fri, 4 Sep 2020 14:14:34 +0000
Message-ID: <BYAPR18MB2791A52DA3BF1D7BE5574F99A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-3-git-send-email-schalla@marvell.com>
 <20200813005407.GB24593@gondor.apana.org.au>
 <BYAPR18MB2791C6451CDE93CA053E0208A02D0@BYAPR18MB2791.namprd18.prod.outlook.com>
 <20200904135044.GA2836@gondor.apana.org.au>
In-Reply-To: <20200904135044.GA2836@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [157.48.62.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06c6534a-d4b8-4f5d-10c0-08d850dcd9cf
x-ms-traffictypediagnostic: BYAPR18MB2406:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2406AFC219939322FD49729AA02D0@BYAPR18MB2406.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eDgTdhoSN3ZuudKg1L9HYlqS0QGSROheGXSDbF7BnYewZnfJBwfY6B07zi4CCs0BMrFMkc5T2mtPHkgWt/G58Sik/EeG5RSFLqZYO8IRptPcZEwnIHjz82h/EpgB3rXevez94u+A94+oKSHjDExHbzu0SFIxz6WXPGG3SrR8uQtGJClI9danoFN7vCdb0boQN4AbeDcviF8AJ53mvWwHrji6OlIt3YxyFPK0DO2GlS5JBtODd3iIOrgzTkW1/oCdeguX98u3cxK+hF5FyJ9cG/HOXqemX3pIrNlBG5oksMJHHR8QUW3Er5Shb6LyPT5UmGQMj08LATedWaL/En8PCD5k6rMN6YVx9JY1trbUGMTRpBaFO4ymT8JwD/uXNMLdkAzZcMtvKinaMXzNLryflQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(478600001)(6506007)(966005)(52536014)(33656002)(9686003)(186003)(26005)(5660300002)(7696005)(55016002)(71200400001)(66946007)(66446008)(64756008)(83380400001)(54906003)(8676002)(66476007)(316002)(2906002)(66556008)(6916009)(8936002)(76116006)(4326008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: yDRAxzOeVVyb5gPOwqFjDxADz/p4biwKjudCZ92hwqG7d51g8Izs2YDYb6EOcw7lJlvKNtnjPYv97O3A0PBlGduqG7PcJqeZ5oij1Y6RlDchZlP3hxRvy+zMdoUDePHDglYT4imwjfOrQM//wLgGoAWwP+E1oQW8O693q5a9TAN1ZQ3UQEgNqRRZJPL6Tki2JV3N+zsjgWEx1DDdzPdaoEuJ37MBVZbKkpcr6a4AZqxTYJelzRZAh2sp3NID5Sgjv3RC3Rhkw2NXjx/onb4yrZWMq3/CrxHweA4ryEMfg5j+dUBeU3Og+l2HApfnhcCoFjsB8pxrqfBc7ERV8G28AY9N6lj5jgu6Ras1/iTgjffZDWqVYdh/emb2HIzVXzvilE7XyP50xQsEX8LXZZftTc0/YOmPWBh1N/CDyFUD/UgUeFndypCHarwa1qDiBjUJfjFpi66gu5+rwG6sxRM0OsoMhUa1saY31a+tvQv9N1vCB8VwANfyCK8Fx4Olu/pQBDpFACZeLQbdRl1hqMjRXciTgnMW/b4bf+CmSisXckTDEN0Oi4G3a8v83+sRtBlUG0r9DTeofe9/Ik4aiG+VvyjAFzRQO1eJfh/Da61S1akB+xQ0QQFZrUmPlCL5+GLIjLDMstF9mRYnsLDSzlUX6Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c6534a-d4b8-4f5d-10c0-08d850dcd9cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 14:14:34.7010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z6WT5RiiRcZYk4gUSgPBOuswZpY8x4y67EYxWAwRbcDbpvADTwlAEaqYbWxOroRBGDn+F8rToBHAVsGoCvz8Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2406
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_07:2020-09-04,2020-09-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [EXT] Re: [PATCH v2 2/3] drivers: crypto: add support for OCTEON=
TX2
> CPT engine
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Fri, Sep 04, 2020 at 01:45:38PM +0000, Srujana Challa wrote:
> >
> > This block of code is used for LMT store operations. The LMT store oper=
ation
> > is specific to our platform, and this uses the "ldeor" instruction(whic=
h is
> > actually an LSE atomic instruction available on v8.1 CPUs) targeting th=
e
> > IO address.
> > We add it in the driver since we want LMT store to work even if LSE_ATO=
MICS
> > is disabled.
>=20
> You have exactly the same macro in your net driver.  Move it into
> a header file in arch/arm64/include/asm and also add one under
> include/asm-generic so we can compile-test.
>
Since LMT store is our platform specific, it cannot be generalized to all A=
RM64.

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__gondor.apana.org.au_-
> 7Eherbert_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4OoD5hcKFpANhTW
> dwQzjT1Jpf7veC5263T47JVpnc&m=3DawJiW_TrzVYeiwrZnqhly73OXSVuKm8XrM7oN
> Nd7Iiw&s=3DXZLFIH9uZTPOhsn-5jAzt7GXzT0iLbCYru55UjgkbqA&e=3D
> PGP Key: https://urldefense.proofpoint.com/v2/url?u=3Dhttp-
> 3A__gondor.apana.org.au_-
> 7Eherbert_pubkey.txt&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DFj4OoD5hcK
> FpANhTWdwQzjT1Jpf7veC5263T47JVpnc&m=3DawJiW_TrzVYeiwrZnqhly73OXSVuK
> m8XrM7oNNd7Iiw&s=3DpBxsW4mXz4mOiEMFDfIJfgC1Ngfvm2egNK0ak5oX7ms&e
> =3D
