Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C834857CBC0
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiGUNVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGUNVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:21:21 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BB0BF8;
        Thu, 21 Jul 2022 06:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BP2dOOHwiEAun/R1J+6SptcEzetpJVF1WfO8eYPtR2Q=; b=g/nP/ePQD9zM/JEZFMtXVfRuk6
        TLGToyIlywor5Yjzifz7Ur7IGyuGYwq80mZ8ia2tIOpKjpPEmvw1hHfBNLvhT7vVFE4M82OwpO6dE
        oUfwvPP/CYPwAlqUIYT3yd22R9kVIN92o2O4WaY0TgWtnYjs4lMys5M0RXuX2sX67wIU87HeULIww
        9I2vZqdvtgWQlbzhaP9FTDF4Z7lSRyIgRAZ9pASvZXer/YPWSnajQj95FuX1VSP3eyaAhx/AjSLLl
        45fOeJAYJZlBWsEX/BBWZAP3CMwP+2zfotvbfUHs4vpzODvRILsdmnQhssEcyFglMtIytO2QQGhKX
        Z7Q2mqZg==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oEW71-001ULd-Vs; Thu, 21 Jul 2022 15:21:08 +0200
Message-ID: <9974e738-6e3d-7d00-69b3-3aca37ea7cc1@igalia.com>
Date:   Thu, 21 Jul 2022 10:20:42 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
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
 <8e201d99-78a8-d68c-6d33-676a1ba5a6ee@igalia.com>
 <c297ad10-fe5e-c2ee-5762-e037d051fe3b@linux.intel.com>
 <8ef53978-f26e-89e3-8b04-6f0eb183f200@igalia.com>
 <4a9d64b5-0fa4-8294-c78c-37394a156325@linux.intel.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <4a9d64b5-0fa4-8294-c78c-37394a156325@linux.intel.com>
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

On 19/07/2022 19:04, Arjan van de Ven wrote:
> On 7/19/2022 2:00 PM, Guilherme G. Piccoli wrote:
>> On 19/07/2022 17:48, Arjan van de Ven wrote:
>>> [...]
>>> I would totally support an approach where instead of pr_info, there's a tracepoint
>>> for these events (and that shouldnt' need to be conditional on a config option)
>>>
>>> that's not what the patch does though.
>>
>> This is a good idea Arjan! We could use trace events or pr_debug() -
>> which one do you prefer?
>>
> 
> I'd go for a trace point to be honest
> 

ACK, I'll re-work it as a trace event then.
Cheers,


Guilherme
