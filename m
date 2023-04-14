Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3916E2841
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDNQ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDNQ0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:26:08 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231CA26A6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:26:06 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id u12so6389734lfu.5
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681489564; x=1684081564;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cmnRNEYCLIJ7M4GcMMXsK4qvUaXrsYePBaOvZ/Hf4J8=;
        b=VP894qxw55hAiuE3tVmhkZEtJd3Co2Inwou1jXUSQ7BDmin3lj9Lxt4iiDItvufcW+
         2TVUSHwlluXBxBczo1sarTV8cnnxrU4cXI4zJ6sW0VZQ7nIRdqhYFbbeU23EJGXrjpqe
         BVghYOAA7I80kF+mng70sOPrjCQ1Wz3KEOUL6mneNAdvFzW1UMDn3WgKuIB+eGI2WZr3
         X4P2H0Vb/0dqnAJ1AOwqW/urUnzlxtQY9Ft/FcxVF+QH8EzNMM6nuY3sKqRZDGAqz6pp
         0y6GcF6UOdJ3pz2FdgC+GclcuK97+CH/05lk1OS/l/6AQZH+nVwTMNKP9tcR7RNMgizR
         IJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681489564; x=1684081564;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cmnRNEYCLIJ7M4GcMMXsK4qvUaXrsYePBaOvZ/Hf4J8=;
        b=WzLoOzvtMlWvNkTZDbjyLmbtKuF7gvkFE/3Bal7H/dVcI2e5qiizUDno+YmYborr4h
         z1Ow+S62U6CFAYSMdp6fqyg85Wkk12qga8LgNglJO9gfeiAcVK8MAcuLiiVolQPkSDgA
         cQERImRvLvlxxUGDj9rc2oOQKSg0OP19BPPYVQ1PoGlijJrnYiqPPCTm4OcDueKtp4Uu
         LKyfSn2WeSpNCQdFCZQ0ix5fEbRCoN30XuntnqXeOlP6C7QdTPgTBoF96pXM5C7oALun
         0yqXyV9EspYp9b/5rR9uU2LF94uP95F2JFNSmw+aSAnZ0G2S7hiRx+aVdamy/xEqtFQG
         2L9g==
X-Gm-Message-State: AAQBX9fq4aAdhIURSz5ZoSPFUott1sc1g+pYjf5Evc1bSbIS6FyfX8i7
        ZnylZbxBYvgTYg4dqu/EX5+/MFevxvqKig==
X-Google-Smtp-Source: AKy350bsKaVsosBQgAbbee0hhpWknEODhDUsgbzJzm/gsoqx/Q5cuaywsJb5+dBG837cvnDTQXRhPA==
X-Received: by 2002:a05:6512:90c:b0:4ec:83ac:675e with SMTP id e12-20020a056512090c00b004ec83ac675emr1789215lft.68.1681489564345;
        Fri, 14 Apr 2023 09:26:04 -0700 (PDT)
Received: from [192.168.10.208] (c-9b3c524e.03-153-73746f67.bbcust.telenor.se. [78.82.60.155])
        by smtp.gmail.com with ESMTPSA id w2-20020ac254a2000000b004dc4bb914c7sm860854lfk.201.2023.04.14.09.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 09:26:03 -0700 (PDT)
Message-ID: <65b59170-28c2-2e3b-f435-2bdcc6d7b10c@gmail.com>
Date:   Fri, 14 Apr 2023 18:26:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: iproute2 bug in json output for encap
From:   Lars Ekman <uablrek@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <e3bfc8e6-5522-4e65-373e-976388533765@gmail.com>
 <20230414082103.1b7c0d82@hermes.local>
 <cf099564-2b3c-e525-82cd-2d8065ba7fb3@gmail.com>
Content-Language: en-US
In-Reply-To: <cf099564-2b3c-e525-82cd-2d8065ba7fb3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again,

Digging a little deeper I see that the double "dst" items will cause
problems with most (all?) json parsers. I intend to use "go" and json
parsing will be parsed to a "map" (hash-table) so duplicate keys will
not work.

https://stackoverflow.com/questions/21832701/does-json-syntax-allow-duplicate-keys-in-an-object

