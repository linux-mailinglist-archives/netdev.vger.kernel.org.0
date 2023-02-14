Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CDD69718E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 00:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbjBNXGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 18:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjBNXGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 18:06:12 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E60E2B0BB
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 15:05:46 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-52f0001ff8eso128718927b3.4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 15:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y/aEHFG6Az5ECrZ77VlsSjPTdsG/bvY8F16S7b4NKpc=;
        b=3+beGfjgidgqkA9W28KBnjoRGEWXsN1LTl/of8k1hT8N9AN/Gp/VLJZHeZW8zVr0Z0
         GKo2KvABztxfrYfHnA9oLs7SbZWyBGfq8ycjnokt2ezFwpydtQTKVSF3+fmxznNtmEsl
         NS9VZxfkEe0i43tEWSV8xzXdyHy5a3aScSDlrtgGLjbSZu3n/laBDUrw+RAwQ96GjwzG
         v96Y01onUcKQ7z7n0eFldToRoYFAsrFYVQaVDYP4QirllGH2C2kiViT1HnPc1PjWqM4V
         6YlXBaaTjtRyf2lO+BaquQq7vZ+MYnzcyzSXxR6v5SJ2JP/MgbSdbIHIE/Zeu2I2wKCK
         PxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y/aEHFG6Az5ECrZ77VlsSjPTdsG/bvY8F16S7b4NKpc=;
        b=7F/VaeXPw774C54zx0iuslNpawyRBKN5iF9P/POIpUmY5J8gN9BrIG/rM0mYs7mhtk
         5iEZhyxeIQSQav01+3riAFr7KQ82qz4Nyo6R5LQUbkxkoawAHZnUvVCOLddXZwhPZrb0
         l6LVfA34xHOAKcWfZDXg80VcqQKE8jgaE9AzZKR1lM/bwjMRQOPzhzj7EygV1s36NYc5
         GaH5+ym5H3psfu0kTVLEusV10AlkuIYK9JO3+sTL1jEKYJROgtyfjFtjrUVKfnuPAUbl
         CRMmEphflAhk+KtdduQ6/sapboscN6Vp6DEo4DtHirqdby3UF6+nUqkt3RCLu0KdNPbC
         EAxA==
X-Gm-Message-State: AO0yUKXcmNQW8XYR5obPBEhYUtcOXThD2ZM7+nlXZJP8imLc8VmO9BB9
        KW5QX4yvfCs0sqGz00ur02R78w78k6weawo41kkd6A==
X-Google-Smtp-Source: AK7set+q/mjdswsNJiTQhhdmT4nxs5wwX1jLgXe1fsG3buNZ5I/hANZ2lhCz7+G7wEndzPSo7kz21Kl+EYy4BiDRWOw=
X-Received: by 2002:a0d:dd09:0:b0:4ff:a70a:1286 with SMTP id
 g9-20020a0ddd09000000b004ffa70a1286mr21290ywe.447.1676415934088; Tue, 14 Feb
 2023 15:05:34 -0800 (PST)
MIME-Version: 1.0
References: <20230214134915.199004-1-jhs@mojatatu.com> <Y+uZ5LLX8HugO/5+@nanopsycho>
 <20230214134013.0ad390dd@kernel.org> <20230214134101.702e9cdf@kernel.org>
In-Reply-To: <20230214134101.702e9cdf@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 14 Feb 2023 18:05:23 -0500
Message-ID: <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and classifiers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 4:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 14 Feb 2023 13:40:13 -0800 Jakub Kicinski wrote:
> > > I think we have to let the UAPI there to rot in order not to break
> > > compilation of apps that use those (no relation to iproute2).
> >
> > Yeah, I was hoping there's no other users but this is the first match
> > on GitHub:
> >
> > https://github.com/t2mune/nield/blob/0c0848d1d1e6c006185465ee96aeb5a13a1589e6/src/tcmsg_qdisc_dsmark.c
> >
> > :(
>
> I mean that in the context of deleting the uAPI, not the support,
> to be clear.

Looking at that code - the user is keeping their own copy of the uapi
and listening to generated events from the kernel.
With new kernels those events will never come, so they wont be able to
print them. IOW, there's no dependency on the uapi being in the kernel
- but maybe worth keeping.
Note, even if they were to send queries - they will just get a failure back.

cheers,
jamal
