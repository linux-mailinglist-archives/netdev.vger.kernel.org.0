Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4564448DF
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhKCTWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhKCTWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 15:22:21 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88761C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 12:19:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f4so12868065edx.12
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 12:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sP0bfXF/8PCJjdeW6fxK7ZV4OnUFgv5gfhjqtRsLygw=;
        b=AVHg1pWWXoNhb2Zrv5jOJY2jhpbdSIHBeGRjeVTUbtX/hca5J9xiPRlZe1fXC9jAUX
         at1s72AfRmheBwFhJCJZZVl1TosQ65h5xT7LypG40C00pmvKdFMuKINp0UjSpHM1u/S0
         YQf1PDSZroqnllginx+SROQYTy1uBDBPL65Gbylgr35+ZNCJSjV9TSOruS7CBbPRU+x+
         wn5d2zQ4G3IEVOkyMBcq6szv4c44FCF7Hujh1uTy8ybowu38rEhWArpp1qskkfuTLB85
         vN/Ry2agQE3vFB4cnktfpuAtW7QTG03H+e/uyWhQITyd82Lsw2vfdi5GYeIJLhj3/ld1
         GmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sP0bfXF/8PCJjdeW6fxK7ZV4OnUFgv5gfhjqtRsLygw=;
        b=ZCZiuDKsaRXcn1aiVodg19tRgMZdPWSRYq1nHayT3Y5JchuifJj5MrMuCMrscYHCoR
         5QVDKeN+puUcxfb4hRx0OyMmVI+WCEI6/loWflmYf9xoMbwotdELy3A4UDOROUhBBD7Q
         Px9Cl2pyp2Fhg9h/yQU3Krm7Oe/C6VuPexDv6fCBk6+3P3hIrIJwgUzZ93sUe15n66qy
         QDkLsARAmm1BNZEJLbUNGz4seva8Djl4y1YyoyPfrPHkHdvG/vztCwksNA6oUZOIwMW/
         4VoYEZAzkKHiszh7uHmyBPSjmPnFP4XBynIPJJevjtsJ9ar2Z/6lpfBCqnwx8Sn4A0ha
         GNpg==
X-Gm-Message-State: AOAM530eJkghTuCALvr5J/bKQvEwUYBJ0ISwA9tcWwmVf+7TYvyPBJhd
        +ASDrgeXP1hqfVC6bV7hYqupog==
X-Google-Smtp-Source: ABdhPJw6Y0MtXhhzP4UwLL27/jVpfnjgS+i0zKA0CmK+YjNd3PguLoW6Hfo7/Lf+VpMs84alrnOTNw==
X-Received: by 2002:a17:907:3d94:: with SMTP id he20mr26408312ejc.75.1635967183074;
        Wed, 03 Nov 2021 12:19:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c19sm2111478ede.16.2021.11.03.12.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 12:19:42 -0700 (PDT)
Date:   Wed, 3 Nov 2021 20:19:41 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     leon@kernel.org, idosch@idosch.org, edwin.peer@broadcom.com,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YYLgzVXO6IYoQkW9@nanopsycho>
References: <20211030231254.2477599-1-kuba@kernel.org>
 <YYJQZIJPdy3WnQ1S@nanopsycho>
 <20211103075231.0a53330c@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103075231.0a53330c@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 03, 2021 at 03:52:31PM CET, kuba@kernel.org wrote:
>On Wed, 3 Nov 2021 10:03:32 +0100 Jiri Pirko wrote:
>> Hi Jakub.
>> 
>> I took my time to read this thread and talked with Leon as well.
>> My original intention of locking in devlink was to maintain the locking
>> inside devlink.c to avoid the rtnl_lock-scenario.
>> 
>> However, I always feared that eventually we'll get to the point,
>> when it won't be possible to maintain any longer. I think may be it.
>
>Indeed, the two things I think we can avoid from rtnl_lock pitfalls 
>is that lock should be per-instance and that we should not wait for
>all refs to be gone at unregister time.
>
>Both are rather trivial to achieve with devlink.
>
>> In general, I like your approach. It is very clean and explicit. The
>> driver knows what to do, in which context it is and it can behave
>> accordingly. In theory or course, but the reality of drivers code tells
>> us often something different :)
>
>Right. I'll convert a few more drivers but the real test will be
>seeing if potential races are gone - hard to measure.
>
>> One small thing I don't fully undestand is the "opt-out" scenario which
>> makes things a bit tangled. But perhaps you can explain it a bit more.
>
>Do you mean the .lock_flags? That's a transitional thing so that people
>can convert drivers callback by callback to make prettier patch sets. 
>I may collapse all those flags into one, remains to be seen how useful
>it is when I create proper patches. This RFC is more of a code dump.
>
>The whole opt-out is to create the entire new API at once, and then
>convert drivers one-by-one (or allow the maintainers who care to do 
>it themselves). I find that easier and more friendly than slicing 
>the API and drivers multiple times.
>
>Long story short I expect the opt-out would be gone by the time 5.17
>merge window rolls around.

Okay, got it.


>
>> Leon claims that he thinks that he would be able to solve the locking
>> scheme leaving all locking internal to devlink.c. I suggest to give
>> him a week or 2 to present the solution. If he is not successful, lets
>> continue on your approach.
>> 
>> What do you think?
>
>I do worry a little bit that our goals differ. Seems like Leon wants to
>fix devlink for devlink and I want drivers to be able to lean on it.
>
>But I'm not attached to the exact approach or code, so as long as
>nobody is attached to theirs more RFCs can only help.
>
>Please be courteous and send as RFCs, tho.

Makes sense. Thanks!
