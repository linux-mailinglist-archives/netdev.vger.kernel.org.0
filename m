Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6C91DC9D8
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 11:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgEUJSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 05:18:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13952 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728693AbgEUJSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 05:18:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04L99coI009329;
        Thu, 21 May 2020 02:18:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=MYR1yME214mdfwByHoWsn//8pqe/GxdPHLvrPOWNg3g=;
 b=rU3KaRqEsPch/B7hLRG7kQCo8CZaoGhanMdHc2o6NGmg9OlMzIrRy+7SY7MevgxHD76u
 gNEZSnvF1U3zEtdmQkJ1MTUHksuGi9zUKvXDQ8Y3yj+sTIMxuZyQG/5ndiOTw5S+MGkR
 QqvDhApheWLXKqSi4beggyRMWlPNHqkx1DLSixYbnXnGlivZdYGU1ZjGMl/tG8iUhlYG
 fgL6Mmyi36ksh/aTzCFgSFfxW8Tv96EPSwcH0LZe2GkfzKIrhxgZM21h7x5QHmcKggju
 L1S8Y168SU3s84ch4/kDUnL4aDWAeDiocKzdI2JdsoqcexqbMCAqPd0ZywoeGmwRTmKa 5g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fppcn2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 May 2020 02:18:48 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 21 May
 2020 02:18:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 02:18:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTNS7Ebt6WgLcF0z3671nZMMNiw9YXDuCXhm1Y0KAyWdCqgmAq0bCnJ3Byt0XYh91lVwKvqBDlT9btyLCoLhFjsKHhDDBfCMFIc+r0qFTE/+68DYivwIvTdKSKWIej+Sit+c0L96VSkpP7CiuW2h/ka3HyoBWCYw1EHnjySqsJQjSxeVrsGNK438lLmQUXIYz7XvloQckqzKL9lvJAOD770/Jkzy3ZZETTAjqgiSp0KEKNW5dbZGJvBbE3vi335GxJ77z+T4e54gOooGOmbMRlCLrLxF/Rh2nFKSNMWoVWSoKgc/dmc8dPLZ2oPLPE1gmQhK3av9h7hrD8s5Z9zklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYR1yME214mdfwByHoWsn//8pqe/GxdPHLvrPOWNg3g=;
 b=VLvrBGWF39Y8ESpzVs5tledAKyqd44hzj7JUWuREh/TtJY84VvwoAOXNJsKMe1BbzFOP/IM4aT3j7Meo2yVK/yfQ7z8oyamIUkJHHLYZOB4v86NqoLk7vKa93CMGzH2mVr7KV5CeGNEyfQCCQtPvdcLzKfNLfRZ14QwiUs3GmJegYmxqjquU9wusy360y5JrT1UJCfVETtq1a6U1aRLbeKl/WeZ+sKc+2/M9JCrL7YLkl6zs5SII6BB1YZZ3WEO2RYtuhfSbiDAnntB6aWIpBSYfp600tqrQ5eFxbKGSX6noKQeFtehb2xoNagVUc9cDUxkfSfk6yFzMxGf1e8yRig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYR1yME214mdfwByHoWsn//8pqe/GxdPHLvrPOWNg3g=;
 b=LKNxMpuIQAl6N4y2Hgfi33NcUHWUiVyQZCHpJr0XkUUb+1bA8DBQ65cI6JzzzspJoHp9zhgq6N00w9B26mdv9q7OzfUjIkXpMxcS/uiVszN3Or42hByt3INuoUouE36hNPPIS7923ubuzwKYGIDSR3G5LY1XCd0hl/AqUIUgZAs=
Received: from CH2PR18MB3238.namprd18.prod.outlook.com (2603:10b6:610:28::12)
 by CH2PR18MB3253.namprd18.prod.outlook.com (2603:10b6:610:2f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 21 May
 2020 09:18:44 +0000
Received: from CH2PR18MB3238.namprd18.prod.outlook.com
 ([fe80::8ac:a709:c804:631c]) by CH2PR18MB3238.namprd18.prod.outlook.com
 ([fe80::8ac:a709:c804:631c%6]) with mapi id 15.20.3021.024; Thu, 21 May 2020
 09:18:44 +0000
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next 03/12] net: atlantic: changes for
 multi-TC support
Thread-Topic: [EXT] Re: [PATCH net-next 03/12] net: atlantic: changes for
 multi-TC support
