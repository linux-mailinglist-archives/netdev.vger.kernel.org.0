Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6840D6E0FD7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjDMOUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDMOUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:20:43 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3DF8692;
        Thu, 13 Apr 2023 07:20:41 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id bj35so5619709qkb.7;
        Thu, 13 Apr 2023 07:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681395639; x=1683987639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lW/y2Ol3OhLPBNr9rvyH1eAaIrNNLPHhWID9/UTdLng=;
        b=nyXR7x3K8TxAWFT6syas/3zTXJU4LKQFrH0Nmvqrk7lRvxC7e0k9H2Rfo1l/tp9i/E
         c6vXpPiaQFpxBTKs2XIhUerytsm/ue9nWI9AbZ7UYcSpQMD+ixI+bd/AtADpYHLf/5lS
         ynzLFisT/QExB9sqbW/xf96GCyluSfEvBp41D1Bk4yyJIqWIA2NaOtYNt0Q/Kan3AtED
         RsKOFsAsBxFK3YSCHTmWTvCgunddJxdSliwGHQx8A+t/9MpZI0O55JL65mwH7/N4iLpT
         kOONNa0ZXhjDsB8ydTo0kkB2pN85330tFSXFXawhED2Y0kj7YzfIqfBgwwMm+Usr2v3f
         7giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681395639; x=1683987639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lW/y2Ol3OhLPBNr9rvyH1eAaIrNNLPHhWID9/UTdLng=;
        b=KQQ4RpyI/086o/L/vprHMXRRTlcXThuznCh9HqepctVbifOrA3AOysUkCga04aTT1C
         Jxr3BUf5lFxrfSjsYV7JwkGOtWqO7byv2uaOkTqGs/Rb1j0CYg8fHzsP44s7F7ocfsCx
         jsDEr0yfwZCSif5n8A2/r4DGJtPPEdbcJw4eSL6cGIrlZ1k0D/w0t6E/n1G/3OHOry8Z
         iHDUpxMQF0+z1/ys48emFbsAH1AzXhRPpYTW1lvfvmkjyDTgOCdnff6bdn6GqyXea9e+
         owi7VHaoZAH9PLmaM+Ck5zc4uJViJR4tT2gyt1NFrZSpUXe93ClW19hmo2Y90WmqwYP+
         R2hA==
X-Gm-Message-State: AAQBX9dSJRt1NgMzpByU0OLJ2Q2Uvy7sYpZn/Vvk8pFP0YeIwqWnlv69
        nzUyl92AozxZbJTO6lwQe1Pplg5BktYgFn8v1qI=
X-Google-Smtp-Source: AKy350ZwVn8Ny+/4FCQhbVC+XVjtZXQVi80HOpVOXoQuvDEd3ErTse5FvQAAMyC3uNX4eFqGoix/G194NaGnuiR7Ru8=
X-Received: by 2002:a05:620a:318d:b0:746:75f7:c8a2 with SMTP id
 bi13-20020a05620a318d00b0074675f7c8a2mr1637361qkb.4.1681395639645; Thu, 13
 Apr 2023 07:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230413025350.79809-1-laoar.shao@gmail.com> <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net>
In-Reply-To: <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 13 Apr 2023 22:20:03 +0800
Message-ID: <CALOAHbDRAV-wgewv8YU1L4z4-3xHZTtD+O7BDD+vCV7=d-hNvQ@mail.gmail.com>
Subject: Re: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev,
        toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 7:47=E2=80=AFPM Daniel Borkmann <daniel@iogearbox.n=
et> wrote:
>
> On 4/13/23 4:53 AM, Yafang Shao wrote:
> > In our container environment, we are using EDT-bpf to limit the egress
> > bandwidth. EDT-bpf can be used to limit egress only, but can't be used
> > to limit ingress. Some of our users also want to limit the ingress
> > bandwidth. But after applying EDT-bpf, which is based on clsact qdisc,
> > it is impossible to limit the ingress bandwidth currently, due to some
> > reasons,
> > 1). We can't add ingress qdisc
> > The ingress qdisc can't coexist with clsact qdisc as clsact has both
> > ingress and egress handler. So our traditional method to limit ingress
> > bandwidth can't work any more.
>
> I'm not following, the latter is a super set of the former, why do you
> need it to co-exist?
>

It seems that I have a misunderstanding.

> > 2). We can't redirect ingress packet to ifb with bpf
> > By trying to analyze if it is possible to redirect the ingress packet t=
o
> > ifb with a bpf program, we find that the ifb device is not supported by
> > bpf redirect yet.
>
> You actually can: Just let BPF program return TC_ACT_UNSPEC for this
> case and then add a matchall with higher prio (so it runs after bpf)
> that contains an action with mirred egress redirect that pushes to ifb
> dev - there is no change needed.
>

Ah, indeed, it works.
Many thanks for your help.

> > This patch tries to resolve it by supporting redirecting to ifb with bp=
f
> > program.
> >
> > Ingress bandwidth limit is useful in some scenarios, for example, for t=
he
> > TCP-based service, there may be lots of clients connecting it, so it is
> > not wise to limit the clients' egress. After limiting the server-side's
> > ingress, it will lower the send rate of the client by lowering the TCP
> > cwnd if the ingress bandwidth limit is reached. If we don't limit it,
> > the clients will continue sending requests at a high rate.
>
> Adding artificial queueing for the inbound traffic, aren't you worried
> about DoS'ing your node?

Yes, we worried about it, but we haven't observed it in our data center.

> If you need to tell the sender to slow down,
> have you looked at hbm (https://lpc.events/event/4/contributions/486/,
> samples/bpf/hbm_out_kern.c) which uses ECN CE marking to tell the TCP
> sender to slow down? (Fwiw, for UDP https://github.com/cloudflare/rakelim=
it
> would be an option.)
>

We're considering using ECN. Thanks for your information, I will analyze it=
.

--=20
Regards
Yafang
