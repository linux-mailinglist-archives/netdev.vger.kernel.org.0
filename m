Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F283492390
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 11:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbiARKNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 05:13:48 -0500
Received: from mail-eopbgr60102.outbound.protection.outlook.com ([40.107.6.102]:42627
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229514AbiARKNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 05:13:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGMpMzYc/i+yYpxHmkMHaaALCE+C2B5ByvwTdOV4qYtKgZoXbWAe6Jklb5jGXiJgpLaYduXiEBN/PMqN9UqVNZcK8Cttlbk5bEkm962nzs5GqSaqKESEtn95cnHSE8xbtRyJiJ+//9MfJ3K6HZD9cubWePUnOWWwyXgU5vIxiUlPg08MhWjg53RrdZq+a5bPlmvwjvWf/Om17TwrQ9dhdKXA+yMv/fNNTcvPn5MJ6C0oUwvSStXKajXeQ/oK43gHw9+5zPXIZszaKXidB5v2Yl1HE2jzGeN+9FRwy1PhfMUQ0CKz3GAE61Alb50qT24bJrOrlkRozA17UO/o2XlIkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23TX2fmN01uzjutGmyK2Readbb/ButdsMG9JjRy4IN8=;
 b=FZHPMlxEb/RpnnC8cypvMzQHjqBGZvoXiQpClRxYKI/J8dLNyIeZbs6CqZkmWWucHAoSzAsqzptffSbZjCG8KYqOuQmb+cnLmLbEp1/1Ymtxs3Voprok/mdZpLGoWzVQcMjBD2VFQOWkr0hfCJNuVZH4hjgOAC1bfgl6RdQAYjPMMEsmiErkxV6XwOCNtWaKEyYvUWHxZq2u39RGKYSefMpkCj0JNAUgwmgWTb3kN/rtC2STyiL1nTihafLXeII2pdt7EZSk0N9rSBLjRm8NguoutCEGy2jNLPTUvzZD3i91MA0yGwpY0JNiH8SJn/A5Wl3DMG/Ub7tzmqkvAiNd0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23TX2fmN01uzjutGmyK2Readbb/ButdsMG9JjRy4IN8=;
 b=P06bkw7+8pqJsfd25DcsxOdK5Qscj0InXGoFvPklZ3RFQS9jSuzaJa5/gYvQsdL1Z48XhnVC3QvidCfJatjvwEXDrbGwIGXWYMDp9kiQrWcic+N+kjP0qM4Aqp9nSpYBxRHEjbBF1x9kcc/X228P6EVVQnKYKBQIPIrl6PazE30=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DBBPR03MB7081.eurprd03.prod.outlook.com (2603:10a6:10:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 10:13:46 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 10:13:46 +0000
From:   =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     Frank Wunderlich <frank-w@public-files.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Thread-Topic: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Thread-Index: AQHYDFQUBpv8Dc7KA0ysRCZOWA7ayA==
Date:   Tue, 18 Jan 2022 10:13:46 +0000
Message-ID: <87fspll5ba.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-12-luizluca@gmail.com>    <87ee5fd80m.fsf@bang-olufsen.dk>
        <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
        <87r19e5e8w.fsf@bang-olufsen.dk>
        <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
        <87v8ynbylk.fsf@bang-olufsen.dk>
        <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
        <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
In-Reply-To: <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Tue, 18 Jan 2022 01:58:39   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 214140ac-35e4-4068-58fd-08d9da6b368f
x-ms-traffictypediagnostic: DBBPR03MB7081:EE_
x-microsoft-antispam-prvs: <DBBPR03MB7081BCBC0785CE76B5CA821D83589@DBBPR03MB7081.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DwAuEV4DbkyNaYhsbfOrVvUwufP+500gcxydFZqr3fkatWVDEaUyh2x72nLc8h8ANKeBP5/lwb9kVxCxLkJqJVG4g4y54vb1B7yMCjldDWXnNXDTqmAEPCmoJjp7nuXkwj/JEMyhm80Q5QcvCuTggdhgRuVF77BxsvoxUjAbIg0GOIC/+wjgQ7Q581wxXmTenoGeIKkiCx0TeH1e5sInG9fnUTZGG+8DSmFbrgInxu2m1DVQKMO78BycV73zqM+uK4fyQHZldd4HEk/MiP6NcQ84UFRzuvaVHXJE+fetwsSYsdAV/PYRrqpr1Smg7OWQ/0JDOkOrZNdPDoTLgcl1icfVizidRgTshq4lspsdiK42Af0Mq2ao24hY/IFMrL3gHJg8mNo+yWO9heQwO1wMOxYoAw7M0TTJ3YPsb1tRedWZCDRXVzL1IyIl6z3Z5zsQRdiCr2pWGEBer5Iwn3zwL3QG6McmAE1Xg+s1Cf6CAEyMfmrqN6LJ9+i8zskAvHEVL7S8su++NHeI/1t+YCSXdGJPyLOxLRM0XqlACfyKuJ+uF9KCLa+D81adnnfJRt6TuV+BtWNidwou+/AcQ+99VwEuOUdZtf/Rai4l0gzrN56oT8DFCg9BGvu0oiSl+Z1kBhHQ4rQCfE78iiywb9EcA5yQOqNM+96wHDPWXfGWKSjWy3rvXKU2PSmhqd4hXbQ/zuIb8E3v4QnuHBPy33cagQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8976002)(36756003)(5660300002)(8936002)(8676002)(6506007)(4744005)(38100700002)(186003)(83380400001)(71200400001)(508600001)(2616005)(6486002)(66476007)(66556008)(76116006)(122000001)(66446008)(64756008)(91956017)(316002)(54906003)(66946007)(38070700005)(6512007)(26005)(86362001)(2906002)(4326008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?kaxKx08pUpTHGQx7cwlAQCklQRGF6ECdM85MUPfSxavNPFKmur59fWoy?=
 =?Windows-1252?Q?6kUF+yCbNmzuMtb6BOnnKkLS5oDhhI3x+jWTUAz1ndcQ9z3026RXaMNj?=
 =?Windows-1252?Q?bymvr8LgL/wqCHO8zuKiby/+x15xtujpBMsKPJCKztJEWiaQwhQKs7uW?=
 =?Windows-1252?Q?mZvke+9i4Govyw8RfSGW6Mcmm12gNCaAUXttCJ88TmtHfGGUBw4W/xQK?=
 =?Windows-1252?Q?HUsiQNRQhcCVsCL2zygKxBX/4Id7mAE7zYLFcV7eLRInxEI+mxnZnvxk?=
 =?Windows-1252?Q?83yw0ea/htPKxDgnE/aIjAxuoPelN5L7wNzORryC4zXxRJY2rUv5S7T7?=
 =?Windows-1252?Q?zQ0DWNzCaNHw0Z+VY3jK3UNfQ+cCFj4qXZ2CLgx5bmJxMMPfZlkj4Y6Q?=
 =?Windows-1252?Q?SPzMpzue2QL3w3WTeoiOGBn6gw6Ezl1kpexvJLcZ7gqCuTZdFz55yzU0?=
 =?Windows-1252?Q?DxMKCVdgOrjBpApdYa4IcJWt73hD6JfWjLi9HUIoJp/ix6S4bdnwVxLU?=
 =?Windows-1252?Q?pzR5qnDBxvYGc7OGsVH2p+6gCWnuksl4MbFZED8EEAtqRszw1MuKedEu?=
 =?Windows-1252?Q?06AW4ywUW05bt2WaXWOmGR5CHA0cUAofGGUqF+zGA2Sw85TVcwlp8VYj?=
 =?Windows-1252?Q?CwltxCOA+3YiZQQqtCsHNpFr55vkioxcelcMoUaZh+l4jiKa4qkxZATB?=
 =?Windows-1252?Q?mUAGuJqpWYLhSIwLw+74+yxrsarfcNioOtsYYY0diE9g5vXclb6BZH9r?=
 =?Windows-1252?Q?Bct+9rcDqrleYyhQhekiWCWW/Yq4drnAD++qXyWU2VxRQoKS7i0p0EcT?=
 =?Windows-1252?Q?CljmjkoePpV0xfPWPUaLY7v3a07p4gx2VzaEsKO3OqdLt+LhriqdXYs8?=
 =?Windows-1252?Q?e4Iw0WvMNx/PgF4M3w9rILjdAjFPgiUa4ictmzknG72YeLcJsqM63vat?=
 =?Windows-1252?Q?JiaITZP/K1u3gSmk3a5fqRf7vXJDD/voqgtIlGdf3WlIePnlsbG5bZI0?=
 =?Windows-1252?Q?Cj+0SdN69A2NuCzXXDjzzvrjhEwfYPiyEH46cJK+mZK/B3lDPPYycA6l?=
 =?Windows-1252?Q?JuyYiF5sUBuC9JCDOsyVQTO/1BkHvxbWKFosBdWTSNpNsacUznpD97Wb?=
 =?Windows-1252?Q?iqqduRtP8FhErggLXicXRGnls1EwgAMmSb6T08LvPEv+riax/AEpK/yU?=
 =?Windows-1252?Q?Sxq5203impIoCmLX4ScUB5XojPYeLIhSGLwXJi/HPHiwC7149Ljtof42?=
 =?Windows-1252?Q?ubtNL/75sXwf3QudIfDVP1mqZkzPpBcxytkodT8jL1tcQXBshCWvWkBc?=
 =?Windows-1252?Q?nStivHN0klhB6ZK6+e2KAOFDvjhy125Yi6uWFg+rPCNzvDAQunRXO4SP?=
 =?Windows-1252?Q?/I0L+hBcrsLtuaeCZVoEXhjrQBLhqVb5EnsMfSh8Dq6IA0Fvqpg3LXh+?=
 =?Windows-1252?Q?FwkljxrRl0FzkAHYBODySRiMhuIHqPq4h5nz/lwrQsQnnQsVQ5N9JUQq?=
 =?Windows-1252?Q?ixuwLkodYmKuhi+JuO8AGkTkBVy7HSHHJXeAAJiw2J5v2WPGSBUMzAX1?=
 =?Windows-1252?Q?x+r+Reh0nsFa5CeYd1CbjUyRNXfSwmdxiVItOiKXs/s8F9kdvBCStuNw?=
 =?Windows-1252?Q?JWdUKIxu7DOwoq1LnJ5Yk8LHsHicBeboYOM9GcOfinDDU+E8zmy3s8j3?=
 =?Windows-1252?Q?Hennl7Hu1tBCP4NK4IxNYA1X3JA3flK54d37ixvxUpHGCYPeMvt4ZDPX?=
 =?Windows-1252?Q?qS3wSDyEw1DS/VByeM8=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214140ac-35e4-4068-58fd-08d9da6b368f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 10:13:46.0887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YscG26+yr1Z4VbfdUEaioHeRD5coY2Pg6qj0juGjeVkG4Jrh2TWreKk/zZABSXNtVn4Aiev7qSW2kgnp+0Lsrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

>> the problem is checksum offloading on the gmac (soc-side)
>
> I suggested it might be checksum problem because I'm also affected. In
> my case, I have an mt7620a SoC connected to the rtl8367s switch. The
> OS offloads checksum to HW but the mt7620a cannot calculate the
> checksum with the (EtherType) Realtek CPU Tag in place. I'll try to
> move the CPU tag to test if the mt7620a will then digest the frame
> correctly.

You have two choices:

    enum rtl8365mb_cpu_position {
            RTL8365MB_CPU_POS_AFTER_SA =3D 0,
            RTL8365MB_CPU_POS_BEFORE_CRC =3D 1,
    };

I hardcoded it to AFTER_SA but if you find that this solves the problem
for some MACs then it might be worth adding a device tree property for
this to make it configurable. Of course remember to keep it
backward-compatible, and add a note to future travellers in the bindings
that this might solve checksum errors :-)

Kind regards,
Alvin=
