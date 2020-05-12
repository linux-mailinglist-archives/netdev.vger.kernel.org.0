Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E784C1D0032
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbgELVKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726324AbgELVKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 17:10:20 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EEBC061A0E
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 14:10:18 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o10so12259252ejn.10
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 14:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CSpdh7Z7zMPtWlBdq88/5LdKyaeey1hMdM035dkEBxs=;
        b=V6uqoOFX6u2CvdHUUrupnk8+21Ued+g4DNiWbLRHdYnw2mPYGFa0LlYwZnjQ5yfRgZ
         UZNy0mo918STQefgWOKbLS0E4C74SKRT95qgXdfKBN/hYX2/Nzecm6BSbIcOGBW2Ru+y
         mIM/uO6R7sr0pcImYebX8/FQQSEAkMLlMakFrsajHRBl8kvMquq5aAUgIXXLzwO17teM
         2kooftAYyD89CGJIzuWl18J4j168p1dkHOV3oamVuCohv8X2upXNRxcFK9XpBJhPp/vq
         +s+7O5nkvCh/vIsWV2DRt29mgqQRG3EncagOPcNGG+ps6EdZsJ+UW8SnUiF4ulHfHv2D
         yiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CSpdh7Z7zMPtWlBdq88/5LdKyaeey1hMdM035dkEBxs=;
        b=FYsz8yEabuJ6nIuv9GjhhZlTU9CmVqhr7AqvkBIuX2XNI992xi5E5r9eciPAlZxPse
         3ylxlbH+xWlHHLn9xr2WhkCgYSlqPUgY0rxsA2Ioc9UQ9/vf5xji437YCaWkWsUvcqft
         L/W+BB7DZryzuSsJiuqzgnFVLJqZzO1j8sjHXRNHKDkpwur5nmRyOoFoi+REwHC/2Ven
         sZPF20DNd9FCCoe30ETj5Ps/arUjf/HoIyX9n3Hl+zI7ZJ/gY5NHSH1uwbJiR7rEO1Vm
         4G9MMLS+s9adoQygcFb7pmpHyMQ1DyRc/0+VVbqUEbWuwEQ0GiNZXmEWIH5izXfr62b5
         +j7A==
X-Gm-Message-State: AOAM531Xn3Sq9gd5WUaIrd231J05VrrLW2tUkgOxcImsbWnMsCFVidHA
        KKHMNMzcbPP6hspdyCfEYo/uh3rUQvGOgBEZKFsq
X-Google-Smtp-Source: ABdhPJz+HF0Y3QZDTXTT1RKvc6wFDQInr2HtM/6l1XFoAqWd56N9wJf0k+oVX+KBsVBP4gA/meeU9qtSiL+UJYblbf0=
X-Received: by 2002:a17:906:6841:: with SMTP id a1mr8378690ejs.271.1589317817246;
 Tue, 12 May 2020 14:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <07d99ae197bfdb2964931201db67b6cd0b38db5b.1589276729.git.pabeni@redhat.com>
In-Reply-To: <07d99ae197bfdb2964931201db67b6cd0b38db5b.1589276729.git.pabeni@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 12 May 2020 17:10:05 -0400
Message-ID: <CAHC9VhRK+k8zwCLCMRBmjPFCYuK=BEn4Gq4vhEngedMqhuPsDA@mail.gmail.com>
Subject: Re: [PATCH net] netlabel: cope with NULL catmap
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-security-module@vger.kernel.org, ppandit@redhat.com,
        Matthew Sheets <matthew.sheets@gd-ms.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 8:44 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> The cipso and calipso code can set the MLS_CAT attribute on
> successful parsing, even if the corresponding catmap has
> not been allocated, as per current configuration and external
> input.
>
> Later, selinux code tries to access the catmap if the MLS_CAT flag
> is present via netlbl_catmap_getlong(). That may cause null ptr
> dereference while processing incoming network traffic.
>
> Address the issue setting the MLS_CAT flag only if the catmap is
> really allocated. Additionally let netlbl_catmap_getlong() cope
> with NULL catmap.
>
> Reported-by: Matthew Sheets <matthew.sheets@gd-ms.com>
> Fixes: 4b8feff251da ("netlabel: fix the horribly broken catmap functions")
> Fixes: ceba1832b1b2 ("calipso: Set the calipso socket label to match the secattr.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv4/cipso_ipv4.c        | 6 ++++--
>  net/ipv6/calipso.c           | 3 ++-
>  net/netlabel/netlabel_kapi.c | 6 ++++++
>  3 files changed, 12 insertions(+), 3 deletions(-)

Seems reasonable to me, thanks Paolo.

Acked-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com
