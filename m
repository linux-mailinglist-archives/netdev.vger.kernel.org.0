Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2D463F5BD
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLAQyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLAQya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:54:30 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67D527143
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:54:29 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id w26-20020a056830061a00b0066c320f5b49so1325026oti.5
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h6gqlBqf72AAqgjEaxIk36DFKyr5wgtbH1GA7J8jPkY=;
        b=dVkFMCNqYiS6EyABVobZ7nYqoVBSbkwpV3+xXRdZ1cjdt6njNMQyDufkYBoVZJdk/S
         3lHHQv7yV2yq9+bTDnel1OXwv5DoPLPgxIwfCDmrMaYW1cZQr04J5wt3bnrSUiPdw88l
         bNRCp41xGDgRaP40zlxvitNZV0BNqAGXWHUqa5wNNwfMs9Hn0vHYrepYlraV3vNnPMKJ
         Bqn745u1E6xUiLxGx1U9CUerOQy43HpEHCSQMYp1F0ldkmIICZjmDsY5LPiswJ3ffD2I
         nLQFufSESrEfRL4DbwUNhwdaNUX+XXPQQKWvvwhdfM9ykI6KgeUumVeUb6HV5TqMD23m
         Gs6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6gqlBqf72AAqgjEaxIk36DFKyr5wgtbH1GA7J8jPkY=;
        b=GWONXD39pCEz1yaxxhKeVVxELESSVtyz1/t5/gpi4Day5K2F8slit1lbUq8fR5kkYs
         O/i/JgeVfuOkxMpa6/99baeeCbVjfFSLvHsxUQ7zgDVCcW537Ao5kXuu7+qnf4fV8SC1
         farr1N9K9JkmDVlFIZhwh14GXyqioxPkck9cobx3FfUP+QCR/UdevLtp2/Z9NKnoL6D1
         a9wWdLDFkBgU6Hx0H4YmRB456PtqwKxFvAaZ3w7V2c8l7KKWsMsrEtZmcqbtHg9Stv/T
         gDXWYkl8X0UfYsDeDzPO6CBfnobAwAKUAZOp5Lo8uiLGvh3dcyAj841ab16l9RU87v03
         5M1w==
X-Gm-Message-State: ANoB5pnGA0+9BDuI4BQXXSOhDer2g9nfi8zi0f3aAfNo2REzjc3j4oc/
        m/cFHriWUzjs421t5fZokTuWrftfT5X7B+x4VjM=
X-Google-Smtp-Source: AA0mqf4LfJtcPztErORPP4bwHXagD9A/mQHrqvI/PDhaE/zO/e/uBlxzGq2MA/hbQA2Zwagm2GAZjuYOVtwYspHizaM=
X-Received: by 2002:a05:6830:1bec:b0:66e:7deb:b5b with SMTP id
 k12-20020a0568301bec00b0066e7deb0b5bmr285701otb.295.1669913669206; Thu, 01
 Dec 2022 08:54:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1669138256.git.lucien.xin@gmail.com> <439676c5242282638057f92dc51314df7bcd0a73.1669138256.git.lucien.xin@gmail.com>
 <Y34s/iGaTfj0DwRg@t14s.localdomain>
In-Reply-To: <Y34s/iGaTfj0DwRg@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 1 Dec 2022 11:53:43 -0500
Message-ID: <CADvbK_ehBnvUUEpDDpNy1OYyst233F0CawZzhsrVOFgnpa14vA@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 3/5] net: sched: return NF_ACCEPT when fails to
 add nat ext in tcf_ct_act_nat
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jarno Rajahalme <jarno@ovn.org>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
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

On Wed, Nov 23, 2022 at 9:24 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Tue, Nov 22, 2022 at 12:32:19PM -0500, Xin Long wrote:
> > This patch changes to return NF_ACCEPT when fails to add nat
> > ext before doing NAT in tcf_ct_act_nat(), to keep consistent
> > with OVS' processing in ovs_ct_nat().
> >
> > Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sched/act_ct.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> > index da0b7f665277..8869b3ef6642 100644
> > --- a/net/sched/act_ct.c
> > +++ b/net/sched/act_ct.c
> > @@ -994,7 +994,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
> >
> >       /* Add NAT extension if not confirmed yet. */
> >       if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> > -             return NF_DROP;   /* Can't NAT. */
> > +             return NF_ACCEPT;   /* Can't NAT. */
>
> I'm wondering if the fix should actually be in OVS, to make it drop
> the packet? Aaron, Eelco?
>
> If the user asked for NAT, and it can't NAT, it doesn't seem right to
> forward the packet while not performing the asked action.
>
> If we follow the code here, it may even commit the entry without the
> NAT extension, rendering the connection useless/broken per the first
> if condition above. It just won't try again.
nf_ct_nat_ext_add() returning NULL is caused by krealloc() failure
like an -ENOMEM error, and a similar thing could happen in
nfct_seqadj_ext_add() called by ovs_ct_nat() -> nf_nat_setup_info()
when doing NAT where it returns DROP. So I think it's right that
we should fix this in openvswitch instead of TC.

Anyway, in ovs_ct_nat():

        if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
                return NF_ACCEPT;   /* Can't NAT. */

git blame shows this was added at the beginning by:

    05752523e565 ("openvswitch: Interface with NAT.")

So add Jarno Rajahalme to Cc: list.

Thanks.

>
> >
> >       if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
> >           (ctinfo != IP_CT_RELATED || commit)) {
> > --
> > 2.31.1
> >
