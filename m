Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F46460EDF
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbhK2GrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353753AbhK2GpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 01:45:19 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9443EC0613E0
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 22:41:00 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id v22so15588372qtx.8
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 22:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=035W6z4+rcvvp+Iw2Vbk0ESy8WJ+26nccaBPMsnEqag=;
        b=Kh5x/7pLYVgwQ7f2dTc8Uw9Yu3hQF9/TzvksfKCdLtp7UjD4mpDsl1JJFlgZuGe+Ne
         vp4O6vOJJPZ4IqcnZKx+Sg9wQHfBbtLGq7BpOKg82+xDR8y/itpkWw7uG6cBi8bOMlR+
         42h2NHx06Xtu0+efodzRa6Ei1591jvhiLIHePY2KeLx9JOFYwJlA+qmSzAeAgqrg7Vlj
         hIPOuSMvGF+4lUWcEwGrUdDJQFVAcU7YFNjzzjcRJeJLYOMJtaKUiV71rkZtT7oLtUbN
         h8Xw+CKYebqQ0If/HDYh5ttlXrpJUusd2zVJR3Kcsol6A2ZDhJgEULdmRUVM5yzg0upx
         4i+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=035W6z4+rcvvp+Iw2Vbk0ESy8WJ+26nccaBPMsnEqag=;
        b=X2oSIlA/TBTswxor9ckuSaK6ZMJLuHLrEt4sSj2MVjA3ah1Jb0RpGgPY5qpOeNm+L8
         5gdVzoxV1zFb1X5UtnUyf5+PBeaw095D6jvXCfj5YoifQU8a8AlSMrJRCAh0ebtXFrDg
         vwOycuoOGP+4+lMDKdqp0II/7mOvaJjZ1SEXQuMMxfDsTMCudBf2Dahuo+8zfXwbzJ5N
         DaV7X9SkcMNiuySBeEGton5i3x8OrOm2PhgJyNHH3xSt0KcIUCSe3HxwHcek7fYaY3MT
         HsB0MM8LT4TWVFf6Tmdh4Avb9UDPIb+XKTfnbm568je44cH+MGIcTub0fqmIairVbJM2
         /Q7Q==
X-Gm-Message-State: AOAM533zc3WcCjeRec05urazFZb7SuBOg6EEIm7YDuH1lFNV9WqMkgmK
        6Y/Lp3LTaHXR2CDj0YEh1lDnpza7GQ==
X-Google-Smtp-Source: ABdhPJxYeAPOK6SZQs37oV+zQ5yWL1zlPi6cqcM2AK9GN6HmYZBXB2d5m81oPLgdxaiphxdrSrM9iQ==
X-Received: by 2002:a05:622a:1792:: with SMTP id s18mr37186121qtk.118.1638168059758;
        Sun, 28 Nov 2021 22:40:59 -0800 (PST)
Received: from bytedance (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id bp18sm7739317qkb.39.2021.11.28.22.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 22:40:59 -0800 (PST)
Date:   Sun, 28 Nov 2021 22:40:56 -0800
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
Message-ID: <20211129064056.GA2272@bytedance>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com>
 <YYuObqtyYUuWLarX@Laptop-X1>
 <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
 <YZR0y7J/MeYD9Hfm@Laptop-X1>
 <d83d3013-0a06-b633-fded-b563fa52b200@gmail.com>
 <CAM_iQpUHLy8mxcztVKAcRz22-VeDUHwTV5g5UgmxUhQx8hQ9Gw@mail.gmail.com>
 <YZ2YrPGJSEm8UAiv@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ2YrPGJSEm8UAiv@Laptop-X1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Wed, Nov 24, 2021 at 09:43:08AM +0800, Hangbin Liu wrote:
> On Tue, Nov 23, 2021 at 05:05:14PM -0800, Cong Wang wrote:
> > My colleague Peilin is now looking into this.
> 
> Thanks Wang Cong and Peilin. Sorry I didn't get time to check on this
> issue.

I think I figured out the cause:

There was a bug [1] in ping's -I option, which has been fixed by iputils
commit f455fee41c07 ("ping: also bind the ICMP socket to the specific
device") [2] in 2016.

Before the fix, "ping -I" actually did _not_ bind the ICMP message
socket to device.  It only bound the "probe socket"; see "probe_fd" in
ping4_run().

Now, "ping -I" binds both sockets to device using SO_BINDTODEVICE, and
socket lookup is failing (when receiving ICMP_ECHOREPLY messages) for
our rp_filter test here, as David mentioned earlier.

I'm still thinking about how should we fix the test.  Any ideas?

[1] https://github.com/iputils/iputils/issues/55
[2] https://github.com/iputils/iputils/commit/f455fee41c077d4b700a473b2f5b3487b8febc1d

Thanks,
Peilin Ye

