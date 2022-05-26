Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C647534C25
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 11:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346190AbiEZJBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 05:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345132AbiEZJBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 05:01:13 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AAFD87
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 02:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653555669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WfmgWYmROWun/bdUJVEavyz/U7GYo/KA9VVj0w/KH0w=;
        b=FtWYEwdxBXlaxkScikoX9RfYqocQ5WtAadC+XsKwTbuASRsY3TiY75+Zxh2x+7MuGD/pkR
        2Pk5efAEYcJLxuzPfH5p72j7UH0T42Si+Yj7Ny8qSBkyQxuXlkj8RnPLOPleai/X9+XSMY
        FxlDae0y8JCVlkmBzmhg+yUqGdgTqi8=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2054.outbound.protection.outlook.com [104.47.12.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-30-6ilVzBiWMOCjk4RarezeXA-1; Thu, 26 May 2022 11:01:05 +0200
X-MC-Unique: 6ilVzBiWMOCjk4RarezeXA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idRlkO/+w2xtGG/8+jelwxRfBtIe1og8+ILjZD9t5XDUsjOggIKuszt0a54UqqeLv0jnS3qfIJlmGNXrBg31+Q5pfj+T2aM13NDj+QnrChqFYHgZPn/BruBgDbsneaD0p5wDHAjPPSgCCtAicQY7SQrjSVKxOA4seHhMBX7OVVnz/iDpKzaPK/YXI75HARFzOXr8gRk5nvpBS03wyBAMa50WZQTCWPo91pFWxvtcFFv+IBa7ZFlAodF1jk4Bn7N98Kd9uEFTk14vItaVGGmLLtp9cDZiEZKkbE3c5eyWYptUgul8RJy8oE1I2Id2cOlqt/Pb4iV/eWltuJnwe8cAkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfmgWYmROWun/bdUJVEavyz/U7GYo/KA9VVj0w/KH0w=;
 b=lRi2fczdpQMZqVwJ52Ha0PlIRjcnuCqzS9Y2zrwk6UmgnyYDhh+KpXNCHL71Aa/QFRxtHMfI9H4MvpWQ8tGS2FihzxO8YRhwmkLbC/GsBFq00xc/a6w6kGw5SGSImJEEq83OrxBPs/rCK0/u+qkDpnfoxeir8p0ShMcrpZ9rTtmDtWrQehUScRnxjeh3OYBpPpw2/LZVCwhu85pxAwMfwd1lwAo3npSWsfWvJpeZQuXS48At514BrbOHzHe2fp+xLRRI8opq2hlldoMeHdLl4lf0zaz01xpQwHJJ2QpjUqSuPYBga4EswqK7leXM3m//lUyGZvP2jAl7QQ4Q54YWhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com (2603:10a6:10:243::20)
 by AM6PR04MB5639.eurprd04.prod.outlook.com (2603:10a6:20b:ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Thu, 26 May
 2022 09:01:02 +0000
Received: from DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa]) by DB9PR04MB8107.eurprd04.prod.outlook.com
 ([fe80::40a2:1b77:8319:a7fa%6]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 09:01:02 +0000
Date:   Thu, 26 May 2022 16:59:45 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH bpf-next 2/4] bpf: verifier: explain opcode check in
 check_ld_imm()
Message-ID: <Yo9BgYBum3jU4N4s@syu-laptop>
References: <20220520113728.12708-1-shung-hsi.yu@suse.com>
 <20220520113728.12708-3-shung-hsi.yu@suse.com>
 <f9511485-cda4-4e5e-fe1f-60ffe57e27d1@fb.com>
 <0cf50c32-ab67-ef23-7b84-ef1d4e007c33@fb.com>
 <YoyEbYGIoiULPQEk@syu-laptop>
 <CAADnVQ+gJ8ksqGRgYn0kbfTBm2BsvZyc-hRAMbAWhj05LdW6Lw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQ+gJ8ksqGRgYn0kbfTBm2BsvZyc-hRAMbAWhj05LdW6Lw@mail.gmail.com>
