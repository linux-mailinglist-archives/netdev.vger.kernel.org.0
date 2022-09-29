Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA1C5EFD98
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 21:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiI2TGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 15:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiI2TFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 15:05:54 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513FD146FA2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 12:05:52 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id k10-20020a4ad10a000000b004756ab911f8so750590oor.2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 12:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=d0crPrIiHDvTjv4ASul3Goxd2GrqWv18ntDF0Hrl2co=;
        b=H5ifccgQ3ejZODwR+iA8IAzLi9dYu0f/LWjubXNYIvuq6neuxtgYbJuqppjEF2uYEm
         XFRqX/6m+EvnCT042dj16sp22LNx4emifWUuDPPtKjkWMVmPKJQKgoy3MUns0MnhYiFa
         ZyS1bB5jGNU78LB/vrVxnTpd2ZLgqzBlT8X7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=d0crPrIiHDvTjv4ASul3Goxd2GrqWv18ntDF0Hrl2co=;
        b=Sy2G/FLEeYgmlFtEcHqtSKIK0Y+DDyCYaEcjfzuud8M7FsvKx4q8yEkx54EbQwiU4m
         iZiAc/jzLyHgj+i+p9ZzBwXzb53g37aVo90oeVrwuyvj7fLM6JGL8qF66cDloNdWbb/H
         rNKZCIcx57CJI2SU123P+7Uzv1FjcVqHE6WutZEjs1/gW2vKRM8rKz4KoNshojPorLaX
         bi1a6ccZEGOopPmiwTE2gvKg3KmxTT0a6bmfCuT6moupV9ku/QTnrAONSfFBoV3AgsZN
         2tewWwhhTLULf4w/pmwLRbDs1vXLEsMwqPnZIggboapgJ9GZPyRPFONEy/I45uVcei/U
         o9Ww==
X-Gm-Message-State: ACrzQf1Pit8mnGFjNikGEPSAzDPZFKWIYU3GlqSRIu/yxbrD/1PeCF4V
        7uylYAoGvD5ifDxAWYg7isFseOTyqF7rtQ==
X-Google-Smtp-Source: AMsMyM4uKbBLIPUaLThhYA2Nzr84YL3Yi2Y4q5ODW8dbXFt5OlX9MNbWEj73CjIJ2+/P5W70SCPQcA==
X-Received: by 2002:a4a:d351:0:b0:476:46fd:c2f1 with SMTP id d17-20020a4ad351000000b0047646fdc2f1mr1966289oos.93.1664478350487;
        Thu, 29 Sep 2022 12:05:50 -0700 (PDT)
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com. [209.85.160.48])
        by smtp.gmail.com with ESMTPSA id m8-20020a4aab88000000b004320b0cc5acsm60083oon.48.2022.09.29.12.05.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 12:05:48 -0700 (PDT)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1318106fe2cso2896577fac.13
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 12:05:48 -0700 (PDT)
X-Received: by 2002:a05:6870:c888:b0:12c:7f3b:d67d with SMTP id
 er8-20020a056870c88800b0012c7f3bd67dmr2868462oab.229.1664478348247; Thu, 29
 Sep 2022 12:05:48 -0700 (PDT)
MIME-Version: 1.0
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV>
In-Reply-To: <YzXrOFpPStEwZH/O@ZenIV>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Sep 2022 12:05:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
Message-ID: <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
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

On Thu, Sep 29, 2022 at 12:00 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Which is insane, especially since the entire problem is due to wanting
> that directory to be different for different threads...

Absolutely. This is all due to Apparmor (a) basing things on pathnames
and (b) then getting those pathnames wrong.

Which is why I'm just suggesting we short-circuit the path-name part,
and not make this be a real symlink that actually walks a real path.

The proc <pid> handling uses "readlink" to make it *look* like a
symlink, but then "get_link" to actually look it up (and never walk it
as a path).

Something similar?

                 Linus
