Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E882D2D78
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgLHOry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729840AbgLHOry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:47:54 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A6EC061749;
        Tue,  8 Dec 2020 06:47:14 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id z5so17094725iob.11;
        Tue, 08 Dec 2020 06:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UAkK5jHni9HllrRopYYiLmdi3EZEk2eB9x/rxa5QN5E=;
        b=viNwddBii2g6zOX398mLVdQU6mJGm0XGdzujm1/OMwkIq5+nDn3K4GFE2bzZfJVAYq
         hmuRhn3hUNlXIevwsZ2++13skFgAoLHYiW5FrA4gEewPdKg3r8iIiLoVpvmDdyRGV1ck
         ufBp56izRIZ7KJYFzJQ0CCea85qIze8kvnRyK5RX+DcydriL5eqixKtB51tGsoiiMdi1
         0mUt1d6+fcxnZEYk6QG3EAUz1+jwOHYUvIcDL2h4SxQAPmrmYKBPeyJvsi/oAZsEx3Zx
         FdFJmxb2Z4B+jhtdOLqxfMSuClx1IVi9gLP/8AGqmOUpONtK/GzkpahC9RYExZ93xeSm
         fe0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UAkK5jHni9HllrRopYYiLmdi3EZEk2eB9x/rxa5QN5E=;
        b=WvMANYve+6bQ0wjjmmivcXinpb5NM1vWVEZ7F9uwurg0r/DJjU+mVuJieDmcv8myw3
         agabl4HUlt8wpq/0VVmvhl7dU4CMP5ngPxp2BaqrP5TgkIXjfKJapYK9qh2stpCw7QAr
         4I+XPrCWC4+772KJfmScRkhX/a/43RY0fSns4vBZbk1MuyGVpMiMriED9+0xCfu79qac
         8H7y8nsf7VeYez4gFqsh3an6hTPaVDdGd8/eEzyHrg8axSDwKwyUJO+ur80UGDN52y6Y
         om7WHiodD4mAhD/9BiEDcLwEFX/NWs5d5OELQpQqHDm7RlEDa4NAL/Zk4P9En2f/4hl+
         kVcw==
X-Gm-Message-State: AOAM5329H2MspGebGLOned1WmtInWCNTENr5Y+ECZv92YcPrt/4cKHP1
        ubuvAJ44SP5+iux5W3oDWoNAL+M1F+wSfspJWc1o9H+RR/51/g==
X-Google-Smtp-Source: ABdhPJy5GMzagNUoT9ETs+Q+A+gmRBOs7Ru/qFnzazz28eHN7K5bmM9/G923ChQo8KhsJ1GxLVtPvpjV0E11vBHmot8=
X-Received: by 2002:a05:6602:214b:: with SMTP id y11mr13725071ioy.78.1607438833340;
 Tue, 08 Dec 2020 06:47:13 -0800 (PST)
MIME-Version: 1.0
References: <20201207134309.16762-1-phil@nwl.cc>
In-Reply-To: <20201207134309.16762-1-phil@nwl.cc>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 8 Dec 2020 16:47:02 +0200
Message-ID: <CAHsH6Gupw7o96e5hOmaLBCZtqgoV0LZ4L7h-Y+2oROtXSXvTxw@mail.gmail.com>
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from netfilter
To:     Phil Sutter <phil@nwl.cc>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phil,

On Mon, Dec 7, 2020 at 4:07 PM Phil Sutter <phil@nwl.cc> wrote:
>
> With an IPsec tunnel without dedicated interface, netfilter sees locally
> generated packets twice as they exit the physical interface: Once as "the
> inner packet" with IPsec context attached and once as the encrypted
> (ESP) packet.
>
> With xfrm_interface, the inner packet did not traverse NF_INET_LOCAL_OUT
> hook anymore, making it impossible to match on both inner header values
> and associated IPsec data from that hook.
>

Why wouldn't locally generated traffic not traverse the
NF_INET_LOCAL_OUT hook via e.g. __ip_local_out() when xmitted on an xfrmi?
I would expect it to appear in netfilter, but without the IPsec
context, as it's not
there yet.

> Fix this by looping packets transmitted from xfrm_interface through
> NF_INET_LOCAL_OUT before passing them on to dst_output(), which makes
> behaviour consistent again from netfilter's point of view.

When an XFRM interface is used when forwarding, why would it be correct
for NF_INET_LOCAL_OUT to observe the inner packet?

What am I missing?

Thanks!
Eyal.
