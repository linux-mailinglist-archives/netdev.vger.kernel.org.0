Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DFC5EFF4F
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 23:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiI2VcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 17:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiI2VcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 17:32:03 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BA314B869
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:32:01 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-13189cd5789so3333735fac.11
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=sqNlv/OW7Vbqc+J0WaON3nruQmYPrMCiY8oE33vRgo0=;
        b=WgvJ54039EW1s9ouY71PRlLjRB1AAPBaxK+LwSc9oBSBuBaQGbc1ZZJDQWfpYY+QFv
         oewQ8Emcvlzop7PkUdnxxoLk0x1WLrTMBM5nb291V2CVFW8y9g4r0VJO6fiOGVqJ4/IT
         oR15vgI9ORd7jixr/rCmTwDCitIcweh6MLPh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=sqNlv/OW7Vbqc+J0WaON3nruQmYPrMCiY8oE33vRgo0=;
        b=T8w/do5tjuJKSlb5euT5zE2rvvBmNLWcnFyuSLnpL0Z4yx7Z0IgGRGZaBkp3f9JjVW
         YSWqb/HfsXLrGJDK4vSW2xxn4HiMMsIbqnP4unsro95PLrTF02Arh0OKKUMAHcvO9o1N
         gyb/a2fXwhH78z2e12K2BN1lRajyqs9hCV7Ip5b1jxSU5PrZLN21/dnUY30tYiUvz+wD
         6JRi8/ctPTAKxhmh81wydUvmNC+pg4N3+I87VQAJIdpQ5YKHAo7H1PLiPPL3eWePaBGK
         GqWNbbUAdZe/ejN/BxNeBmzZGqPPCaZvpQY72HW5X9hmJZlckDki9Pw+URNMGO0NoD8F
         cWxg==
X-Gm-Message-State: ACrzQf0XaFFHLfD+Wprs+tinufRcDe/vI7jTLjTl4z/HYxJbO/gdtQop
        JgyjjuJOVvewGlDhllKnsz37w7c0owT1gA==
X-Google-Smtp-Source: AMsMyM5hBT4Cr+GUtYinjgst8odCbPjUMZU/XSnvzT0grnf8K+/oz8OdCXPqNLeqO4q0KFYwVdISYA==
X-Received: by 2002:a05:6870:c59b:b0:131:8d2e:e808 with SMTP id ba27-20020a056870c59b00b001318d2ee808mr8244277oab.280.1664487119903;
        Thu, 29 Sep 2022 14:31:59 -0700 (PDT)
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id h6-20020a4aa746000000b004764a441aa5sm125540oom.27.2022.09.29.14.31.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 14:31:58 -0700 (PDT)
Received: by mail-oo1-f46.google.com with SMTP id u3-20020a4ab5c3000000b0044b125e5d9eso997866ooo.12
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:31:57 -0700 (PDT)
X-Received: by 2002:a05:6830:611:b0:65c:26ce:5dc with SMTP id
 w17-20020a056830061100b0065c26ce05dcmr2281262oti.176.1664487117634; Thu, 29
 Sep 2022 14:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV> <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV> <CAHk-=wgiBBXeY9ioZ8GtsxAcd42c265zwN7bYVY=cir01OimzA@mail.gmail.com>
 <YzYMQDTAYCCax0WZ@ZenIV> <YzYNtzDPZH1YWflz@ZenIV>
In-Reply-To: <YzYNtzDPZH1YWflz@ZenIV>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Sep 2022 14:31:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi2JKDawG44kpS-bbrATB6LDyRx64LwdXEzZk2RYwkzJg@mail.gmail.com>
Message-ID: <CAHk-=wi2JKDawG44kpS-bbrATB6LDyRx64LwdXEzZk2RYwkzJg@mail.gmail.com>
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

On Thu, Sep 29, 2022 at 2:27 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Put it another way:
>
> David:
>         when I'm opening /proc/net/whatever, I want its contents to match
>         this thread's netns, not that of some other thread.
> dhclient+apparmor:
>         whatever you get from /proc/net/dev, it would better be at
>         /proc/<pid>/net/dev, no matter which thread you happen to be.

... which actually creates an opening for a truly disgusting solution:

 - when an outsider else opens /proc/<pid>/net, they get the thread leader netns

 - when a thread opens its *own* thread group /proc/<pid>/net, it gets
its own thread netns, not the thread leader one.

Disgusting.

            Linus
