Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098EA44E442
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 10:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhKLJ4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 04:56:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234778AbhKLJ4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 04:56:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636710832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=haBKpf02OGQlHdKCvRfyxCu3XNyPW5ZvykAMOPp+Q44=;
        b=SnQAtOZGikcEHly68t5jKQE2uRZQG5mEEUctIj0FIsH3n3JWgKutWK65sEcEeuiKPh6e3q
        GGZl8TjveJyxQyJNnb1ruY6++KGCUbIF1GZE29RzNIZT46gfKpFKJ3rCNmfcHKvFI1FE2N
        S62BolIG53+EBS5efrdgfsP+dqcWo6g=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-5Sy9zHshPFipSx4Og7Zr7w-1; Fri, 12 Nov 2021 04:53:51 -0500
X-MC-Unique: 5Sy9zHshPFipSx4Og7Zr7w-1
Received: by mail-yb1-f197.google.com with SMTP id d8-20020a253608000000b005c202405f52so13803655yba.7
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 01:53:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=haBKpf02OGQlHdKCvRfyxCu3XNyPW5ZvykAMOPp+Q44=;
        b=nz6BheQRWRPRthezvOE39jYwfmLo37ElUX5A2STyBQNQ1LicuA+qtwBCtefEirIgfj
         4EF0ipDcATRkGfucyLbk52yy376NxwJS1DHIhr2M7Z/VXm0riCk+St9UrTguvk3Fr1yu
         qefP7vr+LdnX2oJHdQYjA6uk2Ub2fPFezVVQ8iQEYZO73/uycgQCSIi88b4IFaq6pchy
         +9RXF3ocfwLnbSo/wJ9ETuvYzUHBBIssT4QgCL24G+/Nv/ll4ZBGhadFzIqjpwuQST8J
         JPVeBDNq7CJdtLkhQxqZcXAxMCPj1i6wBr0AczqCEjWVuqU3E1ElwpMVp4arm6Xcpt/h
         Yweg==
X-Gm-Message-State: AOAM5322ol3Semg8EsMRYSoeIOJJ/IP6jVn2H62gRzKdF4Spayj1jUM0
        hH7HXD2w7NtsaCKY8jONW56qYiRY1RQ9cbpHmys2+YZDmAHY9wD/2VDuqcpT3igOtxWhM6ODrh/
        sRuWcx1J0+VA0PjCr5UsgWm5GzW4n81PM
X-Received: by 2002:a25:8205:: with SMTP id q5mr16470725ybk.256.1636710830795;
        Fri, 12 Nov 2021 01:53:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw03Mq9ye854YzequDJcds5WR57wFTZoAcENqj7B/favSIpZcfsO2F1FfxRlK8Hp84AONu8JtdT4xlSVlE12vI=
X-Received: by 2002:a25:8205:: with SMTP id q5mr16470702ybk.256.1636710830585;
 Fri, 12 Nov 2021 01:53:50 -0800 (PST)
MIME-Version: 1.0
References: <20211104195949.135374-1-omosnace@redhat.com> <20211109062140.2ed84f96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHC9VhTVNOUHJp+NbqV5AgtwR6+3V6am0SKGKF0CegsPqjQ8pw@mail.gmail.com>
 <CAFqZXNuct_T-SkvoRg2n7+ye0--OkMJ_gS31V-t3Cm+Yy7FhxQ@mail.gmail.com> <CAHC9VhTmkQy1_1xFn9StgrwT2m8nyCwvHCMA+1sRdTW6xWR96A@mail.gmail.com>
In-Reply-To: <CAHC9VhTmkQy1_1xFn9StgrwT2m8nyCwvHCMA+1sRdTW6xWR96A@mail.gmail.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 12 Nov 2021 10:53:39 +0100
Message-ID: <CAFqZXNufe_7Nz6zayAGiJh-8xGw2cm=awhmVOp7hLLr5Ph72nQ@mail.gmail.com>
Subject: Re: [PATCH net] selinux: fix SCTP client peeloff socket labeling
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> On Thu, Nov 11, 2021 at 7:59 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > On Tue, Nov 9, 2021 at 4:00 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Tue, Nov 9, 2021 at 9:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > On Thu,  4 Nov 2021 20:59:49 +0100 Ondrej Mosnacek wrote:
> > > > > As agreed with Xin Long, I'm posting this fix up instead of him. I am
> > > > > now fairly convinced that this is the right way to deal with the
> > > > > immediate problem of client peeloff socket labeling. I'll work on
> > > > > addressing the side problem regarding selinux_socket_post_create()
> > > > > being called on the peeloff sockets separately.
> > > >
> > > > IIUC Paul would like to see this part to come up in the same series.
> > >
> > > Just to reaffirm the IIUC part - yes, your understanding is correct.
> >
> > The more I'm reading these threads, the more I'm getting confused...
> > Do you insist on resending the whole original series with
> > modifications? Or actual revert patches + the new patches? Or is it
> > enough to revert/resend only the patches that need changes? Do you
> > also insist on the selinux_socket_post_create() thing to be fixed in
> > the same series? Note that the original patches are still in the
> > net.git tree and it doesn't seem like Dave will want to rebase them
> > away, so it seems explicit reverting is the only way to "respin" the
> > series...
>
> DaveM is stubbornly rejecting the revert requests so for now I would
> continue to base any patches on top of the netdev tree.  If that
> changes we can reconcile any changes as necessary, that should not be
> a major issue.
>
> As far as what I would like to see from the patches, ignoring the
> commit description vs cover letter discussion, I would like to see
> patches that fix all of the known LSM/SELinux/SCTP problems as have
> been discussed over the past couple of weeks.  Even beyond this
> particular issue I generally disapprove of partial fixes to known
> problems; I would rather see us sort out all of the issues in a single
> patchset so that we can review everything in a sane manner.  In this
> particular case things are a bit more complicated because of the
> current state of the patches in the netdev tree, but as mentioned
> above just treat the netdev tree as broken and base your patches on
> that with all of the necessary "Fixes:" metadata and the like.

Hm, okay, that isn't what I was branch-predicting from your other
responses, but works for me.

> > Regardless of the answers, this thing has rabbithole'd too much and
> > I'm already past my free cycles to dedicate to this, so I think it
> > will take me (and Xin) some time to prepare the corrected and
> > re-documented patches. Moreover, I think I realized how to to deal
> > with the peer_secid-vs.-multiple-assocs-on-one-socket problem that Xin
> > mentions in patch 4/4, fixing which can't really be split out into a
> > separate patch and will need some test coverage, so I don't think I
> > can rush this up at this point...
>
> It's not clear to me from your comments above if this is something you
> are currently working on, planning to work on soon, or giving up on in
> the near term.  Are we able to rely on you for a patchset to fix this
> or are you unable to see this through at this time?

I'm still working on it, but I'll need to juggle it with other things
now and I might need to defer it completely at some point. I don't
think I'll have all the patches ready sooner than two weeks from now.
My point was to explain that I'm unable to provide a proper fix in the
short term and don't want to block the netdev maintainers in case they
were waiting for this to get resolved before e.g. sending a PR to
Linus.

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

