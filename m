Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46289523E37
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 22:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347464AbiEKUAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 16:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbiEKUAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 16:00:33 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056A2231098;
        Wed, 11 May 2022 13:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gDHQr/46Ll+YF5RXidB7bzodWcAOTgjTzZrI+em3L64=; b=g39PxeAmrsyeqF7oG7t83UmsmK
        q+jHGkHAbmWvohxv26/jw0X2fC5ZQGAB+1t+RR3Dc/QcY0t/UuqqV0Rw0e0vNKpR3Ghg3EjPFEyRu
        xmyuTU8VIa0JckQ1LnJMbsmPzyPVIePtyYzY2GC02et+W2URhxptR9GwDO/JS6MpbzrCHGb/n2EjF
        MPTZc218MFC/xIv1c3Q0VBsXMBQNsxYCCeLWiYkZzdC6cvR08qY5ppLv8+FOFZTVkTAZbUvYrBQWZ
        fyGL7frjV8v7tGHHjzO9nQTkj7crGcqaoQ0KxvgjDlDQp5VOe0vE/nPeGF7YvXLizE8zXvpcRYVIg
        fCPXiI+Q==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nosV8-0008ee-V8; Wed, 11 May 2022 22:00:04 +0200
Message-ID: <1c7dfe73-6691-1ca5-7555-27e81dff4dcd@igalia.com>
Date:   Wed, 11 May 2022 16:58:43 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 22/30] panic: Introduce the panic post-reboot notifier
 list
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, pmladek@suse.com, bhe@redhat.com,
        akpm@linux-foundation.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kexec@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-23-gpiccoli@igalia.com>
 <7017c234-7c73-524a-11b6-fefdd5646f59@igalia.com> <YnvoPe2cTS31qbjb@osiris>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YnvoPe2cTS31qbjb@osiris>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/05/2022 13:45, Heiko Carstens wrote:
> [...]
>>
>> Hey S390/SPARC folks, sorry for the ping!
>>
>> Any reviews on this V1 would be greatly appreciated, I'm working on V2
>> and seeking feedback in the non-reviewed patches.
> 
> Sorry, missed that this is quite s390 specific. So, yes, this looks
> good to me and nice to see that one of the remaining CONFIG_S390 in
> common code will be removed!
> 
> For the s390 bits:
> Acked-by: Heiko Carstens <hca@linux.ibm.com>

No need for apologies, I really appreciate your review!
Will add your Ack for V2 =)

Cheers,


Guilherme
