Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBF531B4FB
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 06:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhBOFNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 00:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhBOFNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 00:13:49 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6217C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 21:13:08 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id y199so6621029oia.4
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 21:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=z2Fm5qZDenpmaBPKtIp7d2kK0vTE9jkxh+D5qzOg0jk=;
        b=f8lOMgwK5AFFjc4OfRTOGqqBCnR1wXwFvkh5BUWv4sGBdw3WRlAyO/ZIuZpwtB+NEv
         Biw0pZhv29eOup/+xXyAB4k5VQXp4fv4vtjM1nHxkiyNPehV4s2e4ZZQueWTswliaF5c
         Z+Em7pJpJEBmxUdo3buw4ChDpcCNoN/CHju2VrNmEHc6409+hXP2bzO3vkL/MZ1jqWKp
         6dE2jFh2MeXiwxOdsmXMTNbdnN9/5UqXE4cEAqV5LAB6AUWO6IdFUobi1c/HYKvpJkPk
         1S+PWlRgZaE+YZkIc2rMhgF2YpHb60rrP7pR8BRzC8jxIM1Lbr2gzTxlwm1VNuvyPKpu
         weYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z2Fm5qZDenpmaBPKtIp7d2kK0vTE9jkxh+D5qzOg0jk=;
        b=mR3iZ1j9N3IIHXtxJIC5IFbA/4hQG6KCaoctKKix66MZgsWnJgu9wmLOHJbLHYmC8v
         zt2+N7zx1mTSaS1yd+P4qxMJ1CCrdzawzCATdBOHCYkroF78gIH52Uksy8oST7596cPA
         RkiELa32PkmO2/IER7K387tLUOILvI4BXWYruXuFk7MbWs8hNIjNHRUUoGVdXq0A0xSv
         xQFjqLOLglKve3zuW01MCvYEaWXZut5hKhxwAwbwnt5BfClsqqBQ+YnU3mHhZR16ok93
         sILsbYvl8obFu34oiceL+wqNqG55BGEIjJDW0HGLgN5z33WPlHAC0mkjngJwWzTHw89m
         SxZg==
X-Gm-Message-State: AOAM531csWwwLvhg6mBOoMrKWexmCanIpiaMXubtaLlktmXQ48ZmMful
        Jfo8liVfNcX9D5it/JwL37MFqD5aOMY=
X-Google-Smtp-Source: ABdhPJyiaa92W+uUdfCJHP980oIdgADtXQgJeTlZSUkTiXzeLzrG7j7jDc5ALg4wqEK2i7gkXanUVg==
X-Received: by 2002:a54:408f:: with SMTP id i15mr7360894oii.63.1613365988026;
        Sun, 14 Feb 2021 21:13:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:a8bf:c38c:3036:ff38])
        by smtp.googlemail.com with ESMTPSA id o98sm3472603ota.0.2021.02.14.21.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 21:13:07 -0800 (PST)
Subject: Re: [PATCH] ss: Make leading ":" always optional for sport and dport
To:     Thayne McCombs <astrothayne@gmail.com>, netdev@vger.kernel.org
References: <0e45b850-6c2a-4089-1369-151987983552@gmail.com>
 <20210214080913.8651-1-astrothayne@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2e20fe26-baac-b1cf-e7b2-05dd6f26af27@gmail.com>
Date:   Sun, 14 Feb 2021 22:13:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210214080913.8651-1-astrothayne@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/21 1:09 AM, Thayne McCombs wrote:
> Doh! Sorry about that, here it is with the sign-off.
> 
> -- >8 --

Don't put text here.

> 
> The sport and dport conditions in expressions were inconsistent on
> whether there should be a ":" at the beginning of the port when only a
> port was provided depending on the family. The link and netlink
> families required a ":" to work. The vsock family required the ":"
> to be absent. The inet and inet6 families work with or without a leading
> ":".
> 
> This makes the leading ":" optional in all cases, so if sport or dport
> are used, then it works with a leading ":" or without one, as inet and
> inet6 did.
> 
> Signed-off-by: Thayne McCombs <astrothayne@gmail.com>
> ---

put extra comments here

>  misc/ss.c | 46 ++++++++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 22 deletions(-)
> 

Also, put iproute2-next in the subject line along with a version number.

applied to iproute2-next.

