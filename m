Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C44448E486
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbiANGzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234354AbiANGzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:55:37 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05056C061574;
        Thu, 13 Jan 2022 22:55:37 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id x33so15361124uad.12;
        Thu, 13 Jan 2022 22:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d+JwdG0zfAD9delZPfW9ChzpcoiNXXynJtxy3L9+B2Y=;
        b=hpKMa5Ej3YQFQTSgQXV53q1mmpKke9ERqJR8POXKS2b7kHeFwKXGTew+a0uZPEaq98
         iXVsUZkLTsGcTRkOeidha9GZgTMydhixKlfR+h4P7xmTZMwo3o9WwzZTA1SsmjDDqUAs
         qe59BdeIgCy90sQLhU5VJwox/BerK79bByb9BwKauo9b9986+Kr/vJcxRb/Hr9BU3dxV
         PCSgqYDV4uuAGTusmab5a45++Vh2n9vzscuGcJh2zMV4D6EQAKK+dt6XoKhcXCiF+IXp
         tJ9a5G6TfNV/kbTEl923B9FgJrJiewG5PxhTi7iUPrLTxZNlFJeluo+0rRd3mW5hqD3w
         eQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+JwdG0zfAD9delZPfW9ChzpcoiNXXynJtxy3L9+B2Y=;
        b=dinW1ewvYkcihPQG4xyO6wWYO88YrFWLO1SL0FlmzXakrm2/qfclCIUqWRR2Cok88b
         5AWJbFDctsgLjjgy04ENfqwVFRy+zp/M+8+zBt7HV16mZLK41q5B3pPek9pqfmq3VPSM
         r0YNwpmfYniHRINgfgDr8fl61LXLATRxPxcZjF8KzPIiDmynW9wd3nnc1FrUYcSwqkQz
         8Q9iPj1WJln+QREkzjb0pukhTDn3HW6bpjhGCK0u2zGSDq3ybJX0CZUxXF0CXU9HEDek
         quPyMVKV2U1hbO0Ay2ShKVFenIdjXqJfTdhtCpW0RqK0okstu1aRGqHLPRB49cckQzkm
         7aKg==
X-Gm-Message-State: AOAM533hERarRRFQ78ApMBhszhAxDlLNcWwnkc5ZuxyCO2hldS4Wxqdl
        1R6CBNPPrn8FH3HCeIeYtO7NdhVBRY8zYqZHU4Y=
X-Google-Smtp-Source: ABdhPJwCWBOgyAay2e430T/PmmcQkABGWvipb5KARaqpVnMnNEPY2AdFbeJuzAfKtQ8mEJJUw3S+Z6nQmWgqv96HMVw=
X-Received: by 2002:a67:f7c6:: with SMTP id a6mr3713563vsp.37.1642143336079;
 Thu, 13 Jan 2022 22:55:36 -0800 (PST)
MIME-Version: 1.0
References: <20220113000650.514270-1-quic_twear@quicinc.com>
 <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
 <BYAPR02MB523848C2591E467973B5592EAA539@BYAPR02MB5238.namprd02.prod.outlook.com>
 <BYAPR02MB5238AEC23C7287A41C44C307AA549@BYAPR02MB5238.namprd02.prod.outlook.com>
In-Reply-To: <BYAPR02MB5238AEC23C7287A41C44C307AA549@BYAPR02MB5238.namprd02.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 13 Jan 2022 22:55:24 -0800
Message-ID: <CAADnVQJc=qgz47S1OuUBmX5Rb_opZUCADKqzqGnBruxtJONO7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
To:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 10:49 PM Tyler Wear (QUIC)
<quic_twear@quicinc.com> wrote:
>
> > > This is wrong.
> > > CGROUP_INET_EGRESS bpf prog cannot arbitrary change packet data.
> > > The networking stack populated the IP header at that point.
> > > If the prog changes it to something else it will be confusing other
> > > layers of stack. neigh(L2) will be wrong, etc.
> > > We can still change certain things in the packet, but not arbitrary bytes.
> > >
> > > We cannot change the DS field directly in the packet either.
> > > It can only be changed by changing its value in the socket.
> >
> > Why is the DS field unchangeable, but ecn is changeable?
>
> Per spec the requirement is to modify the ds field of egress packets with DSCP value. Setting ds field on socket will not suffice here.
> Another case is where device is a middle-man and needs to modify the packets of a connected tethered client with the DSCP value, using a sock will not be able to change the packet here.

If DS field needs to be changed differently for every packet
it's better to use TC layer for this task.
qdiscs may send packets with different DSs to different queues.
