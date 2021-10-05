Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7E542301B
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhJESjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:39:39 -0400
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:32604
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229577AbhJESji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 14:39:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDB7qEqMeuRGO0+PlQZFPIMvlFEWRnQY+IxM+cgVqfHjd6TEPg2p4TUpVCRPmcT8ejwtHSjGjS3HCCLNzRaOoutQefrvGKIRFyPPJhjTeqa8X7kQ2HDlIPdkxTiInrk48f77azQD0PTBn8/iNWXxDT66CEhUhPbQVNTUQYG2+DpEt3ipG0lxwSdqNnwvnkCsYpuAmpnUbneJUO+nhOfz2CRlLrEmleKVVcKoGrfUFnyDd+lwFrog4LdmHLsn7yjPidg9/sFU6MO6teFXKlb+g/6R4Xp4ga0FkBkUYlF3J2coZp5AGUQX270uzPEotDsGrNk3RvZ/P5QfYiiA61OxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5rsgGJmjJJT9pWjGGXj5z1LgKa811sZUO4iuno0Tx8=;
 b=U4xpv5Sm2aM+RlnntPwjXZ8ANFgd8WofwNS7wqrce1Dc8D866VoMKZWsOrVBZhbprjwvUXVHLRit5MSwE8/l4hzhlBeB9s9n1W/GALZmhrweoLDLb9E3SPVExpVbOg4izJ2Wz4701bi18pznFvLEXk4enQkU6IXnDdaoiAvgYtKAKFxRcYJFmsYIA9Xif94+fCqhRFIChimM1+Y7Tuj1HC990douACaKF3CSfWn5QZt0JALvSmuJksEP4WyypKP/6sQf9AlDi2S061Xk1o5cYieeHuQCSHfchQJTMMefNW5gQgiiWOoneelbSKfn2g8BD8y+76boQ2fadrtV87ZfOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5rsgGJmjJJT9pWjGGXj5z1LgKa811sZUO4iuno0Tx8=;
 b=a3TZVrjnK+e9sPVEwTue4L+YG4JCB2gBdjAOfLZOWVL0yYii3RpSg40Yil3B5LBT9hwQ2Gz37sk2gu4NB/hSs0oG0xsoko+3YVz04eFeMG9DidC1WS64x9frQP3VUqh7kCKHV5cQVztpEyOSJqPDkubj+76MyhKWSMxyRgef1g8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5503.eurprd04.prod.outlook.com (2603:10a6:803:d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 5 Oct
 2021 18:37:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 18:37:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v2 net 4/4] net: dsa: mv88e6xxx: isolate the ATU databases
 of standalone and bridged ports
Thread-Topic: [PATCH v2 net 4/4] net: dsa: mv88e6xxx: isolate the ATU
 databases of standalone and bridged ports
Thread-Index: AQHXuX40Ngu/3KAnZUSh7FsMysn2NavEu5wAgAABkwA=
Date:   Tue, 5 Oct 2021 18:37:45 +0000
Message-ID: <20211005183744.scf2cluzgavub66t@skbuf>
References: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
 <20211005001414.1234318-5-vladimir.oltean@nxp.com>
 <874k9vb9w9.fsf@waldekranz.com>