X-ClientProxiedBy: AS8PR05CA0009.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::14) To DB9PR04MB8107.eurprd04.prod.outlook.com
 (2603:10a6:10:243::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8da69b1f-8eee-4fda-bae4-08da3ef64236
X-MS-TrafficTypeDiagnostic: AM6PR04MB5639:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB5639D9B002A68F6BB8C19736BFD99@AM6PR04MB5639.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ydl2uozAt5zqh45J+p6Xl0LWC2PO6jK7sNq/wXBOfNI2ahvzkfL7/+0uf3HBWIAvIgIemHnErperpG477pqYxo5NX76kUWU9DMRrUEn/r1InblknVs4ioKXdfOOpKUo0wwYznj3BePWbfFvbII83eBGu++u2mf/AU2z1AayuDonhGehie/tKKVZW0AfxmNAitSZcp3sOMVCPEWw1rC9UV7woHI09waicrbna56L4KesIWgAaNhsTTIWRcIS76OzHn4SOqWrYrHqJezddZfG2Uw7gfrFEzGO3BJHzLUAQM1FOBy0/RaRakFLUr7YKOtl90+OCkOEs1HAgeRUo0Zx87mQ2yAJ4ZTouJOw5yk/5GpjE3fZp7Qzq1hkiqLuUTw/MS1sx3lY67s7vQOOda+fr4v/vAtQkhuxEtDLUAqRlmGpci3bWhZ8/uM69tsvgOtM7HmguLZN5GvZvyUn0LNNiqZoUhw8/6LrnVExyYErbqwxYSt/ZJROhc9bY73OrzKL3eWdthHpTLuVH9iMXsW5KOjiiK5mVGB4pIhxgF+QJ4NhHajTngPWW2wFnioNwmUwwLxCDn5crg0XB19wnMfqdkaswnTLR/FU8yVpvJwkPbvJRampDnRIonpHVey06WL01hzz9Unkbz7x+ya9aUpGSBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(508600001)(6916009)(38100700002)(54906003)(66476007)(186003)(7416002)(5660300002)(6506007)(6486002)(53546011)(86362001)(9686003)(6512007)(26005)(33716001)(8936002)(6666004)(2906002)(8676002)(316002)(66946007)(83380400001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjZ6WktRWXRwcytubnhUQXhveHNKK0NTRkJjR3BtTWc1SFdnWG5MUEJLbGpa?=
 =?utf-8?B?Ylg1bGxEL1BOUkVNaFpzbUNMdmR4YTh5Q25zZUM3Qy82MXZ1Nksxb0hpVzFF?=
 =?utf-8?B?Q2padENSYzgvc0RqejJxQm51dlVTQ1lUM0pFbHROYVJEZkpobnUzT2pTb3Vu?=
 =?utf-8?B?VFc0T3gwQzkwWG5VWkdBWE9tWkhNUzJ5bjdreVZrQ2x4RlEwUGxqUFpvcm9E?=
 =?utf-8?B?MDRqQ1QyV2pVcjliQUNXMFNMSWFUUkxpemJHdHpuN0dCa3lpNkVyVS8wQ1Ji?=
 =?utf-8?B?ZUpzZmFzYUpNa0VLdUZsZlhMem9XMGN0TEN1R2xwMmcwRmtqKy94aEFSTnJN?=
 =?utf-8?B?bkVUQXdJaC83czlpSzZrZ1pkQnJvS21FYVhucG9yekIrWmVtMm1JTkZQaUNM?=
 =?utf-8?B?MkpRV0pwYmpoZExLVmxjRG5aZGJPUmZIUHE3QWR5Q3FlZ2Rna2ROTytDRitI?=
 =?utf-8?B?QlV6a2NHaVZmT2t5SG5mY0RqVVh1VVZHaExETnVkR0JjLzNNNkhmYmpuZ3Z6?=
 =?utf-8?B?OHZVYWlOQmg3ZzZ3OHowZUhuMkJOSXV5R09Ic0hNUHVXZXppRVhCUkltQkRC?=
 =?utf-8?B?RjBWZmROdndzaE1naHkxVHJnRDNDcXg0czZlMGhQeTRlbUNjYVBPR1dML1Uv?=
 =?utf-8?B?S29OQnA2cTJpTFhxcVZVNUFUcmg2VFhOQlF4YzMxTnV6Rm5YQTc5Uk10Q2s4?=
 =?utf-8?B?TCt6LzByNjZpUTE0Zk8vRHJhUEh6OHc4cGNraUdzb0ZGd3BoV3lJbldLdkhU?=
 =?utf-8?B?SFBweHBUNGlhaFlZZDlXb3lGS3RQMXNJNFN2NWRVSHZMYkk0cXV4bXJkT01a?=
 =?utf-8?B?Q05FMFBkU1VnQ1lHbFJiUGx2TldENCtHU1p5cTNvZTQyV3J2VW9CU1BIeUJy?=
 =?utf-8?B?ZkJJckIxK0xOMjdjdTg3U3o0TXFPQjRaRjIrMFpuVGJZcndsb1Yvd3dvNkNp?=
 =?utf-8?B?cEZ4eUc4by82N1ZjY1RBR1YvL1ZBWjgvdnBqa1BGWlpoZUNZVzloR0VKT1dI?=
 =?utf-8?B?bExHZlZwQlJOUkJNS3JBV1ZrcjBhM3dUS3Z5T0t3ajl6T3FvcTd6QklOV2px?=
 =?utf-8?B?YVhQeWs5WDZRWmZHMGZ1WWRYMGpydVNTN0VwT0NENzArcmFuOUhqbGs1RHpo?=
 =?utf-8?B?QXY3VTdXQ0NHZGplUDdPaFFiRGprQjljbzlueWo0bk05dERENzFrcTR0a0ov?=
 =?utf-8?B?V0dZZnhNMXBvSlJBQndqa3FGYkdyb05HL3dkQUd0SFBBelZyY29WZFN2RURs?=
 =?utf-8?B?OXBMcEp2MWRkMTh1NmlXdGM0SjV0MnBRTzNOSTlXWjJvakRteVZvMnU5Q056?=
 =?utf-8?B?dXNkZjVSeDcxN2QxQ3RTTExzMURDRkRaeXViZlVhV1hLN2VZR1NRanlqRmdk?=
 =?utf-8?B?TFZha1d4VDZNNDducytMeERwTW9yRzd2RnU2WmJDZ1dDUStZNmdQYnZudUV2?=
 =?utf-8?B?YWNUUlJZNXB5eVMxdnFxNmxTcHI1bnUxa3ZqUmlmY3UwcFlneDV0NUhmKzhE?=
 =?utf-8?B?YmRVL0pGR3ZDVnFCb241bG44UDBLanNIQ2V2TEZudHVmZFNHQU1vYVo3MmUz?=
 =?utf-8?B?WHNqOWJLYTNCWDgrVUxCWXphRHROWGlnWFErcWQ4WWI0NlV6ZnRMUVhnWWdi?=
 =?utf-8?B?T2Z1dTJtOXFLQ2hiVGxSclJQbzFKZ1VXTGlLdUZ1VlRPTzd4Sm05TTk2K2Vp?=
 =?utf-8?B?T1JhSXZ3TEs4SHZ3K1lZenRaMy81cVlMQVFOb2E1cUxyNkhlSTBaMitqWjM3?=
 =?utf-8?B?QWt3SGJxdUxvOFpwQTlYOXFid2h0dDN1cmFNbVN5NXlkWGpsOE13Si9xSHJi?=
 =?utf-8?B?K0JiZlVnVjlacjFjTS9CVUVTWkFJMDJqVHA3UjcrSUU4NUNiUW5XaTlxbmFM?=
 =?utf-8?B?anhSeFdrZXBUbHp2ZVdsc21NQW1DeEk0N0ZpWk45Y0p6cjlXRjFLalhUa1BY?=
 =?utf-8?B?U2diVlNmaVd6Yy9OcU9SMjFHMGwrS21lRmF5NU5IMTJDOWQrZWFFd2QzejZt?=
 =?utf-8?B?QmkxVEgrREJhcU5sS1RxZ1ZVL014ZXkyQm9QZ2RSaFBCMG5UalV1a0F6RlVX?=
 =?utf-8?B?N2RlUmhvTWd4Y0RyaitpMVN0ekpodEVpZHdKOWVneW1PNzhBWkpxN0I2Q1N6?=
 =?utf-8?B?RENib1J3aGpnWU5XRG9aT1pYMjZXSkFoaEJOMWhnQTZVaGR3THFUM2hUNm1J?=
 =?utf-8?B?cmQ4KzViWFVHUXF3TitxV3Z1R0l3UmNYekE2dmdXbjdsazJTYlVOK3R0RGJj?=
 =?utf-8?B?U2U4dHpOMHcveVZUMnJzMEcrektSKzFoM01wdlM4Q21MNDUrNjF4OUdqckRU?=
 =?utf-8?B?WTZRK1loQUpuSDExUnFlSFhRcXVUeEdScmI3YmYxanhwY2JWNWxEUT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da69b1f-8eee-4fda-bae4-08da3ef64236
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 09:01:02.5886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2h5Vf5x0wj55t7z39HZFvEOenRzGmZHxvcjGZORZKJfSkEuWWaMBYSxGSS1n+8iaCV1tIIC4fi/bXzx3qlGyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5639
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 08:12:24AM -0700, Alexei Starovoitov wrote:
> On Tue, May 24, 2022 at 12:11 AM Shung-Hsi Yu <shung-hsi.yu@suse.com> wrote:
> > On Fri, May 20, 2022 at 05:25:36PM -0700, Yonghong Song wrote:
> > > On 5/20/22 4:50 PM, Yonghong Song wrote:
> > > > On 5/20/22 4:37 AM, Shung-Hsi Yu wrote:
> > > > > The BPF_SIZE check in the beginning of check_ld_imm() actually guard
> > > > > against program with JMP instructions that goes to the second
> > > > > instruction of BPF_LD_IMM64, but may be easily dismissed as an simple
> > > > > opcode check that's duplicating the effort of bpf_opcode_in_insntable().
> > > > >
> > > > > Add comment to better reflect the importance of the check.
> > > > >
> > > > > Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> > > > > ---
> > > > >   kernel/bpf/verifier.c | 4 ++++
> > > > >   1 file changed, 4 insertions(+)
> > > > >
> > > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > > index 79a2695ee2e2..133929751f80 100644
> > > > > --- a/kernel/bpf/verifier.c
> > > > > +++ b/kernel/bpf/verifier.c
> > > > > @@ -9921,6 +9921,10 @@ static int check_ld_imm(struct
> > > > > bpf_verifier_env *env, struct bpf_insn *insn)
> > > > >       struct bpf_map *map;
> > > > >       int err;
> > > > > +    /* checks that this is not the second part of BPF_LD_IMM64, which is
> > > > > +     * skipped over during opcode check, but a JMP with invalid
> > > > > offset may
> > > > > +     * cause check_ld_imm() to be called upon it.
> > > > > +     */
> > > >
> > > > The check_ld_imm() call context is:
> > > >
> > > >                  } else if (class == BPF_LD) {
> > > >                          u8 mode = BPF_MODE(insn->code);
> > > >
> > > >                          if (mode == BPF_ABS || mode == BPF_IND) {
> > > >                                  err = check_ld_abs(env, insn);
> > > >                                  if (err)
> > > >                                          return err;
> > > >
> > > >                          } else if (mode == BPF_IMM) {
> > > >                                  err = check_ld_imm(env, insn);
> > > >                                  if (err)
> > > >                                          return err;
> > > >
> > > >                                  env->insn_idx++;
> > > >                                  sanitize_mark_insn_seen(env);
> > > >                          } else {
> > > >                                  verbose(env, "invalid BPF_LD mode\n");
> > > >                                  return -EINVAL;
> > > >                          }
> > > >                  }
> > > >
> > > > which is a normal checking of LD_imm64 insn.
> > > >
> > > > I think the to-be-added comment is incorrect and unnecessary.
> > >
> > > Okay, double check again and now I understand what happens
> > > when hitting the second insn of ldimm64 with a branch target.
> > > Here we have BPF_LD = 0 and BPF_IMM = 0, so for a branch
> > > target to the 2nd part of ldimm64, it will come to
> > > check_ld_imm() and have error "invalid BPF_LD_IMM insn"
> >
> > Yes, the 2nd instruction uses the reserved opcode 0, which could be
> > interpreted as BPF_LD | BPF_W | BPF_IMM.
> >
> > > So check_ld_imm() is to check whether the insn is a
> > > *legal* insn for the first part of ldimm64.
> > >
> > > So the comment may be rewritten as below.
> > >
> > > This is to verify whether an insn is a BPF_LD_IMM64
> > > or not. But since BPF_LD = 0 and BPF_IMM = 0, if the branch
> > > target comes to the second part of BPF_LD_IMM64,
> > > the control may come here as well.
> > >
> > > > >       if (BPF_SIZE(insn->code) != BPF_DW) {
> > > > >           verbose(env, "invalid BPF_LD_IMM insn\n");
> > > > >           return -EINVAL;
> >
> > After giving it a bit more though, maybe it'd be clearer if we simply detect
> > such case in the JMP branch of do_check().
> >
> > Something like this instead. Though I haven't tested yet, and it still check
> > the jump destination even it's a dead branch.
> >
> > ---
> >  kernel/bpf/verifier.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index aedac2ac02b9..59228806884e 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -12191,6 +12191,25 @@ static int do_check(struct bpf_verifier_env *env)
> >                         u8 opcode = BPF_OP(insn->code);
> >
> >                         env->jmps_processed++;
> > +
> > +                       /* check jump offset */
> > +                       if (opcode != BPF_CALL && opcode != BPF_EXIT) {
> > +                               u32 dst_insn_idx = env->insn_idx + insn->off + 1;
> > +                               struct bpf_insn *dst_insn = &insns[dst_insn_idx];
> > +
> > +                               if (dst_insn_idx > insn_cnt) {
> > +                                       verbose(env, "invalid JMP idx %d off %d beyond end of program insn_cnt %d\n", env->insn_idx, insn->off, insn_cnt);
> > +                                       return -EFAULT;
> > +                               }
> > +                               if (!bpf_opcode_in_insntable(dst_insn->code)) {
> > +                                       /* Should we simply tell the user that it's a
> > +                                        * jump to the 2nd LD_IMM64 instruction
> > +                                        * here? */
> > +                                       verbose(env, "idx %d JMP to idx %d with unknown opcode %02x\n", env->insn_idx, dst_insn_idx, insn->code);
> > +                                       return -EINVAL;
> > +                               }
> > +                       }
> > +
> 
> This makes the code worse.

Could you elaborate a bit more on the reason? I'd like to try avoid
submitting patch like this in the future.

In hindsight I'd guess it's because it adds more branching into do_check()
and more lines of code, making it harder to understand, but at the same time
the added checks is mostly repeating existing

 1. insn_cnt check in the beginning of do_check() loop
 2. BPF_SIZE check in check_ld_imm()

While it has the benefit of adding more specific error message, such error
message is too specific to be useful in general, thus does not outweigh the
cost of added complexity?

> There is no need for these patches.

Just to be clear, "these" refers to the added checks do_check()
<Yoxjvvm9poTC3Atv@syu-laptop> only, or does it also includes the to-be-added
comment inside check_ld_imm() of patch 2?

