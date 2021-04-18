Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED63635E1
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 16:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhDROcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 10:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhDROcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 10:32:05 -0400
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 6DA02C06174A;
        Sun, 18 Apr 2021 07:31:37 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id A246253E64D;
        Sun, 18 Apr 2021 14:31:35 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1618754464; t=1618756295;
        bh=978cxHn0Q+rZRoDQDYvCuquIb8hcItxZKjj5bKl0f4c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=yAVcyKOuU84jqexTakohpzoax5WxSllgOTwyeO7Bb7qnxGyTZ+20FLyJIaW8+FFT8
         eJoYBdAAM/2J/W33uyGYWfeXJAUzV9HJ1azLyT4qM5Osvz9RXLo20KtEqeEVSTmSGe
         hikLIEnh/qyvOkm7qhpVcNKsC8+OmgbZ4OPRtuzWSkmXnzgLMQ62EK9gqflYqaaku5
         HsrKaPGANI9WnMgS3yxkgzDWon/j/DfkUP8Q6xSARuFSS9VlrXI+FRmaXUzG7ZM5Z8
         Yj6G/QdfyY0C/YIBknaUuM5tpCy8SCXvACmVJO89Ty5TJb42WsocodsoUXXd8kH/4e
         PCdonkLHF/mVw==
Message-ID: <9e2966be-d210-edf9-4f3c-5681f0d07c5f@bluematt.me>
Date:   Sun, 18 Apr 2021 10:31:33 -0400
MIME-Version: 1.0
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
Content-Language: en-US
To:     Willy Tarreau <w@1wt.eu>
Cc:     Keyu Man <kman001@ucr.edu>, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com>
 <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
 <20210417072744.GB14109@1wt.eu>
 <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
 <20210417075030.GA14265@1wt.eu>
 <c6467c1c-54f5-8681-6e7d-aa1d9fc2ff32@bluematt.me>
 <CAMqUL6bAVE9p=XEnH4HdBmBfThaY3FDosqyr8yrQo6N_9+Jf3w@mail.gmail.com>
 <78d776a9-4299-ff4e-8ca2-096ec5c02d05@bluematt.me>
 <20210418043933.GB18896@1wt.eu>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <20210418043933.GB18896@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should the default, though, be so low? If someone is still using a old modem they can crank up the sysctl, it does seem 
like such things are pretty rare these days :). Its rather trivial to, without any kind of attack, hit 1Mbps of lost 
fragments in today's networks, at which point all fragments are dropped. After all, I submitted the patch to "scratch my 
own itch" :).

Matt

On 4/18/21 00:39, Willy Tarreau wrote:
> I do agree that we shouldn't keep them that long nowadays, we can't go
> too low without risking to break some slow transmission stacks (SLIP/PPP
> over modems for example).
