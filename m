Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09F32C3D4B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 11:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgKYKJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728509AbgKYKJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 05:09:39 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0A8C0613D6;
        Wed, 25 Nov 2020 02:09:39 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id e8so1862843pfh.2;
        Wed, 25 Nov 2020 02:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wLJn+e70GcS4hHHsp4RC07fD92Emnrwn7UPxT2f8R2I=;
        b=O44I1PQ6HD0uu7owUqfXEkqgd2AbwWszOgxFbrHt7bAWTgFKxq8mT12bFIf0m4Myz1
         pAFBVqzpFui4NrA3shetpT5IwM/jAE4eCYc8Q2iXVOHyHIbGM0NNpx3MuV2/Q5PsVb1E
         R68GXqleUOoDUpou3d06qCO42liF0SeMnuMxztM2mOUs7xoP+U1A6KyNdog22MRGOjUm
         nCUhYF/vy5Wod5OSZ6yjhz75AU1Fb17+MEYuvmOVX6SijF0k0kZEAsR7nEn7H9JKSS3p
         BLx5HKNaXFbrE/rQmQ1EGq+JRqkNpP773ng8qZYlpwFccdGbp+dLxz15eEWU+pKEYgFz
         2Dcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLJn+e70GcS4hHHsp4RC07fD92Emnrwn7UPxT2f8R2I=;
        b=FWI4FqQBaidPekQ9p7NTawLL771mxw1Vq4g9d/ad5AnlZj+4PkKk4pH0ufLbVgg9w+
         oERgncOGyYyAy9reuqu6WVtdF9QCB90NrAEnxfG4FxOVt0et6lDagZMidFAdyJglI+JW
         zRi48L7FB1T9DO+ra3c6bHcS8PbrpWdaOEe8Wjni0nMiTXa62c5FflgVOgYHZVf93YbS
         ePpUnY6AZNIEm8wPFkXS3qLpeiEqu+EF4eUCOE1HpON59rTVMAZkowovORSeroBNgl91
         eVanJG6NGu0t0ItmkhH8KNaUYx9OuvCEsIGJ50flSvknxvL+wYP8cXnm68XGgYABhe6E
         R8kg==
X-Gm-Message-State: AOAM532SkVZMfKixqdHdrImEdKkiVjoevqh2TJUCUJjLHKX8RcVVtgZK
        48d1uOkJ0eXnwLX9rqqTyRJ4qE9ZNNwVk+6x4TU=
X-Google-Smtp-Source: ABdhPJwKASdWmna9hO9FX129sMoxQyQ4rW0F0UQczZAEM9zvCXNIR4m00XnQnUU404qDjKXe/Z7rRew12raGJbQBw4I=
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr3251547pjy.204.1606298979262;
 Wed, 25 Nov 2020 02:09:39 -0800 (PST)
MIME-Version: 1.0
References: <1606202474-8119-1-git-send-email-lirongqing@baidu.com>
 <CAJ8uoz0WNm6no8NRehgUH5RiGgvjJkKeD-Yyoah8xJerpLhgdg@mail.gmail.com>
 <fe9eeaa5-d40a-9be4-a96b-cdd80095da47@iogearbox.net> <CAJ8uoz1JdmHc9nwa4cY20S-GN62RAJUEPGY4LcmdTM4FjuGTow@mail.gmail.com>
 <aa4cdc17-1e54-7782-2b64-14d7a3ac892e@iogearbox.net> <CAJ8uoz2F3F_w8o1uBzOdxqy5Z1pcg4g4kqG22FnxrQ4+pY5UKg@mail.gmail.com>
 <542d88a0-71c0-6d1f-e949-b375d0ac8369@iogearbox.net>
