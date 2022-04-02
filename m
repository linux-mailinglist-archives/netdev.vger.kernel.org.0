Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384BC4EFF43
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 09:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbiDBHNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 03:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiDBHNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 03:13:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8376D1EAD2
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 00:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648883475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MHkMY/gjWD4ayMgnmR9Ub7v0rfA5e49jqyy9dp2VcPM=;
        b=NrJbxxE+E05yl0HjBD+hyc+aeM8tf7ruug5VY4PallJGo2nTyxSivuItcucWBoq8eo1Got
        3q2q7XvP5G4fUULBbAXsPnJ1y6imPSlrBoYwF00ODzF94Vbvir93sz0ZajjcWwZPETnpU5
        gAnKa/d+WoYUQx+dwxpsOT3Mi4l2DKg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-beyOVKkxMM66W9dohVyjag-1; Sat, 02 Apr 2022 03:11:12 -0400
X-MC-Unique: beyOVKkxMM66W9dohVyjag-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 120A42A2AD45;
        Sat,  2 Apr 2022 07:11:12 +0000 (UTC)
Received: from sparkplug.usersys.redhat.com (unknown [10.40.192.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71F2840885AD;
        Sat,  2 Apr 2022 07:11:09 +0000 (UTC)
Date:   Sat, 2 Apr 2022 09:11:09 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        dsahern@kernel.org
Subject: Re: [net]  6ef3f95797:
 UBSAN:shift-out-of-bounds_in_kernel/time/timer.c
Message-ID: <Ykf3DZ4VJQ0yLJss@sparkplug.usersys.redhat.com>
References: <20220330082046.3512424-3-asavkov@redhat.com>
 <20220402030939.GA19395@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220402030939.GA19395@xsang-OptiPlex-9020>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 02, 2022 at 11:09:40AM +0800, kernel test robot wrote:
> 
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 6ef3f95797546781829db3bb6228c9990ba1d49f ("[PATCH v3 2/2] net: make tcp keepalive timer upper bound")
> url: https://github.com/intel-lab-lkp/linux/commits/Artem-Savkov/timer-add-a-function-to-adjust-timeouts-to-be-upper-bound/20220330-172140
> base: https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git b166e52541f2357ce126a92ce1d9a580fdca719d
> patch link: https://lore.kernel.org/netdev/20220330082046.3512424-3-asavkov@redhat.com
> 
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-a17aac1b-1_20220328
> with following parameters:
> 
> 	group: tc-testing
> 	ucode: 0xec
> 
> test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
> test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
> 
> 
> on test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz with 16G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 
> [  158.913672][    C1] UBSAN: shift-out-of-bounds in kernel/time/timer.c:584:32
> [  158.922603][    C1] shift exponent -3 is negative

This is caused by LVL_START(0). Levels 0 and 1 need to be handled
separately to insure we don't end up with negative values.

-- 
 Artem

