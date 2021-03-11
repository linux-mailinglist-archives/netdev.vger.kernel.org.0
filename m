Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1894F3376DB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhCKPUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbhCKPUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:20:24 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C52C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:20:23 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id u198so18510776oia.4
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I72M+9lNWtnnGBdMVkurCXmrsZseOGzP4/ccH6MIsc8=;
        b=DSY6dKAk9Ri0X3genRyg3/7cuVsrOdcJSyvrArLQJShDY7iiPFxj352Ete5AvNO4tG
         EITgQ54JrSwW4VPCS9ydBwO3mVuVayuby1+aihNov97l7NEVbQCQKi/f+1aifKQexSUY
         4jCvRwd2cB7qgwQeqycIGssefM9xmymE16HKxldEaZbx99BmWf6/1iG3x+PSvcxzD+ix
         v85F3B+71+M8gHrNmJCXOh+vXmHblQc60qPkzeEfDf+UsQmvziQSuLenWpV9zEkm30Ao
         dUQe6/nMJGS6CbXroLh5zwfgf6Yg52Es4nDqx6I0R15+mRkfv+yMt7gK34ODSt4f56nG
         fhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I72M+9lNWtnnGBdMVkurCXmrsZseOGzP4/ccH6MIsc8=;
        b=UtUw8uk41zwa+Oh+O2kcilvVOQQ3neWSFuLpmiAHkmbXhRyvoStenpRd797/xpAMHJ
         cAWW4W/UVnyfr+3+R+KNunGIyLSHx4l4rTYFAErMeHUEwIUOw0bdAtke8zLYPs0aKwNt
         XfKIcKO06ofBfYWktAin76kxUptzzw+T9WgOpK6p/ZPpkpIcV7YDuX53HGwUrbQneiVy
         NIs2UdRocecbkCA+7dE+DRY+r7PGzBoK8AZ2YQpMpfP9r9fGMD0AL3uLdd1XQq8R6MUg
         3hmyvShK/GxCdNimhSFfiiOhwAxhlzoZzU8SMEreu8LUHxlSjrL/j83+zUKSvnupZNsR
         9frA==
X-Gm-Message-State: AOAM531BMP4z4QRlV/zYKL6WT3NwR1GhThPu6Vfk6TM/Me4/2PCvZk5+
        b/c8ZRgUTywlSv/UWsL6hTQYqFTmAzU=
X-Google-Smtp-Source: ABdhPJx4WkoXhjSmpZzF7aZtP9dFrnB1UnimyysG345B624eRPKZ1GC6xb4kxCSUkl3asoLfCsNOFQ==
X-Received: by 2002:aca:fd58:: with SMTP id b85mr1078274oii.52.1615476023441;
        Thu, 11 Mar 2021 07:20:23 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id v7sm688352otq.62.2021.03.11.07.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:20:22 -0800 (PST)
Subject: Re: [PATCH net-next 01/14] nexthop: Pass nh_config to
 replace_nexthop()
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <0a2e419897d7081c273762b58433c8c359ccd98a.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d7712489-cd96-0bca-de2d-d75dd2bf1671@gmail.com>
Date:   Thu, 11 Mar 2021 08:20:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <0a2e419897d7081c273762b58433c8c359ccd98a.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> Currently, replace assumes that the new group that is given is a
> fully-formed object. But mpath groups really only have one attribute, and
> that is the constituent next hop configuration. This may not be universally
> true. From the usability perspective, it is desirable to allow the replace
> operation to adjust just the constituent next hop configuration and leave
> the group attributes as such intact.
> 
> But the object that keeps track of whether an attribute was or was not
> given is the nh_config object, not the next hop or next-hop group. To allow
> (selective) attribute updates during NH group replacement, propagate `cfg'
> to replace_nexthop() and further to replace_nexthop_grp().
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
