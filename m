Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56B54434F
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 07:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbiFIFs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 01:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiFIFs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 01:48:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D4525AD5B;
        Wed,  8 Jun 2022 22:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654753736; x=1686289736;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X6xY/YfYwXt/shABIBSZM3vNDaFed04f3Z096mVyREU=;
  b=LOJx/gRIkeZDxn+0uAXiPl7cBYP2dFoEcnCsqnnz3rLga7mFFw+u36/X
   CtfDEQHiddLIVvIiVHS+thu9yslJD7IZ7FEPQSyaNvuvV+RiTVwjsSwsP
   AwqkpkFCdbg+euII2N7Dv6oBwa1aeWhZQXvPaDEu+3stSrab0cSnAOZv3
   tkyNVmhZgcOtZiUiX9BwJo3r7cGQ/C/3iWx62qqS+aoPxhbB+84J4a5Yi
   0sZ9UG5NJ5Ae7U6FT+ph7kBO+0b2jksikn4CBxJs+KR6N8B46pw5f4mAP
   M6VSQl0B/roFaDIPuCJydBDEsjWt3e4/j1CxZvRnvEFVs6PRDoSCzypH2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="338927173"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="338927173"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 22:48:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="585312688"
Received: from xwang29-mobl.ccr.corp.intel.com ([10.249.168.108])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 22:48:52 -0700
Message-ID: <ac80ed671fc2482524b9234c444d765e2f8d87f1.camel@intel.com>
Subject: Re: [net]  6922110d15: suspend-stress.fail
From:   Zhang Rui <rui.zhang@intel.com>
To:     Willy Tarreau <w@1wt.eu>, Jakub Kicinski <kuba@kernel.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, yu.c.chen@intel.com
Date:   Thu, 09 Jun 2022 13:48:50 +0800
In-Reply-To: <20220608054553.GA7499@1wt.eu>
References: <20220605143935.GA27576@xsang-OptiPlex-9020>
         <20220607174730.018fe58e@kernel.org> <20220608054553.GA7499@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 2022-06-08 at 07:45 +0200, Willy Tarreau wrote:
> On Tue, Jun 07, 2022 at 05:47:30PM -0700, Jakub Kicinski wrote:
> > On Sun, 5 Jun 2022 22:39:35 +0800 kernel test robot wrote:
> > > Greeting,
> > > 
> > > FYI, we noticed the following commit (built with gcc-11):
> > > 
> > > commit: 6922110d152e56d7569616b45a1f02876cf3eb9f ("net:
> > > linkwatch: fix failure to restore device state across
> > > suspend/resume")
> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git
> > > master
> > > 
> > > in testcase: suspend-stress
> > > version: 
> > > with following parameters:
> > > 
> > > 	mode: freeze
> > > 	iterations: 10
> > > 
> > > 
> > > 
> > > on test machine: 4 threads Ivy Bridge with 4G memory
> > > 
> > > caused below changes (please refer to attached dmesg/kmsg for
> > > entire log/backtrace):
> > > 
> > > 
> > > 
> > > 
> > > If you fix the issue, kindly add following tag
> > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > 
> > > 
> > > Suspend to freeze 1/10:
> > > Done
> > > Suspend to freeze 2/10:
> > > network not ready
> > > network not ready
> > > network not ready
> > > network not ready
> > > network not ready
> > > network not ready
> > > network not ready
> > > network not ready
> > > network not ready
> > > network not ready
> > > network not ready
> > > Done
> > 
> > What's the failure? I'm looking at this script:
> > 
> > https://github.com/intel/lkp-tests/blob/master/tests/suspend-stress
> > 
> > And it seems that we are not actually hitting any "exit 1" paths
> > here.


In our test, we do 10 back-to-back suspend iterations,

1. tell the server the machine is going to suspend
2. do suspend
3. resumed by rtc
4. check network availability
5. tell the server the machine is resumed, and update the local log to
the server
6. goto 1

As the test is done remotely, from server side, we only know that step
1 is done, the test machine may either hang in suspend, or lost network
connection after resume. The only way to bring it back on line is to do
a hard reset, but as we're using ramdisk, there is no log can tell us
which step the test stucks before reboot.

You can see the above log only when the network is already back.

The reason why we think it is a regression is that
after 10x10 suspend iterations (10 tests, each test is done after a
refresh boot, and each tests contains 10 suspend iterations)

With the first bad commit:
0/10 passed
with the head that contains the commit
1/10 passed
With the parent of the first bad commit or with the first bad commit
reverted,
10/10 passed

> 
> I'm not sure how the test has to be interpreted but one possible
> interpretation is that the link really takes time to re-appear and
> that prior to the fix, the link was believed to still be up since
> the event was silently lost during suspend, while now the link is
> correctly being reported as being down and something is waiting for
> it to be up again, as it possibly should. Thus it could be possible
> that the fix revealed an incorrect expectation in that test.

Just to be clear, the network is really up. That is why we can see this
log which is sent back from the test machine via network after resume.

thanks,
rui

