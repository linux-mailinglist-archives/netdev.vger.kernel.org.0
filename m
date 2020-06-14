Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229791F8B42
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 01:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgFNXHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 19:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgFNXHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 19:07:19 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354CCC05BD43;
        Sun, 14 Jun 2020 16:07:19 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id D5FF51B599B;
        Sun, 14 Jun 2020 23:07:11 +0000 (UTC)
Subject: Re: Good idea to rename files in include/uapi/ ?
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
 <20200614223456.13807a00@redhat.com>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <5033402c-d95c-eecd-db84-75195b159fab@al2klimov.de>
Date:   Mon, 15 Jun 2020 01:07:10 +0200
MIME-Version: 1.0
In-Reply-To: <20200614223456.13807a00@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
X-Spam-Level: **
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 14.06.20 um 22:34 schrieb Stefano Brivio:
> On Sun, 14 Jun 2020 21:41:17 +0200
> "Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:
> 
>> Hello there!
>>
>> At the moment one can't checkout a clean working directory w/o any
>> changed files on a case-insensitive FS as the following file names have
>> lower-case duplicates:
> 
> They are not duplicates: matching extensions are lowercase, target
> extensions are uppercase. DSCP is the extension to set DSCP bits, dscp
> is the extension to match on those packet bits.
> 
>> ➜  linux git:(96144c58abe7) git ls-files |sort -f |uniq -id
>> include/uapi/linux/netfilter/xt_CONNMARK.h
>> include/uapi/linux/netfilter/xt_DSCP.h
>> include/uapi/linux/netfilter/xt_MARK.h
>> include/uapi/linux/netfilter/xt_RATEEST.h
>> include/uapi/linux/netfilter/xt_TCPMSS.h
>> include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>> include/uapi/linux/netfilter_ipv4/ipt_TTL.h
>> include/uapi/linux/netfilter_ipv6/ip6t_HL.h
>> net/netfilter/xt_DSCP.c
>> net/netfilter/xt_HL.c
>> net/netfilter/xt_RATEEST.c
>> net/netfilter/xt_TCPMSS.c
>> tools/memory-model/litmus-tests/Z6.0+pooncelock+poonceLock+pombonce.litmus
>> ➜  linux git:(96144c58abe7)
>>
>> Also even on a case-sensitive one VIm seems to have trouble with editing
>> both case-insensitively equal files at the same time.
> 
> ...what trouble exactly?
vi -O2 include/uapi/linux/netfilter/xt_CONNMARK.h 
include/uapi/linux/netfilter/xt_connmark.h

... opens the first file two times.

> 
>> I was going to make a patch renaming the respective duplicates, but I'm
>> not sure:
>>
>> *Is it a good idea to rename files in include/uapi/ ?*
> 
> I'm not sure it's a good idea to even use git on a case-insensitive
> filesystem. I'm curious, what is your use case?
My MacOS workstation. Now as I discovered the problem I've created a r/w 
image with a c/s FS, but the need of that for a clean `git checkout .' 
is IMAO pretty silly.

Don't worry, I run Linux, but only on my servers.

Also this issue should also apply to M$ Windows workstations. By the way 
at work I actually use Git on Windows if needed and it also just works. 
However the software I work on doesn't have this issue.

> 
