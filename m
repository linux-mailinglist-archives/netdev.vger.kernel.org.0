Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54157497BF9
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 10:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbiAXJ3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 04:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiAXJ3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 04:29:38 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C1FC06173D
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 01:29:37 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id a18so55289004edj.7
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 01:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oC9HNsvbmipJaI7/3GLC383YFKywT6rDBqGjOn8JyvI=;
        b=nZAt5N2Jo6rWor+1/pb5P5RoORYE/ctNCULwQTr5Jjvv+zSvAW7uxDnILVSXZZ1RaV
         a7Zy/arNWBNllHfyoR5RmOie573vjoA5hzkuGzzAxYPu3wZbBDiOA7YW6TWgiKpmvDT9
         fOI3Abq7XW7NvzAxv1QQ6uK9+BHwo4vCTQqhteysaA6oyqT9BINS2i04Iac888Ul7vuC
         0zk2zmKiviRk6ZPAitr5GBCsEueY3KylmDSsiwlvrYOfUZKZHgrIT/xEWgxIwhdBDTQO
         7ROp5m5paj9moyiPbYXY3PY6yL0y6inwtFEmNSOb7nMkmbeVMy6i1+OSkLgt7IQH5+En
         sKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oC9HNsvbmipJaI7/3GLC383YFKywT6rDBqGjOn8JyvI=;
        b=RmM/od3ceOxyPrwI2FOAg+nGZb7RK53YcEgFvKB2TDQb6UIYVe3XDAszl/A+51gjTX
         ZnPbJp5v/kjzGfN+wo/eIpceRv5PUiufQNa5RrCMd5+tBm7er5V+6aU2LiR75EocYXky
         7ZBAXIAds/VwwFpaUHptsQYtaY91kP0vV2wjao2vkCeeLzcnA0anQ3At4tEdyAZ1kx/b
         tcWzDbs7v29fcyVbFhr/aPnim/kILlfwlLzT+LhMOUepjz4BKBq+Qh1uewuCSSEIEpap
         eil8viQ7eyJZqIqCdm4Gu2B6iVKLHNhCRbDAO1yyTFVQZ0ZA+8hT9dbOskA07KoTU8A4
         VF/A==
X-Gm-Message-State: AOAM532JaF9NW8X+K+btGVFJSjUF4Osjh5CgRLxZAGOslm/SraQ2wKY2
        OsPSkPyD063wx4OvsD12Baxr3g==
X-Google-Smtp-Source: ABdhPJz/dWRJH3zsAQEGgsKWGUG7d9kYAfxghvUOyOChDrjndARlY2TJM66H2aMRp2nhXORS1trhmA==
X-Received: by 2002:a05:6402:5190:: with SMTP id q16mr15192181edd.157.1643016576173;
        Mon, 24 Jan 2022 01:29:36 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([104.245.96.239])
        by smtp.gmail.com with ESMTPSA id cf25sm3175786edb.63.2022.01.24.01.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 01:29:35 -0800 (PST)
Date:   Mon, 24 Jan 2022 17:29:28 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Subject: Re: [PATCH v2 0/7] pid: Introduce helper task_is_in_root_ns()
Message-ID: <20220124092928.GA1167041@leoy-ThinkPad-X240s>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20220112064046.GA3316542@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112064046.GA3316542@leoy-ThinkPad-X240s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 02:40:47PM +0800, Leo Yan wrote:
> Hi David,
> 
> On Wed, Dec 08, 2021 at 04:33:13PM +0800, Leo Yan wrote:
> > The kernel uses open code to check if a process is in root PID namespace
> > or not in several places.
> > 
> > Suggested by Suzuki, this patch set is to create a helper function
> > task_is_in_init_pid_ns() to replace open code.
> > 
> > This patch set has been applied on the mainline kernel and built for
> > Arm64 kernel with enabling all relevant modules.
> 
> I'd like sync for how to merging this patch set.  Except patch 05/07,
> all of other patches in this patch set have been received the reviewed
> or acked tags.  So could you pick up this patch set?
> 
> Furthermore, we have another patch set "coresight: etm: Correct PID
> tracing for non-root namespace" [1], which is dependent on the current
> patch set and it has been Acked by Suzuki.
> 
> I'd like to get opinions from David and CoreSight maintainers Mathieu
> and Suzuki, should we merge the patch set [1] via David's tree as well
> to avoid dependency issue, or prefer to merge it via CoreSight tree?
> If David prefers the prior option, I can resend the patch set [1] with
> looping David.

Gentle ping, Dave.

I verified the current patch set and CoreSight patch set, both can apply
clearly on the latest mainline kernel (with last commit
dd81e1c7d5fb "Merge tag 'powerpc-5.17-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux").

Thanks,
Leo

> [1] https://lore.kernel.org/lkml/20211213121323.1887180-1-leo.yan@linaro.org/
