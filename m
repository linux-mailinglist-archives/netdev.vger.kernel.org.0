Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A5A6B057D
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjCHLKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjCHLKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:10:18 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43E39EF67
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 03:10:16 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r18so14988455wrx.1
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 03:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678273815;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R5KxqxsCE5OkU+lsucXpiyBxVUa95jE3K3CanvMwcZk=;
        b=Gdp+twmN7YoWPOwI1B2rFmiMEdcUU0+g3T4j+yf37qkyoaHBlB9oZ88Gbxmzj7sK5F
         3ezxELfmoF/+xbVG98PLZGk/0LxWciSBzcIUNP+F0eUAbOZHpVeHJxhOzIUFRJhVd9Vg
         LWC41AO4cxI3HiEEN8fFvDNZr9Qmk9HkBFAgFq+lypwrn+SlCCP0Dgx7A6esqurqrKPw
         t/m159wQryRTQOUQx67iUdcig4/SrPUu7Xxkx8KwtzOw4M7XDnYJSX+6tlNQ9AZjGekf
         GeUteVwZwCzT+N6DfI1cARg4CR3KlPSo+JOw/S7CBw64zELNIKggXYw/vu8LyHulpcDm
         jw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678273815;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R5KxqxsCE5OkU+lsucXpiyBxVUa95jE3K3CanvMwcZk=;
        b=jWc8oKctdMT+HG6A6aVEQ20SmMdSUUYtp8zOSD1opDQczTV3/FPcKwqnQ85MIPtLRV
         u1P4oNGT7VjUiWk1Rwn9Ck84E2Op1kEAwQTupa53nnCvU3gd18Er95ZIGRpC8AH83ZUW
         rCKqo6/ncyo/9ySxJ1MLBbG15BDr8YEbg/O0W+s9x2dZDUOyUKsSrWEmlPoE3F/1JIFC
         H0epbaffmSTAFj3HotpJ0n8CSU/HmCz4X1pROEcz8LRToD5ryxAQsvk0TUY5kOc9M4Jw
         3TCiOoCw6IudiWE+jgVyQFfsaXhtdP76lRlh+rlyhezWRVLRm83ksBezr8qQJIIMzPZ0
         CsUw==
X-Gm-Message-State: AO0yUKVfpRGb/yFdz4i6KUiYR79A1XIadmiCz8typHYPb0NWeM9ovzmW
        GFnyo2HqcSDT1cY7SgpvhvcVGQ==
X-Google-Smtp-Source: AK7set+i9zLCYxpSAfqjRIsD4Rx5j+P1dOFGWsiOKP70AfDgLY4yqUMAL2IQUK4/bSYWMUh9XXPT9Q==
X-Received: by 2002:a5d:69cc:0:b0:2c7:17db:bf5c with SMTP id s12-20020a5d69cc000000b002c717dbbf5cmr9882765wrw.25.1678273815330;
        Wed, 08 Mar 2023 03:10:15 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id a13-20020a5d508d000000b002c54536c662sm15202465wrt.34.2023.03.08.03.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 03:10:15 -0800 (PST)
Message-ID: <c7766c78-8947-79ca-992d-fe5300774ff9@blackwall.org>
Date:   Wed, 8 Mar 2023 13:10:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHv2 nf-next 6/6] selftests: add a selftest for big tcp
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>, netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
References: <cover.1678224658.git.lucien.xin@gmail.com>
 <c1ae6bb8f9c67c14437c7714efed7fd2ec551258.1678224658.git.lucien.xin@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <c1ae6bb8f9c67c14437c7714efed7fd2ec551258.1678224658.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2023 23:31, Xin Long wrote:
> This test runs on the client-router-server topo, and monitors the traffic
> on the RX devices of router and server while sending BIG TCP packets with
> netperf from client to server. Meanwhile, it changes 'tso' on the TX devs
> and 'gro' on the RX devs. Then it checks if any BIG TCP packets appears
> on the RX devs with 'ip/ip6tables -m length ! --length 0:65535' for each
> case.
> 
> Note that we also add tc action ct in link1 ingress to cover the ipv6
> jumbo packets process in nf_ct_skb_network_trim() of nf_conntrack_ovs.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Reviewed-by: Aaron Conole <aconole@redhat.com>
> ---
>  tools/testing/selftests/net/Makefile   |   1 +
>  tools/testing/selftests/net/big_tcp.sh | 180 +++++++++++++++++++++++++
>  2 files changed, 181 insertions(+)
>  create mode 100755 tools/testing/selftests/net/big_tcp.sh

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


