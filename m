Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF78032CE8A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhCDIc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbhCDIcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:32:11 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4EBC06175F;
        Thu,  4 Mar 2021 00:31:31 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lHjO1-00BY6u-PZ; Thu, 04 Mar 2021 09:31:09 +0100
Message-ID: <fcf796892ce3e1b469a1f29ba1763a1652d72044.camel@sipsolutions.net>
Subject: Re: BUG: soft lockup in ieee80211_tasklet_handler
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+27df43cf7ae73de7d8ee@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Date:   Thu, 04 Mar 2021 09:30:52 +0100
In-Reply-To: <CACT4Y+ahrV-L8vV8Jm8XP=KwjWivFj445GULY1fbRN9t7buMGw@mail.gmail.com> (sfid-20210302_200147_707197_23EAE1A3)
References: <00000000000039404305bc049fa5@google.com>
         <20210224023026.3001-1-hdanton@sina.com>
         <0a0573f07a7e1468f83d52afcf8f5ba356725740.camel@sipsolutions.net>
         <CACT4Y+ahrV-L8vV8Jm8XP=KwjWivFj445GULY1fbRN9t7buMGw@mail.gmail.com>
         (sfid-20210302_200147_707197_23EAE1A3)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-03-02 at 20:01 +0100, Dmitry Vyukov wrote:
> 
> Looking at the reproducer that mostly contains just perf_event_open,
> It may be the old known issue of perf_event_open with some extreme
> parameters bringing down kernel.
> +perf maintainers
> And as far as I remember +Peter had some patch to restrict
> perf_event_open parameters.
> 
> r0 = perf_event_open(&(0x7f000001d000)={0x1, 0x70, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0x3ff, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xfffffffe, 0x0, @perf_config_ext}, 0x0,
> 0x0, 0xffffffffffffffff, 0x0)

Oh! Thanks for looking.

Seems that also applies to

https://syzkaller.appspot.com/bug?extid=d6219cf21f26bdfcc22e

FWIW. I was still tracking that one, but never had a chance to look at
it (also way down the list since it was reported as directly in hwsim)

johannes

