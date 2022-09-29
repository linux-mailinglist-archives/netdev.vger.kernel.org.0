Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842525EFCED
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbiI2SV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiI2SV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:21:56 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221D711BCE9
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 11:21:55 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id m11-20020a4aab8b000000b00476743c0743so665751oon.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 11:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=hxDmnM1IL2wJ6pbSJipbjQaG4VApgtgIvJlR8md9+aM=;
        b=PenDZ4du+ECiK5JkhEN/8v2etfVrHhJu4FghACXwbcptNy/wJ70A8VBSZT9NkSkTWz
         65vvWHEwnH8ygm1rMdIUcQ5V5pwA3WRX3FrNxMbeLYUxHwne4hNdXGhX0d1rE7XDH+WL
         m38r0MlN5hRKyvv9BMtAFTNTtBfUfjwsz3DP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=hxDmnM1IL2wJ6pbSJipbjQaG4VApgtgIvJlR8md9+aM=;
        b=Q2hw23cyPnTNCdMNvXdWte9uWyBIHGcyIKpIUi3Vq7/1xz7YGKlPu+Kc7xE3iOH5Gp
         uYLktVlx3MwXkteSJioc+Qw3sT6hIB4vjdAfCJy8TQQq1J1hS7xkciHD3V3LmMjahwfo
         Xr3R3rYGZ7/7tK6GyfBx92klltgoakjkKt38lqPF263FRrwuAxL5U3rRhvGjgO4e/st/
         vsPLkof0YGc374m5S3Pa0q+jIBTqGSiPe4y1Sv7L3vm6+gCC3k2RTmf6LP36wtH2O/qA
         cftgvwywN+tBVOZROXJwCmzNkCixqjUWU5gSqMcGry9/ZqlU0+g9JzdOGGvSf8XlGYKt
         jrEQ==
X-Gm-Message-State: ACrzQf24G0+jNPukbWex4FuKe0yDgm1BLal1wakKjRRWNfokSZa9ALPn
        E+Ppl9pUV6A9dxAzPkPl5lUkRrMVwFlc+Q==
X-Google-Smtp-Source: AMsMyM6LfqlhITMGds3RvWuyCaKZCCFYMPttzZLX6QDBa7R0AoVnogZ5CV3sTC2RbzJLdcZ2bm/JLA==
X-Received: by 2002:a4a:434d:0:b0:441:9b4:ffad with SMTP id l13-20020a4a434d000000b0044109b4ffadmr1868459ooj.31.1664475713544;
        Thu, 29 Sep 2022 11:21:53 -0700 (PDT)
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com. [209.85.161.42])
        by smtp.gmail.com with ESMTPSA id g189-20020aca39c6000000b003431d9b3edfsm25955oia.2.2022.09.29.11.21.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 11:21:52 -0700 (PDT)
Received: by mail-oo1-f42.google.com with SMTP id m11-20020a4aab8b000000b00476743c0743so665674oon.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 11:21:52 -0700 (PDT)
X-Received: by 2002:a05:6830:611:b0:65c:26ce:5dc with SMTP id
 w17-20020a056830061100b0065c26ce05dcmr1952667oti.176.1664475712268; Thu, 29
 Sep 2022 11:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
In-Reply-To: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Sep 2022 11:21:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
Message-ID: <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
To:     David Laight <David.Laight@aculab.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
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

On Thu, Sep 29, 2022 at 8:22 AM David Laight <David.Laight@aculab.com> wrote:
>
> This was applied and then reverted by Linus (I can't find anything
> in the LKML archive) - see git show 155134fef - because of
> issues with apparmor and dhclient.

lkml archive link:

  https://lore.kernel.org/all/CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com/

in case anybody cares.

I wonder if the fix is to replace the symlink with a hardcoded lookup
(ie basically make it *act* like a hardlink - we don't really support
hardlinked directories, but we could basically fake the lookup in
proc). Since the problem was AppArmor reacting to the name in the
symlink.

Al added the participants so that he can say "hell no".

Actually, it might be cleaner to make it act like a dynamic
mount-point instead - kind of "automount" style. Again, Al would be
the person who can say "sure, that makes sense" or "over my dead
body".

Al?

Or maybe that crazy AppArmor rule just doesn't exist any more. It's
been 8 years, after all.

                   Linus
