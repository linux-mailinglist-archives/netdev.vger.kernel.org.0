Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8E2546B82
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350137AbiFJRJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350116AbiFJRJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:09:26 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D085450B33
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:09:23 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id n28so36129555edb.9
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7NGj/fRsB8QNhSe369jbVTtv9ZIQI4UquOcWKaIS3lw=;
        b=EDxuEBSySIkS0wX9UtgEWpdaZ5Rkk+ceY4FD2zvv24FQoI0QnCjliwtHZ5rtDY13Wa
         /Eo1coASUZ3gqT6dIuUaR+vjQAIZO4ZOodC6LYg8XqX1lajtUhNUr0Kaj+XbuAK8CkNb
         z33Wa9Cj1RwJWTC+jSvNwO5raxNOUS/Gu5Mh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7NGj/fRsB8QNhSe369jbVTtv9ZIQI4UquOcWKaIS3lw=;
        b=hRcnYW8VCXOcmtMNHAPvQg/SHRcdX6SIaLKzPvVrvnBxwhUFQTPAgjmt/MBGOEQCZk
         YbVD8lNRjfKWOlFpT+fq7Pf3blbR4mxteuT1mCAttiCNWplqKof+sYI9KtBjqfwPtT4U
         IV+JRLctoXxl8BREdgh7mnJ8bYu//cLJkapaFYWQWYzndOP2d68ROH7xpb5jqpmylOTT
         1UJ7Cm3InN1BCspub5TL2I9sBl8KiAKYs1ywnIvoUM6Og0KGk4+IzEHDzN9Tr7JvUuiF
         oA7HShXxxhzsFkHvrEI6EKsfi1fxB9PLjc21M1qEf63Scb13SU3g2+DG3glPSdXpFAjd
         n3/A==
X-Gm-Message-State: AOAM531+IfZ3OyUeXYVa2mZZj7oTT7pryZ57LWJscalD7SOBxmt2UDNB
        1bYHH5RiW/0Km3oYJ+rgnOACPFFLKHxIJQnBv68=
X-Google-Smtp-Source: ABdhPJzpXs07wsiCatVKPj3XG5hOGBFpqu99iDt+WV9kh1LczZyq8LMrVqALKnTWD7o5FRVuWB8SNQ==
X-Received: by 2002:a05:6402:370f:b0:428:11f5:509d with SMTP id ek15-20020a056402370f00b0042811f5509dmr400200edb.253.1654880962141;
        Fri, 10 Jun 2022 10:09:22 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id e13-20020a170906248d00b006fee7b5dff2sm12588496ejb.143.2022.06.10.10.09.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 10:09:21 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id i131-20020a1c3b89000000b0039c6fd897b4so959518wma.4
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:09:21 -0700 (PDT)
X-Received: by 2002:a05:600c:4ec9:b0:39c:69c7:715d with SMTP id
 g9-20020a05600c4ec900b0039c69c7715dmr738538wmq.154.1654880961101; Fri, 10 Jun
 2022 10:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220610053544.417023-1-kuba@kernel.org>
In-Reply-To: <20220610053544.417023-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Jun 2022 10:09:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=whAx7AgD59HyZuaLor1afAk=kYCQiG4gacMR8-_GmmBLQ@mail.gmail.com>
Message-ID: <CAHk-=whAx7AgD59HyZuaLor1afAk=kYCQiG4gacMR8-_GmmBLQ@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.19-rc2 (follow up)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 10:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Quick follow up PR, I managed to catch your tree at a point where AFS
> did not build on GCC < 12. Before I tried building it on an older distro
> I already pushed a few things. I figured cleanest if I just send a quick
> follow up and forward again. Please LMK if I should have just merged
> your tree in.

This looks fine to me, and I think preferred over backmerges.

Thanks,

                Linus
