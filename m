Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CD54AD06A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346956AbiBHEiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiBHEiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:38:55 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F860C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:38:54 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id bt13so22420241ybb.2
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tq5yw0hF9X5jD45i1JnU68xQnDL5OEWyZz6Q4vgMW2g=;
        b=mMat7/lK36VwV1XDgGaJMbYySB/5tk81WK9vGqzfS/XOmiwwSGLeuVkqJsV/uMot52
         6TGBbP3oTUYq0NQX/cuBYDs7JTVvDeHq3jm66rzoaZI0tefpmyZzoZvjdu2Geg2n1gn7
         xYrNMELSwd+F1A2yizu8vr9bjkACPocjmDvfek/tgKt3wF4mb8Hp7iWPwy5G2NhYn2yQ
         bWhdqK198xHGehJk+wMpv/aJlmnAk4iAs0mfyczoesY4kK7m3qSRYmeT61gHEavIpw8S
         v/C1LT16RmcvzOHJQEZr2anurH3cYNKpUVSH6HPp09bMAJ5GvsAH3BqjNV/VnBNUXoek
         7Yqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tq5yw0hF9X5jD45i1JnU68xQnDL5OEWyZz6Q4vgMW2g=;
        b=bnFoip+WA+Uq4/0ssZv3Bo0aizbsWd+mL63c8ETYjG3sMcFhKxAp+h3dBuuix0O9jM
         n3NCd5tZXhVs7OjocfVjiP4/MA51fWNfFDofK+poslFQ1vfKkiOmIzm5HXZqUSX/2dyK
         31ygrHxeGqN7sb7+ZyI66oVXh+ODgN2woLFd4YEH78WA4FFW/md2F4yRadl46nneFgA3
         SslX7jVxh3AcAuFxZZtaN8Mb9BX5DQM9tyIZgP/X89HS6Lm6QLb82FqFGi8wzakcXyeQ
         bB2R8O/odV8TWbJyj4/3N/d1NYB5vLrEjSg5YwD/Z0IGQo3cNyTuKIfRrDM5fytUVuQc
         aqnA==
X-Gm-Message-State: AOAM533+CK2kaPrN4CpMh3Cad3x9u1XIT3rDxQeziHWcpiFAJ0nfBvM8
        n1TD0ApVeuF14jhIXvdtX9vqoy4eBi+Sse0oYxWnVKRdUXI1FA==
X-Google-Smtp-Source: ABdhPJyU85+C9n3CksGVOMZXMCstWxZrp0OqVPn/R0T4ni4TZVjWkKNO+Q7kC+ahfVQ9X0pTVn21cHzH83IkRjKYi70=
X-Received: by 2002:a25:d490:: with SMTP id m138mr3149906ybf.277.1644295133244;
 Mon, 07 Feb 2022 20:38:53 -0800 (PST)
MIME-Version: 1.0
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-12-eric.dumazet@gmail.com> <2815a75c-b474-34f0-f0c9-7566f0f9e87e@gmail.com>
In-Reply-To: <2815a75c-b474-34f0-f0c9-7566f0f9e87e@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Feb 2022 20:38:42 -0800
Message-ID: <CANn89i+EQx3AqvE39HOjiS0F5a3_CfWqirN1cEuZYyDgxfQBDg@mail.gmail.com>
Subject: Re: [PATCH net-next 11/11] net: remove default_device_exit()
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 8:29 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/7/22 9:17 AM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > For some reason default_device_ops kept two exit method:
> >
> > 1) default_device_exit() is called for each netns being dismantled in
> > a cleanup_net() round. This acquires rtnl for each invocation.
> >
> > 2) default_device_exit_batch() is called once with the list of all netns
> > int the batch, allowing for a single rtnl invocation.
> >
> > Get rid of the .exit() method to handle the logic from
> > default_device_exit_batch(), to decrease the number of rtnl acquisition
> > to one.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  net/core/dev.c | 22 ++++++++++++++--------
> >  1 file changed, 14 insertions(+), 8 deletions(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks for the review !

I am sending a v2, with your tags, plus the RTNL_ASSERT() typo fixed.
