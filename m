Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84A11B1041
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgDTPee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgDTPee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:34:34 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D454C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 08:34:34 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h2so11562583wmb.4
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 08:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bh6WozhGcLw9b/xuUdaENuoJLT3SBG8J1R4jduJ0yLY=;
        b=Zbux181WzU8yPs1g+DmQwpvPRfO2qAfHyDxJVOun0zsc93/+b/TKt9D4g1wbv7P4/c
         Lg6MWkS/BxhPkSaozEmLb0Kr5AKgmHN7AHEpR+/TPVr9I9GLgUIY4nozD/70VgE54pWX
         2Gig6A0fIqFlEnbukoCW4MULmsjsUxq1CZNj4QkQ7QB4TKRtF0UxMPXrGCLhIJhzDGSo
         ZYUTyPuqzlX9oa1XQGcLUQXPBRrsiRGKUJWcpWIqjSMsPYX1CXa4vkKc4PmBVvG0nNPs
         9fDqLoP/YqH3gRy6uwY50EtWLG74xYRa/tI2I1/PdtLIWHG4VWN+aATJD5mwDp3bcjp+
         6t5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bh6WozhGcLw9b/xuUdaENuoJLT3SBG8J1R4jduJ0yLY=;
        b=UU+yU/B/kn2TqcO9nIpG/jpz3ycaJ4aVP3arNqYAJy3ARElYdL+hl676iR60wodBmT
         2ILfu20+86BXZa4TByKPGXMmuNQfUH8ywpZLzm4/xioJv9bcGz6xfp2Qh95d23P528h5
         z5WOCcZpNNKWZCaMgrg12Ze7T1Y2ZELakc2WpfSMyi3Znra2jIimWl1lfxNSwTE1Swxd
         jICy/0B0s4FfalPEvyg2dShaE//t2JRWrImbrccuN9RBZtyN9UsltAXfIXqcxg0IgCvq
         BId2iC5BjLI9IaTtsczxTsl2X/fSygBzUEJCZX5MrWZd3BSS23vJngiEju5wjDDkFUof
         HwyA==
X-Gm-Message-State: AGi0PuZyP4FaOEm793B8vDmskObSUROv84iqeblpBewllI2PBFFJqWwN
        wqbbUIAwezs4nPriOeuF6inukg==
X-Google-Smtp-Source: APiQypI4jq4dCToySeV9MaWKIcHdW17hHwOiXTOzggc4WTNkXC3DSkdhAeNZeK3cHi6/R8tGSsRpTg==
X-Received: by 2002:a05:600c:2a52:: with SMTP id x18mr17706386wme.37.1587396872854;
        Mon, 20 Apr 2020 08:34:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k23sm1765537wmi.46.2020.04.20.08.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 08:34:31 -0700 (PDT)
Date:   Mon, 20 Apr 2020 17:34:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v3] team: fix hang in team_mode_get()
Message-ID: <20200420153430.GR6581@nanopsycho.orion>
References: <20200420150133.2586-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420150133.2586-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 05:01:33PM CEST, ap420073@gmail.com wrote:
>When team mode is changed or set, the team_mode_get() is called to check
>whether the mode module is inserted or not. If the mode module is not
>inserted, it calls the request_module().
>In the request_module(), it creates a child process, which is
>the "modprobe" process and waits for the done of the child process.
>At this point, the following locks were used.
>down_read(&cb_lock()); by genl_rcv()
>    genl_lock(); by genl_rcv_msc()
>        rtnl_lock(); by team_nl_cmd_options_set()
>            mutex_lock(&team->lock); by team_nl_team_get()
>
>Concurrently, the team module could be removed by rmmod or "modprobe -r"
>The __exit function of team module is team_module_exit(), which calls
>team_nl_fini() and it tries to acquire following locks.
>down_write(&cb_lock);
>    genl_lock();
>Because of the genl_lock() and cb_lock, this process can't be finished
>earlier than request_module() routine.
>
>The problem secenario.
>CPU0                                     CPU1
>team_mode_get
>    request_module()
>                                         modprobe -r team_mode_roundrobin
>                                                     team <--(B)
>        modprobe team <--(A)
>            team_mode_roundrobin
>
>By request_module(), the "modprobe team_mode_roundrobin" command
>will be executed. At this point, the modprobe process will decide
>that the team module should be inserted before team_mode_roundrobin.
>Because the team module is being removed.
>
>By the module infrastructure, the same module insert/remove operations
>can't be executed concurrently.
>So, (A) waits for (B) but (B) also waits for (A) because of locks.
>So that the hang occurs at this point.
>
>Test commands:
>    while :
>    do
>        teamd -d &
>	killall teamd &
>	modprobe -rv team_mode_roundrobin &
>    done
>
>The approach of this patch is to hold the reference count of the team
>module if the team module is compiled as a module. If the reference count
>of the team module is not zero while request_module() is being called,
>the team module will not be removed at that moment.
>So that the above scenario could not occur.
>
>Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
>Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
