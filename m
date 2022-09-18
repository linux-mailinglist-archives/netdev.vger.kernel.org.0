Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FFC5BBE41
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 16:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiIROH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 10:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIROH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 10:07:56 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E40A20BE6;
        Sun, 18 Sep 2022 07:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pUONd9sTqqHQ9FE2X+xGZAJj/F2FA6dWtFbnIt7IXCg=; b=Za15UwOf4JMKB5OmKPAEs5edyT
        hm9DBfC6AsVVDWlpk9jCR4RAJfwFxZvDBrPDjM7FPnR8CQc6mnBPbKklp7RpkSg4uy7U5yWxfzDX6
        JGpBwlA7CMGkwxkfQse6Yv3rxgd3PfZyGrBnDK02+oXytNWrwtPF3kVodolPV60FDA/NMeFa/UUn7
        gG6zBfOO50qgALjpJ96tN0pA0MQ4+wvlONb0Ch2KCmDtBCukEU9WKOKSEiq89eXdrevIhn73mbVOx
        PkVhR+YO0CncisJIdaDg0n5k838u/ihZy+9z2xY8V62ivgFkp2wbPQ90xXuvii5z0SGorsSoJbLyg
        gkOx3KIA==;
Received: from 201-27-35-168.dsl.telesp.net.br ([201.27.35.168] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oZuxQ-0081WM-IK; Sun, 18 Sep 2022 16:07:40 +0200
Message-ID: <8cbe154c-4564-9480-e429-9599a215a651@igalia.com>
Date:   Sun, 18 Sep 2022 11:07:12 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH V3 07/11] notifiers: Add tracepoints to the notifiers
 infrastructure
Content-Language: en-US
To:     akpm@linux-foundation.org, Xiaoming Ni <nixiaoming@huawei.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Cc:     kexec@lists.infradead.org, bhe@redhat.com, pmladek@suse.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
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
        will@kernel.org, xuqiang36@huawei.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-8-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-8-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> Currently there is no way to show the callback names for registered,
> unregistered or executed notifiers. This is very useful for debug
> purposes, hence add this functionality here in the form of notifiers'
> tracepoints, one per operation.
> 
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: Xiaoming Ni <nixiaoming@huawei.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V3:
> - Yet another major change - thanks to Arjan's great suggestion,
> refactored the code to make use of tracepoints instead of guarding
> the output with a Kconfig debug setting.
> 
> V2:
> - Major improvement thanks to the great idea from Xiaoming - changed
> all the ksym wheel reinvention to printk %ps modifier;
> 
> - Instead of ifdefs, using IS_ENABLED() - thanks Steven.
> 
> - Removed an unlikely() hint on debug path.
> 
> [...]

Hi Arjan / Xioming, apologies for the ping.
Do you think the patch is good enough now? I liked the tracepoint
approach, indeed it was a much better idea than guarding the prints with
the DEBUG Kconfig heheh

Appreciate your opinions!
Thanks in advance,


Guilherme
