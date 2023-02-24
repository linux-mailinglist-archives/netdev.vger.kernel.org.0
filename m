Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE9C6A1CA7
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 14:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjBXNFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 08:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjBXNFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 08:05:18 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AA2686BA
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 05:04:56 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-536bf92b55cso273888987b3.12
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 05:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RZregdige3vPwnQ4az+kvStMVGe4XetWoKj/lHGWuj8=;
        b=vg/juNgfFLGLjyzoBoiD1Rbgg5XxffApfa4PWbKD6T/0eGlpqAaGyxPg0eLuRNxDJ6
         7/leG7VwKj/q4evusEb2UaTy6k5KDmt5mPs0KbE/N9z4D9ZyFsAnQdZwL8I2mzsmNz1Q
         cbr8Mn/L4MxZ8TYKRktYuo3idjn6Cv5Z/GVv/S4KokpJCs6NEQpjxVGCYu/8+1cQvyA8
         o8OmgDZ5RjZXaV6HplzAtKXz0ZBr3DVfnk8nidkqcrYijKK55CgaAW8cdtNXa/V/51BX
         kiN408VNpSeGJRmeWf17JhaT1X/2IohPbIHz0n4Y/T4T7unvFJKuca4gyudoZuB5RWV+
         Re1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RZregdige3vPwnQ4az+kvStMVGe4XetWoKj/lHGWuj8=;
        b=hLwPUW/Wbn+V/SMw2KJy8lqw115On6Z256r0a0JD+jrILQ7KxZjDrMlv0/5f3Wpmtw
         B4lQ361pOAe4r+mBFz+6LA1SwcMMzzKodw27s4NeQWEoMi1ea8eN6HWVy8i6YKwE7MK+
         DfnW7AgvW/uilYREQPzYmsJF5kt4nyJl+2hBvGsEbKMvrOqSo1Ykxh0WoiW7NJqh5w5N
         IT98JtYc3wyODhRUBuaw2Ao9O0Vhz3Ub01WYg46LqREq6Arq69oU9STfKozqLZV3uR5T
         3xpBz1HfR1vnPY8Dy5icT39Dz3ihTfF69Zf0e/nZAJU3ftgHwetK2ZMj4qAPT2GZaVpL
         j4iQ==
X-Gm-Message-State: AO0yUKUiswqYTuzawxvIWtQq6GdcMHv7WyIdEw2amf8kir0ilaeEbYQ8
        QrlbX4jgkIg+BGkAnpwb8W5srDXQfHEnyUBH14IYWQ==
X-Google-Smtp-Source: AK7set/96vAgGMjBmxg8aDvFSkh/KjGIuUjXbEY6Ggfuv4D0eqg1SnEgcBgs7wSfpIy3AZDlkHJ9DC96CCOrdWzdveg=
X-Received: by 2002:a81:ac28:0:b0:535:cdde:9a63 with SMTP id
 k40-20020a81ac28000000b00535cdde9a63mr4444755ywh.7.1677243895699; Fri, 24 Feb
 2023 05:04:55 -0800 (PST)
MIME-Version: 1.0
References: <20230223141639.13491-1-pctammela@mojatatu.com> <Y/h9x8c/XdJeT7e0@corigine.com>
In-Reply-To: <Y/h9x8c/XdJeT7e0@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 24 Feb 2023 08:04:44 -0500
Message-ID: <CAM0EoMmidx7VfX3UW7ELnDruepCe3O6WZfdNav=jJfDHtC1tEQ@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_connmark: handle errno on tcf_idr_check_alloc
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        error27@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 4:05 AM Simon Horman <simon.horman@corigine.com> wrote:
>

[..]

> Hi Pedro,
>
> I think the issue here isn't so much that there may be incorrect usage of
> ci - although that can happen - but rather that an error condition - the
> failure of tcf_idr_check_alloc is ignored.
>
> Viewed through this lens I think it becomes clear that the hunk
> below fixes the problem. While the hunks above are cleanups.
> A nice cleanup. But still a cleanup.
>

I agree with your analysis. The initialization could be left as is and
the else being an error condition would cover it
(although it is one less line with Pedro's approach).
However, on that "else" train of thought - more comment below:

> I think that as a fix for 'net' a minimal approach is best and thus
> the patch below.
>
> I'd also like to comment that the usual style for kernel code is to handle
> error cases in conditions - typically immediately after the condition
> arises. While non-error cases follow, outside of condtions.
>
> F.e.
>
>         err = do_something(with_something);
>         if (err) {
>                 /* handle error */
>                 ...
>         }
>
>         /* proceed with non-error case here */
>         ...
>
> In the code at hand this is complicate by there being two non-error cases,
> and it thus being logical to treat them conditionally.

since 0190c1d452a91 unfortunately given we have the potential of 3
possible return codes (where's before it was either 0 or 1) and it
would help to have consistent code in the spirit of if/else if/else -
gact is probably the best example for this.
My opinion is we should fix all the action init()s to follow that
pattern. There are like 3 different patterns and the danger of making
a mistake with clever manipulation of the return code (as is done for
example in mpls or vlan) is susceptible to breakage once someone
submits a patch that is not properly reviewed.

cheers,
jamal

> Even so, i do wonder if there is value in treating the error case first,
> right next to the code that might cause the error, in order to make it
> clearer that the error is being handled (as normal).
>
> And in saying so, I do realise it contradicts my statement
> about minimal changes to some extent.
>
> i.e. (*completely untested*)
>
>         ret = tcf_idr_check_alloc(tn, &index, a, bind);
>         if (ret < 0) {
>                 err = ret;
>                 goto out_free;
>         } else if (!ret) {
>                 ...
>         } else {
>                 ...
>         }
>
> > @@ -158,6 +156,9 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
> >               nparms->zone = parm->zone;
> >
> >               ret = 0;
> > +     } else {
> > +             err = ret;
> > +             goto out_free;
> >       }
> >
> >       err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> > --
> > 2.34.1
> >
