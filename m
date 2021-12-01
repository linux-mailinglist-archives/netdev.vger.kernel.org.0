Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC33846463D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 06:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbhLAFHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 00:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhLAFHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 00:07:18 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8746EC061574;
        Tue, 30 Nov 2021 21:03:58 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id e136so59504493ybc.4;
        Tue, 30 Nov 2021 21:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qg1yxwbeofVGjh/45BLN8J5HN9IzS64zV7+tlROSMHk=;
        b=I7xLRT8f7a1sNAzHDdQ8mim7DNBsKjDhX5MJN1AxB1C2aFwN6e9isttGM5pJaj6i2m
         ZoNcsFprD1Ym2/qNLY4uvRRoeEo+QhAMqtFtM4SBdqm2Kr6dodkr/Uc5oPCiJs1N5ftE
         879VeMfFnx4hqfLhpKemmEF6ZoTttsvbbWoIs0IUuCcRisj39TorHe768ytkbgdtmWER
         6+vuUBn6h72i1Wsz2zkdDtcNoA4oLFWh0fznMnHsM1KoW3bNph5jJC67h056PMkXQpBw
         HYNt2LfQ4EOiiw94SIK5Glj8WBy7GjErUgAeJKlnmP2kU2yDgwzQUu/OHeCBbZbsGFY0
         kD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qg1yxwbeofVGjh/45BLN8J5HN9IzS64zV7+tlROSMHk=;
        b=JVwOMzZjQznaS/OVloFzuialB9UcHNQN9AnULARVrPf7A33olUIkeab+CyGWOgUwen
         /q1kUBOnxCWAYO8FTPTR7FTAJquTB6RHfaeGN0Zuz+ozihcmubqBQersDbSw6uVKQ3fb
         /yQ6CWb0m36Bv2TwWM+O9w1Usj0bpaed9WciId4YdNpYI9iDxbBmv3GwOfE9LsFbJNtD
         3BpHsfzN5TYZbgfrcmHs/DTMTYMZGuI2EOTlTHxzwUcCNFHAiga1wEAfkvRJfdQsdWZs
         q20j3zwD7yyHcVj6fPdrh8wS9/FJ/NSMau66sRIFNztJl8KSOifv/MYWEP8RY4d7PhSl
         pIFA==
X-Gm-Message-State: AOAM532Iex5EfhUfU34A9XppDINhKhXT/c99GVgoKTSVgQxfleE4joW9
        gVOYTSRdxPHfytOieW6gBvITvaZDwjt6sW/7f5P2ilML3t8=
X-Google-Smtp-Source: ABdhPJze7bzfkeTtw2WH0v1vsY8m/RbEpLFbBDwp1SN0UlDhoAtTobcl3pZtvAguPhlx8Xi/J8ufO51b1Ac9zVq3XKs=
X-Received: by 2002:a25:7b41:: with SMTP id w62mr4498861ybc.164.1638335037726;
 Tue, 30 Nov 2021 21:03:57 -0800 (PST)
MIME-Version: 1.0
References: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
 <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com>
 <YaU9Mdv+7kEa4JOJ@unknown> <CAPhsuW4M5Zf9ryWihNSc6DPnXAq0PDJReD2-exxNZp4PDvsSXQ@mail.gmail.com>
 <CAM_iQpVrv8C9opCCMb9ZYtemp32vdv8No2XDwYmDAaCgPtq+RA@mail.gmail.com> <CAEf4BzZUdE+gsgiLRRissh1Vskf2Ea4WT3gAseV1b9cvNnaBVQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZUdE+gsgiLRRissh1Vskf2Ea4WT3gAseV1b9cvNnaBVQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Nov 2021 21:03:46 -0800
