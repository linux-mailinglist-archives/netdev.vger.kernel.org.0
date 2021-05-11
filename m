Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1B337AC90
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhEKRCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhEKRCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 13:02:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31F7C061574;
        Tue, 11 May 2021 10:00:54 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pf4-20020a17090b1d84b029015ccffe0f2eso61627pjb.0;
        Tue, 11 May 2021 10:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fmFyHNnUFHNuAVxbIzn7lHV9kvhWQzN1eSc9Pbf0XcQ=;
        b=myLkImHXOezSotuuATiOAEM8rI4bn/KntJijmRm0HOQeeHwV6aTGsPD7nv0BjqQoH1
         3L+W86p3VkFFKF1vCivgZ0qDY4CZ1J9P3bAUYxierHIchWRD2cjkCBTXhAgs0oZtHK8E
         f/zSe/dcSO79CEJDcjuxvyV9AGAixNGBTyGehW/EyGOmO0qoxUzxVIjKjJjsRpCsvrQ9
         IV3J4d5IfaH/91hgpUNr80AqexKcSdABwYoGz4zngIkqisK4mcn4V+nSvrjZZiEkbJ8E
         Fn4f9Ons6kvYNmL5aBZXFCVScrB4uAxETd2UTttxRQkelZq+5WueHFxRmL/wJTjHalaa
         8+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fmFyHNnUFHNuAVxbIzn7lHV9kvhWQzN1eSc9Pbf0XcQ=;
        b=IsVTMCSuMqkmPVbsCD2aJ8YL0F+ALfSvNBf+NKPxq6cKEAr/91CFox6niXjCIS4S5O
         afq76FHEzNdEw3ko5L7IGo2oqbFitZw0aCWLH/ERQfHr+6Uj/oYFOdgxBLIdSOkTC2GS
         DJe4ub/kjhXoHFdn+mHePun7I7NPyGugMrdE9NerE/+9vPtv0XzGHIObEYSpCTGFIjWc
         +HW01eboF5/NGsFBl5pjS2WKfaDiZAOje8M828T3gRBCr1XRIclemAc7pmdWHETBUpcC
         /QNblQlRb9BvuxkSpIV7PeDM9U9yWebPwh7YN5C9yxAVyaRbfmFS4Eqwg4cmQ7SameAg
         W5cQ==
X-Gm-Message-State: AOAM531BYROJYmZIwGDM0dN0F4H5+I2qANq5T9EpWqHOxtQ+f/xGI+3b
        m3o/ZcGgiP9gkVVGrcx32XlXTSV7b7cDtER86/c=
X-Google-Smtp-Source: ABdhPJzmu1ezMUQi6YlVmGSO8GpWvroaYz0PCIlp5rMRht3gY+s4xQHOXqACOfoh44yUmzfbgFNkExgUPr7+XNncE0c=
X-Received: by 2002:a17:902:10b:b029:ed:2b3e:beb4 with SMTP id
 11-20020a170902010bb02900ed2b3ebeb4mr31789999plb.64.1620752454532; Tue, 11
 May 2021 10:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210511113257.2094-1-rocco.yue@mediatek.com>
In-Reply-To: <20210511113257.2094-1-rocco.yue@mediatek.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 11 May 2021 10:00:43 -0700
Message-ID: <CAM_iQpVWSJ8BdRoLDX0MdiqmJn2dp+U9JM4mcfzRbVn4MZbzcg@mail.gmail.com>
Subject: Re: [PATCH][v3] rtnetlink: add rtnl_lock debug log
To:     Rocco yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 4:46 AM Rocco yue <rocco.yue@mediatek.com> wrote:
>
> From: Rocco Yue <rocco.yue@mediatek.com>
>
> We often encounter system hangs caused by certain process
> holding rtnl_lock for a long time. Even if there is a lock
> detection mechanism in Linux, it is a bit troublesome and
> affects the system performance. We hope to add a lightweight
> debugging mechanism for detecting rtnl_lock.

Any reason why this is specific to RTNL lock? To me holding
a mutex lock for a long time is problematic for any mutex.
I have seen some fs mutex being held for a long time caused
many hung tasks in the system.

Thanks.
