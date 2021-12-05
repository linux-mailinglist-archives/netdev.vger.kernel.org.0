Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAF14688C8
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 01:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhLEAtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 19:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhLEAtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 19:49:12 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D73C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 16:45:46 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id d10so20778127ybn.0
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 16:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DiyTjuAJMDVGKnngys2c606YYNCs+9tJw8ro15Pr+kA=;
        b=nZuAMHMhByZmNBqgOi+1+wFJAKbV1hD9CIZNRaV0OCxlQuwjBNXlTXPxLUksugr3yH
         YtILvnbWUA5kep4dvaHo2kw+iBdih4dC7lFr4VKQBqSHIkWO+3SLMT0vCrhYDVWkTrza
         y1rEyO2DF2VSPOyU4c1yKKn/KMDRXXGbpl+QNY2a22iI5FrPACEn0xqBry9VULiC0ke6
         1Q45niAti7xOxkXMejOjngdd+9hd98EwnDLTxoE2mQp6PTxXdOOs6BzZeL8TYhGMrjnm
         zyrnn5Q63r1IRoKHoVqGdW7YUh6EUTQat9Gk7SaNnj5F2JqGIEvJtyEdfDjtyyuyVIZp
         TbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DiyTjuAJMDVGKnngys2c606YYNCs+9tJw8ro15Pr+kA=;
        b=KwzrG47xsDInzsfojnHKlCAPXipPhTwAN6zuFTp+wee2Dl4A0MKHv1dMqOh/o4fVOs
         h7yOJp7cNl/quUbujX847yPEXVvedr4aQ17G1JnPmvdTaHIGppcNfP5n1HoEcO605APk
         60fKjcqFmJsFXhiGjlw0Ec1Zp9V7fH/G3h6xaXR8hBKcSiRMSdfce+0kYr6MUY78H55q
         DDEp53FAXMaQC8jneWm4DZ/ihZtCLs4fMX+oSwDbUSNyUSx5iCn7oYYFrtA+Nnihtrbr
         jD1RrdgGsUclqgZ688lQ/4SqKoYtGI/FB5y3/DSv34la8n0rsxbUFtH7b5gig7+1Lp1+
         fVTg==
X-Gm-Message-State: AOAM532beDJLlPjftxOfHTquD9HLVaak4cdmUpU1kbJElGbDHPTUvIUF
        ORMbKqzX4SayhY6aVG8LeuzkaVhvbV2rYjKV4IS82tfjh5U=
X-Google-Smtp-Source: ABdhPJxlVxVDaqjJd+uIA4Orp9lN8uQh4ChCS1v/yoj86vsBlkvzKlW9kM4KBbXQ1BsUvmM5uklgVhUZjfKoLXB8aqU=
X-Received: by 2002:a5b:5c3:: with SMTP id w3mr14257358ybp.293.1638665144839;
 Sat, 04 Dec 2021 16:45:44 -0800 (PST)
MIME-Version: 1.0
References: <20211203024640.1180745-3-eric.dumazet@gmail.com> <202112050729.hISLa0oF-lkp@intel.com>
In-Reply-To: <202112050729.hISLa0oF-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 4 Dec 2021 16:45:33 -0800
Message-ID: <CANn89i+q3S-TrqFS41_3Fo4_tckjWKRQoqCRvBXBxMjLaN-5Nw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 02/23] lib: add tests for reference tracker
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 3:40 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211203-104930
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git fc993be36f9ea7fc286d84d8471a1a20e871aad4
> config: nios2-allyesconfig (https://download.01.org/0day-ci/archive/20211205/202112050729.hISLa0oF-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/98ad7e89138f4176a549203b6e23c2dc1cb9581d
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211203-104930
>         git checkout 98ad7e89138f4176a549203b6e23c2dc1cb9581d
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nios2 SHELL=/bin/bash
>

I tried following these instructions, but this failed on my laptop.


> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    lib/ref_tracker.c: In function 'ref_tracker_alloc':
> >> lib/ref_tracker.c:80:22: error: implicit declaration of function 'stack_trace_save'; did you mean 'stack_depot_save'? [-Werror=implicit-function-declaration]
>       80 |         nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
>          |                      ^~~~~~~~~~~~~~~~
>          |                      stack_depot_save
> >> lib/ref_tracker.c:81:22: error: implicit declaration of function 'filter_irq_stacks' [-Werror=implicit-function-declaration]
>       81 |         nr_entries = filter_irq_stacks(entries, nr_entries);
>          |                      ^~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
>
> Kconfig warnings: (for reference only)
>    WARNING: unmet direct dependencies detected for REF_TRACKER
>    Depends on STACKTRACE_SUPPORT
>    Selected by
>    - TEST_REF_TRACKER && RUNTIME_TESTING_MENU && DEBUG_KERNEL
>

This seems to be a bug unrelated to this patch series.
