Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036CC68E94D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjBHHtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjBHHtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:49:00 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2125.outbound.protection.outlook.com [40.107.22.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFF813D58
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 23:48:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK8ua0myzaZRqHjovmmHhJhMjVqDcX78s68Zi8xHE177AXeExbc1/4iBe8f4KPfkT/AoXLvTLrZylogNMxpqe9geKVdO8FfiWURuy7iY2MjABjPPgDgNKo70j+mMX7H8/3w+u6CiRUc35dmn8W2VZdRvEcK6IbEk3pz4tkYf2axfl9rp+d2eLAgjd8TxJczQCkoizTd5NzULscih66NaoX1xDqCxQ6bMrK5W4aKUFYRO/mJsWbNt6cDiMXVsYSTUQHsHfaHmDwu+FS8vUwztFzv6zaB9kfcDXLPPulHHo63w+Tjz/sSaVYpoM70mBMiI/TSbdRA0gslaFm76LDkc+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c29Ijx3I4Zaf/10Sia6TvUg921/9PiCi6Yo4gJ099EU=;
 b=E7wgqWqF2aUPVf59Q8zeOIUkHZw7T65X3FKcnLszDjYK+hUIwaqw9yV9QClrFtx/h1AjNmXu6ST2sLxv+UHeYwbECuBLqXoAP8gZw3E5FTFvhm1y8DmZ21uEzntHLFYypPIv4cY6eT0RM41R492Qrd3A3ILMD1y8fcA5aGZX1kux/PHy5FLilHIKxvT2xEJGFPHULWnn8cEzDLeANh2vAfIVi0Yft6yKYv6NuXDFrm7kuZn1Tu9Ru03xdV1HeIsqjuVk/9FhToiEsqiFo5k5mhGHbrz9hmFzb/GG98P3EXgcAWW9M+SRWM2eNmTpu+cQsOAsFnAq43jZsuFELeI5mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c29Ijx3I4Zaf/10Sia6TvUg921/9PiCi6Yo4gJ099EU=;
 b=iPQ5lrIpWRsOGrKiGrqbiSSjKr/5MiM//MiWbqAGt9C823X2MirFZgmyPtAWSAKVzKp61RrgUsZuWh2BJJst7jKYwp4MVzsXH2f0Ua0biVvqFWzA1ZdlaIdMntAfL9HntUYhP84RAjrTal771mXKtGWQABWKZICE0dzgc/wcdko=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by DB9PR05MB9510.eurprd05.prod.outlook.com (2603:10a6:10:360::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Wed, 8 Feb
 2023 07:48:55 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%3]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 07:48:55 +0000
From:   Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com" 
        <syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>
Subject: RE: [PATCH net 1/1] tipc: fix kernel warning when sending SYN message
Thread-Topic: [PATCH net 1/1] tipc: fix kernel warning when sending SYN
 message
Thread-Index: AQHZOpJwhgefIEBxLUuhxQ8uC2Fj567EiOaAgAAWcgCAAAn3gIAABO4g
Date:   Wed, 8 Feb 2023 07:48:55 +0000
Message-ID: <DB9PR05MB9078AC021895FFB8CAF1B0A688D89@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230207012046.8683-1-tung.q.nguyen@dektech.com.au>
        <20230207213433.6d679340@kernel.org>
        <DB9PR05MB90789DC75E34ECC441DFF22188D89@DB9PR05MB9078.eurprd05.prod.outlook.com>
 <20230207233033.6b5f4882@kernel.org>
