Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6D35EFD88
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 21:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiI2TBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiI2TBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 15:01:20 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4006B12873A
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 12:01:19 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id v130so2559738oie.2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 12:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=CjLH+7U+sZfFHXWVsg+A2jTXjnVK6LjBkvT3fBCaSeA=;
        b=Iu5QDSSRxclcJVVKnZyR/7ber2Bs/dhKEQuq5OEWNriUvYhlbjDm9Jei3Djf+nsuKQ
         eWC3OFhn7DBL256DSdxAGxDvpvA4Q1l8xPbZBmSSioQgV7azxjX9/zxolqyKvyZVysP+
         YhTHlTaCmPpe/U4eREnWR+3gXyVYwC2PlKo/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=CjLH+7U+sZfFHXWVsg+A2jTXjnVK6LjBkvT3fBCaSeA=;
        b=EK7nnr9nIjZyETxdhjU8UgVGrIeAPd49W5AuAsPKcW/vKZ2Sq+4oC++8do8ZsB7j9Y
         Ne/46vBMh2Tj1alHjZRjcMyMU1Eiu1LOos8+YH/O1GJvLujoGF5SPZgux2z8eicJoFaG
         S3y3us0I6LZRtnOZMjEF8FMpbyGg96yLMz/ZGk2ymcnkwFEuNUcDyeqMoXwEFKZlGWDn
         aeD7Io1KiRISJWrcTYQ2JbHEawESITEdMzRQw/JhMrzAnDBlLiorCYpwPlZrhfJ6hYbw
         O1dbYqyoGtoZxFQ7aVrvLArREzz0iCMzFmz5yhqU4dIK4zynTV29YWcgEthT9WTm5gp3
         VSBg==
X-Gm-Message-State: ACrzQf0zA3ZpcPvfQbCNxq3LOzUUXf1L9u2/4K2HXX86tIRrHPyYtfT1
        iPewH9UBR2u4aDbklyt6p/tOOLvnT/HpQw==
X-Google-Smtp-Source: AMsMyM7T137S4buipenIVb7a1zKmcwer95n7r9sRLlipIKLGu2uJHjpxn+YrgINXwABrLyoe/XLiIA==
X-Received: by 2002:aca:904:0:b0:34f:8e77:4d9c with SMTP id 4-20020aca0904000000b0034f8e774d9cmr7811092oij.87.1664478077579;
        Thu, 29 Sep 2022 12:01:17 -0700 (PDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id g5-20020a9d6485000000b0063711d42df5sm112928otl.30.2022.09.29.12.01.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 12:01:15 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id g130so2518097oia.13
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 12:01:15 -0700 (PDT)
X-Received: by 2002:aca:b957:0:b0:351:4ecf:477d with SMTP id
 j84-20020acab957000000b003514ecf477dmr2263698oif.126.1664478075017; Thu, 29
 Sep 2022 12:01:15 -0700 (PDT)
MIME-Version: 1.0
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com> <YzXo/DIwq65ypHNH@ZenIV>
In-Reply-To: <YzXo/DIwq65ypHNH@ZenIV>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Sep 2022 12:00:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wizrMKtFxtK-5b-RmC2T562A8iHSYpnAygu__U-HcG_3A@mail.gmail.com>
Message-ID: <CAHk-=wizrMKtFxtK-5b-RmC2T562A8iHSYpnAygu__U-HcG_3A@mail.gmail.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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

On Thu, Sep 29, 2022 at 11:50 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> What do you mean?  Lookup on "net" in /proc returning what, exactly?

Returning the same directory as "thread-self/net", just not with a
symlink so that Apparmor doesn't get to mess things up..

> What would that dentry have for ->d_parent?

In a perfect world, I think it should act like a dynamic bind mount
(where the "dynamic" part is that thread-self part, and the parent
would be /proc.

That said, I think this is all a hack to deal with an Apparmor bug, so
I don't think we need perfect. Right now it's a symlink, so the parent
is the thread-self directory. I think that kind of magic jump would be
perfectly acceptable.

We have "magic jump" behavior in other /proc places, where the thing
*looks* like a symlink (ie readlink and friends just work), but the
lookup doesn't *actually* follow the symlink, it just looks things up
directly. IOW, all the /proc/<pid>/fd/<X> stuff.

So I think this would be just another case of that.

                Linus
