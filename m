Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1A443EF0
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhKCJGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhKCJGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:06:11 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA6FC06120E
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 02:03:35 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d13so2402933wrf.11
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 02:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TCZ6vuIwBVtolWK4u3x1TuVxt+i5182IFwC3rZUAjSo=;
        b=i4zHTHIxpvCxmJgClz+Dh9DJEHDFkd+lXWnxtTfJ8IS3SQdtpkUEhtknD8ZN2MGpg+
         vFm+RttB2UnRa/BRei1pFHlp92QdaOQeO4krZZ82jmVkJe1jTmv2WQoaR9btKUUOTnlq
         bZLR7889SNZzIh7MEz04qtviTtI7rqG1jlJmAJQB9CQ+NVm8Q+9EXVkeet5RJqKgzcy0
         wsxkumXGvTqMfWzxLI78iji9wVOxBKgL4ADeHXpNwcXYIZ2x0tolmI2XNL48tSQwm7cJ
         oxcSV2wUhsTQMuOkJV7Uv1DwTBAILepag3c93y0Tud1LAD2gaBRdmqiNBVbJuuejhXQc
         AkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TCZ6vuIwBVtolWK4u3x1TuVxt+i5182IFwC3rZUAjSo=;
        b=A/Q9UUvW7z7d+/MRoaO8CyLaQLomIpSM+8yeAbe28FqvLXq1pJma2cuagbA/02CNme
         +EIXwrzhoNrnNGeU/0XO/ViyEdbqQVD4Th3tPedLypULIAuMAPyC42VRZSUqzWwB2F73
         s/nIUEMcKHy0iAZhmzBxYUwY4X2VyS1aL4RtPDduZx8GZxspLpfXkqsQNv5vZcvxu7uW
         Y0GPohqZaMGNMNjzdT+525rkJfkG8u7vCjVrZxGaeUdX1q9XR/EfN84kIuNljxq+quey
         EaXR9ESZQMKAcApjiUs4xnt3BhUNWyTa39mnCoSK0Vm3OcpVhH258Y7zpdQgUEDg02Wz
         iZFw==
X-Gm-Message-State: AOAM5338YLbD8NloLg6G0yBky0M1jiT3A+s8OgkDGNpZfFDlMXakqqjs
        dJ1Edf3icNq7eX2VFx620gvSxA==
X-Google-Smtp-Source: ABdhPJwR2lgtyYyo/tvWCUm3EGllxLQPSX9U62yNIMjEZb7ciwChkcxMIx+LC/kizzJc6i6MzBpdEg==
X-Received: by 2002:adf:ce03:: with SMTP id p3mr44463742wrn.145.1635930213874;
        Wed, 03 Nov 2021 02:03:33 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id o1sm1412426wrn.63.2021.11.03.02.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 02:03:33 -0700 (PDT)
Date:   Wed, 3 Nov 2021 10:03:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     leon@kernel.org, idosch@idosch.org, edwin.peer@broadcom.com,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <YYJQZIJPdy3WnQ1S@nanopsycho>
References: <20211030231254.2477599-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030231254.2477599-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Oct 31, 2021 at 01:12:49AM CEST, kuba@kernel.org wrote:
>This implements what I think is the right direction for devlink
>API overhaul. It's an early RFC/PoC because the body of code is
>rather large so I'd appreciate feedback early... The patches are
>very roughly split, the point of the posting is primarily to prove
>that from the driver side the conversion is an net improvement
>in complexity.
>
>IMO the problems with devlink locking are caused by two things:
>
> (1) driver has no way to block devlink calls like it does in case
>     of netedev / rtnl_lock, note that for devlink each driver has
>     it's own lock so contention is not an issue;
>     
> (2) sometimes devlink calls into the driver without holding its lock
>     - for operations which may need the driver to call devlink (port
>     splitting, switch config, reload etc.), the circular dependency
>     is there, the driver can't solve this problem.
>
>This set "fixes" the ordering by allowing the driver to participate
>in locking. The lock order remains:
>
>  device_lock -> [devlink_mutex] -> devlink instance -> rtnl_lock
>
>but now driver can take devlink lock itself, and _ALL_ devlink ops
>are locked.
>
>The expectation is that driver will take the devlink instance lock
>on its probe and remove paths, hence protecting all configuration
>paths with the devlink instance lock.
>
>This is clearly demonstrated by the netdevsim conversion. All entry
>points to driver config are protected by devlink instance lock, so
>the driver switches to the "I'm already holding the devlink lock" API
>when calling devlink. All driver locks and trickery is removed.
>
>The part which is slightly more challanging is quiescing async entry
>points which need to be closed on the devlink reload path (workqueue,
>debugfs etc.) and which also take devlink instance lock. For that we
>need to be able to take refs on the devlink instance and let them
>clean up after themselves rather than waiting synchronously.
>
>That last part is not 100% finished in this patch set - it works but
>we need the driver to take devlink_mutex (the global lock) from its
>probe/remove path. I hope this is good enough for an RFC, the problem
>is easily solved by protecting the devlink XArray with something else
>than devlink_mutex and/or not holding devlink_mutex around each op
>(so that there is no ordering between the global and instance locks).
>Speaking of not holding devlink_mutex around each op this patch set
>also opens the path for parallel ops to different devlink instances
>which is currently impossible because all user space calls take
>devlink_mutex...
>
>The patches are on top of the cleanups I posted earlier.

Hi Jakub.

I took my time to read this thread and talked with Leon as well.
My original intention of locking in devlink was to maintain the locking
inside devlink.c to avoid the rtnl_lock-scenario.

However, I always feared that eventually we'll get to the point,
when it won't be possible to maintain any longer. I think may be it.

In general, I like your approach. It is very clean and explicit. The
driver knows what to do, in which context it is and it can behave
accordingly. In theory or course, but the reality of drivers code tells
us often something different :)

One small thing I don't fully undestand is the "opt-out" scenario which
makes things a bit tangled. But perhaps you can explain it a bit more.

Leon claims that he thinks that he would be able to solve the locking
scheme leaving all locking internal to devlink.c. I suggest to give
him a week or 2 to present the solution. If he is not successful, lets
continue on your approach.

What do you think?

Thanks!

>
>Jakub Kicinski (5):
>  devlink: add unlocked APIs
>  devlink: add API for explicit locking
>  devlink: allow locking of all ops
>  netdevsim: minor code move
>  netdevsim: use devlink locking
>
> drivers/net/netdevsim/bus.c       |  19 -
> drivers/net/netdevsim/dev.c       | 450 ++++++++-------
> drivers/net/netdevsim/fib.c       |  62 +--
> drivers/net/netdevsim/netdevsim.h |   5 -
> include/net/devlink.h             |  88 +++
> net/core/devlink.c                | 875 +++++++++++++++++++++---------
> 6 files changed, 996 insertions(+), 503 deletions(-)
>
>-- 
>2.31.1
>
