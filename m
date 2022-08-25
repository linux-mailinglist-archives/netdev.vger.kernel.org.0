Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CDF5A1A81
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243788AbiHYUja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243896AbiHYUjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:39:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33139BD771;
        Thu, 25 Aug 2022 13:39:14 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q2so25458035edb.6;
        Thu, 25 Aug 2022 13:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=zh+rsVhs6RHx+r2VsK9thtDxlesJsxRCbV60iL9P0Vc=;
        b=oN0+X9r4GXeCrnJKxuiZzx0FmmzWQC/LQOWBmI4YtoylyC6+rYkX0Dxf82F10VEmxm
         2LFokK4FAnYA1NrPhHBjy2lZVKQsNyRuZMWxH3OyJUA70/0luGcs6IdkFZ6Y4QhMhjX2
         n0Kdb8HgBve12wBCUXd6M4gebxmzsHLA81hwGfrsX7sK7wqDW8caax8wCvsblF9XnixY
         rEaCrl/Pd4Eaq0xKiOwqsdH57I2eJGoD7LS7OI7Sn98IUlq7aZalEkFta3iyaM42lnth
         2w/TuYA1KUi9JfprFKUKFZHODfUJqwMSpfzSHfYHeXmfgvO8QH/xEGUgZKVgT81ocdVo
         XVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=zh+rsVhs6RHx+r2VsK9thtDxlesJsxRCbV60iL9P0Vc=;
        b=zQME9NFSsIJzy9905IAu01TNftgRNsfNSbyT2vmm/3F2p+ybNEJSvKCZIvRwXOiH5l
         vFztQzs/pqb0HVATB1Km16yXJgdQV2lZ4SMj271Gng0yRsjyzOYFmULhRGOpQjWUPuUj
         GHu0M0LZAj+OkVWejDaTcR8gYfSv+AYo5raw/IDmwfTM0v9kuXXwAkVDOOIn47rM26lC
         QpoVM9yH4wsODeZYq3ZNnmMzonqQfYTLkJ4gQbV3pM9fsJHmTUYXO+2FhlIohmeDxtgf
         1F77LQBHdCsuAYUzNgxrmVV6oQphochGw91c94AhPpiOhbZ+XiSAkDyV7szo2k4hmrEB
         gIuQ==
X-Gm-Message-State: ACgBeo21XKoRC6JI1PjxPzci2pMtVnGTMuCpawPgFQqJL/CCgBzciclc
        JCitSLqhW1oOaxWfOaKngxKUN2mMpj5t6MsMfyY=
X-Google-Smtp-Source: AA6agR5BmmVFRVzpRq40ym3Us7GapEPm8NCzdDoOJTd09LFB7anaLZwiECsDq1HlnFnZZHQbtuO3yZd8CcS7HN95kEs=
X-Received: by 2002:a05:6402:2751:b0:443:d90a:43d4 with SMTP id
 z17-20020a056402275100b00443d90a43d4mr4656933edd.368.1661459952598; Thu, 25
 Aug 2022 13:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com> <CAP01T77A1Z0dbWVzTFMRuHJYN-V8_siMBUg=MqUU3kQzx+Osdg@mail.gmail.com>
