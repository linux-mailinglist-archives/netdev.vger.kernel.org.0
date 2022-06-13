Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FC2547E43
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 05:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiFMDws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 23:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiFMDwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 23:52:47 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D412EA473
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:52:45 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id y12so4877749ior.7
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GMvTVsdJ8mQykEcuoSjqPE6dKTDMLfBaXHrwIlkIMrE=;
        b=RND1UwoSD8YLlHWwAWuVNAJGelNLIxPLi671q8p7uvRm5BcSlda2fCla4TNuAYFB9a
         8aaIZiRhbQfNUxnBApq4gNCuiExxvArKuvbnzj5GYsodoENU5iUN6XcAQrBMqnLxVR3r
         mrP4rvjIURIpD5dtmw63N3pXXoR1cDZTDhPKTW69gFSm4po7gpOdDV11j5MfjE/wb5FN
         M69jxP73pvFOQYuvqLvEYruKMg9myHPxwVSj83AQOkmOoGykTg3XdAQrK0feiWEMLDK5
         toAkSjQcBnOKfHNbEHWxU+QipH2FpekQA4iGXDEAPXqlwJBFfQmFbsWsT7V8KyBdB1v6
         M6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GMvTVsdJ8mQykEcuoSjqPE6dKTDMLfBaXHrwIlkIMrE=;
        b=DYuKqwwk1e9DUJEXPB1xB8s4+8yi089Z5081wcLOuLnyeVvXRxl8zPs3pgVFteaK50
         7p9E0vEBzJ4rqIQyFoL3H6Xh57kfOdW9QZh8DRNOSi3cNT/edqjP+V6O0CEq5o5J5VfL
         9dChFs8y0BD5nD7HrnQLQBz4sU1UvsNcmSZO2BtpqD4iIVnir1j315BriVYl1WMzG1x4
         I/3coqwjYrJgwH0AlFeApHwQSzZpc09GU9HhAwyVVCBS50Wjwu3NFBgvlgye7nMMXsio
         W5psGZtPrvFGCLc0BM+WlTLKxyGxJtMO7gjV2IZYyGrSM103VRV8XJRZds7re4H+yCOZ
         WwEg==
X-Gm-Message-State: AOAM533N/9yEzWBzqNH8jeSZAOuHYw5fM+ypgwvH8fS+1qHzlyopoPWg
        XGpUDy0P1gR5vg0GT5hN4ux7Wc57ARqcnw==
X-Google-Smtp-Source: ABdhPJyXO2OzXUCAg9nx19sgk33KeuseEJQAWKWz3aEU1o9UBUTSFx4qfs9wo/HwXcqp47LmJbdIGQ==
X-Received: by 2002:a05:6602:26cb:b0:648:f391:c37d with SMTP id g11-20020a05660226cb00b00648f391c37dmr27409254ioo.198.1655092365265;
        Sun, 12 Jun 2022 20:52:45 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:2155:12f8:267b:81f3? ([2601:282:800:dc80:2155:12f8:267b:81f3])
        by smtp.googlemail.com with ESMTPSA id g21-20020a056602073500b0065a47e16f4esm3405420iox.32.2022.06.12.20.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 20:52:44 -0700 (PDT)
Message-ID: <cb80378b-a8da-7dea-ea71-eed25a21a345@gmail.com>
Date:   Sun, 12 Jun 2022 21:52:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] net: prefer socket bound to interface when not in VRF
Content-Language: en-US
To:     Benjamin Poirier <bpoirier@nvidia.com>,
        Mike Manning <mvrmanning@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Saikrishna Arcot <sarcot@microsoft.com>,
        Craig Gallek <kraig@google.com>
References: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
 <YqarphOzFTnQRq29@d3>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YqarphOzFTnQRq29@d3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/22 9:14 PM, Benjamin Poirier wrote:
> On 2021-10-05 14:03 +0100, Mike Manning wrote:
> [...]
>>
>> Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
>> Fixes: e78190581aff ("net: ensure unbound stream socket to be chosen when not in a VRF")
>> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
>> ---
>>
>> diff nettest-baseline-9e9fb7655ed5.txt nettest-fix.txt
>> 955,956c955,956
>> < TEST: IPv4 TCP connection over VRF with SNAT                                  [FAIL]
>> < TEST: IPv6 TCP connection over VRF with SNAT                                  [FAIL]
>> ---
>>> TEST: IPv4 TCP connection over VRF with SNAT                                  [ OK ]
>>> TEST: IPv6 TCP connection over VRF with SNAT                                  [ OK ]
>> 958,959c958,959
>> < Tests passed: 713
>> < Tests failed:   5
>> ---
>>> Tests passed: 715
>>> Tests failed:   3
>>
>> ---
>>  net/ipv4/inet_hashtables.c  | 4 +++-
>>  net/ipv4/udp.c              | 3 ++-
>>  net/ipv6/inet6_hashtables.c | 2 +-
>>  net/ipv6/udp.c              | 3 ++-
>>  4 files changed, 8 insertions(+), 4 deletions(-)
>>
> 
> Hi Mike,
> 
> I was looking at this commit, 8d6c414cd2fb ("net: prefer socket bound to
> interface when not in VRF"), and I get the feeling that it is only
> partially effective. It works with UDP connected sockets but it doesn't
> work for TCP and UDP unconnected sockets.
> 
> The compute_score() functions are a bit misleading. Because of the
> reuseport shortcut in their callers (inet_lhash2_lookup() and the like),
> the first socket with score > 0 may be chosen, not necessarily the
> socket with highest score. In order to prefer certain sockets, I think
> an approach like commit d894ba18d4e4 ("soreuseport: fix ordering for
> mixed v4/v6 sockets") would be needed. What do you think?
> 
> Extra info:
> 1) fcnal-test.sh results
> 
> I tried to reproduce the fcnal-test.sh test results quoted above but in
> my case the test cases already pass at 8d6c414cd2fb^ and 9e9fb7655ed5.
> Moreover I believe those test cases don't have multiple listening
> sockets. So that just added to my confusion.
> 
> Running 9e9fb7655ed5,
> root@vsid:/src/linux/tools/testing/selftests/net# ./fcnal-test.sh -t use_cases

use_cases group is a catchall for bug reports. You want run all of the
TCP and UDP cases to cover socket permutations and I know some of those
cover dual listeners (though I can't remember ATM if that is only the
MD5 tests). If not, you can add them fairly easily and illustrate your
point.

As for compute_score, it does weight device binds a bit higher. TCP:

score =  sk->sk_bound_dev_if ? 2 : 1;

UDP:
if (sk->sk_bound_dev_if)
        score += 4;
