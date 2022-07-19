Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE257A83F
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbiGSUdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiGSUdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:33:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A884506B;
        Tue, 19 Jul 2022 13:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658262796; x=1689798796;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=20RPDLm8Al5aPVJySa70I/GMs19LDvZGqa/P5oQG5pU=;
  b=ZjdXZBMFkHzsyEHX0nm7bK965LXL7jOWVgETuC6M6IY3CDdLEzeVu+pZ
   5LFsyznpsCPvBt/o1b8NS5EZe2XS4rmHEtfCGiTAnJ22pCRlMQPAmaqPH
   QlIjJlXvDsIzHRbpf4XsNoanO63Ts8ZwJkRpWhdE5dLU1LeB5x7ChPS+T
   PBJinHesu0xJ15WWslWOtvUV/vRylzTQXboBDSjoJdD5ty6nFvSu14Y9T
   9bS92dPXQDSqHxFYysC7tCKZdL4kYOxdLbY6ROl58287PebOwRJgFWrBa
   bot6/te/qc86zdEs8JLRE09wm+O1DJLiLLxInPNHqcjNsh3rMY+XXUg1X
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="348287280"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="348287280"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 13:33:16 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="843784574"
Received: from avandeve-mobl.amr.corp.intel.com (HELO [10.209.102.45]) ([10.209.102.45])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 13:33:13 -0700
Message-ID: <e292e128-d732-e770-67d7-b6ed947cec7b@linux.intel.com>
Date:   Tue, 19 Jul 2022 13:33:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 09/13] notifier: Show function names on notifier
 routines if DEBUG_NOTIFIERS is set
Content-Language: en-US
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Xiaoming Ni <nixiaoming@huawei.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-10-gpiccoli@igalia.com>
From:   Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20220719195325.402745-10-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/2022 12:53 PM, Guilherme G. Piccoli wrote:
> Currently we have a debug infrastructure in the notifiers file, but
> it's very simple/limited. Extend it by:
> 
> (a) Showing all registered/unregistered notifiers' callback names;


I'm not yet convinced that this is the right direction.
The original intent for this "debug" feature was to be lightweight enough that it could run in production, since at the time, rootkits
liked to clobber/hijack notifiers and there were also some other signs of corruption at the time.

By making something print (even at pr_info) for what are probably frequent non-error operations, you turn something that is light
into something that's a lot more heavy and generally that's not a great idea... it'll be a performance surprise.


