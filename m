Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7605261CCF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732114AbgIHT0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbgIHQAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:00:04 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E290C0068FA
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:02:35 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w8so15690363ilj.8
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LfTXIdItMSqKxZtrDwVu/wtSc1NVGVSR9MloeRpjmqY=;
        b=LdL/DpkOuQjENDMmfpMEdTvVOtX0YCkrKBpF+s4VYTukAhq+hKaDkVaJbKJfBfdLog
         FAZtHLuEZkEXS74mBfYXaUbDWg1lzQCPsBbEcQpRUbzo7MNoK06bu2UUm0gBV/opdkXU
         UhZ44FfyfTiR3j4y7q/o2CdimiV2j0R4ZrN8KH+TyOEuJXHyGptj6pHm7jwnADWnb9s6
         umGCVYrN0rL2aPFhfWU3sjlbeP2bzL1a2NORyPIPC6GHdmBYQ73N7Wx3JGaKzZanmtZk
         RtSOgSY+M5JMPe+AAEIJkj8JsERvQdX/8tsRO8gdEFZtBXolnJtsAdTU5thtCShOSiu9
         nSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LfTXIdItMSqKxZtrDwVu/wtSc1NVGVSR9MloeRpjmqY=;
        b=ePnW3zL2Dohy6CRIaF7d2+2uCLr80nnSH3DZCb8qbsZX+uhj87YIcNB9al5VrfIUTg
         KZuAZlZRTcaChmHp89JDOV8/YJh/Mq1niHQynB5DgYBLYJSTt56xfwnFQ6LTzwWgVfPI
         9FWCuJJ6eHLyXRQUBN/CaPt3zfezDG9Qex6yVKMDIQdwGehOOZwvAv7Q1YMOKCsiBV2x
         E9rZbTDS2AgvNaDVPckaOfdLujq4/+zYSC7q9yTdHc9ZOXJtlKcU8mXgdgtuSl1y42D8
         xbmB06o7LP9mrc4jIr4Qe3Ciwr9gPLRivJTAnljWb7b7qRl7NY/A3Q7QV6moKFu6poDO
         R9kw==
X-Gm-Message-State: AOAM530y+5jq4QaJC7r7bQ/C4q9jVTzbyzlmXk4BV6mlbCPEIz1nv+4A
        w0mmF+2uBWyFdX1ykPb8XbA=
X-Google-Smtp-Source: ABdhPJwomKuL/KxMmhZZreFcWHK69KXcE/EpLbin9QnSYfL97kz9IfQl4YgqtTpQVbIHCi1642bdDg==
X-Received: by 2002:a92:7b10:: with SMTP id w16mr21656222ilc.92.1599577354920;
        Tue, 08 Sep 2020 08:02:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id k14sm8685655ioa.7.2020.09.08.08.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:02:34 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 09/22] rtnetlink: Add RTNH_F_TRAP flag
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-10-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c7159988-c052-0a5c-8b6b-670fd16be1ac@gmail.com>
Date:   Tue, 8 Sep 2020 09:02:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-10-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The flag indicates to user space that the nexthop is not programmed to
> forward packets in hardware, but rather to trap them.

please elaborate in the commit message on what 'trap' is doing. I most
likely will forget a few years from now.

> 
> The flag will be used in subsequent patches by netdevsim to test nexthop
> objects programming to device drivers and in the future by mlxsw as
> well.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/uapi/linux/rtnetlink.h | 6 ++++--
>  net/ipv4/fib_semantics.c       | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
