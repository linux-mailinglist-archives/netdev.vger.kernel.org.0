Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7661B2DB
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfEMJ3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:29:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37490 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEMJ3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 05:29:24 -0400
Received: by mail-qk1-f196.google.com with SMTP id d10so1485256qko.4
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 02:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JYAhsIjOCDyZLiNPqfJ/mGtPOTdfNLZCA07rsuB6wtU=;
        b=G9ITC3BGCN6KSvxvVVz4CC/gRUR2yvDSqB6186QVgNJk8jo04FTFcfmOOYn/iOtZ+u
         5yBLS8ty9jL7XxBICRD5d4azQmg51c2u8sn/WZxLPmhE/k1xR4mB3K22n7SPGZuf5wOU
         5ggGv7sJT34HT/FgjDucO644Br5VxCjRQcpa42XD9N/JNvVOtLErgpurALsSjeEhnnbx
         g9LjYkt9i5vg+orxQqZuIncL9snjCnicNWwzltFFVizRuSeL2fZhmP6TEoLZz4WaCG3g
         r/cPkuOjx9qlyI8OkE4bCemwrx3mA7P7P0pRUg/9wkpDTR94R/8KYjb5iQoEMo/oQeqr
         SQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JYAhsIjOCDyZLiNPqfJ/mGtPOTdfNLZCA07rsuB6wtU=;
        b=BeZE2fm3IW2oStKWp30ullXmAhWysUetssBOsbzZOvqrJrJ5BVuY+1lqA81lyrhreM
         ZBQnU/ekfNMYLzJ9eMnSIob07TSMaxRIRst/7BG5cmIECJTQtfNeLWorhMYUFDUTo6Em
         UUeCFUXo2LqCnoWpIQvj5xTnh+T91qNVxvDCEvfj4KQZmtbTELFmiNu4U8Eg6Wy5bl4s
         QvOMougQOtlSyIWD2rxAgW0kkFMPCcYGHm78esNcbbMtmHenp+YPGE+BaqYfM1eFwlNW
         zrNX05NfwVClJZPYe5kCN+Y4W8z1b+RVuhtzMHWiKF5SFAlnYsyX8u0tGQoBb3EjZLab
         lI9A==
X-Gm-Message-State: APjAAAUtT9bF+Ql53Gahg2DBPjPOHvw3YzV8Nz6fTA2KpQk3HY5aNsAG
        sujGFbG9Txh+i48QLmFf44GU6ykSX4pujllcGQk=
X-Google-Smtp-Source: APXvYqyIldWO0ZkOvoXJn3I/OqR4nvekRoSET494z6diXvOrs0p6tCimCtgKkG6q0kl5zJPeoujCuTm6bEuh4aPnk+k=
X-Received: by 2002:a37:5f41:: with SMTP id t62mr21620574qkb.141.1557739763307;
 Mon, 13 May 2019 02:29:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190508225016.2375828-1-jonathan.lemon@gmail.com>
 <CAJ+HfNj4NgGQkJOEivuxuohA_+Fa98yD8EmY4acHQqymdUBA4g@mail.gmail.com>
 <7974B49C-CC4F-475D-992A-3E5B6480B039@gmail.com> <9a1a0d6a-d7d4-406a-6bad-26f222df073f@fb.com>
