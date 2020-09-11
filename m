Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485C126629A
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgIKPy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgIKPyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:54:06 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EC6C061756
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 08:54:06 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b17so9444147ilh.4
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 08:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7FID5GSCfROt20gZh6958Sr6fTGQul8Xvu3FtbdINNA=;
        b=FwowIc5lQy2ao0cRmOQftG0M72VLMbiUGuO9g3U6b86v7ARJe/SB1NtfCJSo+G9dxV
         Dt1Xhlqj2zhHb3VhfSWcu6dFJ7Vn611OcNUoMgRmPqFEzTjnLLoGHduFpNKx6sGhsJOA
         sasTlHRw3ZFVFpeDi7wlUYVn4AhPvZCdYwAnut+JkwwTRJoVeHx2g+jvD3OuKWleuKUO
         pb8xeqHf+1qor840tk0qFi29NYKJymP5hHZspXj8EHFep9bjMrfWFc6x864VnVG05G8b
         J4xJVvytz73cP8fKH2sOjgZW0x4YmD8eHpAJ4Utq5kzxlWFcMZa2mgi2TI5S++SoJ0GH
         sRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7FID5GSCfROt20gZh6958Sr6fTGQul8Xvu3FtbdINNA=;
        b=ZL+ilHtdvzme9tQnK/qT7X+2jMSfYtRaRtoJlNtOXKod4tvnrCy44prJcgGM7GQ5LD
         HPtrVKF15c272lktewG4IhunhJeOOgAQeJqG6Eek4I8QwKGe0C43wI9ht77EiSa+1NAU
         97xTfxRV57coVAi3Yj89mNw7V9IUUC4CK6It0tMCMTZ7ZIPXuuKoouEmjFiHoGgoDYlj
         t4MA7rrcLuUB93cAhaGYAUduSYl8H0RCanUKjyYO2y9Ps6/oB1Wgx2Hvr1pUvEaIv2JV
         ZDax+u0gvUtPJ7xe9IeRRYjqiApTFQ/v9/qlLZ//6zP5oUCN+b+b/fTAaO6JLgBlh/yH
         3lBA==
X-Gm-Message-State: AOAM531d2Tbc38J/tenlD5mKrToV9mX0mZPsHvVp7l7opBC85Y6GnKDV
        CTfhcEgB5LYBZIBjfJejGGo=
X-Google-Smtp-Source: ABdhPJzzJOjicMjqGEu4t8DCPH5QUK+kexE3KExXhVwF76Ncg2dGQWFdGdBjKz32Kzu9AyVsxjbnqw==
X-Received: by 2002:a92:9145:: with SMTP id t66mr2238642ild.305.1599839645754;
        Fri, 11 Sep 2020 08:54:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e8e2:f0c7:a280:c32c])
        by smtp.googlemail.com with ESMTPSA id i10sm1275627ioi.39.2020.09.11.08.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:54:05 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 09/22] rtnetlink: Add RTNH_F_TRAP flag
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-10-idosch@idosch.org>
 <c7159988-c052-0a5c-8b6b-670fd16be1ac@gmail.com>
 <20200911152601.GE3160975@shredder>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5a371baa-f16f-16c6-e0f2-da2307e578ce@gmail.com>
Date:   Fri, 11 Sep 2020 09:54:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200911152601.GE3160975@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/20 9:26 AM, Ido Schimmel wrote:
> Reworded to:
> 
> "
> rtnetlink: Add RTNH_F_TRAP flag
> 
> The flag indicates to user space that the nexthop is not programmed to
> forward packets in hardware, but rather to trap them to the CPU. This is
> needed, for example, when the MAC of the nexthop neighbour is not
> resolved and packets should reach the CPU to trigger neighbour
> resolution.
> 
> The flag will be used in subsequent patches by netdevsim to test nexthop
> objects programming to device drivers and in the future by mlxsw as
> well.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> "

works for me. thanks
