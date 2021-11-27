Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D0B4600C7
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351809AbhK0R44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355852AbhK0Ryz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:54:55 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518B9C061746
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 09:50:12 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r11so52669839edd.9
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 09:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IvT9A5PgUmmsdPPgmPRktfoLrELQ59r0exofkW/Ii+s=;
        b=NG/FrhUNB8KbyEz2TDL042nDzHzH+VadLD01K1N9pZwyXL8vXfmRFKJMa+97iUJZwW
         KBrgbnqr3+j89Q2pkbY5D0aL+tGvXnmERU/bcRrMS6vcBUu2Sb1eW8UgOn5IAYS51JVg
         i9UpH4LAFB4YhLF1HuYB+dFSkyRJ71mwJ6DUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IvT9A5PgUmmsdPPgmPRktfoLrELQ59r0exofkW/Ii+s=;
        b=xODUdCxx6R4LPXgqNyLU6x8lqkvfmB5aolek6txah09mYsoJy1drV21SBSEyShtfm8
         aF1e35jRXDqmOx8VPgOrr3056jbYO/4IAvq/OIWa0DPdi5w+OzuX9h5XD2F3N6lpYlff
         Nz+2UyceLJn1OEIGuT0XfqKI9sVp/cc8vMNridfZZzykpJ6LqOVjO/Dfigr1SwZODtUD
         3JZVZeAjUllKqw2KZNzLLpwp7w8n5AcEtmAbvGFMOKIO4zF9rCZbjY1hxkZk5QDYWWak
         eXmu/5FZEL4fzWxxHKK88rmXLNSBFzPXmMw3lP9C2+xUCHs4zbIKMN9/lHA2g0txfQ9Z
         ktUA==
X-Gm-Message-State: AOAM5325vtAzbS+i0pst7K9GLgA2MmpkbR0wP98cVGcPn/S0LmFfq3+i
        tFqLhnCdDkkIpsf2GQV3A6pqLC0QIxP7LWbX
X-Google-Smtp-Source: ABdhPJxVQWTN3hzTw+/CWYKMvI43tZjCIbrBHFSglWA1ljQfGHKQFftrTi9DgBp6bORzeaEVxyvsPg==
X-Received: by 2002:a05:6402:190c:: with SMTP id e12mr58647211edz.396.1638035410474;
        Sat, 27 Nov 2021 09:50:10 -0800 (PST)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id hx14sm4668646ejc.92.2021.11.27.09.50.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 09:50:09 -0800 (PST)
Received: by mail-wr1-f51.google.com with SMTP id s13so26238564wrb.3
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 09:50:07 -0800 (PST)
X-Received: by 2002:adf:e5c7:: with SMTP id a7mr22736016wrn.318.1638035407409;
 Sat, 27 Nov 2021 09:50:07 -0800 (PST)
MIME-Version: 1.0
References: <20211127154442.3676290-1-linux@roeck-us.net>
In-Reply-To: <20211127154442.3676290-1-linux@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 27 Nov 2021 09:49:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh9g5Mu9V=dsQLkfmCZ-O7zjvhE6F=-42BbQuis2qWEpg@mail.gmail.com>
Message-ID: <CAHk-=wh9g5Mu9V=dsQLkfmCZ-O7zjvhE6F=-42BbQuis2qWEpg@mail.gmail.com>
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

On Sat, Nov 27, 2021 at 7:44 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> This is the third attempt to fix the following build error.

Thanks, looks good to me.

Should I apply the patches directly, or were you planning on sending a
pull request when everybody was happy with it?

           Linus
