Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA97520AB1
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbiEJBe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbiEJBeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:34:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4B5284909
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDFB9B81A09
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2009AC385C2;
        Tue, 10 May 2022 01:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652146226;
        bh=hl99h4EXt1vl7wKFBfwX/vCdmzi7EyD0p3AQiyRiO/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lLRZ8PdK5E39tY5u/vReSCYDM3+SDjTmDaQ3CCicc/xp/KIofXOAGU5oDEEEj1y9j
         OsO0o+b0dqpd7ddJRclfdi5RdnSbIN+1r4WjXoZJICTE1KOr958EfYEYQA/cQi3cba
         hiMkoZKgzEM841bwABmuE1DL/pT9vQZIGM+37/kHK4HTZ8+DmICqs0EN/HnnEs0ivV
         bulc2XEld64SNb1zVP/Qn38Muf8aphFWIkEbNU56T6pO0hjF1IJ0nB4f4RsAnLPmRh
         BxUu06nnsPaeJKvIZwSqSQwZCe8g4QJnSdFrxpp0HKmWj9SJv+8+v4B6fuRqPS7eOq
         fsBlWCPLKnU1Q==
Date:   Mon, 9 May 2022 18:30:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: warn if transport header was not set
Message-ID: <20220509183024.0edd698f@kernel.org>
In-Reply-To: <CANn89i+rMnV8RotzD7jfp8TgbJeV+XpzJFkWrhJe9YAtD9Wdbg@mail.gmail.com>
References: <20220509190851.1107955-4-eric.dumazet@gmail.com>
        <202205100723.9Wqso3nI-lkp@intel.com>
        <CANn89i+rMnV8RotzD7jfp8TgbJeV+XpzJFkWrhJe9YAtD9Wdbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 16:52:17 -0700 Eric Dumazet wrote:
> On Mon, May 9, 2022 at 4:32 PM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Eric,
> >
> > I love your patch! Perhaps something to improve:
> >
> > [auto build test WARNING on net-next/master]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9c095bd0d4c451d31d0fd1131cc09d3b60de815d
> > config: arm-oxnas_v6_defconfig (https://download.01.org/0day-ci/archive/20220510/202205100723.9Wqso3nI-lkp@intel.com/config)
> > compiler: arm-linux-gnueabi-gcc (GCC) 11.3.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/intel-lab-lkp/linux/commit/d316b61f313a417d7dfa97fa006320288f3af150
> >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> >         git fetch --no-tags linux-review Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
> >         git checkout d316b61f313a417d7dfa97fa006320288f3af150
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/stmicro/stmmac/ drivers/net/mdio/ net/core/
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >  
> 
> I suppose some compiler/arches are asking us to add forward
> declaration for struct net_device.
> I have no idea what is the justification for that.

Yeah the order of inclusion is skbuff -> netdevice, as you probably
figured out by yourself. We may want to pull back the code move for 
the print helpers. Unless you have cycles to untangle that :S
