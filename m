Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA1748C8B2
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355320AbiALQp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:45:59 -0500
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:7776
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239986AbiALQp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 11:45:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knoFmUsYUNHywddIbtZhh6EG9PlaBXqmjeZp4E7ZYKNs5bxusI+NeRI3q0b5s0+7l1mLn8JnK2gbiSopVp+DDJtIPeI8On9VS5Nw1Aoffg4B3jPc1/dhXA7b7hCIFnp2LyQe2DoLA14uKwZ2L9TeGJj3KF+3xxPiZBDUuNkx8asolJ9c/F4wMdOwYNh3YVtDtE1HzLnxXkzjQRAidhbXS2SMQPYn5CwXzIav/6u843tLyoYWJBdlT7lV446/C8/tEXkso8dAB8Pj5InDrj5aycpOFW/2ubRn3eUISF7tOaTesvVifRvYrPPJkC+Y7bkI7+xf0hQhAUjInqAzy/Ohwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDeNQa4SFDno/K8JWcmwKAaGGXAJ5WPWwMn6ss4Ghns=;
 b=gpHjsoDHCL177WntRokxiWQlL+uK6/Y1Z+DU3fiKb2cC6DiPlbjveok6yUGJaQgJ5QwFa+iO2HjBezNJEiT2ZejNSh0zQgvNWcReV3FxcGDp6zj9n/hnNHX6Byb+qLHPSk3rHdkFr4TowHOk4hRsHMNKirlef/DY3cwT2hwDL9kGFFzblGKmTEy0PqRW5Vs0zrIZdSaGdS0fQpweu9RpA6vTMELoXi/vPqbQSg5yMzKMEypBTmOvgYl7taV+5yMO6VS6QKRLrEnnPKZi7KwmxpyKf5xudD1//MCIIte6Lw82/t52dTskBs/zB/pHcKjVpLQFISgKuFe9y9lF3uO/GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDeNQa4SFDno/K8JWcmwKAaGGXAJ5WPWwMn6ss4Ghns=;
 b=V+aebvifFhH1o8ya2Civkbvr4AVdc7vQ1+NIlqV2OtUV+i+G+IlKKc6oq9PceyZzjLbx+fPF4/hGMfYmRCWdeKQM7x7yucqGTVu6mFIlCVENvG3EkwzNdfiBh114oMmpagDgFQUIklBjEKuGRXY6pWZDou2xga6jPatFen83ZIM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by SA2PR11MB5050.namprd11.prod.outlook.com (2603:10b6:806:fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 12 Jan
 2022 16:45:54 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Wed, 12 Jan 2022
 16:45:54 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
Date:   Wed, 12 Jan 2022 17:45:45 +0100
Message-ID: <2680707.qJCEgCfB62@pc-42>
Organization: Silicon Labs
In-Reply-To: <20220112114332.jadw527pe7r2j4vv@pali>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <42104281.b1Mx7tgHyx@pc-42> <20220112114332.jadw527pe7r2j4vv@pali>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SA9PR13CA0091.namprd13.prod.outlook.com
 (2603:10b6:806:24::6) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6b60885-4dbb-445c-becf-08d9d5eaffab
X-MS-TrafficTypeDiagnostic: SA2PR11MB5050:EE_
X-Microsoft-Antispam-PRVS: <SA2PR11MB5050AF88D65C0EA4D5B0B96C93529@SA2PR11MB5050.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SkO9IUWTqTNja0QvuB+H8wqOft70gn5yQ2TGjVNxMwyDMYebDD6BRrn3bbpvKzyC3wFYh8yvSsHSDwC8XLnU3kSzERYttgucIQ7H7rzztESwSQfJP4qAGJBmVnIAfE3wTcEw68AF1kwnttphQJyrH03u04LGlg1YE/QNNU8xe9JZ/pQU2HFkcTP2Ie3xSJYcJW7bJYEboWXygp3eNmpFlifzQi4As6akn2nD8bkrT+rszne7QvuKyMK/6l9eaEJqKm6hbImM/2ldAp57b3/TK1JF5dqiKU4JIxszfoX7ECa2luuw0UOlhSsGZufrVhnWmoHDenCcpEgWrPArYl3yUosrNUVOXbkRXayWmdxndPILGDNgugtVk2G0oIwcXKUXgueMM8jUFS+SxltNAVSFECT0bgKcwuv16GQXijxcNBXUE0N77/3Iik1aZH32uSMKbwEvRiNJQO9pw1sqO+EreaCGSfZ8G6VoUJUoDa8zQY0+GiKuhabVd7WpV6+NsjRFqeJc1q+iix4eSHdHIzfvM+Ov7mxs5DlIQBhehz6rmYIGM8wuW3yJ9HDawpu2Vfc14LUUk2Oc2/HQnH955W/U+jAxABO7+BEi3/lu6KhE/GEB6gwYblSCdaBrL71V1VsbtNXVi90Trt2dV8aZJjiXVNpv75ENKMmimYmzSSQlhc/ZtubYGtShxHfPw1fJMC2i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66946007)(36916002)(508600001)(2906002)(66556008)(52116002)(8676002)(4326008)(66476007)(86362001)(83380400001)(6666004)(8936002)(54906003)(66574015)(9686003)(33716001)(5660300002)(186003)(6916009)(38100700002)(7416002)(6486002)(316002)(6512007)(6506007)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?8g8iL/wkP15z+4bEZd+hE4UYi6SBbhLuVqGhlLs/x/rQrlxvhzbYM9fPK/?=
 =?iso-8859-1?Q?WW/bFxVWfReG5gCRPeEedA/dTmk5AlG9QgPGR/H7rNGh/E86qBRfLkWTx9?=
 =?iso-8859-1?Q?v+7PYyAoJEJZV6/oaPsE5pcftePR6GnUPFufCg0rjiD2+tpdVGvNFf10GF?=
 =?iso-8859-1?Q?wfVO+XrAduJo0e7Wzfl3+cl1aX3gdo6sdHU3WgROWDU+3ZARB2XMnqQ9yk?=
 =?iso-8859-1?Q?755wA6W+iMh4BCccn41Tmc90zB+rWITQ/hNhPpVzLKnQ+5+EsnkTDe88He?=
 =?iso-8859-1?Q?sUJWZn8cSw27HKN35l74vbl0oE8ar7uhnY4FOS4wBe1OXp7RxXNKSmIqBT?=
 =?iso-8859-1?Q?C4tEyfyjQ7JL1k2Zu3scC0TcLKWS3Sq05dmswtfhXy/YEAtQm8hxMT1557?=
 =?iso-8859-1?Q?Lf1ZrTKcIADQKd+KOksh8kuqzhYQ0wDhpDK1jGtkga0pdqBs3m5xzVFpGc?=
 =?iso-8859-1?Q?0qUU+tGF/15UTIfLj7uIr0iFC9hoeaTANOOjSSYSKmcdymEaz1raCq75ss?=
 =?iso-8859-1?Q?+8X1ASIvvGVqAyTEEpT9EtMqr3NdRTEiXlcEQO5w77TXWkssC8uG5bE4a3?=
 =?iso-8859-1?Q?UcSG2fN74mZFWVoxsdtb/3tLOnKLbxffmyF4znJAwR2sCGlOQfpd2mdHi1?=
 =?iso-8859-1?Q?8dshNLCTueatHjqK2I2bZpe8Pf3wAOU99h+E5hCGQvnDGtVVKnOc7821GH?=
 =?iso-8859-1?Q?Ukas/9qRCs6qcNxumOv5be/yhYuqAajjoVtw7AWKNPK+FzwFSd3XOEl4TP?=
 =?iso-8859-1?Q?AQsi8fQ3VR0DlV285CWa/vuxYzRlBGyZFL9f3o42wViqMCjI7YlEeEvI5h?=
 =?iso-8859-1?Q?E2NCuFQansvar3hTQoLLQC2Nw9AGv7LwheUjchsNpOSPbYKgRt+e2Wc+Sp?=
 =?iso-8859-1?Q?cXQQb38NWlTs2st99T9VPzmS/RgOvfWtbhp8gMXzRK01pvHhOL2KKdnece?=
 =?iso-8859-1?Q?ir3AWfChqSOy5UnT3R+ExU/FNRDGRHqo/oNv/y3wILpA3KBHW69+K/YVG7?=
 =?iso-8859-1?Q?VrntcOnABW4v1jxZ8S/fDk4t/4TnhhfYaa+Mtl9hLWnopSyt9WB933H/Ds?=
 =?iso-8859-1?Q?pMTHU0h5hdUxvZRGH4WRlCzq5LjIhse9St5yOgmihT0+naYnj/ze43cMyJ?=
 =?iso-8859-1?Q?nNgRuPuXhWEV7MdD+MtUgZ7vjTTf4mYmvF32yM2MkeEXfByV89yr9fwuqf?=
 =?iso-8859-1?Q?HIGrzybk8X2tYbAm8olENelT06NjgKfPpdOlumS2ZwfagZYdI1Iwg04P/Q?=
 =?iso-8859-1?Q?EmQ+g+tw4JKjW/GrpK9Xamg9736JbAKuF+LDYAotU+Wht8XrC/cy2KESzl?=
 =?iso-8859-1?Q?CoF5Gw/Zobj4B5CMpbAd+Nx+RFad1/t24j1wbc7RK5LQe4/ZGsrw5lFipX?=
 =?iso-8859-1?Q?mdc4x6S0s/fdP2OpxDZ3w55jPzUAEWDK/BOeTkPbP6jZQOmMrOkMTZ6TSm?=
 =?iso-8859-1?Q?91GsPyVARDC11HgwPCE4DzYwiiCUQmEopyUeJ6fjWJH3AVaZuuH9acNXF2?=
 =?iso-8859-1?Q?h8JqQFLMXyvoyRuZu4Rn/o9kcyd/NY4NXIv/TcbjQP2cXP40sFToP9GPYL?=
 =?iso-8859-1?Q?8yZI/K4B0jIICn91fEkRpfaNgXKj94waXeJJ285VPW2GO9nblVdaDlC7ZK?=
 =?iso-8859-1?Q?2BbQ8FbKNm9x2N4tZGpqlOoSSAsjPZrJR/5CwvsBedKM4cauc7rFeP1pQj?=
 =?iso-8859-1?Q?P/uWUPSHmXOgh20G3t8BwvX2lq4K+ER3M9jR2SAiGYLNR//l+I8Cbek6hV?=
 =?iso-8859-1?Q?nlSm9dIR3KbU2atuoNl7X+5Vs=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b60885-4dbb-445c-becf-08d9d5eaffab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 16:45:54.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gffBhxdBAmM/CO1mhQlHhtRYVFUPR/sWNdKBAkS8gewFmc5UJOW/ozqDeVHLrJMnPSz4iqWOhDsM8gp5GWPP+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 12 January 2022 12:43:32 CET Pali Roh=E1r wrote:
