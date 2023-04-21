Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9346EB06B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjDURRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjDURRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:17:04 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59561F0;
        Fri, 21 Apr 2023 10:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=O9bS4BH4zwkU0FNfcO8Vby/NQH4R/p2peke6phXOuvE=; b=eGtondh91bcAngIFLqdAt8LaJR
        nSOUSqpLH4CJrlwcIVVmgQcz7fRjzrkji15dbDy34VbEICd82oDuqgzPabWtPeZt4skEJby+5m9BQ
        fZ1FHpRqj8eedWUYl6wM3uPZHXMJ0RpGOgArWYkn/PGqZ6TDbsh6mh8znQelkf8LtlqcpB18vuRz9
        MBuV4yiRMyyEph5npnSEhdafj8Iv5QkcB9aaQv/7PTusfeeaS03O3ow+Iub50g6OVodpb3XKXF1ox
        08QAdXA2n6CImerL1j9WPFsUY4B5RsqmtRv4RDbdnJJF7bzHxFvJjQkTyUoaH4fBifs+RDbf3T4FQ
        zMwhaUgQ==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1ppu8O-000DJa-44; Fri, 21 Apr 2023 19:01:20 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ppu8N-00025F-AL; Fri, 21 Apr 2023 19:01:19 +0200
Subject: Re: [PATCH bpf,v2 4/4] selftests/bpf: Add tc_socket_lookup tests
To:     Stanislav Fomichev <sdf@google.com>,
        Gilad Sever <gilad9366@gmail.com>
Cc:     dsahern@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        ast@kernel.org, andrii@kernel.org, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org,
        hawk@kernel.org, joe@wand.net.nz, eyal.birger@gmail.com,
        shmulik.ladkani@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20230420145041.508434-1-gilad9366@gmail.com>
 <20230420145041.508434-5-gilad9366@gmail.com> <ZEFr1M0PDziB2c9g@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <87edff5b-5d41-01ec-c629-b2634f894afc@iogearbox.net>
Date:   Fri, 21 Apr 2023 19:01:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ZEFr1M0PDziB2c9g@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26883/Fri Apr 21 09:25:39 2023)
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/23 6:44 PM, Stanislav Fomichev wrote:
> On 04/20, Gilad Sever wrote:
>> Verify that socket lookup via TC with all BPF APIs is VRF aware.
>>
>> Signed-off-by: Gilad Sever <gilad9366@gmail.com>
>> ---
>> v2: Fix build by initializing vars with -1
Agree with Stan on all the refactoring changes and if we can simplify the
set without them. The other item on top of what has been commented is that
it would be great to also add test case for XDP as well to ensure that the
lookup behavior is consistent for both cases.

Thanks,
Daniel
