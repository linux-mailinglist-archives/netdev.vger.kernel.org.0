Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4F2F4C57
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbhAMNjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbhAMNjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:39:45 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC909C061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 05:39:04 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id n16so3655390wmc.0
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 05:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jz/msSrj7zg9GrT7wqX3KU58yYlEE5A0SsTEx+stirQ=;
        b=ib4ymt/YiO/nvjaz/3N5cjRumH8TNjnh+BC1xt3RqIsXthdZc2K6D7UTujv678chCV
         Jb6UzWsH7vmoPziIG3/nikUmWViyaevQ3fGZ0Zxz0WLkHrnl2Thpzo+8JmjWEIYstyBP
         Bm58MHzhymcC4e+qWYYbWv4JJaoE5SPqJ6OfqPMn+ev/8CHRoh2VQM+8PesUPrDeKwtN
         hex8XeL+21kvCDHnPfOz7k5jv2RRerGbv01JuOX3sJ+FN9WQzs7pNrysPe4/HlUEvd0s
         vYI8C8jlGOEZLIr0sxtAQw4hXONRQGX+UvyJ3l3Yg0wVZ8y+x2R3yTc6fG7Up6QDRGg/
         FE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jz/msSrj7zg9GrT7wqX3KU58yYlEE5A0SsTEx+stirQ=;
        b=QFyV4HeNqberMDgbhxJX5O5VY69rLCiMflV/p1Y/vMT7OZ8+tenwydtRyOTSedTizW
         WinsMb5UNUEWEbGfQrIPTuM4DLSpCuzIkwtqzYyf9C1tWjXz6Ef9S3PqaEcQ2eTLyZ86
         26ivBfJ8oc26MEkpK/25rcQXKlw8RjJSy81AzQbhgP6oSfQmLtGo67jOF5z4kP4Av8tK
         HUgllKfZcrB1YBnbe6crdUjsfB2kRz7kAT9DhwoG4LfhxJgibIGfZHnf3SuUf1Uy5hHY
         aQPYgHC71ZgI7IBN5/nK2izdHz5FJeJHymlRVNdVSSIWZa5mutx0yafJ0lPF1JWrQnYo
         KmCw==
X-Gm-Message-State: AOAM532EnCBbvXh+qQr/XCwyeD9c+Y4GVesMfZ3Gok022mF+zq09wQGN
        WctQZ6KAQ1tBMl2BNDbJho0vNQ==
X-Google-Smtp-Source: ABdhPJyg3eTqvb/NQb8qPRtdpvqh1YY3ZNRwCnYqlBD1RahdUjTw4Ei5efO7Bst2XE5tPzxgKART8A==
X-Received: by 2002:a05:600c:1552:: with SMTP id f18mr2265924wmg.125.1610545143512;
        Wed, 13 Jan 2021 05:39:03 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id k1sm3206220wrn.46.2021.01.13.05.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 05:39:03 -0800 (PST)
Date:   Wed, 13 Jan 2021 14:39:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: Register physical ports as a devlink
 resource
Message-ID: <20210113133902.GH3565223@nanopsycho.orion>
References: <20210112083931.1662874-1-idosch@idosch.org>
 <20210112083931.1662874-2-idosch@idosch.org>
 <20210112202122.5751bc9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210113083241.GA1757975@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113083241.GA1757975@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 13, 2021 at 09:32:41AM CET, idosch@idosch.org wrote:
>On Tue, Jan 12, 2021 at 08:21:22PM -0800, Jakub Kicinski wrote:
>> On Tue, 12 Jan 2021 10:39:30 +0200 Ido Schimmel wrote:
>> > From: Danielle Ratson <danieller@nvidia.com>
>> > 
>> > The switch ASIC has a limited capacity of physical ('flavour physical'
>> > in devlink terminology) ports that it can support. While each system is
>> > brought up with a different number of ports, this number can be
>> > increased via splitting up to the ASIC's limit.
>> > 
>> > Expose physical ports as a devlink resource so that user space will have
>> > visibility to the maximum number of ports that can be supported and the
>> > current occupancy.
>> 
>> Any thoughts on making this a "generic" resource?
>
>It might be possible to allow drivers to pass the maximum number of
>physical ports to devlink during their initialization. Devlink can then
>use it as an indication to register the resource itself instead of the
>driver. It can report the current occupancy without driver intervention
>since the list of ports is maintained in devlink.
>
>There might be an issue with the resource identifier which is a 64-bit
>number passed from drivers. I think we can partition this to identifiers
>allocated by devlink / drivers.
>
>Danielle / Jiri?

There is no concept of "generic resource". And I think it is a good
reason for it, as the resource is something which is always quite
hw-specific. Port number migth be one exception. Can you think of
anything else? If not, I would vote for not having "generic resource"
just for this one case.