Thread-Index: AQHWLq1BHxO6SUtdnUiE5iZCKZ9TEqixdm0AgADJ9hA=
Date:   Thu, 21 May 2020 09:18:44 +0000
Message-ID: <CH2PR18MB323861420A81270EC7207300D3B70@CH2PR18MB3238.namprd18.prod.outlook.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
        <20200520134734.2014-4-irusskikh@marvell.com>
 <20200520140154.6b6328de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520140154.6b6328de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [95.161.223.64]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce6ca5ca-9440-4088-628b-08d7fd67f5df
x-ms-traffictypediagnostic: CH2PR18MB3253:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB325314D9010F874CB00BE6E8D3B70@CH2PR18MB3253.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 041032FF37
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Udf57Ml5UWzlhoy09xxrgIh5lNAB4aydtJfmhoZwNNVRbfhhilx3Uw3IxJN8XLbbolAT2aH+CokUlGSROeWvefxA8qe261QgHewReQOWGbxJ71cacqIxAsqHdrl8wfR6+KDFkfIT+ZK6uDRVzhGMclhWr8xhTtrbtVFYnBTqk+T6ZgrCHFvk/mq9GgTjcNZc3rU4+c6LZ44E4/OD75pOkdfZSzH3dfd+4cLFRogTi00zXIKq5H5VRStJFPmIIrlfSE186rM83G4jAQJnDaP/a8rybAfKWS30s2tLbq6N9krCSp3dzrSJBCGJScVYFS0P2Gib56aoI/Z1MnTcyWiLiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR18MB3238.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(478600001)(52536014)(6506007)(33656002)(7696005)(186003)(66946007)(26005)(66556008)(2906002)(54906003)(316002)(76116006)(66476007)(86362001)(8936002)(5660300002)(107886003)(8676002)(4326008)(55016002)(6916009)(64756008)(71200400001)(66446008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NJ5/HgXjkXaPRlCvWBxcEifdZ779qZ5hLHO+y5wwnPfcFbjjZbdTWz+zktjSXAcCsHFNqQlaZJmEoAAwh1XH77OWYkmGe52W3PxoyHB9nFIAvaG6I21wUPDH5YX/w9lvO7Ew72RREoQq9Kew++tWDVRqTJi9/v2jdPrch7vGBFh3ZNQV9Ci5r5YlGBB/Or+tsWtx0J//ElvXGQPmMEAUQlWvsdvpb1vNIX3VlT0e0ipxuvBzHSIOErRef+ZGB1/LfZIU34af/jFfHkq368fJRCXSPmKTIB4rlreWgxd2I+wvwFX7rkocObItTLI2AoWzGBizcJI4DNBT2kO0zK3n43CH7/JKXvAbz7HyQdhSi7/RED8eGD7/fI9Ji8SgS2T1kSGZe+K15OoXO56hIHTR0rsgXJ4Me6oRfGuIXZyu656nvFqRzOGhzTA9xHDqr4GmMrPZ+XFS8nMmkFrqkl/KzPUg0aqsBdM5E3XPPGapP20=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6ca5ca-9440-4088-628b-08d7fd67f5df
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2020 09:18:44.3261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lae9MWgASWWxv7hRu+dzFgquWFTMe7LXLTGI8+03SZNO+WdZhy8jpQ+bs4nCdocQ0aaGY0F4xHmNUvtRl1A4K4Gv6YrmDUd3t19MU5D/K64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3253
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_05:2020-05-20,2020-05-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> > In the first generation of our hardware (A1), a whole traffic class is
> > consumed for PTP handling in FW (FW uses it to send the ptp data and
> > to send back timestamps).
> > Since this conflicts with QoS (user is unable to use the reserved
> > TC2), we suggest using module param to give the user a choice:
> > disabling PTP allows using all available TCs.
>=20
> Is there really no way to get the config automatically chosen when user s=
ets
> up TCs or does SIOCSHWTSTAMP? It's fine to return -EOPNOTSUPP when too
> many things are enabled, but user having to set module parameters upfront
> is quite painful.

Module param is not a must have for usage, default config allows the user t=
o use TCs and PTP features simultaneously with one major limitation: TC2 is=
 reserved for PTP, so if the user tries to send/receive anything on TC2, if=
 won't quite work unfortunately.
If the user wants to get "everything" from QoS/TC (e.g. use all the TCs) - =
he can explicitly disable the PTP via module param.

Right now we really aren't sure we can dynamically rearrange resources betw=
een QoS and PTP, since disabling/enabling PTP requires a complete HW reconf=
iguration unfortunately.
Even more unfortunate is the fact that we can't change the TC, which is res=
erved for PTP, because TC2 is hardcoded in firmware.
=20
We would prefer to keep things as is for now, if possible. We'll discuss th=
is with HW/FW team(s) and submit a follow-up patch, if we find a way to aut=
omatically choose the config.

Best regards,
Mark.
