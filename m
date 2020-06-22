Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71582203EE1
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgFVSOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730099AbgFVSOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 14:14:32 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7A8C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 11:14:32 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a12so6976278ion.13
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 11:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Dnp918H1zFMQvrO8JQK/eY/lBMo9tUkoUuXD/fFg+E=;
        b=MAJ5vGCW6SOLHHjF91Ge7YJ/p5yWG0QjgS8ccW/4a08hj4HRwcR7r6L2AuguSfZHNQ
         re2BeZkKxOcKQi0fJFc0CYZYnmbtNv85b+7LyCKWNNmxUsL7cR2FAycI56AlTDV9h4m2
         zxKrzOtw16SHbgBLUK5lwfoBTHgOHqL+usEKbLce788JGXivi3nvB+mSZyWqfbMRWaIV
         vJX/1Zlw+7hQpeH1mHsEFR3GtNrkFv8kd7fvV5luj6DYPfhyshpplqZzRFKivdS7Qddu
         Bp4sgudFLNBBp/aFfLtPj1n0Vp8qnpPtFt4ieHijVOOfrkc0UzdBFp0U+xCZ1QJFaakY
         NyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Dnp918H1zFMQvrO8JQK/eY/lBMo9tUkoUuXD/fFg+E=;
        b=R5zh5mXBoPKkWV8jKWRnPOy0tTdqCVaTS5cB+gTStCVBWumPETev/NXZ8apaQdd4Ym
         XbnsBFUxd8oKAkoCnkyRv69phdSxleNnT3QoNsJEQ8PSaUkrBnJOxpWDOGryZC/MKBYU
         i+Ovwy250PfYSZ+m0JljQJS4ht1sFSAjzHhDJBYzZB3ebXSngAtvOn1u0UCu3nfdtJ3U
         3xjwb85Qxe0JMe7xyQ6I1LPJh8R+p14JvcyonHe3wKyM5Ai6XezvRb3Y3bIcyWfsAGDY
         v4zgPpwoJ0Pz3DB7trU341W2QSazemSrapCwzq66Ui1PP3TZZ8PluCe7L4d+CK39G4wN
         ruuQ==
X-Gm-Message-State: AOAM530Kke7ASDUZ5ZAn1aNq+WohW5BDu5Fz38utwhv9mOFvNWub8jMY
        nOrLRfpKLkEJOlJhllabiy04Ow7cFUDBxtfetw0=
X-Google-Smtp-Source: ABdhPJwdGsUyIxWh1VJ1GjdO8vh40BnLCXXYmsfEkZfh95TJLSicP3qFglCh9mKW6m+kTy1M2vswMF9XvTgs9HGGdl0=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr19975685iol.85.1592849671480;
 Mon, 22 Jun 2020 11:14:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com> <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com> <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com> <20200620005115.GE237539@carbon.dhcp.thefacebook.com>
 <f80878fe-bf2d-605a-50e4-bda97a1390c2@huawei.com> <20200620011409.GG237539@carbon.dhcp.thefacebook.com>
 <CAM_iQpUmajKqeYW9uwtEiFeZGz=q7DFYQT5sq_27yaqoudewuQ@mail.gmail.com> <20200620155751.GJ237539@carbon.dhcp.thefacebook.com>
In-Reply-To: <20200620155751.GJ237539@carbon.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 22 Jun 2020 11:14:20 -0700
Message-ID: <CAM_iQpVTwkxep3RCcwqCE0rypwj5prLdbE4oEUTyev+RxQq37Q@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Roman Gushchin <guro@fb.com>
Cc:     Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 8:58 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Fri, Jun 19, 2020 at 08:00:41PM -0700, Cong Wang wrote:
> > On Fri, Jun 19, 2020 at 6:14 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Sat, Jun 20, 2020 at 09:00:40AM +0800, Zefan Li wrote:
> > > > I think so, though I'm not familiar with the bfp cgroup code.
> > > >
> > > > > If so, we might wanna fix it in a different way,
> > > > > just checking if (!(css->flags & CSS_NO_REF)) in cgroup_bpf_put()
> > > > > like in cgroup_put(). It feels more reliable to me.
> > > > >
> > > >
> > > > Yeah I also have this idea in my mind.
> > >
> > > I wonder if the following patch will fix the issue?
> >
> > Interesting, AFAIU, this refcnt is for bpf programs attached
> > to the cgroup. By this suggestion, do you mean the root
> > cgroup does not need to refcnt the bpf programs attached
> > to it? This seems odd, as I don't see how root is different
> > from others in terms of bpf programs which can be attached
> > and detached in the same way.
> >
> > I certainly understand the root cgroup is never gone, but this
> > does not mean the bpf programs attached to it too.
> >
> > What am I missing?
>
> It's different because the root cgroup can't be deleted.
>
> All this reference counting is required to automatically detach bpf programs
> from a _deleted_ cgroup (look at cgroup_bpf_offline()). It's required
> because a cgroup can be in dying state for a long time being pinned by a
> pagecache page, for example. Only a user can detach a bpf program from
> an existing cgroup.

Yeah, but users can still detach the bpf programs from root cgroup.
IIUC, after detaching, the pointer in the bpf array will be empty_prog_array
which is just an array of NULL. Then __cgroup_bpf_run_filter_skb() will
deref it without checking NULL (as check_non_null == false).

This matches the 0000000000000010 pointer seen in the bug reports,
the 0x10, that is 16, is the offset of items[] in struct bpf_prog_array.
So looks like we have to add a NULL check there regardless of refcnt.

Also, I am not sure whether your suggested patch makes a difference
for percpu refcnt, as percpu_ref_put() will never call ->release() until
percpu_ref_kill(), which is never called on root cgroup?

Thanks.
