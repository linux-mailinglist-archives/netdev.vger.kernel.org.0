Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EC466DF09
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjAQNlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjAQNky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:40:54 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B84B12F3F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 05:40:53 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 123so853769ybv.6
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 05:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cjeXJZaBjM1oFIUsiX5HW6vJqN5uBzCri0UFKDq4qoM=;
        b=tBH/uj2F6DarqPfAorIHd6EAbMbsoWw5QPX+n3mVQIonxB/egLJ8QN2c4MsluG9T2t
         MOT1uRtiI7xXxjgBo+bcWkVnqKZwe8YH3wZJdbbVPX/1b6ZjlXIXfEbs9h1N3S2rU5SK
         FEZWbdSEgRX0pqYaySn4laZXdCB1MGmf2xrcdwjQ9CDoWYqWXKh/dHBgGj/2yevq/kn7
         99EI5iZsQdjT3/OUY4B7ISLxb4R03G61ILByXVvzQDQWGRHqwP8AO1o926tbv+wEmIB3
         CBvq67d0QGpE4afb71VXhRHJAWD0dOlIn5tozQqA/IU3i4AI2kizcUKDLmWQoPYsehDr
         priQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cjeXJZaBjM1oFIUsiX5HW6vJqN5uBzCri0UFKDq4qoM=;
        b=1DrCk/PjvvB9e4pRhAuCwg2eV2BsUxMp730RY6fGbVVaURRS9uUPh0CjnvlOtwkYKP
         gfcFm1ONmbdEewqq9LushipD+frQEiRXUTPrCpjaoLhXFKyqdee/KmAXFgQlXsY2yCBP
         ZRejoklUVJYvYlsI1qT1Mhi3qDkzVo/xurVHeioZ7gkvzQ/RrQDCIwFC8dwqYOk2+g4g
         3MnnK91DN38FoK8Tdakhfcwx5hovp2+56Uevkrpv+H3sdQmHCa7StHFVr3yB3IdPCLFp
         +LxqS1kl0sUn+orZQAqWcK/SdgjItVUvWyd91THKiIDYpmR2P30saRF7nELXJFGEAG9K
         bCxQ==
X-Gm-Message-State: AFqh2kocy1R1mAXxtcmh4f+heOM5oxRgZBhtUjnUQKOrjW/N3ZdKGjHW
        Qy40YNhgpCxqm6JanYIFx4L5RMxzkOFX34qgab+Imz2d4JHSgg==
X-Google-Smtp-Source: AMrXdXtV/Ww+b4mDkM7T6sAP3Qd0ytsecyDlLQNRENGKyexWbJKcjXckgGi+PzFmtFTDf8uB5/Bh7FKB/28oIpqu0vQ=
X-Received: by 2002:a25:aba7:0:b0:7cc:a5a2:deee with SMTP id
 v36-20020a25aba7000000b007cca5a2deeemr474683ybi.509.1673962852817; Tue, 17
 Jan 2023 05:40:52 -0800 (PST)
MIME-Version: 1.0
References: <20230112105905.1738-1-paulb@nvidia.com> <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
 <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com>
In-Reply-To: <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 17 Jan 2023 08:40:41 -0500
Message-ID: <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
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

On Sun, Jan 15, 2023 at 7:04 AM Paul Blakey <paulb@nvidia.com> wrote:
>
>
>
> On 12/01/2023 14:24, Jamal Hadi Salim wrote:
> > On Thu, Jan 12, 2023 at 5:59 AM Paul Blakey <paulb@nvidia.com> wrote:

[..]

> >
> > Having said that: Would this have been equally achieved with using skbmark?
> > The advantage is removing the need to change the cls sw datapath.
> > The HW doesnt have to support skb mark setting, just driver transform.
> > i.e the driver can keep track of the action mapping and set the mark when
> > it receives the packet from hw.
> > You rearrange your rules to use cls fw and have action B and C  match
> > an skb mark.
> >
>
> The user would then need to be familiar with how it works for this
> specific vendor, of which actions are supported, and do so for all the
> rules that have such actions. He will also need to add a
> skb mark action after each such successful execution that the driver
> should ignore.
>

I agree that with your patch it will be operationally simpler. I hope other
vendors will be able to use this feature (and the only reason i am saying
this is because you are making core tc changes).

Question: How does someone adding these rules tell whether some of
the actions are offloaded and some are not? If i am debugging this because
something was wrong I would like to know.

> Also with this patchset we actually support tc action continue, where
> with cls_fw it wont' be possible.

It will be an action continue for a scenario where (on ingress) you have
action A from A,B,C being offloaded and B,C is in s/w - the fw filter
will have the
B,C and flower can have A offloaded.
Yes, someone/thing programming these will have to know that only A can
be offloaded
in that graph.

[..]

> > Also above text wasnt clear. It sounded like the driver would magically
> > know that it has to continue action B and C in s/w because it knows the
> > hardware wont be able to exec them?
>
> It means that if MLX5 driver gets "action A, action CT, action B",
> where action CT is only possible in hardware for offloaded established
> connections (offloaded via flow table).
>
> We reorder the actions and parse it as if the action list was: "action
> CT, action A, action B" and then if we miss in action CT we didn't do
> any modifications (actions A/B, and counters) in hardware.
>
> We can only do this if the actions are independent, and so to support
> dependent actions (pedit for src ip followed by action CT), we have this
> patchset.

Ok, so would this work for the scenario I described above? i.e A,B, C where
A is offloaded but not B, C?

I also think the above text needs to go in the cover letter.

cheers,
jamal
