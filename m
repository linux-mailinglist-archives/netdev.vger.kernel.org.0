Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB34671DBF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjARN3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjARN2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:28:48 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359FB62D28
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:54:44 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id p188so37914628yba.5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nhOaIIeoPZqUoA+oZgyhunqbDDUGLlE5rMwqEnOAxpY=;
        b=AQZKd931MgNFLZ6lkXzJb1fmj9tJCnw3mkmxyiw2I0XUN9jzWojNHguLeDlnT2V4q6
         L6zM4c/2XBo4mQMgv0I9s4t05AwyztygX5sPxrvOnVIm2/UhciGqEsmJz5J71eu82EER
         VsUSsQtaKFKgy+56+gPpBRhDCXQIaJ4QGaAQIc1/dY3hk1HHlKzMucHYpXn+M1oYUvwI
         vynw+qixPgCYyUrInNXb1IX44Qu8pNto0jz0rVzJlROULT8CJ0McbJyGRvxIQwrBtQ1j
         49+e5Jtpx7vcR3QRuCefCkpa435W9vYNSlK5zU2/VBnZC1+7Hk0+wZTVcu4FjiTdpL4C
         IdkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nhOaIIeoPZqUoA+oZgyhunqbDDUGLlE5rMwqEnOAxpY=;
        b=1N06B8TURPWM4K/l7GAzVAEKAbuf/U1R0iUWZfeTlcvl+xPa6225R5lLxcG9ICN+Oa
         RntZLloJ+7+pk9/3bfUP15yXw8HAUI5zMAMmx6akOFbpDV/rM01eIxcw5mrPaaqaxD4e
         x/qqrRl6YWeaHwRDPeYsuZ01oiFKNN1MgQrJKS5MRv/xWePmlVoZVJkL/v6RBnZAs2Yh
         672f17vNogdBvKI+RvTWMAQo85ded8SFN/Nin7uVOYXBSkTS03WsFcX8uZkcDoma/pw5
         37FMmMHmHCL3V3MTCQCm5w0KQylPKO+rFq4PLqRaGprVAiv7kYeOk5aPh8NHIcmZkMUL
         2CUw==
X-Gm-Message-State: AFqh2kpL+wRbEBWdtZaJGy075tCqAcddvJrsAD+J88qmswV7eQYmz5GQ
        cBLjBNKz4Sp+rv8Ln5NG/K5yzW6+DGAImmktKPrxIg==
X-Google-Smtp-Source: AMrXdXuT5kJ4Q6/QInZ8FZT+A0hKLSlAJJj+bnl+3drlBJCTcA6abuT95zCfRc4Ge/jwPD5cEoqsraYn5r74srMy1/U=
X-Received: by 2002:a25:6642:0:b0:7c5:fcf5:b529 with SMTP id
 z2-20020a256642000000b007c5fcf5b529mr978745ybm.517.1674046475760; Wed, 18 Jan
 2023 04:54:35 -0800 (PST)
MIME-Version: 1.0
References: <20230112105905.1738-1-paulb@nvidia.com> <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
 <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com> <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
 <8f9ca91e-1f3f-c3c1-cbab-4f9af3884b43@nvidia.com>
In-Reply-To: <8f9ca91e-1f3f-c3c1-cbab-4f9af3884b43@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 18 Jan 2023 07:54:24 -0500
Message-ID: <CAM0EoMm-YVTKWwTEEACjEuyh8C+tWiEWFurPB=F2JUT72nZp4A@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to
 tc action
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 9:48 AM Paul Blakey <paulb@nvidia.com> wrote:
>
> On 17/01/2023 15:40, Jamal Hadi Salim wrote:

[..]

> > Question: How does someone adding these rules tell whether some of
> > the actions are offloaded and some are not? If i am debugging this because
> > something was wrong I would like to know.
>
> Currently by looking at the per action hw stats, and if they are
> advancing. This is the same now with filters and the CT action for
> new connections (driver reports offload, but it means that only for
> established connections).

I think that may be sufficient given we use the same technique for
filter offload.
Can you maybe post an example of such a working example in your commit message
with stats?
You showed a candidate scenario that could be sorted but not a running example.

> > It will be an action continue for a scenario where (on ingress) you have
> > action A from A,B,C being offloaded and B,C is in s/w - the fw filter
> > will have the
> > B,C and flower can have A offloaded.
> > Yes, someone/thing programming these will have to know that only A can
> > be offloaded
> > in that graph.
>
> I meant using continue to go to next tc priority "as in "action A action
> continue" but I'm not sure about the actual details of fully supporting
> this as its not the purpose of this patch, but maybe will lead there.

Yeah, that was initially confusing when i read the commit log. It sounded
like action continue == action pipe (because it continues to the next action
in the action graph).
Maybe fix the commit to be clearer.

> > Ok, so would this work for the scenario I described above? i.e A,B, C where
> > A is offloaded but not B, C?
>
> You mean the reorder? we reorder the CT action first if all other
> actions are supported, so we do all or nothing.

Let me give a longer explanation.
The key i believe is understanding the action dependency. In my mind
there are 3 levels of
complexity for assumed ordering of actions A, B, C:

1) The simplest thing is to assume all-or-nothing (which is what we
have done so far in tc);
IOW if not all of A, B, C can be offloaded then we dont offload.

2) next level of complexity is assuming that A MUST occur before B
which MUST occur before C.
Therefore on ingress you can offload part of that graph depending on
your hardware capability.
Example: On ingress A, B offloaded and then "continue" to C in s/w if
your hardware supports
only offloading A and B but not C. You do the reverse of that graph
for egress offload.

3) And your case is even more complex because you have a lot more
knowledge that infact
there is no action dependency and you can offload something in the
middle like B.
So i believe you are solving a harder problem than #2 which is what
was referring to in
my earlier email.

The way these things are typically solved is to have a "dependency"
graph that can be
programmed depending on h/w offload capability and then you can make a decision
whether (even in s/w) to allow A,B,C vs C,A,B for example.

Note: I am not asking for the change - but would be nice to have and I
think over time
generalize. I am not sure how other vendors would implement this today.

Note: if i have something smart in user space - which is what i was
referring to earlier
(with mention of skbmark) I can achieve these goals without any kernel
code changes
but like i said i understand the operational simplicity by putting
things in the kernel.

cheers,
jamal
