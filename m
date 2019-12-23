Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDB8129B39
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 22:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfLWVol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 16:44:41 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45217 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfLWVol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 16:44:41 -0500
Received: by mail-qt1-f193.google.com with SMTP id l12so16473173qtq.12;
        Mon, 23 Dec 2019 13:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yWiQz91Eg8mICpk2PQ5gaHMnGPfj/rqP1re70cxjnC8=;
        b=LhxXUN7Qh9wmEmx6JYXtzHRjxNxDhWZcUUUdwvbUfVm6IRY0naf+xAgTZxDuD+nIuC
         TY01so5ekeF/QrNWD5E9n08ApXmF7InzAbc9Qeq6DaziAaNxjipfyPFl0La+nBDG1xvT
         IWiA0xsq+ud1fZ55bYyPgzt5t0YxaDJZsFOAbXLg1FjYcCZ8Hayj9WA6nLVeg0zZXTJI
         A4hB73ah1kduovKThZ2B8wH9np9sX/9i7Sm4gLlc4+qgwUVYzNVfwZFz3IY+rI5q7HNw
         TwUITliYDgf9OwJ3XM4RP3uT4HwnZdUw4h4PFxw54ZZ8++4cBlpD6m2rQj7fAmk6ZWMV
         /XCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yWiQz91Eg8mICpk2PQ5gaHMnGPfj/rqP1re70cxjnC8=;
        b=egZXBFJMHeaiRfc6TBisOYnu58QJ2SzZ0jQANkltQXFYoKfp3NuMZS7OfeI/DFaAVE
         uMnaLbKFlmmKJulPDAyJ4RqWv6ySmSkCBKHoWVTuNgGuOybiKsz2A1M6insQYVCI1LHN
         Fkjtl9JLfD8kTnNLKmNadMecsKg41RX6x6MH2/lslkbPIOtmFxAjbrD4f+t+1R2ybgpN
         Li0ANS0XVHXWBPVsiHIhyd0G9sm1Um9kPyKTrtBefYHVjqRTDRSUsW0usGnsVZPr8Phu
         3EnWi7GGgPhFeHWOtmCaYyGamgbKWJMVtX2DWfPPCYD8rnZxmIjDEwXc27S3B+ymmYxm
         zSCw==
X-Gm-Message-State: APjAAAWDGkCRHHlbMDzR/xEZtKfbwzpE/LQtUXmwLAJy+1AfxRe88Tk0
        DWrAuYmCthF52wiQXIdX6bCx+sc6LhOzjZSg+c3eXQXy
X-Google-Smtp-Source: APXvYqyrmVyVElq3Tnv0bXA3T/5Wo+MVStbllcucUsunHdSLkqKmvkItxkmTfSa1O3KMp3Bl6b2IyJQw3c+C9txpJBA=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr24188018qtj.59.1577137480134;
 Mon, 23 Dec 2019 13:44:40 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062608.1183091-1-kafai@fb.com>
 <921201ff-8c8d-b523-5df6-3326f6cd0fd9@fb.com>
