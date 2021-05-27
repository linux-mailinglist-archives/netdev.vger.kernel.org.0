Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B454A3932DC
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhE0PwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 11:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhE0PwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 11:52:15 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198F3C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:50:42 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id q10so1091002qkc.5
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B2B3lFq+5cT52++BjnFMwPGbB+M1ri150Y3u+nX/N10=;
        b=N8fJPDkwQLJ054Q1lwHcC7aJ5H3nIbEA6Qs/RwYVipwie2stvwau6fy/qu1wtC/cAO
         azUzrW2JexM15woFr0vrgj65Mxd75WnqTlJyxSB8x/ySrntw5cNylP8oSdqLu/mVm+gs
         gq/u87ov0d+75OApXn5GX4oE9H978FgV594ELcn9ZQwpq1whkYAn35cQGFPNfams16Li
         1FfoADahJf0Dmk3lV36MggBDMWk6Ej5BfvoPZlO05QH5yN5V+ufgKUpTz3YCqnAi9t0l
         SFFlUTiY74xB4iOll+AZrnNrzkIy1QPVx1Q8Kt1I1BnqjhBoYUGbBjDE00Lct0+2ZEPF
         nGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B2B3lFq+5cT52++BjnFMwPGbB+M1ri150Y3u+nX/N10=;
        b=K21emkFU4Jrei2bFxvI58P4Vgcjyr+hEQhyxLcpGMyADnD/T3yaLGnCZ/oX1+KU1mR
         eGjkP0QW/PRA4ecU72vBrfmy4Thv6NaqReqxp5KCMPA6Ra11IsmQwUXCYAZ1RsemiRZH
         TGZzfT6/F99hQoOB0nbsM7WdbmopjmlLlwxy/+MJfrPNIliakVBeTy6+znuYtmgEWidI
         VJiMk9yJ6sAfArE5ozKkkRcT47pcdMMEtKCbshzcPsGr72UJyRpKSMyCJatnlfdotSMf
         LAPXQi/K/zMdQBmq1Sp80QAZoopoVKog8Of5Vz2eFVPuLLc8tygzmJ60folWlMv1RsAz
         tMJw==
X-Gm-Message-State: AOAM532+HnRx1C7AnJg9JWuNejANAuQyHFPrZHnPGq0lXrf6aOKAlc/Q
        T+QlpqmkXNkt2ST5VFVJ3Wc=
X-Google-Smtp-Source: ABdhPJx+3+LO/i5IQOS1E9550AvCsnLgYIObTRimOgqZDGrvRJwBlUmvqjHctiuj3ov5PZhb2egavQ==
X-Received: by 2002:a37:7306:: with SMTP id o6mr4318840qkc.38.1622130641163;
        Thu, 27 May 2021 08:50:41 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:c858:4e88:b1d7:83be:b613])
        by smtp.gmail.com with ESMTPSA id p10sm1591245qkg.74.2021.05.27.08.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 08:50:40 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 169E0C169D; Thu, 27 May 2021 12:50:38 -0300 (-03)
Date:   Thu, 27 May 2021 12:50:38 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Ariel Levkovich <lariel@nvidia.com>
Cc:     netdev@vger.kernel.org, paulb@nvidia.com, jiri@resnulli.us
Subject: Re: [PATCH net] net/sched: act_ct: Fix ct template allocation for
 zone 0
Message-ID: <YK+/zn0R+M4lYfC+@horizon.localdomain>
References: <20210526170110.54864-1-lariel@nvidia.com>
 <YK76nZpfTBO904lU@horizon.localdomain>
 <021dab3f-9ca3-ffeb-b18a-24c9207a7000@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <021dab3f-9ca3-ffeb-b18a-24c9207a7000@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 11:36:18AM -0400, Ariel Levkovich wrote:
