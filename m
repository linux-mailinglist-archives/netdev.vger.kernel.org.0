Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DF2261F31
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732551AbgIHUAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730338AbgIHPf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:35:26 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA75C09B042
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:34:19 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id u20so6959620ilk.6
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IFqlOVCzad6prxZTH6CWB3yaKhYDN58Xi9XgI9XV2lg=;
        b=KstcaGfBTEW+eT7S9eSe7EOf+15DIc3aiRE9jYlg1sZmogYCWTnxq1IlesYLwT+3Ro
         x0tmOXC2J+rvRnVWGjTG+Z+oBhtmVjpuJbxnYXhochv3OEbweg8E7kMOQeF7wC/lkYZk
         Tqh6XH+1M6lsCkuAls+YrotOZbaWnPxNM9qJsJqQFj+FWr/LQk6NTqyiKisIwWRim7Bc
         Ktpufr4rMq9H7/ieCIvFSU4nqyIcvDE67pDNuaxL6Z/RDRV92RAbIh22Y/hrnabim4hV
         6kJKi6c7LGYKehsHLl4L/qZrqCT+tB+0Fez7NbCI4UmvHwrTDxZtv2TuRDiliUtN7vgF
         eWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IFqlOVCzad6prxZTH6CWB3yaKhYDN58Xi9XgI9XV2lg=;
        b=K88jOepyD6npvOsZ6YnYG2dV1z8OTyYZbZcYbvOmzhdGpzaCdBXpeUZgjiwLp24I5G
         zY6PX0W9xvn2chvw4uL5K1ILIK6iTHj3BkdxT9maxgjzg1P8loS6AcWTGXMBk6JUfgaw
         MdrrEtt+i3grunKQu72x4FDrsfSFTxiGEMezkl83J6mFgyOF7x4g99tR/qTaDbKXQzBR
         lAYJHuieF2NletD3izh3wLwEkxhqVauqMUAwb1Ma/LI4u0n7XXqoiAauAaWRl2aTG55g
         e84Y6R5Q5fISreH1vBKGxXcJGkSgF6BOyStb8Sh0HbidxYxZDG97QzcWDXWAW607Cec+
         HO1w==
X-Gm-Message-State: AOAM530TCHCqk/WUqg/c56cawawKuGfev30xITj6nklW2wHlUQOwzKlR
        inWcavgT8iBiQiIJgatXZuPz9S9LhLR9dg==
X-Google-Smtp-Source: ABdhPJwz4dzvRZdggVWyJMjQuIVHvNkR2HXksPJ80QfU7MjmbBm9ohg4IAcPWp6RuNA7wWAc1mjCmA==
X-Received: by 2002:a92:cac9:: with SMTP id m9mr7100811ilq.139.1599579258775;
        Tue, 08 Sep 2020 08:34:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id k2sm8646042ioj.2.2020.09.08.08.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:34:18 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 16/22] nexthop: Pass extack to
 register_nexthop_notifier()
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-17-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <91ca0d81-e046-8090-8c7f-fa022321573c@gmail.com>
Date:   Tue, 8 Sep 2020 09:34:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-17-idosch@idosch.org>
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
> This will be used by the next patch which extends the function to replay
> all the existing nexthops to the notifier block being registered.
> 
> Device drivers will be able to pass extack to the function since it is
> passed to them upon reload from devlink.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan.c   | 3 ++-
>  include/net/nexthop.h | 3 ++-
>  net/ipv4/nexthop.c    | 3 ++-
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


