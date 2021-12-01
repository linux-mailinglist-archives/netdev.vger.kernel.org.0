Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373A44646C3
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 06:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346758AbhLAFmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 00:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345818AbhLAFmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 00:42:10 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2760C061574;
        Tue, 30 Nov 2021 21:38:49 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e136so59732458ybc.4;
        Tue, 30 Nov 2021 21:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1u51qSDcYv1uEUDs3E7sVNA+k8XiG0PUNNhcXHOxjxo=;
        b=OwiIYI0dShncMcrrP3amNdcg/VQrKct8hkNPesCBd8aZDgrTeXrSosEL0F8cDtSXSx
         y9ZmuStkmVFW4pI7dJkSV56K2dw0QAi9UcFHi53mH5BBR5MX4EMQlVepMNmlYB2E5LH9
         7ydCXrIOZnLgMGZwnz7F1WGJyFN1Jx8DRpAVtsn7+UoG40ynBYBp/1Ih1EcgPXJCKDoQ
         HXoMQJST3A2EvA9Wn/Vg0m+SIMhifankpgK4HUF5R+cB03pF75i60moTWzPtM5D6KF55
         Dui/UQ4pQgApR2A5t+cHt6IKAXRxNmzv82x2UmI6PStAZuX43Pzi8vFwsmB4zRsOUg3G
         BEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1u51qSDcYv1uEUDs3E7sVNA+k8XiG0PUNNhcXHOxjxo=;
        b=h/ziXJVu0jHOHZM/4glcuI3M5XOV8m8eoxC7Od7b4ZB0IF9G2lPsQmC9K0UvMPfNkM
         LnsHl6sAo2fPj9QkV5XnedFK5ZN5tWTgWAQ0axH1ATlFnZfc8MlTJOF1buFLu9MG/Vte
         gL05qrt5WtP7IZHZLs8ZKE65upQeFkg81lRzd3bWHYqlTUH0n58mi7obN6K9veiDVbBR
         4rsMNettzxsHAk4RqzEdEuoDpift8MH4G851uXWreXIr/zOwcbAQi+i0lSZphieY66Jr
         QcrJyyGF3QFc+5QJreHW71ZQcEAb6ntjZNo/6Fxlq+Ft4lhzs1E8zEQf3zNlP8h48SEy
         o4UA==
X-Gm-Message-State: AOAM5333UfcQLL63nlaNk/SluRJ5nTSOc93bDsoFydpzpNQykOjZaeL9
        ifLx3P3AySwTu5fmyQZck4hEx+wpADB4FyUcr3o=
X-Google-Smtp-Source: ABdhPJx2SYeXH63pBipJx9ur3BSjBrC/XYWeANkoa+Vmr0odOihxXph6Jf9EFbDLQ6dP+nsmLiloCl17xVKIGjLUwJY=
X-Received: by 2002:a05:6902:1006:: with SMTP id w6mr5178522ybt.252.1638337128936;
 Tue, 30 Nov 2021 21:38:48 -0800 (PST)
MIME-Version: 1.0
References: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
 <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com>
 <YaU9Mdv+7kEa4JOJ@unknown> <CAPhsuW4M5Zf9ryWihNSc6DPnXAq0PDJReD2-exxNZp4PDvsSXQ@mail.gmail.com>
 <CAM_iQpVrv8C9opCCMb9ZYtemp32vdv8No2XDwYmDAaCgPtq+RA@mail.gmail.com>
 <CAEf4BzZUdE+gsgiLRRissh1Vskf2Ea4WT3gAseV1b9cvNnaBVQ@mail.gmail.com> <CAM_iQpV3+bYqw4n494-hc=3DcDkBpM8k9gd=iPwqR4X_Vw6LhQ@mail.gmail.com>
In-Reply-To: <CAM_iQpV3+bYqw4n494-hc=3DcDkBpM8k9gd=iPwqR4X_Vw6LhQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Nov 2021 21:38:37 -0800
Message-ID: <CAEf4Bzbc28MTihTAaaMrMOiv-PCJ4i17BZ973PhCtSWfHAC9jA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing section "sk_skb/skb_verdict"
To:     Cong Wang <xiyou.wangcong@gmail.com>
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

On Tue, Nov 30, 2021 at 9:03 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Nov 30, 2021 at 8:33 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Nov 30, 2021 at 8:19 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Tue, Nov 30, 2021 at 3:33 PM Song Liu <song@kernel.org> wrote:
> > > >
> > > > On Mon, Nov 29, 2021 at 12:51 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > On Fri, Nov 26, 2021 at 04:20:34PM -0800, Song Liu wrote:
> > > > > > On Fri, Nov 26, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > > > >
> > > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > > >
> > > > > > > When BPF_SK_SKB_VERDICT was introduced, I forgot to add
> > > > > > > a section mapping for it in libbpf.
> > > > > > >
> > > > > > > Fixes: a7ba4558e69a ("sock_map: Introduce BPF_SK_SKB_VERDICT")
> > > > > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > > > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > > > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > > >
> > > > > > The patch looks good to me. But seems the selftests are OK without this. So,
> > > > > > do we really need this?
> > > > > >
> > > > >
> > > > > Not sure if I understand this question.
> > > > >
> > > > > At least BPF_SK_SKB_STREAM_PARSER and BPF_SK_SKB_STREAM_VERDICT are already
> > > > > there, so either we should remove all of them or add BPF_SK_SKB_VERDICT for
> > > > > completeness.
> > > > >
> > > > > Or are you suggesting we should change it back in selftests too? Note, it was
> > > > > changed by Andrii in commit 15669e1dcd75fe6d51e495f8479222b5884665b6:
> > > > >
> > > > > -SEC("sk_skb/skb_verdict")
> > > > > +SEC("sk_skb")
> > > >
> > > > Yes, I noticed that Andrii made the change, and it seems to work
> > > > as-is. Therefore,
> > > > I had the question "do we really need it".
> > >
> > > Same question from me: why still keep sk_skb/stream_parser and
> > > sk_skb/stream_verdict? ;) I don't see any reason these two are more
> > > special than sk_skb/skb_verdict, therefore we should either keep all
> > > of them or remove all of them.
> > >
> >
> > "sk_skb/skb_verdict" was treated by libbpf *exactly* the same way as
> > "sk_skb". Which means the attach type was set to BPF_PROG_TYPE_SK_SKB
> > and expected_attach_type was 0 (not BPF_SK_SKB_VERDICT!). So that
> > program is definitely not a BPF_SK_SKB_VERDICT, libbpf pre-1.0 just
> > has a sloppy prefix matching logic.
>
> This is exactly what I meant by "umbrella". ;)

