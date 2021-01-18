Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9C12F9E2B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390020AbhARL3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390149AbhARL3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 06:29:22 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D40EC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 03:28:41 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id b5so6750890ejv.4
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 03:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fAaRAz1s6ISuvWfpc/CM0hm1p72eaR/yydUCAYk4p4M=;
        b=towgGykZquAAw+TuUvmH7itCbiF599F4zJmGgYMXLB+eeNr+J/BZKPlKGgagepx8Gn
         fcFDS/WlQG7P9T2WMJfmHgJwBDhnaEVcu0cY+hYwiO29Hrp4NtfH89pRtJCFWGdwzOOD
         4zLhXa7m4KKJGgBFLS/xkx6T3qTkX5kYktqSzQNRHgpeY4QQ+whxGiFnV5hDJ0syl0As
         s5c79xmCv92HDiFmoZfPw2yKuttF3GwX1sfejVHDHq30XmqHkc09cqOv6a41rCEJ3vfn
         UhBa1ASEhCOHeVWjcapsXIB/scM4iwu6MVwv4NP2EQfwOT9TTUEKpWsKlwB1PF4Mi1BW
         l11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fAaRAz1s6ISuvWfpc/CM0hm1p72eaR/yydUCAYk4p4M=;
        b=h9HeFVIYE6p5A1rhB9F0V/VE+Hogqh1YwaMXvMqXDlT9n6bwzGJ6i4xh57BrIej8E0
         wnUStj5HtfoU8mLdc3V+vVQxSJyPIWZ0eIDdYGdv8uA7vQQ+EG3Ldhb7esxQ4mmBZmcw
         RjVwZW2E9a+VxeSbFzRNk/vNdw8M0LREuZBIztbrs7iTra8c4//jYjZ/fJbr+cWnFiTR
         wnT9JTwegebH882bDdBrzERDKVBbHlzyS8VH13m34hYr4z3i9pz7DMvVk4aqGfns67iG
         Yi07DZ+6sMioyRA0bOg4Yz6Ht97LuPB6DYvPeyIsnQFba2NiPwSvz9qMth2cxr2QU1vM
         e2Rw==
X-Gm-Message-State: AOAM5300FCzsDzut0ecr9p/5Rel2tGO3GzN1+eE4DrCVFJHKhY42ktnj
        c27rSLxb9OO8Na0MgetJ4+8=
X-Google-Smtp-Source: ABdhPJzky9udJ2GF/U+vzMt692daUILWI2N57ZdAf/3jCxGfFzdnunqGsRp7gS0RcDQLJu7pVcSCvQ==
X-Received: by 2002:a17:906:6053:: with SMTP id p19mr17305581ejj.93.1610969319996;
        Mon, 18 Jan 2021 03:28:39 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ce7sm922930ejb.100.2021.01.18.03.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 03:28:39 -0800 (PST)
Date:   Mon, 18 Jan 2021 13:28:38 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, netdev@vger.kernel.org
Subject: Re: [RFC net-next 3/7] net: bridge: switchdev: Send FDB
 notifications for host addresses
Message-ID: <20210118112838.xanyhn5bh2um2cnn@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116012515.3152-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 02:25:11AM +0100, Tobias Waldekranz wrote:
> Treat addresses added to the bridge itself in the same way as regular
> ports and send out a notification so that drivers may sync it down to
> the hardware FDB.
>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

What is the functional difference between a bridge FDB entry which has
the BR_FDB_LOCAL flag, and a bridge FDB entry with a NULL fdb->dst?
