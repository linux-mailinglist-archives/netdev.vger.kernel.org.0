Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD60864670F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLHCiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLHCiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:38:22 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC6BE03E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:38:21 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-14449b7814bso397215fac.3
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 18:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X1EI4xmQOLkF5+6teY/fXdXw69BCCe6XamlbUgv+AhM=;
        b=DJchbrIAtw8KxjWQ0daH0FOTq6IxKJYbUCI/h7fetYmSXU5ru3/oYGpPHLKyz5OMoD
         rKxI4fhiM7xjied6U36xjqJbGhAviK6J2eZc/1excZWIxeuaOW/nu+DzzvbCf+6LSgfG
         R5AYA4teZiGaJaR8du/NNIPQUP/jMC0RBXhd1w5pwmovfD+XhNpCHnl/5rruXhiCu22F
         LnNBmNvDHmNy+1VvwDnrm1IMY2AOxrZM/rbHt5vZB/C2FraUbBJrcV9kIY7FKNYT6pz/
         1wfgQQ55TbERmTYKOUnhEaY3pUZoLu1gfH9M+ujXFsJn/SZ7wZbta3FaGfUxCqY/0n3O
         sepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X1EI4xmQOLkF5+6teY/fXdXw69BCCe6XamlbUgv+AhM=;
        b=NxsMzN3/ar+zNFRWr51XAIg3s1jZyVAnTgXkoLk9yFcYhaRzxu0jM6nAKwzkWJVgHD
         bbok6BgvlxeXx4axg93Dm5ODkxLDjZ1EOIM3tFp+6nlsQtQsbX3+JMIUK5CpCj1D+sY/
         kh3Vmhf8S9Nkm4kVEXC9mM5LeyfxfQeUTuatWxMOwRJurK+pzCIApYxU5BypNmJuB4Xn
         VZaaoqeCkOryVut9EhZGWHVVpbN106nnTCGrzGnHlgv7VdOginWEyw8fYfAgjHFlvGD4
         8yWzvsHuXHVPbdFypqfgnPWJyW3jDVy0NNgWP8/TN8/T+EZKuImPwkiptX/TUVNUC1FR
         3hYQ==
X-Gm-Message-State: ANoB5plGxgctedjbnWBZom4AjgOBrHjPbI6uQHBEuMjPDeI4g2Gj095t
        UXoh6gAD0t5bMvnob1FCgeSqBD233+dkoExH5uo=
X-Google-Smtp-Source: AA0mqf7ILVaWP7AlDQMpKFDhdQ2q7v9WBV1uCGqTVA6a6xUf3cWv6kUb5JdpC4B0BfndvDFI1coW04J8BL9aaqcg9kY=
X-Received: by 2002:a05:6870:b426:b0:142:c277:2e94 with SMTP id
 x38-20020a056870b42600b00142c2772e94mr42303923oap.129.1670467101172; Wed, 07
 Dec 2022 18:38:21 -0800 (PST)
MIME-Version: 1.0
References: <cover.1670369327.git.lucien.xin@gmail.com> <bbaf96445e9e60136dfaacdc58726bfd3a9e5148.1670369327.git.lucien.xin@gmail.com>
 <Y4/WNywqOPQlCQrz@salvia> <CADvbK_dEST=QdwkS0CdtnMWUAcF96XagezF2zuvRU_B7nB=aYw@mail.gmail.com>
In-Reply-To: <CADvbK_dEST=QdwkS0CdtnMWUAcF96XagezF2zuvRU_B7nB=aYw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 7 Dec 2022 21:37:29 -0500
Message-ID: <CADvbK_da=Os1g6G1kWLyXMR=ANdbdOV5s3duCezDSsoUfNFE3w@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 5/5] net: move the nat function to nf_nat_ovs
 for ovs and tc
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 10:32 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Dec 6, 2022 at 6:54 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Tue, Dec 06, 2022 at 06:31:16PM -0500, Xin Long wrote:
> > [...]
> > > diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> > > index 1d4db1943936..0976d34b1e5f 100644
> > > --- a/net/netfilter/Makefile
> > > +++ b/net/netfilter/Makefile
> > > @@ -54,6 +54,12 @@ obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
> > >
> > >  nf_nat-y     := nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
> > >
> > > +ifdef CONFIG_OPENVSWITCH
> > > +nf_nat-y += nf_nat_ovs.o
> > > +else ifdef CONFIG_NET_ACT_CT
> > > +nf_nat-y += nf_nat_ovs.o
> > > +endif
> >
> > Maybe add CONFIG_NF_NAT_OVS and select it from OPENVSWITCH Kconfig
> > (select is a hammer, but it should be fine in this case since
> > OPENVSWITCH already depends on NF_NAT?).
> not really completely depends, it's:
>
>   depends on (!NF_NAT || NF_NAT)
>
> but it's fine, the select will be:
>
>   select NF_NAT_OVS if NF_NAT
>
> >
> > Then in Makefile:
> >
> > nf_nat-$(CONFIG_NF_NAT_OVS)  += nf_nat_ovs.o
> >
> > And CONFIG_NF_NAT_OVS depends on OPENVSWITCH.
> Sounds great!
> Then it will be:
>
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -459,6 +459,10 @@ config NF_NAT_REDIRECT
>  config NF_NAT_MASQUERADE
>         bool
>
> +config NF_NAT_OVS
> +       bool
> +       depends on OPENVSWITCH || NET_ACT_CT
> +
Just FYI, "depends on" is not necessary in this case.
Even without this "depends on OPENVSWITCH || NET_ACT_CT",
it will still be disabled automatically if OPENVSWITCH and
NET_ACT_CT are disabled, and you can't enable it manually either.

Thanks.

>
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -59,6 +59,7 @@ obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
>  obj-$(CONFIG_NF_NAT) += nf_nat.o
>  nf_nat-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
>  nf_nat-$(CONFIG_NF_NAT_MASQUERADE) += nf_nat_masquerade.o
> +nf_nat-$(CONFIG_NF_NAT_OVS)  += nf_nat_ovs.o
>
> --- a/net/openvswitch/Kconfig
> +++ b/net/openvswitch/Kconfig
> @@ -15,6 +15,7 @@ config OPENVSWITCH
>         select NET_MPLS_GSO
>         select DST_CACHE
>         select NET_NSH
> +       select NF_NAT_OVS if NF_NAT
>
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -977,6 +977,7 @@ config NET_ACT_TUNNEL_KEY
>  config NET_ACT_CT
>         tristate "connection tracking tc action"
>         depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT)
> && NF_FLOW_TABLE
> +       select NF_NAT_OVS if NF_NAT
>
>
> I will prepare v4, Thanks.