>=20
> On Wednesday 12 January 2022 12:18:58 J=E9r=F4me Pouiller wrote:
> > On Wednesday 12 January 2022 11:58:59 CET Pali Roh=E1r wrote:
> > > On Tuesday 11 January 2022 18:14:08 Jerome Pouiller wrote:
> > > > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > > > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF=
200) },
> > > > +     { },
> > > > +};
> > >
> > > Hello! Is this table still required?
> >
> > As far as I understand, if the driver does not provide an id_table, the
> > probe function won't be never called (see sdio_match_device()).
> >
> > Since, we rely on the device tree, we could replace SDIO_VENDOR_ID_SILA=
BS
> > and SDIO_DEVICE_ID_SILABS_WF200 by SDIO_ANY_ID. However, it does not hu=
rt
> > to add an extra filter here.
>=20
> Now when this particular id is not required, I'm thinking if it is still
> required and it is a good idea to define these SDIO_VENDOR_ID_SILABS
> macros into kernel include files. As it would mean that other broken
> SDIO devices could define these bogus numbers too... And having them in
> common kernel includes files can cause issues... e.g. other developers
> could think that it is correct to use them as they are defined in common
> header files. But as these numbers are not reliable (other broken cards
> may have same ids as wf200) and their usage may cause issues in future.

In order to make SDIO_VENDOR_ID_SILABS less official, do you prefer to
define it in wfx/bus_sdio.c instead of mmc/sdio_ids.h?

Or even not defined at all like:

    static const struct sdio_device_id wfx_sdio_ids[] =3D {
         /* WF200 does not have official VID/PID */
         { SDIO_DEVICE(0x0000, 0x1000) },
         { },
    };


--=20
J=E9r=F4me Pouiller


