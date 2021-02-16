Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508E131C8CE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhBPK3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:29:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhBPK3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613471281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XToqPgDd1iIoF6n+DUtGOrT7LRsJ+LX6wHH+yYB5kVM=;
        b=boqQcAKftmM4GeVSPbJBxB9LpsQ7/D2O3YdwEfzR9/uvexeF1XU7j3vmw31zCf7WGKRqp8
        u2gZfxizMj/mT6w37kdPn7OdeYAssMQCFWpBmjHUmSy8qGZozmtEn/f/BDkkFRK4VJJfOO
        L/cM5zTKJjWDRt9C07ALn8F2yg24hSU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-z-62D-N1NZu1oHRTZqZdgA-1; Tue, 16 Feb 2021 05:27:59 -0500
X-MC-Unique: z-62D-N1NZu1oHRTZqZdgA-1
Received: by mail-ej1-f71.google.com with SMTP id m4so5795842ejc.14
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:27:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XToqPgDd1iIoF6n+DUtGOrT7LRsJ+LX6wHH+yYB5kVM=;
        b=H8yrxTfPlK+GrLhdbN0ZI/IeCCVoJa84DUTomODQQuzlKFTEPynUflytngIbCmuqjQ
         2Yx+IpFD1U/WsxVj3K3akqaa3f6mxJPjxFMovVn9EE+DOmfC5f8fWK2BVv8mLVPs9/Be
         wMBQvBB9S1v+4R1QXsqaX5ZyVx7Y8Rtem/4E3b7YlImr5e7s+UdULDkTIaEr1PnKQCSa
         wiWniPP9IXfDTO94taWPRu9M67/DBIGG7y9Ah5l3f483wI+OK5QilfBbCxY/LEZ90WGr
         u85C6kNH5/+XHIYZapM/vDNRhVP9jb6ptX9oFpD+WOv01BSvXz8gdyceusbZEJNcaxft
         ABvw==
X-Gm-Message-State: AOAM532KPT52/Bh7U8AkWQhDNHZMdirwsc3rzzQu5H+XihTsllQPeu56
        X2KCfKF1Dufk03cOEI+j4prIl+9/qBUrGTCiMOGvQ807zMJm9bKz7+hvaKtOlAo6UjI+cl2DJ0r
        Kb5EGtCdr+r837CpY
X-Received: by 2002:aa7:cb53:: with SMTP id w19mr16050974edt.324.1613471277949;
        Tue, 16 Feb 2021 02:27:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/egPCVi9iTXdcy8/YmCmqtJE2YosUrYJ6mK1Qx4d7n8rgbnDbhBjGDaVEZsvcyKyPRO3N4A==
X-Received: by 2002:aa7:cb53:: with SMTP id w19mr16050959edt.324.1613471277678;
        Tue, 16 Feb 2021 02:27:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x17sm7436700eju.36.2021.02.16.02.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:27:57 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A81661805FA; Tue, 16 Feb 2021 11:27:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
