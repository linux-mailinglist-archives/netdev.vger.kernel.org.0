Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BCF4B001E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiBIW0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:26:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbiBIW0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:26:02 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2FBDF28A66;
        Wed,  9 Feb 2022 14:26:04 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j4so176495plj.8;
        Wed, 09 Feb 2022 14:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4dNHW4tpxBvXPWZnL5sCZ8U5aYka6vht5SmsbV4tumY=;
        b=bACtZzVfc0CrmRFmpIMHjt4J4pWr1u55BXfG+7o+a0laPtH2QJSKd4qsRnpenYh144
         9iT3+1HeuaoJjkbwOO4/EAFcleMa8CoAAzjgj01c1TSOltLDEzKkEjwoHHUx61N0lqoZ
         hxU/7iIrfmKRvMiII68xxpSYsT2Ei8J4OhGPkYf9FleF1L+/+RL16Rk9t1FuGF0WVEtA
         ACBDcLZt4jrGVew+hOoPSqr22of9oppgeS4lotkrdCfIxXr85fIlojZRdb2FE/Z2mZss
         7v1oJPDjr2VD1F0fpEN2sP8h8YClJOF92OqWZCBQHqWngLt4afv3i0DJPJ5HSqFq9/14
         W3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4dNHW4tpxBvXPWZnL5sCZ8U5aYka6vht5SmsbV4tumY=;
        b=LOl8bWKj7eeN9e0x+2UYp0gzkLbCZErRTF+kHFebEgEGErDCC5h/Icf8mCPrsRZ8G0
         BbgqBZDXea+aNhTyPEOJIGLg41BEMYk+fH5K176NlNlwmI8DJHGZu8MyBFZkDQSNQQS/
         KhIzE0ETkEi68OJMW8Ei+VercaGaZuWif4II7uVTI5zSi9ivOkwbzDm/Jh/OZtXnme2u
         kOf7zLsyDNEhQBPRBcOCxO1nQE5MifBn9c+0kt6lsMp+DUJpxStlEqBJYVeuJTkpMZ69
         a+j4K2mdZV2P9RHfGYEYhsME48vk69PgV18CIgKMMtBMwAuxWSJ2BGsonScTjVNalVrX
         nMRw==
X-Gm-Message-State: AOAM533oEKlc1u+ak9vlvXGq/rfULdNLSknzCtZC8xXUDmFA1pFhR9UN
        F9/jJQkxF0q3q5hh+8IpuAtVYLpEa31yrp6zQW4=
X-Google-Smtp-Source: ABdhPJzpxPjkL7xftOLRWEV4hqgMO5cA90ZjicAGos41l5LyxiY/ECZxXBNCMrHDbWShz/zj3OfW7qfT2kYYAODBxkQ=
X-Received: by 2002:a17:90b:4ac6:: with SMTP id mh6mr5065544pjb.138.1644445564033;
 Wed, 09 Feb 2022 14:26:04 -0800 (PST)
MIME-Version: 1.0
References: <YgPz8akQ4+qBz7nf@google.com> <20220209210207.dyhi6queg223tsuy@kafai-mbp.dhcp.thefacebook.com>
 <YgQ3au11pALDjyub@google.com>
In-Reply-To: <YgQ3au11pALDjyub@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Feb 2022 14:25:52 -0800
Message-ID: <CAADnVQKVes3eKcDsFp=TZXRkteMU=WdmqWvXkW7RSMARbnoqxw@mail.gmail.com>
Subject: Re: Override default socket policy per cgroup
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 1:51 PM <sdf@google.com> wrote:
>
> On 02/09, Martin KaFai Lau wrote:
> > On Wed, Feb 09, 2022 at 09:03:45AM -0800, sdf@google.com wrote:
> > > Let's say I want to set some default sk_priority for all sockets in a
> > > specific cgroup. I can do it right now using cgroup/sock_create, but it
> > > applies only to AF_INET{,6} sockets. I'd like to do the same for raw
> > > (AF_PACKET) sockets and cgroup/sock_create doesn't trigger for them :-(
> > Other than AF_PACKET and INET[6], do you have use cases for other
> > families?
>
> No, I only need AF_PACKET for now. But I feel like we should create
> a more extensible hook point this time (if we go this route).
>
> > > (1) My naive approach would be to add another cgroup/sock_post_create
> > > which runs late from __sock_create and triggers on everything.
> > >
> > > (2) Another approach might be to move BPF_CGROUP_RUN_PROG_INET_SOCK and
> > > make it work with AF_PACKET. This might be not 100% backwards compatible
> > > but I'd assume that most users should look at the socket family before
> > > doing anything. (in this case it feels like we can extend
> > > sock_bind/release for af_packets as well, just for accounting purposes,
> > > without any way to override the target ifindex).
> > If adding a hook at __sock_create, I think having a new
> > CGROUP_POST_SOCK_CREATE
> > may be better instead of messing with the current inet assumption
> > in CGROUP_'INET'_SOCK_CREATE.  Running all CGROUP_*_SOCK_CREATE at
> > __sock_create could be a nice cleanup such that a few lines can be
> > removed from inet[6]_create but an extra family check will be needed.
>
> SG. Hopefully I can at least reuse exiting progtype and just introduce
> new hook point in __sock_create.

Can you take a look at what it would take to add cgroup scope
to bpf_lsm ?
__sock_create() already has
security_socket_create and security_socket_post_create
in the right places.

bpf_lsm cannot write directly into PTR_TO_BTF_ID like the 1st 'sock' pointer.
We can whitelist the write for certain cases.
Maybe prototype it with bpf_lsm and use
bpf_current_task_under_cgroup() helper to limit the scope
before implementing cgroup-scoped bpf_lsm?

There were cases in the past where bpf_lsm hook was in the ideal
spot, but lack of cgroup scoping was a show stopper.
This use case is another example and motivation to extend
what bpf can do with lsm hooks. That's better than
adding a new bpf_cgroup hook in the same location.
