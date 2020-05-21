Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306011DC45E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgEUA4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgEUA4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:56:49 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C20C061A0E;
        Wed, 20 May 2020 17:56:49 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m7so2098400plt.5;
        Wed, 20 May 2020 17:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b3MSuX5qcaUy8dMCkMr9QUS5UB4B3vsYNtwNYi9VcCE=;
        b=YfkmPJZaQ1EEnsDpU2vTMvMymcW1fxHoI485ugt9wQVmi17XSaf9zM/T3fOKuOOsOl
         dq5ozZ/2lsaZgWxq7fXT9W5koyhQvHC6sObZfujFU50aB6FxgfuLD9gsKRauCByQuujh
         kzHNXnf951UGALHShHEX+xpXgmYZk10fCmb8+RvHIaomnrITJ3rUBicIHLi1HI57dhuN
         x0mdL61BrrEC2QH0wNFTAelxSNolfsezYh+0PakWJJpuyZdNVyOlgSI0DbJ1a8UFsmyk
         3L80IE9+QcC/ER88FxEOp8nTZztcCl2xnM7Rm57w4F/5bvtS1mezbQ+7tmE+jgFGF/Wq
         V6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b3MSuX5qcaUy8dMCkMr9QUS5UB4B3vsYNtwNYi9VcCE=;
        b=ek0A5Mlj2F9cXZ+Krb2BQiT5Syvs5LGdCCZwix+MwSbd616XkJEIYAiVp02e9mTEo5
         jhGLIRZZ86PLPaj7Et/pY9IjCTu4pe1iXBpux0cqj48YIJAqxBfgaxbJN60+nosFc21+
         q1Jn43SyywUavSUN1VTuhuI+rQagKzfftW+P7YX+Trp/8sGPjuCgvP3rMztJ5gg1yqkw
         cTIyyJbkxWplumPs2LZnHa9c9Se4swGIuuWy08oVQYZuD5IRyswRkrrwIv4xERUDDo8z
         PQ0a8a5v+405JRFjm/k5CzdTeDdujdAvWJImSCrPaefLRdHPGfrSd/99y7lQPcau9h57
         /uLg==
X-Gm-Message-State: AOAM533jyQOZKJvFJu69UJzLPOImcbRbtOS5nftMAaTYrNiLmbYPM83z
        vakD7OSRyfLPOWYLsyfOnh6Qv/wO
X-Google-Smtp-Source: ABdhPJytduYlNGRgDWvA0jtGV06dYj3dodl/QWIr8ccfYsclDSz5aCGf62Q3QqOK/y8QNtMYo0J6GQ==
X-Received: by 2002:a17:90a:4b47:: with SMTP id o7mr6881203pjl.205.1590022608954;
        Wed, 20 May 2020 17:56:48 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id e13sm2743597pfh.19.2020.05.20.17.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 17:56:48 -0700 (PDT)
Date:   Wed, 20 May 2020 17:56:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     sdf@google.com
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf] flow_dissector: Drop BPF flow dissector prog ref on
 netns cleanup
Message-ID: <20200521005646.zex2l2vglcrx67hu@ast-mbp.dhcp.thefacebook.com>
References: <20200520172258.551075-1-jakub@cloudflare.com>
 <20200520174000.GA49942@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520174000.GA49942@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 10:40:00AM -0700, sdf@google.com wrote:
> On 05/20, Jakub Sitnicki wrote:
> > When attaching a flow dissector program to a network namespace with
> > bpf(BPF_PROG_ATTACH, ...) we grab a reference to bpf_prog.
> 
> > If netns gets destroyed while a flow dissector is still attached, and
> > there
> > are no other references to the prog, we leak the reference and the program
> > remains loaded.
> 
> > Leak can be reproduced by running flow dissector tests from selftests/bpf:
> 
> >    # bpftool prog list
> >    # ./test_flow_dissector.sh
> >    ...
> >    selftests: test_flow_dissector [PASS]
> >    # bpftool prog list
> >    4: flow_dissector  name _dissect  tag e314084d332a5338  gpl
> >            loaded_at 2020-05-20T18:50:53+0200  uid 0
> >            xlated 552B  jited 355B  memlock 4096B  map_ids 3,4
> >            btf_id 4
> >    #
> 
> > Fix it by detaching the flow dissector program when netns is going away.
> 
> > Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> 
> > Discovered while working on bpf_link support for netns-attached progs.
> > Looks like bpf tree material so pushing it out separately.
> Oh, good catch!

Good catch indeed!

> 
> > -jkbs
> 
> >   net/core/flow_dissector.c | 29 ++++++++++++++++++++++++++++-
> >   1 file changed, 28 insertions(+), 1 deletion(-)
> 
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 3eff84824c8b..b6179cd20158 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -179,6 +179,27 @@ int skb_flow_dissector_bpf_prog_detach(const union
> > bpf_attr *attr)
> >   	return 0;
> >   }
> 
> > +static void __net_exit flow_dissector_pernet_pre_exit(struct net *net)
> > +{
> > +	struct bpf_prog *attached;
> > +
> > +	/* We don't lock the update-side because there are no
> > +	 * references left to this netns when we get called. Hence
> > +	 * there can be no attach/detach in progress.
> > +	 */
> > +	rcu_read_lock();
> > +	attached = rcu_dereference(net->flow_dissector_prog);
> > +	if (attached) {
> > +		RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
> > +		bpf_prog_put(attached);
> > +	}
> > +	rcu_read_unlock();
> > +}
> I wonder, should we instead refactor existing
> skb_flow_dissector_bpf_prog_detach to accept netns (instead of attr)
> can call that here? Instead of reimplementing it (I don't think we
> care about mutex lock/unlock efficiency here?). Thoughts?

Agree. Would be good to share that bit of code.
