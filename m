Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882656ECAD3
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbjDXLAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjDXLAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:00:16 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2137.outbound.protection.outlook.com [40.107.14.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA6F3C0B;
        Mon, 24 Apr 2023 04:00:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3zE2QP6QDDv1mtNmD7NDMZUD6hOeHvf+i278d5vocC3Ic0LdD88VbCC7ibjdTbnkn8Q9+l+cgqY8riB9k/1l756MgCmDZpRNayoTRp1T8S+HsTnEbZKqUOJj7SbQF4D327gMcsQR4X8tCReqi94PoxVR1wr/NqutXQdTbMlTLzDumIJBYpAtV6CJk8WItkGpMn+CXSKpZa1RXzbp35R6+dfJy95rThyMEheQhf2FGr+SzuhF0f0gdCVf+NouITUobFENFCYLOT9A7+cppHiZrVfwyuxVm9KKtIN7LVtq9Y8GC93UqsmBveaf3HYZMoUpl/43ukvEKYXD+e5cN/axw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67Mklu3t4zbKHmE8v9Aq+wjbccrGSRZ/Jje1UElw2JQ=;
 b=WCSmsEKq/xEloTuJW/G6XgK405gPi0peUPsbzFKTlGg4NN82gg1dHl4knRLe58L7XQQ+pBYXZsn9wuCvHFICxja4/hr7UTXJsCdUyWKk56nMcLtGyC4PT4vREdgbd2GPQ5q9JrhUpmSU4qJWERkPLcltCSLcHWdnitSmZiFrW/L9FfYpWs9tqUUzun/Tuw/G+1RdP8JeC/tdSJjOPyROXjKb9uU5sW5t1is4fFP3k6fS1u+y1z8H1zPkxlelr6QXheNSDJtfeevw3twRAG6k1ZY3zK36DOqE+RBp0cLYYcfrnUDZ+iKxzEdtHl80sTC0SWtlGxuKlUTUXu1w9uDCLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67Mklu3t4zbKHmE8v9Aq+wjbccrGSRZ/Jje1UElw2JQ=;
 b=SYW/rdIA9lbjbuocTKu1IRNYCEn18uXfx15fn6UyBfCaNRt64BibTDAMoWqftd5rer7p6mz1sAvlPM0cadMcZA0mPAL4Su+gzltQ66OaG0612PlkUWA/YYbjH148x1I61UzhWgAAcvbUEnM3Nn2zMp0sBPgzL2l5ISjA2e4bQpc=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by DB9PR05MB8443.eurprd05.prod.outlook.com (2603:10a6:10:297::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 11:00:06 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::bb8:eab5:13e9:6d25%6]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 11:00:05 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     sunichi <sunyiqixm@gmail.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>
CC:     "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] tipc: fix a log bug
Thread-Topic: [PATCH] tipc: fix a log bug
Thread-Index: AQHZdZf6IGDxiXoho0GFykNFM4WSHK86SrYw
Date:   Mon, 24 Apr 2023 11:00:05 +0000
Message-ID: <DB9PR05MB90785F1F423F12B4EC5EC78688679@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230423035545.3528996-1-sunyiqixm@gmail.com>
In-Reply-To: <20230423035545.3528996-1-sunyiqixm@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|DB9PR05MB8443:EE_
x-ms-office365-filtering-correlation-id: fac1e0d6-72ab-4811-d470-08db44b30fd7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bZsaOXydZBz7+b0kFYCDlZzlq8mnB4pohjoBzQg0wyHqvo9p73i/ZdyDzVGjOpo9ZWx8649AmeKybzM6UL/CBdE7ZMOL/UXLXVEI1gKkdhLjEXRcVf+U2qonuDhcWgqmc0zngoGsJPsEMij8q9KBLhT/UvgfPCe306zb/mQnTc4AMqZeOBcPtgcjZOSuxt9BwlBg+IfznQeYEPhN6fKveaLSw5nLAavEdmehCTt4cw8qWDxplRL3oBem6DknA4PCbUm71R+x+4XF6qq8wlHdHuZPS1WIL+NHQjGjhwljKCFDqSI7c5CR6OLMrpPVYd0EeRXXOOHvILsUiZyNp8Xuw6qbYRKLIj5htkCeOoLar9CnDTvDci9aldE/nitRcjldXornIX9RXtgK/CQDzUJ+x+WtP5522qjrCactpPhPXnelulfKLyMRsxGbD3tq8x409eKtsPebcDJ3RjRpt0iApOU5k/FmzmS8iAyeKjYuXa2YtqYaFsKM6pEh9tJknLG/oCjOuOP68GdEAtm1t8yQealrFj9pEgArIDVR1I0dm2vVQmPtMhJMo5YAxOUwozggJV5wuXml5GslN2DM/fJU8V3e0la9OonBzukRnmrj2hw9aZW1lMtI7YI1IGjZTswi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39850400004)(136003)(396003)(451199021)(478600001)(110136005)(54906003)(86362001)(186003)(7696005)(26005)(9686003)(6506007)(55016003)(33656002)(71200400001)(4326008)(64756008)(66446008)(66476007)(66556008)(316002)(83380400001)(66946007)(76116006)(2906002)(38100700002)(122000001)(41300700001)(8676002)(8936002)(38070700005)(5660300002)(7416002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fG3g1AECFdRNYu41fJfKwm88/CZ9s5ilA/9s0UwUf8nCftTgahegeHoagJXE?=
 =?us-ascii?Q?zoZUg5iKpiGHu2uEnvROYPp4dMtmXGDvoUhjPRNL9j2RouNreYCM9S/5ujKz?=
 =?us-ascii?Q?Hwmy3YcQWJ0Ch21r8fV0eRzZN4I3QaV7PiXAHAwAh6o403KQv9QVscPqakmu?=
 =?us-ascii?Q?TQIN9FFwlheXlW4SFbsf33V76NHcSYM2tKtCKcqNsAqICOPG9R19YmdxZ+B+?=
 =?us-ascii?Q?+45mTPJyX1/Oax5TQ7m9a3GejfP4RYsuFwdKOoom8vjki9AbQCMkGnsDdiJU?=
 =?us-ascii?Q?z52HK9L6gRTUy/KL6t53Fn+byaXrTSgbrRHBQB13KphxfLitWxWZIRLxKQJZ?=
 =?us-ascii?Q?v8j2c8cuW/HSw+cCgwAHu7wRL8Pp73cnJa2wHU7BIuqj5o28JGRSm3bzglyS?=
 =?us-ascii?Q?bprD8vrqECuYekuk4boWr893qNr747/RVCVJwNUCJdU55cX4ymO13L4ZKNZA?=
 =?us-ascii?Q?eYqd16Wf+qaPERFc6Zm5Mv4tcizHJ6VfJQ0jOBW4IZqrmk/0QUS9j0RC57pl?=
 =?us-ascii?Q?T6W1stAhcr2LXyCeTe7DnDeGTjAiJHKJueo/Bxestajy7tnM/IG5NN6OCkUt?=
 =?us-ascii?Q?OXAWdnFJ3CR9hneSbIjK/RvsRbB7z1JucV1DAcPI+yu71x46hv8W7elFyNsK?=
 =?us-ascii?Q?ZQjcAqiRSJMkaua078/c5G1kf/kpgHGZPhUSsmhhDtLBb6A+SsyazD490V7d?=
 =?us-ascii?Q?xgo3c68GcUV7Jxmjuu4Id43sI2VTw7X1IpwOCebi4fx6SAbuiPPZJw4apZ+U?=
 =?us-ascii?Q?Gi9E5ONBkaYXOhkzY/bgLjWLm7roScE0yxmIld0vF8J7oxzFxGjhXwyFh+k6?=
 =?us-ascii?Q?rDCfXsuB+mt2DzvgNDX04s6UD0e38RhYo/vnYMcHuwludzLhyQAtoBZdcS7b?=
 =?us-ascii?Q?O39VTf8fGcJekWAbltXWUuWr02hGeut4uL3IMExXsMsBCQOVsuZZ1g9jY5MP?=
 =?us-ascii?Q?hRognf1zxBW6nuu7j2c0yOHM++vpBHQ2fNkFzvAb5067s2prHXVQFcsO+/LG?=
 =?us-ascii?Q?QAQlb08T9paUbHGxmMPRDN45NztAmDD2f2jow2Ic8YT8rSFasC3ItP2KcHVI?=
 =?us-ascii?Q?b+5u94NaGBwW3i6118r5ID282XFA8moTjeGhTASndBh9Xb0vo/17sZFHKxY6?=
 =?us-ascii?Q?g8xaKCC4IlRsy8mQg5Ab8gfYrZsPeHC+TVOicO4hl7FWJn1A+0KgYO0sscPq?=
 =?us-ascii?Q?WtYvxlunvs5ymG1SHzrMY7dnxWWps74ov5Eed1w7bvz8tnPLjPiE7nO1looT?=
 =?us-ascii?Q?wFmVrjt9DLI4/iDK9WUGXgPPliggmPh4ifCbCXrNEsrW7WF4MMIibcue6inn?=
 =?us-ascii?Q?+0GUK4jN52PhSSRX+CPCJw5Zke3Mnmp8PoaJpl5j2fYdIiYxz6jo0kEZUHEC?=
 =?us-ascii?Q?llXYv8HAT4J/h3RyRDibVDpFgkVbiwSbnhdQHeUGjdbpohzduEQzVZQKCI9R?=
 =?us-ascii?Q?BAQsJm6ZilCiKcRMQXx3ln/FgfhPYCRXFgyxvuVGF/6T5OpUX5LBlUy79Vys?=
 =?us-ascii?Q?Y48qxuIIwLKNS6N1wJErh1DOxiFXT2fe8wCQg3NY5kGVzR+enQocKdxrk1Hn?=
 =?us-ascii?Q?rIYhwiTM9mxIGOj4BsHCrnsTe72SEPXvqgSofoCkchiCAAcJMRjACMAPIwib?=
 =?us-ascii?Q?qQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac1e0d6-72ab-4811-d470-08db44b30fd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 11:00:05.8469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HCrg7KglKH+J4AILMs36QeoB/Vcf9D9HvIFRyjEMjqLCWBfZQC5rQk/57nuvUdSkNf1q4GJ8DFZSfsihLfpKNFCV+sFmb1qsJglUbGIYw8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB8443
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>Subject: [PATCH] tipc: fix a log bug
Please rephrase this patch title, what is "log bug" ?
>
>When tipc stripe \x00 from string hex, it walks step by step
>instead of two step.
>It will cause a char which ascii low 4 bit is zero be striped.
>So change one step iteration to two step to fix this bug.
>
Please rephrase this change log by correcting typo/grammar and provide prin=
touts of "tipc node list" command to prove unexpected/incorrect node id.
>Signed-off-by: sunichi <sunyiqixm@gmail.com>
If you can prove there is a bug, please add Fixes tag to your patch.
>---
> net/tipc/addr.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/net/tipc/addr.c b/net/tipc/addr.c
>index fd0796269..83eb91ca3 100644
>--- a/net/tipc/addr.c
>+++ b/net/tipc/addr.c
>@@ -117,8 +117,10 @@ char *tipc_nodeid2string(char *str, u8 *id)
> 		sprintf(&str[2 * i], "%02x", id[i]);
>
> 	/* Strip off trailing zeroes */
>-	for (i =3D NODE_ID_STR_LEN - 2; str[i] =3D=3D '0'; i--)
>+	for (i =3D NODE_ID_STR_LEN - 2; str[i] =3D=3D '0' && str[i - 1] =3D=3D '=
0'; i -=3D 2) {
> 		str[i] =3D 0;
>+		str[i - 1] =3D 0;
>+	}
>
> 	return str;
> }
>--
>2.25.1

