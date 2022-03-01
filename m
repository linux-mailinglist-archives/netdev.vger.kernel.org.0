Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B440B4C9295
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbiCASKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 13:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbiCASKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 13:10:03 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4003F311
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:09:21 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id z14-20020a170902ccce00b0014d7a559635so6523978ple.16
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 10:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=c0dbKsIdJk+qHikmULBiKTfiJVqKnwC4QHGDZyjez5c=;
        b=c0CY58qwtC+TXIekm9RwFv9mu85r2tPUGknQ7lP4mK62Dv4iMMRx2WwvSmym01I/rt
         x4a6ZJclsNaz5N4C9aAN1fTg3nik/jMjRCN73yPx/fcUzal7hJfreK83kZc1NY0MZB8d
         EVJ5QjIoD9KxKwfsA+8JKkej0did5a3WXbLWwN8dsYyndAwDQx6OXWDTJHo5LnA6Vgxu
         IQjaqRQeuuKMxfjT0X9hu5QyWkWFwifmszCxuDSnaYBgYLDf8fhU2Ip32/r41UnVH3Su
         cAjn4su1Pwdt+j2mgeQqJOJ/z9T8D8s/rO0Ku6ZgWJjzH3C60V6N8sBqCdpXtVzALVJh
         JN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=c0dbKsIdJk+qHikmULBiKTfiJVqKnwC4QHGDZyjez5c=;
        b=I6vhTmCN4GEx45KK8vcLj6+JfYloFK7wtkQGjdQCwzp35P+vBWYOm7Mtm8bWckfJOa
         bkJ8Jh8UlC6tqVuGWS8JAvFNWtP7sjQaoabcOVGX5bopO5fNFEUJpB3194yztasvS1nj
         JDzveIMcUEH0I2C3NsMUwOPdabtAoKYizALX/hD9QRscKDPrRk2E3YdCd64xKsSH+ciP
         TZKcmSiEu2veg7VPovp1gwYSQ3EyG629Znev9cutNI6oOl6QpOwk753VaQQa/NKi+Vrt
         Vuw/VUgaXwFpc7JaZikCek7YYJhEsbBSqE52WleE3POs6YOmnVBXvvqn+D6j0UhaFXzw
         WfaA==
X-Gm-Message-State: AOAM531qVTfOpBshC65y/D1nLSt04V9mHqzy8hM4mbUUOEFcJhayOK6M
        uQOU/AGjOQIaOR2quoFqHhz3rTOXzL8How==
X-Google-Smtp-Source: ABdhPJz3IEoUnP+YY4bGnTx41NXJkSuyhuQFFA6sFxSnDvKBjPMaNwdb8qpS6y54oVGPkAvATMxVOHwB6qwIAA==
X-Received: from shakeelb.svl.corp.google.com ([2620:15c:2cd:202:6e75:6cb3:9d81:deae])
 (user=shakeelb job=sendgmr) by 2002:a17:902:860a:b0:14b:341e:5ffb with SMTP
 id f10-20020a170902860a00b0014b341e5ffbmr26428871plo.6.1646158160480; Tue, 01
 Mar 2022 10:09:20 -0800 (PST)
Date:   Tue, 1 Mar 2022 10:09:17 -0800
In-Reply-To: <YhzeCkXEvga7+o/A@bombadil.infradead.org>
Message-Id: <20220301180917.tkibx7zpcz2faoxy@google.com>
Mime-Version: 1.0
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com> <YhzeCkXEvga7+o/A@bombadil.infradead.org>
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices
From:   Shakeel Butt <shakeelb@google.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vlastimil Babka <vbabka@suse.cz>, NeilBrown <neilb@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 06:36:58AM -0800, Luis Chamberlain wrote:
> On Mon, Feb 28, 2022 at 10:17:16AM +0300, Vasily Averin wrote:
> > Following one-liner running inside memcg-limited container consumes
> > huge number of host memory and can trigger global OOM.
> >
> > for i in `seq 1 xxx` ; do ip l a v$i type veth peer name vp$i ; done
> >
> > Patch accounts most part of these allocations and can protect host.
> > ---[cut]---
> > It is not polished, and perhaps should be splitted.
> > obviously it affects other kind of netdevices too.
> > Unfortunately I'm not sure that I will have enough time to handle it  
> properly
> > and decided to publish current patch version as is.
> > OpenVz workaround it by using per-container limit for number of
> > available netdevices, but upstream does not have any kind of
> > per-container configuration.
> > ------

> Should this just be a new ucount limit on kernel/ucount.c and have veth
> use something like inc_ucount(current_user_ns(), current_euid(),  
> UCOUNT_VETH)?

> This might be abusing ucounts though, not sure, Eric?


For admins of systems running multiple workloads, there is no easy way
to set such limits for each workload. Some may genuinely need more veth
than others. From admin's perspective it is preferred to have minimal
knobs to set and if these objects are charged to memcg then the memcg
limits would limit them. There was similar situation for inotify
instances where fs sysctl inotify/max_user_instances already limits the
inotify instances but we memcg charged them to not worry about setting
such limits. See ac7b79fd190b ("inotify, memcg: account inotify
instances to kmemcg").
