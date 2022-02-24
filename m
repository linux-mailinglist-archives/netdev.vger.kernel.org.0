Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD834C2E72
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiBXOaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbiBXOaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:30:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E2A17C41F;
        Thu, 24 Feb 2022 06:29:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ6HKUUfIVx45Xw/MKVEBLvmoplWfqZpX/ZfTJ+QHqDKL2mGw2cE9oo3i9Grl/MnoLSjh0D1g8ECUDKEhr0fJeg56bKshoFDIzCXUjgWzJ+KSXZ5BXwDc2X2ibBnV/TyaH42DYGI6lDtb+cDJXxIsBfi26S6AuQ/sxJSQPvBU6cwRun44mxLi6NrHnMEyjicNiHMRNK5Q/fD27Pw7c7gbfCkMDlLEDYfO9OE1BmLBF8wljGLzkTIwaWiaM4iNwff4p8xsYhyiKGQI3erywZGe9IwuUuwoq1umtelsoKbP2rvoHsqfP8h8Athj4c/W/7kw/PGvqdcnMy9YskW4Xd/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYw6RgkwDH7SaDUTaZVDmGBDnPBPi734xu9BrJ1/Egg=;
 b=YG4dSXd1p0/CKaKBGxkOXeTBAF8xESevzTHAt5aS3O6cmOoPXqdQlIXko0Ig+j88oVBvri09FqY7EJc0hYhE+S39AMiihOvp5kkpxNXRYhk6BojnwJ51FZcNO3fJTVXGuF3CUEmuxVUhaKnGCeTJmwtcAfaznCKAVsSy22+oxPw05LTBfrw0iN1kt4HUy95ZV14XnDUTORWQF5Il8qFhqvC82h8QchbfFtel/UY7D6lKPYTmRdztO8qSW1397tG9Zif+8qctIHNviEUlum+IlsiwczAUhZ0peDewtjuzo+jYbWvxwb1fjgB7RrjB3iEtzMmJ7Jnrvk+Ne+UGJAcV8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYw6RgkwDH7SaDUTaZVDmGBDnPBPi734xu9BrJ1/Egg=;
 b=NT6omVUco7WncfMUyOI/SVilXL6a9U5fWd6BpRJJpFOgQMqO/d8WGhFpgbC9nILRR1IEPW1GzTSTDgeuVRLuJLIAeX8jNeMI5praIDYeylq8DImbYneTVA+dNDF85T3SvdYmjhp1ABVBDn9HAhOCDZo0Ewc5OsDiEsDJeLNfSoFgg9uvrDZDID/6pvSE848quBgQvvbUHWqAjNVTJtM1hKjg6zrhTE8vosJE/x0Y/za7WtKaWxBjZ6JhEjrFuUqQqEH8e1yYXzySNhr91ww3WD7ReR+54IRz4xxb1jM8AGHzE2Hz3ZoHNvsAzgAWgXK6vVinBUirFhnKHYe+vdFnmQ==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MWHPR12MB1343.namprd12.prod.outlook.com (2603:10b6:300:7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 14:29:34 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9b8:7073:5693:8d06]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9b8:7073:5693:8d06%5]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 14:29:34 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        John Fastabend <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: RE: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
Thread-Topic: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
Thread-Index: AQHYETUMIeFJsb6vVUS8oyTXGAShkqxzXzkAgAnvjYCAAF1RgIAAAgiAgAKb04CAAnekgIAAvXQAgBreGQD//+3oAIAEpQ2A
Date:   Thu, 24 Feb 2022 14:29:34 +0000
Message-ID: <DM4PR12MB51507EE4B11ECCEA7D689320DC3D9@DM4PR12MB5150.namprd12.prod.outlook.com>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
 <61efacc6980f4_274ca2083e@john.notmuch>
 <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
 <61f850bdf1b23_8597208f8@john.notmuch> <61f852711e15a_92e0208ac@john.notmuch>
 <9cef58de-1f84-5988-92f8-fcdd3c61f689@nvidia.com>
 <61fc9483dfbe7_1d27c208e7@john.notmuch> <87a6f6bu6n.fsf@toke.dk>
 <6b6ce8a2-e409-0297-cb29-fe9493c9d637@nvidia.com>
 <20220221152142.cm6fiag27g74bk6h@apollo.legion>