In-Reply-To: <9a1a0d6a-d7d4-406a-6bad-26f222df073f@fb.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 13 May 2019 11:29:12 +0200
Message-ID: <CAJ+HfNjDCFYAiaYNXHc7jFJBB1ZfbZXd3xxdPsd93sMyNiCeNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an xskmap
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 May 2019 at 20:36, Alexei Starovoitov <ast@fb.com> wrote:
>
> On 5/9/19 9:12 AM, Jonathan Lemon wrote:
> > On 9 May 2019, at 4:48, Bj=C3=B6rn T=C3=B6pel wrote:
> >
> >> On Thu, 9 May 2019 at 01:07, Jonathan Lemon <jonathan.lemon@gmail.com>
> >> wrote:
> >>>
> >>> Currently, the AF_XDP code uses a separate map in order to
> >>> determine if an xsk is bound to a queue.  Instead of doing this,
> >>> have bpf_map_lookup_elem() return a boolean indicating whether
> >>> there is a valid entry at the map index.
> >>>
> >>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> >>> ---
> >>>  kernel/bpf/verifier.c                             |  6 +++++-
> >>>  kernel/bpf/xskmap.c                               |  2 +-
> >>>  .../selftests/bpf/verifier/prevent_map_lookup.c   | 15 -------------=
--
> >>>  3 files changed, 6 insertions(+), 17 deletions(-)
> >>>
> >>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>> index 7b05e8938d5c..a8b8ff9ecd90 100644
> >>> --- a/kernel/bpf/verifier.c
> >>> +++ b/kernel/bpf/verifier.c
> >>> @@ -2761,10 +2761,14 @@ static int
> >>> check_map_func_compatibility(struct bpf_verifier_env *env,
> >>>          * appear.
> >>>          */
> >>>         case BPF_MAP_TYPE_CPUMAP:
> >>> -       case BPF_MAP_TYPE_XSKMAP:
> >>>                 if (func_id !=3D BPF_FUNC_redirect_map)
> >>>                         goto error;
> >>>                 break;
> >>> +       case BPF_MAP_TYPE_XSKMAP:
> >>> +               if (func_id !=3D BPF_FUNC_redirect_map &&
> >>> +                   func_id !=3D BPF_FUNC_map_lookup_elem)
> >>> +                       goto error;
> >>> +               break;
> >>>         case BPF_MAP_TYPE_ARRAY_OF_MAPS:
> >>>         case BPF_MAP_TYPE_HASH_OF_MAPS:
> >>>                 if (func_id !=3D BPF_FUNC_map_lookup_elem)
> >>> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> >>> index 686d244e798d..f6e49237979c 100644
> >>> --- a/kernel/bpf/xskmap.c
> >>> +++ b/kernel/bpf/xskmap.c
> >>> @@ -154,7 +154,7 @@ void __xsk_map_flush(struct bpf_map *map)
> >>>
> >>>  static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
> >>>  {
> >>> -       return ERR_PTR(-EOPNOTSUPP);
> >>> +       return !!__xsk_map_lookup_elem(map, *(u32 *)key);
> >>>  }
> >>>
> >>
> >> Hmm, enabling lookups has some concerns, so we took the easy path;
> >> simply disallowing it. Lookups (and returning a socket/fd) from
> >> userspace might be expensive; allocating a new fd, and such, and on
> >> the BPF side there's no XDP socket object (yet!).
> >>
> >> Your patch makes the lookup return something else than a fd or socket.
> >> The broader question is, inserting a socket fd and getting back a bool
> >> -- is that ok from a semantic perspective? It's a kind of weird map.
> >> Are there any other maps that behave in this way? It certainly makes
> >> the XDP code easier, and you get somewhat better introspection into
> >> the XSKMAP.
> >
> > I simply want to query the map and ask "is there an entry present?",
> > but there isn't a separate API for that.  It seems really odd that I'm
> > required to duplicate the same logic by using a second map.  I agree th=
at
> > there isn't any point in returning an fd or xdp socket object - hence
> > the boolean.
> >
> > The comment inthe verifier does read:
> >
> >          /* Restrict bpf side of cpumap and xskmap, open when use-cases
> >           * appear.
> >
> > so I'd say this is a use-case.  :)
> >
> > The cpumap cpu_map_lookup_elem() function returns the qsize for some
> > reason, but it doesn't seem reachable from the verifier.
>
> I think it's good to expose some info about xsk to bpf prog.
> Returning bool is kinda single purpose.
> Can xsk_map_lookup_elem() return xsk.sk.sk_cookie instead?
> I think we can force non zero cookie for all xsk sockets
> then returning zero would mean that socket is not there
> and can solve this use case as well.
> Or some other property of xsk ?
>
> Probably better idea would be to return 'struct bpf_sock *' or
> new 'struct bpf_xdp_sock *' and teach the verifier to extract
> xsk.queue_id or other interesting info from it.
> I think it's safe to do, since progs run under rcu.

Good ideas, definitely worth trying out! ...and again, getting rid of
that extra map is very clean!
