Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32094CED46
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiCFS6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 13:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbiCFS6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 13:58:32 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DA51CFDB
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 10:57:38 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b5so2846239lfs.1
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 10:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qj6QUg+mPOSXqYLVwnSwOPcd0+aQB4PrpOLySbesqDI=;
        b=NMdTtTNbaeoZJonHKJ7sJZqrEn56YUSwRiX+/WQ0gNQDpclgZ5aR/0+mk6g/KddsP0
         2DuCPmlqJF+5nGNp29W3gYMO6pJnxRA25xUksW95XPX/Sa5KYs1R/5iJHFFju6S8BJGd
         O+hpanaAaaNd2mWW4m2T892GFgKi9WPRzhkKU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qj6QUg+mPOSXqYLVwnSwOPcd0+aQB4PrpOLySbesqDI=;
        b=vsWpR1+z+/sTR6t9rm2oZ2+IzJzW1XxeGAHNDrcQoGRt2ODvrxbRLN286T6yagpxRy
         vus6UioNkUTKisWYZU/f9pTNWBTlL4AfWzSa7jgAv6xOpio/lZC3BQ+0QGe5w+p255SL
         skk8TmPEY5kLaCHhVDGa0vq6Z+tqxPEPDHa0JzRF6iMzO3phCeiOrGL5+3dibEDfZPL9
         mjtvqDGaAQ7Jj+Pag5GbzCYhTIfIX7oKiZLhVD8po4tWSxCpar9Er10+OBMrN3o9Ti0Q
         mlX7O6hyxfrpYef+MLxLFyjsdH06PEpVps18Vz83uRhzRkpWBUbhP/1DA+GuFked4BTr
         7NTw==
X-Gm-Message-State: AOAM531P9I0VE/2CyL8QFmxt1lSRLSwMR15SbEYPbgRKc95dImAjI6/g
        dpLfCJdO5spWM1o3wrmqmtyirhKTtZEMGLvHCEQ=
X-Google-Smtp-Source: ABdhPJwP8kEyOmkHUosJ713JmqhSTsh8dPT0DafODm0sDerGNat/CNoj0kj3uq22vjBvuuLY7s5i2g==
X-Received: by 2002:a05:6512:15a5:b0:448:2e98:250e with SMTP id bp37-20020a05651215a500b004482e98250emr1721392lfb.351.1646593054608;
        Sun, 06 Mar 2022 10:57:34 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id x6-20020ac259c6000000b004435e105572sm2388872lfn.131.2022.03.06.10.57.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 10:57:32 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id 5so20824584lfz.9
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 10:57:31 -0800 (PST)
X-Received: by 2002:ac2:41cf:0:b0:448:1eaa:296c with SMTP id
 d15-20020ac241cf000000b004481eaa296cmr5694758lfi.52.1646593051338; Sun, 06
 Mar 2022 10:57:31 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
 <20220304025109.15501-1-xiam0nd.tong@gmail.com> <CAHk-=wjesxw9U6JvTw34FREFAsayEE196Fi=VHtJXL8_9wgi=A@mail.gmail.com>
 <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com> <634CBC77-281E-421C-9ED9-DB9E7224E7EA@gmail.com>
In-Reply-To: <634CBC77-281E-421C-9ED9-DB9E7224E7EA@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 6 Mar 2022 10:57:15 -0800
X-Gmail-Original-Message-ID: <CAHk-=whSRNrhxx__Zo5mpKGKZ9BVwCqHCUcfxfBF4VPfFx8edA@mail.gmail.com>
Message-ID: <CAHk-=whSRNrhxx__Zo5mpKGKZ9BVwCqHCUcfxfBF4VPfFx8edA@mail.gmail.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 6, 2022 at 4:19 AM Jakob Koschel <jakobkoschel@gmail.com> wrote:
>
> I guess we could apply this to list_for_each_entry() as well
> once all the uses after the loop are fixed?

I think that would be a good longer-term plan. "list_traverse()" ends
up being simpler syntactically, and has a certain level of inherent
type safety (not just the "don't expose the mis-typed head pointer
after the loop").

> I feel like this simply introduces a new set of macros
> (we would also need list_traverse_reverse(), list_traverse_continue_reverse()
> etc) and end up with a second set of macros that do pretty much
> the same as the first one.

I think that if we're happy with this, we can probably do a scripted
conversion. But I do like how it's incremental, in that we wouldn't
necessarily have to do it all in one go.

Because it's always really painful with flag-day interface changes,
which it would be to actually change the semantics of
"list_for_each_entry()" without a name change. It just makes for a lot
of pain for things that aren't in-tree yet (not just drivers that are
out-of-tree in general, but drivers in development etc).

And I really disliked the "pass the type to the list_for_each()"
macro, because of how it made the end result look more complex.

But list_traverse() looks like it would make the end result better
both from a user perspective (ie the code just looks simpler) but also
from the type safety point.

> Personally I guess I also prefer the name list_for_each_entry() over list_traverse()
> and not having two types of iterators for the same thing at the same time.

I absolutely agree with you in theory, and in many ways I like
list_for_each_entry() better as a name too (probably just because I'm
used to it).

But keeping the same name and changing how it works ends up being such
a "everything at once" thing that I don't think it's realistic.

               Linus
