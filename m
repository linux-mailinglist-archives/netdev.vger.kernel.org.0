Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7551BFCF
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfEMXV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:21:58 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34065 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfEMXV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:21:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id j24so11757711ljg.1
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 16:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=usZ7dwyRR+3GeIPEvqkM88EGijuVH3/Cv36U2/TTyiY=;
        b=dWazMbZR+sO35lEPXVuRO1sSIp7Hv3fogNTag5CNb+OlxTqbriNzTjaLMhVuFEP9X+
         w/D6yd+KRdNAI4u2jOq4mJsakXia1E1NsLlnQ6UFn1AkoHumeXIaKeaTdq1rDcPbHJuP
         WG+Vf3OvBGQan8o9ay1zFVH2f4mUcdoYYIJ58K8STFieRt1No2j4jFbOb740hcBhdIgF
         WUqZMsYdu9K5HU+vWDaDZjHu4VORHORz75E7rVFEGopV7wC9Hi1045oXtZ2zNcPBOuwb
         SYD55A1ndcTShavRM6Vb7BxrZdPETuhVNK3Te8R3/O+btCj8+S+9hD4QhNb4PgXp/wvJ
         032g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=usZ7dwyRR+3GeIPEvqkM88EGijuVH3/Cv36U2/TTyiY=;
        b=hd5VDxXn4qhfurGxnYzezeecPhK+KxwNjQ9wQ5+mtVReXt2mFPPrLTqHLDUu1XCF/D
         49AnK6lFD4H4rEiUDP8uSu7U2ch+kd//Ut5xMdINt7hdfzTw57+DHL/1BJM7nbSuZ4wo
         jGv3IizKwifuhYmLktk1QQWcgnR9O182ZeO7JIvvj4Z9N1OGN0S52qj56HPDecLIF75r
         GsiNGmgVLKZErNVoSSVM9+B5BgAEUQRyk1UmjqalgjKcdyA8qfHx7fUOzWdKzluk9KNm
         FqZ2y7+L1EwPb18GIeh/3OYOHQKMg8F9ZAJscTZHzs4R+LcR3Jfo7CO73UiDAMA7Dw1M
         lbFQ==
X-Gm-Message-State: APjAAAVd4xbB+gEXoktBweUcGrlMaijARUwcWLq30VpiZFfcTeGXPHlo
        +lp/l9SxnJxg5Fd9w66CSF+Kqr6HUJhuuJ5tbgq5Bw==
X-Google-Smtp-Source: APXvYqxEmi2HIxrG0K6Hr3e6JQIivADgNMiuAVKmOaaQ17Buo1e9beRdOxLIr6xpQuCG71ebzdxPbSkBd4craY2TcCg=
X-Received: by 2002:a2e:9897:: with SMTP id b23mr955942ljj.157.1557789715211;
 Mon, 13 May 2019 16:21:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190513185402.220122-1-sdf@google.com> <CAF=yD-LO6o=uZ-aT-J9uPiBcO4f2Zc9uyGZ+f7M7mPtRSB44gA@mail.gmail.com>
 <20190513210239.GC24057@mini-arch> <CAF=yD-JKbzuoF_q7gPRjMNCBexn4pxgQ6pTeQSRfPXmwWk5dzg@mail.gmail.com>
 <CAF=yD-Lg16ETT09=fRd2FTx2FJoGZ9K0s-JHrhv-9OMTqE+5BQ@mail.gmail.com> <20190513230513.GA10244@mini-arch>
In-Reply-To: <20190513230513.GA10244@mini-arch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 13 May 2019 16:21:30 -0700
Message-ID: <CAKH8qBvG00EJVQ+YqNDOP-YuCRACB0q0c9G51Dgow9a1uzZnGQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: support FLOW_DISSECTOR_KEY_ETH_ADDRS
 with BPF
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 05/13, Willem de Bruijn wrote:
> > On Mon, May 13, 2019 at 5:21 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Mon, May 13, 2019 at 5:02 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 05/13, Willem de Bruijn wrote:
> > > > > On Mon, May 13, 2019 at 3:53 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > > >
> > > > > > If we have a flow dissector BPF program attached to the namespace,
> > > > > > FLOW_DISSECTOR_KEY_ETH_ADDRS won't trigger because we exit early.
> > > > >
> > > > > I suppose that this is true for a variety of keys? For instance, also
> > > > > FLOW_DISSECTOR_KEY_IPV4_ADDRS.
> > >
> > > > I though the intent was to support most of the basic stuff (eth/ip/tcp/udp)
> > > > without any esoteric protocols.
> > >
> > > Indeed. But this applies both to protocols and the feature set. Both
> > > are more limited.
> > >
> > > > Not sure about FLOW_DISSECTOR_KEY_IPV4_ADDRS,
> > > > looks like we support that (except FLOW_DISSECTOR_KEY_TIPC part).
> > >
> > > Ah, I chose a bad example then.
> > >
> > > > > We originally intended BPF flow dissection for all paths except
> > > > > tc_flower. As that catches all the vulnerable cases on the ingress
> > > > > path on the one hand and it is infeasible to support all the
> > > > > flower features, now and future. I think that is the real fix.
> > >
> > > > Sorry, didn't get what you meant by the real fix.
> > > > Don't care about tc_flower? Just support a minimal set of features
> > > > needed by selftests?
> > >
> > > I do mean exclude BPF flow dissector (only) for tc_flower, as we
> > > cannot guarantee that the BPF program can fully implement the
> > > requested feature.
> >
> > Though, the user inserting the BPF flow dissector is the same as the
> > user inserting the flower program, the (per netns) admin. So arguably
> > is aware of the constraints incurred by BPF flow dissection. And else
> > can still detect when a feature is not supported from the (lack of)
> > output, as in this case of Ethernet address. I don't think we want to
> > mix BPF and non-BPF flow dissection though. That subverts the safety
> > argument of switching to BPF for flow dissection.
> Yes, we cannot completely avoid tc_flower because we use it to do
> the end-to-end testing. That's why I was trying to make sure "basic"
> stuff works (it might feel confusing that tc_flower {src,dst}_mac
> stop working with a bpf program installed).
>
> TBH, I'd not call this particular piece of code that exports src/dst
> addresses a dissection. At this point, it's a well-formed skb with
> a proper l2 header and we just copy the addresses out. It's probably
> part of the reason the original patch didn't include any skb->protocol
> checks.
On the other hand, we can probably follow a simple rule:
if it's not exported via bpf_flow_keys (and src/dsc mac is not),
tc_flower is not supported as well.
