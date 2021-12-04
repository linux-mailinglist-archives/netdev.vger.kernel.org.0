Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392C1468242
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 05:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377070AbhLDEob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 23:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354740AbhLDEo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 23:44:29 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF57C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 20:41:04 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v64so15287102ybi.5
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 20:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wNH3pQf2JZks2q0D2lXI4TJY+2V/uMjbyN+HF+gLoFo=;
        b=CYEnNt7Ojl6fiYjint5fQb/xWBaAnOoI+snGZUGmJDGxkTMFDe/wJwXZb/zdECtiJ3
         2hr+BjKa4ulYlVAthoJf5X6H0cfTpHCA8eqOmhwK0/eEmoDPcVS8xc4vxct1BpZmS6XF
         XHUaHTfDBXnLMPm018VsEhS/62HzPRkKAhSG6eWrrbukcsAFfQ7LEtE7nEyxN4HdS4Uw
         11Kd52T2OLikrgZgyioawouqZMajN4JGOh8EIyj623Vc32lsKYc6JtENLckIaHCLvx4s
         taB7t4M+vyJ+U37jAJdWCv9Tyq+Bm+kqaVKNynhYrY4So4XswhFouK0uX4GJEyvLQT1j
         zWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wNH3pQf2JZks2q0D2lXI4TJY+2V/uMjbyN+HF+gLoFo=;
        b=pC+mfAUGZds0/1aaBVgSZmUp5sbvlby2pfFSFLwcx+yOm5u7n4fHioDEstTee7ocxy
         afyIMABs0GEBuV7cLmcQBt46fypHWKybN3bTAqLy0fDg9Z151HIe/gTSTn0gn6807uV8
         EbTPlt4qLZvAu4na0OA8amWOzhRQWdGK0CGaN0D7FdsyUFX5plD7P/sXnnR883TdjetI
         H/LVsoOeTqYh7uLjvPcnrdzJBVupi1lGGon8OGm8UXGCzuK3hxJUm94ubXsS0PWsSxsq
         fTog9i6vx9neJGlgrOKCF1ToY6u+U+5/0c31Un1Iq/QU78lWrzeM85GztJ70FamBUzTL
         Mluw==
X-Gm-Message-State: AOAM530IoRB/mK+fbuYLWBfsEWxtO5mttH4S2ZnsyByHjbg3Qoue8sfL
        IjQW4eCKPPWi3335Gun1loTy7ezverYXU8mB9mtfPQ==
X-Google-Smtp-Source: ABdhPJxJHrqARF+0jz3ZZyXysH3y6k6QtQBNWODT/M/YcMSbKUDlRjViA4ZBi3I41AqPPK0Ex/j/TuaMHj6w6WRkiCU=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr29507318ybg.711.1638592863416;
 Fri, 03 Dec 2021 20:41:03 -0800 (PST)
MIME-Version: 1.0
References: <20211203185238.2011081-1-eric.dumazet@gmail.com> <202112041104.gPgP3Z6U-lkp@intel.com>
In-Reply-To: <202112041104.gPgP3Z6U-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Dec 2021 20:40:51 -0800
Message-ID: <CANn89i+m2O9EQCZq5r39ZbnE2dO82pxnj-KshbfWjNH3a5zqWQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: fix recent csum changes
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Laight <David.Laight@aculab.com>,
        David Lebrun <dlebrun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 7:34 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-fix-recent-csum-changes/20211204-025401
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 43332cf97425a3e5508c827c82201ecc5ddd54e0
> config: parisc-randconfig-s031-20211203 (https://download.01.org/0day-ci/archive/20211204/202112041104.gPgP3Z6U-lkp@intel.com/config)
> compiler: hppa64-linux-gcc (GCC) 11.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.4-dirty
>         # https://github.com/0day-ci/linux/commit/c13fbd113358fb59f76f76d25a1fdb57379c4b9c
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Eric-Dumazet/net-fix-recent-csum-changes/20211204-025401
>         git checkout c13fbd113358fb59f76f76d25a1fdb57379c4b9c
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=parisc SHELL=/bin/bash net/core/ net/ipv4/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>

Yes, keeping sparse happy with these checksum is not easy.

I will add and use this helper, unless someone has a better idea.

diff --git a/include/net/checksum.h b/include/net/checksum.h
index 5b96d5bd6e54532a7a82511ff5d7d4c6f18982d5..5218041e5c8f93cd369a2a3a46add3e6a5e41af7
100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -180,4 +180,8 @@ static inline void remcsum_unadjust(__sum16 *psum,
__wsum delta)
        *psum = csum_fold(csum_sub(delta, (__force __wsum)*psum));
 }

+static inline __wsum wsum_negate(__wsum val)
+{
+       return (__force __wsum)-((__force u32)val);
+}
 #endif
