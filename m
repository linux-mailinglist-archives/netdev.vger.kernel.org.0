Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915242A4A1A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgKCPm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgKCPm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:42:57 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB264C0613D1;
        Tue,  3 Nov 2020 07:42:57 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id y20so18936500iod.5;
        Tue, 03 Nov 2020 07:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdmSmJMhivqis7yO4uZkZnYxSZ1rhGx/M+hRTu2KaCw=;
        b=eP7qJu0SIIeL/FkFShebN6p9imHE41gvEeHiIo/Sm2xiDhh+482PvqUzVeTxCqmErG
         lPYOjj77mt26Hn6Nu3x5972vBlg4GClVW95YWPtkfkImrCl0NQ9FFLUl46Z8LioqDe/s
         G36P8ltFymTUAvNB5au8qxwHlvm8BgcdpbEsB7DrgN1gnFWhWBJtKHJYa992y/E+RCaG
         UiBA3EYWiLiif5M0f8WW6Bbibou4esTuJg6FIpvzoLP8+iwju/ePdnJbt37hRHva2xsZ
         vC0a/3MRIOLYiOQBuQbL+yvrFdlNfgwlpE9KpoLPv78RM3u9txrd51qQoZSO7cb+ngN1
         lN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdmSmJMhivqis7yO4uZkZnYxSZ1rhGx/M+hRTu2KaCw=;
        b=LRYB5boctdvDz0LRehl5tBaTHdSbCFZ9Mk/QurEOLfPr82iYm8IxzOs3BJJBKzQd7Z
         oIAxFS8w+JijvBZND859qPVWivccYI5tBIEyXnl90Jl2YgFd33d5M5lOC00G0jsXckQr
         Sah1rWX8XLGlFOL1oN6Eq7PZg9IUHzVL/CkwMOIfbVKR1AQhmTDbkV94CZgKoJDBnbVy
         Nb/cs0PaZBHH9Is3oUmXoSMSH04khsKAFP1K6RAhfYMuwR+KstwGZ1KFUHx3tj40Oozp
         bDh72MrG7ei6u6kl/nWUUu21ZghkdwYBOolrE4aCoQsrQpADQhumqlSnoQCW2PTMiHaM
         30uA==
X-Gm-Message-State: AOAM532fWHXxkuMRqLyBHLjIoA1H4gAVlQGbTo/V965kqY3L/6ngr4zm
        t4ykTdeYN+UfbpH8dPS47z/inE16QD5Aa3kZkek3mzKCRIQ=
X-Google-Smtp-Source: ABdhPJwehzRbRW8I9ao3mxCRkvH9Gf+Im/+BLIxS0F7f7cc8o7bRP0Mz9Y0GgtqB8a0eS3tBpixQbzHHsmTpkejiN7w=
X-Received: by 2002:a6b:780b:: with SMTP id j11mr14499603iom.5.1604418177097;
 Tue, 03 Nov 2020 07:42:57 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417035730.2823.6697632421519908152.stgit@localhost.localdomain> <20201103012552.twbqzgbhc35nushq@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201103012552.twbqzgbhc35nushq@kafai-mbp.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 3 Nov 2020 07:42:46 -0800
Message-ID: <CAKgT0UebGOEf4aqAqsisUVKzU6+pas+qFkHy-OoHeHYTCAE_+A@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 5/5] selftest/bpf: Use global variables
 instead of maps for test_tcpbpf_kern
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 5:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Sat, Oct 31, 2020 at 11:52:37AM -0700, Alexander Duyck wrote:
> [ ... ]
>
> > +struct tcpbpf_globals global = { 0 };
> >  int _version SEC("version") = 1;
> >
> >  SEC("sockops")
> > @@ -105,29 +72,15 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> >
> >       op = (int) skops->op;
> >
> > -     update_event_map(op);
> > +     global.event_map |= (1 << op);
> >
> >       switch (op) {
> >       case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
> >               /* Test failure to set largest cb flag (assumes not defined) */
> > -             bad_call_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
> > +             global.bad_cb_test_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
> >               /* Set callback */
> > -             good_call_rv = bpf_sock_ops_cb_flags_set(skops,
> > +             global.good_cb_test_rv = bpf_sock_ops_cb_flags_set(skops,
> >                                                BPF_SOCK_OPS_STATE_CB_FLAG);
> > -             /* Update results */
> > -             {
> > -                     __u32 key = 0;
> > -                     struct tcpbpf_globals g, *gp;
> > -
> > -                     gp = bpf_map_lookup_elem(&global_map, &key);
> > -                     if (!gp)
> > -                             break;
> > -                     g = *gp;
> > -                     g.bad_cb_test_rv = bad_call_rv;
> > -                     g.good_cb_test_rv = good_call_rv;
> > -                     bpf_map_update_elem(&global_map, &key, &g,
> > -                                         BPF_ANY);
> > -             }
> >               break;
> >       case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
> >               skops->sk_txhash = 0x12345f;
> > @@ -143,10 +96,8 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> >
> >                               thdr = (struct tcphdr *)(header + offset);
> >                               v = thdr->syn;
> > -                             __u32 key = 1;
> >
> > -                             bpf_map_update_elem(&sockopt_results, &key, &v,
> > -                                                 BPF_ANY);
> > +                             global.tcp_saved_syn = v;
> >                       }
> >               }
> >               break;
> > @@ -156,25 +107,16 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> >               break;
> >       case BPF_SOCK_OPS_STATE_CB:
> >               if (skops->args[1] == BPF_TCP_CLOSE) {
> > -                     __u32 key = 0;
> > -                     struct tcpbpf_globals g, *gp;
> > -
> > -                     gp = bpf_map_lookup_elem(&global_map, &key);
> > -                     if (!gp)
> > -                             break;
> > -                     g = *gp;
> >                       if (skops->args[0] == BPF_TCP_LISTEN) {
> > -                             g.num_listen++;
> > +                             global.num_listen++;
> >                       } else {
> > -                             g.total_retrans = skops->total_retrans;
> > -                             g.data_segs_in = skops->data_segs_in;
> > -                             g.data_segs_out = skops->data_segs_out;
> > -                             g.bytes_received = skops->bytes_received;
> > -                             g.bytes_acked = skops->bytes_acked;
> > +                             global.total_retrans = skops->total_retrans;
> > +                             global.data_segs_in = skops->data_segs_in;
> > +                             global.data_segs_out = skops->data_segs_out;
> > +                             global.bytes_received = skops->bytes_received;
> > +                             global.bytes_acked = skops->bytes_acked;
> >                       }
> > -                     g.num_close_events++;
> > -                     bpf_map_update_elem(&global_map, &key, &g,
> > -                                         BPF_ANY);
> It is interesting that there is no race in the original "g.num_close_events++"
> followed by the bpf_map_update_elem().  It seems quite fragile though.

How would it race with the current code though? At this point we are
controlling the sockets in a single thread. As such the close events
should already be serialized shouldn't they? This may have been a
problem with the old code, but even then it was only two sockets so I
don't think there was much risk of them racing against each other
since the two sockets were linked anyway.

> > +                     global.num_close_events++;
> There is __sync_fetch_and_add().
>
> not sure about the global.event_map though, may be use an individual
> variable for each _CB.  Thoughts?

I think this may be overkill for what we actually need. Since we are
closing the sockets in a single threaded application there isn't much
risk of the sockets all racing against each other in the close is
there?
