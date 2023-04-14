Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894296E281C
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjDNQM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjDNQMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:12:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80D7212F
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:12:09 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id e11so23989478lfc.10
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681488728; x=1684080728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C+48Lt6Oy4T+uvw6F1JZdIx5fDA909CJ1drJYimb/Bg=;
        b=d/TvXTAuG/mGBB4JEiv6T1ZCb3xD+HqML5AJ7sQx5bCE+/1cVgSWK2nqptingKo/n6
         vgNwTehmL28coDZdLokkao89Oh8CjFwIKcxwn/G0jPCvzRE13CHAPw/oMalXYkZUHtxo
         ZvYyDoNnCFKCEwAKPePqZXX7m5UP0Drx1544RcOfzm3EasgfdeOjl/nqgH8xK/qGQqTp
         +EzpiRhNHpF4nf73As4m9sbemnOkKMLohK2a78HZuFGn1IPgQLeKWBayEZyanuu4/z8t
         l1Z0gwSe1Yj9izr/YMX0PUS4yb6/FHHinchQ6CZ+D2y0KLH6PTSaBj+5L3EHwL3GjF9U
         VkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681488728; x=1684080728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C+48Lt6Oy4T+uvw6F1JZdIx5fDA909CJ1drJYimb/Bg=;
        b=J7KkE8HFyXxV+xT0D63g2WhFmQPlMeVqTTWcWhHlHFANnPK90SBP38S/r3Mv7oworx
         +AAcDc5t1ulis3tiBenfGwUXOopKTxcvsX1WylngjBCSAC+/2jChXiDiFg8gmiGDY0NV
         ZtUpKhg9DQEQchnLk9GQ6OpNg6X48kBmzWPmQdHNQxhs3RqTQdKNAtp24VXlyr06Fb7Z
         06t6M65RuLCGlbG0TpJiHBMvj1aUbV4UNrjM07NfLfASKEyu7wsaOH4qbVnGc67xbgJB
         nKiLoP4jvIou2EPH96gLN4rWgUhbZy6BnigKW89sMnC4j3gQirUudmKFE1y1RSChtjdj
         5PjQ==
X-Gm-Message-State: AAQBX9f55+RnnggyWSA54R7cx7THiYBJDpWAlQUUX7JHtql97QRyx5x9
        3M4dfnYbp/6WiZJ4EhJiOYGN67e+vhHniA==
X-Google-Smtp-Source: AKy350ZczgXfiAx48TFIvHc5oNuztpNslSXVU+h5T3L7mVOqo+MDl8I8bSh4BLCx9KjC10JLzfVLnQ==
X-Received: by 2002:ac2:5581:0:b0:4eb:dd2:f3d2 with SMTP id v1-20020ac25581000000b004eb0dd2f3d2mr2227247lfg.43.1681488727652;
        Fri, 14 Apr 2023 09:12:07 -0700 (PDT)
Received: from [192.168.10.208] (c-9b3c524e.03-153-73746f67.bbcust.telenor.se. [78.82.60.155])
        by smtp.gmail.com with ESMTPSA id f15-20020a19ae0f000000b004ece331c830sm736177lfc.206.2023.04.14.09.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 09:12:07 -0700 (PDT)
Message-ID: <cf099564-2b3c-e525-82cd-2d8065ba7fb3@gmail.com>
Date:   Fri, 14 Apr 2023 18:12:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: iproute2 bug in json output for encap
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <e3bfc8e6-5522-4e65-373e-976388533765@gmail.com>
 <20230414082103.1b7c0d82@hermes.local>
From:   Lars Ekman <uablrek@gmail.com>
In-Reply-To: <20230414082103.1b7c0d82@hermes.local>
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

Hi,

Thanks for the reply. You are right, it is jq that eats one ot the
double "dst" items.

vm-002 ~ # ip -j -p route show proto 5
[ {
        "dst": "192.168.11.0/24",
        "encap": "ip6",
        "id": 0,
        "src": "::",
        "dst": "fd00::c0a8:2dd",
        "hoplimit": 0,
        "tc": 0,
        "dev": "dummy0",
        "scope": "link",
        "flags": [ ]
    } ]
vm-002 ~ # ip -j -p route show proto 5 | jq
[
  {
    "dst": "fd00::c0a8:2dd",
    "encap": "ip6",
    "id": 0,
    "src": "::",
    "hoplimit": 0,
    "tc": 0,
    "dev": "dummy0",
    "scope": "link",
    "flags": []
  }
]

Sorry for the fuss.

Best Regards,

Lars Ekman


And btw I did upgrade *before* posting :-)

vm-002 ~ # ip -V
ip utility, iproute2-6.2.0, libbpf 1.1.0
vm-002 ~ # uname -r
6.2.7



On 2023-04-14 17:21, Stephen Hemminger wrote:
> On Fri, 14 Apr 2023 10:29:15 +0200
> Lars Ekman <uablrek@gmail.com> wrote:
>
>> The destination is lost in json printout and replaced by the encap 
>> destination. The destination can even be ipv6 for an ipv4 route.
>>
>> Example:
>>
>> vm-002 ~ # ip route add 10.0.0.0/24 proto 5 dev ip6tnl6 encap ip6 dst 
>> fd00::192.168.2.221
>> vm-002 ~ # ip route show proto 5
>> 10.0.0.0/24  encap ip6 id 0 src :: dst fd00::c0a8:2dd hoplimit 0 tc 0 
>> dev ip6tnl6 scope link
>> vm-002 ~ # ip -j route show proto 5 | jq
>> [
>>    {
>>      "dst": "fd00::c0a8:2dd",
>>      "encap": "ip6",
>>      "id": 0,
>>      "src": "::",
>>      "hoplimit": 0,
>>      "tc": 0,
>>      "dev": "ip6tnl6",
>>      "scope": "link",
>>      "flags": []
>>    }
>> ]
>>
> Both JSON and regular output show the same address which is coming from
> the kernel.  I.e not a JSON problem. Also, you don't need to use jq
> ip has -p flag to pretty print.
>
> I can not reproduce this with current kernel and iproute2.
> # ip route add 192.168.11.0/24 proto 5 dev dummy0 encap ip6 dst fd00::192.168.2.221
>
> # ip route show proto 5
> 192.168.11.0/24  encap ip6 id 0 src :: dst fd00::c0a8:2dd hoplimit 0 tc 0 dev dummy0 scope link 
>
> # ip -j -p route show proto 5
> [ {
>         "dst": "192.168.11.0/24",
>         "encap": "ip6",
>         "id": 0,
>         "src": "::",
>         "dst": "fd00::c0a8:2dd",
>         "hoplimit": 0,
>         "tc": 0,
>         "dev": "dummy0",
>         "scope": "link",
>         "flags": [ ]
>     } ]
>
>
> # ip -V
> ip utility, iproute2-6.1.0, libbpf 1.1.0
> # uname -r
> 6.1.0-7-amd64
>
>
