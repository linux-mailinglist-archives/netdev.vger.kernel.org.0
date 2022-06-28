Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7401E55E74E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiF1QUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbiF1QUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:20:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345543AA75
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DED29B81F15
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 16:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FC3C341D6
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656432757;
        bh=EIP5j5pZ7wbFNo8siwNKuft7SrlYIU0lHe3T+ppJNCY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RthYxAUpkMhtCPVpjqK/2tyQbKXMLwVyHDoez99UtKDcFb4i7v/gA+J0j79uGS05+
         JmBwd5N8KOjpUWYgdyPSEcR9LDD4l4m5LDMxFXzIVFYP81P/+k9gYmetUTpowsrObO
         swu7ITNGRhlx3cW8/JVzyWwoJZ7qipXr7+YPZkMHKjFB32WNM8n+wc78dcfwsohPhp
         zFf06R5P+++x/7X7p6mwEvht4NCmX4EIurJINw0Z7A6Xqh5jebH0IjlwuQWR0Fy/MS
         CukYIpGb9G+tBIEa0P7mqUUfmNf/8s4bK/GhrfEfxiju9wLSpPMS+KaqLFT7QtJkf8
         yDYVUCsB4z/mA==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-31772f8495fso122309977b3.4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:12:37 -0700 (PDT)
X-Gm-Message-State: AJIora+KOuG78zrpjyiP3c/xPjeAoKqp7NiwfX3J7Xv6xpQ/lUVxkn3v
        BdA41FOEF9zKibO3FYuRyYwEQNhHzXLXUYEhAg9/6A==
X-Google-Smtp-Source: AGRyM1tAQfsb70s3aJIgwOAS2pkRUBhwPFRBswHFom3lZRvCVZ4Ufl+bfM0XenuZWxEdN1dwZ1aAvc0cdAEfPtaF0a8=
X-Received: by 2002:a81:1b4b:0:b0:317:a2dd:31fa with SMTP id
 b72-20020a811b4b000000b00317a2dd31famr22481892ywb.476.1656432756482; Tue, 28
 Jun 2022 09:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220621233939.993579-1-fred@cloudflare.com> <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com> <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein> <CAHC9VhSQH9tE-NgU6Q-GLqSy7R6FVjSbp4Tc4gVTbjZCqAWy5Q@mail.gmail.com>
 <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net> <CAHC9VhQQJH95jTWMOGDB4deS=whSfnaF_e73zoabOOeHJMv+0Q@mail.gmail.com>
 <685096bb-af0a-08c0-491a-e176ac009e85@schaufler-ca.com> <9ae473c4-cd42-bb45-bce2-8aa2e4784a43@cloudflare.com>
 <d70d3b2d-6c3f-b1fc-f40c-f5ec01a627c0@schaufler-ca.com>
In-Reply-To: <d70d3b2d-6c3f-b1fc-f40c-f5ec01a627c0@schaufler-ca.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 28 Jun 2022 18:12:25 +0200
X-Gmail-Original-Message-ID: <CACYkzJ6GmotfhBk1+9BjGC6Ct7bGxQGVTZTX2iQcrhjfV7VHwQ@mail.gmail.com>
Message-ID: <CACYkzJ6GmotfhBk1+9BjGC6Ct7bGxQGVTZTX2iQcrhjfV7VHwQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        Paul Moore <paul@paul-moore.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Christian Brauner <brauner@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 6:02 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> On 6/28/2022 8:14 AM, Frederick Lawler wrote:
> > On 6/27/22 6:18 PM, Casey Schaufler wrote:
> >> On 6/27/2022 3:27 PM, Paul Moore wrote:
> >>> On Mon, Jun 27, 2022 at 6:15 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>>> On 6/27/22 11:56 PM, Paul Moore wrote:
> >>>>> On Mon, Jun 27, 2022 at 8:11 AM Christian Brauner <brauner@kernel.org> wrote:
> >>>>>> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
> >>>>> ...
> >>>>>
> >>>>>>> This is one of the reasons why I usually like to see at least one LSM
> >>>>>>> implementation to go along with every new/modified hook.  The
> >>>>>>> implementation forces you to think about what information is necessary
> >>>>>>> to perform a basic access control decision; sometimes it isn't always
> >>>>>>> obvious until you have to write the access control :)
> >>>>>> I spoke to Frederick at length during LSS and as I've been given to
> >>>>>> understand there's a eBPF program that would immediately use this new
> >>>>>> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
> >>>>>> infrastructure an LSM" but I think we can let this count as a legitimate
> >>>>>> first user of this hook/code.
> >>>>> Yes, for the most part I don't really worry about the "is a BPF LSM a
> >>>>> LSM?" question, it's generally not important for most discussions.
> >>>>> However, there is an issue unique to the BPF LSMs which I think is
> >>>>> relevant here: there is no hook implementation code living under
> >>>>> security/.  While I talked about a hook implementation being helpful
> >>>>> to verify the hook prototype, it is also helpful in providing an
> >>>>> in-tree example for other LSMs; unfortunately we don't get that same
> >>>>> example value when the initial hook implementation is a BPF LSM.
> >>>> I would argue that such a patch series must come together with a BPF
> >>>> selftest which then i) contains an in-tree usage example, ii) adds BPF
> >>>> CI test coverage. Shipping with a BPF selftest at least would be the
> >>>> usual expectation.
> >>> I'm not going to disagree with that, I generally require matching
> >>> tests for new SELinux kernel code, but I was careful to mention code
> >>> under 'security/' and not necessarily just a test implementation :)  I
> >>> don't want to get into a big discussion about it, but I think having a
> >>> working implementation somewhere under 'security/' is more
> >>> discoverable for most LSM folks.
> >>
> >> I agree. It would be unfortunate if we added a hook explicitly for eBPF
> >> only to discover that the proposed user needs something different. The
> >> LSM community should have a chance to review the code before committing
> >> to all the maintenance required in supporting it.
> >>
> >> Is there a reference on how to write an eBPF security module?
> >
> > There's a documentation page that briefly touches on a BPF LSM implementation [1].
>
> That's a brief touch, alright. I'll grant that the LSM interface isn't
> especially well documented for C developers, but we have done tutorials
> and have multiple examples. I worry that without an in-tree example for
> eBPF we might well be setting developers up for spectacular failure.
>

Casey, Daniel and I are recommending an in-tree example, it will be
in BPF selftests and we will CC you on the reviews.

Frederick, is that okay with you?

> >
> >> There should be something out there warning the eBPF programmer of the
> >> implications of providing a secid_to_secctx hook for starters.
> >>
> >
> > Links:
> > 1. https://docs.kernel.org/bpf/prog_lsm.html?highlight=bpf+lsm#
> >
