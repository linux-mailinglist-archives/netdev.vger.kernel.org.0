Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEC1605138
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 22:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiJSUXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 16:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJSUXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 16:23:10 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5496E1946D8;
        Wed, 19 Oct 2022 13:23:07 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r14so26948225edc.7;
        Wed, 19 Oct 2022 13:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o+VYBjQB7Yx50yVwU1MMoGB+C5Q6N6YATcengMcXkS4=;
        b=maJ4ID2tVxHZZAoMKoeqJXCydTsVNuP8MO2Qc/tCXj56BC6pY6vC+GKk1+h/4mCSeF
         a7CceTwNp526d3puJTN2HR+8C1835bDZTxdwwA/uGYiF6+fcFVX/ANzqifmYSXpYgr4+
         LQon0C74Dx+jOE8LinzEmpeWEItNTKSzFIM00th0qfatmlEcMF8ivI/CuOH9yX5Ygkth
         IoGuXKuNk0fEWPiNEcs818MgQ/ZS777piseOfdhkwKbOjczM6JrTQ+FWfm9z0M9HSwU9
         lNtnpBWeTNxPBj8LODgUXzIcc2UZwztFcGmiK/G61CuwPphy+kc1ogwyf4BuamUDmb1l
         MtSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o+VYBjQB7Yx50yVwU1MMoGB+C5Q6N6YATcengMcXkS4=;
        b=Do0nSj4IfH62a0C+hwsrL8CIyxxwDA7NfsQVQUXhTq+qVAzv7/Yyv3w8OjVWf6tq/m
         NUiEpeOogRev5S9XueoCifj9stKc4M6A78XTvrOTCrMOdgrd6n3x7y3Y6avpGSHK2qWI
         CgaX831jfB0trkCszW7j2kMe0G1rBIuqaO/76Y7CwRUjMp6IgAN72ZGibvzG2nHyJ5ll
         9ikTFZltikaH/e31C7Bsox5zK81vFXIzgYbdNaDu7syOZ5QXe41NbaWaaOy0TnSUfJT1
         ABLu7PSo4o3PAxiRQqYtjBVEI5e0UkvamMwzWBYkNl4IXnLuOayJNp2NVwCOp/PQZj4s
         f7Pg==
X-Gm-Message-State: ACrzQf3VNS7NjvYl4aEocUu45QZZP8ZvnIaik088YF7Jl6OMCHRIDEKC
        NkFUeZ5vyqfulK6bzaw6du6nI4Lx5hfV3OxCNmI=
X-Google-Smtp-Source: AMsMyM7QHLOnjUcuw+YPbwf9zp3UxH7nNT3H0S3AbAefvgiEyD9Omi4cxsf0AeHwB9ag6ycMbPgoeANwqxaeXLd6xp0=
X-Received: by 2002:a05:6402:3546:b0:45d:a52f:2d38 with SMTP id
 f6-20020a056402354600b0045da52f2d38mr8912353edd.403.1666210985810; Wed, 19
 Oct 2022 13:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220907183129.745846-1-joannelkoong@gmail.com>
 <20220907183129.745846-2-joannelkoong@gmail.com> <cd8d201b-74f7-4045-ad2f-6d26ed608d1e@linux.dev>
In-Reply-To: <cd8d201b-74f7-4045-ad2f-6d26ed608d1e@linux.dev>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 19 Oct 2022 13:22:54 -0700
Message-ID: <CAJnrk1ZTbHcFsQPKWnZ+Au8BsiFc++Ud7y=24mAhNXNbYQaXhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/3] bpf: Add skb dynptrs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        martin.lau@kernel.org, kuba@kernel.org, memxor@gmail.com,
        toke@redhat.com, netdev@vger.kernel.org, kernel-team@fb.com,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 4:12 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/7/22 11:31 AM, Joanne Koong wrote:
> > For bpf prog types that don't support writes on skb data, the dynptr is
> > read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> > will return NULL; for a read-only data slice, there will be a separate
> > API bpf_dynptr_data_rdonly(), which will be added in the near future).
> >
> I just caught up on the v4 discussion about loadtime-vs-runtime error on
> write.  From a user perspective, I am not concerned on which error.
> Either way, I will quickly find out the packet header is not changed.
>
> For the dynptr init helper bpf_dynptr_from_skb(), the user does not need
> to know its skb is read-only or not and uses the same helper.  The
> verifier in this case uses its knowledge on the skb context and uses
> bpf_dynptr_from_skb_rdonly_proto or bpf_dynptr_from_skb_rdwr_proto
> accordingly.
>
> Now for the slice helper, the user needs to remember its skb is read
> only (or not) and uses bpf_dynptr_data() vs bpf_dynptr_data_rdonly()
> accordingly.  Yes, if it only needs to read, the user can always stay
> with bpf_dynptr_data_rdonly (which is not the initially supported one
> though).  However, it is still unnecessary burden and surprise to user.
> It is likely it will silently turn everything into bpf_dynptr_read()
> against the user intention. eg:
>
> if (bpf_dynptr_from_skb(skb, 0, &dynptr))
>         return 0;
> ip6h = bpf_dynptr_data(&dynptr, 0, sizeof(*ip6h));
> if (!ip6h) {
>         /* Unlikely case, in non-linear section, just bpf_dynptr_read()
>          * Oops...actually bpf_dynptr_data_rdonly() should be used.
>          */
>         bpf_dynptr_read(buf, sizeof(*ip6h), &dynptr, 0, 0);
>         ip6h = buf;
> }
>

I see your point. I agree that it'd be best if we could prevent this
burden on the user, but I think the trade-off would be that if we have
bpf_dynptr_data return data slices that are read-only and data slices
that are writable (where rd-only vs. writable is tracked by verifier),
then in the future we won't be able to support dynptrs that are
dynamically read-only (since to reject at load time, the verifier must
know statically whether the dynptr is read-only or not). I'm not sure
how likely it is that we'd run into a case where we'll need dynamic
read-only dynptrs though. What are your thoughts on this?

>
> > +     case BPF_DYNPTR_TYPE_SKB:
> > +     {
> > +             struct sk_buff *skb = ptr->data;
> > +
> > +             /* if the data is paged, the caller needs to pull it first */
> > +             if (ptr->offset + offset + len > skb->len - skb->data_len)
>
> nit. skb_headlen(skb)
>
> The patches can't be applied cleanly also. Please remember to rebase.
> eg. commit afef88e65554 ("selftests/bpf: Store BPF object files with
> .bpf.o extension") has landed on Sep 2.

I will use skb_headlen(skb) and rebase for the next iteration :)
Thanks for reviewing this!
>
>
