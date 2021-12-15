Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D68475705
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241831AbhLOK5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbhLOK5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:57:35 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEBAC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:57:35 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 131so54002021ybc.7
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AIrkD/IobhHZYxHxGbgH3jxyfBz6NWo4YroRSenLJUE=;
        b=bTTv63Ge/6FRH89M7D86qhkk/pyCDjZIoIBeoUV3DKzSqkzsVNS7z9mXK4/h6OUDQI
         lLVz6Gw0j4byVy4KyQNKzfrPyc72WrQjruSL7AYfw6JfmYo6IRZUatCPx43Arilfo4HM
         DiatrggvhKt1R9HK2ZaAtJnN1dAxzndkkq5x2qMxsZ+ssbw3tIOI1itbFf+zg1ie37CE
         a39rcdDsdQm0un6PMmz1f9zOcDMmCXuWnv2gjEoIsmz5ouIqYLF7B3siGOhLZbc0u7ee
         blnG2P0pM6cGKBKlOeRwEM9nxderFfs3RYTeTJ4qf4q1CJs2eWHRkE01irm3GQYzF2o0
         tqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AIrkD/IobhHZYxHxGbgH3jxyfBz6NWo4YroRSenLJUE=;
        b=W8SHR4YAqQS5SKuBYH687aOZT1Td8NSk87HsW0TXXLYz2phkik1EOeMxDo9McgsaYL
         VPJGVG9z+K1DCKNPWu/qPNhsXNTTZlP4NoMCN5SBTCt1d9kJ1EcnYaTN3gg+9V3F6YoH
         TOkn3KDtRfLWqCU+xUcFG2zD9WXQhF3ZWNnPT0bRRSY1ek9aJeukkAUH4wjJr0IulO0e
         Rb+N+4DHD0Hdkk4ODg+ovyiQPCv8RNWOSufHYarx9djXlHOB4oKQ7jepu62Sjwo+v9Y0
         wCTmQzqMgKTwwlA6pb3GPs6/XSFgXc3mF0wWREb6b6nxO0eMPXEwulzQ30cIpVB3vMgd
         p7xg==
X-Gm-Message-State: AOAM530a4XCtFmVx4CntYLdbL19Hw6Ixc0Khh1rkDwDBme+gUUGzDgqz
        Z3P3+COWPUy72fgTwxG9sHXgXeKufg8Zb4pUwloagQ==
X-Google-Smtp-Source: ABdhPJxJOMUSo4Ey+qvovIH8KQHFepe9ugEWNg072zmjsMSsURjykDxmENoqPcZCtk9GINwhiqy3l2oE+uvi6uwqsdk=
X-Received: by 2002:a25:760d:: with SMTP id r13mr5552778ybc.296.1639565854209;
 Wed, 15 Dec 2021 02:57:34 -0800 (PST)
MIME-Version: 1.0
References: <0b6c06487234b0fb52b7a2fbd2237af42f9d11a6.1639560869.git.geert+renesas@glider.be>
 <CANn89iKdorp0Ki0KFf6LAdjtKOm2np=vYY_YtkmJCoGfet1q-g@mail.gmail.com>
 <CAMuHMdWQZA_fS-pr+4wVYtZ6h9Bx4PJ_92qpDNZ2kdjpzj+DHQ@mail.gmail.com>
 <CANn89iJ-uGzpbAhNjT=fGfDYTjpxo335yhKbqUKwSUPOwPZqWw@mail.gmail.com>
 <CAMuHMdUepDEgf9xD6+6qLqKtQH-ptvUf-fP1M=gt5nemitQBsw@mail.gmail.com> <CANn89iJ2HjNqOM=yF0yCi5K8id7XY=nG-yoo-sJsv=ykaSNDnw@mail.gmail.com>
In-Reply-To: <CANn89iJ2HjNqOM=yF0yCi5K8id7XY=nG-yoo-sJsv=ykaSNDnw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Dec 2021 02:57:23 -0800
Message-ID: <CANn89i+rBQr0dCKp6KrO83cFmB-abNSSbxJiDmOVf-gFfiKnwg@mail.gmail.com>
Subject: Re: [PATCH -next] lib: TEST_REF_TRACKER should depend on REF_TRACKER
 instead of selecting it
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 2:55 AM Eric Dumazet <edumazet@google.com> wrote:
>

> So you say that STACKDEPOT should be user selectable,
> even if no layer is using it ?
>
> I based my work on STACKDEPOT, not on EXT4

In any case, the patch you sent prevents me from testing the module alone.

So whatever you had in mind, you will have to send another patch.
