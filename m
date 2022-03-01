Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C444C979C
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbiCAVQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiCAVQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:16:10 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F228AE66
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 13:15:29 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b11so28996361lfb.12
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 13:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AFFQZ5G9629SYwN4GslubcgtNOJHtDCYyH5rTLKNhPs=;
        b=J7SNKN4+VaeirWCC/sELTWGxD9feSOxwo5q96qWEAmukJiV3VyojWYDxtxuMGxCyR3
         YrpHXPdAb07nriCJ8cCpxklbaMU6iL5ozLyyOZQ0PKB6soH/RogNt2jYscdgsizouIbx
         qbKugFzE7mJwHl02BxHXOCWjpLGFgeV/WWue0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AFFQZ5G9629SYwN4GslubcgtNOJHtDCYyH5rTLKNhPs=;
        b=bcA0INnEDCuRHVNs0gFB/Xa07zr9417BQyqzH6znK/sG57bBmyL7yvRJEdFJDaA7QO
         Fn+J7gvhAenCZADYNFki4Xr3nDSB1/sGTQG0fwBAKBhFVXq6rYSvLXmpLJ+FMpfcPDpx
         6WPKOeMcrHO2yvju1z+Uv3dwRA3PUvNd0H7ODSFmzoMThg0qZbUTDqOAWsd84NzezfxN
         0gVHVHpZz2qpuaBrBo6P/8Hd6n+NfzeZxa2VpBW+jON1hnGlk4Yf4NT/RQFLcVEm9AEr
         shrNyUQJOz7KtOxA3Y3e/kVdMzig9SGQc2B1I7Ep499tJ/EPFxtIHD+GZuTv1Mk5JgVA
         RDcw==
X-Gm-Message-State: AOAM530wPXnDWfiIzGPDKUGkR0NnBv4qRrv4rVDlQbkAQu9vsddvB1Kd
        28b5Kv5fDDOOfLkGuYKv6WlO6JvlO2b7wVAbj4Y=
X-Google-Smtp-Source: ABdhPJwdvKD1n82hrpZ3ULdQLPOmcR5BVaZoRal360Ye3le+cmSByQrazWqI5JagNxfC/lZVr9P4zA==
X-Received: by 2002:a05:6512:3741:b0:443:d5c1:404b with SMTP id a1-20020a056512374100b00443d5c1404bmr16096883lfs.565.1646169326518;
        Tue, 01 Mar 2022 13:15:26 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id u19-20020a2e91d3000000b002461bced9e2sm2189651ljg.79.2022.03.01.13.15.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 13:15:23 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id t14so23554699ljh.8
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 13:15:23 -0800 (PST)
X-Received: by 2002:a2e:3013:0:b0:246:2ca9:365e with SMTP id
 w19-20020a2e3013000000b002462ca9365emr18180017ljw.291.1646169323173; Tue, 01
 Mar 2022 13:15:23 -0800 (PST)
MIME-Version: 1.0
References: <20220301075839.4156-2-xiam0nd.tong@gmail.com> <202203020135.5duGpXM2-lkp@intel.com>
 <CAHk-=wiVF0SeV2132vaTAcL1ccVDP25LkAgNgPoHXdFc27x-0g@mail.gmail.com>
 <CAK8P3a0QAECV=_Bu5xnBxjxUHLcaGjBgJEjfMaeKT7StR=acyQ@mail.gmail.com> <CAHk-=wiFbzpyt1-9ZAigFYU7R8g9mEgJho3w7yGYe0h-W==nsw@mail.gmail.com>
In-Reply-To: <CAHk-=wiFbzpyt1-9ZAigFYU7R8g9mEgJho3w7yGYe0h-W==nsw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 1 Mar 2022 13:15:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiuZGzc2UaNVPr6rZnK7buvaQWfadZMcDXavE=MeCXw3g@mail.gmail.com>
Message-ID: <CAHk-=wiuZGzc2UaNVPr6rZnK7buvaQWfadZMcDXavE=MeCXw3g@mail.gmail.com>
Subject: Re: [PATCH 1/6] Kbuild: compile kernel with gnu11 std
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     kernel test robot <lkp@intel.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        kbuild-all@lists.01.org, Jakob Koschel <jakobkoschel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 1:04 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yeah, looks like that "<< 16" is likely just wrong.

.. and perhaps more importantly, I guess that means that -Wshift-overflow is

 (a) somehow new to -std=gnu11

 (b) possibly a lot more relevant and good than that
-Wshift-negative-value thing was

doing some grepping, it seems like we have never had that
'-Wshift-overflow' even in any extra warnings.

And trying it myself (keeping -std=gnu89), enabling it doesn't report
anything on a x86-64 allmodconfig build.

So I think this is likely a good new warning that -std=gnu11 brought
in by accident. No false positives that I can see, and one report for
a MIPS bug that looks real (but admittedly not a "sky-is-falling" one
;)

There's apparently a '-Wshift-overflow=2' mode too, but that warns
about things that change the sign bit, ie expressions like

        1<<31

warns.

And I would not be in the least surprised if we had a ton of those
kinds of things all over (but I didn't check).

So the plain -Wshift-overflow seems to work just fine, and while it's
surprising that it got enabled by gnu11, I think it's all good.

Famous last words.

                     Linus
