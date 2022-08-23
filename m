Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F23459ECDF
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiHWTtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiHWTtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:49:31 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DD39D66A;
        Tue, 23 Aug 2022 11:52:46 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w19so29256563ejc.7;
        Tue, 23 Aug 2022 11:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7Xx3PtHJzUXze83NrY9jK2YjqwqxuxzlYYO+dhkelAg=;
        b=Xo73yj1yYu+eRDakNB1eagtvis4Yjtvy3D5I10u8Ykhodn7g+62b9OHcZV/p1HzHMD
         QvU15no+Ybky+gknHW0jq8L66YTsu7yEO3xdSYhopVjeg2V0FoE5gb+kXJrJ+3lGCalv
         3cIlpj2QD4t0USZsVP4A47boij2IagzPAvISfaJHZkV9jJZPvRlUKxu1TZITQG2BL1wc
         KBmgnFeBjr0Hh1ej26gOe8mPlTOolqxEQwpL0h+7Y2Z8EupIqpMGox6LWsgBZkQkXXs/
         X99JvMiqcphlCVnhStzYD2+RliMCUbV3BlcNcvni8jXIW+KLy4fJPke3TLjr+OD26OBC
         W50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7Xx3PtHJzUXze83NrY9jK2YjqwqxuxzlYYO+dhkelAg=;
        b=zh/MUlgfEp+Mat0GVEeqQCE+DUu0eBzLU/gx+huo0zmaklTjhVCR7Csrg+pjcMZjaI
         V+8QvpNg4FlgtagnhftcHmVlPRPjiF1eHUOtr3urHMnACea6OksOO2FtSKnWemOAR0Js
         p+KwoquWKn2S6IOflSFCKXjJGgbaL7iuJwrEwaLvzeooD8DBYA0AKoNpt1ECvN8tbFi9
         wsarfx9/1skpuEAbee+4FSDBoAgeNreMlvRvL2C4fqBqbbTHPv46lR8kX8nfcpmZHx1w
         fo9ZsujvYmapkbaETq0REGVa2DyBDD8BIoITVl9wjMxD7ZyvdShRDE+DHzYEGW+GR73I
         zYJQ==
X-Gm-Message-State: ACgBeo0hBXlkwa4EQ7vdTkZ9Jhr49TP88G/X45MnxgRj4Lv4hkqUgMcG
        0VI8yKlNumLILYSwBeSCC8Q+f+o71m+ezyVjOlM=
X-Google-Smtp-Source: AA6agR5aRILyEF0TniRWgfkhRpWaIx3GRqOZRayXVqWkECvXOewaoXXP5PuvOApHmdWbpXajbVDcSwUCvN1cGszQ590=
X-Received: by 2002:a17:906:84f0:b0:73d:837a:332c with SMTP id
 zp16-20020a17090684f000b0073d837a332cmr594314ejb.679.1661280764393; Tue, 23
 Aug 2022 11:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com> <CAP01T74LUHjpnVOtwV1h7ha4Dqz0EU5zjwojz-9gWPCN6Gih0Q@mail.gmail.com>
In-Reply-To: <CAP01T74LUHjpnVOtwV1h7ha4Dqz0EU5zjwojz-9gWPCN6Gih0Q@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 23 Aug 2022 11:52:33 -0700
Message-ID: <CAJnrk1amsYS51deoXTOnWvMKSQNvbCK_JSPaGW=OBZZsEyNVuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] Add skb + xdp dynptrs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org
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

On Mon, Aug 22, 2022 at 7:32 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, 23 Aug 2022 at 02:06, Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
> >
> > This patchset adds skb and xdp type dynptrs, which have two main benefits for
> > packet parsing:
> >     * allowing operations on sizes that are not statically known at
> >       compile-time (eg variable-sized accesses).
> >     * more ergonomic and less brittle iteration through data (eg does not need
> >       manual if checking for being within bounds of data_end)
> >
>
> Just curious: so would you be adding a dynptr interface for obtaining
> data_meta slices as well in the future? Since the same manual bounds
> checking is needed for data_meta vs data. How would that look in the
> generic dynptr interface of data/read/write this set is trying to fit
> things in?

Oh cool, I didn't realize there is also a data_meta used in packet
parsing - thanks for bringing this up. I think there are 2 options for
how data_meta can be incorporated into the dynptr interface:

1) have a separate api "bpf_dynptr_from_{skb/xdp}_meta. We'll have to
have a function in the verifier that does something similar to
'may_access_direct_pkt_data' but for pkt data meta, since skb progs
can have different access restrictions for data vs. data_meta.

2) ideally, the flags arg would be used to indicate whether the
parsing should be for data_meta. To support this though, I think we'd
need to do access type checking within the helper instead of at the
verifier level. One idea is to pass in the env->ops ptr as a 4th arg
(manually patching it from the verifier) to the helper,  which can be
used to determine if data_meta access is permitted.

In both options, there'll be a new BPF_DYNPTR_{SKB/XDP}_META dynptr
type and data/read/write will be supported for it.

What are your thoughts?

>
>
>
> > When comparing the differences in runtime for packet parsing without dynptrs
> > vs. with dynptrs for the more simple cases, there is no noticeable difference.
> > For the more complex cases where lengths are non-statically known at compile
> > time, there can be a significant speed-up when using dynptrs (eg a 2x speed up
> > for cls redirection). Patch 3 contains more details as well as examples of how
> > to use skb and xdp dynptrs.
> >
> > [0] https://lore.kernel.org/bpf/20220523210712.3641569-1-joannelkoong@gmail.com/
> >
> > --
