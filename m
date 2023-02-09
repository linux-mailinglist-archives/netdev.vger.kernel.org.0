Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D43968FC62
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjBIBGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjBIBGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:06:45 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2116.outbound.protection.outlook.com [40.107.215.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADDA1CAF6;
        Wed,  8 Feb 2023 17:06:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyAZrt0JxSAhvNKnmGldBsuY7CHOGYn6RXgKIxulXIieWp18t/EQBVJKKRCSMbAXywechA8HthLiDgtEUOmZrBjru8d52fneGdIDg4sDVdz5oWNQNs26fr4PT6CSxiUB90zDNVG7N+XP/UV1hsF3NUej4rqqTdJqc7p1HSZGIR8WhSWW5zJzlUhYhhuW2dMtAXpTvhypyw/wGYxIakxHraANJfjayHLzIc2XrVflDT5zRVDdCmdoVOFwTlLHzy3SKzmvv5Qir9+7laJJhx5km3rZiQkOht3fjcREDHEg/LHUGJbs6zAZSIwxGWfprJomlMxM+y9lIdlhnsWfirgVeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Obq+DHj9np0CxQmJDiIlZVRRrbhvFYyxcZt7QtFn9U=;
 b=EEhSOsknP59f1CCF7fuxvX3mFxcWXlND1sagEfLPkQ+gaQaVUuBYuqs+kuYLbMIu8XTK7nV5AdQa8Wb2uCCmnbV145504xDePt7MKvdAECnbcChN1xwL5tX3IfFzy/6BHxseawGPjVfrEYDLkZJYXvRAakdPdgNhmYufqNJm8HqK+LBKirsT+UWB8fE78FvPpViVYu4q4HKnac2UdjFtbEf1hzJpmCBYDL0WFZ/ccDT6uAfi1KwLBx01Y2188+26LLGyDfX+icLmbBq7FBppwf2ONxfM29VoqvVDEwyAQV9rYtw2/Z2y3I1WM4dn0bCQKSVYIihSfXbGiR8EyA5PpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Obq+DHj9np0CxQmJDiIlZVRRrbhvFYyxcZt7QtFn9U=;
 b=DHdb7SrjGmbof4+E2IASInT8lHpCMAHIP6o+VaayPpJbYkg+9Bzb7Bawc/M2y6UbSZt9zQqp11G7GXfofvBB9AtHkmCNM0tAC3mShmklc+fht6JWXL2nEthzdqgIsGZfJEJXJLYUSIJU8qKCx2QZdOuejbrR3A58zRpXbV+c548=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS7PR01MB11683.jpnprd01.prod.outlook.com
 (2603:1096:604:240::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 01:06:37 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5f2:5ff1:7301:3ff1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5f2:5ff1:7301:3ff1%4]) with mapi id 15.20.6086.018; Thu, 9 Feb 2023
 01:06:37 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 4/4] net: renesas: rswitch: Improve TX timestamp
 accuracy
Thread-Topic: [PATCH net-next 4/4] net: renesas: rswitch: Improve TX timestamp
 accuracy
Thread-Index: AQHZO4/XpXVWqQ5c5UOLJ51ToYrMjq7FvZ0AgAAQm7A=
Date:   Thu, 9 Feb 2023 01:06:37 +0000
Message-ID: <TYBPR01MB53417BD8EF0FD35376897B51D8D99@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230208073445.2317192-1-yoshihiro.shimoda.uh@renesas.com>
        <20230208073445.2317192-5-yoshihiro.shimoda.uh@renesas.com>
 <20230208160634.33d2abfd@kernel.org>
