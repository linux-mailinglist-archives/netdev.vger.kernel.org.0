Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B965AFA60
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 05:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiIGDEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 23:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIGDEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 23:04:32 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AC2CDF;
        Tue,  6 Sep 2022 20:04:23 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gh9so5502825ejc.8;
        Tue, 06 Sep 2022 20:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=HHiZpp/lkYp2ofvupKRP2VlnxkJw1jXBL0DKfMbVElQ=;
        b=KgdQqC+WT7xbqnFc6SpJK5IiCLPs8+f8qafKpmNGPjPB+4oFJeI+lsOLOTyHJn3DvF
         a0r/6p/oTjnz+ELV/2PXJSKRrA9e/V2MAyzxm20BsikGHwneXWqwtGjYqraxYgeOxaHP
         X7zXZ9jXBhs+QGfx99DQnRKVwgiNnoL4wJy82crJfrizTBQUivp9Kd7K6CET3lSxkjVd
         Cst02IEYzebWje29c0ANC4Vnse0DsQiADoR1FNcFedZpIu883LsQH07GSL6JzONusuKc
         iJNbnByzcjmKX5eD9vRjJ6YjZ3vWh4PRF6EqwpKnGM2vwH2AlQCKzf3rBi8DBfBiT7rS
         Uesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HHiZpp/lkYp2ofvupKRP2VlnxkJw1jXBL0DKfMbVElQ=;
        b=GWBtxMgNR932nwuj6iqmQpvfFLmtZ7s0vFLGg0YYq6kPzEF2nk6I1SaiMVsi/EdZ0U
         uAqDuzX3OIXbeHznUygG8kz4LXS06qSnNwIulAcbOKhf2upEZGO3QYYPFOFJXydm3I1/
         dCyIQlkZd4jcMkg86fsYLfat03lOG5gzwygNHpp4gJL8qWhJWw3PTKdsdRZ0UCTi8nix
         zn4vP1h9b1kcRZcf0RG1PKLCJGHNVaiC+3o5N+P8vasAmhHlp4I55+T1lnkpG7a6SaVw
         ZrrjtDixWIDMkccBs7ioRxq9694reM8/QQExV+383rActgUDu5RiM2wwo/w4eW/dhbPi
         Cudw==
X-Gm-Message-State: ACgBeo3hRCd7Y72oK4k8tD3LlCiM2N9PS25Pzr0U0xfzjT2XDXUXlK/k
        M2U00r1etZ6hsl2jHmZ+zssID1xb9RNYjuYYkLwnrdB5
X-Google-Smtp-Source: AA6agR7LJES6Wnx7jzpyLYvs1KevE1iq41zkaB2RDhDld0XfThl7Ry6nu5J+5mTj6QZYfLYzxlAwQccYaAhcbDPy8sE=
X-Received: by 2002:a17:906:58d1:b0:76d:af13:5ae3 with SMTP id
 e17-20020a17090658d100b0076daf135ae3mr942631ejs.708.1662519862193; Tue, 06
 Sep 2022 20:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc> <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc> <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
 <20220831215737.GE15107@breakpoint.cc> <bf148d57-dab9-0e25-d406-332d1b28f045@6wind.com>
In-Reply-To: <bf148d57-dab9-0e25-d406-332d1b28f045@6wind.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Sep 2022 20:04:11 -0700
Message-ID: <CAADnVQLYcjhpVaFJ3vriDcv=bczXddRd=q83exNNPrgnvsCEAg@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 11:57 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
>
> Le 31/08/2022 =C3=A0 23:57, Florian Westphal a =C3=A9crit :
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >>> This helps gradually moving towards move epbf for those that
> >>> still heavily rely on the classic forwarding path.
> >>
> >> No one is using it.
> >> If it was, we would have seen at least one bug report over
> >> all these years. We've seen none.
> >
> > Err, it IS used, else I would not have sent this patch.
> >
> >> very reasonable early on and turned out to be useless with
> >> zero users.
> >> BPF_PROG_TYPE_SCHED_ACT and BPF_PROG_TYPE_LWT*
> >> are in this category.
> >
> > I doubt it had 0 users.  Those users probably moved to something
> > better?
> We are using BPF_PROG_TYPE_SCHED_ACT to perform custom encapsulations.
> What could we used to replace that?

SCHED_CLS. It has all of the features of cls and act combined.
