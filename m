Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8900B5F9F76
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJJNdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJJNdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:33:43 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2068.outbound.protection.outlook.com [40.107.21.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D36472867;
        Mon, 10 Oct 2022 06:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/b6rC4+N7moquoSYZj4VVF6p41MIZc7HV+zq4WiAeISMay4ENPrj5I5ql8hiaL+m5aYT6jQloWdU5xa4wtT8mDvA79wU73E9boP35+sST3IdD0PYJMFbkEJryrPoqLBJBydrCvi4iGrHGwdcGdFHuNnKwpw2ceTAZrJ1FBYs08xf4Y44irjJssuXR4hI8WKXzQkKU4c0WzQCzRV+SwAH8+FkQcl2VeGqahAEyFXltxsWKIuVme4pWcCjonUMyCOqvZbdlkAKUagCJMvY2akBM0JuO9Da1/ZvJHoldlvkIbU/PRVdzVYC17PzrmHMHV/O54EGoVQqd7GMy9ljwNkCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YYda4fyhIsLfxhBRpob12HIVpjUaIh8dFzGwuWFIxfE=;
 b=ly7udvLvyFeMEKh8Z7Tzn9LxTPJwntEwAG3khxprVlZHGn0eSg7XHhYh4TJF5okXVKgxLVPK6kMZweahT5QK6WdmYqgjujynyJkDVPGY7/lFe9UohG6vD9bjSVd8q4IPUh83kFZVdG9DKb0qydsHzV51gDjYOuBmPlY1lh2StWFkRI33xhMkpuMiM5wiD4GgFSN+aGbKXbvEwKX8GNmeGQ8iSH4YNKGQ3hotBOyr6BtoeC0ZDFFhBEamtDWz5BMbDqUWEk3xvP6i9YT7M52aBuXw/JNVeQig3woI+FMOZeG8ZwMG2G0Phsp/i5ZJrIuwcey5Zw/qB6vOD8WHFtxCMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYda4fyhIsLfxhBRpob12HIVpjUaIh8dFzGwuWFIxfE=;
 b=f3aD5ive4mYJHq0Mitb9Pwpw+qojDJY9JC9FOvDS3n8007l9fZ+ngT+ccfgH+84WJ32PbXi3owhNdmgT3X0+WwlwKOUqgXwfNPAxfPgRNvrsqhpk/loPxH+8X/dAHyUycnCT+i9YeIjmikUHV9hi3ZwgYCsDU/Bxs5xjsOD0V9E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8808.eurprd04.prod.outlook.com (2603:10a6:10:2e3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 13:33:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 13:33:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.10 22/34] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Topic: [PATCH AUTOSEL 5.10 22/34] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Index: AQHY3C2kHrdjzthEi0WraLEdXdCgp64HoXKA
Date:   Mon, 10 Oct 2022 13:33:38 +0000
Message-ID: <20221010133337.4q75fsa6m2v5ttk7@skbuf>
References: <20221009222129.1218277-1-sashal@kernel.org>
 <20221009222129.1218277-22-sashal@kernel.org>
In-Reply-To: <20221009222129.1218277-22-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU2PR04MB8808:EE_
x-ms-office365-filtering-correlation-id: 2f3adda3-913c-4b18-5af1-08daaac409de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WScGxHIjHIVypYP1OT67BU8cdNdFhOfdflqrJNobDyfl4rbIM+4+Ay3+8OtDbFkvp7nL3pypFlvatcYBrJZkF7SgE5eUol9FGZYDYITg2NKyam1YaE8hcZDrI8aPd2hNF7mslirFy8REJSZzvleIk+UqY0HrrFzAXyPHalhXKQrwWX+e6Sjl9Vz/2m3DljQubSAtD3eCbmDnkPKWCvj0ny35kzxtTnN/ksqbGAa/hXbGRa1mGBXeg2ryy9bZite2VYxYyFT407t4WUCz6pESKEty95C/6GdeUBkMw8aBB8DYBd8UWFm70D04oS0IISoE2kY2/nB5OwkPnewv42YXSjpHDNwQIM2xxyfFS5qAbdLCdZL5Fol0RbNGV0uMVEapLnUufE1K3/laL2UtdYVjKg9HuDtI8gVeZKDf7sp9suXVCo+qMVE1SCg2xwtqjCYVRRQMRlaN4ZVQvCMekRmLvzsT2JOP8CV54fTpW0Ckz+2Khdbmo9jczocG7fitEuiY/5x1reTHqVJBsJU1iAQa7t1vHjO7qMo+hmBOAxhlIwZXAk2Zp80HhvTM9hDIrdbsNq6RtadEMHA0vfvFe0KT6SWQl6qj29tH9zFccn1JJfW2Vwc2oIWzBag1H9SJt73s9q4XqzO7Mi6BorU5gcSXI6TWaYaSm+K81XGN6kX7nsAek/liwWt7kkAuCH/PYIaQu2rNP3ke6T9acgAuwOE3kuVJJziZA1pUm4fgYObS6LgkkUve9lzMty9kl8A5vOg7f19Y8AdO2vDEBqTZIfWKpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199015)(6506007)(26005)(38100700002)(122000001)(66556008)(316002)(86362001)(71200400001)(8676002)(66446008)(4326008)(64756008)(66946007)(76116006)(33716001)(66476007)(38070700005)(83380400001)(186003)(1076003)(478600001)(6486002)(2906002)(54906003)(6916009)(5660300002)(8936002)(7416002)(9686003)(41300700001)(4744005)(44832011)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MHspMM7zls6DZBqSzxsRzeX/KKQaCdpXK5g5iBYje3mf4/huyct6ro4UhEEE?=
 =?us-ascii?Q?g93XQqvYuWYh66GWAWew3tv7jXjAae+3opgZ4e15krNP69IUbJapBhBFTg9o?=
 =?us-ascii?Q?fKwiAuixJPEAFi0gprSJHlrlXY209+z8khH3dTkFB5ubnAsA4RIYKj16R+H6?=
 =?us-ascii?Q?USp51Aud737XkSAKVRFp/QtDmHNjiAh+1qhZSl0nCa36A99JuPkfTRW/h/hs?=
 =?us-ascii?Q?UbXMyAIZF4udNs2qE2JSWLi6Zplw/CkrvnXpviPV8R5fjWH/gsPICBTcmWt1?=
 =?us-ascii?Q?c7cs9h+4Zpe9rDgZLW/u7F4Q+3Cer0P4rKbxzH/jFxDHiZoUMIz0LruIfNkc?=
 =?us-ascii?Q?+/Y/Gk2bwpQPi/nVOw3fVNZDrJUIwW1Q+amuY2MnRrUds4PdgYKmFyqdIX/j?=
 =?us-ascii?Q?2YXUt3LHdxvMlzZKbU0dQNSog0c5gNtgm8ksWFii7Uoe4ykobD48qt7pUVxc?=
 =?us-ascii?Q?HZ5sLaxWt6AeIcmGhGLJh2F2k1tcaX6HhSmN3gmWcYruyoNci98GZeA/UkQT?=
 =?us-ascii?Q?NtsjR9XnNUqYAjAjkiqLVfa5sF/fQxOluDqIDYGUf1PgREKi4SnTW4cHSIc0?=
 =?us-ascii?Q?kkJFIVVl8qq/2MCz8rZSuK6FtAh/bD7vStjlNCdIsD0LCwpNiQ4OvSHDaBEp?=
 =?us-ascii?Q?UWxhl6mR3PqL0WqdgONjDtWT1t/Zl5VYs42lzSomsv4OqnHKVFHLbAe6OqiV?=
 =?us-ascii?Q?QllF0BIcmuByk1tWckSB9FB+9VRAsL8mByrc4xbVSexZuQB4WcXC025nzio9?=
 =?us-ascii?Q?jwRoeRp3gcYB6Zdfoe+df03tSTh8Vs58YwU74P4RowJlh0UWLLszoVLyZD+l?=
 =?us-ascii?Q?11VRjs70HnE+EmpbuINFx3ViWMGcm6IwSCd3RZ2Ix1+x7z2OFinhYPRuMzOM?=
 =?us-ascii?Q?hACJG3b+O98mrdd3YlAyueFyKMolZumr2q9Bzlny17LuRGANuEes4z1Fb+p6?=
 =?us-ascii?Q?1qKikJ9oBLPH3L0QA0JQC83+54L2frWXbul/8HculTt9WCS2PFxzBJ132aFW?=
 =?us-ascii?Q?8ZOzlibp34tzoves7pJqLZM27V8Sa64174L/hiXfTGtsMpSV1OOJcy8m3c+D?=
 =?us-ascii?Q?GjGHKlFJsp0Lubr0UohdN7Cug3W8e2XQd/q1/8o+gtDHIewhmkBuXkUnUMZh?=
 =?us-ascii?Q?r6ahVLW5XwI1oPT99bjw2DsVh8s2xqRtHp4bKKG3P/41VGTDVa4f1KIIuoVv?=
 =?us-ascii?Q?oYiw1EpEo9O93gVVFphuP4l5wlS3dlA9zM9fOenXDl6HsnbYiPgKEzn395YE?=
 =?us-ascii?Q?Cqe64n1EOGHcMJtLNUaUIM1KRxY2doL6XljsPIqgyI95fcLYwPT2S/UGriFp?=
 =?us-ascii?Q?y9jQjKydyn8rgTafCXKXnrLf9EEPV40rimB75HHHzykoAuXy1+B0E35fhZNN?=
 =?us-ascii?Q?eVobF/tgJUc7eLuv/YRHNRqeDcFNIsGKjEuWmwlq2wvJDy/Liu1ck1L5KBN7?=
 =?us-ascii?Q?p/uqKT68WGK/dFgAuwxWR0uknSjGeEQrMiSoO7DrmPFGeoInHqzWsCU5iz0W?=
 =?us-ascii?Q?8YTsyB3ZkwGUsw+CWtIg7kk7o2+bJTmDvCDd7YchT5yIzXfGbSF1aOOyvsir?=
 =?us-ascii?Q?OvLPgBgrM5mCzQF3I6J0JdVfGmjYBkrdwrotV+Q1YyXo5QJUrXy254cz4R9/?=
 =?us-ascii?Q?ag=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <849BB510DE04AE479EB1FDE3BCE793F4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3adda3-913c-4b18-5af1-08daaac409de
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 13:33:38.1600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8w5d8hY5HXrFAsV7SEvIUDvShHClSQkPlx2SqEM5a0V6vr+u24xWRgkbP2Xytss6Ue4bIMYAHBxW2589I3LrOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:21:16PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]
>=20
> Since the writer-side lock is taken here, we do not need to open an RCU
> read-side critical section, instead we can use rtnl_dereference() to
> tell lockdep we are serialized with concurrent writes.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.=
