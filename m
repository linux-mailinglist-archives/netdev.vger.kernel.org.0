Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E355F4540
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiJDOQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 10:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiJDOQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 10:16:52 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DCE40E15
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 07:16:52 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id q83so10592959iod.7
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 07:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hCP6GDD6KpgEws/PFmYypSzjAagdt2JL+JUukXWDlc0=;
        b=mDqUVM1tdlC2lG5zsvbgPC1FbQ0+J/VlSX1rjJaoc6EjaDfoGLlM7NkRva9R/TAsYC
         dCdMtvdtkoAomGmtK4qCoRFr0lF6CWY/ddEIm5MGPC6AOciQme9vL2nnDa/ODoavWdC5
         dxs9qnxC+y4sA3f2odFCia3bjtQvN2We84Q2JUPKb9zfKzts+s/+IyBB/0LqnqtPkFB1
         hgdfo0y6JW1jyKSoZ6qc4Z0hJYw/HNgbpmqY0PanL0Jdw9sWIH3g8rJ4BWKz35MMQpnt
         ebzi1KM8AEzkHhfg7KN8A8BG2bk1WxmJMuzQZl+tUShCV0RRkzT5AZwFf/NOZhlFKu2x
         PbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hCP6GDD6KpgEws/PFmYypSzjAagdt2JL+JUukXWDlc0=;
        b=Vp3410UAFK1MVJoVpfNMKxCRdINrCJTcEWK4SKAydYPhfkQEccno/Uba+40SocN9vY
         mh4zMcTMOowReBGjxciirpL7aijaDVkqWhbBysqGUggdW2rXGgxKu/Oorfv+hvv8zEQC
         eZA3uWLSkcnfFgJwms0b2c84EOUaKhflR6fq+5Jt5HFmUIXfz3zLE3jscCzndp7xWEG6
         6hKaLD6lb+VFGWW9TvGGulbl7vQONWuDqTsMJT7YkJOfhUqgjD1R35M1DKsxxsqAb8lQ
         eCx71bYOvmodH6gZyXcJjWMaGaZOB3lL9N+37mWN2P4wEKC3mJaqy4Mqzf4QrMEMYMuc
         naAw==
X-Gm-Message-State: ACrzQf0G1pp/ELceKSQmmGrxX2xWjaUSzLd59yAAAmnD3n4rQsS5EWmp
        obSwrMMqFcuF5PEHHg9OIMaEQSYQm18=
X-Google-Smtp-Source: AMsMyM5reDynmHch5VUEOpV4MyiLPYJw21LX71GYm0ZuiChLQfOJvzcfc8dCpYc9ItwQO2oYZXVpXg==
X-Received: by 2002:a5d:9902:0:b0:6a2:f72d:4b21 with SMTP id x2-20020a5d9902000000b006a2f72d4b21mr11347837iol.113.1664893011463;
        Tue, 04 Oct 2022 07:16:51 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:38e6:13c8:49a3:2476? ([2601:282:800:dc80:38e6:13c8:49a3:2476])
        by smtp.googlemail.com with ESMTPSA id d68-20020a6bcd47000000b006a11760aebbsm5838433iog.36.2022.10.04.07.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 07:16:49 -0700 (PDT)
Message-ID: <582321ff-50dc-3dd1-7a16-60ba0d84da3a@gmail.com>
Date:   Tue, 4 Oct 2022 08:16:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2-next 3/3] f_flower: Introduce L2TPv3 support
Content-Language: en-US
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "gnault@redhat.com" <gnault@redhat.com>
References: <20220927082318.289252-1-wojciech.drewek@intel.com>
 <20220927082318.289252-4-wojciech.drewek@intel.com>
 <06112b64-39c5-0dee-b419-872e94263457@gmail.com>
 <MW4PR11MB57769E48533C7CC9BCD453B0FD5B9@MW4PR11MB5776.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <MW4PR11MB57769E48533C7CC9BCD453B0FD5B9@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/3/22 3:19 AM, Drewek, Wojciech wrote:
> 
> 
>> -----Original Message-----
>> From: David Ahern <dsahern@gmail.com>
>> Sent: poniedziałek, 3 października 2022 00:51
>> To: Drewek, Wojciech <wojciech.drewek@intel.com>; netdev@vger.kernel.org
>> Cc: stephen@networkplumber.org; gnault@redhat.com
>> Subject: Re: [PATCH iproute2-next 3/3] f_flower: Introduce L2TPv3 support
>>
>> On 9/27/22 1:23 AM, Wojciech Drewek wrote:
>>> Add support for matching on L2TPv3 session ID.
>>> Session ID can be specified only when ip proto was
>>> set to IPPROTO_L2TP.
>>>
>>> L2TPv3 might be transported over IP or over UDP,
>>> this implementation is only about L2TPv3 over IP.
>>> IPv6 is also supported, in this case next header
>>> is set to IPPROTO_L2TP.
>>>
>>> Example filter:
>>>   # tc filter add dev eth0 ingress prio 1 protocol ip \
>>>       flower \
>>>         ip_proto l2tp \
>>>         l2tpv3_sid 1234 \
>>>         skip_sw \
>>>       action drop
>>>
>>> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
>>> ---
>>>  man/man8/tc-flower.8 | 11 +++++++++--
>>>  tc/f_flower.c        | 45 +++++++++++++++++++++++++++++++++++++++++++-
>>>  2 files changed, 53 insertions(+), 3 deletions(-)
>>>
>>
>>
>> I updated kernel headers to latest net-next tree. (uapi headers are
>> synched via a script.) This patch on top of that does not compile, so
>> something is missing. Please take a look and re-send.
> 
> Ok, the issue is that IPPROTO_L2TP is undeclared and I'm not sure how to resolve this.
> I've moved IPPROTO_L2TP to in.h file but while building, system file is included
> (/usr/include/netinet/in.h) not the project one (iproute2-next/include/uapi/linux/in.h).

utils.h -> resolv.h -> netinet/in.h I believe is the problem.

> I guess the workaround would be to define it in f_flower.c like this:
> #ifndef IPPROTO_L2TP
> #define IPPROTO_L2TP 115
> #endif
> I saw similar solution in case of IPPROTO_MPTCP.
> 
> Let me know if it works for you.
> 

I don't want to propagate redefines like that, but I don't see a
feasible solution with the headers.
