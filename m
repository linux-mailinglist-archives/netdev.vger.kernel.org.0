Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69321B1E3B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 07:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgDUFhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 01:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725385AbgDUFhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 01:37:48 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C52C061A10
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 22:37:47 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u16so2170591wmc.5
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 22:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sFVLl7XFsA0fmf0EJD1vmZJMnnrsNNiC6fGUnkgAhp0=;
        b=lp7Hgml+93xI+CgJaDMSFKC7hF4xGK9+HRc7cqVDBFmadFez9+RS2b0GvO8XR1Pq5N
         9Fpu4Asncv0dG8BV3eaTjts6s/aWEQCuxvE+kLyZQV/Ggaq1ByBQOOts+73069w4x29y
         pVVEVfeg69W/gdDeC6dyrgsFZCkerTYAktVEEk/TMmwY7d7y4b5ONHC0xVfHhn15amSn
         J7zKsD/bcXZjD8ZxFJe2PmDjW3t+5LzMuPhP89fJrqU0j6pwyCWi1gvLsn8/DVIME2kU
         0ga97DwyLPFUE9jCxdppQLn1gLZlOniv+kM2TBVPgJl9C97rg7CMF7o07oia5wMA5vvn
         /0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sFVLl7XFsA0fmf0EJD1vmZJMnnrsNNiC6fGUnkgAhp0=;
        b=kNTis1DPonIyzsPILpD6AlLaKdG4EFG7JO7/rrY9or0shjIUGx5T75gIbqZJll49D9
         gFWlWjiAstNTUZRhIoML3/mD5pzoTC81oWrvxr5Y0IRshjKNyr3k4QkpMpYsolnf91ES
         Tw7hlfr6u6dB3Qqc8Af+dP8ypnHLRj1NpLMvVEFtkS4i2j7JWYwSD0WLI0XQ22YBGdYv
         QC+W4wPFy14OuaJXSZayS8qJkN1bhAJsF2GzBNulS9IpQCVplbgq//vRT0EvfVlUDVCZ
         5CaWAfbJDE1OPhDZeDkXHlVqxcQrtL+7YsC6GbJqBYT5t9wusWLXT7MbrUIkX7R3u4nq
         Vpcw==
X-Gm-Message-State: AGi0PuagUvftUn2KAIgJxXHfOz5nVUswxmZ39fns93xlDHfkZKCP20Lz
        rC1qMOvTgpbEjXqoHdDIrS4s+w==
X-Google-Smtp-Source: APiQypIs59QYmdx83SecPfSceQCLa38pWF71rK77sxjhltIhmaI0up152I/GpXyqx9FkhPdWWzZqyQ==
X-Received: by 2002:a1c:2e0a:: with SMTP id u10mr2980638wmu.146.1587447466249;
        Mon, 20 Apr 2020 22:37:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y10sm1983744wma.5.2020.04.20.22.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 22:37:45 -0700 (PDT)
Date:   Tue, 21 Apr 2020 07:37:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
Message-ID: <20200421053744.GX6581@nanopsycho.orion>
References: <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420175421.GU6581@nanopsycho.orion>
 <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
 <20200420180144.GV6581@nanopsycho.orion>
 <75dffa6a-c14f-45c9-44e1-bf5b5c650a9b@gmail.com>
 <20200420184811.GW6581@nanopsycho.orion>
 <60467948-041c-5de1-d365-4f21030683e7@mellanox.com>
 <46f77bb5-c26e-70b9-0f5a-cd3327171960@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46f77bb5-c26e-70b9-0f5a-cd3327171960@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 09:02:58PM CEST, dsahern@gmail.com wrote:
>On 4/20/20 12:56 PM, Maor Gottlieb wrote:
>> 
>> On 4/20/2020 9:48 PM, Jiri Pirko wrote:
>>> Mon, Apr 20, 2020 at 08:04:01PM CEST, dsahern@gmail.com wrote:
>>>> On 4/20/20 12:01 PM, Jiri Pirko wrote:
>>>>> Generic ndo with lag-specific arg? Odd. Plus, there is a small chance
>>>>> this is ever going to be used for other master. And if so, could be
>>>>> very
>>>>> easily renamed then...
>>>> core code should be generic, not specific and renamed at a later date
>>>> when a second use case arises.
>>> Yeah, I guess we just have to agree to disagree :)
>> 
>> So I am remaining with the flags. Any suggestion for better name for the
>> enum? Should I move master_xmit_get_slave from lag.h to netdevice.h?
>>>
>
>IMHO, yes, that is a better place.
>
>generic ndo name and implementation.
>type specific flag as needed.
>
>This is consistent with net_device and ndo - both generic concepts -
>with specifics relegated to flags (e.g., IFF_*)

Why there is need for flags? Why a single bool can't do as I suggested?
Do you see any usecase for another flag?

