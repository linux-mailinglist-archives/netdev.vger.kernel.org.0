Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A0F6010CC
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiJQOKj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Oct 2022 10:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJQOKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:10:37 -0400
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3254F1A6;
        Mon, 17 Oct 2022 07:10:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C252561F0A8B;
        Mon, 17 Oct 2022 16:10:30 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 7Bqt5iK7Mhen; Mon, 17 Oct 2022 16:10:30 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 2CC3A62EFE89;
        Mon, 17 Oct 2022 16:10:30 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id eGcU3lunn7ZX; Mon, 17 Oct 2022 16:10:30 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id CC4CA61F0A8B;
        Mon, 17 Oct 2022 16:10:29 +0200 (CEST)
Date:   Mon, 17 Oct 2022 16:10:29 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-um <linux-um@lists.infradead.org>,
        kexec <kexec@lists.infradead.org>, bhe <bhe@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv <linux-hyperv@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, x86 <x86@kernel.org>,
        kernel-dev <kernel-dev@igalia.com>, kernel <kernel@gpiccoli.net>,
        halves <halves@canonical.com>,
        fabiomirmar <fabiomirmar@gmail.com>,
        alejandro j jimenez <alejandro.j.jimenez@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, bp <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        d hatayama <d.hatayama@jp.fujitsu.com>,
        dave hansen <dave.hansen@linux.intel.com>,
        dyoung <dyoung@redhat.com>, feng tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mikelley <mikelley@microsoft.com>,
        hidehiro kawai ez <hidehiro.kawai.ez@hitachi.com>,
        jgross <jgross@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        mhiramat <mhiramat@kernel.org>, mingo <mingo@redhat.com>,
        paulmck <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        senozhatsky <senozhatsky@chromium.org>,
        stern <stern@rowland.harvard.edu>, tglx <tglx@linutronix.de>,
        vgoyal <vgoyal@redhat.com>, vkuznets <vkuznets@redhat.com>,
        will <will@kernel.org>, xuqiang36 <xuqiang36@huawei.com>,
        anton ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <422015181.40644.1666015829599.JavaMail.zimbra@nod.at>
In-Reply-To: <280ce0ae-5a50-626f-930f-2661a109fa36@igalia.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com> <20220819221731.480795-5-gpiccoli@igalia.com> <1f464f3d-6668-9e05-bcb7-1b419b5373e1@igalia.com> <2087154222.237106.1663535981252.JavaMail.zimbra@nod.at> <280ce0ae-5a50-626f-930f-2661a109fa36@igalia.com>
Subject: Re: [PATCH V3 04/11] um: Improve panic notifiers consistency and
 ordering
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Improve panic notifiers consistency and ordering
Thread-Index: kqQk2RczEaY2s6Uahti6roceJKzQkQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
> Hi Richard / Johannes, is there any news on this one?
> Thanks in advance,

It's upstream:
git.kernel.org/linus/758dfdb9185cf94160f20e85bbe05583e3cd4ff4

Thanks,
//richard
