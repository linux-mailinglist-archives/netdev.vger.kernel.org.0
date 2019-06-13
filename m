Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DBA44EB9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfFMVu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:50:28 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36919 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfFMVu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:50:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so411088qkl.4;
        Thu, 13 Jun 2019 14:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QbSBAlE+pt12UJBCYdXG/zx0lhYgnpVwEE9At798WtQ=;
        b=bDIRdxbOo2UAyPlkfVRA4EH6HmxQ0CQKejUaQVb9A3OT1RmNoOf4OJ/0ggR1CCUHvF
         tzCRJ8fRKqre7025if6NHWbd3yP1crMWJmzZ90YgN0BCEk2KXbmo4OIS+zupEzGQQQZX
         a112Cqah4D2cf5UHyXrnEWKxf6L/Dji0X9HTw34D2vyX0BgBdmQuDaOlo+voNOe89ROy
         m6srnmfhC9p5L/Et8Sh9KHk0NEo9H3u2Cc8NNYCIdJeRFEWA9Hap68HNBwnlYQIDeDYt
         uEDOrTC5YAvYWFfRi+OvM4GmmThUqwHSyzUeQJQrSSdNzrlVAen04ZYzXJf5ZYZC7Vkd
         wJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QbSBAlE+pt12UJBCYdXG/zx0lhYgnpVwEE9At798WtQ=;
        b=AIXwNWm1zXpU3aVSBipx/npxkgNON6aDKNFuO3CH4IyxF8O4j1P7bqS+AMvwuByLOw
         130+njqyJAuBcFInOYunr+HBj6I0Bem+5CF5et50AIV8xRE9FR8h8oX7k8Ql6iD5pYeo
         ejP9TfpvbGbYaK1TLUs961DQhg7Hf5fZbO78+t3L20AAgdBNftkrFAWJfIHwNKxDkl65
         E7vYAESD2EwHD7RnC1HKoyXP45dHCOFlNmWNNLizg7Qk7WPiLVKefqXNchVRowmT38hK
         6xKVN4Vfq+RbXfLtWqgTX8AmgR/FZS0LXiMOc1LK0iR9oPbJa67VHsXeiNgWk0zDCJ6E
         vjCg==
X-Gm-Message-State: APjAAAUZBrwR4wbX8XczPAftEnxLEsLeebg114wZMIsMhP2N847rIcWz
        YntZ4ZYjZ/HaSKY0xybIFn246AK8qQtiRq0f9H8=
X-Google-Smtp-Source: APXvYqwU/5Gr85djiZMwBSuhqA4heQh9LqV2EwfM0a9lFan3ze+G9jWlUG54zWGOpRs8SL/106HJZ6uJb1aJl9ng6aQ=
X-Received: by 2002:a05:620a:14a8:: with SMTP id x8mr17569505qkj.35.1560462627052;
 Thu, 13 Jun 2019 14:50:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190610210830.105694-1-sdf@google.com> <20190610210830.105694-2-sdf@google.com>
 <20190613201632.t7npizqhtnohzwmc@ast-mbp.dhcp.thefacebook.com> <20190613212020.GB9636@mini-arch>
