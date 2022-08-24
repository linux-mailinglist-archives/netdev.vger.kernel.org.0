Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B645A0325
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 23:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbiHXVL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 17:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiHXVL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 17:11:27 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143857B294;
        Wed, 24 Aug 2022 14:11:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p187so6967481iod.8;
        Wed, 24 Aug 2022 14:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=GBCtXhaJdzeVYXzVDnzGIG3y3lv+heRr/tizYV41Ktw=;
        b=RDdafZaZqPnZXYbyhR0EaCjeUq1Ya5uRlw5NpzqvgTn0fK1RffipgHuwcltbeEa4oA
         eQBuygicYRltDIz1o46pjWLJ79n/NePa00TCwGTnBuJh/kCPxiHjmMcKT5bTobaGvCwp
         NA/v/XBMfJzoaURyzUW7JARZo5ZA8HDmyWEc/56FZ3CgvWaUIJ5miMfn8cTcyPy71aSn
         5KCisHM/d1VBZT+pjLuE+anvf6IY8yJITjTOQKclPMVhAg2j0Ppgsou6CZ1I81wvlxYL
         H/g0evRrtByGQiBB8ZRsjO0Oe5evLY828qAXeUl7QhzZ5pWn4ZKM5WwdvaGHuLRG9JXy
         Al9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=GBCtXhaJdzeVYXzVDnzGIG3y3lv+heRr/tizYV41Ktw=;
        b=O3rV047JRJbERTWE1VkHmRowz6BVp88TtTquQvWTsNR6ik122rV3RMVpIL8VjolWjS
         65JJONavyRKEZCUOqlh7x5Jua1BFRtooOzu2czR/LJ78whas5sEMAQtUZiCLppe2bN43
         y9k9QwzRC9l2amUBbI3v/9wg0eKd1W3lTAVPYfSYtzLbdp6VB9mMwJ6GJvirrI7zx6z/
         rPwLm18vcHKm2EHZiwsEp2MIzt9LfU55TAsedptVDQoU6eIoCIIVd/q0NW+qWPRFyliI
         qqhrK7C3HokkHLTexPYpA20d4mEG/B+LiiZwuf2T+w+xdBmRur+p0ZMR0aUtHy9h0Gax
         VWbg==
X-Gm-Message-State: ACgBeo3d5zFXewVPWORGl+O0A6HN5Kg/AmMaIQZT185V66KsG4EnZvVg
        ZBkJDtdP7KVdw0PwbdhFq/ZPRkApaSG0d6FHBVM=
X-Google-Smtp-Source: AA6agR6FBTMpDWCetFATgYHhAygbjEFgi1d463o2WzeiqSsaJoIo0BuaKp5g/7rv7S2DFsYrzvMnAC1g2JBkDla6R+A=
X-Received: by 2002:a05:6638:2382:b0:347:7dae:b276 with SMTP id
 q2-20020a056638238200b003477daeb276mr362241jat.124.1661375485327; Wed, 24 Aug
 2022 14:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
In-Reply-To: <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 24 Aug 2022 23:10:47 +0200
Message-ID: <CAP01T77A1Z0dbWVzTFMRuHJYN-V8_siMBUg=MqUU3kQzx+Osdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
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

