Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27DA6D5643
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 03:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjDDBsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 21:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjDDBsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 21:48:46 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F0D1FE9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:48:21 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso369306pjc.1
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 18:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680572901;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1q2BofHrGCo+RPWMNzGCdFLZaQiXJqXIgKAKTLgK1M=;
        b=eX7Zw/4KQMIOU7qTsaR5KxYRBMUv78LFFicGZ+e5Qr4Re22xUxe2uqV2/vc7n6v42G
         PhB1KC+uvU8zmg4ZgmCqhjeXCwHOVVm5grK379/koAOuR7rA1fDMOgH13e/ZJ8KTO3Vq
         uo0D8KhYAPdzf3nXYmo4rs46Jn61YBUGXHLR03DWKF1SXHRaKxmqsfSta878J/hSyxqB
         jfst60O6I5OzhVSweEpFmw19k/A0tfRdn5XPez80mtJ9eJvECaEql9gaUVjNhn4bGWl2
         +XMXmk34nMkK4JxlUg35H5IA0iBHaqbTYFbCMTh1XAprgiRWDFJ/GVcMZdwqoQhA+Lul
         ZFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680572901;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y1q2BofHrGCo+RPWMNzGCdFLZaQiXJqXIgKAKTLgK1M=;
        b=8BaO4DXKDgixtVwopCsjN5TA0eB+ZLXlMT1i3JWBAfdJlJfpTKGMeGJefMnj8Scmm8
         bTyZqDf26233yQcN+IT61b8dF7r419440PdbQLRJ+2MgJLxHj5/MrB9fxaUr2S50XsJr
         bPyPEQfUImS+5q4E5Szs8nw05jQhjtY6CS3d81C8VyMpWahR2PDDCLBq45vlLMLvlbfw
         N/OgFBkgsHAAgdwz1ZLMbL1MvUmTAIwkBB3HTAGaTR5hssrWqzTxeyu6rSmYsWL+07Bp
         9qg7+mjntaM6TSMHolStui9FiU5Un+BFkbrDDUQOYZZaeuyqX+70lBYssKJWQBZzKNeM
         xFDg==
X-Gm-Message-State: AAQBX9cx81Hx/VW6QJtFrqRjEfXd8U0Pxcj1bLFxWSLl9MhaR3qqosfP
        TG7IgwQmVtQl+gIQfrE+gxcS6pcLjeF1skzBFmrz2w==
X-Google-Smtp-Source: AKy350bYq3OfEPlMyUgoPFuZ9DV3j/aZXtdLiolN6L6HCuU/DiQgBOSL/vmegA5sw9OTI82u5oQA7Q==
X-Received: by 2002:a05:6a20:7b2a:b0:db:1d43:18fe with SMTP id s42-20020a056a207b2a00b000db1d4318femr732782pzh.8.1680572900805;
        Mon, 03 Apr 2023 18:48:20 -0700 (PDT)
Received: from [10.93.232.230] ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id s2-20020aa78d42000000b006243e706195sm7499195pfe.196.2023.04.03.18.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 18:48:20 -0700 (PDT)
Message-ID: <25fe50f2-9f1d-ec48-52af-780eb9ba6e09@bytedance.com>
Date:   Tue, 4 Apr 2023 09:48:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [External] Re: [PATCH] udp:nat:vxlan tx after nat should recsum
 if vxlan tx offload on
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     dsahern@kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>, ecree@amd.com
References: <20230401023029.967357-1-chenwei.0515@bytedance.com>
 <CAF=yD-Lg_XSnE9frH9UFpJCZLx-gg2KHzVu7KmnigidujCvepQ@mail.gmail.com>
 <fae01ad9-4270-2153-9ba4-cf116c8ed975@gmail.com>
From:   Fei Cheng <chenwei.0515@bytedance.com>
In-Reply-To: <fae01ad9-4270-2153-9ba4-cf116c8ed975@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for remind plain text.
Use csum_start to seperate these two cases, maybe a good idea.
1.Disable tx csum
skb->ip_summed ==  CHECKSUM_PARTIAL && skb_transport_header == udp
2.Enable tx csum
skb->ip_summed ==  CHECKSUM_PARTIAL && skb_transport_header != udp

Correct?

在 2023/4/3 下午6:56, Edward Cree 写道:
> On 02/04/2023 19:18, Willem de Bruijn wrote:
>> On Fri, Mar 31, 2023 at 10:31 PM Fei Cheng <chenwei.0515@bytedance.com> wrote:
>>>
>>> From: "chenwei.0515" <chenwei.0515@bytedance.com>
>>>
>>>      If vxlan-dev enable tx csum offload, there are two case of CHECKSUM_PARTIAL,
>>>      but udp->check donot have the both meanings.
>>>
>>>      1. vxlan-dev disable tx csum offload, udp->check is just pseudo hdr.
>>>      2. vxlan-dev enable tx csum offload, udp->check is pseudo hdr and
>>>         csum from outter l4 to innner l4.
>>>
>>>      Unfortunately if there is a nat process after vxlan tx，udp_manip_pkt just use
>>>      CSUM_PARTIAL to re csum PKT, which is just right on vxlan tx csum disable offload.
> 
> In case 1 csum_start should point to the (outer) UDP header, whereas in
>   case 2 csum_start should point to the inner L4 header (because in the
>   normal TX path w/o NAT, nothing else will ever need to touch the outer
>   csum after this point).
> 
>> The issue is that for encapsulated traffic with local checksum offload,
>> netfilter incorrectly recomputes the outer UDP checksum as if it is an
>> unencapsulated CHECKSUM_PARTIAL packet, correct?
> 
> So if netfilter sees a packet with CHECKSUM_PARTIAL whose csum_start
>   doesn't point to the header nf NAT is editing, that's exactly the case
>   where it needs to use lco_csum to calculate the new outer sum.  No?
> 
> -ed
> 
> PS. Fei, your emails aren't reaching the netdev mailing list, probably
>   because you're sending as HTML.  Please switch to plain text.
