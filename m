Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A7D69AC02
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBQM6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjBQM5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:57:53 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD18E1A951
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:57:45 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id 12so630655vkj.13
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X0YA885Zz5Kvt8EHU8rMQ4WE+TUUQqvhzhkDDW/8/JM=;
        b=dcwBBwjhoDyPvufqR2rffskMVpxVDU+MHdGvmmwFobMsXZVbdK/44/ACCGV9aI3rDG
         SzmPxhbzqscPib3jVbMJt1qUNLy6g2Cr40/Jg205ieFFx13nMwgONHyNClJoYoBiZ7ol
         couImIxadghwzNjqfaYoBj4bxBgzAe2DAPFmvUjd7Jmod5Slee7FuHwgFOb1ojgtZuvi
         dc4oGFMfSZbQZWp8JKGullOFpudEhd+pOKLvLpx4ZEndO9bDn1/pI2xC8ZldkXKHOPE1
         pqBIrNMF8v3P9UHo+psdYdllA6PpNWF5iD6Mh3NFP8WoduzwAtp0NHulypSqeZFDWmbq
         sLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X0YA885Zz5Kvt8EHU8rMQ4WE+TUUQqvhzhkDDW/8/JM=;
        b=pIz2qN/vFPINWutIy6kJ3UOPw4Lj5YsSXzA9zbUNp1anLwtZz5Gz2pdQZ12XcwUOCN
         8BDK2EUcSWbva/EXf9Nb0anDBZ1ssph4b15yKo6lRSfJL3xxuDA35d4u9hehB/89cesL
         HdJUwGwgT54w9zEmSen664x4WIummm0o8TkNqdOn4kFeJYS43IZfqZ2ZaIwyht+Q+aAS
         R4Bo+O8VLasjnwF0GfBDJWKidrwr9iZcFbRqJlXJj37sE5oz4RUjvO46CNbdq6ZZMhMp
         ZhzklMagTy4P6PbGfBeaheFGuZ9e1dhU271lORgsXuO88uuD7zySLSQVAxmjL+GNsHxo
         rSqw==
X-Gm-Message-State: AO0yUKXXqRTtiasJIavzG6Q7KhgAlmz7pVmopDYaNfl+RgoIoISNy2Tb
        2MY4l60DkaheuxGDebMNcJLngOTSEk5sqqrbdUxS8bChJxJ2acCj
X-Google-Smtp-Source: AK7set/dyIVtxSMMBoR1xstDfdozoiAnHTC9U9c9I6+V12tFuaM1ZeRpSZYuONYJzW7vLrjSz/TnvkK7oQEFMi8FNN4=
X-Received: by 2002:a1f:22d7:0:b0:405:cdc8:50b with SMTP id
 i206-20020a1f22d7000000b00405cdc8050bmr687427vki.41.1676638664643; Fri, 17
 Feb 2023 04:57:44 -0800 (PST)
MIME-Version: 1.0
References: <20230217100606.1234-1-nbd@nbd.name> <CANn89iJXjEWJcFbSMwKOXuupCVr4b-y4Gh+LwOQg+TQwJPQ=eg@mail.gmail.com>
 <acaf1607-412d-3142-1465-8d8439520228@nbd.name>
In-Reply-To: <acaf1607-412d-3142-1465-8d8439520228@nbd.name>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Feb 2023 13:57:33 +0100
Message-ID: <CANn89iLQa-FruxSUQycawQAHY=wCFP_Q3LHEQfusL1pUbNVxyg@mail.gmail.com>
Subject: Re: [RFC v2] net/core: add optional threading for rps backlog processing
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 1:35 PM Felix Fietkau <nbd@nbd.name> wrote:
>
> On 17.02.23 13:23, Eric Dumazet wrote:
> > On Fri, Feb 17, 2023 at 11:06 AM Felix Fietkau <nbd@nbd.name> wrote:
> >>
> >> When dealing with few flows or an imbalance on CPU utilization, static RPS
> >> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
> >> for RPS backlog processing in order to allow the scheduler to better balance
> >> processing. This helps better spread the load across idle CPUs.
> >>
> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >> ---
> >>
> >> RFC v2:
> >>  - fix rebase error in rps locking
> >
> > Why only deal with RPS ?
> >
> > It seems you propose the sofnet_data backlog be processed by a thread,
> > instead than from softirq ?
> Right. I originally wanted to mainly improve RPS, but my patch does
> cover backlog in general. I will update the description in the next
> version. Does the approach in general make sense to you?
>

I do not know, this seems to lack some (perf) numbers, and
descriptions of added max latencies and stuff like that :)
