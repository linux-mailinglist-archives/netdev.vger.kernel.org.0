Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E106366266
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 01:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhDTXQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 19:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhDTXQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 19:16:54 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326A2C06174A;
        Tue, 20 Apr 2021 16:16:22 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id r12so60752291ejr.5;
        Tue, 20 Apr 2021 16:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5OPpZ1Zy/OjC2Shxj539LsgrLZzcMTLd2OcL5QqrLrg=;
        b=WoQtHkFCnP9lgqJOhpdEZEEpPgVBz9iZm4EQ0ILLc6bgcg25h6Q3vf/303TqbeK+Aj
         myyMMXKDfg65ZsJnsB2CWLNNpQyC2CuXphQU3YO9UjEzt8bMAoU0RYE0qq/hsYGDE+j0
         oqp9/lU0OzI8ZmlP7hnJCOKQ4T4gge2Jb/ASTFjFZwbMQ0XMHT/8J5qDADKy+7aB0lJk
         /dSgOM4+kfRHgdnO0BLKh14u00DMU4W+zJ72hlK5DzirDE1Knd+5IOfRYXhW0EsjsH3b
         Snk872oijkQSQ4zO/MwuJ8AQE2RqZgxawZKRXKcaRZ+qXqF8zXusJ8nyGLsG2bClBoE2
         e/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5OPpZ1Zy/OjC2Shxj539LsgrLZzcMTLd2OcL5QqrLrg=;
        b=EG9BSqULGtShcKMrfXSU5jdbHCcHDMLhEK9SrdtQNERrKxiJB8LB/jItqfw3R5EYhz
         7g2kXJ4Nhq7R+wjkhcV8lKMKL3ZC42luHLmsPdMy2Ul5GIeVd8MOcYqzhHZJ739SWCZd
         3TutbGJfUrUvJDyW41oPL+UZLQCCcZX/aFlfN9JYQRQ+MdQLN5BxQZNqxWVsQ1xTuuXZ
         deP+5qf6d/tp2H9AAOAibE+Eu81cOh+QpZ0YmOD+gLPt6y87TvqHb/rMBGTQdlp6FyJB
         Jb5bwlQHH9vtvghsuILy7QiZZih+su5ELCE9665jgwJHrp6WTSEHv79SFn1+3c6SKj6H
         6PVA==
X-Gm-Message-State: AOAM530xiA2HQsxU7bKhc+9j0AhFQeWqOXw1xcYMxbDUziURlAkkq9Kc
        XzOtUqgsnL4ViBb9mGfRjBU=
X-Google-Smtp-Source: ABdhPJw+n6BcjZtyxbUxf07KCUNBXZuSePiLI97Egxp+CH7XqHqTM9Y1lCLFnuTA6ZTEuZph8VGF5g==
X-Received: by 2002:a17:906:f6c1:: with SMTP id jo1mr29057085ejb.262.1618960580883;
        Tue, 20 Apr 2021 16:16:20 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v4sm322725ejj.84.2021.04.20.16.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 16:16:20 -0700 (PDT)
Date:   Wed, 21 Apr 2021 02:16:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 4/5] net: dsa: Allow default tag protocol to
 be overridden from DT
Message-ID: <20210420231610.zrmzuse22z6nvkbq@skbuf>
References: <20210420185311.899183-1-tobias@waldekranz.com>
 <20210420185311.899183-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420185311.899183-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 08:53:10PM +0200, Tobias Waldekranz wrote:
> Some combinations of tag protocols and Ethernet controllers are
> incompatible, and it is hard for the driver to keep track of these.
> 
> Therefore, allow the device tree author (typically the board vendor)
> to inform the driver of this fact by selecting an alternate protocol
> that is known to work.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