In-Reply-To: <20210216020128.GA9572@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk> <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <875z2tcef2.fsf@toke.dk> <20210216020128.GA9572@ranger.igk.intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Feb 2021 11:27:55 +0100
Message-ID: <87sg5wb93o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Mon, Feb 15, 2021 at 08:35:29PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:
>>=20
>> > On 2021-02-15 18:07, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>> >>=20
>> >>> Currently, if there are multiple xdpsock instances running on a sing=
le
>> >>> interface and in case one of the instances is terminated, the rest of
>> >>> them are left in an inoperable state due to the fact of unloaded XDP
>> >>> prog from interface.
>> >>>
>> >>> To address that, step away from setting bpf prog in favour of bpf_li=
nk.
>> >>> This means that refcounting of BPF resources will be done automatica=
lly
>> >>> by bpf_link itself.
>> >>>
>> >>> When setting up BPF resources during xsk socket creation, check whet=
her
>> >>> bpf_link for a given ifindex already exists via set of calls to
>> >>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by=
_fd
>> >>> and comparing the ifindexes from bpf_link and xsk socket.
>> >>=20
>> >> One consideration here is that bpf_link_get_fd_by_id() is a privileged
>> >> operation (privileged as in CAP_SYS_ADMIN), so this has the side effe=
ct
>> >> of making AF_XDP privileged as well. Is that the intention?
>> >>
>> >
>> > We're already using, e.g., bpf_map_get_fd_by_id() which has that
>> > as well. So we're assuming that for XDP setup already!
>>=20
>> Ah, right, didn't realise that one is CAP_SYS_ADMIN as well; I
>> remembered this as being specific to the bpf_link operation.
>>=20
>> >> Another is that the AF_XDP code is in the process of moving to libxdp
>> >> (see in-progress PR [0]), and this approach won't carry over as-is to
>> >> that model, because libxdp has to pin the bpf_link fds.
>> >>
>> >
>> > I was assuming there were two modes of operations for AF_XDP in libxdp.
>> > One which is with the multi-program support (which AFAIK is why the
>> > pinning is required), and one "like the current libbpf" one. For the
>> > latter Maciej's series would be a good fit, no?
>>=20
>> We haven't added an explicit mode switch for now; libxdp will fall back
>> to regular interface attach if the kernel doesn't support the needed
>> features for multi-attach, but if it's possible to just have libxdp
>> transparently do the right thing I'd much prefer that. So we're still
>> exploring that (part of which is that Magnus has promised to run some
>> performance tests to see if there's a difference).
>>=20
>> However, even if there's an explicit mode switch I'd like to avoid
>> different *semantics* between the two modes if possible, to keep the two
>> as compatible as possible. And since we can't currently do "auto-detach
>> on bpf_link fd close" when using multi-prog, introducing this now would
>> lead to just such a semantic difference. So my preference would be to do
>> it differently... :)
>>=20
>> >> However, in libxdp we can solve the original problem in a different w=
ay,
>> >> and in fact I already suggested to Magnus that we should do this (see
>> >> [1]); so one way forward could be to address it during the merge in
>> >> libxdp? It should be possible to address the original issue (two
>> >> instances of xdpsock breaking each other when they exit), but
>> >> applications will still need to do an explicit unload operation before
>> >> exiting (i.e., the automatic detach on bpf_link fd closure will take
>> >> more work, and likely require extending the bpf_link kernel support).=
..
>> >>
>> >
>> > I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
>> > we're months ahead, then I'd really like to see this in libbpf until t=
he
>> > merge. However, I'll leave that for Magnus/you to decide!
>
> WDYM by libbpf 1.0/libxdp merge? I glanced through thread and I saw that
> John was also not aware of that. Not sure where it was discussed?
>
> If you're saying 'merge', then is libxdp going to be a part of kernel or
> as an AF-XDP related guy I would be forced to include yet another
> repository in the BPF developer toolchain? :<

As I replied to John, we're trying to do this in as compatible and
painless a way as possible. In particular, we'll maintain (source) API
compatibility with the code currently in libbpf. And yeah, currently
libxdp lives outside the kernel tree. Not sure whether we'll end up
moving it into the kernel tree, as Bj=C3=B6rn noted up-thread there are
arguments in both directions :)

>> Well, as far as libxdp support goes, the PR I linked is pretty close to
>> being mergeable. One of the few outstanding issues is whether we should
>> solve just this issue before merging, actually :)
>>=20
>> Not sure exactly which timeframe Andrii is envisioning for libbpf 1.0,
>> but last I heard he'll announce something next week.
>>=20
>> > Bottom line; I'd *really* like bpf_link behavior (process scoped) for
>> > AF_XDP sooner than later! ;-)
>>=20
>> Totally agree that we should solve the multi-process coexistence
>> problem! And as I said, I think we can do so in libxdp by using the same
>> synchronisation mechanism we use for setting up the multi-prog
>> dispatcher. So it doesn't *have* to hold things up :)
>
> Am I reading this right or you're trying to reject the fix of the long
> standing issue due to a PR that is not ready yet on a standalone
> project/library? :P

Haha, no, that is not what I'm saying. As I said up-thread I agree that
this is something we should fix, obviously. I'm just suggesting we fix
it in a way that will also be compatible with libxdp and multiprog so we
won't have to introduce yet-another-flag that users will have to decide
on.

However, now that I'm looking at your patch again I think my fears may
have been overblown. I got hung up on the bit in the commit message
where you said "refcounting of BPF resources will be done automatically
by bpf_link itself", and wrongly assumed that you were exposing the
bpf_link fd to the application. But I see now that it's kept in the
private xsk_ctx structure, and applications still just call
xsk_socket__delete(). So in libxdp we can just implement the same API
with a different synchronisation mechanism; that's fine. Apologies for
jumping to conclusions :/

> Once libxdp is the standard way of playing with AF-XDP and there are
> actual users of that, then I'm happy to work/help on that issue.

That is good to know, thanks! I opened an issue in the xdp-tools
repository to track this for the libxdp side (Magnus and I agreed that
we'll merge the existing code first, then fix this on top):
https://github.com/xdp-project/xdp-tools/issues/93

As noted above, the mechanism may have to change, but I think it's
possible to achieve the same thing in a libxdp context :)

-Toke

