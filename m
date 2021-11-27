Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77564601F4
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 23:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356403AbhK0Wha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 17:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356372AbhK0Wf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 17:35:29 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6344C061574
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 14:32:14 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x15so54527286edv.1
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 14:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BXUeAi2+SoZlOAeVxzpmD/hoJP95QxCkovEv8DaX2SQ=;
        b=SlW9NdbVN58YpeREsvTB9WyxAD6XgU0wbSRECOnLAdjp3CjRYvUXyMEc68vSH6ybpX
         IeNIX2UReqfIFSK4Z0S2vK/lC7F07lMqUrgEYglszqNYs8bEnafD4LzlR3S28r9l3VsZ
         c9Ia8cLhA495icUxVghv669/m6jpS3lHDLtfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BXUeAi2+SoZlOAeVxzpmD/hoJP95QxCkovEv8DaX2SQ=;
        b=n91PiuT52VaoP3pPibr9/YTrHEV5Ka0+URQwYTIHtVtLaXk58tDWiJHn/J6BsM9ADn
         VEMtcO0THut5jxdtTQYoq0nR6EzUQLhwEOIwh+nqDgE3XOYkngC1rxTzdOtN2SiVqVDq
         wP/H3nLQ5UaU6urPixdw0hP/6XgrS/qtNUJm2qHvvmby+viPUjC0urnG8qoRwE4gPq4x
         EPRpqMqxoUxx1PzrHuTnC4GzJzH4UzwgT/cMjOt4B0XbeAed24a9SoDQS0Vz1DFiJppY
         9+8W9Th+WHs/50kTwp6ucrka598ZXpcDZvxlFBkmi1Z5yt3FH2uLt5xeMxJoV83ta8bg
         WbsA==
X-Gm-Message-State: AOAM532VlfvKMVL0dauzCrzaWBPBfqwaXBUwqEQ5Ypb/4U5R57Oyc5wX
        r8IyA+3ByhVKPdPFcTKeTlSAvF8mdPqvIndM
X-Google-Smtp-Source: ABdhPJyaGBdkLxtyUo5R4b/THE/O/PkP/+P0Rm7cGGmZMAokLFwRnnisHu2XtdlnCgxatRFJbRYSXQ==
X-Received: by 2002:a17:907:3f07:: with SMTP id hq7mr47939711ejc.420.1638052332838;
        Sat, 27 Nov 2021 14:32:12 -0800 (PST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id ch28sm6132109edb.72.2021.11.27.14.32.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 14:32:10 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id 133so11332402wme.0
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 14:32:10 -0800 (PST)
X-Received: by 2002:a1c:7405:: with SMTP id p5mr24444897wmc.152.1638052330543;
 Sat, 27 Nov 2021 14:32:10 -0800 (PST)
MIME-Version: 1.0
References: <20211127154442.3676290-1-linux@roeck-us.net> <CAHk-=wh9g5Mu9V=dsQLkfmCZ-O7zjvhE6F=-42BbQuis2qWEpg@mail.gmail.com>
 <228a72fd-82db-6bfe-0df6-37f57cecb31a@roeck-us.net>
In-Reply-To: <228a72fd-82db-6bfe-0df6-37f57cecb31a@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 27 Nov 2021 14:31:54 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjaVwrf1OQbDSbk1FxqzbtAYQLx16D74TeagXQyb5oEEA@mail.gmail.com>
Message-ID: <CAHk-=wjaVwrf1OQbDSbk1FxqzbtAYQLx16D74TeagXQyb5oEEA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Limit NTFS_RW to page sizes smaller than 64k
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 27, 2021 at 2:26 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Either way is fine with me. Either apply it now and have it fixed in -rc3,
> or we can wait for a few days and I'll send you a pull request if there
> are no objections by, say, Wednesday.

I'll just take the patches as-is and we can leave this issue behind us
(knock wood).

Thanks,

           Linus
