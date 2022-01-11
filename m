Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18FC48B58A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344282AbiAKSRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:17:06 -0500
Received: from mail-eopbgr70114.outbound.protection.outlook.com ([40.107.7.114]:57152
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242138AbiAKSRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 13:17:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7K/w1jYNHo+WzTq/WIP3DbSc0nTURzXfqsI7jaDJEJS9bGEHx/i31oER/j6f1W/VRQQYDTeb0nXu32ns27fD3w2doRgmipewhwyFWfiR+E+UKtMY7Y9JbdFR584RQMw6ReMODdmsmMSCWVSitCK9opzZaV19HdIzCF6hWX+n71vYvWtdJgxSFJeUtX2WRUlBjzq7lDbng4awI0wW9YeBfs1WTE3BDv3t4GgziVkz1UqR1fTJbjF3ZAAPiahASkCgyQdd/2yJJXAJvJwlbb2mEoOOXiGk3MzlEPvV4zH4iUM0ZoO97BtqptvTwz/6Ev/4lfn2ju6M5gKo1qX1j9i0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtGmgnLR0Ow5/H0xBcnrhAmV8LPfTV6Cq5D/yhK7AKQ=;
 b=bqvRZjsrWtRJrc35pk+eT2oKCvLscAozA1HU925yx3uRzyFxu9+/aWshmQGAxTImRBXtw+k6OsPF4dtuMEQUdN6sJRD/x7IfHSUOOx1D0mkVwchMVDL4hzI02DQcdQ+J5A1wX9Hd8PaPvsFGDpqE6BXEsjcdZyyiLytqi2gt0Lj56gs+9BTKIvggY+JE/DX2yAxHGzroq4CTAe2v4T5CsjiWiZ1tLTFYXtjeShR60OWD+BR7fprzNdJiWQCxWoFql4Iv8EszPrYce8ixYKdifYSCaD7udYv5GeUKF4C9ufkmTzavR7mbZZnCJaLWEJBWuY6Y4FgnsEES6URQSGmMQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtGmgnLR0Ow5/H0xBcnrhAmV8LPfTV6Cq5D/yhK7AKQ=;
 b=qccvve+dP0n1sopIMpg58uGGTE1vSzNCvy2s1ixrqvgOKgv/+90pnL3M8EUkV2NfyB8UdFMBP5vxPhpmaOZoyT1WPd0ftxO6AVmcGH4NDzeP15CDWlb7c2c6Eoidziq43BMJMhP3QFM4Nl7yrj6GF0JBTgYZDlJs8o9jWDWQy3s=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AS8PR03MB7479.eurprd03.prod.outlook.com (2603:10a6:20b:2ee::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 18:17:04 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 18:17:03 +0000
From:   =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Frank Wunderlich <frank-w@public-files.de>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: Aw: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb:
 multiple cpu ports, non cpu extint
Thread-Topic: Aw: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb:
 multiple cpu ports, non cpu extint
Thread-Index: AQHYAeKdFqOvd3BDqEyIRmVm5LaE7w==
Date:   Tue, 11 Jan 2022 18:17:03 +0000
Message-ID: <87r19e5e8w.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-12-luizluca@gmail.com>    <87ee5fd80m.fsf@bang-olufsen.dk>
        <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
In-Reply-To: <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
        (Frank Wunderlich's message of "Mon, 10 Jan 2022 14:53:35 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e7e56a8-05fb-436d-f596-08d9d52e91b5
x-ms-traffictypediagnostic: AS8PR03MB7479:EE_
x-microsoft-antispam-prvs: <AS8PR03MB74793F3F57E51434E5F06A6683519@AS8PR03MB7479.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 539Um4z3OO1hqauszf2mlUnQ819HFcXHKszUqFkYf9ikuk/stXTOehEPaS+0bad3ueWDF+VjiJL+hhqqLaVm56jppSsyHeBZlh76S1q8kpJvW+N/H5igb7V8oJe2RHHQ9J1YydKYvUhpQr8kBB6Qlor90u+6lFh/Ux3fbLT5rnOPGF/HkOHvTWrraVJGxEUrMjl2h4D+9hVDdEeywaOJCFpKsJe+yk0knm0OWBnQHaMKugQxr1/iOFeYOIAUafORpHOo+A1J0nVdzTkZJCJcWc1O0Q7vGMP95Y2TJLtvb21NELpWoO24j32XFHr8rSfBRiR5eTgp4UEFtfhX3HgtaqRDNLFPFONl522282wEfX3EL1+70bdEvxNmxq7df+uWqhefamVXqRsogfPupdFj/tBer1KvFnrKt6Fu9XUEXfdVIth9CEOmywqcYdQOODhkHMyapZzXy4FLDU/09eFVXNs/1vrxjqaTuneonNZQ4NHbelkWU9+QOVMBPemYzUf4n1HoJA86ZHe7jZKFgYs/viMfePTpReht4Tyoe/yCRnFAKLVMUsXJDbJV6drll/eo+j81QQRFFguRnffVltQOmuDGc3MnXBgPZrnbeUh5oFy9Yp/e1hcKySd6kT2s0JVwrC8yiBNspqa0ylNpxLrxVPw3UNnq+Akdmy3e0lesjzeUxvlh/B2Eq94AJgQIaWvXTu++TxnNWyG2k5jwNLfKuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(5660300002)(8976002)(6486002)(8936002)(64756008)(66556008)(4326008)(8676002)(76116006)(66446008)(66946007)(508600001)(6506007)(26005)(66476007)(83380400001)(38070700005)(316002)(91956017)(54906003)(2616005)(122000001)(2906002)(71200400001)(6512007)(6916009)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?c6kJjlNCDP9/fbA3bQCirBTE7B9tTBBZzt6q2CNhPSBgfLmr+rn1S0Ea?=
 =?Windows-1252?Q?yKaFGjarVL7E4vQ/FNiL1MlpN13hWpIoxj2Mtdx2QHXmeClRxPt2uiK2?=
 =?Windows-1252?Q?KiIMTJRrNhqbsAAd47j1w2BNCoQRjjAYzNQV+7y3OhQDTF6pvGQ6uEuR?=
 =?Windows-1252?Q?S87u8ATRzMfT90xw8U5mj9QYPi0G5U/gBKw8gwKyYf8gs0w4kqxhrdkU?=
 =?Windows-1252?Q?gv3ucJrMx0lW1h/vR0Ssdx1FgkWdqfIo2CvsiLGpS9fXDOTeN3Bxwynz?=
 =?Windows-1252?Q?BZ3FWQOT8UZ33uw2wP1xWDwLLDBW4cjPa664IdepqYtRMb3jezLG0++t?=
 =?Windows-1252?Q?/OgNfQTdMAPknTrHYaixK+6yJC5RjeUCkmHRl3N8yq2larJGyPLXa7Ks?=
 =?Windows-1252?Q?FwW8Tn41CcBFK9Xjkbe7P8z5f7AlZPh6e6J8HRWnTPR01C9dBYHwMY6k?=
 =?Windows-1252?Q?gBXJGO3ujXSUNjPVbD09E1VV0/eKv49mhbmJIhEAXJCoLFUdZrJOnKJX?=
 =?Windows-1252?Q?tfrJoosT6ACRnNR0Vh77qDXDu6IQSsvbSTb/V9X8ebcIc4b0HHrId0Jd?=
 =?Windows-1252?Q?ixa1OlX8ac/pTZERt0+EfhiiexsSHkWGn1tNqiqgleuMPeYZCF8CxaGd?=
 =?Windows-1252?Q?rJzyd4M5Ectj+vBY8OIjhEUMgh63wqX/ZEtRmfdkrF5tbvoFNWsy/IHn?=
 =?Windows-1252?Q?ZUhufWj+U2hHBSf7HYRMTUBV228FfDLjOgbwjmdQelBqxgN2988Xxnad?=
 =?Windows-1252?Q?IOUmekWP0ihbu3cKOLgtJbj4DaOF9HP9Y1nlYu5BtUaET9dkE1Zw8NSA?=
 =?Windows-1252?Q?7Sl8HJ+dGRqaR91f+Dfm8dXa/K0Wxt4tF8/XDGlMkHZ3wtSmX2nqO7wL?=
 =?Windows-1252?Q?CXWzHoBgfwJKsJyek1h+nsWX561nExX59JuRsvhp8CoOLbg8pIODj7oN?=
 =?Windows-1252?Q?iLkUmyPBegGhtbQbposkT5UKMu0ZW3aWGzvnFozFuujRruj9OoNKEZnp?=
 =?Windows-1252?Q?JdP/rfthSe06QTSHaJ9CKZ/AePl5ac7I4gO1IlWxMFETgi8L2VgYnRvb?=
 =?Windows-1252?Q?BC2qGP9nnBU7RKkCIUT1RZNfI+ZFEHO7m9YHRHBGl2CQ4n9nzaqr7Dhf?=
 =?Windows-1252?Q?FNnikzvLfB3nkcj1uCINPyznKxIb/38XavF1CpXZoVzD2uSUizH9dOCI?=
 =?Windows-1252?Q?q27YOHspKWn6gr+S6m/LtbSYz5Dgm8TAUJpIMKFa1kRJ3HCqm1niYUf5?=
 =?Windows-1252?Q?IuMHqN6BNwEK+bS6sOvG7hb1v7AaJ5RcXHtO0vKYb0+gLCMFt6YieOkA?=
 =?Windows-1252?Q?Cf0P+DLoXTIFX59zUW19KKxDvRgP7Ppx3S/RiOLggAe32yNd9+cpb6xV?=
 =?Windows-1252?Q?ithKPv5P0rmBsMtUr/LRB/p5VgHKT5Fd3hkqn5NzClmN64r76Lo940+X?=
 =?Windows-1252?Q?ErpHDUH/vizZp64vSUm3ayBIeV6c29Zspqozob81I+/UybyaVt7Bvz3y?=
 =?Windows-1252?Q?P17q4sPY+hNnGRq5V1KG22ZL/OpYaS89PiCp5czo/LAkGLxfNmz9eQ31?=
 =?Windows-1252?Q?TjDgTYsx2++4GbkFJfSxwthDuJR2X5jy2Z51sUQtCrpM/nU7icLE8qd+?=
 =?Windows-1252?Q?NFwgKJ2BDgutapWuCj2caPhdEGqRgxGPzhFpERA1ejdRCQeQpcf9iY5m?=
 =?Windows-1252?Q?mvY8QNPSR/0aPfdLEIwTFp2HMldae6F8k0FyLtf1rQ7xGt7RYQc3D/rA?=
 =?Windows-1252?Q?jxlSG8qPoceytb21vmI=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7e56a8-05fb-436d-f596-08d9d52e91b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 18:17:03.8531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7iI1f6iMDyHw90LjRPCPEDueCQrIT1iPkgY9064WIB2cw5iNoUHaQG7Xhpssa41zC4dhgjafSfjxUQa/S4N2xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7479
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frank Wunderlich <frank-w@public-files.de> writes:

> Hi,
>
> i have 2 devices here i currently try this series.
>
> 1x Bananapi R64 v0.1 (mt7622 SOC) with rtl8367s (sgmii+rgmii) - configure=
d to use extport 2 in rgmii mode
> 1x Bananapi R2 Pro v0 (rk3568 SOC) with rtl8367RB (rgmii+rgmii) - configu=
red to use extport 1 in rgmii mode
>
> on both devices i get mdio running after additional reset in probe and po=
rts are
> recognizing link up (got the real port-reg-mapping)
>
> on r64 i get pings working but tcp (ssh, http) seems not working.
> on r2pro i cannot get even ping working (but rk3568 gmac seems to come
> up).

Luiz, any comments regarding this? I suppose if the chip ID/revision is
the same for both 67S and 67RB, they should work pretty much the same,
right?

>
> but i'm not deep enough in driver coding to find out whats wrong not havi=
ng technical documents for checking registers to values needed.

Ping working but TCP not working is a bit strange. You could check the
output of ethtool -S and see if that meets your expectations. If you
have a relatively modern ethtool you can also append --all-groups to the
comment to get a more standard output.

You can also try adjusting the RGMII TX/RX delay and pause settings -
that might help for the R2 where you aren't getting any packets
through.
