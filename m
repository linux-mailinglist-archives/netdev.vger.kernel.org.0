Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56E954228D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiFHDkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 23:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiFHDfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 23:35:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAB721628F;
        Tue,  7 Jun 2022 17:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A306187F;
        Wed,  8 Jun 2022 00:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8ACC341F8;
        Wed,  8 Jun 2022 00:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654649251;
        bh=ZskClJ6YsWVHejtgkKujPrrb7TJaJgflzOhkbxSLtFI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vmq2cjcGwoPB/8iv/5DnovPl8yo7M2lo6Ms+GtKh37ybTLOTFFnxXKshOpH4WZiRj
         AlrFUemLwZLWVjuJZL3P+2y2IsVq8RcTZBERqt6zWtDYpoTXmagd7EJPjduMIv9E6G
         shEB00JHIUITxEZrWcLzND3MY29Kxwn/P120e+lvdlfC3xLnlYxGTJxVgknx2KhZJv
         xeVcaYmWkIFtk75MtBVH3nclLLrNlf2AoafmS4LT3jTV5ZDg+Wjz13OgZu/sesqRdM
         YIfy1j1eRkSsk5YVBnioAkiqwYJq5JmNCqm5gFEAvMWkD3oCMy0aOz9Kj7avf09/5D
         iEgDDeu/N+lAg==
Date:   Tue, 7 Jun 2022 17:47:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Willy Tarreau <w@1wt.eu>, Heiner Kallweit <hkallweit1@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, rui.zhang@intel.com,
        yu.c.chen@intel.com
Subject: Re: [net]  6922110d15: suspend-stress.fail
Message-ID: <20220607174730.018fe58e@kernel.org>
In-Reply-To: <20220605143935.GA27576@xsang-OptiPlex-9020>
References: <20220605143935.GA27576@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Jun 2022 22:39:35 +0800 kernel test robot wrote:
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: 6922110d152e56d7569616b45a1f02876cf3eb9f ("net: linkwatch: fix failure to restore device state across suspend/resume")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> in testcase: suspend-stress
> version: 
> with following parameters:
> 
> 	mode: freeze
> 	iterations: 10
> 
> 
> 
> on test machine: 4 threads Ivy Bridge with 4G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 
> Suspend to freeze 1/10:
> Done
> Suspend to freeze 2/10:
> network not ready
> network not ready
> network not ready
> network not ready
> network not ready
> network not ready
> network not ready
> network not ready
> network not ready
> network not ready
> network not ready
> Done

What's the failure? I'm looking at this script:

https://github.com/intel/lkp-tests/blob/master/tests/suspend-stress

And it seems that we are not actually hitting any "exit 1" paths here.
