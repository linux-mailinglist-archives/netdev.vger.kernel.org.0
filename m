Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88878223100
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 04:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgGQCFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 22:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgGQCFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 22:05:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0B4C061755;
        Thu, 16 Jul 2020 19:05:13 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id 72so4766343ple.0;
        Thu, 16 Jul 2020 19:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=o8T/zCdEaD4JKmsGvJdDUYbUsp9sExzVX1p/J/0Eg8s=;
        b=NrwOiTb+C6iJu/kJQqKnxzCT1oGKsTH/3v4XNjLbNyC8Y8YaahND902AVozJYVz5r8
         eEwy0S59r7FinvTizBLLw0aQSiln0os41t3JHT67rjyFkVsdm3gUN9MnZEtw4dXhHTwE
         EJI4B7+1/WLCM4XUumhJmCWhOGBHOoE80an6Fl6MQZonC16v6Xxba6xwd423tqmUQrvB
         Op8AeoTdH2LbDeDqg/MLCIK7OdSoroeQGnEIpijfoWKyiUMLE8XqHRvp1AiLtTIvJL4l
         nb0wTI88anUQcJdP36/jmc33tShkOSKT91E6iPu/rdbl/IXADlRgZItSAkw25UodREJ3
         TW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=o8T/zCdEaD4JKmsGvJdDUYbUsp9sExzVX1p/J/0Eg8s=;
        b=U5CZJaiClS+YOtS4oCykAY9vPjIOHXlUyPUOa/99eRXYfgzuhPCLFcheNpvg1udAkQ
         XfU/wRlQ5X89stFep37uyh5YDMUDiX7oOSvotxZMJkn87hdtEzoYSgDElbGLyhZxpu56
         unkCFifhm7ElL+wmUtY7qOuMH8PbAoe+MI9pvOxyNPnlXLzmyx65RkRWWFAczby/XFBZ
         ALao8ygbx9TQBiz6nu1KhW0EQlDTnxwEgy3oD8dMBNM+ZjpNlCgiXtftdhbxW37N83dI
         etxRw05QHO2P4yZDwviKrfgrTbgtsSg3oksOUkI03b5voGkUEN8gmV1N6oaA6bDuVdPf
         6Vpw==
X-Gm-Message-State: AOAM531rk2SS6GI/ExnqiGvF9+T/6WUb41sxfNWJU8YiDxZEEqdViLeu
        +fJLoonVe56DTNkq6TQZ8vM=
X-Google-Smtp-Source: ABdhPJyhS3wKoh3B9AeTBwCak6T9Q64BatYIPJjuH95H6S8SKkr6lgQN5UbNeBsm3h4jRN0pw6U4tg==
X-Received: by 2002:a17:90a:db17:: with SMTP id g23mr8006332pjv.180.1594951512206;
        Thu, 16 Jul 2020 19:05:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id k189sm5944123pfd.175.2020.07.16.19.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 19:05:10 -0700 (PDT)
Date:   Thu, 16 Jul 2020 19:05:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs
 to multiple attach points
Message-ID: <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk>
 <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mu3zentu.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 12:50:05PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Wed, Jul 15, 2020 at 03:09:02PM +0200, Toke HÃƒÂ¸iland-JÃƒÂ¸rgensen wrote:
> >>  
> >> +	if (tgt_prog_fd) {
> >> +		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
> >> +		if (prog->type != BPF_PROG_TYPE_EXT ||
> >> +		    !btf_id) {
> >> +			err = -EINVAL;
> >> +			goto out_put_prog;
> >> +		}
> >> +		tgt_prog = bpf_prog_get(tgt_prog_fd);
> >> +		if (IS_ERR(tgt_prog)) {
> >> +			err = PTR_ERR(tgt_prog);
> >> +			tgt_prog = NULL;
> >> +			goto out_put_prog;
> >> +		}
> >> +
> >> +	} else if (btf_id) {
> >> +		err = -EINVAL;
> >> +		goto out_put_prog;
> >> +	} else {
> >> +		btf_id = prog->aux->attach_btf_id;
> >> +		tgt_prog = prog->aux->linked_prog;
> >> +		if (tgt_prog)
> >> +			bpf_prog_inc(tgt_prog); /* we call bpf_prog_put() on link release */
> >
> > so the first prog_load cmd will beholding the first target prog?
> > This is complete non starter.
> > You didn't mention such decision anywhere.
> > The first ext prog will attach to the first dispatcher xdp prog,
> > then that ext prog will multi attach to second dispatcher xdp prog and
> > the first dispatcher prog will live in the kernel forever.
> 
> Huh, yeah, you're right that's no good. Missing that was a think-o on my
> part, sorry about that :/
> 
> > That's not what we discussed back in April.
> 
> No, you mentioned turning aux->linked_prog into a list. However once I
> started looking at it I figured it was better to actually have all this
> (the trampoline and ref) as part of the bpf_link structure, since
> logically they're related.
> 
> But as you pointed out, the original reference sticks. So either that
> needs to be removed, or I need to go back to the 'aux->linked_progs as a
> list' idea. Any preference?

Good question. Back then I was thinking about converting linked_prog into link
list, since standalone single linked_prog is quite odd, because attaching ext
prog to multiple tgt progs should have equivalent properties across all
attachments.
Back then bpf_link wasn't quite developed.
Now I feel moving into bpf_tracing_link is better.
I guess a link list of bpf_tracing_link-s from 'struct bpf_prog' might work.
At prog load time we can do bpf_link_init() only (without doing bpf_link_prime)
and keep this pre-populated bpf_link with target bpf prog and trampoline
in a link list accessed from 'struct bpf_prog'.
Then bpf_tracing_prog_attach() without extra tgt_prog_fd/btf_id would complete
that bpf_tracing_link by calling bpf_link_prime() and bpf_link_settle()
without allocating new one.
Something like:
struct bpf_tracing_link {
        struct bpf_link link;  /* ext prog pointer is hidding in there */
        enum bpf_attach_type attach_type;
        struct bpf_trampoline *tr;
        struct bpf_prog *tgt_prog; /* old aux->linked_prog */
};

ext prog -> aux -> link list of above bpf_tracing_link-s

It's a circular reference, obviously.
Need to think through the complications and locking.

bpf_tracing_prog_attach() with tgt_prog_fd/btf_id will alloc new bpf_tracing_link
and will add it to a link list.

Just a rough idea. I wonder what Andrii thinks.

> 
> >> +	}
> >> +	err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
> >> +				      &fmodel, &addr, NULL, NULL);
> >
> > This is a second check for btf id match?
> > What's the point? The first one was done at load time.
> > When tgt_prog_fd/tgt_btf_id are zero there is no need to recheck.
> 
> It's not strictly needed if tgt_prog/btf_id is not set, but it doesn't
> hurt either; and it was convenient to reuse it to resolve the func addr
> for the trampoline + it means everything goes through the same code path.

Doing the same work twice is a sign that this function needs to split
into more than 3 helpers, so the work is not repeated.

> 
> > I really hope I'm misreading these patches, because they look very raw.
> 
> I don't think you are. I'll admit to them being a bit raw, but this was
> as far as I got and since I'll be away for three weeks I figured it was
> better to post them in case anyone else was interested in playing with
> it.

Since it was v2 I figured you want it to land and it's ready.
Next time please mention the state of patches.
It's absolutely fine to post raw patches. It's fine to post stuff
that doesn't compile. But please explain the state in commit logs or cover.
