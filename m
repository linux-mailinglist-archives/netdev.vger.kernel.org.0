Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDAC274EC9
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 03:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgIWB7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 21:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgIWB7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 21:59:20 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B934C061755;
        Tue, 22 Sep 2020 18:59:20 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id w16so23277258oia.2;
        Tue, 22 Sep 2020 18:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7P8Z5oLsyCerSIKlM6E32eue5tyujrExNojN0rVKp4c=;
        b=SIca7xw3I2B5Ygs0Wl3SSHMG7Ax13OlBQSO6xP3YFeorOBjUPSTMTt3tDBWLI4kH5e
         bAs4xcAjF3eDbmpVTscI5MFsy/aD92NcmiOMUcJYRfemSpGJhCDPr9PxWarh0PtCJ4ID
         iQuHQL8fPvF4WmVhzXvpswsVhKQyHzCjeuAdhdp3frqlqazEAzlpTjX01LRg2wc8Uh/a
         ITavhGTy4XsvZNDzhUBF062jPLXK8KGQ9aT5nlFyViGoKdE4e5JEml+FirLxGL9hgZox
         1hVRISrmgcxk78QDJjPAOkXtG3ttQcCEn2hSiKTJTgv48Mh0TXsWT9ZrZkWkR1h7z6B9
         qtRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7P8Z5oLsyCerSIKlM6E32eue5tyujrExNojN0rVKp4c=;
        b=awzJFMwjqy82Ju5AYCfudOCGradbEAvlasC9SaPOd/FQmDzAs31ClXraoS032hPj6w
         hmKXW4qNpSVOsDw3vUaVGj0L5sXB/a3R/uNz3gMbI+7iCUNx/y4BCyjJAVjTtpklTfIr
         tWKB0cBf+tp8gOPHJP5NqJLPax/BDHCQDcGlM3mItK/ZACy1cIFo//A2Inq9zKM0fRKp
         qD4Maq+sZ4Oxq8BlkWWOBz6Rl4gT7Efi1X6uRpBOqHBByS6Dnkv3o/1jy5S6uH4cYf5V
         igfNHviB6fexyoKtM9aP9FQlNrwyPKdIsWKKAethFWcAcC/ZtkqazCfd2QL3fq9A1rbO
         3kCg==
X-Gm-Message-State: AOAM532SUDYGnQgSUnjtkNMuO+v0BphhrE9zojhGDZXyK1hpR3VC2peg
        h1mjyXh2gxns2e6JMBPWwQ/Co/MQXYLleg==
X-Google-Smtp-Source: ABdhPJwFgBU3Bqd0Qz23sLfSX/ck5Sct4I0//xmj62Ks9s6EaY8F4dWijhshu0sKY6gDeDI2o00dDQ==
X-Received: by 2002:a54:411a:: with SMTP id l26mr4090990oic.12.1600826359482;
        Tue, 22 Sep 2020 18:59:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9c91:44fa:d629:96cc])
        by smtp.googlemail.com with ESMTPSA id n186sm8883429oob.11.2020.09.22.18.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 18:59:18 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
To:     Michael Jeanson <mjeanson@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
 <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
 <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
 <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
 <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
 <1135414696.37989.1600782730509.JavaMail.zimbra@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4456259a-979a-7821-ef3d-aed5d330ed2b@gmail.com>
Date:   Tue, 22 Sep 2020 19:59:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1135414696.37989.1600782730509.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/20 7:52 AM, Michael Jeanson wrote:
>>>
>>> the test setup is bad. You have r1 dropping the MTU in VRF red, but not
>>> telling VRF red how to send back the ICMP. e.g., for IPv4 add:
>>>
>>>    ip -netns r1 ro add vrf red 172.16.1.0/24 dev blue
>>>
>>> do the same for v6.
>>>
>>> Also, I do not see a reason for r2; I suggest dropping it. What you are
>>> testing is icmp crossing VRF with route leaking, so there should not be
>>> a need for r2 which leads to asymmetrical routing (172.16.1.0 via r1 and
>>> the return via r2).
> 
> The objective of the test was to replicate a clients environment where
> packets are crossing from a VRF which has a route back to the source to
> one which doesn't while reaching a ttl of 0. If the route lookup for the
> icmp error is done on the interface in the first VRF, it can be routed to
> the source but not on the interface in the second VRF which is the
> current behaviour for icmp errors generated while crossing between VRFs.
> 
> There may be a better test case that doesn't involve asymmetric routing
> to test this but it's the only way I found to replicate this.
> 

It should work without asymmetric routing; adding the return route to
the second vrf as I mentioned above fixes the FRAG_NEEDED problem. It
should work for TTL as well.

Adding a second pass on the tests with the return through r2 is fine,
but add a first pass for the more typical case.
