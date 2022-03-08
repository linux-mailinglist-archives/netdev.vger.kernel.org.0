Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1784D269A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiCIBTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiCIBSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:18:39 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B78D14CC95
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 17:09:01 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o23so596492pgk.13
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 17:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MusoGpUv1p2zQy1RvldH76aZNXuwQdYMtqN07IJwAnI=;
        b=ds1htgBVmHtliaUjeJHGy47FCcuSJ0JBWXo0VtlQQtURq7/Uzjk8Q+tM+H4kvFQtMA
         MGmn4AMMe9bgbvAKGCpoE2zt2K6IUmx28wNr1rocIo+PGyarjK62FSYOhTdAGsMVKeg2
         HBkybG6PPKZUunsf9ub8/91bSAliJqSWJUeF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MusoGpUv1p2zQy1RvldH76aZNXuwQdYMtqN07IJwAnI=;
        b=GyTj5jtn/KXZ8wSiKRhzUUUYnIYwf2GcVQpTvjZa/bHWbKO2VIHr02OtyC8cgJLfDO
         2bJJ7vibCnH0t7ZlFx/4+lTqYn8cODQnvYXZ87YvWaQ8/sul25jVjTM6oH7qd/tGgfDL
         zMqXKhETpG4oRmWmn//nwvxMdFnIben+fEierZQANc6w62xB7pbAKw0p/5wxU3X+z4l5
         cBAN6wrhigLBMJ/BDjRG6h6BwYj4Z/mwawtGNw6kFqsJd6oGtL/JieQGr3HMejh6x7m7
         FF/qfRQ1kSnkENnwiWOnc1v/+B84Q20GNgQYZAVGcMT6/8qL9xOjm0Rerb6+EsHRAq28
         Wa1A==
X-Gm-Message-State: AOAM53096cmRT6Tnp2vtb8GHOh3sC/KKR4aCEcGzGCYwNKRzM4dqih/O
        7d7TlyxN49gCI2gAlXNTCfip1qec57YDkA==
X-Google-Smtp-Source: ABdhPJynsZ5A+Ab/kN8RTDK2ahNjxuyh0PquXXQBfvfkGdUy/rfUBZmutFfvNjFABdN7j3fH8jeMfg==
X-Received: by 2002:a92:c568:0:b0:2c2:9ad2:a787 with SMTP id b8-20020a92c568000000b002c29ad2a787mr17982333ilj.228.1646783508042;
        Tue, 08 Mar 2022 15:51:48 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id n5-20020a056e02148500b002c426e077d4sm208510ilk.19.2022.03.08.15.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 15:51:47 -0800 (PST)
Subject: Re: [PATCH net 0/2] selftests: pmtu.sh: Fix cleanup of processes
 launched in subshell.
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1646776561.git.gnault@redhat.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <36d7619f-0fb4-e23b-2d2b-e0d27fd517ee@linuxfoundation.org>
Date:   Tue, 8 Mar 2022 16:51:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <cover.1646776561.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 3:14 PM, Guillaume Nault wrote:
> Depending on the options used, pmtu.sh may launch tcpdump and nettest
> processes in the background. However it fails to clean them up after
> the tests complete.
> 
> Patch 1 allows the cleanup() function to read the list of PIDs launched
> by the tests.
> Patch 2 fixes the way the nettest PIDs are retrieved.
> 
> v2:
>    * Use tcpdump's immediate mode to capture packets even in short lived
>      tests.
>    * Add patch 2 to fix the nettest_pids list.
> 
> Guillaume Nault (2):
>    selftests: pmtu.sh: Kill tcpdump processes launched by subshell.
>    selftests: pmtu.sh: Kill nettest processes launched in subshell.
> 
>   tools/testing/selftests/net/pmtu.sh | 21 +++++++++++++++++----
>   1 file changed, 17 insertions(+), 4 deletions(-)
> 

Both of these look good to me. One nit on commit header. Please
include net in the patch subject line in the future.

e.g: selftests:net pmtu.sh

Tested them on my system. Seeing these messages even after building
nettest:

'nettest' command not found; skipping tests
   xfrm6udp not supported
TEST: vti6: PMTU exceptions (ESP-in-UDP)                            [SKIP]
'nettest' command not found; skipping tests
   xfrm4udp not supported
TEST: vti4: PMTU exceptions (ESP-in-UDP)                            [SKIP]
'nettest' command not found; skipping tests
   xfrm6udprouted not supported
TEST: vti6: PMTU exceptions, routed (ESP-in-UDP)                    [SKIP]
'nettest' command not found; skipping tests
   xfrm4udprouted not supported

Might not be related to this patch though. I jusr ran pmtu.sh from
net directory.


Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

