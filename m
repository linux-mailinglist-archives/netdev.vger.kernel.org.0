Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1BC4B2051
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348078AbiBKIls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:41:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiBKIlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:41:46 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10115.outbound.protection.outlook.com [40.107.1.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBC2E5E
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 00:41:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSxt4BuxPtE8kBQrtfPuobrSw70FhI1Dyc/cFyTz9vJz4pzCjjf1XgTacyz6sev913MIWCLHBWcf7v0V+17vUqAlnCMvk+gxdLrPbCBM2dGsTLaHBnXYQl/VbQht85wr/IxliDF9rympyyBP+LoP9GoKes9SJlH5w2ThG0hTUBSwu9OIxWA2M7ZF80lnwHr/Y+ETlTVYbuXpW0lGMslYI/PjH33zERcYVWcgluc6fQwdLqQnD38UmqMdJNVhkyGt0SrDwRJnsuuZYpFy0+JD2nAf8l+wybGuKNoU+AnL0Dfm6dPq+Mx47KjstFQcJKhigyLlCOVHrufC3hWlM/CrGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgEj7DuH7zpO0X/ENBs4nXf+3o6tXfG0rH0sg1FO5pk=;
 b=oaTh68bkeZj7U+YeTG82OY01ZFQi5o5ALpBZ4WcX2QP0HIUBmAwmW13EA00GjUZKmTrrdUTiz2W5Ml58aJdG38V2kfXeOwAX/PYW6EaR6MEZ6gToMlFE7SUuusAgGLy3RDnwXDwuA+V4S31nMMN66RHemjw2aiLQmuqwButU9WfG1m/4HNdnHwEDn1DTTGHIvamQy5ZIkU4Rad64As7qg3Bjdtf8rQDy0yKdtg0opohOC6RJRO2lst2iIjC38p4ZFZ6fwR6EGNYXePPBJLOF/fxW2OgkjJFicv5dNu7QcIzIuzv6q7PbHlFO9gdiVmW4hz1cZLecQNLT4aWHu5cdmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgEj7DuH7zpO0X/ENBs4nXf+3o6tXfG0rH0sg1FO5pk=;
 b=q9g0IErmixDxHrOe7VSvWhn/v3HpfWNhUJoZunaNc/1jA3sfkaRZLJmz4dV+qpakeyFWAbNoItWCxv4bpCqLAIbzOQQ3rIfgtANsMXHUJEczCsjHzYEyOx5RahMkc6+5ZgJGiVFPVIZTjLWBe+mI89X2trGgnB8YV4NQhhvUP4Q=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB5185.eurprd03.prod.outlook.com (2603:10a6:20b:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 11 Feb
 2022 08:41:43 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4975.015; Fri, 11 Feb 2022
 08:41:42 +0000
From:   =?windows-1254?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?windows-1254?Q?Ar=FDn=E7_=DCNAL?= <arinc.unal@arinc9.com>
Subject: Re: net: dsa: realtek: silent indirect reg read failures on SMP
Thread-Topic: net: dsa: realtek: silent indirect reg read failures on SMP
Thread-Index: AQHYG5fs5yDF6pxxpUySzHA96Kq4cw==
Date:   Fri, 11 Feb 2022 08:41:42 +0000
Message-ID: <87o83dx0ai.fsf@bang-olufsen.dk>
References: <CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com>
        <878rukib4f.fsf@bang-olufsen.dk>
        <CAJq09z71Fi8rLkQUPR=Ov6e_99jDujjKBfvBSZW0M+gTWK-ToA@mail.gmail.com>
        <CAJq09z6W+yYAaDcNC1BQEYKdQUuHvp4=vmhyW0hqbbQUzo516w@mail.gmail.com>
        <87h797gmv9.fsf@bang-olufsen.dk> <87o83eg170.fsf@bang-olufsen.dk>
        <CAJq09z5g+LfUPRJOoCXfdY89yZpH_4X=A0r1CPXd3Sihp7Sivw@mail.gmail.com>
In-Reply-To: <CAJq09z5g+LfUPRJOoCXfdY89yZpH_4X=A0r1CPXd3Sihp7Sivw@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Fri, 11 Feb 2022 02:40:45   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 305c0a5f-d98d-4236-f02a-08d9ed3a545a
x-ms-traffictypediagnostic: AM6PR03MB5185:EE_
x-microsoft-antispam-prvs: <AM6PR03MB518570E43F7B3F7263C4350F83309@AM6PR03MB5185.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X1AOiD8o0uH5CsYr/Qpb3j04vcLIcwmiTcppp5IJdZB+Ij0JRmOm3DHAlsrG+Yp/E0Qcp/1wj3LGqDv7mXvZNAkrlWXRiDu0TNiEHz7/56IS0fe6ImSxbnKWIxosw7/J177H7UzB56tp8WN/W2RQASettCr5js18ydOmiSv4HJhq494jsWk7fTIpGnDPjcvdxrTNzGPYB9Ny0F0nMH8GRo0VQK6cj3uIfMeTyIc1mLyekfQ6SVgdqYH5vuxRA9lrPuxEa1eQ54Ov7fouzv0jSC4A0ZG3rOswBr6cpwIjeF4fUajAZKn91CjGwymD7YC2IDkDXVY18qci3c1LTvPVl2p+BPKkNP0ulTIGbjyfOeMdKXQ3F4bQu0p0qQZEa/6iPfEBmy42+nNmyZn2tIh575s54tLBAQotV07wkHWQGiWbS0RRkg0n8Yj6pyA49D42xkJEiZq/dx+QF0OdaJfPhV/1u/ZAosfEdjEh/Wv4yRUtbK8Ev59uHlJ9J+1r7QdgjK+GZ12HqBzBK5uKjCEsm3cgNy/gY9s+keQd6vBMZ4ixCPWiQDuDNByKxCeocCjWKCja+U13XGezmT9579XTBNiwSRZH2oRYI8b58Y7bfwCgN5RePX3gF3q5nFGh4zAzJ9SH+OrqbU/6zPnqI1n4m49OlT/gRBGts17FascFQQ2rfL/GTlv+OtMqa7kxXFJ4t7Mb8R1p69yKSzdeS8lb3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(186003)(26005)(66476007)(316002)(6916009)(54906003)(6506007)(4744005)(64756008)(8976002)(66446008)(66556008)(8676002)(5660300002)(4326008)(8936002)(76116006)(66946007)(2616005)(91956017)(6512007)(38070700005)(6486002)(38100700002)(36756003)(71200400001)(86362001)(508600001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?dkcyXF4AgF2HHJhv9yk1eKCJT9lkwDyD1tOi1939CG+3a7gtjZvILhWI?=
 =?windows-1254?Q?2L4L7nLaP4vO+z/kRAFo1Qw776HieMz+3j8G9M2bO7P898kLxzMicifq?=
 =?windows-1254?Q?ohkBiN1q9mxjaIWtfswx3usoBlPlToUlgqlZLpkh3pBwR1U7zjJEfnsP?=
 =?windows-1254?Q?oTWdbm9kQB+81OpN5bcGb7fBRfYmx/svxILlc5ZaNP5B6yCZsossvq45?=
 =?windows-1254?Q?9ZMcXL9+JvSHOzTYeGbp0syGy6bLOypPqxSHSYxaZkq5y87/9eaRhUg6?=
 =?windows-1254?Q?dZHIqHydkmK/2NkSZ5ZmHxyyHcHm9laaJkSOY3zz33D0cd0ugu7MdeVB?=
 =?windows-1254?Q?xNFmkAWi2XIdPwU8JFEkqULy3640XcbB9U1mD1uGE6WHOP8KsC2wf4Bc?=
 =?windows-1254?Q?kbVo/8dlgk1vLqnfi8TkxK0pNLymJo7CBn+1ZKa2UfETuMD86AZ+KOKm?=
 =?windows-1254?Q?+F8letfmTrHn3xFuwIfg8YrwGA+s7YxLiQpxP/RLwWTcImP5QA5iDnqk?=
 =?windows-1254?Q?jS+fmd6NftGjUIdA1q+xlqD9F/nBSY2MXZmLcug4wr+mW29hpM0O+jai?=
 =?windows-1254?Q?/rjNP/KOxjUlMD57AazMt6kl3slGzQHDjMOwmU0XqwEuUNJkuDWo9M6a?=
 =?windows-1254?Q?rKqZvHcKD5/DBrDUtE2tMnHvVLNhDgKb1cW8Lj79tqVhsvJ1qmWBYhp3?=
 =?windows-1254?Q?Pn/0npkREACjMZ3DDkPszgxCj3kQfXhZ4IGumfIKvDVN919Ni2shHv4V?=
 =?windows-1254?Q?EhAEpgxZZKCjsLohS7Eie9uGOgeSgQf+nwsOCCIAlNg7Rez3bdkDb5Dl?=
 =?windows-1254?Q?4IMxSX2/KBDyBKCeHrDX3ObMGve6ooZlcTksQH4fZhHKkJWWpLMErNiD?=
 =?windows-1254?Q?n1DZIcgL/7O/eihItiK4R9D0LJqIFcCgqwyAKWGX4a9jyur8Rdnk8oN8?=
 =?windows-1254?Q?Fj3JrtXFLcBoP3Elxd5PWsQOApamT3AtIml//H5RixZlKCifJxhaaicT?=
 =?windows-1254?Q?+fpv8grl/JDBcKF4L6caqzkI7sN5QtGSO/F6YgJlzc0ra6HvgeQLxdTM?=
 =?windows-1254?Q?DL+4rqxQR8OWmOqZ89epruoM4rcPcgCBXoxt/4B7sz0Vgeyizs6vUarl?=
 =?windows-1254?Q?1GJ52+b2+i+U6ds5nc3vG7RXZp8xUxJp5ZEh/Trvf+TvmQ5AwVkAhOqY?=
 =?windows-1254?Q?ovIaFRucYARa7Th1Dk0mnks8euAgLY9NjmOv1xB4WrfM1RqgkJ+BRj9v?=
 =?windows-1254?Q?tMtVyBSbuC1KAGKC6rYA+ootIHF94L6/5GcdWtTncZ3g8RCCra7BzY2s?=
 =?windows-1254?Q?JL7Hx1rsPENdLmtyxkHtTuUaCLu+u/KoBD8qONwvxAZ8HhMKWsjWoDRX?=
 =?windows-1254?Q?yUpW5o9ZFTZG2Kqr3qzO8cjtJ8J6GNbMl1+Pv+owLanFDh8SMS6NDNQH?=
 =?windows-1254?Q?bfK2WMCQ6z7MypvzPRwW/mXM1vfhLBz5uhVgZyp5XKyj47+HJJiSDwPk?=
 =?windows-1254?Q?tSKFrHLExp+Jz7Ds6BK0Oxmrd1buYMFyefk+78Jqt8BVZU/z8gxOwYUp?=
 =?windows-1254?Q?eyDnJ4LC36CdG7WSF3ZOPrYeMTacOKDW3ncbNsYPXv02qWfCPLxibApW?=
 =?windows-1254?Q?dLSkkA5Gh/rSUFzGiNyoqiql4NUUd/ZTHjliLLpZiL7QmWif0/8xknYS?=
 =?windows-1254?Q?xPrXX4q7LdET9HgEHcdo5wbGrcHoNmjDHT3RcFJzQBgLNFoFgs8Q+gaT?=
 =?windows-1254?Q?escV5LgJcdp6G5jDqvU=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 305c0a5f-d98d-4236-f02a-08d9ed3a545a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 08:41:42.7674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zffdolko6FX7rOPH/AvHojiAhEbhs41RvH3kHwEyiev0mXvGD2SV2QOagUzhEvTRKrtxa28bSovd2QcXJFHmXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5185
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

>
> Hello,

<snip>

> I would prefer to drop it if we get a shared fix. There is an ongoing
> discussion that might allow us to drop the realtek-smi internal mdio
> and share phy_read/write between both interfaces. In that case, that
> different mdio code path will fit much better as an "if" inside those
> functions.

OK, sounds good!

Kind regards,
Alvin=