> 
> On 5/26/21 9:49 PM, Marcelo Ricardo Leitner wrote:
> > On Wed, May 26, 2021 at 08:01:10PM +0300, Ariel Levkovich wrote:
> > > Fix current behavior of skipping template allocation in case the
> > > ct action is in zone 0.
> > > 
> > > Skipping the allocation may cause the datapath ct code to ignore the
> > > entire ct action with all its attributes (commit, nat) in case the ct
> > > action in zone 0 was preceded by a ct clear action.
> > > 
> > > The ct clear action sets the ct_state to untracked and resets the
> > > skb->_nfct pointer. Under these conditions and without an allocated
> > > ct template, the skb->_nfct pointer will remain NULL which will
> > > cause the tc ct action handler to exit without handling commit and nat
> > > actions, if such exist.
> > > 
> > > For example, the following rule in OVS dp:
> > > recirc_id(0x2),ct_state(+new-est-rel-rpl+trk),ct_label(0/0x1), \
> > > in_port(eth0),actions:ct_clear,ct(commit,nat(src=10.11.0.12)), \
> > > recirc(0x37a)
> > > 
> > > Will result in act_ct skipping the commit and nat actions in zone 0.
> > > 
> > > The change removes the skipping of template allocation for zone 0 and
> > > treats it the same as any other zone.
> > > 
> > > Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> > > Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
> > > ---
> > >   net/sched/act_ct.c | 3 ---
> > Hah! I guess I had looked only at netfilter code regarding
> > NF_CT_DEFAULT_ZONE_ID.
> > 
> > >   1 file changed, 3 deletions(-)
> > > 
> > > diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> > > index ec7a1c438df9..dfdfb677e6a9 100644
> > > --- a/net/sched/act_ct.c
> > > +++ b/net/sched/act_ct.c
> > > @@ -1202,9 +1202,6 @@ static int tcf_ct_fill_params(struct net *net,
> > >   				   sizeof(p->zone));
> > >   	}
> > > -	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
> > > -		return 0;
> > > -
> > This patch makes act_ct behave like ovs kernel datapath, but I'm not
> > sure ovs kernel is doing the right thing. :-) (jump to last paragraph
> > for my suggestion, might ease the reading)
> > 
> > As you described:
> > "The ct clear action sets the ct_state to untracked and resets the
> > skb->_nfct pointer." I think the problem lies on the first part, on
> > setting it to untracked.
> > 
> > That was introduced in ovs kernel on commit b8226962b1c4
> > ("openvswitch: add ct_clear action") and AFAICT the idea there was to
> > "reset it to original state" [A].
> > 
> > Then ovs userspace has commit 0cdfddddb664 ("datapath: add ct_clear
> > action") as well, a mirror of the one above. There, it is noted:
> > "   - if IP_CT_UNTRACKED is not available use 0 as other nf_ct_set()
> >       calls do. Since we're setting ct to NULL this is okay."
> > 
> > Thing is, IP_CT_ESTABLISHED is the first member of enum
> > ip_conntrack_info and evalutes 0, while IP_CT_UNTRACKED is actually:
> > include/uapi/linux/netfilter/nf_conntrack_common.h:
> >          /* only for userspace compatibility */
> > #ifndef __KERNEL__
> >          IP_CT_NEW_REPLY = IP_CT_NUMBER,
> > #else
> >          IP_CT_UNTRACKED = 7,
> > #endif
> > 
> > In the commits above, none of them mention that the packet should be
> > set to Untracked. That's a different thing than "undoing CT"..
> > That setting untrack here is the equivalent of:
> >    # iptables -A ... -j CT --notrack
> > 
> > Then, when it finally reaches nf_conntrack_in:
> >            tmpl = nf_ct_get(skb, &ctinfo);
> > 	      vvvv--- NULL if from act_ct and zone 0, !NULL if from ovs
> >            if (tmpl || ctinfo == IP_CT_UNTRACKED) {
> > 	                     ^^-- always true after ct_clear
> >                    /* Previously seen (loopback or untracked)?  Ignore. */
> >                    if ((tmpl && !nf_ct_is_template(tmpl)) ||
> >                         ctinfo == IP_CT_UNTRACKED)
> > 		              ^^--- always true..
> >                            return NF_ACCEPT;
> > 			  ^^ returns her
> >                    skb->_nfct = 0;
> >            }
> > 
> > If ct_clear (act_ct and ovs) instead set it 0 (which, well, it's odd
> > but maps to IP_CT_ESTABLISHED), it wouldn't match on the conditions
> > above, and would do CT normally.
> > 
> > With all that, what about keeping the check here, as it avoids an
> > allocation that AFAICT is superfluous when not setting a zone != 0 and
> > atomics for _get/_put, and changing ct_clear instead (act_ct and ovs),
> > to NOT set the packet as IP_CT_UNTRACKED?
> > 
> > Thanks,
> > Marcelo
> 
> I understand your point. But if we go in this path, that means going into
> zone 0,
> 
> skb will not be associated with zone 0 unless there was a ct_clear action
> prior to that.
> 
> skb->_nfct will carry the pointer from previous zone. I see several
> scenarios where this will
> 
> be problematic.

I don't follow why. When the skb is created, skb->_nfct is "entirely NULL",
right? Done by the memset() on __alloc_skb().

Then,

@@ -950,7 +950,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
                ct = nf_ct_get(skb, &ctinfo);
                if (ct) {
                        nf_conntrack_put(&ct->ct_general);
-                       nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+                       nf_ct_set(skb, NULL, 0);
                }

                goto out_clear;

would restore it to that state and not have a pointer to the previous
zone in skb->_nfct.

Thanks,
  Marcelo

> 
> 
> Thanks,
> 
> Ariel
> 
> > 
> > >   	nf_ct_zone_init(&zone, p->zone, NF_CT_DEFAULT_ZONE_DIR, 0);
> > >   	tmpl = nf_ct_tmpl_alloc(net, &zone, GFP_KERNEL);
> > >   	if (!tmpl) {
> > > -- 
> > > 2.25.2
> > > 
