Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3796B7911
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCMNfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjCMNew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:34:52 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD6A59818
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:34:48 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id p26so7997934wmc.4
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678714487;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C3w1hmQ11OX4n8F2TaszLNoeRya/4qEkLaswuCtCJG8=;
        b=fW3qN1w0/alWy1T1bDYnOC921UIOyzZylbLOWSVAOJD0+9JUprSSzJe14hJ/QAuGCH
         2Dt+98hRS8ottz5jqQr1Bf4f2zyfRwNpfp2J/aszLoj79T04NXy5IeXqmuceMVrGxfmn
         sCzDArYQhg1gyNlASE2TM4d7h3SWIN32NnKlrQuTe8VMoejteIK0wXGtIyZ8LjTCGdA/
         EakbeyEUQllyjLgoewWl8NnhVErvS1cJC9tZxaDwXWdrEkcEBaqfUj/WyQ0rYHXvyEhE
         AcdR6WXGOzcD7uA4ReeNow18jkGrCIEOd+RZ5xK3okZ7GHjt9nCLb06Lh9EptmD/7R/B
         37CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678714487;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3w1hmQ11OX4n8F2TaszLNoeRya/4qEkLaswuCtCJG8=;
        b=dhtHMhyJ0whTZ4Zb+xRONdyGyZxQ6Y9y+ntxVHu+CasWHg/XVLcKcjfelDOPxrSsVJ
         WFBZiqnHhoE/BMlMX4vHeBuTQN6PFXgchXVjN4vhSF7L2+WZmQy811XYQViFOgtHSkCk
         7RV+r+KnuRJKA+5vb8oqv1Z9fcMd5Fr+p+EodyHqMmKOVTKNAT1Cb+pdzlyKrr0+LYuC
         2nXB3qaik5e3q5ELSp6Oj+yO9OzJTs2WzHaRCMn7QScumOBcQu/zjd7cHQE4+ECvL6dp
         oIJ6J3xlN0nnkPC9Oy9gSjx2E7gz3IBhGv4+qttSweLKz7E3oAEu4MOlQmhmnXQyd6Qc
         W6DQ==
X-Gm-Message-State: AO0yUKX1KPqCokPa2uSPgqpHH20kh6SbfC6XHDYyzjZHS605kJSvu5lW
        z1CbXuOwHK8UohzboAFg7ZQJP868HL2g2kuDeh8=
X-Google-Smtp-Source: AK7set+bC7p+8f5OCZ1sMK99msJO9az95i9Hs3xhYPz48q+6QVm9I+P/OZsPUx82QHc454owOoiEWw==
X-Received: by 2002:a05:600c:358d:b0:3df:e6bb:768 with SMTP id p13-20020a05600c358d00b003dfe6bb0768mr10424108wmq.24.1678714486738;
        Mon, 13 Mar 2023 06:34:46 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d44d1000000b002c5691f13eesm7884659wrr.50.2023.03.13.06.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 06:34:46 -0700 (PDT)
Message-ID: <95af874d-626e-00d0-b418-052323e00dd1@blackwall.org>
Date:   Mon, 13 Mar 2023 15:34:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 2/2] selftests: rtnetlink: add a bond test trying to
 enslave non-eth dev
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     syoshida@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230313132834.946360-1-razor@blackwall.org>
 <20230313132834.946360-3-razor@blackwall.org>
 <7caf0c99-fb6a-389a-4b1e-f2cfe83b258d@blackwall.org>
In-Reply-To: <7caf0c99-fb6a-389a-4b1e-f2cfe83b258d@blackwall.org>
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

On 13/03/2023 15:32, Nikolay Aleksandrov wrote:
> On 13/03/2023 15:28, Nikolay Aleksandrov wrote:
> [snip]
>> +kci_test_enslaved_bond_non_eth()
>> +{
>> +	local ret=0
>> +
>> +	ip link add name test-nlmon0 type nlmon
>> +	ip link add name test-bond0 type bond
>> +	ip link add name test-bond1 type bond
>> +	ip link set dev test-bond0 master test-bond1
>> +	ip link set dev test-nlmon0 master test-bond0 1>/dev/null 2>/dev/null
>> +
>> +	ip -d l sh dev test-bond0 | grep -q "SLAVE"
>> +	if [ $? -ne 0 ]; then
>> +		echo "FAIL: IFF_SLAVE flag is missing from the bond device"
>> +		check_err 1
>> +	fi
>> +	ip -d l sh dev test-bond0 | grep -q "MASTER"
>> +	if [ $? -ne 0 ]; then
>> +		echo "FAIL: IFF_MASTER flag is missing from the bond device"
>> +		check_err 1
>> +	fi
>> +
>> +	# on error we return before cleaning up as that may hang the system
> 
> I wasn't sure if this part was ok, let me know if you prefer to always attempt cleaning up
> and I'll send v2 moving the return after the cleanup attempt.
> 

Actually sorry for the noise, I'll just send v2 instead with that change.
I don't have a good argument why we shouldn't attempt a cleanup after printing
the error messages even if the system hangs.

