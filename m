Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CD62E0BF4
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgLVOod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgLVOoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:44:32 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38064C0613D6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:43:52 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ce23so18542815ejb.8
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mj1e9GJGtgDAlKPwJtIlHCuzGziY+Ki4te0nGssc4KI=;
        b=sjXcCE8A8CIn/E42tu/RspCzFqfsQObZlgxZoiZjrSYZ6IhJGZ8aAJEbJe2PN3d20E
         kwdHQwuztHAolkSsUH6pem+4ZllfzxdRDF/07VOPT/5SMZE99hKY++zhGRdxh/s6Xq+d
         /ZiPCuw2/AbDTWz/vpXV9R8kuPb5+/XB/HDEU6hXSxQIJUrrnL6bEgHZPc0dDqbA4iAA
         DOCzqGUGwovJbXx3MlHGn+NsclJt+4z85ziZz2xYs/89uX3dvZmtWzI9L3ovh8xT/Wss
         diKGnkIwDrq5KL1z8MW2h8WtardzHdhZE6lxaeH5yIA9BpbI5kJxyg4czsE/pWQI4LqN
         H8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mj1e9GJGtgDAlKPwJtIlHCuzGziY+Ki4te0nGssc4KI=;
        b=VBXCvNVdCmDWmnNt8aTGq3IMdtu7wZ8EnZUjqI8m3Zv0zPujHCerfLqbj9I30DneAa
         QNZVn9Qk4YP3vMWZIgEFaMVS4waaK7g8EuGcWGhxq9GAXA5KPobvHbA7cGRRoyAKdw8K
         A0jx0DXatfqhUvOxYc5Upk6DqnfQSQe3hajbTDKiuQ0ShssM949IXwcj9spC8FDYrd+v
         5u4qwnrluqI0u2hsV/y+9aLzFJLFyJYRqEpQ62pXjJ8DisVhef12zy+6d/8KeZzkMKjM
         MX4wNWq0CFO4dqFtkGbxSMjtFLhQymNjXfhigNBYd7G2CW3Wuu36Dc7Kh7BFhFfECumm
         bT8w==
X-Gm-Message-State: AOAM532URgENTjPa7Kz+bIrjgF6ilpvWYsvMfFvAu/lzumf2QbNhl2q2
        /Q+lFFxqoMosVncJKaNN6qa2fEwVYvJp31FmuNJZefRQ
X-Google-Smtp-Source: ABdhPJxbwu0WaxgmmJkNfV2MXFsBl6LX8CeH1nY7Pxt/m86KUrcYR467xXwai67FBz7IRCgn4pC6irxxZX7JtE2cJ0c=
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr19878764ejb.11.1608648230965;
 Tue, 22 Dec 2020 06:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com> <20201222000926.1054993-2-jonathan.lemon@gmail.com>
In-Reply-To: <20201222000926.1054993-2-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 09:43:15 -0500
Message-ID: <CAF=yD-+i9o0_+2emOVkBw2JS5JyD+17zw-tJFdHiRyfHOz5LPQ@mail.gmail.com>
Subject: Re: [PATCH 01/12 v2 RFC] net: group skb_shinfo zerocopy related bits together.
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> In preparation for expanded zerocopy (TX and RX), move
> the ZC related bits out of tx_flags into their own flag
> word.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

I think it's better to expand tx_flags to a u16 and add the two new
flags that you need.

That allows the additional 7 bits to be used for arbitrary flags, not
stranding 8 bits exactly only for zerocopy features.

Moving around a few u8's in the same cacheline won't be a problem.

I also prefer not to rename flags that some of us are familiar with,
if it's not needed.
