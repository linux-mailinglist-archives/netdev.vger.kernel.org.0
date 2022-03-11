Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E394D5C27
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347024AbiCKHUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347019AbiCKHUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:20:48 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF9D1B30AF;
        Thu, 10 Mar 2022 23:19:45 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id a5so7204617pfv.2;
        Thu, 10 Mar 2022 23:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=66mySApkNx2AsLKTlPg2xjC7ns+ZdXY0B8f3WpTzrGw=;
        b=XCTjhzVEO7nAGVAVxhXVbeUzg1dpuh8umb4iGRPatCVJoP61UCsqz/Bsv6vje5ty7Y
         +tYT60xIs1F/h7dRg4rXhjww7tdh5Vkrf8BMITNVMigC+c1MbgGHwAh3NQq0BOy8Q18Z
         XXWi+2jh7O3P+yVdZ7uVDUXw6DFaW+ccVChNQnUQPXsHp69pjcFOuwyP68URDAOk8h15
         NjFg4yP9JeLJs/To35wi7XOLfxN/n8HBh5eUzdQVT+fWjPnbTJvtUSkWFGj6zjIN0KPI
         cGpwSIbYOFcB9K1IxryMHZP3XtB1X5jx1UNKJhvcErcyp4jYXk/+mP5tGyUE9cvdBuFW
         mmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=66mySApkNx2AsLKTlPg2xjC7ns+ZdXY0B8f3WpTzrGw=;
        b=Q8X7hcra5uPU1ARfRcQdesoPaOKHYABqimaU176htK8+sEN5PJaWIBMgn/Qg6dtN+G
         tcbWyMUI15wBuondMDVNqUpdp/dMVSAb6o9+/l0H7uXjsq7JRO7h/KQCQrnzi26jOwR9
         rw7lNNnYfNSVJOGh2lDkTBD42Z+zhiIvnhm2IUGUnYDZkRHNi9wBfPKohe5x1SuuRfON
         pQq2NFq1T0Nh+uQGD3YYhOPVaV7OVuIPwCEtx5hA5RPqhifrynBl1jNxbYZF1s5Waz1D
         qUVVsm/azzY6FGND+jws96xsU9e8xdgWFY0EDXLagb0gbOSHqQmwKEGBQwmo7VYMIaYb
         HHrg==
X-Gm-Message-State: AOAM531m/USWeLW/cgQQMWaGWacMAjfYZ7bxQqAdENg/WKg0ecqrK8Is
        e01RJbcZ6mo6zMnWv0pkKNoEBKHdY4c=
X-Google-Smtp-Source: ABdhPJyj/3UAi1zDwcu4a9dID2FEHC3gQwxQdEqbnGYmJAETdHfkgQZkgwzxQlgPgTGV+etVrcj8Cw==
X-Received: by 2002:a05:6a00:1354:b0:4c9:1e96:d15c with SMTP id k20-20020a056a00135400b004c91e96d15cmr8710658pfu.30.1646983184958;
        Thu, 10 Mar 2022 23:19:44 -0800 (PST)
Received: from localhost ([112.79.142.206])
        by smtp.gmail.com with ESMTPSA id ay5-20020a056a00300500b004f6d510af4asm8307529pfb.124.2022.03.10.23.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 23:19:44 -0800 (PST)
Date:   Fri, 11 Mar 2022 12:49:35 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
Message-ID: <20220311071935.6k24jzdv7izzifto@apollo>
References: <20220306234311.452206-1-memxor@gmail.com>
 <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
 <20220308070828.4tjiuvvyqwmhru6a@apollo.legion>
 <87lexky33s.fsf@toke.dk>
 <CAEf4Bza6BhG7wtgmvWohEKpN5jSTyQwxm5-738oMoniz1v3uVw@mail.gmail.com>
 <87bkydxu59.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bkydxu59.fsf@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 05:00:42AM IST, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Mar 8, 2022 at 5:40 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >>