Message-ID: <CAM_iQpV3+bYqw4n494-hc=3DcDkBpM8k9gd=iPwqR4X_Vw6LhQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing section "sk_skb/skb_verdict"
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Song Liu <song@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 8:33 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 30, 2021 at 8:19 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Nov 30, 2021 at 3:33 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Mon, Nov 29, 2021 at 12:51 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Fri, Nov 26, 2021 at 04:20:34PM -0800, Song Liu wrote:
> > > > > On Fri, Nov 26, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > >
> > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > >
> > > > > > When BPF_SK_SKB_VERDICT was introduced, I forgot to add
> > > > > > a section mapping for it in libbpf.
> > > > > >
> > > > > > Fixes: a7ba4558e69a ("sock_map: Introduce BPF_SK_SKB_VERDICT")
> > > > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > The patch looks good to me. But seems the selftests are OK without this. So,
> > > > > do we really need this?
> > > > >
> > > >
> > > > Not sure if I understand this question.
> > > >
> > > > At least BPF_SK_SKB_STREAM_PARSER and BPF_SK_SKB_STREAM_VERDICT are already
> > > > there, so either we should remove all of them or add BPF_SK_SKB_VERDICT for
> > > > completeness.
> > > >
> > > > Or are you suggesting we should change it back in selftests too? Note, it was
> > > > changed by Andrii in commit 15669e1dcd75fe6d51e495f8479222b5884665b6:
> > > >
> > > > -SEC("sk_skb/skb_verdict")
> > > > +SEC("sk_skb")
> > >
> > > Yes, I noticed that Andrii made the change, and it seems to work
> > > as-is. Therefore,
> > > I had the question "do we really need it".
> >
> > Same question from me: why still keep sk_skb/stream_parser and
> > sk_skb/stream_verdict? ;) I don't see any reason these two are more
> > special than sk_skb/skb_verdict, therefore we should either keep all
> > of them or remove all of them.
> >
>
> "sk_skb/skb_verdict" was treated by libbpf *exactly* the same way as
> "sk_skb". Which means the attach type was set to BPF_PROG_TYPE_SK_SKB
> and expected_attach_type was 0 (not BPF_SK_SKB_VERDICT!). So that
> program is definitely not a BPF_SK_SKB_VERDICT, libbpf pre-1.0 just
> has a sloppy prefix matching logic.

This is exactly what I meant by "umbrella". ;)

>
> So Song's point is valid, we currently don't have selftests that tests
> BPF_SK_SKB_VERDICT expected attach type, so it would be good to add
> it. Or make sure that existing test that was supposed to test it is
> actually testing it.

Sure, I just noticed we have section name tests a few minutes ago. Will add
it in V2.

>
> > >
> > > If we do need to differentiate skb_verdict from just sk_skb, could you
> >
> > Are you sure sk_skb is a real attach type?? To me, it is an umbrella to
> > catch all of them:
> >
> > SEC_DEF("sk_skb",               SK_SKB, 0, SEC_NONE | SEC_SLOPPY_PFX),
> >
> > whose expected_attach_type is 0. The reason why it works is
> > probably because we don't check BPF_PROG_TYPE_SK_SKB in
> > bpf_prog_load_check_attach().
>
> We don't check expected_attach_type in prog_load, but

I see many checks in bpf_prog_load_check_attach(), for instance:

2084         switch (prog_type) {
2085         case BPF_PROG_TYPE_CGROUP_SOCK:
2086                 switch (expected_attach_type) {
2087                 case BPF_CGROUP_INET_SOCK_CREATE:
2088                 case BPF_CGROUP_INET_SOCK_RELEASE:
2089                 case BPF_CGROUP_INET4_POST_BIND:
2090                 case BPF_CGROUP_INET6_POST_BIND:
2091                         return 0;
2092                 default:
2093                         return -EINVAL;
2094                 }


> sock_map_prog_update in net/core/sock_map.c is checking expected
> attach type and should return -EOPNOTSUPP. But given that no test is
> failing our tests don't even try to attach anything, I assume. Which
> makes them not so great at actually testing anything. Please see if
> you can improve that.

sock_map_prog_update() checks for attach_type, not
expected_attach_type.

>
> >
> > > please add a
> > > case selftest for skb_verdict?
> >
> > Ah, sure, I didn't know we have sec_name_test.
> >
> > >
> > > Also, maybe we can name it as "sk_skb/verdict" to avoid duplication?
> >
> > At least we used to call it sk_skb/skb_verdict before commit 15669e1dcd.
>
> As I mentioned above, it could have been called "sk_skb!dontcare" and

So why commit c6f6851b28ae26000352598f01968b3ff7dcf58 if your point
here is we don't need any name? ;)

> that would still work (and still does if strict mode is not enabled
> for libbpf). For consistency with UAPI expected_attach_type enum it
> should be called "sk_skb/verdict" because BPF_SK_SKB_VERDICT vs
> BPF_SK_SKB_STREAM_VERDICT vs BPF_SK_SKB_STREAM_PARSER.

To me, "verdict" is too broad, it could refer "stream_verdict" or "skb_verdict".
And let me quote commit c6f6851b28ae26000352598f01968b3ff7dcf588:

    "stream_parser" and "stream_verdict" are used instead of simple "parser"
    and "verdict" just to avoid possible confusion in a place where attach
    type is used alone (e.g. in bpftool's show sub-commands) since there is
    another attach point that can be named as "verdict": BPF_SK_MSG_VERDICT.

Thanks.
