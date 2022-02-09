Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FB64B0070
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbiBIWiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:38:22 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiBIWiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:38:16 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82709C1DF65E
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 14:38:18 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f32-20020a25b0a0000000b0061dad37dcd6so7804783ybj.16
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 14:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ib123V5iLfjbHcZ4PIw5eMxrsJC+gSwDpXVK3o+dB3g=;
        b=S9ncoterRMsBZv0Ny234MoaDJTDDS3NyLulE0TB3sbEpy2yvZjoBt0dxyXquO9VPLZ
         u/oB2oTPAfMp1D03l1U074OIkZBCxo0QhZNGVGzhciQm0x/FrItEwZhUSdP5JdCMF2ZT
         dwot++JnORcrakDGnFA5rRcqlmKBYeOddD/j6kO0yAiN45ECI+IOTzGfiSMqqx7Oyd9B
         +moP3fK0OO6vurQZX2i7ppdv/JPwYxgA4KTfKmtM+0p4toeF4ti8rbxSS7FbbwRr7HCY
         rYYfVsydz3ByHNwvLCdVfQ2A7YkK1z90fz/u/rDk/7K8jG0EPVMIFps13Oese/C+4yJU
         dKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ib123V5iLfjbHcZ4PIw5eMxrsJC+gSwDpXVK3o+dB3g=;
        b=GqPZshNWrK9C02qEJ0T2pYUErfms8kptMV/d7S4I961cxkfI4X8ZCamvG2f7EgJ+BV
         KBjog/SBNG+ORo9iQbSPRELwKzcDrv77WXvC6wVAbcAb9Ffs4Gu4ZHC9I9fX9ixcHKDI
         4/X/iSBCPAp91mQYf8+V4pnjCe9w22TGrX5q6ZXKGWQuViyUHLEWOqQ+aj9FplQd4Tps
         whpe5emFKWda1vnKagkoGgiNqZ1+BKKy9r9hXUKugA6T3wEre+chmNi55LUhjR0hFSWX
         4XgnV/txXbPjoSPm0KHXLW8cWwDjhgdpxJalTkDpNgkgm4yG0MLqfA8xM32cO36pJcKM
         wnxg==
X-Gm-Message-State: AOAM533cnBjFpdqrGzZgDastFyUJ/nlpZjKgolJMtUD5yZndLevarRME
        A8AG97wXPGYkH75+VW9ER1zOl84=
X-Google-Smtp-Source: ABdhPJx15MYjWWMuxTVtlE7hisOqrWbFhN/8ONrpccG5UN1JHLZpdqbiClritO5ewf/2VC8rH8XIfW4=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:4d3:1afe:7eeb:c0e6])
 (user=sdf job=sendgmr) by 2002:a25:fe07:: with SMTP id k7mr4328312ybe.589.1644446297749;
 Wed, 09 Feb 2022 14:38:17 -0800 (PST)
Date:   Wed, 9 Feb 2022 14:38:15 -0800
In-Reply-To: <CAADnVQKVes3eKcDsFp=TZXRkteMU=WdmqWvXkW7RSMARbnoqxw@mail.gmail.com>
Message-Id: <YgRCVxaYirEDudjM@google.com>
Mime-Version: 1.0
References: <YgPz8akQ4+qBz7nf@google.com> <20220209210207.dyhi6queg223tsuy@kafai-mbp.dhcp.thefacebook.com>
 <YgQ3au11pALDjyub@google.com> <CAADnVQKVes3eKcDsFp=TZXRkteMU=WdmqWvXkW7RSMARbnoqxw@mail.gmail.com>
Subject: Re: Override default socket policy per cgroup
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/09, Alexei Starovoitov wrote:
> On Wed, Feb 9, 2022 at 1:51 PM <sdf@google.com> wrote:
> >
> > On 02/09, Martin KaFai Lau wrote:
> > > On Wed, Feb 09, 2022 at 09:03:45AM -0800, sdf@google.com wrote:
> > > > Let's say I want to set some default sk_priority for all sockets in  
> a
> > > > specific cgroup. I can do it right now using cgroup/sock_create,  
> but it
> > > > applies only to AF_INET{,6} sockets. I'd like to do the same for raw
> > > > (AF_PACKET) sockets and cgroup/sock_create doesn't trigger for  
> them :-(
> > > Other than AF_PACKET and INET[6], do you have use cases for other
> > > families?
> >
> > No, I only need AF_PACKET for now. But I feel like we should create
> > a more extensible hook point this time (if we go this route).
> >
> > > > (1) My naive approach would be to add another  
> cgroup/sock_post_create
> > > > which runs late from __sock_create and triggers on everything.
> > > >
> > > > (2) Another approach might be to move BPF_CGROUP_RUN_PROG_INET_SOCK  
> and
> > > > make it work with AF_PACKET. This might be not 100% backwards  
> compatible
> > > > but I'd assume that most users should look at the socket family  
> before
> > > > doing anything. (in this case it feels like we can extend
> > > > sock_bind/release for af_packets as well, just for accounting  
> purposes,
> > > > without any way to override the target ifindex).
> > > If adding a hook at __sock_create, I think having a new
> > > CGROUP_POST_SOCK_CREATE
> > > may be better instead of messing with the current inet assumption
> > > in CGROUP_'INET'_SOCK_CREATE.  Running all CGROUP_*_SOCK_CREATE at
> > > __sock_create could be a nice cleanup such that a few lines can be
> > > removed from inet[6]_create but an extra family check will be needed.
> >
> > SG. Hopefully I can at least reuse exiting progtype and just introduce
> > new hook point in __sock_create.

> Can you take a look at what it would take to add cgroup scope
> to bpf_lsm ?
> __sock_create() already has
> security_socket_create and security_socket_post_create
> in the right places.

> bpf_lsm cannot write directly into PTR_TO_BTF_ID like the 1st 'sock'  
> pointer.
> We can whitelist the write for certain cases.
> Maybe prototype it with bpf_lsm and use
> bpf_current_task_under_cgroup() helper to limit the scope
> before implementing cgroup-scoped bpf_lsm?

> There were cases in the past where bpf_lsm hook was in the ideal
> spot, but lack of cgroup scoping was a show stopper.
> This use case is another example and motivation to extend
> what bpf can do with lsm hooks. That's better than
> adding a new bpf_cgroup hook in the same location.

Cool, if you think we can whitelist some writes in lsm/fentry that
might be a perfect solution (especially if it gets per-cgroup scope).
I'll try to look in that, thanks!
