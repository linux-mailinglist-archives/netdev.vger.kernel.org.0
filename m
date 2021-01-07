Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB22ED433
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbhAGQXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbhAGQXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 11:23:20 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3269DC0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 08:22:40 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id o5so1682644oop.12
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 08:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sNVVrVXrtO2MQP5ZEKIiSupLTnpxlY7IKNXcGHdIm1g=;
        b=UwnLH440mLaPzlvCDUsyzndRp0vBqsvdpCo/DmbsMA9WBf3t42WlcBaeX4oUVedYo7
         6ZWl/DQ8lgwvY4+y9otOb3A9F8X/61+Eh5MxNumi/Ophv7B0xr7BFQ1jykb+xtbk/wZM
         h5cqS6z6fckXZOfHUeqPxqB5bfozmj9stPsm09/tKY8EXekoCNUuaQO0zoRA7I1ZQnqT
         pLjoK/6W24l/x3zuB04xzDzQUuRx/GkNr9oD9dC8R6OM4k+JcuJXDPmpnlJmFiH3orA7
         pOXr2Ly+IwZv14hnldxHJsqy0QlvL0ydZQLbXD/jLqwEhziLCwJ3GY/0GaiarvbbcmGW
         r1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sNVVrVXrtO2MQP5ZEKIiSupLTnpxlY7IKNXcGHdIm1g=;
        b=VGy0J3Ax4m2CbvyNu+PzbPfCL/MBJd5z/rP4DOl1Kas/hSY1skP+rS7h+H20n0rUGD
         UOKhvngDxJOd+SFHcPcKkoPQCyDrF5hRh0JPMUsuP8qtWag+HVO3Iwwpg4K8owfUkWhC
         N27qmhCqvBWtbIONVBXCrAIefpQ8eqjNl4lrBjPeeYamiFj3TTsf766uRjlHmTpNN2mP
         z1QvteoewscMq/j25Dao+FxT6WkY3o8z1LrN2ITbykmWMCIupoT5PuWpY6lyWCjX4fDE
         PHixbFdXNlbdggALltE2kkRlJ3OsR31BHSRSCo1xvG/2d112F4rfA/FcCkf0xF4d+o/k
         IVpw==
X-Gm-Message-State: AOAM532bI+eVhfNtETE6GxCKEiv5Rii/xiOuzXgbuJJ3kNCzgzQIzCHK
        atdnajN7WqV0zAOniGOoHwhuPPM02k0=
X-Google-Smtp-Source: ABdhPJy+VFjonfgReKI8fvLmjjH6yrtfCEg17XmRJaB8Ynw04OmUc+ZSF/F7mWhLA7RigCgldG9KgA==
X-Received: by 2002:a4a:e718:: with SMTP id y24mr1593852oou.91.1610036559682;
        Thu, 07 Jan 2021 08:22:39 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:800d:24b4:c97:e28d])
        by smtp.googlemail.com with ESMTPSA id s26sm1195419otd.8.2021.01.07.08.22.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 08:22:39 -0800 (PST)
Subject: Re: [PATCH net 3/4] nexthop: Bounce NHA_GATEWAY in FDB nexthop groups
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210107144824.1135691-1-idosch@idosch.org>
 <20210107144824.1135691-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <73b04764-6243-f3c9-5075-72bf5c964dca@gmail.com>
Date:   Thu, 7 Jan 2021 09:22:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107144824.1135691-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 7:48 AM, Ido Schimmel wrote:
> From: Petr Machata <petrm@nvidia.com>
> 
> The function nh_check_attr_group() is called to validate nexthop groups.
> The intention of that code seems to have been to bounce all attributes
> above NHA_GROUP_TYPE except for NHA_FDB. However instead it bounces all
> these attributes except when NHA_FDB attribute is present--then it accepts
> them.
> 
> NHA_FDB validation that takes place before, in rtm_to_nh_config(), already
> bounces NHA_OIF, NHA_BLACKHOLE, NHA_ENCAP and NHA_ENCAP_TYPE. Yet further
> back, NHA_GROUPS and NHA_MASTER are bounced unconditionally.
> 
> But that still leaves NHA_GATEWAY as an attribute that would be accepted in
> FDB nexthop groups (with no meaning), so long as it keeps the address
> family as unspecified:
> 
>  # ip nexthop add id 1 fdb via 127.0.0.1
>  # ip nexthop add id 10 fdb via default group 1
> 
> The nexthop code is still relatively new and likely not used very broadly,
> and the FDB bits are newer still. Even though there is a reproducer out
> there, it relies on an improbable gateway arguments "via default", "via
> all" or "via any". Given all this, I believe it is OK to reformulate the
> condition to do the right thing and bounce NHA_GATEWAY.
> 
> Fixes: 38428d68719c ("nexthop: support for fdb ecmp nexthops")
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


