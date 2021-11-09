Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87DF44B137
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 17:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbhKIQcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 11:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240354AbhKIQcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 11:32:03 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD62C06120C
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 08:29:17 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id c4so34018485wrd.9
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 08:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uwR1t4o6epDV/t4amIqWEVfEvcX3CRHUyEZbrtcYLdo=;
        b=t6e/phj9cRmjeaAKKehsThGSsRYGgbk9sanouMI8gS0Eoib+wsYlC8S2GcDnk8iol6
         r0gPVXPj3/M5B61uy0lptt9IL5cwDLgtmnOo7Ru/ocCYrfD/Fo4RnaDUHGFDxRtxgawl
         5gvR0Lh00tDtHElEU4i2Ukvm6Uz8QR8LGed8nvi2LBMKirpbIyjglzXNnJdxyXq3JSm9
         BRqRvuAzteOgjUAlTTjoaP1+TTbTRv7hTjI9xwbFKjR9rOY8bH+Q230l5tAib6ANffpf
         wjAbnr5wpaA3IkVOVOYX5cHmk9hMrAEeGO8kw9Z40neakSmXJFqlfq4uQJa06HTGDt0d
         gwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uwR1t4o6epDV/t4amIqWEVfEvcX3CRHUyEZbrtcYLdo=;
        b=UqLsVn2sn4/TEnM4Lvfgu+aT++Edjs8WkMiazyJXphfuu4EajdnshfzKoqPls1bkwk
         3WSKj9fCr8RtOEXvRgt+ZQaHuR8DZcPALk4g+2Q54RGzu0COY8w3M6mwrcDeWey59cxn
         XkwEWurVjBTYlfLhTLsyadzEiYA8fT3Hcr9la8rBBPex1oBcxM25JHq41EPfNrlEpabE
         lq96lLb/h5L7ZDdQZ4Atigt5fC0MBw0CmVITfzREzYnX9qGTTt42GY1nfgHp7aD5Ul4H
         oCm+ScGS3ZnWoqTB7xaNYTyrilEpxOXGEKC241TLQIm4J7ZJg+IdUEUBx+XU9D/IXZTF
         3CHQ==
X-Gm-Message-State: AOAM533xNj7vJmPjdNG8SEq+OBK5SGvS9N46QPusGhKo9e3ZEOWfM3sn
        yh1x3vzyW6C2NaAGevJ1omo6vQ==
X-Google-Smtp-Source: ABdhPJyoOr15DD4sd8lgO2lQHThukrLMgZ4EZxk1WEAhx4X/fPA8dwkZQhSB9eWgqcW28RqCRSabCw==
X-Received: by 2002:adf:ef52:: with SMTP id c18mr11013472wrp.162.1636475356037;
        Tue, 09 Nov 2021 08:29:16 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f133sm3183344wmf.31.2021.11.09.08.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 08:29:15 -0800 (PST)
Date:   Tue, 9 Nov 2021 17:29:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYqh2vDGJ+RxlmoD@nanopsycho>
References: <YYgJ1bnECwUWvNqD@shredder>
 <YYgSzEHppKY3oYTb@unreal>
 <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYqB0VZcWnmtSS91@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYqB0VZcWnmtSS91@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 09, 2021 at 03:12:33PM CET, leon@kernel.org wrote:
>On Mon, Nov 08, 2021 at 03:31:26PM -0800, Jakub Kicinski wrote:
>> On Mon, 8 Nov 2021 21:58:36 +0200 Leon Romanovsky wrote:
>> > > > > nfp will benefit from the simplified locking as well, and so will bnxt,
>> > > > > although I'm not sure the maintainers will opt for using devlink framework
>> > > > > due to the downstream requirements.    
>> > > > 
>> > > > Exactly why devlink should be fixed first.  
>> > > 
>> > > If by "fixed first" you mean it needs 5 locks to be added and to remove
>> > > any guarantees on sub-object lifetime then no thanks.  
>> > 
>> > How do you plan to fix pernet_ops_rwsem lock? By exposing devlink state
>> > to the drivers? By providing unlocked version of unregister_netdevice_notifier?
>> > 
>> > This simple scenario has deadlocks:
>> > sudo ip netns add n1
>> > sudo devlink dev reload pci/0000:00:09.0 netns n1
>> > sudo ip netns del n1
>> 
>> Okay - I'm not sure why you're asking me this. This is not related to
>> devlink locking as far as I can tell. Neither are you fixing this
>> problem in your own RFC.
>
>I asked you because you clearly showed to me that things that makes
>sense for me, doesn't make sense for you and vice versa.
>
>I don't want to do work that will be thrown away.
>
>> 
>> You'd need to tell me more about what the notifier is used for (I see
>> RoCE in the call trace). I don't understand why you need to re-register 
>> a global (i.e. not per netns) notifier when devlink is switching name
>> spaces.
>
>RDMA subsystem supports two net namespace aware scenarios.
>
>We need global netdev_notifier for shared mode. This is legacy mode where
>we listen to all namespaces. We must support this mode otherwise we break
>whole RDMA world.
>
>See commit below:
>de641d74fb00 ("Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"")

If it is not possible for whatever reason to have per-ns notifier, you
have to register the global notifier probably only once in init, and
have probably some sort of mechanism to ignore the events while you are
in the middle of the re-init. I don't see other way.
