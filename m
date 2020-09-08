Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA9F2613AE
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 17:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgIHPla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730647AbgIHPh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:37:56 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C36C0619C9
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:29:55 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b6so17483312iof.6
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=en0B4WvoUIA+ZQ6WyLNig7f0AHUGiPEiq9PV+9znCF4=;
        b=er3w4qWZWx29E/RYAXqzDgKr2vbu31qwNHcDpKEuYTrGyPr/mSL4nQQnZJ1fND2bgv
         DXh8PVVL1LjSQB2i+SKlEEavv8Lklz5vehXj0gwmhFA2F7Jz99le5JFELF/+bX2H2l23
         Zllylss08uTg2XBULWj0hHDjUzPx+XT9beiITMk0IyIKjU+aSo+szZvG4wU81g5//taB
         Tle7eNbP3Yh5sPmwiEu174pAR+3hzwienmijry3e3U/FjdX0esqKOfJE7dzF0oDRGVHa
         6kgvuqhwhhkvzNDOSPR5bqla5MNJmxO4pRtV10cYnlzVIeKG3N8K/VPGdl7rIcYqHU9m
         qmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=en0B4WvoUIA+ZQ6WyLNig7f0AHUGiPEiq9PV+9znCF4=;
        b=J08aOAA7nroxhg8exbRHEW3toZBI1gt6aBmUNMmHCsTZXt8jntPnFo4kc/o47v1HE0
         GteJ4WA6HJglK1EXMFkk87pRd1ZJFdk+Yl/ULkM/sUWBthXocTY1cX6x4o3vH04WDcgq
         1F4ib12X1eWdE0SQv53wkJL9DmvHCSoworjYryzb2kvC6Hlm2aa0p9imh5ZQX117639W
         b1gtsvn9CIMcpFzwdEYPwXAkO1gWmg4XuR+YDGov5uYSUUBw1tKyIuhR1lMnSJD5y8Ux
         iLhVyVLDhLpPZfQZfc3S90j46VLLrj3t/5xsIiTsiMXKbWXe5RqmAyBFIuAcCtWd5/0H
         o99g==
X-Gm-Message-State: AOAM530yhnYotfta9eioY+VJ+On0W8F24lMb0E8uBnwZ17onCYcVgUts
        8qDg7Y3gk8H2NEDBaMImUOU=
X-Google-Smtp-Source: ABdhPJyeVqvHQDiNuwJefnRpUwNeAsz5vHFwgiTvF3FYEdy5gCjHhRY4JRbqk5x+oeeiVrXAocrgRQ==
X-Received: by 2002:a5e:a705:: with SMTP id b5mr9388166iod.73.1599578994432;
        Tue, 08 Sep 2020 08:29:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id p2sm4251916ili.75.2020.09.08.08.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:29:53 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 14/22] nexthop: Emit a notification when a
 nexthop group is modified
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-15-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <40a90c91-de9f-4512-329b-f91ac1bfe235@gmail.com>
Date:   Tue, 8 Sep 2020 09:29:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-15-idosch@idosch.org>
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
> When a single nexthop is replaced, the configuration of all the groups
> using the nexthop is effectively modified. In this case, emit a
> notification in the nexthop notification chain for each modified group
> so that listeners would not need to keep track of which nexthops are
> member in which groups.
> 
> The notification can only be emitted after the new configuration (i.e.,
> 'struct nh_info') is pointed at by the old shell (i.e., 'struct
> nexthop'). Before that the configuration of the nexthop groups is still
> the same as before the replacement.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


