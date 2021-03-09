Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A516B331FCD
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 08:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhCIHaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 02:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhCIHaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 02:30:08 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A979C06174A;
        Mon,  8 Mar 2021 23:30:08 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id d139-20020a1c1d910000b029010b895cb6f2so5298628wmd.5;
        Mon, 08 Mar 2021 23:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4vBUhrxGgI51ZZlWqm46T/WJc2GXwjczIDInhwRSI/A=;
        b=gs9QQVH28i3oen5qAxwkyKMFSucE5G2sBQu442e0h0KxaObHcruEnLd+R+ABx/cjeZ
         9zIlvYK++86N5DPiyZBMwb6iHiwhMZWnpRvV8l7ZCZ8A8OFZx/hLgAuTK5w1GzNTBayC
         g41JnAHgHbf0LDwH7KkR1Nx4WFPP9UcmUswGA+AraZ+u74FhkFwBmZgLRYK6SuPCK6Nv
         xLe78qlDDVqxtwtOnBRYWeF9sHapM/khc+tlf6O9UuUf51JkUr7h0jLQjR0IDSTFFeGK
         XVJKKh8TZjqSC4NvTU2dFWC0uGG8YjkgWYegmoNKCABhayvFtDRAaNLaNN0TiYkzZAMd
         s0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4vBUhrxGgI51ZZlWqm46T/WJc2GXwjczIDInhwRSI/A=;
        b=VS0kWg7s4FsqrYn9qCb3eTA9N7HTvg47dNGPULEGhkYuNLTwDp+rATUdGQ2IZ5r2qy
         kr1yD9ezJo1ZJatBXWzEI/rJ+oOsmewtqokAzfFCdJ+DW8NFO+ReL/gApKoy9v7r8fm6
         bM+oK1xla0Pnu1UIoeI5fOgBr+pBjEg4Gz1girOm/QP6rGxEhpPPZRTFdfNg8B8cHkrd
         bK9HUkqwWqZFa5Gsmw+hf+tc9WTuVAwvIjbay4oFFFSkZwPdyEjZkPasJ8JzYoEx47WL
         5ANKjogqMz0UQnq78AYKofZRhxtIcdX+Swt2SaZdTJXHMlIQ5eS77uw98hZTxcGqVmaD
         fMtw==
X-Gm-Message-State: AOAM531lBVLx/bG9Gky2pG+E6zC2IAPgv/p0YIF0t6NqEoh7bYeeEbTK
        W8Ylvn5GYggF+ecmjysYats1iR3yQQwFVibJfys=
X-Google-Smtp-Source: ABdhPJx2IWuDmJBvKFegs727UrdA3ssKH6Xk1k4YM0DngfyAmZ3tgO3on9cbDqKnR/o7Mq4na5e4hTFgXkQgqJm/psw=
X-Received: by 2002:a1c:7714:: with SMTP id t20mr2415722wmi.107.1615275006555;
 Mon, 08 Mar 2021 23:30:06 -0800 (PST)
MIME-Version: 1.0
References: <161523611656.36376.3641992659589167121.stgit@localhost.localdomain>
In-Reply-To: <161523611656.36376.3641992659589167121.stgit@localhost.localdomain>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 9 Mar 2021 08:29:55 +0100
Message-ID: <CAJ+HfNiDZ+iw50W-N9KprHDygzMZcrTteX1KVpmXC0dafDi-RA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [net PATCH] ixgbe: Fix NULL pointer dereference
 in ethtool loopback test
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Mar 2021 at 21:42, Alexander Duyck <alexander.duyck@gmail.com> wr=
ote:
>
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> The ixgbe driver currently generates a NULL pointer dereference when
> performing the ethtool loopback test. This is due to the fact that there
> isn't a q_vector associated with the test ring when it is setup as
> interrupts are not normally added to the test rings.
>
> To address this I have added code that will check for a q_vector before
> returning a napi_id value. If a q_vector is not present it will return a
> value of 0.
>
> Fixes: b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>

Thanks Alex!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

I'll look into if this applies to the other Intel drivers as well.


Bj=C3=B6rn
[...]
