Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4035569020E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBIIYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBIIYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:24:15 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A964F5BB2
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:24:14 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id m2so3999448ejb.8
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 00:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=El/eQRB9yhNDVbsyMGqKU4oQ0Q74MtAF8R0BcKylaqk=;
        b=3v5R4qiBVq9xM6wLqd0c+DpbRhP9+tZtjDzbvwbfeoPESvrF4juCtFgGyLrP+Zfs9E
         /LILszyUzaEEC+48igySPuXXMfC8m1m1d0aP+gp9pUpz0cTNX2hLDRLixS7lC/0hTu9F
         GDN7gbqvP6vXL3j7MVmQzX2XS3UaJixA+3bUQJuz0iOVl16s9lHfGbVJ3KqOZ2Sdrctn
         EhsZtWxk3oZVhnHf3V/xLXYBGKAn6MTkG2L+Kw0DS66OlXjaNUIR3UfcpCONlidkfRQz
         EWWaqAP9aDdLaoTafn6pTNugqWs2ceVbVs15xLojebZQ4ru7pMubAHWfvXsf6l/DW0CO
         h3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=El/eQRB9yhNDVbsyMGqKU4oQ0Q74MtAF8R0BcKylaqk=;
        b=bipSd/1aSqEtz6iuWHRvt+Kzhxd+GZQd0OQPXmXaM5Jj+A3MkAFd4LfcRnoPr8iGJw
         BbY5R8s67P5khlUszmGSaIM69+JsNinLltbhjI+D+r/Do2KFbMda/atYgCIlwb3W/r7L
         8WHNGM12dXpaT5B8xxCXQpKZoYJAIibEAAhO8dBV1uwLvRRGltX+XImVsXwvqah8bsTD
         i5hj6k3KRNxrYfFBbQgFezMX66ecPLbGvf7m33yk7KhWSyQhJqk/syg313lg4Fcc7wvs
         GBCPUo3m/mFjmux3b25lfFhwMuPORmh1uC214ZzSaS7got1pPhG0CdCl3/uJTOfdyiVf
         3vIQ==
X-Gm-Message-State: AO0yUKVctruQmbMbkR/LG+sFnNcDhZnolx2BDKt3V/Q/0U+3IW0ODkEm
        v7Bf8Oi/o/G2K+cIQna0PcYvQw==
X-Google-Smtp-Source: AK7set/jbC+og9VFjGivS6G29TZo00HmpHLt8QNywmtSV61KLYDhVFFtQbr2y3KgqCYfqcmCVoE7nA==
X-Received: by 2002:a17:906:1ec8:b0:88d:5fd1:3197 with SMTP id m8-20020a1709061ec800b0088d5fd13197mr10669050ejj.50.1675931053264;
        Thu, 09 Feb 2023 00:24:13 -0800 (PST)
Received: from [192.168.100.228] (212-147-51-13.fix.access.vtx.ch. [212.147.51.13])
        by smtp.gmail.com with ESMTPSA id n17-20020a170906165100b008af3fd7a1e7sm265464ejd.121.2023.02.09.00.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 00:24:13 -0800 (PST)
Message-ID: <e69754d3-dead-5477-266b-8618f567ac34@blackwall.org>
Date:   Thu, 9 Feb 2023 09:24:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 4/4] selftests: forwarding: Add MDB dump test
 cases
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230209071852.613102-1-idosch@nvidia.com>
 <20230209071852.613102-5-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230209071852.613102-5-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/23 09:18, Ido Schimmel wrote:
> The kernel maintains three markers for the MDB dump:
> 
> 1. The last bridge device from which the MDB was dumped.
> 2. The last MDB entry from which the MDB was dumped.
> 3. The last port-group entry that was dumped.
> 
> Add test cases for large scale MDB dump to make sure that all the
> configured entries are dumped and that the markers are used correctly.
> 
> Specifically, create 2 bridges with 32 ports and add 256 MDB entries in
> which all the ports are member of. Test that each bridge reports 8192
> (256 * 32) permanent entries. Do that with IPv4, IPv6 and L2 MDB
> entries.
> 
> On my system, MDB dump of the above is contained in about 50 netlink
> messages.
> 
> Example output:
> 
>   # ./bridge_mdb.sh
>   [...]
>   INFO: # Large scale dump tests
>   TEST: IPv4 large scale dump tests                                   [ OK ]
>   TEST: IPv6 large scale dump tests                                   [ OK ]
>   TEST: L2 large scale dump tests                                     [ OK ]
>   [...]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> ---
>   .../selftests/net/forwarding/bridge_mdb.sh    | 99 +++++++++++++++++++
>   1 file changed, 99 insertions(+)
> 

Nice!
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

