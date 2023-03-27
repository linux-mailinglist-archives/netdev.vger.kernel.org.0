Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4E36CA7E2
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjC0OkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjC0OkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:40:04 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23248A1;
        Mon, 27 Mar 2023 07:40:04 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s19so5305725pgi.0;
        Mon, 27 Mar 2023 07:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679928003;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SyYmTYsp48SN5GhFCO3GnJdP+uhW7qRHTOQPZ8beoaU=;
        b=g5EuLIiLm6gkT4v7NNIQ2Cy/jsRWj20OJQhSpNWH4CiOnpwEpikge+EitbC6MUTKfq
         mOr0qjYXCewmp68v/TZ28wgyLCzy/+s3oxKxymaX9laCrDnEfNX5CPmQEUrTBS58waL3
         nWplDyr9lsPGdhqp4GuzsD/LYqnE9Q6/Ra8sgxmg+KtdhNa7dzu/8c1ULrPJabq09gUA
         qgjFOvx2UDnxT/ids/pa43rWHymyjrR5Sz+aew2PTJwkjp5QfbrDigRZwUqbvxIcg6kH
         q0OP/wEvkEC7diU7ApViIXkMWGVbnCMD6fdySPqzajAWfrKq1xxrs6IuAODhuHZnc6y0
         kUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679928003;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SyYmTYsp48SN5GhFCO3GnJdP+uhW7qRHTOQPZ8beoaU=;
        b=B7DzhPo9x3PixWr/3aVROKAohA9HVfyp+MJ3B0tEba1OoYa+eT3bTOsNi8H6Izqixe
         hV336g6U7Cmth7s2b2/ewf5H6rl9JQIhHRMssQGEp7CjfqbAYN4zRpU8+vsKh0F9mZ78
         W7sysUN96KLA29ejp5z74YYntjdIjr0VMBS1Q613hBeZtyDjNZZFqw1xn0D/xx57IUuW
         Vs4J3QuxXd2bwbtYWEL729p5UTd/tFXmTnilY6sD1oA3994A/8NbsPdtbZyZwkoIIHMP
         KRL+kCF/7/qPA30UaSQapAxFz/s3itDcnXuxOGbG7uzmhzqi4bX/NGbXdr2+G0/Wur1o
         mpgQ==
X-Gm-Message-State: AAQBX9fV5VAK2P/fFQ//geDe/orMcfoE9bbHPWNxTm7GM6yNd44nmRr1
        5Y+qDixq9atGmLguniPs/14=
X-Google-Smtp-Source: AKy350Z+bLkSuLBES54vGvv3XE566i7LbqSCQqPUsHfk83sIinzJl5JNLzoGEQOgDR73iIuitB1qzQ==
X-Received: by 2002:aa7:8e88:0:b0:626:2cc8:311e with SMTP id a8-20020aa78e88000000b006262cc8311emr12245416pfr.12.1679928003516;
        Mon, 27 Mar 2023 07:40:03 -0700 (PDT)
Received: from [192.168.11.9] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79042000000b00625e885a6ffsm8929071pfo.18.2023.03.27.07.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 07:40:03 -0700 (PDT)
Message-ID: <a1d0d61c-d6e9-aee6-fe67-e35f42b76a04@gmail.com>
Date:   Mon, 27 Mar 2023 23:39:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     bagasdotme@gmail.com
Cc:     corbet@lwn.net, davem@davemloft.net, donald.hunter@gmail.com,
        donald.hunter@redhat.com, edumazet@google.com, kuba@kernel.org,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
References: <ZCGPy+90DsRpsicj@debian.me>
Subject: Re: [PATCH net-next v5 6/7] docs: netlink: document struct support
 for genetlink-legacy
Content-Language: en-US
From:   Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <ZCGPy+90DsRpsicj@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Date: Mon, 27 Mar 2023 19:44:59 +0700, Bagas Sanjaya wrote:
> On Mon, Mar 27, 2023 at 09:31:37AM +0100, Donald Hunter wrote:
[...]

>> +
>> +Here is the struct definition from above, declared in YAML:
>> +
>> +.. code-block:: yaml
>> +
>> +  definitions:
>> +    -
>> +      name: message-header
>> +      type: struct
>> +      members:
>> +        -
>> +          name: a
>> +          type: u8
>> +        -
>> +          name: b
>> +          type: u16
>> +        -
>> +          name: c
>> +          type: u8
>> +
> 
> Nit: The indentation for code-block codes should be relative to
> code-block:: declaration (e.g. if it starts from column 4, the first
> column of code is also at 4).

Hey Bagas,

I don't believe there is any such restriction. :-\
Where did you find it ?

        Thanks, Akira