In-Reply-To: <CAP01T77A1Z0dbWVzTFMRuHJYN-V8_siMBUg=MqUU3kQzx+Osdg@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 25 Aug 2022 13:39:01 -0700
Message-ID: <CAJnrk1aO0VPmg7pEjNTt2J-JttOYOMGx6GM+hQ1G2J-fkDPN8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, "toke@redhat.com" <toke@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>, lorenzo@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 2:11 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, 24 Aug 2022 at 00:27, Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Mon, Aug 22, 2022 at 7:31 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > > > [...]
> > > >                 if (func_id == BPF_FUNC_dynptr_data &&
> > > > -                   dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > > > +                   (dynptr_type == BPF_DYNPTR_TYPE_SKB ||
> > > > +                    dynptr_type == BPF_DYNPTR_TYPE_XDP)) {
> > > >                         regs[BPF_REG_0].type = PTR_TO_PACKET | ret_flag;
> > > >                         regs[BPF_REG_0].range = meta.mem_size;
> > >
> > > It doesn't seem like this is safe. Since PTR_TO_PACKET's range can be
> > > modified by comparisons with packet pointers loaded from the xdp/skb
> > > ctx, how do we distinguish e.g. between a pkt slice obtained from some
> > > frag in a multi-buff XDP vs pkt pointer from a linear area?
> > >
> > > Someone can compare data_meta from ctx with PTR_TO_PACKET from
> > > bpf_dynptr_data on xdp dynptr (which might be pointing to a xdp mb
> > > frag). While MAX_PACKET_OFF is 0xffff, it can still be used to do OOB
> > > access for the linear area. reg_is_init_pkt_pointer will return true
> > > as modified range is not considered for it. Same kind of issues when
> > > doing comparison with data_end from ctx (though maybe you won't be
> > > able to do incorrect data access at runtime using that).
> > >
> > > I had a pkt_uid field in my patch [0] which disallowed comparisons
> > > among bpf_packet_pointer slices. Each call assigned a fresh pkt_uid,
> > > and that disabled comparisons for them. reg->id is used for var_off
> > > range propagation so it cannot be reused.
> > >
> > > Coming back to this: What we really want here is a PTR_TO_MEM with a
> > > mem_size, so maybe you should go that route instead of PTR_TO_PACKET
> > > (and add a type tag to maybe pretty print it also as a packet pointer
> > > in verifier log), or add some way to distinguish slice vs non-slice
> > > pkt pointers like I did in my patch. You might also want to add some
> > > tests for this corner case (there are some later in [0] if you want to
> > > reuse them).
> > >
> > > So TBH, I kinda dislike my own solution in [0] :). The complexity does
> > > not seem worth it. The pkt_uid distinction is more useful (and
> > > actually would be needed) in Toke's xdp queueing series, where in a
> > > dequeue program you have multiple xdp_mds and want scoped slice
> > > invalidations (i.e. adjust_head on one xdp_md doesn't invalidate
> > > slices of some other xdp_md). Here we can just get away with normal
> > > PTR_TO_MEM.
> > >
> > > ... Or just let me know if you handle this correctly already, or if
> > > this won't be an actual problem :).
> >
> > Ooh interesting, I hadn't previously taken a look at
> > try_match_pkt_pointers(), thanks for mentioning it :)
> >
> > The cleanest solution to me is to add the flag "DYNPTR_TYPE_{SKB/XDP}"
> > to PTR_TO_PACKET and change reg_is_init_pkt_pointer() to return false
> > if the DYNPTR_TYPE_{SKB/XDP} flag is present. I prefer this over
> > returning PTR_TO_MEM because it seems more robust (eg if in the future
> > we reject x behavior on the packet data reg types, this will
> > automatically apply to the data slices), and because it'll keep the
> > logic more efficient/simpler for the case when the pkt pointer has to
> > be cleared after any helper that changes pkt data is called (aka the
> > case where the data slice gets invalidated).
> >
> > What are your thoughts?
> >
>
> Thinking more deeply about it, probably not, we need more work here. I
> remember _now_ why I chose the pkt_uid approach (and this tells us my
> commit log lacks all the details about the motivation :( ).
>
> Consider how equivalency checking for packet pointers works in
> regsafe. It is checking type, then if old range > cur range, then
> offs, etc.
>
> The problem is, while we now don't prune on access to ptr_to_pkt vs
> ptr_to_pkt | dynptr_pkt types in same reg (since type differs we
> return false), we still prune if old range of ptr_to_pkt | dynptr_pkt
> > cur range of ptr_to_pkt | dynptr_pkt. Both could be pointing into
> separate frags, so this assumption would be incorrect. I would be able
> to trick the verifier into accessing data beyond the length of a
> different frag, by first making sure one line of exploration is
> verified, and then changing the register in another branch reaching
> the same branch target. Helpers can take packet pointers so the access
> can become a pruning point. It would think the rest of the stuff is
> safe, while they are not equivalent at all. It is ok if they are bit
> by bit equivalent (same type, range, off, etc.).

Thanks for the explanation. To clarify, if old range of ptr_to_pkt >
cur range of ptr_to_pkt, what gets pruned? Is it access to cur range
of ptr_to_pkt since if old range > cur range, then if old range is
acceptable cur range must definitely be acceptable?

>
> If you start returning false whenever you see this type tag set, it
> will become too conservative (it considers reg copies of the same
> dynptr_data lookup as distinct). So you need some kind of id assigned
> during dynptr_data lookup to distinguish them.

What about if the dynptr_pkt type tag is set, then we compare the
ranges as well? If the ranges are the same, then we return true, else
false. Does that work?
