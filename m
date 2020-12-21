Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1622DFF2F
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgLUSEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgLUSEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 13:04:12 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902FEC0613D3;
        Mon, 21 Dec 2020 10:03:57 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id d20so9615889otl.3;
        Mon, 21 Dec 2020 10:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SkxBBTqvX4ksMLPbsVxLzAgxNErI17TvQLy+XCkjQ4U=;
        b=rKK1bRvswKV6f5n4xZcxx7uwJ3QCAuJ8bOVcURcp5u6x1mE1r1Xlc4qMTXGf1fvSF9
         8ojWeiput+LiHGPiLzH1LJLM/pZwPIjYgpwIS/hdcW0lmT+AuU6MrPFS/fsg2rmStXR4
         jOyymKbXtw1N3zxuDqzX8AuTcoUB8Ml/WMzCEYNv0w3lLGx3NrTcMHH7nJQ2pmTS/vPs
         oykLrgpK8SNojYVEpUIQsvCLnb8gejsyXUGAzkXZZSVBW+lzVASURdwuZ0j23YEQ5q1H
         rwvvfYaRWhEJatdWrOYzOyLJct/oAVPkTl8jurgW6RuVGXk4n27OmTN3v2JiPdjUgPBM
         O/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SkxBBTqvX4ksMLPbsVxLzAgxNErI17TvQLy+XCkjQ4U=;
        b=PmzVlOFjnRBItHoIOkfHY0BkfIQtELOMKmmHYJEs6brR4OaK+In8whrV2ordunfMvu
         iqyMrL76LW75RGgVJt+G1aoDNNGjGFc+NMXxyoLAdD5f6qTcCPMQemZd+Vx1pGK2OFoH
         VOHGYTOxU64/dwRPvlfdFbDO6spf12XWfgPbch/3g46Rl0GsBQm5f5AgzUjAN19d4rT5
         uImmr1JsyymcqIPG0gy6QRC6DCn1eV3+uezVI9P/MLXUuYg9gXelNsOsxIo3dNrkSfI7
         FxfpxRNzIlqoRLvhUPjBgucG2EF9IJnfRscGwAarm2AR4IttMepOp7aPxeb4fbISkY9h
         8D3Q==
X-Gm-Message-State: AOAM5330y5QX+QNvBrmRnOjiLgDEk5cg0SYbUIKX91ajCGqWML9NfIzZ
        UVlxj/XgbO8EIRW93tlWuf0ML8FgopBmTL+m4R66JDIn
X-Google-Smtp-Source: ABdhPJzBtR03XJh7zMK5RDu4h7BGWT7TvlxQ7Pub29mtDa6MIdOrtHSbkQtmcuua3/pj4Vsf14WjKK/DGWTqwpD5m+4=
X-Received: by 2002:a25:284:: with SMTP id 126mr22949367ybc.22.1608572323828;
 Mon, 21 Dec 2020 09:38:43 -0800 (PST)
MIME-Version: 1.0
References: <20201221054323.247483-1-masahiroy@kernel.org> <20201221152645.GH3026679@lunn.ch>
 <CAK7LNAQ9vhB6iYHeGV3xcyo8_iLqmGJeJUYOvbdHqN9Wn0mEJg@mail.gmail.com> <20201221170141.GI3026679@lunn.ch>
In-Reply-To: <20201221170141.GI3026679@lunn.ch>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 21 Dec 2020 18:38:32 +0100
Message-ID: <CANiq72=-vdUd-mkhAcNJoWe-QQEyF2uLt1iVnaXYUPPL+1Bk0g@mail.gmail.com>
Subject: Re: [PATCH] net: lantiq_etop: check the result of request_irq()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 6:01 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> So please leave the warning in place, and maybe somebody else will
> fully fix it.

For context: the plan is to enable the warning unconditionally
starting with 5.11. After that, the idea is making it an error as soon
as reasonable (e.g. 5.12 if no warnings remain by then).

However, if there is nobody planning to fix a given warning, then I'd
say documenting the problem with a `FIXME` comment (plus a change like
this or simply ignoring the return value) would be the best approach.

Cheers,
Miguel
