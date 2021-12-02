Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A72465DFE
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 06:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355337AbhLBGAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 01:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349726AbhLBGAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 01:00:54 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03254C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 21:57:33 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v203so70311979ybe.6
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 21:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1XLkOMX+6T+VTGVoPTNEyS5cbg1UXxxrXM5PlwQs20=;
        b=dGZoi4CbMnVnPexpZND4nAaOnTmXstu0BmW2qE6bLoyGr00RbxvcjO7aa8vK1m/lin
         R2BVeaQCi/zIcfZppXzaJlgYgl90QvEew5VPWPO4gnJX9oL5CxstvK0k/Rduacq3lpb2
         8ilSDtmeLbG6kBvh/Y44K728REkT1NLf1HW32ypXS0WNAtVd5mawSNs2dl6Npb0l5w7l
         2gXg1iHWsPBIBwTYOXDu4D83C+xR1ejhYJracZOmJz8hI16kyLqNCmvNevOhkDnSfrfa
         SRINQp15+WiOB5Dj7/dkIl8kYzmwTdZsmGAm8rP7EWBpaI/N0CqL21OsQKwqwz41wMNj
         Bcbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1XLkOMX+6T+VTGVoPTNEyS5cbg1UXxxrXM5PlwQs20=;
        b=3I6Cj24x5B1sKZGO8g7tE16d4olFlVxXLyqASz5hmsL4Pt1kCQ48a+PAd6ZkEJIaN+
         wqg45ldse3RBPcWOQhxTBVdp1Vfgsp/JU45ilOgcTGHuDWcr/AGYL5ceIuH0m/VQLz4I
         SVGxg6vV+AzqIP3q/r6xlyYIKKiI73HX/cmfn2SgU5IvZaAm2+Qd5IipWJQU84V0FuH+
         p3ylClPLNSLoCt/kVsYRMcCH0QnUAwElOUI573Mm1HHaGTJ9mJpo/WyLEdifTP9lpaDo
         1dnL5bcdYyVZ7QwrlkxogRSJpElb35QxkoPlTo6Y0W3ovIZxRlJVFZJpYjpDV5cVC872
         FS4g==
X-Gm-Message-State: AOAM533yXjIhNBwG78WZOrfTt5SkDFRb7KXZ2ZqZbYhOy0YgcYXbND4B
        g5ozg/m5hVLVGJuWeW/kaxDFAuB9500ZUWovt+4z9auSZHNzXg==
X-Google-Smtp-Source: ABdhPJy1kpg6Bm4PWfmzLmchHCp6WXsELJ2/VIxtrNBXr6BR/z1bSakQZlQiX8xjJrd2MesdzY4iuG/cpeSkAOR28EQ=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr13372989ybt.156.1638424651810;
 Wed, 01 Dec 2021 21:57:31 -0800 (PST)
MIME-Version: 1.0
References: <20211202032139.3156411-9-eric.dumazet@gmail.com> <202112021345.IlporM5t-lkp@intel.com>
In-Reply-To: <202112021345.IlporM5t-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Dec 2021 21:57:19 -0800
Message-ID: <CANn89i+n4RAywMtDVy8ffwt0uk3PHnwWVVprsqQiA-cPDzYdxA@mail.gmail.com>
Subject: Re: [PATCH net-next 08/19] drop_monitor: add net device refcount tracker
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

On Wed, Dec 1, 2021 at 9:41 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8057cbb8335cf6d419866737504473833e1d128a
> config: nds32-allyesconfig (https://download.01.org/0day-ci/archive/20211202/202112021345.IlporM5t-lkp@intel.com/config)
> compiler: nds32le-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/6b336d0b301ebb1097132101a9e3bd01f71c40d4
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
>         git checkout 6b336d0b301ebb1097132101a9e3bd01f71c40d4
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nds32 SHELL=/bin/bash net/core/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    net/core/drop_monitor.c: In function 'net_dm_hw_metadata_free':
> >> net/core/drop_monitor.c:869:47: warning: passing argument 2 of 'dev_put_track' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>      869 |         dev_put_track(hw_metadata->input_dev, &hw_metadata->dev_tracker);
>          |                                               ^~~~~~~~~~~~~~~~~~~~~~~~~
>    In file included from net/core/drop_monitor.c:10:
>    include/linux/netdevice.h:3863:53: note: expected 'struct ref_tracker **' but argument is of type 'struct ref_tracker * const*'
>     3863 |                                  netdevice_tracker *tracker)
>          |                                  ~~~~~~~~~~~~~~~~~~~^~~~~~~
>
>
> vim +869 net/core/drop_monitor.c
>
>    865
>    866  static void
>    867  net_dm_hw_metadata_free(const struct devlink_trap_metadata *hw_metadata)

Yep, I have removed this not really useful  const qualifier

net_dm_hw_metadata_free(struct devlink_trap_metadata *hw_metadata)
...


>    868  {
>  > 869          dev_put_track(hw_metadata->input_dev, &hw_metadata->dev_tracker);
>    870          kfree(hw_metadata->fa_cookie);
>    871          kfree(hw_metadata->trap_name);
>    872          kfree(hw_metadata->trap_group_name);
>    873          kfree(hw_metadata);
>    874  }
>    875
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
