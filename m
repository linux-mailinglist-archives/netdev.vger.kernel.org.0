Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF8441D9D5
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350807AbhI3McE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:32:04 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59121
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350264AbhI3Mbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:31:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HlXqYlEZ8ay+kz2z6W1gb+cFg1SCOwRmStp+9jgdy0ZD8zp4fD/aYpqCDMbFLp2xNvcNRVorXSw4Ge3x5/RiWh6orZjS0iJsJ+sa8tBpg9yWbo+vfJGI5wfWx5wAjR1UeaUGYM5cfOdwgn+Yv7X7iOf00U5hWDEtJ/9+1cFuh5JxnXkG0lmnH0So1wCd0xjNcwsw7cfR/tdkvM9WWitPLyHlqgwQSv2Hc3M8xRMp4UF0IiZ29QxNykRwmDxarfmw6BnKkqSHLLI7jZuROUHox1IUl85qVt2HMNtZ8OvfnYKJ5dyth9xFFKRd8O3XoHwP05yU7kml4U6+5LcrcGOlZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kLn8j3ghoMH+ax2d1NwpSVwbS4wOljIeXZ8me4sKK9Y=;
 b=TM1fr2aI/1xpp7gKXyyifE5ZNcMTf/Txv3nbuZtt3Ko71jilrpLXJrkzzC4qEGXalOzPYlO1fXJjgQ8HRxegFfohIbYuoJ+1aJZgyi/lPkh48eywN7iyP1x9YQ9Pbu/p1Ci3UF8TMguTRpwwhZuj/4vGqa/P4foHbF/VBAgs/qK27nco69tNdjpbSDilrcGWTA/L+DJj0CQWdIbEI1dBPp+6On9QIfSGhnOYYiZ46tc6JiTyU9uEjdbe9cpF7qKJyseG+O573UsaF4WbxJRXxH0qe0si703uwrcs1RtEBdc3Wvx/LZ9D7zpEOCLCsFeuyAR7IRA70VxokeLXCXlOTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nordicsemi.no; dmarc=pass action=none
 header.from=nordicsemi.no; dkim=pass header.d=nordicsemi.no; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nordicsemi.onmicrosoft.com; s=selector2-nordicsemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLn8j3ghoMH+ax2d1NwpSVwbS4wOljIeXZ8me4sKK9Y=;
 b=OsS1jdZ7lE+MLoNdpu21lpGr/WchVxPs+nxiP4TwdRp7tGiQoNO62X0YY4eU4XINidNKigYgjDRKR46EW1OF+k6sf+PQHX/N1oHcJqJiDDjfx5doGHfyjUbKvbfjcyVA6fee0Q5V04Tl3X9SPdSOmb3htp4gV/1LXG4CXupjmPE=
