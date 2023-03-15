Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3316BBD9C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjCOTwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjCOTwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:52:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E15FA0B25;
        Wed, 15 Mar 2023 12:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBC5A61E5F;
        Wed, 15 Mar 2023 19:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F8FC433EF;
        Wed, 15 Mar 2023 19:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678909917;
        bh=JZ0bjFMXIdUIWMQnlPQr0Suxei6gYW22j6ZzMtDWArY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ay7EbyrT/+fU1TkS3qEKm0SkejRBMotzbjVZKwACzDRST5EyUPJfHl42lauRAozk8
         MovbuxMFGZlQofh6KAlGa/t6c3oUA7TcX9oRsc2nVx81o76GfEnJ5wryMO6Trkh8ai
         2q9f9285b73EPCCJW4JMs4RvJGtCYqAouFh+/p9FNgpEyYZ+DkBdSDH4YHIubUHoKi
         OLZIRnpK/3eQ07X1KiCe+WyAQVSC7+CPtDSqSvI6OGvfNcShgKpx16g8J6pZjOuVpm
         Xw24P+PgOoECEHPdGpvAFudJDul6pWCjwRdfPHl6Hv9i6SvCUHfH74vh87KuYDYlbX
         mVXzynxvi1AHg==
Date:   Wed, 15 Mar 2023 12:51:54 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <20230315195154.GA1636193@dev-arch.thelio-3990X>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
 <202303150831.vgyKe8FD-lkp@intel.com>
 <ZBH7G+1RwX4VAKcz@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBH7G+1RwX4VAKcz@smile.fi.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 07:06:35PM +0200, Andy Shevchenko wrote:
> On Wed, Mar 15, 2023 at 09:05:25AM +0800, kernel test robot wrote:
> > Hi Andy,
> > 
> > I love your patch! Yet something to improve:
> > 
> > [auto build test ERROR on net-next/master]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Shevchenko/net-dsa-hellcreek-Get-rid-of-custom-led_init_default_state_get/20230315-021931
> > patch link:    https://lore.kernel.org/r/20230314181824.56881-1-andriy.shevchenko%40linux.intel.com
> > patch subject: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
> > config: i386-randconfig-a015-20230313 (https://download.01.org/0day-ci/archive/20230315/202303150831.vgyKe8FD-lkp@intel.com/config)
> > compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/intel-lab-lkp/linux/commit/fdd54417a75386e7ad47065c21403835b7fda94a
> >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> >         git fetch --no-tags linux-review Andy-Shevchenko/net-dsa-hellcreek-Get-rid-of-custom-led_init_default_state_get/20230315-021931
> >         git checkout fdd54417a75386e7ad47065c21403835b7fda94a
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/dsa/hirschmann/
> > 
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Link: https://lore.kernel.org/oe-kbuild-all/202303150831.vgyKe8FD-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> drivers/net/dsa/hirschmann/hellcreek_ptp.c:322:10: error: implicit declaration of function 'led_init_default_state_get' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
> >            state = led_init_default_state_get(of_fwnode_handle(led));
> >                    ^
> >    1 error generated.
> 
> I can not reproduce it.
> 
> I have downloaded net-next and applied the only patch on top.
> I have downloaded the above mentioned kernel configuration and
> repeated the steps with `make ... oldconfig; make W=1 ...`
> 
> Can you shed a light on what's going on here?
> 
> Note, the bug is impossibly related to my patch because the new API is in the
> same header as already used from the LEDS framework. If it's reproducible, it
> should be also without my patch.

If you modify the GitHub link above the 'git remote' command above from
'commit' to 'commits', you can see that your patch was applied on top of
mainline commit 5b7c4cabbb65 ("Merge tag 'net-next-6.3' of
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next"), which
was before the pull that moved led_init_default_state_get() into
include/linux/leds.h, commit e4bc15889506 ("Merge tag 'leds-next-6.3' of
git://git.kernel.org/pub/scm/linux/kernel/git/lee/leds"). Not sure why
that was the base that was chosen but it explains the error.

Cheers,
Nathan