In-Reply-To: <20190613212020.GB9636@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 14:50:15 -0700
Message-ID: <CAEf4Bza0D6=4a6D1ErpT+nh8_byufOz4qhvBmCsBV9zLFHP0eA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: implement getsockopt and setsockopt hooks
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 2:20 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/13, Alexei Starovoitov wrote:
> > C based example doesn't use ret=1.
> > imo that's a sign that something is odd in the api.
> I decided not to test ret=1 it because there are tests in the test_sockopt.c
> for ret=1 usecase. But I can certainly extend C based test to cover
> ret=1 as well. I agree that C based test can be used as an example,
> will extend that to cover ret=0/1/2.
>
> > In particular ret=1 doesn't prohibit bpf prog to modify the optval.
> That's a good point, Martin brought that up as well. We were trying
> to remedy it by doing copy_to_user only if any program returned 2 ("BPF
> handled that, bypass the kernel"). But I agree, the fact that the prog in
> the chain can modify optval and return 1 is suboptimal. Especially if
> the previous one filled in some valid data and returned 2.
>
> > Multiple progs can overwrite it and still return 1.
> > But that optval is not going to be processed by the kernel.
> > Should we do copy_to_user(optval, ctx.optval, ctx.optlen) here
> > and let kernel pick it up from there?
> I was thinking initially about that, that kernel can "transparently"
> modify user buffer and then kernel (or next BPF program in the chain)
> can run standard getsockopt on that.
>
> But it sounds a bit complicated and I don't really have a good use case
> for that.
>
> > Should bpf prog be allowed to change optlen as well?
> > ret=1 would mean that bpf prog did something and needs kernel
> > to continue.
> >
> > Now consider a sequence of bpf progs.
> > Some are doing ret=1. Some others are doing ret=2
> > ret=2 will supersede.
> > If first executed prog (child in cgroup) did ret=2
> > the parent has no way to tell kernel to handle it.
> > Even if parent does ret=1, it's effectively ignored.
> > Parent can enforce rejection with ret=0, but it's a weird
> > discrepancy.
> > The rule for cgroup progs was 'all yes is yes, any no is no'.
> My canonical example when reasoning about multiple progs was that each one
> of them would implement handling for a particular level+optname. So only
> a single one form the chain would return 2 or 0, the rest would return 1
> without touching the buffer. I can't come up with a good use-case where
> two programs in the chain can both return 2 and fill out the buffer.
> The majority of the sockopts would still be handled by the kernel,
> we'd have only a handful of bpf progs that handle a tiny subset
> and delegate the rest to the kernel.
>
> How about we stop further processing as soon as some program in the chain
> returned 2? I think that would address most of the concerns?

What about a case of passive "auditing" BPF programs, that are not
modifying anything, but want to capture every single
getsockopt/setsockopt call? This premature stop would render that
whole approach broken.

> Maybe, in this case, also stop further processing as soon as
> we get ret=0 (EPERM) for consistency?
>
> > So if ret=1 means 'kernel handles it'. Should it be almost
> > as strong as 'reject it': any prog doing ret=1 means 'kernel does it'
> > (unless some prog did ret=0. then reject it) ?
> > if ret=1 means 'bpf did some and needs kernel to continue' that's
> > another story.
> > For ret=2 being 'bpf handled it completely', should parent overwrite it?
> See above, I was thinking the opposite. Treat ret=1 from the BPF
> program as "I'm not interested in this level+optname, other BPF
> program or kernel should do the job". Essentially, as soon as bpf program
> returns 2, that means BPF had consumed the request and no further processing
> from neither BPF, nor kernel is requred; we can return to userspace.
>
> There is a problem that some prog in the chain might do some
> "background" work and still return 1, but so far I don't see why
> that can be useful. The pattern should be: filter the option
> you want, handle it, otherwise return 1 to let the other progs/kernel
> run.
>
> That BPF_F_ALLOW_MULTI use-case probably deserves another selftest :-/
>
> > May be retval from child prog should be seen by parent prog?
> >
> > In some sense kernel can be seen as another bpf prog in a sequence.
> >
> > Whatever new behavior is with 3 values it needs to be
> > documented in uapi/bpf.h
> > We were sloppy with such docs in the past, but that's not
> > a reason to continue.
> Good point on documenting that, I was trying to document everything
> in Documentation/bpf/prog_cgroup_sockopt.rst, uapi/bpf.h seems too
> constrained (I didn't find a good place to put that ret 1 vs 2 info).
> Do you think having a file under Documentation/ with all the details
> is not enough? Where can I put this ret=0/1/2 handing info in the
> uapi/bpf.h?
