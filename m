Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27B466BC4C
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjAPK5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjAPK4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:56:53 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68460196BA;
        Mon, 16 Jan 2023 02:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673866593; x=1705402593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y7e/CLZ3ljsrCTzKfSBVMgLDxTU+zMqha/sd9CiarEQ=;
  b=AAThQHRUAW645pHrWYGvovqDRNCeqw+R9/USV106k9xXIfwnxUomsyzk
   fCRAHzSJA2O+2tt3i4grk2/qN2ypNEkDD67Vpf6LBZ9AQdMbXQ/alJwyn
   yCsiEDNFHKgrre43Y5U/umAO/KC8WodJntimE9KgWkXJYLdD3VdYhzKBT
   5gbT80TAn0m9/eOPk5+uu43Gb0ouJp7RUhAZACUll0RK8vebH3tzqJ4z+
   LpBGYiBR2+L7G8HnW0bl4ZkN8RuYf/N47ZULA7MatNQFEoT7Sx+iX05Yt
   lDrN/QwNBmtI8Q6O7Nq+VqBIbtigZAmnWNEegQQthTQf8tZAWt6j3iaba
   A==;
X-IronPort-AV: E=Sophos;i="5.97,220,1669046400"; 
   d="scan'208";a="325223387"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jan 2023 18:56:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2yAe2f4o144lXB/GpiIjM4k1mxetdlHwZbCY4TmtTEQvCE+2o8h1mZk5b9PNZi0z+91fkkEjoc/v4kyIsEKnCz8KYq0s0dNwA/Y4dyUK/+qOqM0Xu+fmhPmsBG3UgTsugvRxx/XBZ1RXbENCg1G9NMvnRFNIkXgRq9RZqZxpyLM8khVF+VEqd1tFUyFQPAXUQsISMuGMc/8cCU0DidMdWLGUUWQiQhWDgQ9MGI90wqY9LP1RQV/lBlc8WnljvV71uUqHX6SSY+EdDPDqyGAmqq1cTpJV3l3mHpYvZ8ka90mWOcmXwS7s4YSfSQYJUDE6pM8awrCIfUw2CQyGFGvtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjPOVBuYpxAWItnyz/x+b1k6luUkf+yDzhiaCXsslLE=;
 b=noyFDX2ydRDYAYmnAevrQD6vVDILZvEVYtPfO0hH7ngK3jUm2tPihJVA18WiaN+f9jFUCOzlUx9WaInM7vbzHiy6W/ZtDnBf4aBgNgyHO6Nle/xZhYxoo8A5O9HtRxV9ozz/sd19WRPtKwEzpIP/at/yjMwpW2PPsJljCy0KRkPGgdBJmEfFbCn9/sOx+/q1xuj7RIoUBCTcLNw1jC7j67PvjAHNu+SAZgvncRgYe1CNM9br2F5nyAfMwebI1JLbIgsKuuor0i31mXOZuZ7DBhuBxj2+J2fQKG9EH5JDbpv/+MbEttxaHDMCgmygP29hUHyIfYy7je4NWOtV9Cp7OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjPOVBuYpxAWItnyz/x+b1k6luUkf+yDzhiaCXsslLE=;
 b=DzdL/7AL3LbrqJUmH0GBAJqZvHLGFht5qQ0eT2XBC+Ps4JzfaDYkDNVVaq/QJy4yZzhB72SdeijUXgFDP9GCoTZOfY/HxprUcjm1OLz6MT/dWyn8RJ8PLqSv0ls1akLo9UtlDB5DKlj0Zd9oJ9whJ5sRibqf/pq4UNpRggPi3UI=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BN0PR04MB7920.namprd04.prod.outlook.com (2603:10b6:408:153::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 10:56:27 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 10:56:27 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Siddhesh Poyarekar <siddhesh@gotplt.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Tom Rix <trix@redhat.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: linux-next - bnxt buffer overflow in strnlen
Thread-Topic: linux-next - bnxt buffer overflow in strnlen
Thread-Index: AQHZJ2lCUJqUxstXRUGtYPCc7p47dq6c8mEAgAPxJoA=
Date:   Mon, 16 Jan 2023 10:56:26 +0000
Message-ID: <Y8UtWYMZKGNzuG1I@x1-carbon>
References: <20220920192202.190793-1-keescook@chromium.org>
 <20220920192202.190793-5-keescook@chromium.org> <Y8F/1w1AZTvLglFX@x1-carbon>
 <Y8GB9DMtcSP/8e/i@x1-carbon> <202301131415.6E0C3BF328@keescook>
In-Reply-To: <202301131415.6E0C3BF328@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BN0PR04MB7920:EE_
x-ms-office365-filtering-correlation-id: 64ea8e0e-9c3c-4de8-8cdc-08daf7b050e2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0bhoZp1agurGYrVNo679U43yr3L4kjdFP77L4uPckJdqcTYDRSulp1t0dRkUxloHJ8FwN+ss9io12gz/JGXNvIsUe1AVbhnC7IPWkauGxZKdPDRTYs6sMR5mSQgHjZAvrjCoVZKm8n2oL2sgZsRwCiWQE2fLodqNugdL4e0ua35t5J+7i0l4yQfmW/rJfVAd4b4I3xNE6CjCmd1ZU7xcPfZ9Rcr4dWxCK8WOwrW53P87GjcYL7B+rAUMi8DPRKBqvSjfNQ+vAq1JeCHTIhNnMQX77orvVBeFgpibBF7gW4LwjZ/RKUIvV7pmwjjATDGi3vF2Od0fHNR8hSFPhqIpjVoAhovKghZJ5/OLyU7kL1n0CJn0UXUiSixilukAZpi8pemeD9q8p+aFN8agv6+PJeJhpRDpyIf4YVj9sfX4JFzcKEHVDbVav5XJ0JJGVq+o7T2DUhztpcSmbwvtLqldSUXqoegZhH0y35BRG3PcYdjLC18yR8gY1fAfBoJf/94P60w9SLouwO/AC/Ap5VNARFxYz0NnCf2PrWOHAV00wDwmW4tYdyEVVkNyw48Xb+rlqlSSlaMzy0GOB/NCoLcniqo4MDQJ01Nbi82b3LFoZRicZnFoqKC1sq5yyoarD2IW53EG5JsWYN1urnhkV5kqZ0h7dAMW4+8kCIUPwPNGizAD1e95WvMByCHEbvTChKNfhKTJ9vBpdBSNuJFdRKWuxmCNPQdXRUCrVyMAy98nv/PQojcvt45uCn+424CZ0KTh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199015)(33716001)(76116006)(66556008)(41300700001)(66476007)(66446008)(66946007)(6512007)(186003)(9686003)(26005)(64756008)(91956017)(4326008)(8676002)(6916009)(86362001)(83380400001)(5660300002)(82960400001)(8936002)(54906003)(478600001)(71200400001)(6506007)(316002)(7416002)(38100700002)(2906002)(38070700005)(6486002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WHLgURliteco4HJp1wC7saOsKQOEuN3/BBDOYUyJ/TZMfb3c7odhoBcbGBP3?=
 =?us-ascii?Q?qx8Fu00f7o0nqz94aySaHivxAs4nlt7fnfn2gRHYhT/NNE+xqX7olJcQ4pb3?=
 =?us-ascii?Q?Y0SifIrnt+Qki9JJCRYvROTdmWRgV18IH2QiKrrJWAYeXlv/e3eHycUiKoj6?=
 =?us-ascii?Q?nhChGgSf2VwJpTHwuL16ma3bOImD8ejE8v8oe3T9BlzEFlu/TTbRGmMwBdIJ?=
 =?us-ascii?Q?ybSg30j++OTBtx8X3Lr0sladgzwF/qlxXb7jEGGARZqMGlWtI2aHaMsgLmtY?=
 =?us-ascii?Q?UpdEB8fErg5R7PyrSHMlnR6qeeffhX6qFzYZPqTIQPptMt/iQdq7kQGjy5Vh?=
 =?us-ascii?Q?VNv8oO5rExmHC3juUc3Nqj32qGVPr68WcWRwZEXNpf26oNvVZGVbuLhui4et?=
 =?us-ascii?Q?8/hSsXn8eMe8njMDDw4k/dkhTkdcZdSmtql6MKRTwRcIUmcVQKNPjEiMJBGP?=
 =?us-ascii?Q?SkCCxvs/e0o4cWkToxfr1LLpLApM70IjNHvUcxtkhpibSbnytdJ5XvwjNnpt?=
 =?us-ascii?Q?vHEiaL03F1axvlYt+Xzf5ga7qZP8MUabuPku7+hJirnoUXLHgoFIWnRP0+N7?=
 =?us-ascii?Q?w5wmI7u0/wZBgdMWikpk5sV2Ujj+M7crIwSMPAjIMNg4D/mxcWJUzV5sAhvz?=
 =?us-ascii?Q?vLCrYZx1W7VrFsqJtyxq7656G+fNRWCUIfbVk9Qbr4f3/m9IRFyn1XpB18G0?=
 =?us-ascii?Q?oHIQPyWABBemuiY6vo/sORTVouXc0bJZJNfoiTkqeoQ3guzXjx9BIZB1kVcq?=
 =?us-ascii?Q?CLhcgdGJA8oja1aP7uc67aDrQq01+4clfPA9dzPB2qfMANfI/kyB5cNCFyBz?=
 =?us-ascii?Q?85NC2yKvaGf4pToCv5JbY5u0hxrdbON2xX2OK2T+9+IyqN75MmswLZISFa6G?=
 =?us-ascii?Q?9tRHzbm4NBefbDJEb/M/fHEw5kZLwG7pLa14vFxp6mVF4MvoeGJEzwdEd/xA?=
 =?us-ascii?Q?mKMuwnQDTlIUfDChxfroInd1bNIlztS+Bo0NUzwEDz44qXu8EezVFup3MrTV?=
 =?us-ascii?Q?FFalAzE/0t3c0lOp6EE9l8wgEQkZx8dqbEb0H77C8LiPV3xw/TaRyCNGb1MN?=
 =?us-ascii?Q?OUzOuoqEPBBzWOscpeUewsBbz9gBquCx1DEa1T1HaXkHRIoS6V4zTezQkZey?=
 =?us-ascii?Q?olyUBcwZHUEKOG5GhsQfd0Sd4kMq1OYZskBQ8AAIn55k6hXFr63JibgZUFtY?=
 =?us-ascii?Q?urEhjJ+96vo3AnEwFANyThOfaqgBQTZOLj2v9/j/+K9n0HRUGsTsmZS7aYza?=
 =?us-ascii?Q?s0hid7Aqt9GI6wA7kmOaSIlWtxfL8IZIJVW42Ig/ujwBYZW6O4KFyxNLVHX0?=
 =?us-ascii?Q?+of8Kq9k9Q4d95XIWWo8jPYEiZxadAQcb5lIrf264oJdRFdFua6d2+yJlNxe?=
 =?us-ascii?Q?OhYvzL45FCBp//nIc9SFS+KN8jzoXP/TXNKMh4QDC/IedDGxTAhBYUwgVKgA?=
 =?us-ascii?Q?ZZwiQ9oCmQvS90GzpbQoGOJyNgA2R/WVrZFxp9z3QIWWE0VvVAU1/Dnkd+fu?=
 =?us-ascii?Q?126ymzkI3WRCJq70Wa3uJeLe+y99MSc66AJnaKKrlq4qDc7sxN6k2uPUzSg6?=
 =?us-ascii?Q?qP+LTSsv7Rf9uoybXTDKnOXtdQUiPn9AC8Y0lA/1uk1mwoucwP/HcQDTj/7n?=
 =?us-ascii?Q?lw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A36B69FEBDCDE43964B50F71B3E5B0F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?4ahk78gqdrMbme7qs04Xo8deOkVk50A40jbM4ZhDLc/z8lOIA83HXH05MvF0?=
 =?us-ascii?Q?P8tA5YfC66WnfiFehkMMarg8hAQv1uSjn5OQuplxG8KeUBJBOs4/VsrXQcuj?=
 =?us-ascii?Q?d+yiGdmp6GZ61+7KZsBHkY5U+zsDP1OWEhHxFJRMT9+zsrYfwWkZM5Mm7+vH?=
 =?us-ascii?Q?5S+DfJsiz61QAlnpiFmfKzs/yqaLOoFrN4mUjXgSjRs8LhLknaGfnSdkSuJx?=
 =?us-ascii?Q?++rX8IGQli7lTfR5PSDVKv1ZUfwdLRkcxbCQ6aeFdSsFJVUIcD3SYp/kBNX5?=
 =?us-ascii?Q?fX77uXAptSrpzEUHloQhY0eqD14nLYXJtLJjFowJ+4gjhsiv8f4XXKvU86b4?=
 =?us-ascii?Q?rn1z51Y2TTgvAsWqRSZnnfcgysEYt6GSLUzYixOyFLUIXIdyqO5yDUcc1aka?=
 =?us-ascii?Q?9XldvSPZFH/kxTnjcmwtLBm9itsVI3vmjX1Nkn6Gm8Mv5eKpY2d7lw9eZKH5?=
 =?us-ascii?Q?tO26r2QKkGi/Dr5G9YrE1D5nNbJ/FozU0luDnrtvbCR9kuhOgPBtp/cuRlQD?=
 =?us-ascii?Q?768q2nmWDbz2spEJx8fPfLKtT9yMRYbpkRCLvRt7ta28Ghc/Q046OJRgfosy?=
 =?us-ascii?Q?jZUQe5DDDIN5IQag6Nfy/0GBYE351cnNXU5Sf1m6ja/phPKwmmwMFC4tEQrp?=
 =?us-ascii?Q?PgqWfW6TkNOW6NM8Uo6bsuSYpkY988eJ5MHfeYfFCdE5jH800UwIjvVx1Ma/?=
 =?us-ascii?Q?RVs9oYXSDnF9mmW8gwCrFdf45qssK78eHfb18LncPLJmBbnpByIKXwiTR6fd?=
 =?us-ascii?Q?Xq5T4L0XpuFP4omA9c/M6w+ge91lK1txKyElJM70l8tgJf4tRkank34G9NXz?=
 =?us-ascii?Q?nAsq8dlgvNyEc0atMhXuMWJunaLy5Owl/50vs6NlZQjz0yEx2pUp2qvhL7tf?=
 =?us-ascii?Q?rfbTfLYufWbDKgir6LnWKbNeEYF/5P3Lo8HmXdcAb1u26doan5Fe/JSYPrCb?=
 =?us-ascii?Q?cbDR4sShisT1l4IeqjOyrNrIlvWJxdqppgdElnT377gE98PCfeGmT3yhJbp1?=
 =?us-ascii?Q?MO1ffaqVtcMtzL30BP5NEoknFehyq5L5GhbACFN4QmYQQ2l3pdl61+9KkbLU?=
 =?us-ascii?Q?zf6Jb0hwmFevBhjfDlZwS9pCGfDLvg=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ea8e0e-9c3c-4de8-8cdc-08daf7b050e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 10:56:26.9519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /j+1oIPbWaYisYPxK2WVJoI3zhmW3JvGaJHUgxwVvEAygL6+7JTWBdM9if4i7i9UqspdSQBETKJLNYxTBQt4Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB7920
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 02:44:32PM -0800, Kees Cook wrote:
> On Fri, Jan 13, 2023 at 04:08:21PM +0000, Niklas Cassel wrote:
> > > Hello Kees,
> > >=20
> > > Unfortunately, this commit introduces a crash in the bnxt
> > > ethernet driver when booting linux-next.

(snip)

>=20
> Let's see...
>=20
> struct hwrm_selftest_qlist_output {
> 	...
>         char    test0_name[32];
>         char    test1_name[32];
>         char    test2_name[32];
>         char    test3_name[32];
>         char    test4_name[32];
>         char    test5_name[32];
>         char    test6_name[32];
>         char    test7_name[32];
> 	...
> };
>=20
> Ew. So, yes, it's specifically reach past the end of the test0_name[]
> array, *and* is may overflow the heap. Does this patch solve it for you?

Yes, it does!

Thank you very much Kees, both for this patch, and for all the excellent wo=
rk
that you've done with regard to kernel hardening in general over the years.

Feel free to add my:
Tested-by: Niklas Cassel <niklas.cassel@wdc.com>

if you send out a real patch.


Kind regards,
Niklas

>=20
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/=
net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index cbf17fcfb7ab..ec573127b707 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -3969,7 +3969,7 @@ void bnxt_ethtool_init(struct bnxt *bp)
>  		test_info->timeout =3D HWRM_CMD_TIMEOUT;
>  	for (i =3D 0; i < bp->num_tests; i++) {
>  		char *str =3D test_info->string[i];
> -		char *fw_str =3D resp->test0_name + i * 32;
> +		char *fw_str =3D resp->test_name[i];
> =20
>  		if (i =3D=3D BNXT_MACLPBK_TEST_IDX) {
>  			strcpy(str, "Mac loopback test (offline)");
> @@ -3980,14 +3980,9 @@ void bnxt_ethtool_init(struct bnxt *bp)
>  		} else if (i =3D=3D BNXT_IRQ_TEST_IDX) {
>  			strcpy(str, "Interrupt_test (offline)");
>  		} else {
> -			strscpy(str, fw_str, ETH_GSTRING_LEN);
> -			strncat(str, " test", ETH_GSTRING_LEN - strlen(str));
> -			if (test_info->offline_mask & (1 << i))
> -				strncat(str, " (offline)",
> -					ETH_GSTRING_LEN - strlen(str));
> -			else
> -				strncat(str, " (online)",
> -					ETH_GSTRING_LEN - strlen(str));
> +			snprintf(str, ETH_GSTRING_LEN, "%s test (%s)",
> +				 fw_str, test_info->offline_mask & (1 << i) ?
> +					"offline" : "online");
>  		}
>  	}
> =20
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_hsi.h
> index 2686a714a59f..a5408879e077 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
> @@ -10249,14 +10249,7 @@ struct hwrm_selftest_qlist_output {
>  	u8	unused_0;
>  	__le16	test_timeout;
>  	u8	unused_1[2];
> -	char	test0_name[32];
> -	char	test1_name[32];
> -	char	test2_name[32];
> -	char	test3_name[32];
> -	char	test4_name[32];
> -	char	test5_name[32];
> -	char	test6_name[32];
> -	char	test7_name[32];
> +	char	test_name[8][32];
>  	u8	eyescope_target_BER_support;
>  	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E8_SUPPORT=
ED  0x0UL
>  	#define SELFTEST_QLIST_RESP_EYESCOPE_TARGET_BER_SUPPORT_BER_1E9_SUPPORT=
ED  0x1UL
>=20
>=20
>=20
>=20
>=20
> --=20
> Kees Cook=
