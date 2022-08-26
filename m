Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41CF5A2E5D
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiHZSX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiHZSXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:23:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4956A6EF0C;
        Fri, 26 Aug 2022 11:23:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id m1so3091874edb.7;
        Fri, 26 Aug 2022 11:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=mnqTntBBUixCBmK/KgH2joTYOGTwv8oYMOUMhSLv8JE=;
        b=qUzyqf/PxxhU5HYYOUVMajaCeiUefYf6xB+Zcn6gYrih5Jh9sGc3WR5nHBSXCxfsre
         qoJhuK5UQ53F1Mdd0amtpEkTu08bFiNn9JfDlXFv+RiKwW4uGlY4lEkR+vACzpYPyqfY
         vvjIsZYt/KDzGjkd5IK+S5fmOGA/z2HCr+YClC51maOkCSLtXYB/F+ZhbMHUV/PywO8v
         wCsWPtF0KE1mn3QLYrIvCqBjvgpvTosqq2RgwNIGpK+MKCW9XKcUWPE1F1nHnu/WHha+
         PrQgYDwr81hNNeL8pGpHKDHsQr2qZz4/jpxRE2+a990P561YF5ODUKSrh0z2hIbrmAdH
         TMww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=mnqTntBBUixCBmK/KgH2joTYOGTwv8oYMOUMhSLv8JE=;
        b=IIHgoVmpSAH3W+q7FY1hspoUZE9j/HBfu+qraWUUr8dWo/6TIYIdXcPUMKct+s8Ca6
         YXfYXaJXYYlIzrxARS16/xylXTL6l6Pudipd9JdtEOaEZ405oZAKyIX54fl6XUz6obzM
         0PlLlhnj8t0JNeEpgOWH8qpF+uOFf57BAO8EUfBQ7b9E2hOIZ6ScEDw3VyM/RFBonwzc
         bl9qJOZv3qQ/UvDZm5t+ulVEN8OQWPc6QPSDK7Aa/KmTd6ayxMfEXFxIOb9VpNUMoMSx
         Y5iWYV33iE73hawX/7t4OcTYEjBGtTmO+tafy1OiUhQIEQjOGiGGD8ZRvILSzGX5eS9F
         xEUg==
X-Gm-Message-State: ACgBeo0dq9An0y+2eGqcg1+ddj/mx42OJPUBtzIGKzVdoEqohSZ69Cqh
        3zPOWRHvb+X2DMPywAdbSLIJNrKihq1NjuEllEI=
X-Google-Smtp-Source: AA6agR5o2UKBfKOSTjnQ+A10InlWFErMKTsVhyuq7y+GX+xEHqECN8jC4L4AplIk5tnvfa6FxXI/Pga3/8iq+agLzoc=
X-Received: by 2002:a05:6402:2949:b0:445:dc8d:44d with SMTP id
 ed9-20020a056402294900b00445dc8d044dmr7802453edb.60.1661538232841; Fri, 26
 Aug 2022 11:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com> <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
 <CAP01T77A1Z0dbWVzTFMRuHJYN-V8_siMBUg=MqUU3kQzx+Osdg@mail.gmail.com>
 <CAJnrk1aO0VPmg7pEjNTt2J-JttOYOMGx6GM+hQ1G2J-fkDPN8g@mail.gmail.com> <CAP01T779thB5vYr112+Zc4d1=wXQ8EvW00e8V5mC=mP+dgxbBA@mail.gmail.com>
In-Reply-To: <CAP01T779thB5vYr112+Zc4d1=wXQ8EvW00e8V5mC=mP+dgxbBA@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 26 Aug 2022 11:23:41 -0700
Message-ID: <CAJnrk1ZznUTdSSazWtwFQzWkzXPbqv6=i7wNrA+O1a7YdZRY2Q@mail.gmail.com>
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

