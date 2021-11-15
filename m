Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2165945053A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhKONWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:22:38 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:50828 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231545AbhKONWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 08:22:23 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AFCwVZF021859;
        Mon, 15 Nov 2021 05:18:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=WH/AyC5GtNbIC+KH2TWX1LMfkWcIQg9fBSH8Sua1G00=;
 b=IMffDl3YWSKw/zIkJREwaKXUAq2V/186Rm+/C+CICl/WMlBhfZab4C47kkOVyEzUHj9r
 xf5plouag/y/n5z+8LjjX5TV/H98TlNNrr++mmPB9K3/EaTtJrkdsWL/BLFoXe4EkUM6
 9CVy6dU1X+BZG6hecK03+uKKtXt2D8jfg8udRCSVd6ER/eQ+pbPWIK75Nr4IA1794api
 3WKyj4NyxcJifXbyl5EOhyyGNAXQ6s+2M3d38zuabsZQf9o9jk0PDx0q8G8xSzk0IWsn
 NAIadkzxmpij3D89d92uLvMGxMV1Bt5Xq3PWB7/nYJKIs+ppJcN5+9SC7Lg5/brcde3O /g== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3cbbxrj1wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 05:18:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYhJaGxD+iCk392g8gVsXyt01xJNBQMRY+YWRqJsWy+MHlwpgU1ZgbR+U+hH5zlVmNGAbslNoAFGesQ7IDJMEkhvkZobszNq7BtBdVBnjWn/ig4XthhskIYIg4ieFM2noIRVdKzBUt+Zw5+vZhddrBOX7Aa0Mbno7apy4glOOrMVobZl0da6kjpm3mclwZgttq667AGYV5H3qx7RnpEPeb4Qi2wNCjzBK0IVTT9AnSlQSKNUvHwAqpGbHm8tFCgtEEU65eciEeSpeIprH4I50d2xyAiOCL1IxIpfMkezOr/E/WGZ9dtkZ0FTwa8GmRP1j55n7NXcCcsWVlfpLlXuVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WH/AyC5GtNbIC+KH2TWX1LMfkWcIQg9fBSH8Sua1G00=;
 b=dZlwnNZc2NnYIade0MbfA7FxxY7vtpwpQPATBRpONMcr34sca2YyLOaw2tLmO8Fo+e0GLS/X4J5wI811TWSzfh+pr7aHcm15ui3/x9IaYC8pZkrC2+YNDXv1zSH1g1oIYCUlW0TwYNIaaMR2hlL0eiH0a5f4VQKXAPtQP9TJUSdS0cMRB2MglbveeBrJipSi7gNKCkvTO+sMSxjeg1wxWrhq4qOrdpv3jQcAaETIxgaBiFEwj/3gaTl/CmsmlMMREIWECGQIrRFQWzqA6mUYH0RPss1xQyndxW/o6YfwzNXG15EXW7H+YdWGDtlv5jT6trKLkfoFOyi/f7SYTtYeJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WH/AyC5GtNbIC+KH2TWX1LMfkWcIQg9fBSH8Sua1G00=;
 b=vhEPDBXfMIevrFVzYRIH34XI4zdDgjTKLxjJhkag/gwp6roL2q1vPNOUUKwVtWdTd4lnXaQrkyCEFdXXtfJn+mx1LRWLqvWR2BqOhGDuWj9sTxAQkBs3IeZE+NTizal2RbWpJa8FnM7UGKGhseoDGjG+qP0koD6BzfxgwP4jM5M=