In-Reply-To: <20230208160634.33d2abfd@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS7PR01MB11683:EE_
x-ms-office365-filtering-correlation-id: 1adfff26-5e8d-40f3-630f-08db0a39e51e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 77Ew8+APPq2OTd9Dhzi2nES1gRL2Qi4Tu5aVuwKk90O08oh5iJLcvfnIP0JSxwXQUCvIEnZZM8yxSAFsVcqTG3g8KrYXXZcsG9iUkB1qxDRUqWUM5URas+b8a+MK8cSAdh8X+quhpvx2kiUJRHwt3HVTEmZbFLFRdkoxG4tTwBQMftYEeqNfKlWHXc768An6ohhViY+4HgZf4YXt0d0n9ejd5CxGLnv1n2dZ0fP6K20eZq+M0vG6OOB4CT7lbyqRbVm7NjITdPMuPqesOTVY91zzTRvrsMQ9e0g0RrC3UdfWpVU0kMRxQmiIo0+DzCRjCbDOqAogeYBopbB5BTlaxctSeUXcWQf/A5fmmQJXm7jhYfUJlA/n7yGLdsMS3usT7hNDXV+etwhgU7nnGfMr8HvtC2ErjYTTze7qXyRmMwiDYl4/ddVt3S8dzRUG8XQCWYr8vmP7+10/cv95s4aOz2kM6QIzJ6VTQZHNOCdWfbqH76KC40nW3vbohdwtkoyEfJypxaKeYkuq46j/m6SJZsRnt6/4zfxH/a0+DejzEn7t5ErwA/ivc/m64+gtMCcPSeKJ1vrecjog1yi5E2YxGS0QlQICcxCZgkrPnhlW89h/X5zUxt3n2CBw9vJ1HWLHI/lhJRcUkk4tgV7tjPwg5XYS8I3O3LGEBh1EFrC1grn5ifhhfCbjGpEW9wnNL/S+jP78lNJ1UMjRn9Wddf5Otg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199018)(186003)(38070700005)(9686003)(316002)(55016003)(76116006)(4326008)(6916009)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(71200400001)(7696005)(478600001)(6506007)(54906003)(86362001)(83380400001)(2906002)(38100700002)(8936002)(52536014)(41300700001)(33656002)(4744005)(5660300002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SGPvWffMba2FO7m60XsWOTwYqPexXQA++v7q1TLhGj1lBRk5/tJbdKaQBlTZ?=
 =?us-ascii?Q?go1tRYpjxZs1iqkoWywX+5jfosfX8HS0TJBUP5xJv/nJSn+e/e+bHLX4WRna?=
 =?us-ascii?Q?5tqnBJ0qgmX6ZNWrq+hEEXcDrJoc0xwqUxtQjmpeKb5M5O0RqU3UJ6iX0iTz?=
 =?us-ascii?Q?8KAdAA3lW0XtbYWtd2YRlAotULAZvDknLlQiz4a/bG5xbegGkLKkcB3Byt5a?=
 =?us-ascii?Q?fuKJ+YT/PgSPW/uSOEtmPi6d1gZl6wbRgE3V+NdFpjw6oo0/TjeztSn2YIB6?=
 =?us-ascii?Q?m0k6V+SvWL/tea2iUQAK0vnUJZTgsOMki76zWvQ4KPXoQaEojtlHjclfFamw?=
 =?us-ascii?Q?L4mVk9+otijQwfcPaX7FTMcMZgv1ZZjFTorZH6AR+mIkZwpMObtsBz7RMWn5?=
 =?us-ascii?Q?EiMbGg2d2I9z/mioVHcVXZ+o4o9iCP7n1mC7r9FgvrMTu55cb2C8AnvmSXlQ?=
 =?us-ascii?Q?Ytfy0raCVZPXb0jmDIFeuzVhmepG4X9Onx1fAxGzLD94nOv/kWj9A8XXskju?=
 =?us-ascii?Q?OSw+cTAT3VwZSK+Ooqf7VKGLUHjJoxBXYEK6zeR22i2XiE/JpBujHtrljo/W?=
 =?us-ascii?Q?zqzcJ26i2xUTybZ1U6XS4sCLpAI/xWZMvZywyradY39LGoyefVK7SbnJJqjO?=
 =?us-ascii?Q?a/JwMb25EM+Gb8fEgP1UQPRsUXiekMyCagGP0Kau+1F+oNJ2ymkvg9zqXI9j?=
 =?us-ascii?Q?Nq/vLe4oki16w+0mhXEm8VbegX/hhvV1xzPBt7szlLZhzc1+gL/6BQqA5MWh?=
 =?us-ascii?Q?64ARjQwBTXCayqEGrBsBJMrec6fwYHX7uqVGcEZmERfnzvys1BrH0t6LpqH2?=
 =?us-ascii?Q?bw/+r/V23Ci9gnKbeAbbzm+icvKAIj72yhnvcHeKsZua6FxoV8f0ViEL4XFH?=
 =?us-ascii?Q?A3Hx5/FDqkY3L6xzcH6etss6AHVvxYluBsltaE6kzgE4N1g98z/7MeTfr9W+?=
 =?us-ascii?Q?cbsANaG9ZiPgwz2nmVu3gMP3Yq4NPkiOMRoI5JPqb8ZjCjoA4nbHWt3BFg0h?=
 =?us-ascii?Q?yA3bhmlPB0m2xRsdTwPfm6IVoRQ+463zE85/ECm2/JjQSuUy9gzlq0cpKAvT?=
 =?us-ascii?Q?Zn7Cjq5loJbqWOzuKwhsu8WZDhHLkd6fg1VtcmZFIjAnhcasNCkpw6+BlLUi?=
 =?us-ascii?Q?sZUTGCKHq0M6H1VVTRyY1kBurZuGdgZCeTo9by3tIeQr8sVcCfLxWQEyH+gm?=
 =?us-ascii?Q?iPHwXRRydiTCpyyvQuXORdjyPU32jo30I0OSUGIvReOt6e42AGVnQWmb8/KK?=
 =?us-ascii?Q?kpYfsFmkqSOMBTlj8E5tne1BaTmc7dpeso/4fQaUWyFHbh1HFTnpkWqr4VNT?=
 =?us-ascii?Q?A2+K8mpyEzECr4oyfgFFvM+UdOY4C5Ib7dFiL0gA2xJewL4foKTonrY+OAMo?=
 =?us-ascii?Q?X3/0tl8zkEjH3oYCYr4UeHjW7rTrSS4PoIcDaxkgFYx7IQfsA2s/HWzdzFcQ?=
 =?us-ascii?Q?D2k/+WGs0vIc1X/2lQ4kivWBShhsF3RXxK1JBhmAJ1M2811ooEJDN5MM7eTk?=
 =?us-ascii?Q?IHG6gjXb078SHBUBiTmKbxLcDisfL2iJdizXGf5AoHBWDKSxWJFnaEamVYSD?=
 =?us-ascii?Q?443yVGRMw3OXF3DRhLw+bcwBofZJ3o7pQGJX8wVKOR41jyGs5oYP3CBNUEDs?=
 =?us-ascii?Q?QA1LLgh0ztgndyRxRT4AH23RovdM89U6MyzAOacjqFECaIYSPjITwJjmJYiF?=
 =?us-ascii?Q?TkfPpw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1adfff26-5e8d-40f3-630f-08db0a39e51e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 01:06:37.6288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dpaV8bQj2x7HQLPLnmzcfL55spkdX8qbjX09iXGvHBAtJuY0wEpHRZp8HPhYXz+kYA2rXBteDl3/m3jsJOyfDHXVpbpcEY/M0VEJDdOqfUo0OQphDZt517O8GeVRVfEV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB11683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Jakub Kicinski, Sent: Thursday, February 9, 2023 9:07 AM
>=20
> On Wed,  8 Feb 2023 16:34:45 +0900 Yoshihiro Shimoda wrote:
> > In the previous code, TX timestamp accuracy was bad because the irq
> > handler got the timestamp from the timestamp register at that time.
> >
> > This hardware has "Timestamp capture" feature which can store
> > each TX timestamp into the timestamp descriptors. To improve
> > TX timestamp accuracy, implement timestamp descriptors' handling.
>=20
> 2 new sparse warnings here:
>=20
> drivers/net/ethernet/renesas/rswitch.c:917:24: warning: restricted __le32=
 degrades to integer
> drivers/net/ethernet/renesas/rswitch.c:918:23: warning: restricted __le32=
 degrades to integer

Thank you for your review!
I'll fix the warnings on v3 patch.

Best regards,
Yoshihiro Shimoda

