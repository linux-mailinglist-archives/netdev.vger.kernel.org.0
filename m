Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25693481455
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 16:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240482AbhL2PJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 10:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbhL2PJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 10:09:19 -0500
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F89C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 07:09:18 -0800 (PST)
Received: by mail-ua1-x930.google.com with SMTP id j11so880545uaq.6
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 07:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T059ASJ4RtNlK+2+zqkQwGDitt3VLEMv58+0Dyd15tw=;
        b=k/sZSVfO2n1ewqdP+M5u1L3MSFLlvIBg5huso4GeRPgYVk/13h3TBvjAIbky4yh7oE
         jywLqi03y5KEO7QCuYfxLH/b70MVzikaIJ8Do4kw6+RYOgK9QZDAFUCGU9Rfkwc/xHpa
         GHHyjbXswHSkIwHOrDwRgSmEa3V1pPuWcRNARraptp4toJFYWNRrGW9POPNArwXKyOGY
         vMO2ent+W69IwXGQQleUsR6CSfpQh35jE4dQ8hMyM4trJzg4ToOsZKWB9iXXUZJYDhqt
         EBPVGpG+ME9qSWV4NTJlB9uoTeaqbclEGC1mAX7GRZkx4wUny7+tjf4r/ChBf8fzRPXL
         N6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T059ASJ4RtNlK+2+zqkQwGDitt3VLEMv58+0Dyd15tw=;
        b=3VZOAJKk5HThOgXBkW6qFliUeUw3NdnGmGeAJdqC4LUN4bSAukwLLeIM6xjIzpS/1U
         /CPMb52vhCIf3Ne7yRi0fwZ/8Xe9Gwr7J0D8NdlxIDw0P9cqvP1JiVMkXVHJK5zFnnjB
         32LQM8R+UGOZevX7ErdE0ugos8Vt3nrcZ14/PcO2ve/egpL13nZlsMA1UqxEC8Uztt0+
         qBI5b6GxURTe/SP2ZOppnJvd+YQLVZsT4pNaoTZCWsTMIIidnhyb5bYGtCWP0KA4NdbZ
         p3jP5ABqZiBo0/uc6b2D+pQeARMiSbPahbYMgbLSMSGfgGnlIuzR1Od1Bl+dByOomYWX
         KYuA==
X-Gm-Message-State: AOAM532xA2cidj6j5XLImmCc1N0y+THgJdPG/RKCJ3pSjWsM93MoU3yZ
        9nRoMUbmTcb8UeP6KB8/GBlQ0DOjAKY=
X-Google-Smtp-Source: ABdhPJxr5ijPC5LKhW7+abxs8ZfnUneAr+2BNAxMF3m9YH3AJMukLE9bpzfeRrwLPI4AvilVvCTFOw==
X-Received: by 2002:a9f:31c4:: with SMTP id w4mr8121206uad.24.1640790557859;
        Wed, 29 Dec 2021 07:09:17 -0800 (PST)
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com. [209.85.221.182])
        by smtp.gmail.com with ESMTPSA id 204sm4263020vkb.43.2021.12.29.07.09.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Dec 2021 07:09:17 -0800 (PST)
Received: by mail-vk1-f182.google.com with SMTP id u1so11948055vkn.10
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 07:09:17 -0800 (PST)
X-Received: by 2002:a05:6122:2086:: with SMTP id i6mr8428405vkd.2.1640790556954;
 Wed, 29 Dec 2021 07:09:16 -0800 (PST)
MIME-Version: 1.0
References: <CAJ-ks9kd6wWi1S8GSCf1f=vJER=_35BGZzLnXwz36xDQPacyRw@mail.gmail.com>
 <CAJ-ks9=41PuzGkXmi0-aZPEWicWJ5s2gW2zL+jSHuDjaJ5Lhsg@mail.gmail.com> <20211228155433.3b1c71e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211228155433.3b1c71e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 29 Dec 2021 10:08:40 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeDTJxbPvN6hkXFMaBspVHwL+crOxzC2ukWRzxvKma9bA@mail.gmail.com>
Message-ID: <CA+FuTSeDTJxbPvN6hkXFMaBspVHwL+crOxzC2ukWRzxvKma9bA@mail.gmail.com>
Subject: Re: [PATCH] net: check passed optlen before reading
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tamir Duberstein <tamird@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 6:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 28 Dec 2021 16:02:29 -0500 Tamir Duberstein wrote:
> > Errant brace in the earlier version.
> >
> > From 8586be4d72c6c583b1085d2239076987e1b7c43a Mon Sep 17 00:00:00 2001
> > From: Tamir Duberstein <tamird@gmail.com>
> > Date: Tue, 28 Dec 2021 15:09:11 -0500
> > Subject: [PATCH v2] net: check passed optlen before reading
> >
> > Add a check that the user-provided option is at least as long as the
> > number of bytes we intend to read. Before this patch we would blindly
> > read sizeof(int) bytes even in cases where the user passed
> > optlen<sizeof(int), which would potentially read garbage or fault.
> >
> > Discovered by new tests in https://github.com/google/gvisor/pull/6957 .
> >
> > Signed-off-by: Tamir Duberstein <tamird@gmail.com>
>
> Your patches are corrupted by your email client.
>
> Can you try sending the latest version with git send-email?

Then perhaps also update the subject line to make it more clear where
this applies: "ipv6: raw: check passed optlen before reading".
