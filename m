Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09D850AEF6
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 06:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443918AbiDVETd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 00:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443910AbiDVETb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 00:19:31 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88084EA3F
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 21:16:39 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2ec05db3dfbso73108217b3.7
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 21:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0XMtGxOthvm0qHtvZHNgKtcnPWKVnX2H8GqR5kDhM0=;
        b=bmYXzH44Sbzwz9nQ2VQTn0ve/JQce4+6APsNcIktLszFF0UIf9Xd3V9vzbg4QP2GfG
         2mt2PhnSb/rCmYrFDfnLydrNBQ7zUIl/kmxagqB4/BZQSzlKwD/8ug5FS4hS9SEpxhNf
         BRCirKXPbDGmk4HcHGF4+FA9Yyg0/8ff2MnsuBzLVPPEOKN41G666QjqT2t+/IUhIJ38
         msnxSmqXFbUTBLVRlQeSk3LbBjgQrEFKi5hOUxsGkGS3I2PPsfaMXmd0gBV574jkvDr1
         8vF5c/PB3QND7nYG9k/rpDwK3uwHj/Z4JWlA1ZLlOJ0z31IjppDbRXPwbIJEtoJLa4nf
         Vqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0XMtGxOthvm0qHtvZHNgKtcnPWKVnX2H8GqR5kDhM0=;
        b=qPrjZbFmq1vTPrPrqYrkhnGO/rcdSrbbIIfCXjDshKjrhf7ryG9it9K08mvIHtXnfN
         4NKFId9ZHE2QYCbO7Hl6Sj8qZXW7AkLp31zeDMlc5kGN0jIwU/Yp6UPX9MT+JtKMqSvF
         GeE8XqGOmjWoPZqWYzYAofAwsMqJa6vQS+z+X5aKKmUuTYjWOW2TeB787njmPGun6dYv
         n4raAt3fUaJQTL37gHB8VRDFS7Y9PpQVwlxG7Uu3Zl1c9v1PYGR8wBY5Q/9utzm1J1Dd
         CwL219mjM7i8UmtDO6RoaDFXKMAolnXrfhS1n67sGZcZvK259gpoKnOFyY90Q1aeiJlK
         TmAQ==
X-Gm-Message-State: AOAM532/dYkAm4pXPak0zGm1DyX1lqwbNrjwKDobTMi/WHvSWC6pllAs
        aTbHTAftwUwDGlkJHyTJpwcHSuLfByIf8UvEgY66alhoWRmJCvsR
X-Google-Smtp-Source: ABdhPJzopDdxTHAw51BBzRm6SWCi9XHffPHaT0V92VYPesLSpM2QHIA021Tfoqh2ppZsM1caDbEDNS3T4JIxwrL1NgM=
X-Received: by 2002:a81:2054:0:b0:2f4:dfb3:3e3 with SMTP id
 g81-20020a812054000000b002f4dfb303e3mr3124035ywg.332.1650600998767; Thu, 21
 Apr 2022 21:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220405134237.16533-1-florent.fourcot@wifirst.fr>
 <20220405134237.16533-4-florent.fourcot@wifirst.fr> <20220422035049.lkdmvfhznfbwk7jw@sx1>
In-Reply-To: <20220422035049.lkdmvfhznfbwk7jw@sx1>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Apr 2022 21:16:27 -0700
Message-ID: <CANn89i+MhRzgFqXpeLT+59cZJbS+P2GVegC+Uk1qnApK=a_m4Q@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 4/4] rtnetlink: return EINVAL when request
 cannot succeed
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 8:50 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On 05 Apr 15:42, Florent Fourcot wrote:
> >A request without interface name/interface index/interface group cannot
> >work. We should return EINVAL
> >
> >Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> >Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
> >---
> > net/core/rtnetlink.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> >index e93f4058cf08..690324479cf5 100644
> >--- a/net/core/rtnetlink.c
> >+++ b/net/core/rtnetlink.c
> >@@ -3420,7 +3420,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
> >                       return rtnl_group_changelink(skb, net,
> >                                               nla_get_u32(tb[IFLA_GROUP]),
> >                                               ifm, extack, tb);
> >-              return -ENODEV;
> >+              return -EINVAL;
> >       }
>
> This introduced a regression iproute2->iplink_have_newlink() checks this
> return value to determine if newlink is supported by kernel, if the
> returned value is -EINVAL iproute2 falls back to ioctl mode, any value
> other than -EINVAL or -EOPNOTSUPP should be ok here to not break compatibility
> with iproute2.
>

Yep, but apparently network maintainers are MIA

https://patchwork.kernel.org/project/netdevbpf/patch/20220419125151.15589-1-florent.fourcot@wifirst.fr/
