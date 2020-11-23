Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7882C1139
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbgKWRBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgKWRBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:01:09 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E79C0613CF;
        Mon, 23 Nov 2020 09:01:09 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id 10so16574138ybx.9;
        Mon, 23 Nov 2020 09:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8oS1tqNv7f6RkxFUUnN8Th7AIx+SIEYLcj7Qp63p9k=;
        b=XVEZRacQJCq6PUcwiSqBhTCNm6nCGyDfUWju1rcXBbeqoud9rcUoA0tOMYCMzB16+A
         Tf2nyNR3t/IgTmwCIQB3ypyJX49r6P9OYc4rr8O0GyP+kH9GvVo57h25AzM2IpNdBJCI
         6VLJdQ/PQ4UkU3N4pmDXYYgizJ5Pfla+w5/9goVU/6MpEicrzk67JRLBr0Cie208jhlC
         H98JkfQHihT+nzvH+TLNNG0iXU+4+bFV34QO7OZ83KC7AUou7iPn0+Or7kQLOKk4QbqZ
         u31mLbMWS6fVKYWBJpOVY66yIIwTk5i1l6O01w6Kg0HE6F0Pd/kbjjmGlUCXMvB2VIHC
         l2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8oS1tqNv7f6RkxFUUnN8Th7AIx+SIEYLcj7Qp63p9k=;
        b=Wc298nc/h42tFExOzZSG/XQQDQWWToqrhSnC1fve28PRg8Y9rQKDUv5xrORNiKFRQ/
         G7PWlC7Ho08NhwEZgdYeSz0K9LkTgBceZg2+LSK1F10m2D+b3CUYLdXQrra2fsH06rur
         +tMd+zIKkYbY7RijmRp1p9aPvE2f5JWdC6kXHbIBDjf4008BN/Z+5D5O8QaoooiIYO8W
         Po7yAHBGou4onkZoPZEoTsEtJ6rDx0ikanbL8ViJBIOoSKSKZSNEci37gB2QN8+NIvFg
         KWrVVDjBSE/R8VLLjvCAb6lVyVt81cDKTYHIuLuGXJBaztQWMyJNoNbivsxtw5Nh16hn
         XweQ==
X-Gm-Message-State: AOAM530qcPfa+7N9eHzjFouQZuSs1rRyBwlfh5gm5XZuOFw+KvesRZg5
        MEehSIlOWcrdGsNz0IWg8/NlTz2rKxl7NaTsRUw=
X-Google-Smtp-Source: ABdhPJw65A04SBNaDefIkuI5vF2SMl8iYxkpxXq0HO2LbpXElojOUQFFbXitA0Vl7O8rkXXIAYbjyBqND8UiNocLcps=
X-Received: by 2002:a25:2e0d:: with SMTP id u13mr381510ybu.247.1606150868581;
 Mon, 23 Nov 2020 09:01:08 -0800 (PST)
MIME-Version: 1.0
References: <20201121194339.52290-1-masahiroy@kernel.org> <CANiq72nL7yxGj-Q6aOxG68967g_fB6=hDED0mTBrZ_SjC=U-Pg@mail.gmail.com>
 <CAK7LNARjU5HTcTjJG1-sQTJBFqohC1O8aAvFs3Hn_sXscH_pdg@mail.gmail.com>
In-Reply-To: <CAK7LNARjU5HTcTjJG1-sQTJBFqohC1O8aAvFs3Hn_sXscH_pdg@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 23 Nov 2020 18:00:57 +0100
Message-ID: <CANiq72mcJMRqV+YZbQtLTCR37ydD=8yFjFzg5ZYMmtH5pK1sEQ@mail.gmail.com>
Subject: Re: [PATCH] compiler_attribute: remove CONFIG_ENABLE_MUST_CHECK
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shuah Khan <shuah@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 4:37 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> I can move it to compiler_attribute.h
>
> This attribute is supported by gcc, clang, and icc.
> https://godbolt.org/z/ehd6so
>
> I can send v2.
>
> I do not mind renaming, but it should be done in a separate patch.

Of course -- sorry, I didn't mean we had to do them now, i.e. we can
do the move and the rename later on, if you prefer.

Cheers,
Miguel
