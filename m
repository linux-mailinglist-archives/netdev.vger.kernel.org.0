Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F4341D302
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348192AbhI3GGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348054AbhI3GGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:06:00 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D01C06161C;
        Wed, 29 Sep 2021 23:04:18 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id k24so5138585pgh.8;
        Wed, 29 Sep 2021 23:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ic73pPeEyXcWnfRNixNiAUb29ZgXxYyvahioOuxFWMQ=;
        b=UH4L74CsfTSDU+nsBbx3i9EFZWG02fMmeA/BPJd7dr2HX9lEwjfvJevEqmvWvgWj6V
         gb4rs/6lo8QgvWoj1dhS9Ld0Uq0dE9qu8ldTA0XVhXBGozixmgeb5NZPJcsvFMp0zNii
         WO4KXO/MjLqxIIldYWs/PJRdgRoUAfaWqgpZTsfMn84SjglpMyvpWAnk1Td1fQKAK0+9
         27gNZADJ+mrqBcbd3tccpNOba5ZqEKasvgfwsRSrE8vJc7CZc/2Au8Qu4Hxg2f40VugP
         KNZipR/5akpoiHneZuFywg9hAcn2vAvHtJuUkXcdKffs/m/4tnyr6+XvR5kWuSm9Pa1m
         CFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ic73pPeEyXcWnfRNixNiAUb29ZgXxYyvahioOuxFWMQ=;
        b=Wz/ziz5YbN+NoXixS+lLz+Vm5AKM+zRwDvGiZUyI8ws0XQ7VEwtuQVy9OtQxmQuM+M
         eKqesTIO/tEpJiqmbINifY2linbO7DIONTqHRAGitSoGlDXJ0r7HPveWaXcJnQYo+KHn
         k6adlTKdCt/B0HHzWzenSnnRNldGJ1by0GI+bkqPI4dKrj3jOBwjQzHh9iW2wgKMJ9r+
         LcJ2ZyW/EAyFLmfVW7NpDnkq0pmSoDSmVyTnR5lPfdDWXuj7shoy0SXdFpnZcyYB1DKD
         5Ol3va+psLj0eJ9OPuSdRgE57UyQuQIDBOjVg7y03mn1simNBOy7hENiP4sEV15cdFut
         pjmw==
X-Gm-Message-State: AOAM531BvGLr+VIm6srQQVVsGq7l9G1kVOnF0E9d83t+hHDrxBXGamr1
        X8oZoaZJVV8Ugvki3JVOCgoEap8e/zMcHYR2s3Lx5WmijbhCerHZ9A4=
X-Google-Smtp-Source: ABdhPJzvRzZMn0eToIIC99jY+ZPM2aC9u3K8zx/Fgpudo4oJtqcXON8SmKM+a7V89pXDjarOblKcBDvNDd4KdbqHx7o=
X-Received: by 2002:a05:6a00:708:b0:43b:80ba:99c8 with SMTP id
 8-20020a056a00070800b0043b80ba99c8mr2483411pfl.51.1632981857497; Wed, 29 Sep
 2021 23:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201119083024.119566-7-bjorn.topel@gmail.com> <202109300212.l6Ky1gNu-lkp@intel.com>
In-Reply-To: <202109300212.l6Ky1gNu-lkp@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 30 Sep 2021 08:04:06 +0200
Message-ID: <CAJ8uoz3g6wzkTYRb4qq4aj+KDVGUfyZ6O6NkMK_t-EBp07igOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/10] xsk: propagate napi_id to XDP socket Rx path
To:     kernel test robot <lkp@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kbuild-all@lists.01.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 8:37 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi "Bj=C3=B6rn,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on 4e99d115d865d45e17e83478d757b58d8fa66d3c]
>
> url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Introduce-pr=
eferred-busy-polling/20210929-234934
> base:   4e99d115d865d45e17e83478d757b58d8fa66d3c
> config: um-kunit_defconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=3D1 build):
>         # https://github.com/0day-ci/linux/commit/f481c00164924dd5d782a92=
cc67897cc7f804502
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Bj-rn-T-pel/Introduce-preferred-=
busy-polling/20210929-234934
>         git checkout f481c00164924dd5d782a92cc67897cc7f804502
>         # save the attached .config to linux build tree
>         mkdir build_dir
>         make W=3D1 O=3Dbuild_dir ARCH=3Dum SHELL=3D/bin/bash
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    cc1: warning: arch/um/include/uapi: No such file or directory [-Wmissi=
ng-include-dirs]
>    In file included from fs/select.c:32:
>    include/net/busy_poll.h: In function 'sk_mark_napi_id_once':
> >> include/net/busy_poll.h:150:36: error: 'const struct sk_buff' has no m=
ember named 'napi_id'
>      150 |  __sk_mark_napi_id_once_xdp(sk, skb->napi_id);
>          |                                    ^~
>
>
> vim +150 include/net/busy_poll.h
>
>    145
>    146  /* variant used for unconnected sockets */
>    147  static inline void sk_mark_napi_id_once(struct sock *sk,
>    148                                          const struct sk_buff *skb=
)
>    149  {
>  > 150          __sk_mark_napi_id_once_xdp(sk, skb->napi_id);
>    151  }
>    152

It seems that the robot tested an old commit and that this was already
fixed by Daniel 10 months ago. Slow mail delivery, a robot glitch, or
am I missing something?

commit ba0581749fec389e55c9d761f2716f8fcbefced5
Author: Daniel Borkmann <daniel@iogearbox.net>
Date:   Tue Dec 1 15:22:59 2020 +0100

    net, xdp, xsk: fix __sk_mark_napi_id_once napi_id error

    Stephen reported the following build error for !CONFIG_NET_RX_BUSY_POLL
    built kernels:

      In file included from fs/select.c:32:
      include/net/busy_poll.h: In function 'sk_mark_napi_id_once':
      include/net/busy_poll.h:150:36: error: 'const struct sk_buff'
has no member named 'napi_id'
        150 |  __sk_mark_napi_id_once_xdp(sk, skb->napi_id);
            |                                    ^~

    Fix it by wrapping a CONFIG_NET_RX_BUSY_POLL around the helpers.

    Fixes: b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
    Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
    Link: https://lore.kernel.org/linux-next/20201201190746.7d3357fb@canb.a=
uug.org.au


> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
