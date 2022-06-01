Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3E853ABD6
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 19:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355803AbiFAR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 13:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345750AbiFAR0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 13:26:20 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2D73EBA4
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 10:26:19 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2f83983782fso26328657b3.6
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 10:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wdMD0knNqN9sqWmnxjKW1L2wG54cbNO+R3QNEYwN0t4=;
        b=CTxsReE9WzfHzH1TmYW4L33X1alptKwJSgcU1Um/lTWg9N0lE4QJWmbwAZi/RqzLCN
         PFrkIehiemOJax0EKJOUz1fvIYaeTvsPBFrJhzlRXTXYzKQrkehTJ3O1OGaSkzB+NLap
         QO7nRV0FaRODvvHSq4zPw7LoUXJmQP7KHou2rvH/NmaGpaP7IOT+DU8aaJ2t78nsWf/k
         kfG32mndXUDCSpdQAxSVKVVNrWJB7zYKsyj+Gy3WwdhmvtKcolqTix9LYSr93w4sXKuk
         8vhEVPDqjHUEXLVYU4CUoNBfqExWrWrRGiIhCF3vjJN6Tu9EwhnVRvy/v8bzYmqIMcQl
         BaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wdMD0knNqN9sqWmnxjKW1L2wG54cbNO+R3QNEYwN0t4=;
        b=3l/nDgmD2ci8BfrPqY6tKX5TWdlaH/eVANAcpDpzR1lMK3s5KOXfvWksf69oVO0kfQ
         CFRcp5fVr/4CcUfry45JfSScnW4nMWtx0tdq00ALrKVGnaqjR2jZ9Wjrmr/s1DY1GY0y
         b9bkYWtU+TZDohi5nvOicYl2CpVyJZAwqhoKh+wf4yy0DZz6D6r+5+itfizlcbDS8GDW
         c2SQawwFH1yFbn3PviirnTvby6tihqLVFeASrv37U4iZzpAvM7IiEtQt41gKqMulscod
         MttBPbIC1n7Gk8zShJ6vgH7DqZ+XKvoZQoh1d3vvWEF/NajaJ6HGnZLRbUJhhXQIOJPG
         FpTg==
X-Gm-Message-State: AOAM531sfBzITclCLvIgHl5uErqTrWLNt9/jZpD6z8owR70lr+4NRF1x
        wZ4ceFsVYwRaE7KwNDBMlyQeEAkGee7RmcnMJmPGLg==
X-Google-Smtp-Source: ABdhPJxxCEBy4meH7Kx2Tf8V2ItTb8rgnpgruejTcC3pEJF8dC7me884W7RolUaNAPVkXzkLJTNFKRmUoXOo8GS+oeI=
X-Received: by 2002:a81:4909:0:b0:30c:34d5:9f2c with SMTP id
 w9-20020a814909000000b0030c34d59f2cmr542095ywa.489.1654104378223; Wed, 01 Jun
 2022 10:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220531185933.1086667-2-eric.dumazet@gmail.com> <202206011509.Rpp82wrl-lkp@intel.com>
In-Reply-To: <202206011509.Rpp82wrl-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 1 Jun 2022 10:26:07 -0700
Message-ID: <CANn89i+dz7NiTOJP4uyq2qCsj-_E=qbXBBKZ819pgMzd6TbMBA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: add debug info to __skb_pull()
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
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

On Wed, Jun 1, 2022 at 12:28 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-af_packet-be-careful-when-expanding-mac-header-size/20220601-030146
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 09e545f7381459c015b6fa0cd0ac6f010ef8cc25
> config: arc-randconfig-r021-20220531 (https://download.01.org/0day-ci/archive/20220601/202206011509.Rpp82wrl-lkp@intel.com/config)
> compiler: arc-elf-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/a907c048e7699133feedaa06948c15c719a59f94
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Eric-Dumazet/net-af_packet-be-careful-when-expanding-mac-header-size/20220601-030146
>         git checkout a907c048e7699133feedaa06948c15c719a59f94
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    arc-elf-ld: kernel/bpf/cgroup.o: in function `__skb_pull':
>    include/linux/skbuff.h:2703: undefined reference to `skb_dump'
> >> arc-elf-ld: include/linux/skbuff.h:2703: undefined reference to `skb_dump'
>


So... CONFIG_NET=n  and yet __cgroup_bpf_run_filter_skb() is using skbs ?

Not sure if this makes any sense.



>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