On Thu, Aug 25, 2022 at 4:19 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, 25 Aug 2022 at 22:39, Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Wed, Aug 24, 2022 at 2:11 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Wed, 24 Aug 2022 at 00:27, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > >
> > > > On Mon, Aug 22, 2022 at 7:31 PM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > > > [...]
> > > > > >                 if (func_id == BPF_FUNC_dynptr_data &&
> > > > > > -                   dynptr_type == BPF_DYNPTR_TYPE_SKB) {
> > > > > > +                   (dynptr_type == BPF_DYNPTR_TYPE_SKB ||
> > > > > > +                    dynptr_type == BPF_DYNPTR_TYPE_XDP)) {
> > > > > >                         regs[BPF_REG_0].type = PTR_TO_PACKET | ret_flag;
> > > > > >                         regs[BPF_REG_0].range = meta.mem_size;
> > > > >
> > > > > It doesn't seem like this is safe. Since PTR_TO_PACKET's range can be
> > > > > modified by comparisons with packet pointers loaded from the xdp/skb
> > > > > ctx, how do we distinguish e.g. between a pkt slice obtained from some
> > > > > frag in a multi-buff XDP vs pkt pointer from a linear area?
> > > > >
> > > > > Someone can compare data_meta from ctx with PTR_TO_PACKET from
> > > > > bpf_dynptr_data on xdp dynptr (which might be pointing to a xdp mb
> > > > > frag). While MAX_PACKET_OFF is 0xffff, it can still be used to do OOB
> > > > > access for the linear area. reg_is_init_pkt_pointer will return true
> > > > > as modified range is not considered for it. Same kind of issues when
> > > > > doing comparison with data_end from ctx (though maybe you won't be
> > > > > able to do incorrect data access at runtime using that).
> > > > >
> > > > > I had a pkt_uid field in my patch [0] which disallowed comparisons
> > > > > among bpf_packet_pointer slices. Each call assigned a fresh pkt_uid,
> > > > > and that disabled comparisons for them. reg->id is used for var_off
> > > > > range propagation so it cannot be reused.
> > > > >
> > > > > Coming back to this: What we really want here is a PTR_TO_MEM with a
> > > > > mem_size, so maybe you should go that route instead of PTR_TO_PACKET
> > > > > (and add a type tag to maybe pretty print it also as a packet pointer
> > > > > in verifier log), or add some way to distinguish slice vs non-slice
> > > > > pkt pointers like I did in my patch. You might also want to add some
> > > > > tests for this corner case (there are some later in [0] if you want to
> > > > > reuse them).
> > > > >
> > > > > So TBH, I kinda dislike my own solution in [0] :). The complexity does
> > > > > not seem worth it. The pkt_uid distinction is more useful (and
> > > > > actually would be needed) in Toke's xdp queueing series, where in a
> > > > > dequeue program you have multiple xdp_mds and want scoped slice
> > > > > invalidations (i.e. adjust_head on one xdp_md doesn't invalidate
> > > > > slices of some other xdp_md). Here we can just get away with normal
> > > > > PTR_TO_MEM.
> > > > >
> > > > > ... Or just let me know if you handle this correctly already, or if
> > > > > this won't be an actual problem :).
> > > >
> > > > Ooh interesting, I hadn't previously taken a look at
> > > > try_match_pkt_pointers(), thanks for mentioning it :)
> > > >
> > > > The cleanest solution to me is to add the flag "DYNPTR_TYPE_{SKB/XDP}"
> > > > to PTR_TO_PACKET and change reg_is_init_pkt_pointer() to return false
> > > > if the DYNPTR_TYPE_{SKB/XDP} flag is present. I prefer this over
> > > > returning PTR_TO_MEM because it seems more robust (eg if in the future
> > > > we reject x behavior on the packet data reg types, this will
> > > > automatically apply to the data slices), and because it'll keep the
> > > > logic more efficient/simpler for the case when the pkt pointer has to
> > > > be cleared after any helper that changes pkt data is called (aka the
> > > > case where the data slice gets invalidated).
> > > >
> > > > What are your thoughts?
> > > >
> > >
> > > Thinking more deeply about it, probably not, we need more work here. I
> > > remember _now_ why I chose the pkt_uid approach (and this tells us my
> > > commit log lacks all the details about the motivation :( ).
> > >
> > > Consider how equivalency checking for packet pointers works in
> > > regsafe. It is checking type, then if old range > cur range, then
> > > offs, etc.
> > >
> > > The problem is, while we now don't prune on access to ptr_to_pkt vs
> > > ptr_to_pkt | dynptr_pkt types in same reg (since type differs we
> > > return false), we still prune if old range of ptr_to_pkt | dynptr_pkt
> > > > cur range of ptr_to_pkt | dynptr_pkt. Both could be pointing into
> > > separate frags, so this assumption would be incorrect. I would be able
> > > to trick the verifier into accessing data beyond the length of a
> > > different frag, by first making sure one line of exploration is
> > > verified, and then changing the register in another branch reaching
> > > the same branch target. Helpers can take packet pointers so the access
> > > can become a pruning point. It would think the rest of the stuff is
> > > safe, while they are not equivalent at all. It is ok if they are bit
> > > by bit equivalent (same type, range, off, etc.).
> >
> > Thanks for the explanation. To clarify, if old range of ptr_to_pkt >
> > cur range of ptr_to_pkt, what gets pruned? Is it access to cur range
> > of ptr_to_pkt since if old range > cur range, then if old range is
> > acceptable cur range must definitely be acceptable?
>
> No, my description was bad :).
> We return false when old_range > cur_range, i.e. the path is
> considered safe and not explored again when old_range <= cur_range
> (pruning), otherwise we continue verifying.
> Consider if it was doing pkt[cur_range + 1] access in the path we are
> about to explore again (already verified for old_range). That is <=
> old_range, but > cur_range, so it would be problematic if we pruned
> search for old_range > cur_range.