In-Reply-To: <921201ff-8c8d-b523-5df6-3326f6cd0fd9@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 13:44:29 -0800
Message-ID: <CAEf4BzYU723WmF=ik26DOS7fAmpiju2rpgJyEZXB0ENF9VNyeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
To:     Yonghong Song <yhs@fb.com>
Cc:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 11:58 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/20/19 10:26 PM, Martin KaFai Lau wrote:
> > The patch introduces BPF_MAP_TYPE_STRUCT_OPS.  The map value
> > is a kernel struct with its func ptr implemented in bpf prog.
> > This new map is the interface to register/unregister/introspect
> > a bpf implemented kernel struct.
> >
> > The kernel struct is actually embedded inside another new struct
> > (or called the "value" struct in the code).  For example,
> > "struct tcp_congestion_ops" is embbeded in:
> > struct bpf_struct_ops_tcp_congestion_ops {
> >       refcount_t refcnt;
> >       enum bpf_struct_ops_state state;
> >       struct tcp_congestion_ops data;  /* <-- kernel subsystem struct here */
> > }
> > The map value is "struct bpf_struct_ops_tcp_congestion_ops".
> > The "bpftool map dump" will then be able to show the
> > state ("inuse"/"tobefree") and the number of subsystem's refcnt (e.g.
> > number of tcp_sock in the tcp_congestion_ops case).  This "value" struct
> > is created automatically by a macro.  Having a separate "value" struct
> > will also make extending "struct bpf_struct_ops_XYZ" easier (e.g. adding
> > "void (*init)(void)" to "struct bpf_struct_ops_XYZ" to do some
> > initialization works before registering the struct_ops to the kernel
> > subsystem).  The libbpf will take care of finding and populating the
> > "struct bpf_struct_ops_XYZ" from "struct XYZ".
> >
> > Register a struct_ops to a kernel subsystem:
> > 1. Load all needed BPF_PROG_TYPE_STRUCT_OPS prog(s)
> > 2. Create a BPF_MAP_TYPE_STRUCT_OPS with attr->btf_vmlinux_value_type_id
> >     set to the btf id "struct bpf_struct_ops_tcp_congestion_ops" of the
> >     running kernel.
> >     Instead of reusing the attr->btf_value_type_id,
> >     btf_vmlinux_value_type_id s added such that attr->btf_fd can still be
> >     used as the "user" btf which could store other useful sysadmin/debug
> >     info that may be introduced in the furture,
> >     e.g. creation-date/compiler-details/map-creator...etc.
> > 3. Create a "struct bpf_struct_ops_tcp_congestion_ops" object as described
> >     in the running kernel btf.  Populate the value of this object.
> >     The function ptr should be populated with the prog fds.
> > 4. Call BPF_MAP_UPDATE with the object created in (3) as
> >     the map value.  The key is always "0".
> >
> > During BPF_MAP_UPDATE, the code that saves the kernel-func-ptr's
> > args as an array of u64 is generated.  BPF_MAP_UPDATE also allows
> > the specific struct_ops to do some final checks in "st_ops->init_member()"
> > (e.g. ensure all mandatory func ptrs are implemented).
> > If everything looks good, it will register this kernel struct
> > to the kernel subsystem.  The map will not allow further update
> > from this point.
> >
> > Unregister a struct_ops from the kernel subsystem:
> > BPF_MAP_DELETE with key "0".
> >
> > Introspect a struct_ops:
> > BPF_MAP_LOOKUP_ELEM with key "0".  The map value returned will
> > have the prog _id_ populated as the func ptr.
> >
> > The map value state (enum bpf_struct_ops_state) will transit from:
> > INIT (map created) =>
> > INUSE (map updated, i.e. reg) =>
> > TOBEFREE (map value deleted, i.e. unreg)
> >
> > The kernel subsystem needs to call bpf_struct_ops_get() and
> > bpf_struct_ops_put() to manage the "refcnt" in the
> > "struct bpf_struct_ops_XYZ".  This patch uses a separate refcnt
> > for the purose of tracking the subsystem usage.  Another approach
> > is to reuse the map->refcnt and then "show" (i.e. during map_lookup)
> > the subsystem's usage by doing map->refcnt - map->usercnt to filter out
> > the map-fd/pinned-map usage.  However, that will also tie down the
> > future semantics of map->refcnt and map->usercnt.
> >
> > The very first subsystem's refcnt (during reg()) holds one
> > count to map->refcnt.  When the very last subsystem's refcnt
> > is gone, it will also release the map->refcnt.  All bpf_prog will be
> > freed when the map->refcnt reaches 0 (i.e. during map_free()).
> >
> > Here is how the bpftool map command will look like:
> > [root@arch-fb-vm1 bpf]# bpftool map show
> > 6: struct_ops  name dctcp  flags 0x0
> >       key 4B  value 256B  max_entries 1  memlock 4096B
> >       btf_id 6
> > [root@arch-fb-vm1 bpf]# bpftool map dump id 6
> > [{
> >          "value": {
> >              "refcnt": {
> >                  "refs": {
> >                      "counter": 1
> >                  }
> >              },
> >              "state": 1,
>
> The bpftool dump with "state" 1 is a little bit cryptic.
> Since this is common for all struct_ops maps, can we
> make it explicit, e.g., as enum values, like INIT/INUSE/TOBEFREE?

This can (and probably should) be done generically in bpftool for any
field of enum type. Not blocking this patch set, though.

>
> >              "data": {
> >                  "list": {
> >                      "next": 0,
> >                      "prev": 0
> >                  },
> >                  "key": 0,
> >                  "flags": 2,
> >                  "init": 24,
> >                  "release": 0,
> >                  "ssthresh": 25,
> >                  "cong_avoid": 30,
> >                  "set_state": 27,
> >                  "cwnd_event": 28,
> >                  "in_ack_event": 26,
> >                  "undo_cwnd": 29,
> >                  "pkts_acked": 0,
> >                  "min_tso_segs": 0,
> >                  "sndbuf_expand": 0,
> >                  "cong_control": 0,
> >                  "get_info": 0,
> >                  "name": [98,112,102,95,100,99,116,99,112,0,0,0,0,0,0,0
> >                  ],

Same here, bpftool should be smart enough to figure out that this is a
string, not just an array of bytes.

> >                  "owner": 0
> >              }
> >          }
> >      }
> > ]
> >

[...]
