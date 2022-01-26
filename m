Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112D049C731
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbiAZKN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239718AbiAZKN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:13:28 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46738C06161C;
        Wed, 26 Jan 2022 02:13:28 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m11so68147256edi.13;
        Wed, 26 Jan 2022 02:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7of4j6tXJsQTj96IqMsKqWsSKbGVqn3ZKiSJTHPl75E=;
        b=QHZGNvAuvGw7dVgE+zNRdndvuugGnChjIbsMvjjz/ITotAgWGyNwZuN48EXCo8az5D
         RWQMdAopz5nv/RRobC4VoRcuLtfo/RrKWSAUysAnG5W/5/9h/OvMXETCBuAkEbn4m9Vh
         ZRKNjulT52tFSx8jl00TJVZCKzHeKwvhagWm2XuDHHRI67mQUHyXyGjJwC3tgnpudBHK
         CUPg3gPeW91RE8SwaJcaX/cvKSHU6keIf7UPLJbzDiBXtJyAMK7gupAvOKDHHEKJh+F3
         9WpCas3I2OiV7CjbJWwV6SnsGTJS7yhn6+3ULU7z0WtzzLGHTl8R51wyt+Vu1KuStZpj
         M64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7of4j6tXJsQTj96IqMsKqWsSKbGVqn3ZKiSJTHPl75E=;
        b=q1t0IviRPdFarPCBKA6U2xj6mBJiT6/hkdmgmCzxQKFsawbX/M0vG0rjTq5HD+I2W+
         ia3c+IpAySABXPFubpGx+oRXKZ7oJwu8t6nDNNeUl2SQDUN3SPVS4hQ0sRJDeENsoMN3
         K0iLU32WBYSU0CJ3rkrUFFZ+F5QD1OOAtn7cFdtRHUxQ4dhYJfWVJIn6i6av178vpWxo
         yfzchJEsO8ykrCFMF37LTtfFY8NVyVjicfBZ18oAniEwf7hoASBlG6jYtzK22Liqa6Yk
         nv0BCb+by6r3zrD5QCEBRxXl9G+IqIuOghodF32XToMubmldX5p41Q85KouMbdHaUKkU
         yeyA==
X-Gm-Message-State: AOAM531yvUun8sq+fjOqHIVTWroyMwgHzkm38qVeJCJ0zbcAnyVUARI4
        AiZR8LwIuRlYeFrdPq2J9HQOwRkm/RTSDHbhaNI=
X-Google-Smtp-Source: ABdhPJynLKvQGv/H0FG+uuXI+OlMGiphzh5iPLeSuydUEWE4P8tlRcmMs/osAZq4tj+XuWR5dY63TLHMcK+DIJhiiao=
X-Received: by 2002:a05:6402:35d5:: with SMTP id z21mr17032960edc.29.1643192006805;
 Wed, 26 Jan 2022 02:13:26 -0800 (PST)
MIME-Version: 1.0
References: <20220126093951.1470898-1-lucas.demarchi@intel.com> <20220126093951.1470898-10-lucas.demarchi@intel.com>
In-Reply-To: <20220126093951.1470898-10-lucas.demarchi@intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 26 Jan 2022 12:12:50 +0200
Message-ID: <CAHp75Vd+TmShx==d_JHZUu0Q-9X7CmZEOFdKnSrcRKs81Gxn3g@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] drm: Convert open-coded yes/no strings to yesno()
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>, Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:39 AM Lucas De Marchi
<lucas.demarchi@intel.com> wrote:
>
> linux/string_helpers.h provides a helper to return "yes"/"no" strings.
> Replace the open coded versions with str_yes_no(). The places were
> identified with the following semantic patch:
>
>         @@
>         expression b;
>         @@
>
>         - b ? "yes" : "no"
>         + str_yes_no(b)
>
> Then the includes were added, so we include-what-we-use, and parenthesis
> adjusted in drivers/gpu/drm/v3d/v3d_debugfs.c. After the conversion we
> still see the same binary sizes:
>
>    text    data     bss     dec     hex filename
>   51149    3295     212   54656    d580 virtio/virtio-gpu.ko.old
>   51149    3295     212   54656    d580 virtio/virtio-gpu.ko
> 1441491   60340     800 1502631  16eda7 radeon/radeon.ko.old
> 1441491   60340     800 1502631  16eda7 radeon/radeon.ko
> 6125369  328538   34000 6487907  62ff63 amd/amdgpu/amdgpu.ko.old
> 6125369  328538   34000 6487907  62ff63 amd/amdgpu/amdgpu.ko
>  411986   10490    6176  428652   68a6c drm.ko.old
>  411986   10490    6176  428652   68a6c drm.ko
>   98129    1636     264  100029   186bd dp/drm_dp_helper.ko.old
>   98129    1636     264  100029   186bd dp/drm_dp_helper.ko
> 1973432  109640    2352 2085424  1fd230 nouveau/nouveau.ko.old
> 1973432  109640    2352 2085424  1fd230 nouveau/nouveau.ko

This probably won't change for modules, but if you compile in the
linker may try to optimize it. Would be nice to see the old-new for
`make allyesconfig` or equivalent.

...

>         seq_printf(m, "\tDP branch device present: %s\n",
> -                  branch_device ? "yes" : "no");
> +                  str_yes_no(branch_device));

Can it be now on one line? Same Q for all similar cases in the entire series.

-- 
With Best Regards,
Andy Shevchenko