In-Reply-To: <20220221152142.cm6fiag27g74bk6h@apollo.legion>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61e74401-d056-475d-6236-08d9f7a2142e
x-ms-traffictypediagnostic: MWHPR12MB1343:EE_
x-microsoft-antispam-prvs: <MWHPR12MB134303BB86CF97F0C3B9F877DC3D9@MWHPR12MB1343.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZe43fqwMsM6V+PpZGNNdp345O/FYXe0tDQrYunZf9ZWNL+DQmCOUCO2eJofvgUI7oJEkiXe4OWwx4mO9PRiLt+tw3rYlipbtLiunZOxnAbuKAF9G0dlxQGZQ9JkAi0gG6AwmzUCsw1/PAaQZkwFTz12DKwv9Lpn2O25r19+vYlVgSzCzqlNK+jJCtQkbvTKi1reDG93o5zJ/7ubWJuuqk2B+E71aRGHwNhM8XP6bH45kakyzV1BifBrZhte8ldQ2AtVJeY91iQytd6zAtcxBsSpDRz8/sN+RIvBjjiWQTlgBWVrIOkq9U96PgxFQND5cTvPgwwPkHTgd8ZKmKfTrreOmvRxhbjQIh8RofJfNDyPOPP9KP0FRuPnUi3bs1TtAj2RV8P7Bobi9SmwT+jSXGqUeY4ExVdbTTagpQIjRhjbViUAAkoo6EK54b8LQlAI51hG34gbPwnPgEOYvXSYY8cnxDLiAM7F6dQWfMDjeBjqdEEHfmGqVVxy/gzwS1xtmQZtrPgu4gCQ4Af5zVpydXS+cDGDri8VFBv1UaI7DZoTavmkvt5t1ZTPVf2vKePc3BslrTj6vI03OKMhkkgdem1dS3/WCjJuDpLxRY2H/WbSwvXs2QhTuBfJDo2p2yqcK0/EzVzR6JrKzTjKR3/+khgqv5c7ysBYMLRCcXV+UgL4YMU3LQ6R4uO3Q1xiqtii3jL3EUyZwL3pTimnF0CSCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(122000001)(508600001)(83380400001)(66574015)(33656002)(2906002)(6506007)(9686003)(7696005)(53546011)(8936002)(52536014)(54906003)(30864003)(86362001)(38070700005)(38100700002)(316002)(186003)(26005)(76116006)(8676002)(4326008)(7416002)(6916009)(66556008)(5660300002)(64756008)(66946007)(66476007)(66446008)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?n/t1OXKImtioBJtKlf998CB20PoxFJnE2Ub3sKZE41/ddQqZOxbpsuM4VE?=
 =?iso-8859-1?Q?FDifxB+B3q13jJAfhM6+TWIHR0t1sOCagzySmNSV6D1tltooo/8mJwSBsF?=
 =?iso-8859-1?Q?LI999E64K/aDxeqtLJlX1aFO9LKfaWuuWPQEqMKsiPKuEPQcdA7XtiUkKx?=
 =?iso-8859-1?Q?wwHIEQ854KPx3IY0p42oodJtxovGYK8p7/9y7gwGWeyw7LDBJLjgoxBTbl?=
 =?iso-8859-1?Q?D9L0SAOz0Yeg8FMRUa+bj+a5fcOqWVKbHDs20T+NOHKuGTypup7WxNIzmG?=
 =?iso-8859-1?Q?XwmsZkeO+ydXJRQ4dZ+vGTBDgxOinDK6k2wR5er/GuMajos13QHj5nJmsq?=
 =?iso-8859-1?Q?iq5Fk3i3qdzTIKG0EcvYW9bahWJBH8WGwp2V7wpd+ndM2m5Zbr8inNXkZ1?=
 =?iso-8859-1?Q?OJYQ3Cq1nq6TuA/aeDwRerBSVPlh+0xdHH9uMLyuoAF3et1JJRUwi29t3L?=
 =?iso-8859-1?Q?8t/S790Vj/8nF/Q3O0cfYDJcwnOPji1L5Khw8dA8FKIw9TQSSHnnyVRnlO?=
 =?iso-8859-1?Q?U02ppsK4+lC3qF/QJMvPm4M6FlR3N+ODG14e4oImU35tnbtzEk/H/dQrey?=
 =?iso-8859-1?Q?sh1vipcCHGB+LerY4nBqEK5T0TczWdh3wz9fZnE06heeMW8sgb++WFIXYh?=
 =?iso-8859-1?Q?2fzphq+Q7k7zRAg8vh3J89byd4VgE5Wng16HjMmnbSzaEFsFkTajF7iFFa?=
 =?iso-8859-1?Q?FEcFBtpJmWFK4wGXBENhFRmS2zpm6uPACpi9kTly2U2bYGpfW0yHyPmejF?=
 =?iso-8859-1?Q?uffaJYfHvPAuGbEqnOt6PFt8fXC7mRhTeRO2taFKnRl+2IbNbSjs6S5G3G?=
 =?iso-8859-1?Q?nAjbjxJ/t/xnjlSSCENDPx0XJ1eaHJDmvoiXXnG7fR0W8y65mwsBgozmtJ?=
 =?iso-8859-1?Q?/hgZEj2aZQiktbYclfVxlH+3OyLT61dwhHH/YGNR/FOwkrQ6DI3Ly4iSPF?=
 =?iso-8859-1?Q?GQ8DxVnZf223lp431A9K7bqOsMmyFTREe3kpdACRwgihBMZwZMvcc8x7zV?=
 =?iso-8859-1?Q?CkJDmMiA3IUbYqKldA7OufsN8FfikcM6zCL+uFPYRY4OSQB1l5DXsu2i4d?=
 =?iso-8859-1?Q?nZqvrK72up9DuD8qz+x25kLXSTF0ykpF5JPx5v5AaeiL1p7xv/ckQfr5ff?=
 =?iso-8859-1?Q?6e2wgzxeEsiMHLni5QfFuIogF+z1vp258GVyK4iRZRqbxoJnedSaj43RIN?=
 =?iso-8859-1?Q?DD8EyBMUWYnzzQhj/TXcASmfGCMaRDWvpbohaXZgtazIkazWyYEH0tlt8E?=
 =?iso-8859-1?Q?2gtzBMId2BJ9BS0tHsg4QTlcFa1KihLDEel/eWtbCke9tBs6KG/W3eyEor?=
 =?iso-8859-1?Q?T7r8uSSsgu5DHJvIKTEmU1u+goX+la6Q92hbc64I/AeMWakF8K1C/LGzYB?=
 =?iso-8859-1?Q?HkLNxyQ5j9U5veRtzmpNTzpD5llhTNMF69Et/RSYR9zke3Is2hDcdMRpjx?=
 =?iso-8859-1?Q?atcp5+ramzZaSvsw5vglCFA8DMRAKMlwoIxQXwz1u3zCLEo6t5mamEnTpB?=
 =?iso-8859-1?Q?cdtbhRkkqnl21mgnrMR3k4TDVCQ5Lroy+xXJNLrjdPG7j8xPJzIL7nS5qE?=
 =?iso-8859-1?Q?0PDV/UXCycwkaKBHyJseECh/QRkBPinj5gOexLs0B8JKKL9EcyoDxqiLTt?=
 =?iso-8859-1?Q?u8cF45NBKSUJv5M/gvfW8XCUIIyzeMmpo6c58jCKgAM6GDwOB/Gaelsc9y?=
 =?iso-8859-1?Q?vxilUCN+NXcZKh3Gbjg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e74401-d056-475d-6236-08d9f7a2142e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2022 14:29:34.3576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NdFk81KxhUz01Rg0ziaWcMNXF2fcMNw3KSXQl37HkGVeo1w5/627rGvkjt2uwYzWVfu0HQWnYj8PDqjeY4o87w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1343
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Sent: 21 February, 2022 17:22
> To: Maxim Mikityanskiy <maximmi@nvidia.com>
> Cc: Toke H=F8iland-J=F8rgensen <toke@toke.dk>; John Fastabend
> <john.fastabend@gmail.com>; bpf@vger.kernel.org; Alexei Starovoitov
> <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Andrii Nakryiko
> <andrii@kernel.org>; netdev@vger.kernel.org; Tariq Toukan
> <tariqt@nvidia.com>; Martin KaFai Lau <kafai@fb.com>; Song Liu
> <songliubraving@fb.com>; Yonghong Song <yhs@fb.com>; KP Singh
> <kpsingh@kernel.org>; David S. Miller <davem@davemloft.net>; Jakub Kicins=
ki
> <kuba@kernel.org>; Petar Penkov <ppenkov@google.com>; Lorenz Bauer
> <lmb@cloudflare.com>; Eric Dumazet <edumazet@google.com>; Hideaki YOSHIFU=
JI
> <yoshfuji@linux-ipv6.org>; David Ahern <dsahern@kernel.org>; Shuah Khan
> <shuah@kernel.org>; Jesper Dangaard Brouer <hawk@kernel.org>; Nathan
> Chancellor <nathan@kernel.org>; Nick Desaulniers <ndesaulniers@google.com=
>;
> Joe Stringer <joe@cilium.io>; Florent Revest <revest@chromium.org>; linux=
-
> kselftest@vger.kernel.org; Florian Westphal <fw@strlen.de>
> Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check =
SYN
> cookies in XDP
>=20
> On Mon, Feb 21, 2022 at 07:56:28PM IST, Maxim Mikityanskiy wrote:
> > On 2022-02-04 16:08, Toke H=F8iland-J=F8rgensen wrote:
> > > John Fastabend <john.fastabend@gmail.com> writes:
> > >
> > > > Maxim Mikityanskiy wrote:
> > > > > On 2022-01-31 23:19, John Fastabend wrote:
> > > > > > John Fastabend wrote:
> > > > > > > Maxim Mikityanskiy wrote:
> > > > > > > > On 2022-01-25 09:54, John Fastabend wrote:
> > > > > > > > > Maxim Mikityanskiy wrote:
> > > > > > > > > > The new helpers bpf_tcp_raw_{gen,check}_syncookie allow=
 an
