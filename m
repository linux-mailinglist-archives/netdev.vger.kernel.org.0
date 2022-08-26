Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC27B5A2258
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245706AbiHZHxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245725AbiHZHxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:53:39 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8208BD3EF1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:53:34 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k9so866026wri.0
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc;
        bh=pLGkByOQtUyNIrq+AB6ywJQFRaPW2OijF5FLi8vGm90=;
        b=fA5Rd+taknD3yl0VFm1rZMyGtDdJHsb+Dih5HDSv4K+CHzlYGoieAFfETL/e0tDgbd
         S7RLIRP+3jHFbd8m+0S1F/2fDL8OdOBU5aelAqwZkMqy1gfvHeRYL/4EDMjUpUFPymM6
         +mPYFNG6jkDprQeTnsXZPuNseE/1CJbL6wKRvEMtjp2wQ54muJIe8vf2WrZJhzFqhd8q
         MMCWjg2WTnhQ/Z6I37gPsG699y59sTUCh1tkK+i/R6DooX3PMfsEVFZ7VIUquzaw5s7S
         2guWt/jLzJ7iPCCYBTtS5qJrK5zF3T/I/9z7jKRhF7B23vv3/5B7rQfWc6BUfSz7lKA7
         nWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc;
        bh=pLGkByOQtUyNIrq+AB6ywJQFRaPW2OijF5FLi8vGm90=;
        b=YnFV0JyOKM7JA8bjj3y/yWPFlPAQRV2xcS2OUOdKPE6IaVukkK1jgXfnATM6YGaVZh
         IK1DmFRP5aqwDvn2X91p9boDICPatElTPO8F6QNMSY0ny63awyMHgVRp5Er1fZDl1yQe
         NJ7/UrEud77YtQ5LE6TuVnu9i2zbBwFPvy8njnAmWUXIvuIJjlm/HevsnEqT+5gAs1ZV
         gYncUykZZrZ/PQQLT2nc8Nyo2Ska3+0X0jCa4do6Dm7Wx2YP1xYaeJ4m+lauPe+ZF5ic
         zJXHHSorIytSXmtlUU2UJ3Cyj6ugXYwU0/eA3QbBNVwZMXQMRKQcdFxbtNAeAiW3y+PD
         0YSw==
X-Gm-Message-State: ACgBeo2egENTFkOeHpBkJT3qcdDkXCd2L/IMHt0ejXsuSoOqs7lNxK35
        OBYEqjp/L+70BhrfqfCmOcsYzA==
X-Google-Smtp-Source: AA6agR6dcDBRP9cKMK4QGQBlOFV2gZL3V/tX7XVXExYygh0kQ336/ycDAMuG/yv0YGb1axMp6BDemQ==
X-Received: by 2002:a5d:64c6:0:b0:225:4073:8fef with SMTP id f6-20020a5d64c6000000b0022540738fefmr4217818wri.253.1661500412689;
        Fri, 26 Aug 2022 00:53:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5d94:b816:24d3:cd91? ([2a01:e0a:b41:c160:5d94:b816:24d3:cd91])
        by smtp.gmail.com with ESMTPSA id r184-20020a1c2bc1000000b003a6125562e1sm1525075wmr.46.2022.08.26.00.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 00:53:31 -0700 (PDT)
Message-ID: <e80f14c5-4ca4-55b0-57e0-108fb73fb828@6wind.com>
Date:   Fri, 26 Aug 2022 09:53:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec-next,v2 2/3] xfrm: interface: support collect
 metadata mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "daniel@iogearbox.net" <daniel@iogearbox.net>
References: <20220825134636.2101222-1-eyal.birger@gmail.com>
 <20220825134636.2101222-3-eyal.birger@gmail.com>
 <a825aa13-6f82-e6c1-3c5c-7974b14f881e@blackwall.org>
 <CAHsH6Gv8Zv722pjtKrWDiSHYKvV0FUxUSnHf_8B+gJnAVYiziQ@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <CAHsH6Gv8Zv722pjtKrWDiSHYKvV0FUxUSnHf_8B+gJnAVYiziQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 25/08/2022 à 17:14, Eyal Birger a écrit :
> On Thu, Aug 25, 2022 at 5:24 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>
>> On 25/08/2022 16:46, Eyal Birger wrote:
>>> This commit adds support for 'collect_md' mode on xfrm interfaces.
>>>
>>> Each net can have one collect_md device, created by providing the
>>> IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
>>> altered and has no if_id or link device attributes.
>>>
>>> On transmit to this device, the if_id is fetched from the attached dst
>>> metadata on the skb. If exists, the link property is also fetched from
>>> the metadata. The dst metadata type used is METADATA_XFRM which holds
>>> these properties.
>>>
>>> On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
>>> packet received and attaches it to the skb. The if_id used in this case is
>>> fetched from the xfrm state, and the link is fetched from the incoming
>>> device. This information can later be used by upper layers such as tc,
>>> ebpf, and ip rules.
>>>
>>> Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
>>> metadata is postponed until after scrubing. Similarly, xfrm_input() is
>>> adapted to avoid dropping metadata dsts by only dropping 'valid'
>>> (skb_valid_dst(skb) == true) dsts.
>>>
>>> Policy matching on packets arriving from collect_md xfrmi devices is
>>> done by using the xfrm state existing in the skb's sec_path.
>>> The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
>>> is changed to keep the details of the if_id extraction tucked away
>>> in xfrm_interface.c.
>>>
>>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>>>
>>> ----
>>>
>>> v2:
>>>   - add "link" property as suggested by Nicolas Dichtel
>>>   - rename xfrm_if_decode_session_params to xfrm_if_decode_session_result
>>> ---
>>
>> (+CC Daniel)
>>
>> Hi,
>> Generally I really like the idea, but I missed to comment the first round. :)
>> A few comments below..
>>
> 
> Thanks for the review!
> 
>>>  include/net/xfrm.h           |  11 +++-
> <...snip...>
>>>
>>>  static const struct nla_policy xfrmi_policy[IFLA_XFRM_MAX + 1] = {
>>> -     [IFLA_XFRM_LINK]        = { .type = NLA_U32 },
>>> -     [IFLA_XFRM_IF_ID]       = { .type = NLA_U32 },
>>> +     [IFLA_XFRM_UNSPEC]              = { .strict_start_type = IFLA_XFRM_COLLECT_METADATA },
>>> +     [IFLA_XFRM_LINK]                = { .type = NLA_U32 },
>>
>> link is signed, so s32
> 
> Ack on all comments except this one - I'm a little hesitant to change
> this one as the change would be unrelated to this series.
I agree, it's unrelated to this series.