Does "old_range" here refer to the range that was already previously
verified as safe by the verifier? And "cur_range" is the new range
that we are trying to figure out is safe or not?

When you say "we return false when old_range > cur_range", what
function are we returning false from?

>
> So maybe it won't be a problem here, and just the current range checks
> for pkt pointer slices is fine even if they belong to different frags.
> I didn't craft any test case when writing my previous reply.
> Especially since you will disable comparisons, one cannot relearn
> range again using var_off + comparison, which closes another loophole.
>
> It just seems simpler to me to be a bit more conservative, since it is
> only an optimization. There might be some corner case lurking we can't
> think of right now. But I leave the judgement up to you if you can
> reason about it. In either case it would be good to include some
> comments in the commit log about all this.
>
> Meanwhile, looking at the current code, I'm more inclined to suggest
> PTR_TO_MEM (and handle invalidation specially), but again, I will
> leave it up to you to decide.
>
> When we do += var_off to a pkt reg, its range is reset to zero,
> compared to PTR_TO_MEM, where off + var_off (smin/umax) is used to
> check against the actual size for an access, which is a bit more
> flexible. The reason to reset range is that it will be relearned using
> comparisons and transferred to copies (reg->id is assigned for each +=

Can you direct me to the function where this relearning happens? thanks!

> var_off), which doesn't apply to slice pointers (essentially the only
> reason to keep them is being able to pick them for invalidation), we
> try to disable the rest of the pkt pointer magic in the verifier,
> anyway.
>
> pkt_reg->umax_value influences the prog->aux->max_pkt_offset (and iiuc
> it can reach that point with range == 0 after += var_off, and
> zero_size_allowed == true), only seems to be used by netronome's ebpf
> offload for now, but still a bit confusing if slice pkt pointers cause
> this to change.

My major takeaway from this discussion is that there's a lot of extra
subtleties when reg is PTR_TO_PACKET :) I'm going to delve deeper into
the source code, but from a glance, I think you're right that just
assigning PTR_TO_MEM for the data slice will probably make things a
lot more straightforward. thanks for the discussion!

>
> >
> > >
> > > If you start returning false whenever you see this type tag set, it
> > > will become too conservative (it considers reg copies of the same
> > > dynptr_data lookup as distinct). So you need some kind of id assigned
> > > during dynptr_data lookup to distinguish them.
> >
> > What about if the dynptr_pkt type tag is set, then we compare the
> > ranges as well? If the ranges are the same, then we return true, else
> > false. Does that work?
>
> Seems like it, and true part is already covered by memcmp at the start
> of the function, I think.