Received: from AS8PR05MB7895.eurprd05.prod.outlook.com (2603:10a6:20b:33a::9)
 by AS8PR05MB8309.eurprd05.prod.outlook.com (2603:10a6:20b:339::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Thu, 30 Sep
 2021 12:30:06 +0000
Received: from AS8PR05MB7895.eurprd05.prod.outlook.com
 ([fe80::f8d7:481c:b502:8f0d]) by AS8PR05MB7895.eurprd05.prod.outlook.com
 ([fe80::f8d7:481c:b502:8f0d%9]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 12:30:06 +0000
From:   "Cufi, Carles" <Carles.Cufi@nordicsemi.no>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "jukka.rissanen@linux.intel.com" <jukka.rissanen@linux.intel.com>,
        "johan.hedberg@intel.com" <johan.hedberg@intel.com>,
        "Lubos, Robert" <Robert.Lubos@nordicsemi.no>,
        "Bursztyka, Tomasz" <tomasz.bursztyka@intel.com>
Subject: Non-packed structures in IP headers
Thread-Topic: Non-packed structures in IP headers
Thread-Index: Ade11fYpGxA4RFKaTJCxYimSNlf1AQ==
Date:   Thu, 30 Sep 2021 12:30:05 +0000
Message-ID: <AS8PR05MB78952FE7E8D82245D309DEBCE7AA9@AS8PR05MB7895.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nordicsemi.no;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f9640fc-7d41-49de-3e17-08d9840e08db
x-ms-traffictypediagnostic: AS8PR05MB8309:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AS8PR05MB8309AE56605387635D7F9096E7AA9@AS8PR05MB8309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HXyFByl/cNqw5Q728zSEOpJSTOLEgnYVVe8u/WuWzuRPhA3rU5yzP/QDwAaQSOjrpw9zH+s7lE/Cl0TowN9IHG66R2UzwOuGVbo8r1FbD8K8jF49FRzOOPtuuKgwRfuDBePWQEYswyjRU2+Q5F5SuWtcvFtLC8B/9vcQM2oXVvSMFQyRBgyI3JEEq0tXrXna9rAHOBv0wg8NVWRWTNaEYssOkIjoL5I+WK4qTiSK6LClvfIrZ4uM1/OkOwRfnMIAZmoIMG15n7Gpw1uSDIEbXqM3dTlJ5rbShDrqjqng2qFHjOvBBum7KRj4eRpF7idJJE61ccZrb5671FFXVwW/MBx0E3GdXf0yotnrJWgxCnbWnIByvI+zv5JC3W5fwk1d+dMX2u6HAOytXryDUjssA5cJOdNBlqrPotJyOvPv9IJqLrhA4uEnOY1cp00sTVnX//ZvV+IQy1z8Fdw1otJGYXWtuXT07GL3eAYHbzOAuHjsRUJJ5oVf9tLBrFC0DdshtZJTjOnUVL0/5/bEGYoUITbqrpIMG2X1CGBwtdyxUG/bS5vD/ZKVrBVzZmCSyhaVS22njm6KhzrAnu1Hb1J28u/7RfUt2mLgsGnaOlDaE8azRtlCxP3yX6o0M82CWuIqboB5iJeNmvcVGQ0Ziq119tspiY3pVwDCPVtCQZtAJx60hPVX9Q71+5xp/SXNmi0BN9yVaPm3dkVAW16EDpT1Fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR05MB7895.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(76116006)(38100700002)(122000001)(6506007)(186003)(7696005)(316002)(8676002)(55016002)(54906003)(9686003)(71200400001)(33656002)(4326008)(38070700005)(86362001)(52536014)(5660300002)(66946007)(66476007)(83380400001)(66556008)(6916009)(508600001)(2906002)(8936002)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BcEp/4IlGy/MQVZnG5OcceUbVY/LQ+Q3NV9OghoIfewOb7JgcrPgPdT/7POY?=
 =?us-ascii?Q?LLoCVuN9GrQFfoKPdQnuVRcIGxFrqYcTX+lDQD879HcoQOgk9X3dEVvhiV+W?=
 =?us-ascii?Q?hiTQ6ZaE4mSw+B4RY0Ii6ihii6tcYqPAAOs+BLvTi6Tp8GRA0XheorTKrHge?=
 =?us-ascii?Q?ywQAv8Mafycd/yEl8xusPkY/0WsPf7bB/h0nfLq4iUKWjeqcW08Ns5M5GJp8?=
 =?us-ascii?Q?eC5JpHUrydHB17R2snP1E/CK/CUIKYCw+SAqoE/0wxG1Lnrnj0gsTza4w48s?=
 =?us-ascii?Q?vROxM26aVvLwJVV3cBKtBVWUOdev5XA58Baj7DjcJ3i/LHxJlFW8G/KU30sE?=
 =?us-ascii?Q?uKXb9zpec9vB0DfE+cCPrbIFHmjP7eCOwheEHN0gusTvCa1pIVDQLjiKTuRu?=
 =?us-ascii?Q?3fdQIa1BQg08fjXISXIbrTAJYbwkwWwF9vpCsUE7PsWrTT/WtDVlc+EZ+ddf?=
 =?us-ascii?Q?qu22axbMlLwtQxI0gskvKNK5ISJEVQ6+GaviyGl4xXovi8jD08vMV6e10Xyy?=
 =?us-ascii?Q?TefxSZn3Cv0Ajjf9ck4rAe4tQ4SAJp3mGQQ3WDcXnNSn34hkVllHYjIftVPL?=
 =?us-ascii?Q?37Em7rLx4h1gk1AV9OplIV+98pvsPsIc+6iEsdzg4vg4RaHtuwrfOdR3W5Sx?=
 =?us-ascii?Q?13Dnc89NeaMfRUsLkOoQBPStPavQyJM5qc8zjjlMIXFoxwPKsyvKzhgxj/7C?=
 =?us-ascii?Q?opnnk+7vFX7UpEz75RM3FzPn7NIYf+USjmgwYPOshtBpkIjSakOums/Ocg+7?=
 =?us-ascii?Q?NtEEK1iZz251chG5PpfidTxa7ge6Al/CCp42t4O6FwG3rj/pzwsasgNYTjcO?=
 =?us-ascii?Q?7DCy21PLUD27zVErB8YZnI901hihW/o41DM7eGGZUOgeBaz/M7kIzBHSYuds?=
 =?us-ascii?Q?Dk0XANPwMESCswljQDCinuz0GdasET81YGRaLIDxDIudhkaXrBuxzb6LUavW?=
 =?us-ascii?Q?hAIkSmix6mw6m2dAhKCv5oFiIjx5+3m34H0qa02aaw0T5aIG0L2aBaSGpRUF?=
 =?us-ascii?Q?0sFgwMlWU8w5/comCih2NTPkJtIFbgtvEbCtJjU3TJYNr08vgGHLYU05WwTV?=
 =?us-ascii?Q?QZ2XB3+JQcoQ8+fZTHAlTKMkLfX7w1v076BNVae75O+XA2EkqtNluWPZ5rVx?=
 =?us-ascii?Q?H2UOSdzn6APwUTxqhHycdcXKYLyKfE1dfvzXmOS4Vuh5LOPZjvSUQXUrXUSb?=
 =?us-ascii?Q?gT6HJIFrKjmjeX+gqCoHPyZ1Tp++v887tXMNfm4P0at/lMWOyanms5P/bjcx?=
 =?us-ascii?Q?lS9/GdLzRqqQ57vfVl93Xkd+cLiHP9y633VpyxMxHVqTkbP4Yu9r8TQY1lUC?=
 =?us-ascii?Q?ri2m5Cpzc1sXTYXeStBCrvlp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nordicsemi.no
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR05MB7895.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9640fc-7d41-49de-3e17-08d9840e08db
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 12:30:06.1276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 28e5afa2-bf6f-419a-8cf6-b31c6e9e5e8d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lk1TeJpYjgNLXwgXVtkW93IAw9DSybFYC4r5qOgSrPjVrv/9+EOxCPC9esOOzQ0sTsveUmn7XYX5HO0/+eMf15/EcGugnIPPudM9Kyp4K6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB8309
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I was looking through the structures for IPv{4,6} packet headers and notice=
d that several of those that seem to be used to parse a packet directly fro=
m the wire are not declared as packed. This surprised me because, although =
I did find that provisions are made so that the alignment of the structure,=
 it is still technically possible for the compiler to inject padding bytes =
inside those structures, since AFAIK the C standard makes no guarantees abo=
ut padding unless it's instructed to pack the structure.

To better show what I mean, here's a rough patch to ensure that the compile=
r doesn't break the on-wire format by inserting padding in between structur=
e members:

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..62d0b83257e3 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -452,6 +452,8 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb,=
 struct net *net)
                goto out;
        }

+       BUILD_BUG_ON(sizeof(struct iphdr) !=3D 20);
+
        if (!pskb_may_pull(skb, sizeof(struct iphdr)))
                goto inhdr_error;

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e..32beb8b9e3d4 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -181,6 +181,8 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb=
, struct net_device *dev,
         */
        IP6CB(skb)->iif =3D skb_valid_dst(skb) ? ip6_dst_idev(skb_dst(skb))=
->dev->ifindex : dev->ifindex;

+       BUILD_BUG_ON(sizeof(struct ipv6hdr) !=3D 40);
+
        if (unlikely(!pskb_may_pull(skb, sizeof(*hdr))))
                goto err;

Thanks,

Carles

