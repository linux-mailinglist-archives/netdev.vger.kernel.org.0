Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2CD2CBA33
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbgLBKKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388330AbgLBKKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 05:10:06 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A2CC0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 02:09:25 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id z7so3018943wrn.3
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 02:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5bwtaOvtCSLyHCTCqmSwVa7XRaWT1NwajyhJl6tnuBg=;
        b=JOIBqtd87TqsJSp3xaw65ifrT/pN5eXfoql8t8PR7+0czuKUucpRHrh1TiVrVjd5ky
         RnAX08jxfLKUdYnLtXth3XDDt9+s7QlIpD8d5bWSRizpGMbpgW1UF1bFrUYHCSiIuFzD
         VXVulyOIhJm4i83UYHmlWy6wQlj10Js6ohHBuRIa4FmUp1KQGvSJHSo5bCJdiC/uXAUv
         3KD9f56JQA2cEnPUZhjonvIEf5K3GlavtjhAlxe6c4vdOGwQcMJhqHYJS38GOTBVRm2x
         nSC9eVMK6VbvuucscJKgvghozgxbJjwVuuk0j04TMWDR8eS8bYC91o6p1LhK5kS00sLB
         i3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5bwtaOvtCSLyHCTCqmSwVa7XRaWT1NwajyhJl6tnuBg=;
        b=n/uyLm7K0hWi0K4eg+yxe0AfvgyYHjyAF1moR80SLHPQpGXu/BCZitvhPIiBgGR8ME
         SlXV4kQ1iC0COS/H3O66U9QqZv55NrJ/zFcP4lH2F9q6Z6mU4gEESZRo0BVZMI1TM5cX
         Q1+f41U8wcs7SLQqyNxnm0ibVA/My2ieze52emZSjz/wuSKU2ZkFh4OgP004ThM99xUs
         v23HGqyreJbtd/4J/91DYMuf3cZHz9vxiLltSgINUTQGw7ChihtjLbx1KtLODBLwxIpe
         h4nFnV0U1HLZ7DZYOKSh3ZWaok4HzqKGaqJmqHePhM95TbYp6R/pFJipRZHX6/zg3UQE
         HXLw==
X-Gm-Message-State: AOAM530Eb7gOAmsVs4oAJC13jSDKsh2jzDQwsqFwyt8E2MctyMz43ZJj
        fDZECacGqW9NT9ebKLC4foudIA==
X-Google-Smtp-Source: ABdhPJx4ELv79IRASg+W+UqBkNppVU/OF/nCELXyZnKZQh5ej1Evaa7JngphBVWraDI0gCy3uBqNlQ==
X-Received: by 2002:adf:f8d2:: with SMTP id f18mr2362315wrq.379.1606903764632;
        Wed, 02 Dec 2020 02:09:24 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id u26sm1479633wmm.24.2020.12.02.02.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 02:09:24 -0800 (PST)
Date:   Wed, 2 Dec 2020 11:09:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201202100922.GM3055@nanopsycho.orion>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <CAKOOJTw1rRdS0+WRqeWY4Hc9gzwvPn7FGFdZuVd3hFYORcRz4g@mail.gmail.com>
 <20201123094026.GF3055@nanopsycho.orion>
 <CAKOOJTxEgR_E5YL2Y_wPUw_MFggLt8jbqyh5YOEKpH0=YHp7ug@mail.gmail.com>
 <20201130171428.GJ3055@nanopsycho.orion>
 <CAKOOJTw54DxitbYHW7vNVWRv9BbsdmW_ARTgpMu5HBVjkTeQ5w@mail.gmail.com>
 <20201201112250.GK3055@nanopsycho.orion>
 <CAKOOJTxS8Lssq_CxhorCk33Byj+mM-FQLp+zSiCZSQhJpTMQDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTxS8Lssq_CxhorCk33Byj+mM-FQLp+zSiCZSQhJpTMQDg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 02, 2020 at 01:32:46AM CET, edwin.peer@broadcom.com wrote:
>On Tue, Dec 1, 2020 at 3:22 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
>> >Consider a physical QSFP connector comprising 4 lanes. Today, if the
>> >speed is forced, we would achieve 100G speeds using all 4 lanes with
>> >NRZ encoding. If we configure the port for PAM4 encoding at the same
>> >speed, then we only require 2 of the available 4 lanes. The remaining 2
>> >lanes are wasted. If we only require 2 of the 4 lanes, why not split the
>> >port and request the same speed of one of the now split out ports? Now,
>> >this same speed is only achievable using PAM4 encoding (it is implied)
>> >and we have a spare, potentially usable, assuming an appropriate break-
>> >out cable, port instead of the 2 unused lanes.
>>
>> I don't see how this dynamic split port could work in real life to be
>> honest. The split is something admin needs to configure and can rely
>> that netdevice exists all the time and not comes and goes under
>> different circumstances. Multiple obvious reasons why.
>
>I'm not suggesting the port split be dynamic at all. I'm suggesting that if
>the admin wants or needs to force PAM4 on a port that would otherwise
>be able to achieve the given speed using more lanes with NRZ, then the
>admin should split the port, so that it has fewer lanes, in order to make
>that intent clear (or otherwise configure the port to have fewer lanes
>attached, if you really don't want to or can't create the additional split
>port).

Okay, I see your point now. The thing is, the port split/unsplit causes
a great distubance. Meaning, the netdevs all of the port
disappear/reappear. Now consider following example:

You have a router you have configured routes on many netdevs
On one of the netdevs (has routes on it), you for any reason
need to force lane number.
In your suggestion, the netdev disappears along with the routes, the
routing is then broken. I don't see how this could be acceptable.

We are talking here about netdev configuration, we have a tool for that,
that is ethtool. What you suggest is to take it to different level,
I don't believe it is correct/doable.


>
>Using this approach, the existing ethtool forced speed interface is
>sufficient to configure all possible lane encodings, because the
>encoding that the driver must select is now implicit (note, we don't
>need to care about media type here). That is, the driver can always
>select the encoding that maximizes utilization of the lanes available
>to the port (as defined by the admin).
>
>> >So concretely, I'm suggesting that if we want to force PAM4 at the lower
>> >speeds, split the port and then we don't need an ethtool interface change
>> >at all to achieve the same goal. Having a spare (potentially usable) port
>> >is better than spare (unusable) lanes.
>>
>> The admin has to decide, define.
>
>I'm not sure I understand. The admin would indeed decide. This paragraph
>merely served to motivate why a rational admin should prefer to have a
>spare port rather than unused lanes he can't use, because they would be
>attached to a port using an encoding that doesn't need them. If he wasn't
>planning on using the additional port, he loses nothing. Otherwise, he gains
>something he would not otherwise have had (it's win-win). From the
>perspective of the original port, two unused lanes is no different than two
>lanes allocated to another logical port.
>
>Regards,
>Edwin Peer


