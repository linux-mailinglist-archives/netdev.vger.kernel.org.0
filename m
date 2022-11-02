Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC80A616E49
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiKBUHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiKBUHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:07:34 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED18E7A
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 13:07:33 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-13c569e5ff5so21132968fac.6
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 13:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BzEvbKhLInkSI50uyZV3GyWWfM7OoBWy5VYPEPSm6fA=;
        b=k5W5MbWxeLUPIaE9NlNiQGAN6yM7TyrhRrk0TdEBatkI1GzMsGI6COoFfOte87mlX3
         K/Sh4DdbmwY+3w7gs9boHwQ21cEdjvmsZfRrtIHyOqJ0JFViEx2BtihByJldOFFwej6N
         sFEPHHm0QOBYX8Xb7uIRucva1kvHPmtFTE0/Ecb/WzuY46uveIGOrXNrqWbYoqi2O7ri
         hH+I0hqSJB10QWgTUKzd8mLNlyRaNbuRICb/WSJpUNDYAH3ioCvsceeG7J1mkK+9NKeg
         KRFzksSY3nN0KTiT9/OxNda8lRW5/iZpVAsgMOTFht89sdT750WfwQ9ZBowAFN/x/Dip
         WVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BzEvbKhLInkSI50uyZV3GyWWfM7OoBWy5VYPEPSm6fA=;
        b=a3kCiB/81e/kuZ3Lglmju8k/KGU1izX7nD0TxRf9RoFlb6tmDi4ESRZDpEAvmZfA4u
         h4uUeluPG3QCnsaH3C5ZRUPKNxCqpgD6zPkkEJEdf3eAUsEOCrQTtTEp5Dp6TSiO2/Zz
         1k6Q/T+s8G80kaGI5TvqwPn5urD8967RtFVPOzEbiVDNUUUJGZuect70Bcg2XhbEq+1r
         UAcxeMWiFflWR3F3tUmo6cTl5yr0gPdNdaGB6pnsbXrwb+2NMUmDzDIDKY60GOGVqDr0
         Htf//6TLUQ74MvMxY0KkHU04q5RWjJOHpsrEQcRBVQXa4698jGXjAJndzJ2sQ8oG68bA
         jTUQ==
X-Gm-Message-State: ACrzQf2iFaB4MdBdv2Rsu72HgWnC/VZZCItXYyScqNFMIkMFBkl9vbpz
        yY/vm3apbD9ze+zST/BgEhO/JPSXipV/MTNBbbg=
X-Google-Smtp-Source: AMsMyM7TAiBkAk2Rh/iA4x1Is3a6/F+EoWg+SSDr5+AsoIgKvV5XywcNbi4iczMvIqs3BBhfAg7yBMK+PxHRcnpHIKo=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr25698140oaq.190.1667419652745; Wed, 02
 Nov 2022 13:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1667230381.git.lucien.xin@gmail.com> <4ce649629cc4c5bebe49fdd48a3cf5497a4489fa.1667230381.git.lucien.xin@gmail.com>
 <20221101150031.a6rtrgzwfd7kzknn@t14s.localdomain>
In-Reply-To: <20221101150031.a6rtrgzwfd7kzknn@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 2 Nov 2022 16:07:09 -0400
Message-ID: <CADvbK_dcTAPZ_LDDsWUCaVZ=sxSshpANR80N41LukDr-nftSUA@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCHv3 net-next 4/4] net: sched: add helper support
 in act_ct
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, Jiri Pirko <jiri@resnulli.us>,
        Paul Blakey <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
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

On Tue, Nov 1, 2022 at 11:00 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Oct 31, 2022 at 11:36:10AM -0400, Xin Long wrote:
> ...
> > --- a/net/sched/act_ct.c
> > +++ b/net/sched/act_ct.c
> > @@ -33,6 +33,7 @@
> >  #include <net/netfilter/nf_conntrack_acct.h>
> >  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
> >  #include <net/netfilter/nf_conntrack_act_ct.h>
> > +#include <net/netfilter/nf_conntrack_seqadj.h>
> >  #include <uapi/linux/netfilter/nf_nat.h>
> >
> >  static struct workqueue_struct *act_ct_wq;
> > @@ -655,7 +656,7 @@ struct tc_ct_action_net {
> >
> >  /* Determine whether skb->_nfct is equal to the result of conntrack lookup. */
> >  static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
> > -                                u16 zone_id, bool force)
> > +                                struct tcf_ct_params *p, bool force)
>
> Nit, it could have fetched 'force' from p->ct_action too then, as it
> is only used in this function.
right, we can save one variable here.

>
> There's a typo in Ilya's name in the cover letter.
Ah sorry, it was a letter missed when copying from the last cover.

>
> Other than this, LGTM.
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Thanks!