In-Reply-To: <20230207233033.6b5f4882@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|DB9PR05MB9510:EE_
x-ms-office365-filtering-correlation-id: 7767d718-dec3-46ca-d194-08db09a8ede1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xU1difFaU6Kj1GRvbkgLzF4EpeaxmcBZ9z6eKrZZBrdx5qdeZAilEZyny04qcyhMq78Wo9RRPJDwQchYtuWvXs5tpf9BdD+ZKzbELbnCEOY8EULwuqCc2BeBr5IME+4Qrei3f6JCy2Zl15foN965VX92ipSLBN0KXfbdCU0NwcjxCgAGSk5b4z89sFwBN/U8isFEHyJG5BLvgMAjA+6LgIeCaevEOaTW8PMqpuA5K37Zz+Bb8iH+e8fqQvAn0bGmv9FiZ8PjUNBUiR/Tusratm0pH5guBklN7E8i9pKvbowYO562joxswkxAqR1azIQrbeP6MZUj5K4twu+8Y/cm0sl29QazbeTpCydDhOXpw8gz6/cKout05fsQ8z6byHa8P7zRmWlFbIzPQi4TaXnk2/WWLJMYsC742mfW+M3lWr+4z1xAENoC/Uxmd+lXcIwjgNFoAFMCztrekuJL7AnSZaKbezVDOLQpETbILlyoIawQb3v25dhmBu6rSoVzrVJkjBv3GQMFYIJgBH1zAV/K+B9dA9TXPmiXbWQxUJbnK1IxZDtogocN3czzayfHAEUtNIHXJU8ekCc4hmP1SeEsLqzcIiliAQQ8oIJCpBrP4bl++TYn7yTRtMvacFMdgQt0XhdigBOTZf9n6Zz2phvb7H2l8ZtFRypZ5cU/H1jQhZKJC2fuW3mE1B21DAdNTo2IVkmzF7xuT8UEPLtxPK9PVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39850400004)(396003)(366004)(136003)(376002)(346002)(451199018)(86362001)(33656002)(6506007)(71200400001)(7696005)(478600001)(4326008)(41300700001)(8936002)(54906003)(316002)(55016003)(83380400001)(186003)(9686003)(26005)(66946007)(52536014)(8676002)(6916009)(76116006)(66476007)(66556008)(64756008)(66446008)(5660300002)(15650500001)(2906002)(38070700005)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tb/LZJv+2lWzi/I/j7/kpkcfnuvsp9UbMP4mn8l6+YeLiSzF7jalVdEvG/M7?=
 =?us-ascii?Q?LBtkKP+CZ7+WWOLN2i4Ar02UVGMdscMrnGYJBZGPamIUCn8y3Y/ZLGg7FX3R?=
 =?us-ascii?Q?4qQUlxQQF1HsxMZDu2wlmYlenIZneIdOOX78sEPlqbbdYVcuwUrIxxekB5yB?=
 =?us-ascii?Q?xB69LV2l8WW0eioFXThrOB8cPJY3A81IStpt2I8tlYAKOomOP+jRy4p5HnCB?=
 =?us-ascii?Q?MU/+Ys5wxKR7gq+n/4qObKB7Fb+L4wUPsqjG/XOR6DFQCtTeo7fZwSQnUvFN?=
 =?us-ascii?Q?cmXmxzcJ9a9iMdOjMcMyrajU9lARErsiGrxLY7IznVGJZp3Ku4YDzLNYV57M?=
 =?us-ascii?Q?P+2Joj2FjCDymHwcC8xeJAOamcmw1eNdykq/0WemDu9O0TV7Qbdgggy5yIlj?=
 =?us-ascii?Q?HycTZcideoY581OgZtzsh7R19sZXoGjdiB/Lzj2/IkdUse8jjpZmlhfwsOUA?=
 =?us-ascii?Q?z92K8liGKQ3skPIW8LwSjuYMovep4ZvwQgQYzZK/ih1q7Ti4qR1Fv3VmwgFu?=
 =?us-ascii?Q?h/DRJ7SIKAY9GoTKvgUGUXVNiDkbfm2VPvZx51nZymcsHmRwar9inedjw+d/?=
 =?us-ascii?Q?ZGhZmQKWetANL5oJqnv4tlzgY5lE/uasUIuxfsGzK51BEdLgjBb+HlxgNT3z?=
 =?us-ascii?Q?0sMhWiOWTdNLpboSx2jQvnK0MWeFCLoUp68P7/AqM0lw27zXhyWh2uFq9tRr?=
 =?us-ascii?Q?g8u2+6Yge+vf/i/5fYScnM4NKJsbK3Kra5MB4MGvQR4AL4Nc7sScE6JOzcHr?=
 =?us-ascii?Q?S3ijU0yIGHBy5nO2nhOVkMkBiSZ+ppADLE1cGbhEaWXA/3kE4Kj3lj7Mlstx?=
 =?us-ascii?Q?gsOoPb5NwpdtXVKt9rTu49o/81ZMJIut3ZxACgnrUVLJdY/y/Jb7WCzY6zRC?=
 =?us-ascii?Q?5mj5gC8mksXEQsspjGDfjocAxXuRnob0ikPBy7O7vBZfxCBltNSA0rgLE2FD?=
 =?us-ascii?Q?F7AUud0CafiDGqoUxIAY5BDI9c3/tRZpgy3u7esOG4H50gGaKVSEsuYJGfNy?=
 =?us-ascii?Q?8E+LZlrP+yH0ujpTjNhYAiSyUmMvHJBMCOQ1nirWkDDcyzQsujGzM7T3Y1k3?=
 =?us-ascii?Q?yGzap47IC9mFTI3jl2PuU6zhqq/t+KoScHmdoAPUuPBpt1pNuUoRPygErsZQ?=
 =?us-ascii?Q?1fom2/McbbBRsSkDBKw6cMW32N2D3t4a9Vtu67+7DLdirYN4ITNHX4mHk44M?=
 =?us-ascii?Q?LKwt2WSE2IizZHKWXmXWOvcpAAv41Hsw0igpL9isByJNLn1DH4QF42NRhGVX?=
 =?us-ascii?Q?xRw7mE9sKWl+PD07Po17TeikfuXUWm13pCXkl739YViJieGV6QN3AXsISxPZ?=
 =?us-ascii?Q?HjkpxZmU4oXnqwbncPVxcTon1FfOea7L9B1iUgD88kpqN6SaLoV0WeHSqt6D?=
 =?us-ascii?Q?o9h8Ga+9wXT4trVAz2lGI6AvKm0hUU5R6DkgA3M3RxQi0sF+76cGn+wqk/TS?=
 =?us-ascii?Q?ra4J18kQFK9NB3DdKuuz7gW9GteN13gRN2xVfSFafjTsgG40HAw7Y8jWOukX?=
 =?us-ascii?Q?vgA0Hk7Hi2ztAV/pIcJHYeHl2l2rHDxQVUDcuLaJBNM8uqdqlsxDawIvYxRB?=
 =?us-ascii?Q?oW7HZGwOY1OFlupwao3E5xZ9Cj7veXtdf/eQa5jZ54bSAx0GYc931T1TGTe8?=
 =?us-ascii?Q?Pw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7767d718-dec3-46ca-d194-08db09a8ede1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 07:48:55.3056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yUxNaYHH3pYo2uFnri5+wfGSMDvfMmaQm+7uOwcxsQ9u0vUXJaz9Zovq2StuMqjr6QE5WC5gaZLymUylqyhEyaCgflb6XqjyivvCUQJ9jMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB9510
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Wednesday, February 8, 2023 2:31 PM
>To: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
>Cc: netdev@vger.kernel.org; davem@davemloft.net; edumazet@google.com; pabe=
ni@redhat.com; jmaloy@redhat.com;
>ying.xue@windriver.com; viro@zeniv.linux.org.uk; syzbot+d43608d061e8847ec9=
f3@syzkaller.appspotmail.com"
><syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>
>Subject: Re: [PATCH net 1/1] tipc: fix kernel warning when sending SYN mes=
sage
>
>On Wed, 8 Feb 2023 06:56:26 +0000 Tung Quang Nguyen wrote:
>> >> It is because commit a41dad905e5a ("iov_iter: saner checks for attemp=
t
>> >> to copy to/from iterator") has introduced sanity check for copying
>> >> from/to iov iterator. Lacking of copy direction from the iterator
>> >> viewpoint would lead to kernel stack trace like above.
>> >
>> >How far does the bug itself date, tho?
>> This issue appeared since the introduction of commit a41dad905e5a in Dec=
ember 2022.
>
>I presume that commit a41dad905e5a just added a warning to catch
>abuses. Unless this is a false positive the bug itself must have
>been introduced earlier.
Yes, since 2014. I added in v2
>
>> >Can we get a Fixes tag?
>> I will add a Fixes tag in v2.
>
>Thanks!
