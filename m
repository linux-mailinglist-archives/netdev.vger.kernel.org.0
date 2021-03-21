Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EF33433A7
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhCURSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhCURSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:18:33 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3AEC061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 10:18:33 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id t23-20020a0568301e37b02901b65ab30024so13648686otr.4
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 10:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WjH1yju6K5XFWvbpIKfPPWrWNFJmx5XV9KI0N6Ox1JY=;
        b=HHozkaQtpwDKWmPalOTOLq/LnmE5lMbCagYXFDsvlxjTyVa4jJWNIvtKagOPU43lQw
         t7m+prOI8XLpgUzjQ0C8u9DjbLKARe9ym2FEXiktVmnXA8dvS/KJcSM9FBAWDDiDGABt
         pPPig9Ee/YUx8Mr3/76aaibtWG+TvMjMhY621UORfix7MjY5J0fNfN2Tozl2nwtevT6C
         Egplt9OVBB+eR7dufrm4x504SwxFp799wugclm+gI/DkVbGp5mhZT+guExzgp57wqYVR
         E/lf3HmUhNtiwSVaQgsBYMozRGKGeoD1EbmGH0XauZhYxssCI54h+P3bCCS1hm6KePG0
         YfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WjH1yju6K5XFWvbpIKfPPWrWNFJmx5XV9KI0N6Ox1JY=;
        b=PeEnOYPCREFplBmPpwVHxfT+BaoQsNyj12/cGaD9nu4lr8eDaUtCwGyAzX3t0F8qhE
         Z1saF3K7cDizxqNoRRZNxXDlwiYhO6WK9Mk6eshYJp/CPBRHD/a6riPrtCicvyw3yOsh
         ZzFz2oA1XpBl/OsYFx57DKJCMlV4lpEU0wHLbc2MqFgIguhNGLvJP+P0CXjkcC0c5vho
         avjixMcsepXsXWqvUq27wuI+ucxCzUMy9CxIPWvexMyLrPVG09lYci2a3G3sab2hkkch
         QuglZsAu3l1bSf//HYGsvUvg0Lb5DA9AHocMsNJTGYyIKbOvw4u66Itr8QLDW+Ip1dI7
         wSmQ==
X-Gm-Message-State: AOAM533x+zRBlY9R5TWWAJepGt613/EkFAj72ppl1XdzcrTzT5sRcbdC
        FbqK+fXD0WtWuoQRBWQVkDQ/cdkuQ4Q=
X-Google-Smtp-Source: ABdhPJwAbSDdkhCL+FzZhWsO7c1lkQvnUjh57QLXp0AKAi2L/NpUH5aFal6WyjEGGFKBRl1l+iiGrw==
X-Received: by 2002:a05:6830:4c2:: with SMTP id s2mr8569322otd.338.1616347112630;
        Sun, 21 Mar 2021 10:18:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:15d7:4991:5c5e:8e9d])
        by smtp.googlemail.com with ESMTPSA id f197sm2753960oob.38.2021.03.21.10.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 10:18:32 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: xfrm: add support for tfcpad
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <1a3dcd1916cc4399c88315e19ab3c2d8948d28c1.1616170525.git.sd@queasysnail.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <59aba78f-bd0a-3f5b-057a-0eb56cf58867@gmail.com>
Date:   Sun, 21 Mar 2021 11:18:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1a3dcd1916cc4399c88315e19ab3c2d8948d28c1.1616170525.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 10:57 AM, Sabrina Dubroca wrote:
> This patch adds support for setting and displaying the Traffic Flow
> Confidentiality attribute for an XFRM state, which allows padding ESP
> packets to a specified length.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  ip/ipxfrm.c        |  8 ++++++++
>  ip/xfrm_state.c    | 10 +++++++++-
>  man/man8/ip-xfrm.8 |  2 ++
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks,