IMHO it would be better to use a structured "encap" item. Something like;

[ {
    "dst": "192.168.11.0/24",
    "encap": {
        "protocol": "ip6",
        "id": 0,
        "src": "::",
        "dst": "fd00::c0a8:2dd",
        "hoplimit": 0,
        "tc": 0
    },
    "scope": "link",
    "flags": [ ]
} ]

Best Regards,

Lars Ekman



On 2023-04-14 18:12, Lars Ekman wrote:
> Hi,
>
> Thanks for the reply. You are right, it is jq that eats one ot the
> double "dst" items.
>
> vm-002 ~ # ip -j -p route show proto 5
> [ {
>         "dst": "192.168.11.0/24",
>         "encap": "ip6",
>         "id": 0,
>         "src": "::",
>         "dst": "fd00::c0a8:2dd",
>         "hoplimit": 0,
>         "tc": 0,
>         "dev": "dummy0",
>         "scope": "link",
>         "flags": [ ]
>     } ]
> vm-002 ~ # ip -j -p route show proto 5 | jq
> [
>   {
>     "dst": "fd00::c0a8:2dd",
>     "encap": "ip6",
>     "id": 0,
>     "src": "::",
>     "hoplimit": 0,
>     "tc": 0,
>     "dev": "dummy0",
>     "scope": "link",
>     "flags": []
>   }
> ]
>
> Sorry for the fuss.
>
> Best Regards,
>
> Lars Ekman
>
>
> And btw I did upgrade *before* posting :-)
>
> vm-002 ~ # ip -V
> ip utility, iproute2-6.2.0, libbpf 1.1.0
> vm-002 ~ # uname -r
> 6.2.7
>
>
>
> On 2023-04-14 17:21, Stephen Hemminger wrote:
>> On Fri, 14 Apr 2023 10:29:15 +0200
>> Lars Ekman <uablrek@gmail.com> wrote:
>>
>>> The destination is lost in json printout and replaced by the encap 
>>> destination. The destination can even be ipv6 for an ipv4 route.
>>>
>>> Example:
>>>
>>> vm-002 ~ # ip route add 10.0.0.0/24 proto 5 dev ip6tnl6 encap ip6 dst 
>>> fd00::192.168.2.221
>>> vm-002 ~ # ip route show proto 5
>>> 10.0.0.0/24  encap ip6 id 0 src :: dst fd00::c0a8:2dd hoplimit 0 tc 0 
>>> dev ip6tnl6 scope link
>>> vm-002 ~ # ip -j route show proto 5 | jq
>>> [
>>>    {
>>>      "dst": "fd00::c0a8:2dd",
>>>      "encap": "ip6",
>>>      "id": 0,
>>>      "src": "::",
>>>      "hoplimit": 0,
>>>      "tc": 0,
>>>      "dev": "ip6tnl6",
>>>      "scope": "link",
>>>      "flags": []
>>>    }
>>> ]
>>>
>> Both JSON and regular output show the same address which is coming from
>> the kernel.  I.e not a JSON problem. Also, you don't need to use jq
>> ip has -p flag to pretty print.
>>
>> I can not reproduce this with current kernel and iproute2.
>> # ip route add 192.168.11.0/24 proto 5 dev dummy0 encap ip6 dst fd00::192.168.2.221
>>
>> # ip route show proto 5
>> 192.168.11.0/24  encap ip6 id 0 src :: dst fd00::c0a8:2dd hoplimit 0 tc 0 dev dummy0 scope link 
>>
>> # ip -j -p route show proto 5
>> [ {
>>         "dst": "192.168.11.0/24",
>>         "encap": "ip6",
>>         "id": 0,
>>         "src": "::",
>>         "dst": "fd00::c0a8:2dd",
>>         "hoplimit": 0,
>>         "tc": 0,
>>         "dev": "dummy0",
>>         "scope": "link",
>>         "flags": [ ]
>>     } ]
>>
>>
>> # ip -V
>> ip utility, iproute2-6.1.0, libbpf 1.1.0
>> # uname -r
>> 6.1.0-7-amd64
>>
>>
