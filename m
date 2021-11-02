Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912D6442CB9
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhKBLjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:39:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231133AbhKBLjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 07:39:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A27ImYR023823;
        Tue, 2 Nov 2021 04:36:23 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3c2ycv9gsc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 04:36:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYW/LcPZDr2FzMsHJ4Fhsr+4A2HzIYVH+al3uB7XNEn3FXfVoKhBQBNvi2AySMTG6l4LyABRE0/ug5pahLjAwh43ILQ7ZgIITZ6kIX8IMx7w8HErNs6wC4FPEoa8DKgTExjyfwaZrLKR3klct1F6lWvkooEDRq4ieh5/+Mot3FlMi69CxZmFPMRXPb3/n50i98UT6CEjTITHjHL50M10Q+4eYGlBeJnduCSCGGeGWgjGWjDv+fUtzPxVrbN+YQYkpoKi1PU286T07rmKu8bII/9KrR+fttY4rUwDRVCRP9M4MCUyCM+5JiiP62tSNaknkZ+ZsEorjQ2hWHsjR/dEhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwfOwDRzARTJRNzD0JEDYqJ3j+oAfbAIPz1enHoP07Q=;
 b=bplzB/sqm3BJzziWcBUyCPJzSpLELZNBAG4KmHEEzn/O6rD+aabPUDuq94DYc3jA9dPhKAE6axLwz4NfYG/hXQDQpM+NQ/b15pBS5fk6xMjm29oczlQhB5qyI9D69OzeUKVSa47vXA204le1beV42NZLBfg6G9qlA0xqFz1PVFvZMShnWKJMnNxxMQATCXVP3UjUkiw6iBp51yi9Q949cOHR3jfcBPbUodxuiFNFFoum5nUYmxmM4Ra1MOPnDAQHpytyDL3wJwVSrZ4edIcJCPQ2qFeSl9Ecfqb/wK06yVq8gji+d+eeyjT6D8e5Ju+mdZ79/XTTB94nYM+q3eeskw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwfOwDRzARTJRNzD0JEDYqJ3j+oAfbAIPz1enHoP07Q=;
 b=FIkrzRu6qpmWTdC4YkkK18ED8t8stXrz87ilg5PjZX4qyRpcLOE5RL+4MihaJE2oGKk7tS6FF2HVoft7ZLtaftX57rJ0b804LR7IjkQFwHabgMVm7yf4qB4GFZKuuy9cMwkEF+GSa1katiMRqOu1jt0/+A7ctOF7iWcdN7h4+L4=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BY5PR18MB3170.namprd18.prod.outlook.com (2603:10b6:a03:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 11:36:20 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 11:36:19 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [-next] net: marvell: prestera: Add explicit padding
Thread-Topic: [PATCH] [-next] net: marvell: prestera: Add explicit padding
Thread-Index: AQHXz93a3E+bAU9+gECDkTpGNukWQQ==
Date:   Tue, 2 Nov 2021 11:36:19 +0000
Message-ID: <SJ0PR18MB4009AED9ADC1CB53775F71FEB28B9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <20211102082433.3820514-1-geert@linux-m68k.org>
 <CAK8P3a1x0dU=x=mnBC8JeDG=dsQNfyO7X=16jm0WUwQ8wwLp=w@mail.gmail.com>
In-Reply-To: <CAK8P3a1x0dU=x=mnBC8JeDG=dsQNfyO7X=16jm0WUwQ8wwLp=w@mail.gmail.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 0ca14783-9e80-ee4f-3b53-5359a06a1de0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b409c78-0d31-4171-e559-08d99df4fd5c
x-ms-traffictypediagnostic: BY5PR18MB3170:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BY5PR18MB317099822BD09F6D1D09191CB28B9@BY5PR18MB3170.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aTIhytXpwuTr86nKEgsUP4GI1ZoZupru7l53MfB2kPV7aohaiOnVJoUycv+KaodYMMzPetnVLyH2ArPaCENoJrAMSsEeZ/tLbiEa8jRF23DTfad04PTaBJDNj2zoayG0IIA8ixX3exwfGV2rEgYaopdBEfxs/0cILNsREVcGfmGA/W8w7RANWaoOeqxSf+S7hbiTLAvIsn6UWOEiml1uCAEFXJXGNViWzRN7ftKFGh2iSRGf9lrse099+g7z9tMPLksj4vAPxPMc/U5A7BQNWcx88x8rKAo4y0C0rpbVU2ljRm5Isfwf0j99VXthr11T/H09zPvbekfwvikSuvp17X6p6MtGf6kk2ekZ32xC3DQ1ne1XOZ4EIqXcgDCNYroVmhZn2d/4niQva8+EALVe6kZYGr16A61ivU81YiImZgqMIoP2hUCVzWUIt1wpMiHbT0dgX3vtNT2ROU6C4XfKnTcdwCZpQljQ/bOJvXwYXuTGa223cp26ESIuNA0VNzCiBUra4qhYb37Z0yyOBCm3uVIxyxXXg1689+yDRD+ZXDd9Ak/wbOpgWGL1Y0meusvuGfVg3vzKcwnadNAisJ/QAst1yv+Y/YTsFGsVyVUWdrCcOcJho+6jruFjexVO8U/XGlVG0FF7YDiYpVk3p1uVWXkQN6UyZ3lNDXaRjUwxuE0dfn4uT1t7mAIl1OKdJYZMyQFTeh7zSo77khosJtMQW835G3uLImVwg4df3kHS8e1Q1lit0f1JZxJcsCc1CIk1B6bdoB7iYKhkYAFTSKQjEV47ziDlVK1YE+jsyd6PJTM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(508600001)(38070700005)(9686003)(186003)(122000001)(55016002)(2906002)(83380400001)(38100700002)(4326008)(52536014)(8676002)(5660300002)(966005)(6506007)(76116006)(66946007)(7696005)(86362001)(53546011)(110136005)(66476007)(33656002)(66446008)(64756008)(66556008)(71200400001)(8936002)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?FjYfCV3eHOmt6NJra9q0gMUGVCyxcuIDDgb5bvf7TwTGpY9bqG2U9NIG?=
 =?Windows-1252?Q?mgOxa4XHAmNJwzgf4cMwBEba8VguJ1u+sFq9bX2Yi749ji/arw1IgdIB?=
 =?Windows-1252?Q?orTNPX/rXZ3pVYVRLItYK/bx9epwmyxAG7Qs8y2Fpy+pviNFecfUHnMf?=
 =?Windows-1252?Q?aeK8VaIeymElQkolL8ZPptloYqP50ohyClcy4tPBj2AlxI1BWbt38ZXm?=
 =?Windows-1252?Q?TlWm2h2PZcxOrOOfMQutmuL6HbtnTSXRZFoqj6XjDiLnAs2j+6U2Kmms?=
 =?Windows-1252?Q?QUX76fAnkb15JBPho9agGuy7/gyJyp56b5Gzh7vE6cd0WcgVFKXJSAjI?=
 =?Windows-1252?Q?7AGuQle7JTxuheilqPkPaRdUSfRVGDzAeEzPHTXIFkS3ze1XTRdzO+xJ?=
 =?Windows-1252?Q?q7ehBkGvFenTi06f4LdUUG3cnmd8woE4sCxwNF6n1EIzG8XjIxflLvfn?=
 =?Windows-1252?Q?/AiGmOVtqx7uwT0Ska20vdkq9WCKnQeUB3C/ys6LtkcAZiGEppYPsHeg?=
 =?Windows-1252?Q?9jkhWixlxMxGmWJtOSdG1VnGyZH7TakUhRkNKc1FOZXTpf7hQhcXrpGr?=
 =?Windows-1252?Q?881C3eLs0+A386pP4u3FyYKFoaelgAbL4zCfHpbIzh0zmG8yLBCr6Xrv?=
 =?Windows-1252?Q?T8PCm9T64zTVjAhR4bOevYNO0JybMxRrHFF4cCci0rqDqmVQc8To+67o?=
 =?Windows-1252?Q?k1pZZ49WHOye8wOorFAiCP7jAnZpZBJD6PNyLp0zxyHQ8fDCChFREEg1?=
 =?Windows-1252?Q?yJfDkktbJbOC3wlbWBLhrLOVSpuzFyYad1GbLJiKoJ7OSa9oKKM6ScLX?=
 =?Windows-1252?Q?ySCYD6OIIBUmshvgtemeTCK9Z4lfabgATXrlIUCjBzwvdUvExqSeBNyq?=
 =?Windows-1252?Q?MYQal0xf4AvNugf4pfU7GqaNZU37FPAIKBOGEM6dWfKDeX/tJvTa5RH7?=
 =?Windows-1252?Q?Dslp8Hjo566l2quF8ZAVSLme+FIPpeGU1tsK9ASk3UmmavaCKIMyz9HE?=
 =?Windows-1252?Q?Ppzn/+mWcj02jiasKgoIMC0rAJmeUxzzXRtOOyEmeCz6L5oHgPfmgROn?=
 =?Windows-1252?Q?57EixyChDVtTJ+BxV+i/PvWWaLPosv86QZ8P/zsfTsDtkuOd4qIjU2wj?=
 =?Windows-1252?Q?+nKDrs7UZgtTNeHV4a+Vo9FnO/cLWxO4D0YgKBtRY1s+G66rLQiAf7hF?=
 =?Windows-1252?Q?SNmTPpE2i7/qGv1LM2/X7foWKF5pM78EU6yfdcSFJPiTo1agPI8C9qd4?=
 =?Windows-1252?Q?2HiDiFiV8m2b5In6GK+QV0xoIuUPRdFZR/lZmmpiqvzgQLpkb4k7CrwL?=
 =?Windows-1252?Q?P08QIiW2f+b+hdE1JaEC4Y0GcTBtV01u7N00ZaUxcQFFi1ROt7mPze4x?=
 =?Windows-1252?Q?/ISfqy2oqVUUKcrUue345/mm3KbD6qk9YQYNHUUv6TNolisAA+gTHBss?=
 =?Windows-1252?Q?dNm3fIU0PfXLbkk7OVlUZduJjn3OqJWJQcznze3zaxIdQB+e+wpggKov?=
 =?Windows-1252?Q?n9rke5JZ+KWTG07x74q4GQq1JahqXdg2XUgVoL0lBllskSZ2rSYugg29?=
 =?Windows-1252?Q?DyN9OpWS3MdGyA2PiVjn81k9Ia5nqK63w89fJRAO18SNyb/hVqGdM2Ub?=
 =?Windows-1252?Q?x8Ztev0aAIrCOTlKnkQMJnvsOBpol+GJo89jX40Fu+FzSckUoi0lGfY8?=
 =?Windows-1252?Q?pIKxfq+OmOJ+ak8ZMrOkJVzLT7T4qV4FdYcwKDJP+ja/u8v4sWy+KA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b409c78-0d31-4171-e559-08d99df4fd5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 11:36:19.5730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SyYKlEC8kqISAO4x1onjgrYYBW1mGq2VH9UEivbNMfzAa47Ij58ZocCfL7z9Qx8cqsuw/Tje0sUFuiz4nu7gFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3170
X-Proofpoint-GUID: 62MUDd20wjzQfU3FDK947ztPA-cGQwpW
X-Proofpoint-ORIG-GUID: 62MUDd20wjzQfU3FDK947ztPA-cGQwpW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_07,2021-11-02_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,=0A=
=0A=
For some unknown reason, the bb5dbf2cc64d5cfa ("net: marvell: prestera: add=
 firmware v4.0 support") changes have been merged into net-next w/o review =
comments addressed and waiting for the final patch set to be uploaded. Any =
idea why ?=0A=
=0A=
Right now, I'm working on fixing all the issues/comments and rebasing them =
based on latest net-next master. Also, my changes include those posted in t=
his thread to fix m68k build and comments related to structure pack/align.=
=0A=
=0A=
Should I rebase my changes based on yours now ? Is it possible to make a re=
lation chain ?=0A=
=0A=
The bb5dbf2cc64d5cfa mail thread discussion (waiting for new v5 patchset to=
 be uploaded) can be found at:=0A=
=0A=
    [PATCH net-next v4] net: marvell: prestera: add firmware v4.0 support=
=0A=
    https://www.spinics.net/lists/kernel/msg4127689.html=0A=
=0A=
Regards,=0A=
  Volodymyr=0A=
=0A=
> On Tue, Nov 2, 2021 at 9:24 AM Geert Uytterhoeven <geert@linux-m68k.org> =
wrote:=0A=
> >=0A=
> > On m68k:=0A=
> >=0A=
> >=A0=A0=A0=A0 In function =91prestera_hw_build_tests=92,=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0 inlined from =91prestera_hw_switch_init=92 at d=
rivers/net/ethernet/marvell/prestera/prestera_hw.c:788:2:=0A=
> >=A0=A0=A0=A0 ././include/linux/compiler_types.h:335:38: error: call to =
=91__compiletime_assert_345=92 declared with attribute error: BUILD_BUG_ON =
failed: sizeof(struct prestera_msg_switch_attr_req) !=3D 16=0A=
> >=A0=A0=A0=A0 ...=0A=
> >=0A=
> > The driver assumes structure members are naturally aligned, but does no=
t=0A=
> > add explicit padding, thus breaking architectures where integral values=
=0A=
> > are not always naturally aligned (e.g. on m68k, __alignof(int) is 2, no=
t=0A=
> > 4).=0A=
> >=0A=
> > Fixes: bb5dbf2cc64d5cfa ("net: marvell: prestera: add firmware v4.0 sup=
port")=0A=
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>=0A=
> =0A=
> Looks good to me,=0A=
> =0A=
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>=0A=
> =0A=
> > Compile-tested only.=0A=
> >=0A=
> > BTW, I sincerely doubt the use of __packed on structs like:=0A=
> >=0A=
> >=A0=A0=A0=A0 union prestera_msg_switch_param {=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 mac[ETH_ALEN];=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 ageing_timeout_ms;=0A=
> >=A0=A0=A0=A0 } __packed;=0A=
> >=0A=
> > This struct is only used as a member in another struct, where it is=0A=
> > be naturally aligned anyway.=0A=
> =0A=
> Agreed, this __packed attribute is clearly bogus and should be removed.=
=0A=
> =0A=
> Same for=0A=
> =0A=
> +struct prestera_msg_event_port_param {=0A=
> +=A0=A0=A0=A0=A0=A0 union {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 op=
er;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le3=
2 mode;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le3=
2 speed;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 du=
plex;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 fc=
;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 fe=
c;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } __packed mac;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 md=
ix;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le6=
4 lmode_bmap;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 fc=
;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } __packed phy;=0A=
> +=A0=A0=A0=A0=A0=A0 } __packed;=0A=
> +} __packed __aligned(4);=0A=
> =0A=
> This makes no sense at all. I would suggest marking only=0A=
> the individual fields that are misaligned as __packed, but=0A=
> not the structure itself.=0A=
> =0A=
> and then there is this=0A=
> =0A=
> +=A0=A0=A0=A0=A0=A0 union {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 ad=
min:1;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 fc=
;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 ap=
_enable;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 union=
 {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 struct {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 mode;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8=A0 inband:1;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 speed;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8=A0 duplex;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8=A0 fec;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8=A0 fec_supp;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 } __packed reg_mode;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 struct {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 mode;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le32 speed;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8=A0 fec;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8=A0 fec_supp;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 } __packed ap_modes[PRESTERA_AP_PORT_MAX];=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } __p=
acked;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } __packed mac;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 ad=
min:1;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 ad=
v_enable;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le6=
4 modes;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __le3=
2 mode;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 md=
ix;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } __packed phy;=0A=
> +=A0=A0=A0=A0=A0=A0 } __packed link;=0A=
> =0A=
> which puts misaligned bit fields in the middle of a packed structure!=0A=
>=0A=
>=A0=A0=A0=A0=A0=A0 Arnd=