On Wed, 24 Aug 2022 at 00:27, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Mon, Aug 22, 2022 at 7:31 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> > > [...]
> > >                 if (func_id == BPF_FUNC_dynptr_data &&
> > > -                   dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > > +                   (dynptr_type == BPF_DYNPTR_TYPE_SKB ||
> > > +                    dynptr_type == BPF_DYNPTR_TYPE_XDP)) {
> > >                         regs[BPF_REG_0].type = PTR_TO_PACKET | ret_flag;
> > >                         regs[BPF_REG_0].range = meta.mem_size;
> >
> > It doesn't seem like this is safe. Since PTR_TO_PACKET's range can be
> > modified by comparisons with packet pointers loaded from the xdp/skb
> > ctx, how do we distinguish e.g. between a pkt slice obtained from some
> > frag in a multi-buff XDP vs pkt pointer from a linear area?
> >
> > Someone can compare data_meta from ctx with PTR_TO_PACKET from
> > bpf_dynptr_data on xdp dynptr (which might be pointing to a xdp mb
> > frag). While MAX_PACKET_OFF is 0xffff, it can still be used to do OOB
> > access for the linear area. reg_is_init_pkt_pointer will return true
> > as modified range is not considered for it. Same kind of issues when
> > doing comparison with data_end from ctx (though maybe you won't be
> > able to do incorrect data access at runtime using that).
> >
> > I had a pkt_uid field in my patch [0] which disallowed comparisons
> > among bpf_packet_pointer slices. Each call assigned a fresh pkt_uid,
> > and that disabled comparisons for them. reg->id is used for var_off
> > range propagation so it cannot be reused.
> >
> > Coming back to this: What we really want here is a PTR_TO_MEM with a
> > mem_size, so maybe you should go that route instead of PTR_TO_PACKET
> > (and add a type tag to maybe pretty print it also as a packet pointer
> > in verifier log), or add some way to distinguish slice vs non-slice
> > pkt pointers like I did in my patch. You might also want to add some
> > tests for this corner case (there are some later in [0] if you want to
> > reuse them).
> >
> > So TBH, I kinda dislike my own solution in [0] :). The complexity does
> > not seem worth it. The pkt_uid distinction is more useful (and
> > actually would be needed) in Toke's xdp queueing series, where in a
> > dequeue program you have multiple xdp_mds and want scoped slice
> > invalidations (i.e. adjust_head on one xdp_md doesn't invalidate
> > slices of some other xdp_md). Here we can just get away with normal
> > PTR_TO_MEM.
> >
> > ... Or just let me know if you handle this correctly already, or if
> > this won't be an actual problem :).
>
> Ooh interesting, I hadn't previously taken a look at
> try_match_pkt_pointers(), thanks for mentioning it :)
>
> The cleanest solution to me is to add the flag "DYNPTR_TYPE_{SKB/XDP}"
> to PTR_TO_PACKET and change reg_is_init_pkt_pointer() to return false
> if the DYNPTR_TYPE_{SKB/XDP} flag is present. I prefer this over
> returning PTR_TO_MEM because it seems more robust (eg if in the future
> we reject x behavior on the packet data reg types, this will
> automatically apply to the data slices), and because it'll keep the
> logic more efficient/simpler for the case when the pkt pointer has to
> be cleared after any helper that changes pkt data is called (aka the
> case where the data slice gets invalidated).
>
> What are your thoughts?
>

Thinking more deeply about it, probably not, we need more work here. I
remember _now_ why I chose the pkt_uid approach (and this tells us my
commit log lacks all the details about the motivation :( ).

Consider how equivalency checking for packet pointers works in
regsafe. It is checking type, then if old range > cur range, then
offs, etc.

The problem is, while we now don't prune on access to ptr_to_pkt vs
ptr_to_pkt | dynptr_pkt types in same reg (since type differs we
return false), we still prune if old range of ptr_to_pkt | dynptr_pkt
> cur range of ptr_to_pkt | dynptr_pkt. Both could be pointing into
separate frags, so this assumption would be incorrect. I would be able
to trick the verifier into accessing data beyond the length of a
different frag, by first making sure one line of exploration is
verified, and then changing the register in another branch reaching
the same branch target. Helpers can take packet pointers so the access
can become a pruning point. It would think the rest of the stuff is
safe, while they are not equivalent at all. It is ok if they are bit
by bit equivalent (same type, range, off, etc.).

If you start returning false whenever you see this type tag set, it
will become too conservative (it considers reg copies of the same
dynptr_data lookup as distinct). So you need some kind of id assigned
during dynptr_data lookup to distinguish them.
