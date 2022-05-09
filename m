Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79B85209B2
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbiEIX4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiEIX4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:56:25 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE0156C05
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:52:29 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2f7d621d1caso162165617b3.11
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 16:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KPy/7NbEAoIiRfW2yFmwpDhdDkkk5IoJxIY+izjqK6I=;
        b=FLpJxzJTkUTv6sRzC1r86F+JmTtLyl0ay7uCnXjcXSUfejtUoTKzeKKMD2ppP0L6gb
         nRnVdjHrmfxHQOgdyp+FWKmMRNkU3g7DAkSsbQ3xYxJkexWXmi8IGhHP3a7vjmWvd4D1
         pFEwHbJf8/H7xfXwU9JI2kTzpuGzXSQL7seDY9gsj4kpPf9zn1UhG0jeJetTJ6YzU6E3
         K9c82NOo2eFdhPNxMdu50rLO7qcrfs62HV/DJ+wN+EPDD4DuXfTP1PoYpiY/glKqunaC
         jfO7aSg8qmbHwBIBJDe7OuBrlpFhYBTi35sIOOt3gB7Hr9+LOIvvv1d6AlEdgsZsQayI
         seOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KPy/7NbEAoIiRfW2yFmwpDhdDkkk5IoJxIY+izjqK6I=;
        b=WDQq2R5EDmatRU8WlNmTyIac82gkFSowTMSzwEsTMIMgdFECoZ7GlJHkq9atQA4Z1y
         FwiCRBrcMVcHKPTPEpCokk97iZBYkBATjthOHmowQK+XxemWCcbb/2pxc5KfYQPRA3pR
         aQTz0A4QmW+VQbD3PhEhVG3uufmHIQ1e0tl2305MuNdsNlhUfLT3sGL6gnHw7sGRuKmc
         V5BSh9z+VQQ3F4oxJfs1Onl4aP7wnXs1W42bbc+tpeY9BC0VSF9py9UZJE7xFGlEFO1T
         FHC+nzZrVJC3/bBcq2Jz6HLt32Sx5123i0lNo56eIwoyvYcWrk8CjO6telwgHeCDA2p2
         A6kQ==
X-Gm-Message-State: AOAM532ZIaeVKIHhvmfisQg/NeGGq5VovGglZxiDAhf1PlWWtXwOlk8q
        9ugCqkBr8cnl9Lp/KE1iemQheIPg5MCJS52tkraiYHdRdDevXg==
X-Google-Smtp-Source: ABdhPJxm3uUgMvP4Hnaw647bywXkwKpjnDP6bfPJr1Ks/85ODKfKFc9lVv6EJqsw9RRwWRV3zGdlvL1H/m0p5iWuFxs=
X-Received: by 2002:a81:4f0c:0:b0:2f8:46f4:be90 with SMTP id
 d12-20020a814f0c000000b002f846f4be90mr17106858ywb.332.1652140348735; Mon, 09
 May 2022 16:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220509190851.1107955-4-eric.dumazet@gmail.com> <202205100723.9Wqso3nI-lkp@intel.com>
In-Reply-To: <202205100723.9Wqso3nI-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 16:52:17 -0700
Message-ID: <CANn89i+rMnV8RotzD7jfp8TgbJeV+XpzJFkWrhJe9YAtD9Wdbg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: warn if transport header was not set
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 4:32 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9c095bd0d4c451d31d0fd1131cc09d3b60de815d
> config: arm-oxnas_v6_defconfig (https://download.01.org/0day-ci/archive/20220510/202205100723.9Wqso3nI-lkp@intel.com/config)
> compiler: arm-linux-gnueabi-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/d316b61f313a417d7dfa97fa006320288f3af150
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
>         git checkout d316b61f313a417d7dfa97fa006320288f3af150
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/stmicro/stmmac/ drivers/net/mdio/ net/core/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>

I suppose some compiler/arches are asking us to add forward
declaration for struct net_device.
I have no idea what is the justification for that.
