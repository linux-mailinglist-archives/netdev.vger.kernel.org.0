Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D080A5323C1
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbiEXHLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiEXHK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:10:58 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE96939AB
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653376255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TAGFP9/HFXubeeav8O0YNo9svlg8MO+fWwwxxvYrjHc=;
        b=BfGCk4zWQcs6r4gH8N8AfccJNxelAnDS28AlHSCGASa+t0MeB3HYOl3AQfej5ftknNl6ie
        BTkweWa5uVanydMA9Yubp3zxUoItY2NFs1BouUqhCBHn4IaQ6uup2v+nam3CpW2xMu9HQy
        4ULhz6tcc7GawsN78BAHjdFJdZm2W0w=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2055.outbound.protection.outlook.com [104.47.5.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-29-NYv1RREVNUmHgz3Uk1zDww-1; Tue, 24 May 2022 09:10:52 +0200
X-MC-Unique: NYv1RREVNUmHgz3Uk1zDww-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apmRTFtyLIaQ1UNkxJav7RHfW/gPnusk5HL43JQypicTQkg9j40/i6XvIDLtscYeemnQ+FmXpK/zjOcQwVXyR15YWeQAhSsWmi9CtPIpQzkERDqspxodTBmTfy9xFUGqB0a+7fuTZrQiR0RUGTVd+KMGz3Nyk8snmUtcNm/9l4JwazRHl0Uuf0AUysrAoP3vIN8KxStstCepXm4wlqbLxdlRU/8xA8PByuIQZ49dfSxR8aBAsTE4w3A1Uyg00F3hGWgInzddYsxckBSICKYds5VcfEsqwHYr53jm7E3GEE2SvIJfg7+s/NEdjjZM42m3AQJ4KhuIT9N5fj+JrsAlHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8MO+lIxdCe3+XczJ2KKW88YGXKbCQ03WH6b1GtXWas=;
 b=boXEeuJOhBl5RTFw3iO5cIEqZuVBWh3Jl41RqwKF8bjhsjYlgKxD1A871LAGj6scdAtFVt7d0ap5RIytrohUBrPxgVN6S5ht9ET7F2yRqprpLMpYQtE8d2f/1DHkaHqyipZ/KRrnejNBGChF3OsnQaYd0oiCDHi1wmBNakKCqFC/Perh7/eBuaSDx2OdA8wogj4k+wa+aAagbBRftGLFSeRotgmn/anKPZ0cpSWILtJ5RrJButQarB0Tf2YZNGdDvoAi4SktR1IB/nF/2TDbsMzeVi5GxhjNsWynAH9jVjn32n+gCLQCUzH2QQkN5p+Cp6b+yU5vJUpGBgTP19+GXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by VI1PR0402MB2703.eurprd04.prod.outlook.com (2603:10a6:800:ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 07:10:50 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 07:10:50 +0000
Date:   Tue, 24 May 2022 15:10:39 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Yonghong Song <yhs@fb.com>
CC:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH bpf-next 2/4] bpf: verifier: explain opcode check in
 check_ld_imm()
Message-ID: <YoyEbYGIoiULPQEk@syu-laptop>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
 <20220520113728.12708-3-shung-hsi.yu@suse.com>
 <f9511485-cda4-4e5e-fe1f-60ffe57e27d1@fb.com>
 <0cf50c32-ab67-ef23-7b84-ef1d4e007c33@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <0cf50c32-ab67-ef23-7b84-ef1d4e007c33@fb.com>
X-ClientProxiedBy: HK0PR03CA0111.apcprd03.prod.outlook.com
 (2603:1096:203:b0::27) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e213bfc0-23e9-4d46-57eb-08da3d548878
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2703:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2703C345B1779914F34F3B40BFD79@VI1PR0402MB2703.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDGogBOxNGOu98UGBaPGxQWv4BXPCR7bxdOcukF7Fm5aOYdemadqGCzefqWOy1nIRGY1/IyU4o614vYoYKDVHdDug574e4GqaIOwwgiJnswLQyp6g8t3CxSBOv9gfxiE8XvlALAoTc87nu5731ZlSZeqO15+oPNW5iGkyQAQ3+blzM0Bh7pD6eeKKywEc0JQc0iq69RnZg2xhCAUTfKVVtQjr2Fx7AouRwVQ92Alrd+c8kC/BArsHp/IAQLVwNXWiEaJu0q+JfaeqdUel0wqluNLG5ZyP3LYmJ+a002s6qiOUUaRCAxa+bQ3raZvKlTXJYQwPIk2TQBmnc+yqTe0C8j8oOcEtEIAey6+/u/FahHI9zyk0M9D4Wr2VY0Mu0bXSfzwUDlwYydGjCT8e3NPVN+JLA0N/01k7oBfIr41NvKbePLKnrYikpIeupWLN+2HvOKpfjxJ2PRItx5xoU8NHpPP4gchuNZZuhREb8sckfV2mjTYeTIKUPGnmc8tJMINznwX8e98numqPe9UrmQyhhqF+K0W6E2vXFZ6yFl+Bh81jd0dnSGbO9qmBhl/9CreOomxHy4df9fDmgAKLX+sx/CslwiGlvrJ4zGgz8kzh7YzJ8iVCflPfVRjXwTJ2Ch2jy9os8izc/epb5HPldsbbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(86362001)(4326008)(8676002)(6666004)(6506007)(53546011)(2906002)(6486002)(5660300002)(8936002)(508600001)(26005)(9686003)(83380400001)(7416002)(6512007)(38100700002)(6916009)(54906003)(186003)(66556008)(66476007)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oP0mAy3DDSX4CCiyd8qBD4RIIt7NTmOt1PgvDyAnb/7DvNUzM7AUmEtXfhOb?=
 =?us-ascii?Q?yxzAkdAo/kOjPv0vuCR/Ke9YY/JDY8FEecUz4GdGD7phidwPb9yP22sieYKW?=
 =?us-ascii?Q?y/d8mUV95Sfcb4Ei9NXP6DRyH01uWoDM46Z+/czt+/la2BGpYlZdOUxQW9n3?=
 =?us-ascii?Q?yKu/LIxlyCui3MnC1UaTVazxSWIlHI6WxZ7XASxd/s5RuHnLgkVxfzrUIwQQ?=
 =?us-ascii?Q?MTC0rQ5bdJiKlrrgWlgP5JzYNnYzRCR5ECfNsH8DSO4aA28bLS5VyWALUva6?=
 =?us-ascii?Q?6w8kb/6WWHqsgr2z4q0KAC0tDehYJDlGezA87cMP6hxw6Ggc793cvFTQK/Ch?=
 =?us-ascii?Q?d0Lfzhnqg4rcNq9EPeqou3UN+jpC+PjMF/Jz2JPERiv7RL7qanUGg3umuSpv?=
 =?us-ascii?Q?E0MHw2PYmMMQU4jDGPFMeCnGUIxwRmvv/gw0zHFnIYqcj+oEZQlHeImCZwd/?=
 =?us-ascii?Q?WT41wbaVADxdUdO024l2jXb5p0Yp3Fs5sLtl7wo8+IMuEha3GruM81tWcQIA?=
 =?us-ascii?Q?ggac+9xMm0shE02KV5hj3omG6lPthTdFmKbcquwrtW3buSTcrcxdt8flWdYf?=
 =?us-ascii?Q?gCNoL8ydPuX6Dof/UMnEu4T1y03q41MSIpL4AGAEwTQuboHwfR0eihW62Xqw?=
 =?us-ascii?Q?zb5Fi3/1pIVgqha3/p8FSnv0oN/IFB/0ygCRgY0d3XEZDNGGWgBk3ZxS9hNR?=
 =?us-ascii?Q?y4M7h0KBuXhn8+zG2SacpMxjH20LQSQTIkLjkblfAp/InK+c4XByePf1ux/a?=
 =?us-ascii?Q?wMTE22VrrvpLixGu7J32qyX3OLgx9xoVVZ0JtyJ8zsb4KOpQe2lRhBUmVLEV?=
 =?us-ascii?Q?Lw7vJXVvp71HDNIOW4tTPqM4zbnvwDE0YO5pTy3oHWx9U03HazBABrknmLwZ?=
 =?us-ascii?Q?9015PFvURVWYhRkgZ9gNXX4ndyLshJZfhHFCiKHbkFMzWdgXtx5H3wQc43tv?=
 =?us-ascii?Q?DxA82yQnBqPmWW1z4+eLSnuAerqj5mQzXCYZFK22xUXxCsT8OYvwx8rkLn35?=
 =?us-ascii?Q?FqBF1OoFr2snTP/eJrcv/rBDMFH3GdZYkAZVXgcL1jgjRYCIHS/VI3+CGkJg?=
 =?us-ascii?Q?Hlhdad+q8HbB+e88TRS4lpv4RVr85otrH5NtnyihoMOEY0z9ynwoxDv6cWtJ?=
 =?us-ascii?Q?Ao6BN7n/g97iowpvi2zaThC5jakNb3g8MjVbKNur8JTUWkIRJd9MDzbkSMhB?=
 =?us-ascii?Q?/BiRfCIOGOJKfAkiDy+NoFFsmFZv6DGeeykg+YEDt1bx7c7uwJFOLE4yudYv?=
 =?us-ascii?Q?+0tcdYer8EEUFXjE39Y156sOKIRsBEH/ARsIrrFDQObR7WIlQsfERkv0otAS?=
 =?us-ascii?Q?M72+JXB+LA6AJCcz7zDN8p10YjejtUbMS80TKWt0HNICMfMiF+Ims/SrvibQ?=
 =?us-ascii?Q?marXtzrbqI5NhE4znVGe4ZcUSKU0c0JYcz3OxLwDM3s6uiQO8NpFoRrRFFNM?=
 =?us-ascii?Q?Kn7MX7mhjWNF2sO9KWo0Ogs/uUWwJbRwLjZWjSfbF7iHBB8BlfYnWqu9AsA8?=
 =?us-ascii?Q?gh0OzrixuND5pbCPTAOQjuyKk+5u6CqPoPPmYptD+gnq0/rvOhQNFKfJMizu?=
 =?us-ascii?Q?Moraf88qaIzLmEyUeoe/IBxOB3+JgvlNxeQ3yDPBH2+3giFsbHQitp0OpPZ0?=
 =?us-ascii?Q?0NdyjMclH9HtSvZDJ5ARYqP1KpX5Q0vdavlfW1djT70Cfr3xYS69LMrcqPhy?=
 =?us-ascii?Q?vy41bOG5vwugqiCdryhSLrjeOZTODNdLB7gF9kWVE7Np9Ckk+TT0M5S3L7vg?=
 =?us-ascii?Q?zx/yH40XSA=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e213bfc0-23e9-4d46-57eb-08da3d548878
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 07:10:50.5293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1b8W8KRypsYmHbCNCCzdCZ06kg95qNNuIMAC+tdaVZ4E/4Vql3ORz9Wu5xyXfhITvlv+uhIQZHiSQr/+VOJArQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2703
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 05:25:36PM -0700, Yonghong Song wrote:
> On 5/20/22 4:50 PM, Yonghong Song wrote:
> > On 5/20/22 4:37 AM, Shung-Hsi Yu wrote:
> > > The BPF_SIZE check in the beginning of check_ld_imm() actually guard
> > > against program with JMP instructions that goes to the second
> > > instruction of BPF_LD_IMM64, but may be easily dismissed as an simple
> > > opcode check that's duplicating the effort of bpf_opcode_in_insntable=
().
> > >=20
> > > Add comment to better reflect the importance of the check.
> > >=20
> > > Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> > > ---
> > > =C2=A0 kernel/bpf/verifier.c | 4 ++++
> > > =C2=A0 1 file changed, 4 insertions(+)
> > >=20
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 79a2695ee2e2..133929751f80 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -9921,6 +9921,10 @@ static int check_ld_imm(struct
> > > bpf_verifier_env *env, struct bpf_insn *insn)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bpf_map *map;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int err;
> > > +=C2=A0=C2=A0=C2=A0 /* checks that this is not the second part of BPF=
_LD_IMM64, which is
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 * skipped over during opcode check, but a J=
MP with invalid
> > > offset may
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 * cause check_ld_imm() to be called upon it=
.
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 */
> >=20
> > The check_ld_imm() call context is:
> >=20
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 } else if (class =3D=3D BPF_LD) {
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 mo=
de =3D BPF_MODE(insn->code);
> >=20
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (m=
ode =3D=3D BPF_ABS || mode =3D=3D BPF_IND) {
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D check_ld_abs(env, insn);
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return err;
> >=20
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } els=
e if (mode =3D=3D BPF_IMM) {
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D check_ld_imm(env, insn);
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return err;
> >=20
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 env->insn_idx++;
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sanitize_mark_insn_seen(env);
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } els=
e {
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 verbose(env, "invalid BPF_LD mod=
e\n");
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > which is a normal checking of LD_imm64 insn.
> >=20
> > I think the to-be-added comment is incorrect and unnecessary.
>=20
> Okay, double check again and now I understand what happens
> when hitting the second insn of ldimm64 with a branch target.
> Here we have BPF_LD =3D 0 and BPF_IMM =3D 0, so for a branch
> target to the 2nd part of ldimm64, it will come to
> check_ld_imm() and have error "invalid BPF_LD_IMM insn"

Yes, the 2nd instruction uses the reserved opcode 0, which could be
interpreted as BPF_LD | BPF_W | BPF_IMM.

> So check_ld_imm() is to check whether the insn is a
> *legal* insn for the first part of ldimm64.
>=20
> So the comment may be rewritten as below.
>=20
> This is to verify whether an insn is a BPF_LD_IMM64
> or not. But since BPF_LD =3D 0 and BPF_IMM =3D 0, if the branch
> target comes to the second part of BPF_LD_IMM64,
> the control may come here as well.
>=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (BPF_SIZE(insn->code) !=3D BPF_DW) =
{
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 verbose(env, "=
invalid BPF_LD_IMM insn\n");
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL=
;

After giving it a bit more though, maybe it'd be clearer if we simply detec=
t
such case in the JMP branch of do_check().

Something like this instead. Though I haven't tested yet, and it still chec=
k
the jump destination even it's a dead branch.

---
 kernel/bpf/verifier.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index aedac2ac02b9..59228806884e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12191,6 +12191,25 @@ static int do_check(struct bpf_verifier_env *env)
 			u8 opcode =3D BPF_OP(insn->code);
=20
 			env->jmps_processed++;
+
+			/* check jump offset */
+			if (opcode !=3D BPF_CALL && opcode !=3D BPF_EXIT) {
+				u32 dst_insn_idx =3D env->insn_idx + insn->off + 1;
+				struct bpf_insn *dst_insn =3D &insns[dst_insn_idx];
+
+				if (dst_insn_idx > insn_cnt) {
+					verbose(env, "invalid JMP idx %d off %d beyond end of program insn_cn=
t %d\n", env->insn_idx, insn->off, insn_cnt);
+					return -EFAULT;
+				}
+				if (!bpf_opcode_in_insntable(dst_insn->code)) {
+					/* Should we simply tell the user that it's a
+					 * jump to the 2nd LD_IMM64 instruction
+					 * here? */
+					verbose(env, "idx %d JMP to idx %d with unknown opcode %02x\n", env->=
insn_idx, dst_insn_idx, insn->code);
+					return -EINVAL;
+				}
+			}
+
 			if (opcode =3D=3D BPF_CALL) {
 				if (BPF_SRC(insn->code) !=3D BPF_K ||
 				    (insn->src_reg !=3D BPF_PSEUDO_KFUNC_CALL
--=20
2.36.1

