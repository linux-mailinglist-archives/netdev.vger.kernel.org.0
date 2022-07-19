Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E456457A86D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbiGSUpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238143AbiGSUpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:45:01 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D99599D4;
        Tue, 19 Jul 2022 13:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mm6gaIG3ulRS6bYmNbpjfA3sE2i3p2OSI7BJX/PQ87M=; b=NHRZ5ZOoSJvZ1rx0k+qAorgHi+
        ysh3vwi0PmqkJ+sGT7WvvQq42Iam55ZtfsYvuSe8jlWS3T5GO6WFTAJPoBvG8B0awkYvog91umeP9
        Uy9+z9l79ZNg4uOpd7S9OPocCVgkb02y0J3HsguQ5KVTAI49LNiEt9sPKWHn2I9cb6QoKgN6FB9Kg
        nC7EdVklSTsvadIYvBBICjf9v+16T5FuWpJnr1e48reVt+ocCZ9LYMX8lFiuwZHLqGO0dgF535kiv
        pv2Ma+2wbPCi1qg2RE2gqrjaTAHsDQjqblHKykFE7WpSED9UQK0QBFo9aHF9TjvED8BhtMx764WgT
        m/JB4MpQ==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oDu59-006j7M-DT; Tue, 19 Jul 2022 22:44:39 +0200
Message-ID: <8e201d99-78a8-d68c-6d33-676a1ba5a6ee@igalia.com>
Date:   Tue, 19 Jul 2022 17:44:03 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 09/13] notifier: Show function names on notifier
 routines if DEBUG_NOTIFIERS is set
Content-Language: en-US
To:     Arjan van de Ven <arjan@linux.intel.com>,
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
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <e292e128-d732-e770-67d7-b6ed947cec7b@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 17:33, Arjan van de Ven wrote:
> On 7/19/2022 12:53 PM, Guilherme G. Piccoli wrote:
>> Currently we have a debug infrastructure in the notifiers file, but
>> it's very simple/limited. Extend it by:
>>
>> (a) Showing all registered/unregistered notifiers' callback names;
> 
> 
> I'm not yet convinced that this is the right direction.
> The original intent for this "debug" feature was to be lightweight enough that it could run in production, since at the time, rootkits
> liked to clobber/hijack notifiers and there were also some other signs of corruption at the time.
> 
> By making something print (even at pr_info) for what are probably frequent non-error operations, you turn something that is light
> into something that's a lot more heavy and generally that's not a great idea... it'll be a performance surprise.
> 
> 

Is registering/un-registering notifiers a hot path, or performance
sensitive usually? For me, this patch proved to be very useful, and once
enabled, shows relatively few entries in dmesg, these operations aren't
so common thing it seems.

Also, if this Kconfig option was meant to run in production, maybe the
first thing would be have some sysfs tuning or anything able to turn it
on - I've worked with a variety of customers and the most terrifying
thing in servers is to install a new kernel and reboot heh

My understanding is that this debug infrastructure would be useful for
notifiers writers and people playing with the core notifiers
code...tracing would be much more useful in the context of checking if
some specific notifier got registered/executed in production environment
I guess.

Cheers,


Guilherme