> >> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
> >>
> >> > On Tue, Mar 08, 2022 at 11:18:52AM IST, Andrii Nakryiko wrote:
> >> >> On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >> >> >
> >> >> > Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_packet_pointer'
> >> >> > returning a packet pointer with a fixed immutable range. This can be useful to
> >> >> > enable DPA without having to use memcpy (currently the case in
> >> >> > bpf_xdp_load_bytes and bpf_xdp_store_bytes).
> >> >> >
> >> >> > The intended usage to read and write data for multi-buff XDP is:
> >> >> >
> >> >> >         int err = 0;
> >> >> >         char buf[N];
> >> >> >
> >> >> >         off &= 0xffff;
> >> >> >         ptr = bpf_packet_pointer(ctx, off, sizeof(buf), &err);
> >> >> >         if (unlikely(!ptr)) {
> >> >> >                 if (err < 0)
> >> >> >                         return XDP_ABORTED;
> >> >> >                 err = bpf_xdp_load_bytes(ctx, off, buf, sizeof(buf));
> >> >> >                 if (err < 0)
> >> >> >                         return XDP_ABORTED;
> >> >> >                 ptr = buf;
> >> >> >         }
> >> >> >         ...
> >> >> >         // Do some stores and loads in [ptr, ptr + N) region
> >> >> >         ...
> >> >> >         if (unlikely(ptr == buf)) {
> >> >> >                 err = bpf_xdp_store_bytes(ctx, off, buf, sizeof(buf));
> >> >> >                 if (err < 0)
> >> >> >                         return XDP_ABORTED;
> >> >> >         }
> >> >> >
> >> >> > Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO_MEM, because
> >> >> > these pointers need to be invalidated on clear_all_pkt_pointers invocation, and
> >> >> > it is also more meaningful to the user to see return value as R0=pkt.
> >> >> >
> >> >> > This series is meant to collect feedback on the approach, next version can
> >> >> > include a bpf_skb_pointer and exposing it as bpf_packet_pointer helper for TC
> >> >> > hooks, and explore not resetting range to zero on r0 += rX, instead check access
> >> >> > like check_mem_region_access (var_off + off < range), since there would be no
> >> >> > data_end to compare against and obtain a new range.
> >> >> >
> >> >> > The common name and func_id is supposed to allow writing generic code using
> >> >> > bpf_packet_pointer that works for both XDP and TC programs.
> >> >> >
> >> >> > Please see the individual patches for implementation details.
> >> >> >
> >> >>
> >> >> Joanne is working on a "bpf_dynptr" framework that will support
> >> >> exactly this feature, in addition to working with dynamically
> >> >> allocated memory, working with memory of statically unknown size (but
> >> >> safe and checked at runtime), etc. And all that within a generic
> >> >> common feature implemented uniformly within the verifier. E.g., it
> >> >> won't need any of the custom bits of logic added in patch #2 and #3.
> >> >> So I'm thinking that instead of custom-implementing a partial case of
> >> >> bpf_dynptr just for skb and xdp packets, let's maybe wait for dynptr
> >> >> and do it only once there?
> >> >>
> >> >
> >> > Interesting stuff, looking forward to it.
> >> >
> >> >> See also my ARG_CONSTANT comment. It seems like a pretty common thing
> >> >> where input constant is used to characterize some pointer returned
> >> >> from the helper (e.g., bpf_ringbuf_reserve() case), and we'll need
> >> >> that for bpf_dynptr for exactly this "give me direct access of N
> >> >> bytes, if possible" case. So improving/generalizing it now before
> >> >> dynptr lands makes a lot of sense, outside of bpf_packet_pointer()
> >> >> feature itself.
> >> >
> >> > No worries, we can continue the discussion in patch 1, I'll split out the arg
> >> > changes into a separate patch, and wait for dynptr to be posted before reworking
> >> > this.
> >>
> >> This does raise the question of what we do in the meantime, though? Your
> >> patch includes a change to bpf_xdp_{load,store}_bytes() which, if we're
> >> making it, really has to go in before those hit a release and become
> >> UAPI.
> >>
> >> One option would be to still make the change to those other helpers;
> >> they'd become a bit slower, but if we have a solution for that coming,
> >> that may be OK for a single release? WDYT?
> >
> > I must have missed important changes to bpf_xdp_{load,store}_bytes().
> > Does anything change about its behavior? If there are some fixes
> > specific to those helpers, we should fix them as well as a separate
> > patch. My main objection is adding a bpf_packet_pointer() special case
> > when we have a generic mechanism in the works that will come this use
> > case (among other use cases).
>
> Well it's not a functional change per se, but Kartikeya's patch is
> removing an optimisation from bpf_xdp_{load_store}_bytes() (i.e., the
> use of the bpf_xdp_pointer()) in favour of making it available directly
> to BPF. So if we don't do that change before those helpers are
> finalised, we will end up either introducing a performance regression
> for code using those helpers, or being stuck with the bpf_xdp_pointer()
> use inside them even though it makes more sense to move it out to BPF.
>

So IIUC, the case we're worried about is when a linear region is in head or a
frag and bpf_xdp_pointer can be used to do a direct memcpy for it. But in my
testing there doesn't seem to be any difference. With or without the call, the
time taken e.g. for bpf_xdp_load_bytes lies in the 30-40ns range. It would make
sense, because for this case the code in bpf_xdp_pointer and bpf_xdp_copy_buf
are almost the same, just that the latter has a conditional jump out of the loop
based on len. bpf_xdp_copy_buf is still only doing a single memcpy, the cost
seems to be dominated by that.

Otoh, removing it would improve the case for the other scenario (when region
touches two or more frags) because we wouldn't spend time in bpf_xdp_pointer and
returning NULL from it failing to find a linear region, but that shouldn't be a
regression.

Please let me know if I missed something.

> So the "safe" thing to do would do the change to the store/load helpers
> now, and get rid of the bpf_xdp_pointer() entirely until it can be
> introduced as a BPF helper in a generic way. Of course this depends on
> whether you consider performance regressions to be something to avoid,
> but this being XDP IMO we should :)
>
> -Toke
>

--
Kartikeya
