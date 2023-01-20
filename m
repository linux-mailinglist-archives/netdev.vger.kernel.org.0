Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5BA675DDE
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 20:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjATTVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 14:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjATTVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 14:21:08 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AD128D26
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 11:21:07 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id 3so6727168vsq.7
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 11:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oKc6aNElBeAjI0A5h4AlsuIRL0OuAo/OC+4hdSyr7ko=;
        b=cNyecBjx4GrRbbQB+eKy3OkwQjZ2Qa0TMinfaoUdN/IRX0MBlZa/RsYnhvR2kAZb6x
         CtXGnDx05z8vkmXXN1skLmANGwZ7jJIKWbLP864IS6hmrqdNLYeQTmVwNqz+d3RGX7Y7
         Y2j2qq4OX70FgEDGJmBIxLHz0/f14J8oiZ154=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oKc6aNElBeAjI0A5h4AlsuIRL0OuAo/OC+4hdSyr7ko=;
        b=SuVGMHzmtAhRK5G+td6TgXuSUqGq3GliS3rGeonReVclsGo+xHFmQHgdd6HXE+7W/y
         ep0EjBISOMOACCK+V/1uf7+YBg3yejlv9LiO2h7oxIVq2PaO2/u4YWWCKN1tLTa1Ig/0
         DAehrPbLUU7+j8JrM+LCcs9C+sdkQrSQjcB4a9P+bbCILt1IoyhnHKSARTCxBQG0MtDf
         TDNYy6qdRLjsuB+u0PRqANcWntj7PxH2QSI6LqFtZq5O/VV6WLZF38zicEUb6qZEY22p
         8WLmCzbF94AHAKxqpMSFWl5ftbJ3nTKz499bE3u/sJN7xLSqxushd5myVrDLDWu/RXvi
         jrpQ==
X-Gm-Message-State: AFqh2kq+wVdT/GYf6W9JeCbMWT707/3HkKjdIAoVoCnGgPrptjMll5Th
        hRTlKa59cuCWpshjPb0YkzYkV4nE8gwQHePq
X-Google-Smtp-Source: AMrXdXuxpbXMIyRTOU2iS65OSj8uKbFncSyYdv45xc9kDOL+aXUPn9HyLObQvSbiZfKrWYIkGhYCKg==
X-Received: by 2002:a05:6102:2135:b0:3c8:f1de:f5b6 with SMTP id f21-20020a056102213500b003c8f1def5b6mr10154870vsg.8.1674242466328;
        Fri, 20 Jan 2023 11:21:06 -0800 (PST)
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com. [209.85.222.174])
        by smtp.gmail.com with ESMTPSA id f9-20020a05620a280900b006fcaa1eab0esm27076762qkp.123.2023.01.20.11.21.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 11:21:05 -0800 (PST)
Received: by mail-qk1-f174.google.com with SMTP id w21so3416411qkf.8
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 11:21:05 -0800 (PST)
X-Received: by 2002:a05:620a:144a:b0:6ff:cbda:a128 with SMTP id
 i10-20020a05620a144a00b006ffcbdaa128mr837664qkl.697.1674242465702; Fri, 20
 Jan 2023 11:21:05 -0800 (PST)
MIME-Version: 1.0
References: <20230119185300.517048-1-kuba@kernel.org> <20230120085114.6c30d514@kernel.org>
 <CAHk-=wgsKaO7qxOso_PrmsBEfpN-Wot=V0fUAy3oKOSFuAQxVw@mail.gmail.com>
In-Reply-To: <CAHk-=wgsKaO7qxOso_PrmsBEfpN-Wot=V0fUAy3oKOSFuAQxVw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 20 Jan 2023 11:20:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=whEAtZ+p0svZ1i1jg3=bh2MWPm_KQo9Mq3AiKwKWaNHxQ@mail.gmail.com>
Message-ID: <CAHk-=whEAtZ+p0svZ1i1jg3=bh2MWPm_KQo9Mq3AiKwKWaNHxQ@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.2-rc5
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 9:30 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I undid my pull and will do your v2,

Side note: that late merge, and its revert is pretty ugly.

It seems to be a pattern that the networking tree has, which is not a
great sign (merging much too eargerly into the wrong branches).

Doing a

   git log --grep='Revert "Merge '

does seem to show that this is a networking pattern. Nasty.

But I hope it also means that you know how to deal with the fallout.

In particular, reverting a merge means that re-doing that merge later
will just be a no-op: the original commits are already merged. You'll
need to revert the revert to get the changes back (or you just need to
re-do the whole thing).

            Linus
