Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE605A37A6
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 14:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiH0MhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 08:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiH0MhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 08:37:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AA71C104
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 05:37:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id cu2so7632484ejb.0
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 05:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=60sQ4obtzLi3SZDfR4Ml7RLmd2im4duwgOowcHUJA0E=;
        b=RUrSJPRFEUOf/0y7rG54jPIE7fBG/y8I3porJWpzmqBIrB5cwYbkXSp52fCpri5/U9
         5AslzChrc10s49NaYNr7Bb0F1eB0SXFa1hhWRlh53vOqFCe7BSYHxnEZ6FImN/dZC8x6
         EIbW0WdC4OlhX5IMi18aVsxPp8sMYN+4jNj8xBSwZNeKN6mSC2G0U2h7Fkc+DYtxTdbm
         U+REYLXIqJeClR6sWD1QebLElk0HQMatsKfG7zPYIEEoSXA63Duz+Ub4mUsTY6VfHdfP
         r6Gdtul4IH7duvg5cctwxc5WuQIznLJzkDUx/TdrV6C6DQDIu8n4LIyoELm28NJ3czUB
         40qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=60sQ4obtzLi3SZDfR4Ml7RLmd2im4duwgOowcHUJA0E=;
        b=dWT4W7FV1Bhwf8a9A9GkFSbzIuxUkawHQ0ZKVCsWrd0NZ7aar2Hx/H4pLX+1EddZny
         0nzbq3cQE/l1OPGrr2AQkLH7XbQxqc0KlDvSMlcPI8YrH0JP36RHAdwAG4DlOPDX5+/r
         20H3KBYoLdLCIXFaamM1OUj426a0iMa9URn6+1FgRAVFxGWVy/iAOhv/OQibhElKFY3Z
         5WBxgrm+tc/38Ql217WFEyZoP7zZNsunwAmPGNZpM7nDNFx5d5x1NZPgLriJ11f2ZRkA
         HqxnNkgice+59lrZvNNslBR885/3nykwyiSv3mmfLP6xq8ptlGXtVCNseXAvoxQexot6
         gIPw==
X-Gm-Message-State: ACgBeo1FUzvo3Qae42fJnAqkd8X1XvBcoim8S6UBSPLa6XIsXiXMkjcW
        BAO4ztEUE+QJUMt7aMBTdy1e3w==
X-Google-Smtp-Source: AA6agR5sYNQ0nCTil9GCFq4HVWtMmefpcbuFJwfLmDuGi3j2vuCCG1uIUd8KLInUazhANSAFtalMhQ==
X-Received: by 2002:a17:907:7394:b0:73a:d077:9ba1 with SMTP id er20-20020a170907739400b0073ad0779ba1mr7667936ejc.697.1661603820490;
        Sat, 27 Aug 2022 05:37:00 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id t1-20020a17090616c100b0073100dfa7b5sm2066071ejd.33.2022.08.27.05.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Aug 2022 05:37:00 -0700 (PDT)
Message-ID: <3a2c5c4c-a42c-eaae-be0a-b81a63543c0e@blackwall.org>
Date:   Sat, 27 Aug 2022 15:36:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH ipsec-next,v2 2/3] xfrm: interface: support collect
 metadata mode
Content-Language: en-US
To:     nicolas.dichtel@6wind.com, Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "daniel@iogearbox.net" <daniel@iogearbox.net>
References: <20220825134636.2101222-1-eyal.birger@gmail.com>
 <20220825134636.2101222-3-eyal.birger@gmail.com>
 <a825aa13-6f82-e6c1-3c5c-7974b14f881e@blackwall.org>
 <CAHsH6Gv8Zv722pjtKrWDiSHYKvV0FUxUSnHf_8B+gJnAVYiziQ@mail.gmail.com>
 <e80f14c5-4ca4-55b0-57e0-108fb73fb828@6wind.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <e80f14c5-4ca4-55b0-57e0-108fb73fb828@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/08/2022 10:53, Nicolas Dichtel wrote:
> 
> Le 25/08/2022 à 17:14, Eyal Birger a écrit :
>> On Thu, Aug 25, 2022 at 5:24 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>>
>>> On 25/08/2022 16:46, Eyal Birger wrote:
>>>> This commit adds support for 'collect_md' mode on xfrm interfaces.
>>>>
>>>> Each net can have one collect_md device, created by providing the
>>>> IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
>>>> altered and has no if_id or link device attributes.
>>>>
>>>> On transmit to this device, the if_id is fetched from the attached dst
>>>> metadata on the skb. If exists, the link property is also fetched from
>>>> the metadata. The dst metadata type used is METADATA_XFRM which holds
>>>> these properties.
>>>>
>>>> On the receive side, xfrmi_rcv_cb() populates a dst metadata for each
>>>> packet received and attaches it to the skb. The if_id used in this case is
>>>> fetched from the xfrm state, and the link is fetched from the incoming
>>>> device. This information can later be used by upper layers such as tc,
>>>> ebpf, and ip rules.
>>>>
>>>> Because the skb is scrubed in xfrmi_rcv_cb(), the attachment of the dst
>>>> metadata is postponed until after scrubing. Similarly, xfrm_input() is
>>>> adapted to avoid dropping metadata dsts by only dropping 'valid'
>>>> (skb_valid_dst(skb) == true) dsts.
>>>>
>>>> Policy matching on packets arriving from collect_md xfrmi devices is
>>>> done by using the xfrm state existing in the skb's sec_path.
>>>> The xfrm_if_cb.decode_cb() interface implemented by xfrmi_decode_session()
>>>> is changed to keep the details of the if_id extraction tucked away
>>>> in xfrm_interface.c.
>>>>
>>>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>>>>
>>>> ----
>>>>
>>>> v2:
>>>>   - add "link" property as suggested by Nicolas Dichtel
>>>>   - rename xfrm_if_decode_session_params to xfrm_if_decode_session_result
>>>> ---
>>>
>>> (+CC Daniel)
>>>
>>> Hi,
>>> Generally I really like the idea, but I missed to comment the first round. :)
>>> A few comments below..
>>>
>>
>> Thanks for the review!
>>
>>>>  include/net/xfrm.h           |  11 +++-
>> <...snip...>
>>>>
>>>>  static const struct nla_policy xfrmi_policy[IFLA_XFRM_MAX + 1] = {
>>>> -     [IFLA_XFRM_LINK]        = { .type = NLA_U32 },
>>>> -     [IFLA_XFRM_IF_ID]       = { .type = NLA_U32 },
>>>> +     [IFLA_XFRM_UNSPEC]              = { .strict_start_type = IFLA_XFRM_COLLECT_METADATA },
>>>> +     [IFLA_XFRM_LINK]                = { .type = NLA_U32 },
>>>
>>> link is signed, so s32
>>
>> Ack on all comments except this one - I'm a little hesitant to change
>> this one as the change would be unrelated to this series.
> I agree, it's unrelated to this series.

Ohh right, my bad. I somehow confused this for new code. :)

Cheers,
 Nik

