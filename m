Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150444D2016
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 19:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349547AbiCHSXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 13:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349582AbiCHSW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 13:22:57 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B7556C36;
        Tue,  8 Mar 2022 10:22:00 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id d62so21889102iog.13;
        Tue, 08 Mar 2022 10:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s/aSiwa4OsaHjuhB4cvErlX8E1QGHNTboTB9+HLwgwM=;
        b=BoYmw4Rvgt6yhXyB4+VaRBsgw0ePcMEN6wWZRJOPq0es17z7AeBjjcA8YmH0IBehdv
         lkScxEgiLLYR35oagmriDRJn+6HOQ7xEyN6QmEDu9XqC5ldLetKIRN51ulKxsdqMMOwh
         DF6D1320yOVQmRBhXS32wKqt0RGJuDb5OHKwK8eRVEeChIard+JPBoLbRrgfxXTfIIFF
         gS9mp1Z5/cCmj+qZRVpoGVaKwwKQ3ZIdS+lljZfuwbdt70KPLy2p2V9JA5QjS5Qb5Hi+
         jF4KRxoWC5tuvO0jJET3YdkwQpRQahzoPXuh4QX9PURGUwG/o9P8vTg/7DvibxJpXBv3
         JvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s/aSiwa4OsaHjuhB4cvErlX8E1QGHNTboTB9+HLwgwM=;
        b=aQim8hBY8635MRPkxSJE0xECGZ3zFRkln1wm3pLPIwDQIagnX07MQGFtHym8WJQkLp
         +XXUlrk0Pl6QHTvRcrlHXfk4/Hz11+rfww8FfS9wkFlJvfNoAbRdO3EDCwSYFIydkCTO
         o+347glSuQrDSnKcjuRz7WGv+HVEFA0/2BCGYJrBsOaV8Y5/L+RlHwNIXymsUtAqsonn
         lYlGtIV+WVpBBDcpPJCCMeTBU36L4KwcySAHZhrwsX1cNK/Se0QNAPURtppldUZ1qhu9
         enKWrzygW3XyFr9edKorb7PFyhxTY4n6LLsIV5RsXmFFzPpoTenTGcUuUB46vpd37VGO
         xO5A==
X-Gm-Message-State: AOAM5313xTvLWwOYX7d/Obqbw3+zMsNU71OWPsc5RWrrJiX/J1s96Gm3
        d0C6Thn8WHJCxYcGSWmoHhNabD4bRpzOqA==
X-Google-Smtp-Source: ABdhPJy/s5NdsXuzzi8pgnnpYVqjxwKV0qqx6sRD/Oy+zF12aUgXpmdGwFA5KAa469//b1DAiqNS+w==
X-Received: by 2002:a05:6638:240d:b0:314:dd3c:81cc with SMTP id z13-20020a056638240d00b00314dd3c81ccmr16419365jat.287.1646763720041;
        Tue, 08 Mar 2022 10:22:00 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id r9-20020a056e0219c900b002c5ffafa701sm12672716ill.79.2022.03.08.10.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 10:21:59 -0800 (PST)
Message-ID: <d5a67e6a-6e1b-8f69-8d2a-e05708dfa3c9@gmail.com>
Date:   Tue, 8 Mar 2022 11:21:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net] selftests: pmtu.sh: Kill tcpdump processes launched
 by subshell.
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
References: <0378c55466d8d1f7b6d99d581811d49429e1f4e7.1646691728.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <0378c55466d8d1f7b6d99d581811d49429e1f4e7.1646691728.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/22 3:38 PM, Guillaume Nault wrote:
> The cleanup() function takes care of killing processes launched by the
> test functions. It relies on variables like ${tcpdump_pids} to get the
> relevant PIDs. But tests are run in their own subshell, so updated
> *_pids values are invisible to other shells. Therefore cleanup() never
> sees any process to kill:
> 
> $ ./tools/testing/selftests/net/pmtu.sh -t pmtu_ipv4_exception
> TEST: ipv4: PMTU exceptions                                         [ OK ]
> TEST: ipv4: PMTU exceptions - nexthop objects                       [ OK ]
> 
> $ pgrep -af tcpdump
> 6084 tcpdump -s 0 -i veth_A-R1 -w pmtu_ipv4_exception_veth_A-R1.pcap
> 6085 tcpdump -s 0 -i veth_R1-A -w pmtu_ipv4_exception_veth_R1-A.pcap
> 6086 tcpdump -s 0 -i veth_R1-B -w pmtu_ipv4_exception_veth_R1-B.pcap
> 6087 tcpdump -s 0 -i veth_B-R1 -w pmtu_ipv4_exception_veth_B-R1.pcap
> 6088 tcpdump -s 0 -i veth_A-R2 -w pmtu_ipv4_exception_veth_A-R2.pcap
> 6089 tcpdump -s 0 -i veth_R2-A -w pmtu_ipv4_exception_veth_R2-A.pcap
> 6090 tcpdump -s 0 -i veth_R2-B -w pmtu_ipv4_exception_veth_R2-B.pcap
> 6091 tcpdump -s 0 -i veth_B-R2 -w pmtu_ipv4_exception_veth_B-R2.pcap
> 6228 tcpdump -s 0 -i veth_A-R1 -w pmtu_ipv4_exception_veth_A-R1.pcap
> 6229 tcpdump -s 0 -i veth_R1-A -w pmtu_ipv4_exception_veth_R1-A.pcap
> 6230 tcpdump -s 0 -i veth_R1-B -w pmtu_ipv4_exception_veth_R1-B.pcap
> 6231 tcpdump -s 0 -i veth_B-R1 -w pmtu_ipv4_exception_veth_B-R1.pcap
> 6232 tcpdump -s 0 -i veth_A-R2 -w pmtu_ipv4_exception_veth_A-R2.pcap
> 6233 tcpdump -s 0 -i veth_R2-A -w pmtu_ipv4_exception_veth_R2-A.pcap
> 6234 tcpdump -s 0 -i veth_R2-B -w pmtu_ipv4_exception_veth_R2-B.pcap
> 6235 tcpdump -s 0 -i veth_B-R2 -w pmtu_ipv4_exception_veth_B-R2.pcap
> 
> Fix this by running cleanup() in the context of the test subshell.
> Now that each test cleans the environment after completion, there's no
> need for calling cleanup() again when the next test starts. So let's
> drop it from the setup() function. This is okay because cleanup() is
> also called when pmtu.sh starts, so even the first test starts in a
> clean environment.
> 
> Note: PAUSE_ON_FAIL is still evaluated before cleanup(), so one can
> still inspect the test environment upon failure when using -p.
> 
> Fixes: a92a0a7b8e7c ("selftests: pmtu: Simplify cleanup and namespace names")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  tools/testing/selftests/net/pmtu.sh | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


