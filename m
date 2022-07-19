Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E389A57A87D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbiGSUtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240315AbiGSUsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:48:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EB95F9AD;
        Tue, 19 Jul 2022 13:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658263726; x=1689799726;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JKOoFo77x7jN/peLRtw+tsIV5rXzDnhY5iVySkXtvUo=;
  b=VQRq6SmXmRuS/zDFRQ8GvYrcJ9aa1pROzpt07RC3mh40FHHQOE+NpNdp
   Ijym+vxctckULjZnQ5vLu9RnQIww5nKSNCl7q58DG5LHZX8DyfYQo68Rx
   1WI8Q+l4aBEUUbkQzIIrijbE+Xjz9m756ZkuzePwTPAiJ8UThq8AbIBjy
   YWYNp/RgcJYHUmSgOg463JlvbwZpJimaYaXYeg3D6XTRNYX70cF9WC6FE
   +LKthrCXT3DVRxyOJdpZnxghMlIeNMwzBkor4UBvLRZ00vCVXMfLOJWt8
   EE+TJ/J8ZSv/pja8ntuLLcRsMO+jRlnYLLBG5+cnL8UcKhoeRswsViFTw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="348290267"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="348290267"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 13:48:45 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="843788360"
Received: from avandeve-mobl.amr.corp.intel.com (HELO [10.209.102.45]) ([10.209.102.45])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 13:48:43 -0700
Message-ID: <c297ad10-fe5e-c2ee-5762-e037d051fe3b@linux.intel.com>
Date:   Tue, 19 Jul 2022 13:48:43 -0700
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
 <e292e128-d732-e770-67d7-b6ed947cec7b@linux.intel.com>
 <8e201d99-78a8-d68c-6d33-676a1ba5a6ee@igalia.com>
From:   Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <8e201d99-78a8-d68c-6d33-676a1ba5a6ee@igalia.com>
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

On 7/19/2022 1:44 PM, Guilherme G. Piccoli wrote:
> On 19/07/2022 17:33, Arjan van de Ven wrote:
>> On 7/19/2022 12:53 PM, Guilherme G. Piccoli wrote:
>>> Currently we have a debug infrastructure in the notifiers file, but
>>> it's very simple/limited. Extend it by:
>>>
>>> (a) Showing all registered/unregistered notifiers' callback names;
>>
>>
>> I'm not yet convinced that this is the right direction.
>> The original intent for this "debug" feature was to be lightweight enough that it could run in production, since at the time, rootkits
>> liked to clobber/hijack notifiers and there were also some other signs of corruption at the time.
>>
>> By making something print (even at pr_info) for what are probably frequent non-error operations, you turn something that is light
>> into something that's a lot more heavy and generally that's not a great idea... it'll be a performance surprise.
>>
>>
> 
> Is registering/un-registering notifiers a hot path, or performance
> sensitive usually? For me, this patch proved to be very useful, and once
> enabled, shows relatively few entries in dmesg, these operations aren't
> so common thing it seems.
> 
> Also, if this Kconfig option was meant to run in production, maybe the
> first thing would be have some sysfs tuning or anything able to turn it
> on - I've worked with a variety of customers and the most terrifying
> thing in servers is to install a new kernel and reboot heh
> 
> My understanding is that this debug infrastructure would be useful for
> notifiers writers and people playing with the core notifiers
> code...tracing would be much more useful in the context of checking if
> some specific notifier got registered/executed in production environment
> I guess.

I would totally support an approach where instead of pr_info, there's a tracepoint
for these events (and that shouldnt' need to be conditional on a config option)

that's not what the patch does though.