Received: from CY4PR07MB2757.namprd07.prod.outlook.com (2603:10b6:903:22::20)
 by CY1PR07MB2522.namprd07.prod.outlook.com (2a01:111:e400:c61b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 13:18:48 +0000
Received: from CY4PR07MB2757.namprd07.prod.outlook.com
 ([fe80::18cb:253e:25e5:3928]) by CY4PR07MB2757.namprd07.prod.outlook.com
 ([fe80::18cb:253e:25e5:3928%5]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 13:18:48 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [net-next PATCH v6] net: macb: Fix several edge cases in validate
Thread-Topic: [net-next PATCH v6] net: macb: Fix several edge cases in
 validate
Thread-Index: AQHX1/gcdaIdJ/IaBEiurm8bcTecAawEldfw
Date:   Mon, 15 Nov 2021 13:18:47 +0000
Message-ID: <CY4PR07MB2757F8D13005032AB5AAF10BC1989@CY4PR07MB2757.namprd07.prod.outlook.com>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
In-Reply-To: <20211112190400.1937855-1-sean.anderson@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy04ZWUxNmI0ZC00NjE2LTExZWMtODY1MC0xMDY1MzBlZjIyZjVcYW1lLXRlc3RcOGVlMTZiNGYtNDYxNi0xMWVjLTg2NTAtMTA2NTMwZWYyMmY1Ym9keS50eHQiIHN6PSIxODI1IiB0PSIxMzI4MTQ1NTkyNTIxMDI2ODQiIGg9IlpWQ2l5SEZmaXMwS1FQL28zL0cxV0JyOVViST0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 000e408d-3b75-4884-a9f6-08d9a83a756c
x-ms-traffictypediagnostic: CY1PR07MB2522:
x-microsoft-antispam-prvs: <CY1PR07MB2522F599861E8276C764BAACC1989@CY1PR07MB2522.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VRl5YoAeZDtg4xBnDGHnsSZ+2JFDwq0aldwTYrWDvVI+Qhp8Wy1gPpgt6gqoNFsjRBy9QnPmJDZGzKYv5/hNo+ss0H6Cjd+kOqnuEftOAMEScqvhK69NtOdC2AA1M98xO8QxylIr0oe4d3dZsgeL5s5Qbd+/f2gzIym2v5/rHmo9YnwP5TIZMytxH1PY+4QJg2/0nXYc8aXyvftXuAIddxFNLbMU9DldNo0ZxLZPB/Mi5tCI6oMBKsLCpFJ5yDaiLNEALcWYVoFxAXRZ1C1SLvhwjNpTMX9rctWdoi6kgJXBtJJX/pb4YnnlVDKFxHEOGwnSmCUE5orYJl+VzpDOTLm4x2IUz5AoBwec55omiuq57EonFZiSr3LalRT4rlYjLKnXO4136VZQaEJk/E3OoEghz/sSwh/emTwwABdouzaRH1yM5CibW/lce6dwGwtp0BwlOzWF0e1gXJtMeThAcDbkEi01vGJ3XTTMoklkEewoGQN44aW7DdK4HkWM8xbtSsNa2jo/UW3/0xQTEXlfmImws2yfUTgFw+yMMUhrcCEJoE+mvvKu5PyEArr/AyCIwXPT9ZRT9ABgRbMK+r1kL5GbjZNRtC6d9Bcjm5rJJqn+rjMQwAG+PP2Bmq2hiBaDZ9ITxzerrVLKwLq4kTqxNlLyQAlh/iQ2A5pozleqGbaHIDyZ8O7cUtcuPvEWcGvTG33YjVnbg1CaXdjaWCqEgPr56M0ietpXMGDUf3OIOJLPOt9OsvU4RPnDMbqT/ekA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR07MB2757.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36092001)(38070700005)(66446008)(76116006)(508600001)(64756008)(7696005)(66946007)(66556008)(66476007)(6506007)(110136005)(54906003)(2906002)(5660300002)(316002)(33656002)(122000001)(38100700002)(52536014)(71200400001)(83380400001)(15650500001)(186003)(8676002)(86362001)(4326008)(9686003)(8936002)(55016002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ME20XnNhR8pXQU+v9lS6R2re+su+Ym2XFp7jKWw6CaZBlVSy4wAY0gXO1m7w?=
 =?us-ascii?Q?hWdglK49QoV5eosfEo2ueDUy3mEC32ZysJQOzd12ZfTSqIlUNDJCdrSDp2aS?=
 =?us-ascii?Q?1UDHt/mHNq4w4DI+w2S72t10p5ViCdu9R3UZoQQMQUJuuDpJKX1LXm3PnSDC?=
 =?us-ascii?Q?4zDnmisoSKmytDDM+C8KJ0DUJkHz0PrSl2iIn9jYziCnhCebQwv419M0ZekN?=
 =?us-ascii?Q?FypjwoKrEOlEOVGMFnQHegKMl03T22dnNtw+2qksu5W20FGi41by12dfAsCz?=
 =?us-ascii?Q?hg9SRF54qPqiqwkmn23RnqJlDDYI4ILfEHtQdnbsUGLgTGqvX6mo4QCvNBGE?=
 =?us-ascii?Q?BUQN3Cp6i5Gb+icNeic2Z4hPYIAnTaou2H7mfVedtFYsbRP7FfklnB92UZvr?=
 =?us-ascii?Q?WctXJiudC5I+58n8FyDshAtzQL6OHkznj/vqOmJRb+0SycX1soJUDRqfcTJj?=
 =?us-ascii?Q?34NJkxbRbxwNQvAACUGKvcX91kdhBMi3dLA34Tjabwm9A0P+u18X7+ja9UOg?=
 =?us-ascii?Q?d7AAukBZT79rZWgjH8jehPOCjQPqZL6IUzH+xT2OMSb38T/oHo5mW6PYgJCK?=
 =?us-ascii?Q?36DkyPO3HibwWPIV9ntFNa+FtLmKKIwnErxLXUiN2Wfpqq2m7+YVhCOSvnJK?=
 =?us-ascii?Q?Chd6ACKQdJ9N3z8e1w9msSJBT6XN+MCxiKhDXnv8LzN/bTjoC9GTBYZCsTdq?=
 =?us-ascii?Q?aP5Q/N7oqzYCExuyaZ+GJs5mCzw5NsEqhnPzX9+U37bdp4Al5NjPEtYxTppL?=
 =?us-ascii?Q?8WKuSqRTVs5ZKwbRsoL7J2zPA+ztbCaRCm2X6HG7792Sjb4GU0x8OVpy8C5a?=
 =?us-ascii?Q?g2z165VvuHWrrTYOF3jBOjmf7YP6GqxouiWzFFrQnRSt1B73b3aeMT0ZzNaY?=
 =?us-ascii?Q?KntUJa1wueiojSrfx1KrltAU7tDF4FizzitYHLNKHX4aCQQjLYYTurf5UGfY?=
 =?us-ascii?Q?3wj6FFDB2dJDhhZDlIN3BB+Bmoh77gDh6IsJh4GaUf59yE/182rATkOWfWg5?=
 =?us-ascii?Q?RYWvZtrPcqU/GI5ZsV6dXGY+3JdeyjjdhBcKOU9BZu3KcWsPcTMm74cC4rBW?=
 =?us-ascii?Q?0CAIoQNzGV/xmjf/1w8N5A+7XoRKXFxQM6plKRoS/odtWvyFUMqf6Zk3JXgd?=
 =?us-ascii?Q?sL/efrV3D+VhV+/qxCWz+peb/0YcAOLHW5kgMoN0k8h80tE8dx1X59baea1r?=
 =?us-ascii?Q?7Q4wL7/DYy26OIcPmsURJ2+p9e5z/2cmwPhKHhRCysEzODXWpRzqIYi7BC7R?=
 =?us-ascii?Q?DDyz94TcHwSBqPlvzgfi46u1buk5GAFg4KfbDf+f1xREUHkrPkgBW2GeQfIR?=
 =?us-ascii?Q?YgMexMrfUjQH1F8LoNKk4+GnVfCwT3pr2nKSYX51OiNsWxo02ZkwF48kbDeJ?=
 =?us-ascii?Q?6iHUSFrb7u/vJcfToFAgXdpC1YErTxuDVKfh8fNWmtDyLILU2GKT3Vz7MAA2?=
 =?us-ascii?Q?V60mpNbzfwsl56UixQi7Nk266ppo1qa5zkKPlLQuFL976heCzJB/MPT4D3pc?=
 =?us-ascii?Q?vs8Wa5fwPpUuu1Bm0QPkcDubAYdYHQneeK7FbXJarGGJrvJ5aT1p6cc1G2Kb?=
 =?us-ascii?Q?iIRxzoOxeoWWXIQC1MIyJz1VZLEcOxTYy4q2ld8hzuuiGgx1pWFCVdqZ2F/2?=
 =?us-ascii?Q?r5/p2+vo98eseFC08ZMeAkiIzyuEeINab97rWr983Ved/6ImyubOS1iMrObm?=
 =?us-ascii?Q?A0h1Zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR07MB2757.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 000e408d-3b75-4884-a9f6-08d9a83a756c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 13:18:47.9821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EMjXC8GhIPFe2m24daGtSErX07H2w5iN8t6R/dN0oLwrgH0NJmANRC6WTqJwL3c/7ig17kG/tJcbw8/f2BbEPxKx9AHVwc4M7IgnHLx2R5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR07MB2522
X-Proofpoint-GUID: 0DNjfiJCscmtgsslKhHEuDnp5xMalUra
X-Proofpoint-ORIG-GUID: 0DNjfiJCscmtgsslKhHEuDnp5xMalUra
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 mlxlogscore=934 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>There were several cases where validate() would return bogus supported
>modes with unusual combinations of interfaces and capabilities. For
>example, if state->interface was 10GBASER and the macb had HIGH_SPEED
>and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
>another case, SGMII could be enabled even if the mac was not a GEM
>(despite this being checked for later on in mac_config()). These
>inconsistencies make it difficult to refactor this function cleanly.
>
>There is still the open question of what exactly the requirements for
>SGMII and 10GBASER are, and what SGMII actually supports. If someone
>from Cadence (or anyone else with access to the GEM/MACB datasheet)
>could comment on this, it would be greatly appreciated. In particular,
>what is supported by Cadence vs. vendor extension/limitation?
>
>To address this, the current logic is split into three parts. First, we
>determine what we support, then we eliminate unsupported interfaces, and
>finally we set the appropriate link modes. There is still some cruft
>related to NA, but this can be removed in a future patch.
>
>Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Reviewed-by: Parshuram Thombare <pthombar@cadence.com>

>---
>
>Changes in v6:
>- Fix condition for have_1g (thanks Parshuram)
>
>Changes in v5:
>- Refactor, taking into account Russell's suggestions
>
>Changes in v4:
>- Drop cleanup patch
>- Refactor to just address logic issues
>
>Changes in v3:
>- Order bugfix patch first
>
>Changes in v2:
>- New
>
> drivers/net/ethernet/cadence/macb_main.c | 108 +++++++++++++++--------
> 1 file changed, 71 insertions(+), 37 deletions(-)

Regards,
Parshuram Thombare