You were asking why keep sk_skb/stream_verdict and
sk_skb/stream_parser and how it's different from sk_skb/skb_verdict.
The first two set expected_attach_type, the latter doesn't. Kernel
currently doesn't enforce extected_attach_type for SK_SKB prog type,
but that might change in the future.

>
> >
> > So Song's point is valid, we currently don't have selftests that tests
> > BPF_SK_SKB_VERDICT expected attach type, so it would be good to add
> > it. Or make sure that existing test that was supposed to test it is
> > actually testing it.
>
> Sure, I just noticed we have section name tests a few minutes ago. Will add
> it in V2.
>
> >
> > > >
> > > > If we do need to differentiate skb_verdict from just sk_skb, could you
> > >
> > > Are you sure sk_skb is a real attach type?? To me, it is an umbrella to
> > > catch all of them:
> > >
> > > SEC_DEF("sk_skb",               SK_SKB, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > >
> > > whose expected_attach_type is 0. The reason why it works is
> > > probably because we don't check BPF_PROG_TYPE_SK_SKB in
> > > bpf_prog_load_check_attach().
> >
> > We don't check expected_attach_type in prog_load, but
>
> I see many checks in bpf_prog_load_check_attach(), for instance:
>
> 2084         switch (prog_type) {
> 2085         case BPF_PROG_TYPE_CGROUP_SOCK:
> 2086                 switch (expected_attach_type) {
> 2087                 case BPF_CGROUP_INET_SOCK_CREATE:
> 2088                 case BPF_CGROUP_INET_SOCK_RELEASE:
> 2089                 case BPF_CGROUP_INET4_POST_BIND:
> 2090                 case BPF_CGROUP_INET6_POST_BIND:
> 2091                         return 0;
> 2092                 default:
> 2093                         return -EINVAL;
> 2094                 }

I meant specifically for BPF_PROG_TYPE_SK_SKB, for which kernel
doesn't check or enforce expected_attach_type, as far as I can see
from the code.

>
>
> > sock_map_prog_update in net/core/sock_map.c is checking expected
> > attach type and should return -EOPNOTSUPP. But given that no test is
> > failing our tests don't even try to attach anything, I assume. Which
> > makes them not so great at actually testing anything. Please see if
> > you can improve that.
>
> sock_map_prog_update() checks for attach_type, not
> expected_attach_type.

Right, but shouldn't it make sure that attach_type ==
expected_attach_type? Otherwise what's even the point of
expected_attach_type?

>
> >
> > >
> > > > please add a
> > > > case selftest for skb_verdict?
> > >
> > > Ah, sure, I didn't know we have sec_name_test.
> > >
> > > >
> > > > Also, maybe we can name it as "sk_skb/verdict" to avoid duplication?
> > >
> > > At least we used to call it sk_skb/skb_verdict before commit 15669e1dcd.
> >
> > As I mentioned above, it could have been called "sk_skb!dontcare" and
>
> So why commit c6f6851b28ae26000352598f01968b3ff7dcf58 if your point
> here is we don't need any name? ;)

If kernel doesn't and *shoulnd't* care about expected_attach_type,
then maybe there is no point in supporting those names. I'm not
familiar with SK_SKB prog type, so I can't really answer. Given what
we do with CGROUP prog types and their expected attach types, I'd say
that probably the right thing is to enforce that in the kernel. But
again, opinions of others are welcome.

>
> > that would still work (and still does if strict mode is not enabled
> > for libbpf). For consistency with UAPI expected_attach_type enum it
> > should be called "sk_skb/verdict" because BPF_SK_SKB_VERDICT vs
> > BPF_SK_SKB_STREAM_VERDICT vs BPF_SK_SKB_STREAM_PARSER.
>
> To me, "verdict" is too broad, it could refer "stream_verdict" or "skb_verdict".

It's not "verdict" in isolation, it's "sk_skb/verdict". You yourself
added BPF_SK_SKB_VERDICT in a7ba4558e69a ("sock_map: Introduce
BPF_SK_SKB_VERDICT"), so I suppose that wasn't too broad at that time.
Now it's part of kernel UAPI, and consistency takes priority.

> And let me quote commit c6f6851b28ae26000352598f01968b3ff7dcf588:
>
>     "stream_parser" and "stream_verdict" are used instead of simple "parser"
>     and "verdict" just to avoid possible confusion in a place where attach
>     type is used alone (e.g. in bpftool's show sub-commands) since there is
>     another attach point that can be named as "verdict": BPF_SK_MSG_VERDICT.
>
> Thanks.
