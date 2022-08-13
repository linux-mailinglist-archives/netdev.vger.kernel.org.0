Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285B3591BFB
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 18:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbiHMQUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 12:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239760AbiHMQUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 12:20:51 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B454610FDF;
        Sat, 13 Aug 2022 09:20:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660407605; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=LYtSCUqODWDHtBj51efKKORt0d0g0I/kHwHw5VwPHEK5JV8Lxum5HjFup/SWb2vXW5pF1EJTrrFYxZQQcaMpgcHjwaAjYULpP5eB3lrKcplOmb46LgbXPC1VHqkcJ37Z2mnSuDXSmFJQD58c7Ilis3x326WDVIc9ltCh0+QotVE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660407605; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=U3torEU8ue1d6ut66EvgIXpz48aBqMmo4NWWLjEFBMM=; 
        b=Kxp8AbQulGvoO7w+Q3UIFPNEhau0uskWwPGJCY5SfvR9ag1xR0xLSp4mB1B/9o5ssZim+eYi2xQmCAQqOzz2qXLn3ESW1aqqbJjU7xakVvbuBjPayiGQ3rQ9Kr4LYthATXF+KPa1uV+NZimTiUqrn89X1soo6YFXJM4yU5poy8E=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660407605;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=U3torEU8ue1d6ut66EvgIXpz48aBqMmo4NWWLjEFBMM=;
        b=Df3uVVWBXUIoDMCL+puzzLoUIoh7jD0UuVSUAZpQO47W5tw3m/s46kDkvmNzBMmk
        10XFsSKNcEodQ4JIib9Pde2L22YHccxbCQSazfdGyGzlq3vdIJqky5oqTXmScAO/Oe3
        7aEpts9XZVD2umtCTWFdQzaIJi6Bqx/TvIBn3a1g=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1660407592922781.0334173208613; Sat, 13 Aug 2022 21:49:52 +0530 (IST)
Date:   Sat, 13 Aug 2022 21:49:52 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "greg kh" <gregkh@linuxfoundation.org>,
        "johannes berg" <johannes@sipsolutions.net>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "paolo abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "syzbot+6cb476b7c69916a0caca" 
        <syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "syzbot+f9acff9bf08a845f225d" 
        <syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com>,
        "syzbot+9250865a55539d384347" 
        <syzbot+9250865a55539d384347@syzkaller.appspotmail.com>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <182980137c6.5665bf61226802.3084448395277966678@siddh.me>
In-Reply-To: <20220812122509.281f0536@kernel.org>
References: <20220726123921.29664-1-code@siddh.me>
        <18291779771.584fa6ab156295.3990923778713440655@siddh.me>
        <YvZEfnjGIpH6XjsD@kroah.com>
        <18292791718.88f48d22175003.6675210189148271554@siddh.me>
        <YvZxfpY4JUqvsOG5@kroah.com>
        <18292e1dcd8.2359a549180213.8185874405406307019@siddh.me> <20220812122509.281f0536@kernel.org>
Subject: Re: [PATCH v2] wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Aug 2022 00:55:09 +0530  Jakub Kicinski  wrote:
> Similarly to Greg, I'm not very familiar with the code base but one
> sure way to move things forward would be to point out a commit which
> broke things and put it in a Fixes tag. Much easier to validate a fix
> by looking at where things went wrong.

Thanks, I now looked at some history.

The following commit on 28 Sep 2020 put the kfree call before NULLing:
c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")

The following commit on 19 Nov 2014 introduces RCU:
6ea0a69ca21b ("mac80211: rcu-ify scan and scheduled scan request pointers")

The kfree call wasn't "rcu-ified" in this commit, and neither were
RCU heads added.

The following commit on 18 Dec 2014 added RCU head for sched_scan_req:
31a60ed1e95a ("nl80211: Convert sched_scan_req pointer to RCU pointer")

It seems a similar thing might not have been done for scan_req, but I
could have also missed commits.

So what should go into the fixes tag, if any? Probably 6ea0a69ca21b?

Also, I probably should use RCU_INIT_POINTER in this patch. Or should
I make a patch somewhat like 31a60ed1e95a?

Thanks,
Siddh