In-Reply-To: <542d88a0-71c0-6d1f-e949-b375d0ac8369@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 11:09:28 +0100
Message-ID: <CAJ8uoz36wS+cQSXxRm_GVyH7O1vhzASmC-LUoLcS0dW7SsqcNw@mail.gmail.com>
Subject: Re: [PATCH][V2] libbpf: add support for canceling cached_cons advance
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Li RongQing <lirongqing@baidu.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 11:07 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/25/20 10:13 AM, Magnus Karlsson wrote:
> > On Wed, Nov 25, 2020 at 10:02 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 11/25/20 9:30 AM, Magnus Karlsson wrote:
> >>> On Tue, Nov 24, 2020 at 10:58 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>>> On 11/24/20 9:12 AM, Magnus Karlsson wrote:
> >>>>> On Tue, Nov 24, 2020 at 8:33 AM Li RongQing <lirongqing@baidu.com> wrote:
> >>>>>>
> >>>>>> Add a new function for returning descriptors the user received
> >>>>>> after an xsk_ring_cons__peek call. After the application has
> >>>>>> gotten a number of descriptors from a ring, it might not be able
> >>>>>> to or want to process them all for various reasons. Therefore,
> >>>>>> it would be useful to have an interface for returning or
> >>>>>> cancelling a number of them so that they are returned to the ring.
> >>>>>>
> >>>>>> This patch adds a new function called xsk_ring_cons__cancel that
> >>>>>> performs this operation on nb descriptors counted from the end of
> >>>>>> the batch of descriptors that was received through the peek call.
> >>>>>>
> >>>>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> >>>>>> [ Magnus Karlsson: rewrote changelog ]
> >>>>>> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> >>>>>> ---
> >>>>>> diff with v1: fix the building, and rewrote changelog
> >>>>>>
> >>>>>>     tools/lib/bpf/xsk.h | 6 ++++++
> >>>>>>     1 file changed, 6 insertions(+)
> >>>>>>
> >>>>>> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> >>>>>> index 1069c46364ff..1719a327e5f9 100644
> >>>>>> --- a/tools/lib/bpf/xsk.h
> >>>>>> +++ b/tools/lib/bpf/xsk.h
> >>>>>> @@ -153,6 +153,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
> >>>>>>            return entries;
> >>>>>>     }
> >>>>>>
> >>>>>> +static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
> >>>>>> +                                        size_t nb)
> >>>>>> +{
> >>>>>> +       cons->cached_cons -= nb;
> >>>>>> +}
> >>>>>> +
> >>>>>>     static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
> >>>>>>     {
> >>>>>>            /* Make sure data has been read before indicating we are done
> >>>>>> --
> >>>>>> 2.17.3
> >>>>>
> >>>>> Thank you RongQing.
> >>>>>
> >>>>> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >>>>
> >>>> @Magnus: shouldn't the xsk_ring_cons__cancel() nb type be '__u32 nb' instead?
> >>>
> >>> All the other interfaces have size_t as the type for "nb". It is kind
> >>> of weird as a __u32 would have made more sense, but cannot actually
> >>> remember why I chose a size_t two years ago. But for consistency with
> >>> the other interfaces, let us keep it a size_t for now. I will do some
> >>> research around the reason.
> >>
> >> It's actually a bit of a mix currently which is what got me confused:
> >>
> >> static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
> >> static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
> >> static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod, size_t nb, __u32 *idx)
> >> static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, size_t nb)
> >> static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons, size_t nb, __u32 *idx)
> >> static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
> >>
> >> (I can take it in as-is, but would be nice to clean it up a bit to avoid confusion.)
> >
> > Hmm, that is confusing indeed. Well, the best choice would be __u32
> > everywhere since the ring pointers themselves are __u32. But I am
> > somewhat afraid of changing an API. Can we guarantee that a change
> > from size_t to __u32 will not break some user's compilation? Another
> > option would be to clean this up next year when we will very likely
> > produce a 1.0 version of this API and at that point we can change some
> > things. What do you think would be the best approach?
>
> Given they're all inlines, imho, risk should be fairly low to switch all to __u32.
> I would probably go and verify first with DPDK as main user of the lib and/or write
> some test cases to see if compiler spills any new warnings and the like, but if not
> the case then we should do it for bpf-next so this has plenty of exposure in the
> meantime. Any nb large than u32 max is a bug in any case.

Sounds good. Will do and get back to you.

> Thanks,
> Daniel