In-Reply-To: <874k9vb9w9.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52143fce-e1b3-4414-f429-08d9882f3932
x-ms-traffictypediagnostic: VI1PR04MB5503:
x-microsoft-antispam-prvs: <VI1PR04MB5503F72E9D3D83EB56AB3B31E0AF9@VI1PR04MB5503.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /zoliWe6qDFXHFQFStdW5NoyxzlHDb9zadC+pq0kR+BZGvOc7raam8DNVMBPgfTjGGA9DLIrmk1pwS8d2+ylBXvJEnkEc+OAaMDeH5uPBBp+oJWYb6gCe3zdxjznpzN1ESusdWoQCy2uhaMeYMttL+zkoAYsBxCQyB7szDvjOu3JR5GRBPrDjZZ8KYdu240SfSsOPFREkkhrRJauMu7eWzjVqppoKgOWsOsDKOWABvC4sYn7pwMCPVczQh66RM0LJ8Kuj6QN+JeHJEggpACEbdbVJKlFWOU4dxxUkKIFkGPQpI+B4dfox9k5dajmjmGjqGXM6B4z93HtSALPYQVztrCvBVqMLyrt2oxc9WtB4husjC8fbvhOaMsxdSmhamBWSoHJQoV2SC+j0TnPcSVTBVMn+Kaak20CvCAwAOouPFf8MYSHoapS0G+wJRstT+nKytIaB5p9MTyEJb+sRHVzqi4YvGgJfvMlmeevrkW+55s+WRTcUQlY+eSis5+vv52LHmYQbz5ZgUnzkMKOnpZoFRrMpgNXiv0634uZdzduXmcAwOB3/KwU7gtU12YDcuxUAlDGiLLKklccBqL7sa1Rekg6h/d5VMJIwILmy3VCMTSt74tuEKsEx7B88KAizouNX2LfN2OLZfZJi0ZGE5QS0nguvCmeY013EhdMAQlpEneSccyu2LO4MV9QGfxn5gU6TbJVOhtEBLSroD4DW9LO9AferjTyTOwmVwbSydAOEfNffuZvuCocCCDa04C1Uwnx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(5660300002)(122000001)(1076003)(86362001)(26005)(186003)(8676002)(8936002)(508600001)(6506007)(6512007)(6486002)(9686003)(54906003)(2906002)(4326008)(33716001)(66446008)(83380400001)(76116006)(91956017)(66556008)(64756008)(71200400001)(44832011)(316002)(6916009)(66476007)(38070700005)(66946007)(38100700002)(130980200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LHHRDxE9Q46VAp0A7Li5Bqu1SIJ6bUdBJWHV/DTNKT5AKkQ6hvmseMEVfCKV?=
 =?us-ascii?Q?IptFOJPliZtxhYHeYz3GGr9Bxq8Rxd+zVFxTjEUrACkI5PH929W6/8IIALH0?=
 =?us-ascii?Q?yuwxfmoduS8Z+rR7xlPFN2ORG/prms+20AF/LkkOAEo+1v2+48jheAoJlDfZ?=
 =?us-ascii?Q?DYVjcu7pCOne22ymeGuZvLjkG/7671Pm51v/YhR7+7gQFZ0RwaYqJrtK6F+j?=
 =?us-ascii?Q?8Ba52YDOuz4AabtvK7YaWPuSL3DUWPb0IkEoJ/Ir1+JXULNdu7/9tA8ISA53?=
 =?us-ascii?Q?/ZqIIyUyrI5lEbY6K979/0DTmOOElDP8t0PVVpaycVcS10dsRzaD4wTHqSKc?=
 =?us-ascii?Q?GDOqDRek/jQaLkqg0duimi8O/FY2ikyFScdGIerEqCqS3iNqWbTNPT5dSdVh?=
 =?us-ascii?Q?0/JlBiCu44lK8pA/2H+etBpmxpKpHN24SBPT3EWdjJuU3FGOrzrBWOzcyhlH?=
 =?us-ascii?Q?17UE0ehRtm1TZ2Q7qYRKeZU2CDmaCX7aeQMR4aLj7LGGYu/tmvMao7ibcWR7?=
 =?us-ascii?Q?90F7GRhiJDJO2FoKDCm8ub+EQV42mskwhPmLZFNjx8mzZ06Teln3gVbG3Uys?=
 =?us-ascii?Q?BztH5Wt/EyUxQrvvgCJYuWFH/0MBQIYuhiLS8Zah/Nac26qC9macsevyJAXW?=
 =?us-ascii?Q?1Ap+HufMDa+5iVqKWJVKoJV/mg6dOaj6JrTndBHCoFPM9pmD4hoDBua7Dbis?=
 =?us-ascii?Q?Op8YT0FmYR9Z6AfDVikktVI8jIXhhDZO1dSxegpPdRqpJ4fi7NtRDs4xrmt8?=
 =?us-ascii?Q?ImmG6CfelBzoqHx3f20yC+JqIE4f35zJ2Nnpcb2YQvVls4s62rEiCRh2O4eC?=
 =?us-ascii?Q?t0FLyG/J3WlY77k9z7OCtzjkMz9IQ1m+uc82jm/ZZyJWaWFfZg1VVTf7mtmx?=
 =?us-ascii?Q?0KTMn0VjoD4nkpJz7gWaG5Eup5Wbp8BzpuXJAVnpxJZ8dCufwwKzn5aZpaiB?=
 =?us-ascii?Q?gaxL/eyn8l0ususxPqyLWBlStKcKatsOCDWX1H7My6JPNMj2Q3nOb8+36unq?=
 =?us-ascii?Q?1+gBnNWNrdjtkUvzvVBAgsADJaJ4vUcrLp1alk6///O2LWYBcXqWaDkQiJVV?=
 =?us-ascii?Q?d6aC6CzVfSVavbTwBtb3MlMfEvloS668Ca1x0OeokHX64N0qE1Sf4iobhSfT?=
 =?us-ascii?Q?obftIceEje3Y4yayGtbFLN9vVAjLqVEzVhr4q5X5pvC58CgPXEcaxX7VbvXX?=
 =?us-ascii?Q?4yxYOuBIZ8XcQ11PDYnLpXrEEjsR3kTZMhy+MsPo1ej58TBtnRHkxP7S4b1E?=
 =?us-ascii?Q?QdIhjltSbyYVZky3w53Vt7hDbBIbVhN/ydyHLlveRfQMQMdu0fVH0085kFtv?=
 =?us-ascii?Q?vzat3YlF955dvz2YkSOJtLqOutLSxgYRvjowwvM9keKI8A=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C2DBF2F2FB7A144A30889DD6BD6D202@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52143fce-e1b3-4414-f429-08d9882f3932
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 18:37:45.3427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qy6OzwJnqVDi9tiHMuPaWlUJifrnfyUgb9kAEeYtKIOdxKuMO9ULXk75a/bNTflEFUJ06Y3Fxgyua5B5MJgi1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5503
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 08:32:06PM +0200, Tobias Waldekranz wrote:
> I believe this patch gets aaaalmost everything right. But I think we
> need to set the port's PVID to 4095 when it is attached to a
> VLAN-unaware bridge. Unfortunately I won't be able to prove it until I
> get back to the office tomorrow (need physical access to move some
> cables around), but I will go out on a limb and present the theory now
> anyway :)
>
> Basically, it has to do with the same issue that you have identified in
> the CPU tx path. On user-port ingress, setting the port's default FID is
> enough to make it select the correct database -- on a single chip
> system. Once you're going over a DSA port though, you need to carry that
> information in the tag, just like when sending from the CPU. So in this
> scenario:
>
>   CPU
>    |    .----.
> .--0--. | .--0--.
> | sw0 | | | sw1 |
> '-1-2-' | '-1-2-'
>     '---'
>
> Say that sw0p1 and sw1p1 are members of a VLAN-unaware bridge and sw1p2
> is in standalone mode. Packets from both sw1p1 and sw1p2 will ingress on
> sw0p2 with VID 0 - the port can only have one default FID - yet it has
> to map one flow to FID 1 and one to FID 0.
>
> Setting the PVID of sw1p1 should provide that missing piece of
> information.

Hey, Spiderman!

Yes, that makes sense, and is something I can actually test, no need to
wait until tomorrow. Give me a few hours, I need to finish something else f=
irst.=