> XDP program
> > > > > > > > > > to generate SYN cookies in response to TCP SYN packets =
and
> to check
> > > > > > > > > > those cookies upon receiving the first ACK packet (the
> final packet of
> > > > > > > > > > the TCP handshake).
> > > > > > > > > >
> > > > > > > > > > Unlike bpf_tcp_{gen,check}_syncookie these new helpers
> don't need a
> > > > > > > > > > listening socket on the local machine, which allows to =
use
> them together
> > > > > > > > > > with synproxy to accelerate SYN cookie generation.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > > > > > > > > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > > > > > > > > > ---
> > > > > > > > >
> > > > > > > > > [...]
> > > > > > > > >
> > > > > > > > > > +
> > > > > > > > > > +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u=
32,
> iph_len,
> > > > > > > > > > +	   struct tcphdr *, th, u32, th_len)
> > > > > > > > > > +{
> > > > > > > > > > +#ifdef CONFIG_SYN_COOKIES
> > > > > > > > > > +	u32 cookie;
> > > > > > > > > > +	int ret;
> > > > > > > > > > +
> > > > > > > > > > +	if (unlikely(th_len < sizeof(*th)))
> > > > > > > > > > +		return -EINVAL;
> > > > > > > > > > +
> > > > > > > > > > +	if (!th->ack || th->rst || th->syn)
> > > > > > > > > > +		return -EINVAL;
> > > > > > > > > > +
> > > > > > > > > > +	if (unlikely(iph_len < sizeof(struct iphdr)))
> > > > > > > > > > +		return -EINVAL;
> > > > > > > > > > +
> > > > > > > > > > +	cookie =3D ntohl(th->ack_seq) - 1;
> > > > > > > > > > +
> > > > > > > > > > +	/* Both struct iphdr and struct ipv6hdr have the
> version field at the
> > > > > > > > > > +	 * same offset so we can cast to the shorter header
> (struct iphdr).
> > > > > > > > > > +	 */
> > > > > > > > > > +	switch (((struct iphdr *)iph)->version) {
> > > > > > > > > > +	case 4:
> > > > > > > > >
> > > > > > > > > Did you consider just exposing __cookie_v4_check() and
> __cookie_v6_check()?
> > > > > > > >
> > > > > > > > No, I didn't, I just implemented it consistently with
> > > > > > > > bpf_tcp_check_syncookie, but let's consider it.
> > > > > > > >
> > > > > > > > I can't just pass a pointer from BPF without passing the si=
ze,
> so I
> > > > > > > > would need some wrappers around __cookie_v{4,6}_check anywa=
y.
> The checks
> > > > > > > > for th_len and iph_len would have to stay in the helpers. T=
he
> check for
> > > > > > > > TCP flags (ACK, !RST, !SYN) could be either in the helper o=
r
> in BPF. The
> > > > > > > > switch would obviously be gone.
> > > > > > >
> > > > > > > I'm not sure you would need the len checks in helper, they
> provide
> > > > > > > some guarantees I guess, but the void * is just memory I don'=
t
> see
> > > > > > > any checks on its size. It could be the last byte of a value =
for
> > > > > > > example?
> > > > >
> > > > > The verifier makes sure that the packet pointer and the size come
> > > > > together in function parameters (see check_arg_pair_ok). It also
> makes
> > > > > sure that the memory region defined by these two parameters is
> valid,
> > > > > i.e. in our case it belongs to packet data.
> > > > >
> > > > > Now that the helper got a valid memory region, its length is stil=
l
> > > > > arbitrary. The helper has to check it's big enough to contain a T=
CP
> > > > > header, before trying to access its fields. Hence the checks in t=
he
> helper.
> > > > >
> > > > > > I suspect we need to add verifier checks here anyways to ensure=
 we
> don't
> > > > > > walk off the end of a value unless something else is ensuring t=
he
> iph
> > > > > > is inside a valid memory block.
> > > > >
> > > > > The verifier ensures that the [iph; iph+iph_len) is valid memory,
> but
> > > > > the helper still has to check that struct iphdr fits into this
> region.
> > > > > Otherwise iph_len could be too small, and the helper would access
> memory
> > > > > outside of the valid region.
> > > >
> > > > Thanks for the details this all makes sense. See response to
> > > > other mail about adding new types. Replied to the wrong email
> > > > but I think the context is not lost.
> > >
> > > Keeping my reply here in an attempt to de-fork :)
> > >
> > > > > > > >
> > > > > > > > The bottom line is that it would be the same code, but with=
out
> the
> > > > > > > > switch, and repeated twice. What benefit do you see in this
> approach?
> > > > > > >
> > > > > > > The only benefit would be to shave some instructions off the
> program.
> > > > > > > XDP is about performance so I figure we shouldn't be adding
> arbitrary
> > > > > > > stuff here. OTOH you're already jumping into a helper so it
> might
> > > > > > > not matter at all.
> > > > > > >
> > > > > > > >    From my side, I only see the ability to drop one branch =
at
> the expense
> > > > > > > > of duplicating the code above the switch (th_len and iph_le=
n
> checks).
> > > > > > >
> > > > > > > Just not sure you need the checks either, can you just assume
> the user
> > > > > > > gives good data?
> > > > >
> > > > > No, since the BPF program would be able to trick the kernel into
> reading
> > > > > from an invalid location (see the explanation above).
> > > > >
> > > > > > > >
> > > > > > > > > My code at least has already run the code above before it
> would ever call
> > > > > > > > > this helper so all the other bits are duplicate.
> > > > > > > >
> > > > > > > > Sorry, I didn't quite understand this part. What "your code=
"
> are you
> > > > > > > > referring to?
> > > > > > >
> > > > > > > Just that the XDP code I maintain has a if ipv4 {...} else
> ipv6{...}
> > > > > > > structure
> > > > >
> > > > > Same for my code (see the last patch in the series).
> > > > >
> > > > > Splitting into two helpers would allow to drop the extra switch i=
n
> the
> > > > > helper, however:
> > > > >
> > > > > 1. The code will be duplicated for the checks.
> > > >
> > > > See response wrt PTR_TO_IP, PTR_TO_TCP types.
> > >
> > > So about that (quoting some context from your other email):
> > >
> > > > We could have some new mem types, PTR_TO_IPV4, PTR_TO_IPv6, and
> PTR_TO_TCP.
> > > > Then we simplify the helper signatures to just,
> > > >
> > > >    bpf_tcp_raw_check_syncookie_v4(iph, tcph);
> > > >    bpf_tcp_raw_check_syncookie_v6(iph, tcph);
> > > >
> > > > And the verifier "knows" what a v4/v6 header is and does the mem
> > > > check at verification time instead of run time.
> > >
> > > I think this could probably be achieved with PTR_TO_BTF arguments to =
the
> > > helper (if we define appropriate struct types that the program can us=
e
> > > for each header type)?
> >
> > I get the following error when I try to pass the headers from packet da=
ta
> to
> > a helper that accepts ARG_PTR_TO_BTF_ID:
> >
> > ; value =3D bpf_tcp_raw_gen_syncookie_ipv4(hdr->ipv4, hdr->tcp,
> > 297: (79) r1 =3D *(u64 *)(r10 -80)      ; R1_w=3Dpkt(id=3D0,off=3D14,r=
=3D74,imm=3D0)
> > R10=3Dfp0
> > 298: (79) r2 =3D *(u64 *)(r10 -72)      ;
> > R2_w=3Dpkt(id=3D5,off=3D14,r=3D74,umax_value=3D60,var_off=3D(0x0; 0x3c)=
) R10=3Dfp0
> > 299: (bc) w3 =3D w9                     ;
> > R3_w=3DinvP(id=3D0,umin_value=3D20,umax_value=3D60,var_off=3D(0x0; 0x3c=
))
> > R9=3DinvP(id=3D0,umin_value=3D20,umax_value=3D60,var_off=3D(0x0; 0x3c))
> > 300: (85) call bpf_tcp_raw_gen_syncookie_ipv4#192
> > R1 type=3Dpkt expected=3Dptr_
> > processed 317 insns (limit 1000000) max_states_per_insn 0 total_states =
23
> > peak_states 23 mark_read 12
> > -- END PROG LOAD LOG --
> >
> > It looks like the verifier doesn't currently support such type conversi=
on.
> > Could you give any clue what is needed to add this support? Is it enoug=
h
> to
> > extend compatible_reg_types, or should more checks be added anywhere?
> >
>=20
> I think what he meant was getting the size hint from the function prototy=
pe.
> In
> case of kfunc we do it by resolving type size from BTF, for the PTR_TO_ME=
M
> case
> when a size argument is missing. For helper, you can add a field to indic=
ate
> the
> constant size hint in the bpf_func_proto, and then in check_func_arg
> directly do
> the equivalent check_helper_mem_access for arg_type_is_mem_ptr block if s=
uch
> a
> hint is set, instead of delaying it till check_mem_size_reg call when the
> next
> arg_type_is_mem_size block is executed.
>=20
> Then you can have two helpers with same argument types but different size
> hint
> values for the header argument, so you wouldn't need an extra mem size
> parameter.
>=20
> You may also want to disallow setting both the size hint and next argumen=
t
> as
> ARG_CONST_SIZE.

Thanks, I implemented your suggestion as a new feature of the verifier,
and it works.

I'm ready to respin the series, I've split my new helpers, but splitting
the existing helpers won't be part of resubmission, because it is out of
scope of changes I intended to push. It can be added later as an
improvement, though.

> > Alternatively, I can revert to ARG_PTR_TO_MEM and do size checks in
> runtime
> > in the helper.
> >
> > [...]
>=20
> --
> Kartikeya
