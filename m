Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF0D517342
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386064AbiEBPym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 11:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240096AbiEBPyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 11:54:39 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE602AC2;
        Mon,  2 May 2022 08:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vs1TxitJVaqXfZt5+JAgzgpJc3Rl9y+sqSF7sQt0958=; b=CYM+I+cStAj6nsmkdvAL01St6e
        IV8WQNLOxWhy3UHpXhc9ZYxNJzq7ZxpyOwHWort+30gmSz14Tjb7K8kvM2hGR2PPX3dc7GXMEaskm
        g34Tjq/8qIJgML47/2DCuEUnFB03pqMfnk/uwmQB09CDWgBvh7TL/gFDoH0TI9HOJ3bezLUV1DrKv
        MwXxD9LKMhdDIB0wdDr6Kr32RysL68LVvKOkDfa5SERbORMzBS0ZyutauBA2Ekqa3472ChMBhe54V
        1FaXK1lleaqm8beFaaq7IO5wyd2Jb5T5RV+lvaTO/6luDzRXN43duubtlHaOQOQQCOGaRTF8O2nxl
        BUemy2kw==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nlYKD-0006x9-MY; Mon, 02 May 2022 17:51:01 +0200
Message-ID: <af03a6ef-6b92-31cd-72d4-47b82bc47f87@igalia.com>
Date:   Mon, 2 May 2022 12:50:35 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 15/30] bus: brcmstb_gisb: Clean-up panic/die notifiers
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>, akpm@linux-foundation.org,
        bhe@redhat.com, pmladek@suse.com, kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
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
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Brian Norris <computersforpeace@gmail.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-16-gpiccoli@igalia.com>
 <eaf3a893-00dd-8717-202e-911b395670e1@gmail.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <eaf3a893-00dd-8717-202e-911b395670e1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/05/2022 12:38, Florian Fainelli wrote:
> [...] 
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Not sure if the Fixes tag is warranted however as this is a clean up, 
> and not really fixing a bug.

Perfect, thanks Florian. I'll add your ACK and remove the fixes tag in V2.
Cheers,


Guilherme
