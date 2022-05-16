Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5D5289CB
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245727AbiEPQJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245713AbiEPQJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:09:45 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF32381AB;
        Mon, 16 May 2022 09:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZFn50ampduPG9oGRQUX2BMS6rY0kjBJ3j8a67GHebAM=; b=FcOPep8ePTWgqhN9kkuewdcNEP
        c+0DcuW1jGVdOvrXyeFbQQqAUYMA09npC4Byr3YGEoB/g2NkzWTt5Pixw+6iQWFOoxmTbFxaaHkCP
        GYMvVe3H+uOm3cet8cNwDTa56BrpIyiq1AnVWz2iVREpdKhDi1ibK7mTGwEsf+7L1BvRA0jP/ip7K
        3Wv2lFsKQ8u4mnZSuMW4kfL4laBmHOrAwA4a8EfUlxz4QT/0au4zO1sGM8rm2FSym85ndF4P4dT3N
        BwBBCS9eObHRceuash+pnFltB0GDgdDLOd7W2xfGhQiSAKVeJrd4klCmODWnoEukEx3MhnUQk8Saq
        p8THRBQA==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nqdHp-006sJN-Dt; Mon, 16 May 2022 18:09:33 +0200
Message-ID: <9f20619a-b405-2dc6-9771-b574b6f5058b@igalia.com>
Date:   Mon, 16 May 2022 13:09:04 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 23/30] printk: kmsg_dump: Introduce helper to inform
 number of dumpers
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, akpm@linux-foundation.org,
        bhe@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, senozhatsky@chromium.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, vgoyal@redhat.com,
        vkuznets@redhat.com, will@kernel.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-24-gpiccoli@igalia.com>
 <20220510134014.3923ccba@gandalf.local.home>
 <c8818906-f113-82b6-b58b-d47ae0c16b4f@igalia.com> <YoJkpAp8XdS7ROgd@alley>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YoJkpAp8XdS7ROgd@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/05/2022 11:50, Petr Mladek wrote:
> [...]
> Shame on me that I do not care that much about the style of the commit
> message :-)
> 
> Anyway, the code looks good to me. With the better commit message:
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 

Heheh, cool - I'll add your tag and improve the message in V2.
Thanks,


Guilherme
