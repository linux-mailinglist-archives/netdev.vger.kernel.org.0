Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C77F43FFCE
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhJ2PsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhJ2PsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:48:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30732C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 08:45:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 127so9641348pfu.1
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qTcXKJKgbF5mty1hNo8ly8P/1rFgubFz7cgW+BVrg28=;
        b=bzuUOadA/lKAsal/1Z+XTGbJP5+SGXCZyKbDtjSprdT/wFOdajSU1M3EWgbJ4oj+BS
         jn27+ZVYItJfS90HP/xQm1a6LOVLENewCmJGG2Mc1C/0DN8SlF4hNA5Lwsvfm0x9QK1f
         kBShkjEt0D8ogJs5blz5+RYflB2ojXqfSYms7X+HdVQnb4N/9TvRZu2Khk+Tk5UwOTtv
         BZThGfTV1AHx9aJJpnv9n6N9h1MZR8Glr+UYqE0M9gu9+LD56P0BFJ+fAiDMkaz6CsnB
         i3/WKLXNDOatY3JFRpCLkXnFhgeGo/3mdb9xtOWSukX6AK5w3/4pl0GvM0Rseuq3Z4ry
         1GBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qTcXKJKgbF5mty1hNo8ly8P/1rFgubFz7cgW+BVrg28=;
        b=5bX9XLFoKAeV5KukMdKHurNGZorNdtECkHE558mrxxpyZge+a4ose/AqsZy35P65ZB
         PPk29p+wjRPMrWtKE1OaEjUSRLfEcEjcZys19JcA/aM+HV5p2KVrtJqKS39fpzBFfY1x
         GjsTtwcgirNI5WvUVGTdqmqyd1gw+5psJZ1WCy+SgZjfbQyxs07+KsMrYD9+hZZVuLa5
         8ycKUW8T7ly6yDiSXXFBu+cbNUVJbzLU0Nl9S+uLEhaqbl8sNyTJvsXHm4B9MAX5uD9m
         wPelo5vXCz4TbvOQfTvbdVfN3+605N94huhFuRFyKEYCGMP9mI5j4KUmlZ0XWzVLAg3O
         328A==
X-Gm-Message-State: AOAM531ac7ut9Jt0/R6TtjOEjiaPKbRCb5D2YPNsiLKS0vO22kV7Lwlf
        IJCiUDDqVYlPl6gdnKqx9MkaaQ==
X-Google-Smtp-Source: ABdhPJzb2aOUtMbO3Qd8aVNrMJ8dplMYSBupzT7gPDXfuy8yvmkAF6XbNkk8PgW08aAjOpKo/wMUEw==
X-Received: by 2002:a63:2b81:: with SMTP id r123mr8721805pgr.91.1635522332678;
        Fri, 29 Oct 2021 08:45:32 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id w5sm8174819pfu.85.2021.10.29.08.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 08:45:32 -0700 (PDT)
Date:   Fri, 29 Oct 2021 08:45:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org, mhocko@suse.com
Subject: Re: [RFC PATCH net-next 0/9] Userspace spinning on net-sysfs access
Message-ID: <20211029084527.57d38f09@hermes.local>
In-Reply-To: <163551798537.3523.2552384180016058127@kwain>
References: <20210928125500.167943-1-atenart@kernel.org>
        <163551798537.3523.2552384180016058127@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Oct 2021 16:33:05 +0200
Antoine Tenart <atenart@kernel.org> wrote:

> With the approach taken in this thread not going too well[1], what next?
> I think we should discuss other possibilities and gather some ideas.
> Below are some early thoughts, that might not be acceptable.
> 
> 1) Making an rtnl_lock helper that returns when needed
> 
> The idea would be to replace rtnl_trylock/restart_syscall by this
> helper, which would try to grab the rtnl lock and return when needed.
> Something like the following:
> 
>   static rtnl_lock_ifalive(const struct net_device *dev)
>   {
>           while (!rtnl_trylock()) {
>                   if (!dev_isalive(dev))
>                           return -EINVAL;
> 
>                   /* Special case for queue files */
>                   if (dev->drain_sysfs_queues)
>                           return restart_syscall();
> 
>                   /* something not to have the CPU spinning */
>           }
>   }
> 
> One way not to have the CPU spinning is to sleep, let's say with
> `usleep_range(500, 1000);` (range to be defined properly). The
> disadvantage is on net device unregistration as we might need to wait
> for all those loops to return first. (It's a trade-off though, we're not
> restarting syscalls over and over in other situations). Or would there
> be something better?
> 
> Possible improvements:
> - Add an overall timeout and restart the syscall if we hit it, to have
>   an upper bound.
> - Make it interruptible, check for need_resched, etc.
> 
> Note that this approach could work for sysctl files as well; looping
> over all devices in a netns to make the checks.
> 
> 2) Interrupt rtnl_lock when in the unregistration paths
> 
> I'm wondering if using mutex_lock_interruptible in problematic areas
> (sysfs, sysctl), keeping track of their tasks and interrupting them in
> the unregistration paths would work and be acceptable. On paper this
> looks like a solution with not much overhead and not too invasive to
> implement. But is it acceptable? (Are there some side effects we really
> don't want?).
> 
> Note that this would need some thinking to make it safe against sysfs
> accesses between the tasks interruption and the sysfs files draining
> (refcount? another lock?).
> 
> 3) Other ideas?
> 
> Also, I'm not sure about the -rt implications of all the above.
> 
> Thanks,
> Antoine
> 
> [1] https://lore.kernel.org/netdev/163549826664.3523.4140191764737040064@kwain/

As the originator of net-sysfs and the trylock, I appreciate your attempts
to do something better. The best solution may actually not be just in the
networking code but go all the way back up to restart_syscall() itself.


Spinning a CPU itself is not a bad thing, see spin locks.
The problem is if the spin causes the active CPU to not make progress.
