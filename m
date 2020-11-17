Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7E92B713E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgKQWHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbgKQWHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 17:07:55 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444B8C0617A6
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 14:07:55 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id l22so11997160vsa.4
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 14:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=umEa7JuHmTxIADXNGGqKNEHKb3a04RTaswLCVFJxa4M=;
        b=tI4mA80+Xd+JUJ/JzwWEysBKnaTvgHAU/hR2i1Wqs9FEiBXbaulhbQxwgONQh5AKZk
         9JQ4pKVTUHba6Ba5Ytj7wdoKe8NLQYcL6W0bKir9B6Qnbtv0atVqDA0X0VacBHNxQDFc
         ltG2s+9QQ7PnpRfVrsZPaVcgwAWqw+EiOCi4RmC6O3YM2781T5LdZvaitL/10JhqaZE0
         OYM9rgwZTQ3VNwb7RqVlGg3K7NXXVUTEDT6iT8glzocYQdWjMcXuKb6lyIn66gVC+zQH
         wo4wTmGsb1H3lf79eje+pGYOANlnYRA6ObW6mqh/7w8dArzIczPEEvgTCxMWKTYqcYaH
         0L0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=umEa7JuHmTxIADXNGGqKNEHKb3a04RTaswLCVFJxa4M=;
        b=MiCV4OYkGr0qEI7LG05atliFDkaWWaFhsahbuEHvuJRBXw6f4H4Xvl+eFH24awNg/I
         53gw+oOKUdoC8YGNB8ayizYRPSX00GXets/iBSIPTPBwf3OTpP6RlvBEK/ivvwt616Jk
         6XkSBZ81GPzFLt7DElNnsvBfkVvoEJFIltILG6/pbZ5CR33ieeKuJ+XvPiF7uAtlX2HQ
         rwiMAgw2we4DMnWp2iVNMWsfBgKIjnSyX2LGOg7PeYdbr+8zjQ8cJivBMmwv9HrCs2Tv
         BMv6f+Kyvpfm9my+47F/RN1AuwwgXHHSAKv9PfJKSYVK1UiHkqYMmw5UVVQtG1XnzeLb
         e9AA==
X-Gm-Message-State: AOAM5318zPobqHhM6WxRENtOITaNV65Jh3ApdouyJ+A4GuZzazbzbxqs
        L6Lt4UFRROpZcEWGFDbeKMYRAqqykvKR4C70HoDizA==
X-Google-Smtp-Source: ABdhPJy1j7yuSAkeHluT8wnz4btQvLYJWOobaaWW1k9hE9h6H7I1udmnoO2ccRadkiR3syWb8ZwHFHLeDEr/GT1JY7A=
X-Received: by 2002:a05:6102:22da:: with SMTP id a26mr1462614vsh.13.1605650874215;
 Tue, 17 Nov 2020 14:07:54 -0800 (PST)
MIME-Version: 1.0
References: <20201117205902.405316-1-samitolvanen@google.com> <202011171338.BB25DBD1E6@keescook>
In-Reply-To: <202011171338.BB25DBD1E6@keescook>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Tue, 17 Nov 2020 14:07:43 -0800
Message-ID: <CABCJKudJojTh+is8mdMicczgWiTXw+KwCuepmG5gLVmqPWjnHA@mail.gmail.com>
Subject: Re: [PATCH net] cfg80211: fix callback type mismatches in wext-compat
To:     Kees Cook <keescook@chromium.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 1:45 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Nov 17, 2020 at 12:59:02PM -0800, Sami Tolvanen wrote:
> > Instead of casting callback functions to type iw_handler, which trips
> > indirect call checking with Clang's Control-Flow Integrity (CFI), add
> > stub functions with the correct function type for the callbacks.
>
> Oh, wow. iw_handler with union iwreq_data look like really nasty hacks.
> Aren't those just totally bypassing type checking? Where do the
> callbacks actually happen? I couldn't find them...

The callbacks to these happen in ioctl_standard_call in wext-core.c.

Sami
