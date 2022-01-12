Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09C48BEA3
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 07:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351014AbiALGk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 01:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiALGkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 01:40:55 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C640C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 22:40:55 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id k15so5650835edk.13
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 22:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j6hbyKol68wFX5iiymhuEQsHgpNKkmkI3FMm7bj3TOM=;
        b=DEtq4nScoRmZpHDPIBFDzULWTmc5oEnWu0HWl9mQoRoTBM/ad+z67adCChiy1HP+pi
         Mjg76DatHzF73HgPRTkNFeVunycvIIrnPHK779ME6ig3sk4t9yTZcHn++pQulQo1u6Og
         DbWzyLfYG5f49VrhQgdqFb/MuIFgl/WUeFAQTGJl/LFgzVifoBOEP2obm0yPedSGnpyp
         Pq5ybK7XZ5Da8x4DaO5dOZmka175e9kebZLXISJdscKlODyPDME40gTkt+O3Uk4IFQx6
         zVUXDFXfWJ0mE6jE2Jmx7lUJt1hQmAE/k2d9KoTKwEwgt8g5+h/xsBMjs4qSLFRHaPwu
         IdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j6hbyKol68wFX5iiymhuEQsHgpNKkmkI3FMm7bj3TOM=;
        b=xmy2wY7rcRocOjP4a7tcX3eX/rkZQx5Gu9bW/b8u+NQQlnF99PRULc/h56eyTcJSay
         jDJifudiJWlx9xhvstaHXXM1Sb1ovW/vKnwj1X17Qa9mR9WeuC6sl1/c0t4lQOr2RW1+
         1BjknvlOvVrWQERteUigb0dp6YKT8mwBrexOXe0h/zdhDYJz0UFTx3A6W0uu8vIefsC6
         pVpeW+1S1twlRTgE0oAIYyF8DkjzKOFougogILBGBwLicMF8sLsITNtkfqBmYpmQ2xlP
         qTu9Cuys+/HdClwinUEeY1SCQD6L1vxZeqmSbuTWT6Z9Fv7KJwnTmAhdQXYamCzSHhdn
         hUBQ==
X-Gm-Message-State: AOAM5308mRdhTsBa23dy3trLAR9iyKE1HBwVn8KX6vujIR+ezQmJ6m/Y
        U2ETVNDSzpnHjFd6+ABLA/M3wg==
X-Google-Smtp-Source: ABdhPJxFACxwQqohWAwzNyIFzdza3Go5zCu+23kAyqd4VttcVfMxPX4biC1GqarDCqok0lezkQ4qEQ==
X-Received: by 2002:a50:d6d5:: with SMTP id l21mr7486410edj.69.1641969653736;
        Tue, 11 Jan 2022 22:40:53 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([104.245.96.239])
        by smtp.gmail.com with ESMTPSA id ck3sm1892109edb.36.2022.01.11.22.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 22:40:53 -0800 (PST)
Date:   Wed, 12 Jan 2022 14:40:47 +0800
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
Message-ID: <20220112064046.GA3316542@leoy-ThinkPad-X240s>
References: <20211208083320.472503-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208083320.472503-1-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, Dec 08, 2021 at 04:33:13PM +0800, Leo Yan wrote:
> The kernel uses open code to check if a process is in root PID namespace
> or not in several places.
> 
> Suggested by Suzuki, this patch set is to create a helper function
> task_is_in_init_pid_ns() to replace open code.
> 
> This patch set has been applied on the mainline kernel and built for
> Arm64 kernel with enabling all relevant modules.

I'd like sync for how to merging this patch set.  Except patch 05/07,
all of other patches in this patch set have been received the reviewed
or acked tags.  So could you pick up this patch set?

Furthermore, we have another patch set "coresight: etm: Correct PID
tracing for non-root namespace" [1], which is dependent on the current
patch set and it has been Acked by Suzuki.

I'd like to get opinions from David and CoreSight maintainers Mathieu
and Suzuki, should we merge the patch set [1] via David's tree as well
to avoid dependency issue, or prefer to merge it via CoreSight tree?
If David prefers the prior option, I can resend the patch set [1] with
looping David.

Thanks,
Leo

[1] https://lore.kernel.org/lkml/20211213121323.1887180-1-leo.yan@linaro.org/
