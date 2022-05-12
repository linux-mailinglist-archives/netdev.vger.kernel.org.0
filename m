Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4AD52431D
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 05:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245308AbiELDMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 23:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiELDMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 23:12:16 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2094.outbound.protection.outlook.com [40.107.114.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E75A6A060;
        Wed, 11 May 2022 20:12:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YE3l+ZXXk/IZwUVKN+A5dXx1d3wDGzYbMtksEYjh5fzyHtZ6JZkKQhBQuoBGvPdvT52BCi6FMlr3kkV6ijbgzeDavbeci1DyQeqt3macqj3btYid3XPPqWhG69I8KqMGIdiXnvgCXkLpREFjCJx5mEts8WmY8EBfK3RJr3o9yt72kPtLFgtd9y6Kcyjx6jfNhH+f2a5tmtppY1w5XaGnyukLfAk7Q0Q/pKpzt6hgA2/Us/ApYZ/SQeLWmRItnekESh+bYoKA0hvo98wtCg+5j6zdN1uVKt3RN4NvqdQKM9XgGw4Q2jLoglogmIH7gT6e0QzzyhSI/F/xaeTExrEJRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+voINXgt9rpBiFV2kPnG8rpwbCNsm33jn6gsuEyVX2Y=;
 b=Li+e75FaLvAGoeuLm3KCN7VZivUJ7Ga4IIFqo+UPQ0YX0q97g+EWWDYH4iziqMtG3EK1yNEnbemqr3R0xL+AZ9eoLEun0XF6qOQdoGiXdHw9QzqvZXzT5PPJwKVOxA/atAiG2sG4om9HYzjaSkVnTdomzv5SItdusa8T5LXF7KaQT8ItMJKaJuFhXJ8KiFAOKHtMNiWEKj43hgrMAoxvGZd7nEv+wGFaJ/gCJpqwHjQik+S0S5DjteoAQlALGrqAcmiDhrfIMA/+fcGrz3dFfCkqmGH3UBNKs+S5u63B8YQX7T75//XxYsit52KNAvNT29/WQvhodZV8HzCxNxrWdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+voINXgt9rpBiFV2kPnG8rpwbCNsm33jn6gsuEyVX2Y=;
 b=OkcigOuJ1Q9ZxTxDv53l3CCNjP02DaxafmRcvdg6uUEyrVWOmoKyAMMTvr/3jz3fb9qSI5bdtg5Rvdq09V9DfmycryIvrVyhrlryL/AY3ql04jYaxG/oG7ZjMjeftViZC0s717m4/VPkRIgI6n8VVHHpXOjxJ/nAH0yEUfw+UzA=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS3PR01MB9606.jpnprd01.prod.outlook.com (2603:1096:604:1c8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Thu, 12 May
 2022 03:12:13 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 03:12:13 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v5 3/3] ptp: clockmatrix: miscellaneous cosmetic
 change
Thread-Topic: [PATCH net v5 3/3] ptp: clockmatrix: miscellaneous cosmetic
 change
Thread-Index: AQHYZUL8ldsZ7eBi5U+Dt1LHv3Avg60aZmgAgAAq2yA=
Date:   Thu, 12 May 2022 03:12:13 +0000
Message-ID: <OS3PR01MB659312F189453925868225B2BACB9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
        <1652279114-25939-3-git-send-email-min.li.xe@renesas.com>
 <20220511173732.7988807e@kernel.org>
In-Reply-To: <20220511173732.7988807e@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d215f45c-46f1-433f-d9bf-08da33c535f5
x-ms-traffictypediagnostic: OS3PR01MB9606:EE_
x-microsoft-antispam-prvs: <OS3PR01MB96062A5D03715AC21BFA2583BACB9@OS3PR01MB9606.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wh6P5AOKCGEaX926mqzQjl/YRTbykbI7Gz/7b9a3Wc87Yf6PURxKw0K88pB/jYoKpHmTcfOr9vgelgWO9cGGv3vJPRd92f58sCyMcOAvtMo/BGblrbv+uA6JRRfi1XOrczJdtmk2JR3OOwUYR9NGWsHgf7lsRxbcNjJAqPJF95W7IoDvGZim142da86F5vn6KFomGlo+8CrCH1eTc4lcS1QCCSG/6KNUyhd7vr86aXs8J5Hkhidfkz7jP0C0VFhR24aSHGnl8wHB7G9j3gdshBetGDwufeEoKJ98wYXOtM8cVLnfK0DQsMBkYw8M9ofFIb6JAIvkRrbHSwUAydievEWPgx/uvbwCG3qVP/s94hyWp0O0ez9zejnTQWQJZrdYHd8tIUdghRV/LsNksGVGCetdOJLwfHatxuFt/YFSkYYyxmq7ueHndcS3IcUMTiwPfLCfg3kJj3jcpYD7CeAPg4zHuCe/1Sn7dpRaxPhqj4iY05SpqjzhnD3XyIUobUl2NZZaQcDVw3ZcflHoo2NzqtTOqBTESzd1fZt9v9RvAdKbxGa15TSie4a8uEFUwdFQP1noOePKbp3oZYjvrwj7Y2Sf3gGt3aMXMflI6o0SrpBca+It97wyyPkfKQgMEYssc4xf+KS4j0Qo8jXIHuhl1Zg4ul638bYCpKEmu05OCCoNAyjAWx1IbzHK2fZ/RXd/48zgakcGMoY9eV6eKPEBmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(2906002)(122000001)(38070700005)(38100700002)(5660300002)(508600001)(4326008)(33656002)(186003)(66476007)(66556008)(8676002)(64756008)(66946007)(66446008)(76116006)(54906003)(316002)(6916009)(6506007)(7696005)(71200400001)(558084003)(26005)(9686003)(86362001)(55016003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QcNLs0embVhL2zo4bERrz87nO8kdXQ2r+dDmm71Ml4efGxd9hllewcPp+XnG?=
 =?us-ascii?Q?NuH6/EkywCPtutQ21p5NwOYoOckp9Py/+dPP8WdkmEAw5dXKQtjxbjTSkyt8?=
 =?us-ascii?Q?3xihdy/fDjRE7j1mZOJPKc45lcnfDNIjsDwjP1ahHjUrK1eP30E2610Nrluv?=
 =?us-ascii?Q?tsQKg/s7sLvpTqDrMNlL7Sci6Fc/kUnUEOJ87L6DbTlb07cMaWtvSCuxmOSL?=
 =?us-ascii?Q?gHxMzIa/SIyfKJryITEtUg5Yea3eHNTuUyekT2DxLeLMoxso80ZVJ+sinLcU?=
 =?us-ascii?Q?6lGD7a65+delhEGJaf8PO5XcItWJRP5G6SYRk0XCMYF5uEqWvEm/EREclGSr?=
 =?us-ascii?Q?zIIg8U/2Qd+Y25As3Xn2kVRqUz3CiVuOtirEzEZU4AunaHzp5B1SDW9pkaHO?=
 =?us-ascii?Q?uJYtSgATNM/0J/vzsuXCdcV8SR6DejSYYdL366ijOseZ2U87TYzYT66M0A5/?=
 =?us-ascii?Q?RP1wgcIohmnqE45Ur41Uz0Nq3mqXkF+jn/PqTM6vRXVfwL5AtSY0CLfnp2PO?=
 =?us-ascii?Q?8eVI+Kv/s1fipehchtC0EiXwK8e2QQ+jGrHQxJIs2tIKvd+9BFpMelJMtGJO?=
 =?us-ascii?Q?4dahaOEPM4qmf5If8hBGb5nLqFG3lhTmXMKj33jZ10hhOGZk0rZ1LLTVF/B8?=
 =?us-ascii?Q?627Jp1V3qEIsDvhgKVmkpewj7sMjYZxGo0dJ+zbBCQCWuaXQnA8Fpi9k4VBG?=
 =?us-ascii?Q?Zfl1odFxnzM4VphwuWnScOH0UTcyEmhUKWFzeEh2BNWA+SswrHgG25OXl0X2?=
 =?us-ascii?Q?2b4qHFzLvEA1YWF/3h/g0c3TRuUrVbbiTw5V4G3KETS/3HTcg0WlHauECzr5?=
 =?us-ascii?Q?Mktzo1wXGI2MysdhnX9v0Mvj6x7KgOGx07ZXk+qA9wGpABZFzPgrLj+H0bSW?=
 =?us-ascii?Q?mTVZcZetGmBdgJ0qjcOrCON/cUzhD9GZlveyiq6rGjd31MJSGb4OmF1uC6b0?=
 =?us-ascii?Q?oifjPD/D39MlxlVN8tSLQuOJRPBIJBtKyRqzes0FQwCfr9CsL6iQr5Jh/P8X?=
 =?us-ascii?Q?ExhpTz8PKM6lIPhi6G5QRNk5sAGpM9eoJy9YqtXIIOwacFQPvDGIBYubvjhs?=
 =?us-ascii?Q?EEsRiUg4GVnZINL3gom9FkrqCLlO1gxst21mPjfEhPbkF5q5iXhCIxlJLbnW?=
 =?us-ascii?Q?U7IZOdxR5DPWnwX133uyE9C18PkFKe1MnEmtmAXrBep3nOPLnLl3RYPTvJeo?=
 =?us-ascii?Q?63zQSIJad5T7+rpVDl89LdxbCrI//h4X4jWtynSbCAfqyzY02K6X/dmnASiL?=
 =?us-ascii?Q?ZJ57dNroADI9yR5RSCyY5KQFFv8kE+8T0s42CqTX0UBfaM9xsJKQTUqVqK/P?=
 =?us-ascii?Q?lubCiCUoMtemYnRY8EeFDdPgjMrM+hqFlwA6VjdyWgzqSrTazXYSPgpFCNPg?=
 =?us-ascii?Q?0wBKn8gNgL02z1I2nVwt+zPoduanIodMg5HslM/+QQ+UTPNj+h86aSFD6+03?=
 =?us-ascii?Q?3GB1O1F1mlU4kbV3FursxbqZMNGhdaTNj0IRL9XFfPdg+Nea2V+wlXtoQm0e?=
 =?us-ascii?Q?XKeCpGU83h7mehqFAqLnVrlWnyB/CVws6O0s5sSsNm8Y9pmYShHX2qCQfIba?=
 =?us-ascii?Q?d+s4Prhybsh1ZbrXhIU+eWJHyT0KIGg0c53xlUQNx+iudXqMJKfVBy91HXPE?=
 =?us-ascii?Q?gYfnLB1WshYmEmSjjto3L7IXqsb1/MF6d/mK1MpuSpP7EGL5UMlQcbp6yEMB?=
 =?us-ascii?Q?tZELjXcPSzj+T5Gohj9RCvIU0cfSRILH5j2XymiuElPjPZk2qT1jbOB17nx5?=
 =?us-ascii?Q?Uoykkrgkug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d215f45c-46f1-433f-d9bf-08da33c535f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 03:12:13.2756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oMRsobx+0YTkHfeRFwKDmIJoFJ5xETIiRg51teZeGIR2M0zKPKYjfSYIlB6AAtWGBdE8OtmcdB2ySxFI65yB8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9606
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Not what I meant. I guess you don't speak English so no point trying to
> explain. Please resend v4 and we'll merge that. v5 is not better.

Where do you want me to do it then? PATCH 2?
