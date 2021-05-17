Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0929383906
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343582AbhEQQGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244658AbhEQQCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:02:08 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE33C0467C6;
        Mon, 17 May 2021 07:45:24 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id d21so6654049oic.11;
        Mon, 17 May 2021 07:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dQh3WD+V36DcjC0tRHnk3vjCMvP62JeajHSbxzekmLY=;
        b=Chnd4Pj2Y8RyVvXPj6M832q/iB/no7+e0YmAxsL/N1cgnjquNf37lXctJQh0LpTK4i
         S/fL/IIDIZ/vHpz/h7BZX7i5D6j/mipF3o9G/Zm1huxLajcP0lC3cEesQhzKcx5latte
         ksudygWrQksl2LzfpcmkSFlDBUGw0pJEpVmvs9fGPAJSlV7ife2arQdoXchX+9BgekG8
         fmbt1i8U0+nGpAEhrjsL7xNqXZB11aXEpRaZStKTG1E5wl89N9Pn9dtYFp20KP/pIKUN
         w2i0KliAKI7RZelYlQIlUAua6B7+dLj+yXTa9wQJ9pzcfaa5GmvqcKKysxMcsItXSDvb
         ZpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dQh3WD+V36DcjC0tRHnk3vjCMvP62JeajHSbxzekmLY=;
        b=t4BNKK95ocgjWONwp0LTP7jLyrRbb+Fhc+CkLNKlQsUeY4/hBaIuARjLdu2t6oyHk0
         cDYrHJhLKRoJJRYJh5m9yIZ7VDtdM6cK1IRQg6cXZdxQIXnfO0GXoldXymUW1IGIXXRG
         53q3TGRGb4qtcTCur/7Lb8v5x8XbFdm1AINH01c9Mu7NO23OMHMiiXQlX4Sa+euqRP61
         d3JCCyCxUrAaV29hOQCBrqD1VNy7csfwxF5wxiF/oGAJhUSJYpThVrtS+PBJOHvsOuxh
         oTkv+GiWztMg83svClOwxSiiJXeXiN+rqlqneQvh/+U9DwfZKuov1VUl9sCX6LqVE/XI
         31bw==
X-Gm-Message-State: AOAM533d53bC4+1osFrjTs5BoY1W3xGASWK3IoyF1W/YNsCAQpR1a4Pb
        mMsOACv3GcRq9BSV6dhY2ks=
X-Google-Smtp-Source: ABdhPJzXc1gbOm6DJ88PuSwBm6xawJcoOfwrpG+2Rpg+8grxci8Ca6BrK7Kn4BISGvZXBPkZrfs2QQ==
X-Received: by 2002:aca:3684:: with SMTP id d126mr90498oia.129.1621262723613;
        Mon, 17 May 2021 07:45:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id o15sm3096753ota.61.2021.05.17.07.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 07:45:23 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     Heiko Thiery <heiko.thiery@gmail.com>, netdev@vger.kernel.org
Cc:     petr.vorel@gmail.com, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, Dmitry Yakunin <zeil@yandex-team.ru>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fcd869bc-50c8-8e31-73d4-3eb4034ff116@gmail.com>
Date:   Mon, 17 May 2021 08:45:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508064925.8045-1-heiko.thiery@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/21 12:49 AM, Heiko Thiery wrote:
> With commit d5e6ee0dac64 the usage of functions name_to_handle_at() and
> open_by_handle_at() are introduced. But these function are not available
> e.g. in uclibc-ng < 1.0.35. To have a backward compatibility check for the
> availability in the configure script and in case of absence do a direct
> syscall.
> 
> Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
> Cc: Dmitry Yakunin <zeil@yandex-team.ru>
> Cc: Petr Vorel <petr.vorel@gmail.com>
> Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> ---
> v3:
>  - use correct syscall number (thanks to Petr Vorel)
>  - add #include <sys/syscall.h> (thanks to Petr Vorel)
>  - remove bogus parameters (thanks to Petr Vorel)
>  - fix #ifdef (thanks to Petr Vorel)
>  - added Fixes tag (thanks to David Ahern)
>  - build test with buildroot 2020.08.3 using uclibc 1.0.34
> 
> v2:
>  - small correction to subject
>  - removed IP_CONFIG_HANDLE_AT:=y option since it is not required
>  - fix indentation in check function
>  - removed empty lines (thanks to Petr Vorel)
>  - add #define _GNU_SOURCE in check (thanks to Petr Vorel)
>  - check only for name_to_handle_at (thanks to Petr Vorel)
> 
>  configure | 28 ++++++++++++++++++++++++++++
>  lib/fs.c  | 25 +++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 

applied to iproute2-next.

