Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E322A5ADA23
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiIEUYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIEUYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:24:24 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3CA6113A
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 13:24:19 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id j26so5794728wms.0
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 13:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=wlyo+5iK/1uo9/64yjQ2ELZxRLIzl1XF18VskNivGNE=;
        b=ETlCi5JPk/fvJRK3wkXwhNsSXmNCkUXKF2KR8HA0KOU+ga/StHDOaZUDBzOmJr/Zou
         qlCCfMlzEjjH87shQ+AElP83rFCkLN/635NLcbvIwVxG5VyI42dKB3Ti94hZ9lwc+wFg
         nbX0UBxLgo9gTV5+udOzLjXXxbq0mhfKcxy7QFWV6nsK6P2a7cBFdctqM6IOq0ytltBf
         iHHw6ROWi+XmLxrgyDDt+N6sSw4UVeFOz35LZnM/hEJg7Wy7Z+L4jg+d/0so+aAv3GEM
         Fn0MgGPhcjGEG5FX1W3gUA57aNXJ18/xj8W6CzaO0XZ2uMqpUtpqPgtWM5aBO13y0Owy
         oIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=wlyo+5iK/1uo9/64yjQ2ELZxRLIzl1XF18VskNivGNE=;
        b=MU1Yk+vj4GNhd+fRdqHEqnVk230v7mZLg7S8cEy5cHy8z1GywDYaJiA0AZQJeOlXvP
         lFwewPyepnKCKxAra32HLyKlpnLzwyBInJLmbEMYVahywJNUA1YQgccHhHCLOZz+RerC
         UTe5gTZRxo2h5DLqacSJEpU64ejjUZGFNnG922p1yFG4+g0sP49SRZrk1fZlK68fNaZZ
         tHOMUuL4VCrgnggKTG9k9vDIT3gccHoJydjNCWkAvkw6z3j91DSpKUgqH1LJkGj62jEe
         49tO9vALPwTjP3aMznQfQ6KSoYm2NgVm8WSi72KWc0TXIsPKqylggDV6GxB6tvt5+mgZ
         oeUg==
X-Gm-Message-State: ACgBeo2TTupG22JrwuppvXZD9NSATNAeTJD6Ilzkh4/wVO9jpUNqyMoL
        86G1rrOoevxAVyl55J9W+YVlVQ==
X-Google-Smtp-Source: AA6agR7KJn/aGLt/PsCEULFrz221gkhfqlcXADY+GUxjuKx3jSBzBosg6ByMqLWSXlmipfR3wgoLpQ==
X-Received: by 2002:a05:600c:2193:b0:3a5:346f:57d0 with SMTP id e19-20020a05600c219300b003a5346f57d0mr11547037wme.124.1662409458450;
        Mon, 05 Sep 2022 13:24:18 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id w4-20020adfee44000000b0022863c18b93sm5790695wro.13.2022.09.05.13.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 13:24:17 -0700 (PDT)
Message-ID: <003aca05-00e6-8661-a330-686096be89bd@arista.com>
Date:   Mon, 5 Sep 2022 21:24:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 25/31] selftests/net: Add TCP-AO library
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-26-dima@arista.com>
 <aa0143bc-b0d1-69fb-c117-1e7241f0ad89@linuxfoundation.org>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <aa0143bc-b0d1-69fb-c117-1e7241f0ad89@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/22 16:47, Shuah Khan wrote:
> On 8/18/22 10:59 AM, Dmitry Safonov wrote:
>> Provide functions to create selftests dedicated to TCP-AO.
>> They can run in parallel, as they use temporary net namespaces.
>> They can be very specific to the feature being tested.
>> This will allow to create a lot of TCP-AO tests, without complicating
>> one binary with many --options and to create scenarios, that are
>> hard to put in bash script that uses one binary.
>>
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> ---
>>   tools/testing/selftests/Makefile              |   1 +
>>   tools/testing/selftests/net/tcp_ao/.gitignore |   2 +
>>   tools/testing/selftests/net/tcp_ao/Makefile   |  45 +++
>>   tools/testing/selftests/net/tcp_ao/connect.c  |  81 +++++
>>   .../testing/selftests/net/tcp_ao/lib/aolib.h  | 333 +++++++++++++++++
>>   .../selftests/net/tcp_ao/lib/netlink.c        | 341 ++++++++++++++++++
>>   tools/testing/selftests/net/tcp_ao/lib/proc.c | 267 ++++++++++++++
>>   .../testing/selftests/net/tcp_ao/lib/setup.c  | 297 +++++++++++++++
>>   tools/testing/selftests/net/tcp_ao/lib/sock.c | 294 +++++++++++++++
>>   .../testing/selftests/net/tcp_ao/lib/utils.c  |  30 ++
>>   10 files changed, 1691 insertions(+)
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/.gitignore
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/Makefile
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/connect.c
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/aolib.h
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/netlink.c
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/proc.c
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/setup.c
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/sock.c
>>   create mode 100644 tools/testing/selftests/net/tcp_ao/lib/utils.c
>>
>> diff --git a/tools/testing/selftests/Makefile
>> b/tools/testing/selftests/Makefile
>> index 10b34bb03bc1..2a3b15a13ccb 100644
>> --- a/tools/testing/selftests/Makefile
>> +++ b/tools/testing/selftests/Makefile
>> @@ -46,6 +46,7 @@ TARGETS += net
>>   TARGETS += net/af_unix
>>   TARGETS += net/forwarding
>>   TARGETS += net/mptcp
>> +TARGETS += net/tcp_ao
> 
> Please look into a wayto invoke all of them instead of adding individual
> net/* to the main Makefile. This list seems to be growing. :)

Sent a patch separately to allow sub-dir defining their $(TARGETS):
https://lore.kernel.org/all/20220905202108.89338-1-dima@arista.com/T/#u

Will rebase this patch set if the other gets in :)

> 
>>   TARGETS += netfilter
>>   TARGETS += nsfs
>>   TARGETS += pidfd
> 
> [snip]

[..]
Thanks,
          Dmitry
