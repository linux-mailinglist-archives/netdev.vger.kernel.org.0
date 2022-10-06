Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE18E5F6BF9
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 18:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiJFQuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 12:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJFQuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 12:50:14 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C194557E38
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 09:50:12 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w70so2690401oie.2
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 09:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=COxO5LnrIWzt/jw6mQyRzopKJeQXyul5IJodpgpQm8Y=;
        b=S6H/x/tg2ka0eQ2HCV0qdhVUwOlj2o7NtpPicRcoNc4nqQg640+CRyRqBxNZ5u9msy
         R9f/tBnMBcMJPZdSwDPjHMq7qGAE2FbRXkQgbC28foT+GhO/7kE9hvz/F3qy1Ts2q0Wc
         Fqpk/gPtgMXuZVod42ji11yA5dlhRfggAhsL4F3JoSrrdEf+epY0tmyZVjSRta62OIto
         i4sEJhDFXAjxX7dONm/7yq15JW8BA6C/ukkRfaXJqhKN/BYK+SeYUkd3kPbPldD2I5SO
         xQTUva7OihaDTG0Oa4gpBsvxJn8USgFNd62jrIYG9UxiAl6g4BL36QQR92feJHd0Ky0g
         CPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=COxO5LnrIWzt/jw6mQyRzopKJeQXyul5IJodpgpQm8Y=;
        b=wkJPWisIi4Txw5ofKWxot9KepR8sEd4bTg84QHfU1IrjCCpdZDsUdqmA37SH1i1rHT
         r2iqFWw6ne9fBuDrm90ZHRmK0aLmGQo6OOOzByNLUfgHVbV6Vjvl1kcMX4tCCdW9SbER
         37r1O1lUro3pT6Vkmi5/bXhFeG5+dsuFre63WiUVZ/aEMOL19jt2C3qgrjBpphBZAdJd
         z0Gq56FUZ4aeKFEy4MDn+Df6r6vS9jqJpDhrL/hn18GWpsrcih5eWKAmTtG/cR6k2xKQ
         uqCgSj1ZP+oWSo4Lp1XEXj/oYq2Q0ncQ+Tm296ulifkI8+r8VKmeYOhH/tMeAU8O5td/
         K3ZA==
X-Gm-Message-State: ACrzQf3TFoNRLJf0DYwHCEbzCh4V5JyNPzAjFoaRCjbhkxwvu5vw8QJN
        wH4OGIL4+uw2wN9+NVPrPJhpaqMGX8yrsnKDwTU=
X-Google-Smtp-Source: AMsMyM58ZhZgde9ueV7y3NHPXDP+PmwB6yXdqsFnHLnMlhyCo7/h8Rd0ocdUDXmlecus06Q4ZutHpcywEMM+rffHHXk=
X-Received: by 2002:a05:6808:15a2:b0:350:4f5c:1440 with SMTP id
 t34-20020a05680815a200b003504f5c1440mr5462264oiw.129.1665075012080; Thu, 06
 Oct 2022 09:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1664932669.git.lucien.xin@gmail.com> <bc53ffac4d6be2616d053684fb6670f478b4324b.1664932669.git.lucien.xin@gmail.com>
 <Yz7iDEjVbHrPUPT4@salvia>
In-Reply-To: <Yz7iDEjVbHrPUPT4@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 6 Oct 2022 12:49:24 -0400
Message-ID: <CADvbK_d6ZB_4uMu=t=tN9bdPxj-4D1Y_qM7FwcD8wT2HrL_2Bg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: sched: add helper support in act_ct
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
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
        Eelco Chaudron <echaudro@redhat.com>
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

On Thu, Oct 6, 2022 at 10:11 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Oct 04, 2022 at 09:19:56PM -0400, Xin Long wrote:
> [...]
> > @@ -1119,6 +1135,22 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
> >       if (err != NF_ACCEPT)
> >               goto drop;
> >
> > +     if (commit && p->helper && !nfct_help(ct)) {
> > +             err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
> > +             if (err)
> > +                     goto drop;
> > +             add_helper = true;
> > +             if (p->ct_action & TCA_CT_ACT_NAT && !nfct_seqadj(ct)) {
> > +                     if (!nfct_seqadj_ext_add(ct))
>
> You can only add ct extensions if ct is !nf_ct_is_confirmed(ct)), is
> this guaranteed in this codepath?
This is a good catch, the same issue exists on __nf_ct_try_assign_helper(),
and also in __ovs_ct_lookup().

I could trigger the warning on OVS conntrack with the flow:

table=0, in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk
actions=ct(commit, table=1)
table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
actions=ct(commit, alg=ftp),normal

I will prepare a fix for ovs conntrack first.

Thanks.

>
> > +                             return -EINVAL;
> > +             }
> > +     }
> > +
> > +     if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
> > +             if (nf_ct_helper(skb, family) != NF_ACCEPT)
> > +                     goto drop;
> > +     }
> > +
> >       if (commit) {
> >               tcf_ct_act_set_mark(ct, p->mark, p->mark_mask);
> >               tcf_ct_act_set_labels(ct, p->labels, p->labels_mask);
