Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E850257A8BA
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 23:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiGSVBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 17:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiGSVBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 17:01:51 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722BE42AC4;
        Tue, 19 Jul 2022 14:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R5Au+5U/0PLhoUTkyt9QA4es8I+MEovmCKFKZno3xlw=; b=FX69N5uKCeIMKuHjP1gW9zQcx+
        cZ+RBGNWHCiZ1K9Yvamb599ZzzU0UKt/NjOwLP/J0QAvsrgHUmFEtnwxwuZnC0T404AcJl/z/lLFA
        Cu0/wNp+5JLPzsw2YiZzwqKr5Fut3jJYDe8l5CiVdpHW4BW2pdYH2gdRQR96NS5jodJAVgnx17oGX
        +jdnJrGAWA1um3adlNKSIlABEXA8qikH0tBAEZDOh9oVfBSeQbv7929xyi3jwHKUEc8doKv4gLm8G
        MLNOFO4hCK5CqOOfgMHGG4su+x/q2GeE6TP6tz55u50QhZUUVxA/u6Hmq44eRBgsp5tli7U+kYcvJ
        Uk0asL7w==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oDuLT-006k9d-IH; Tue, 19 Jul 2022 23:01:32 +0200
Message-ID: <8ef53978-f26e-89e3-8b04-6f0eb183f200@igalia.com>
Date:   Tue, 19 Jul 2022 18:00:39 -0300
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
 <8e201d99-78a8-d68c-6d33-676a1ba5a6ee@igalia.com>
 <c297ad10-fe5e-c2ee-5762-e037d051fe3b@linux.intel.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <c297ad10-fe5e-c2ee-5762-e037d051fe3b@linux.intel.com>
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

On 19/07/2022 17:48, Arjan van de Ven wrote:
> [...]
> I would totally support an approach where instead of pr_info, there's a tracepoint
> for these events (and that shouldnt' need to be conditional on a config option)
> 
> that's not what the patch does though.

This is a good idea Arjan! We could use trace events or pr_debug() -
which one do you prefer?

With that, we could maybe remove this Kconfig option, having it always
enabled, what do you think ?
