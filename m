Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D983A327F9A
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhCANfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:35:36 -0500
Received: from mail-am6eur05on2075.outbound.protection.outlook.com ([40.107.22.75]:8802
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235733AbhCANfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 08:35:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In2FYr7ke5vRGgSckPcKj7/0HirMIaHLZgM2ha4Ro//XVr8+Js/Q2ON4LRvv0RIljTjmBhJpirRWptFt7GQnCIpGkbj+WUyV+xh40ErDKfHhFuk786di32pJxljHa6GITAqhU1shgVwZLxbeHEWz4mBiZiPx8JSe3+IKFXIw11lP6EGnhlMX4JIx4y1CsQ4mecpdOzshUArVz96BhIfhtyudEkNnWkt6dvJIwlUXYCvpoDMm9L7ZeRbrAmm4Vy/O+oPRzd48TxQvuZn9Yq0lGOiWVoKkp0jGmkn+XqgNXCiGxcdSm6n+2HzbSHunk91cFr2boezRj2Fd32zdUv83jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LkT4ZgkpUk3EtUyMA6omLYs0ZWl69JTtwWKiHxPIOE=;
 b=MoF6YAxARJ7CP4rJFe8xUPIaHhX3yREJ3ejegKlvjPqFIsqszMuvrGKT9F4uwKT569cGzOMnoGGpWBpJXl+QBsHFYtO+Cg7LQY0a3pwcEJsVpgvvoPcmj6unGi7o7724crKa2VFn/AURRug5IKbYWHFI3o98wxbUawNiNs1vnxx1Bz61pAJV1gRZd3n1gwgY0U7ywtG+u1ieXShN7baCSSrQt8fs1wDPBoCUvsKaXrzKqh8OOySMFqLcj+VoNFmJdBKzEpQXJyjBYpw1Y3DKvvhsXdPdfGyHIwOLvnc5ryTOxOp73HFmY8wn2LKfZAaLRIZV82MEb9cmHJX50qbJOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LkT4ZgkpUk3EtUyMA6omLYs0ZWl69JTtwWKiHxPIOE=;
 b=rkEeHoWstEskoW7Cb89bdZXlHoXDzh0QEQDZ09d/bOst+TwrEAcZWxBsV6kCc10mpKcptPjOGyE3Mjv68SalEcUtycEsE8Y9gQgskmnA+JuVbOAFZPNfx//L9PWzz2ndH6ru+uL7jfHbg8ay3zyl2mXUkSqd9kjq8q1xE9hGiBw=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB5140.eurprd04.prod.outlook.com (2603:10a6:208:ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:34:16 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:34:16 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Michael Walle <michael@walle.cc>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH v3 net 8/8] net: enetc: keep RX ring consumer index in
 sync with hardware
Thread-Topic: [PATCH v3 net 8/8] net: enetc: keep RX ring consumer index in
 sync with hardware
Thread-Index: AQHXDoyjdPcNhFvDZEWZfEBdqu879apvGmWw
Date:   Mon, 1 Mar 2021 13:34:16 +0000
Message-ID: <AM0PR04MB6754887223A3BE7FD4A227DD969A9@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20210301111818.2081582-1-olteanv@gmail.com>
 <20210301111818.2081582-9-olteanv@gmail.com>
In-Reply-To: <20210301111818.2081582-9-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.4.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a726fed2-458b-440d-563e-08d8dcb6b5be
x-ms-traffictypediagnostic: AM0PR04MB5140:
x-ms-exchange-minimumurldomainage: bootlin.com#1165
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5140446C3AABA40712CE1388969A9@AM0PR04MB5140.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HweCgiGADpyNs23FgvZLClLfQ7DYUPuEV7C7hsvdNwKTZyZ43NAswWG6SZv1SjmYaXIgqI24/ubUI0vGA86ZGUbG8YzUw6ugmp1T+UzbDe2B4qcYaDQSCoWtgQcynGPw3wMlUr9D1nafiQFqXlSbwRQsd0l4obkm27E8gO3ez5tOD/rU0iLLUiO9fL0Hg9tRd82mOWoJ2OjwcjnRMkSCAC+Bm1M7nyxlDlRtXqDUKtSd71Kap7aBpZ5C+NW6uP+qCQ6F6YZUrej036WwHizTOeVXXjc7s5KzYUPbjmAJbuozRtyCo+OL+DKNOP0NY7PdIXlDYoAqSxjaUu8pvJ/mbzbW/7pHSMk2ymx28+p/zoxy6ObunK0nLbteaPVrJ8uo4D/rYQ3Q5ywqMz0iw6J8CeT1rWObN+Cstgc3j2ZBvUM4Ls8k1/PAJamhjpWTXWvXfkaAFROQbuA2pEsKBzWxHXeUL0QMUT1x0dnCGabRNMxCIL6xaPD/ibR8URuJ8qGKD56cE1RLe8QvPw6zoCzVzDJicX56BuxGeypVtveKBoq+ZuaXbtIvT00Fs6OYsegW5pdE56ryI6wgeleY7bvXPa3kpvW4T0J88C0pYOaLQUk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(76116006)(71200400001)(110136005)(64756008)(66556008)(66476007)(66446008)(8676002)(316002)(9686003)(5660300002)(33656002)(66946007)(26005)(2906002)(966005)(44832011)(55016002)(478600001)(186003)(4326008)(86362001)(83380400001)(52536014)(7696005)(8936002)(6506007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yYNZi0fO0YGuGZwevsSXfNJKoKNJo5rgVdn0VeQzaGA2EMkZ1WVZAbQUuvfS?=
 =?us-ascii?Q?pd8Huo27TrG8wEASEfKNKAvpMkCSbyfOQ4vqKcdKT0gS74Bz8Pq2as1f5pwV?=
 =?us-ascii?Q?VpHQ7PourBY/LMS8UCaWlewdOdAKyNEyNhCqhb94eJwbvdDcMLsTx6EEWnLd?=
 =?us-ascii?Q?xsiH1QS25UA7tOtJZjiNuTyqKjm3HTnUcf+INaS4lwwfEMwCg3VARx0ZbFOe?=
 =?us-ascii?Q?xFSljvrcr2tIoQSNT4N2UOdp6u81nH7SQwe5qDVJgXsZw5ljkdoHuYaJfT6R?=
 =?us-ascii?Q?W03qrF70XyJ/DvAwmqP7plUrNy5xR5TT93AVa8aqhLwjA0w65D+uZ8Yp7atu?=
 =?us-ascii?Q?02E3esVubc62eU17XrV0jCkw7SXH9U/ZwAqlsHRC5Ininqmm124mACWiB8Pf?=
 =?us-ascii?Q?vifSxArIc9jvyqDoLylh1tGaMsDHoFCLL9MiUxFmXufwvwvEEt/EpCi/bZ+V?=
 =?us-ascii?Q?onAptO0RTdYPZms5nBkuaXbh0rBWyQQtYAq1HTP+EhP2QJzvBO0uVaYlZFqV?=
 =?us-ascii?Q?sfFPfr69ZSqYJCie85fDghY9X+iuDiZOnzugc8CYlFhlVP7y1kxAx3ZYLUdR?=
 =?us-ascii?Q?nablVbQL50OIRy46OH0mgr8jsQuBNaDUjZgD5cqYDoeeVdWqmyL+yDb0C39k?=
 =?us-ascii?Q?DV5vW/o1lmWYVSYwfprCT+l6+qa5kRDaGtqxVIrJKgpcIs+xtVJN9bQ5VvPi?=
 =?us-ascii?Q?DRuEfui521d9GyZk9mO89++ut8orR9yzXWArxgyXvU68XWIud0QeLtTe1kxv?=
 =?us-ascii?Q?xoIqdtJI8WchQl/ycXCBFCKGo9zRwuFOVBQ4hSR0HVZdPmR2L948ziClMbXo?=
 =?us-ascii?Q?HdJYHn4AGyqMXuTfu6N90EXwgzFGuLPK3+OQJ2D9jJ6XAhXAtnDiQawBykyw?=
 =?us-ascii?Q?80DiYJ3qRDZWikHZYfrT5CoJ4eYMkJHVcxs7PgTtB3Ze6fLeTW8jdAQsb8QV?=
 =?us-ascii?Q?IJ4kBJWgWMd2eHbMpj44G3ZspjJx3xrdk65fRKc0D4Hqar2KCyiGVwpm5fT+?=
 =?us-ascii?Q?l0dAQEXcgon05jowNr4tMKDSGE7uoZZyBm5tko5hujeGetX65s6x8eob00cx?=
 =?us-ascii?Q?lBgVob8K00OJWF9It57PIT72jVPeDuBhMDBUkzDO0mbfuolGE0kdmpKJqzR7?=
 =?us-ascii?Q?30S+NKlHNe3w4HZNnLRPPZY2EkmGVoVMs3EhPAv5XYc79hEwYAgY7cn+Gh1F?=
 =?us-ascii?Q?RKhLD2T1ch5E81HgcEdCIg4a4czwGFtiJvC/xmau7atgmlIFAa2WTWL2nQ/K?=
 =?us-ascii?Q?FZB+mNRs18nqWciANhaMqIjH1MMNU5ESkNSxkECnorbd9gyFPFyJ293i8Wmm?=
 =?us-ascii?Q?NRA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a726fed2-458b-440d-563e-08d8dcb6b5be
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:34:16.3834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QAoy4DUJIcscEhCuWJq6lJYyZzj7bqorM6lAb+aVr6wjC7prZE/NlgBPDCREW0QVAYEck+mp4tzuFi5edrotbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Vladimir Oltean <olteanv@gmail.com>
>Sent: Monday, March 1, 2021 1:18 PM
>To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
><kuba@kernel.org>; netdev@vger.kernel.org
>Cc: Michael Walle <michael@walle.cc>; Claudiu Manoil
><claudiu.manoil@nxp.com>; Alexandru Marginean
><alexandru.marginean@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
>Vladimir Oltean <vladimir.oltean@nxp.com>
>Subject: [PATCH v3 net 8/8] net: enetc: keep RX ring consumer index in syn=
c
>with hardware
>

Hi Vladimir,

>
>Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet
>drivers")

I just realized I introduced this regression with the MDIO workaround patch=
.

I you look at the initial code from d4fd0404c1c9 ("enetc: Introduce basic P=
F and VF ENETC ethernet
drivers") , the consumer index is being updated with the value of next_to_u=
se inside enetc_refill_rx_ring():
static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_c=
nt)
{
[...]
       if (likely(j)) {
               rx_ring->next_to_alloc =3D i; /* keep track from page reuse =
*/
               rx_ring->next_to_use =3D i;
               /* update ENETC's consumer index */
               enetc_wr_reg(rx_ring->rcir, i);
       }

       return j;
}
See:
https://elixir.bootlin.com/linux/v5.4.101/source/drivers/net/ethernet/frees=
cale/enetc/enetc.c#L434

enetc_refill_rx_ring() being called on both data path and init path (enetc_=
setup_rxbdr).

With commit fd5736bf9f23 ("enetc: Workaround for MDIO register access issue=
") I messed this up:

I moved this update outside refill_rx_ring():

@@ -515,8 +533,6 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ri=
ng, const int buff_cnt)
        if (likely(j)) {
                rx_ring->next_to_alloc =3D i; /* keep track from page reuse=
 */
                rx_ring->next_to_use =3D i;
-               /* update ENETC's consumer index */
-               enetc_wr_reg(rx_ring->rcir, i);
        }
[....]

Updated the data path side accordingly (changing update to the new accessor=
) :

@@ -684,23 +700,31 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_r=
ing,
                u32 bd_status;
                u16 size;

+               enetc_lock_mdio();
+
                if (cleaned_cnt >=3D ENETC_RXBD_BUNDLE) {
                        int count =3D enetc_refill_rx_ring(rx_ring, cleaned=
_cnt);

+                       /* update ENETC's consumer index */
+                       enetc_wr_reg_hot(rx_ring->rcir, rx_ring->next_to_us=
e);
                        cleaned_cnt -=3D count;
                }
[...]

But on the init path I messed it up likely due to some merge conflict:

@@ -1225,6 +1252,7 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, st=
ruct enetc_bdr *rx_ring)
        rx_ring->idr =3D hw->reg + ENETC_SIRXIDR;

        enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
+       enetc_wr(hw, ENETC_SIRXIDR, rx_ring->next_to_use);

Instead of:
	enetc_wr_reg(rx_ring->rcir, rx_ring->next_to_use);
	or  enetc_rxbdr_wr(hw, idx, ENETC_RBCIR, rx_ring->next_to_use); ... if you=
 prefer.

Obviously writing to ENETC_SIRXIDR makes no sense, and just shows that some=
thing went wrong with that commit.

So the blamed commit for this is: fd5736bf9f23 ("enetc: Workaround for MDIO=
 register access issue").

And you could merge patches 7/8 and 8/8, as they both deal with fixing the =
(merge conflict) regression
that I introduced with the MDIO w/a patch:

Fixes: fd5736bf9f23 ("enetc: Workaround for MDIO register access issue").

Sorry for all this trouble.

Thanks,
Claudiu

>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
>Changes in v3:
>Patch is new.
>
> drivers/net/ethernet/freescale/enetc/enetc.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c
>b/drivers/net/ethernet/freescale/enetc/enetc.c
>index abb29ee81463..30d7d4e83900 100644
>--- a/drivers/net/ethernet/freescale/enetc/enetc.c
>+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
>@@ -1212,6 +1212,8 @@ static void enetc_setup_rxbdr(struct enetc_hw
>*hw, struct enetc_bdr *rx_ring)
> 	rx_ring->idr =3D hw->reg + ENETC_SIRXIDR;
>
> 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
>+	/* update ENETC's consumer index */
>+	enetc_rxbdr_wr(hw, idx, ENETC_RBCIR, rx_ring->next_to_use);
>
> 	/* enable ring */
> 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
>--
>2.25.1

