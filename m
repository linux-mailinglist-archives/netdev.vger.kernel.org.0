Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CE5520494
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240251AbiEISjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240252AbiEISi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:38:56 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FAE13C4DD;
        Mon,  9 May 2022 11:35:00 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id i186so14769194vsc.9;
        Mon, 09 May 2022 11:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0CWbkHhjAUzJhrJblAdla1MYt72/7V+6Sko9hLuAy1k=;
        b=DMswHnP3kLyGvC6D88Bj01PPKKoTgCjU4ZIDnpzvEn681tXfOcRDjVFepBf0pYM0Rw
         AVejU1r24A+sf+Rzpa4PUNZNxvH207KpAmTSJ/qMOHnRjLgkcOWhmsxGsizswSNyIY2R
         B0QVxZN2CL0mc5vqGKdu+7oEBLj+8NarWHG3LKdMvepLtpRs5qnBD6a1SDhbpxxp0pXP
         iusHWlgfP3332hTZL1uHZaKBQDrMgMYw1ObVeQIfY7LGOaqQSmddRFpaDLMFsoFkgMnK
         cE+VeiOUqdmenRzDggfCoqPVvtvSIF0LOWC63urUxxPc56Ho2bDc6naShAsgnQJBd4Yx
         8xIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0CWbkHhjAUzJhrJblAdla1MYt72/7V+6Sko9hLuAy1k=;
        b=mghz7+nfjqxRbk4grBnqSN6MsBIJd0Mx3I3Lmjf8BSIXYHiMawwG+lOYBeZxsu2L11
         oUOcQMZQqZ4T4laE3jthjWg7j7Wa/IyZ8aXEgAQbYDtoUM2RLmso/1EC4ZupD4W/qbTd
         LAQYQ8S9VL010e6RGMjuLY4Tsk6nIUSnhOiZitcf82kAYYcKnYiGzKyPr1suklceXGnN
         /v/Wiu6VQujMefBdAOfIdTWJA8GMf3r9+FJS44mcqnwi6fIeoChgvODLgFlKofNvOMJp
         5SED809YU4seVSFCaJznn2kqmMWB0H0YVgq8euoec/Ay4F+UfmtgzgOhVjABgqQMqnbg
         n1ig==
X-Gm-Message-State: AOAM531WrljESQvCwFwB9SgVQJmgVu0D2k/UTLFboDiE1YhjMrnnzzxY
        75LbNcCBLQQaVlxKyic7bYs6f5OuNck8JnEvNYGwPRV4ZITTLA==
X-Google-Smtp-Source: ABdhPJy7ifv1dcjnolb3rFo93bLkJkid/C43o1Hpy+cBDhbcUx8piu7bUaWybVdZekX/E5knRF0J9RI9A/g6clDUSk4=
X-Received: by 2002:a67:b605:0:b0:32d:34a:15bb with SMTP id
 d5-20020a67b605000000b0032d034a15bbmr9135764vsm.69.1652121299787; Mon, 09 May
 2022 11:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
 <20220506181310.2183829-3-ricardo.martinez@linux.intel.com> <20220509094930.6d5db0f8@kernel.org>
In-Reply-To: <20220509094930.6d5db0f8@kernel.org>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 9 May 2022 21:34:58 +0300
Message-ID: <CAHNKnsSZ-Sf=5f3puLUiRRysz80b2CS3tVMXds_Ugur-Dga2aQ@mail.gmail.com>
Subject: Re: [PATCH net-next v8 02/14] net: skb: introduce skb_data_area_size()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On Mon, May 9, 2022 at 7:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri,  6 May 2022 11:12:58 -0700 Ricardo Martinez wrote:
>> Helper to calculate the linear data space in the skb.
>>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>> ---
>>  include/linux/skbuff.h | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index 5c2599e3fe7d..d58669d6cb91 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -1665,6 +1665,11 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
>>  }
>>  #endif
>>
>> +static inline unsigned int skb_data_area_size(struct sk_buff *skb)
>> +{
>> +     return skb_end_pointer(skb) - skb->data;
>> +}
>
> Not a great name, skb->data_len is the length of paged data.
> There is no such thing as "data area", data is just a pointer
> somewhere into skb->head.

What name would you recommend for this helper?

> Why do you need this? Why can't you use the size you passed
> to the dev_alloc_skb() like everyone else?

It was I who suggested to Ricardo to make this helper a common
function [1]. So let me begin the discussion, perhaps Ricardo will add
to my thoughts as the driver author.

There are many other places where authors do the same but without a
helper function:

$ grep -rn 'skb_end_pointer(.*) [-]' drivers/net/ | sort
drivers/net/ethernet/marvell/mv643xx_eth.c:628: size =
skb_end_pointer(skb) - skb->data;
drivers/net/ethernet/marvell/pxa168_eth.c:322: size =
skb_end_pointer(skb) - skb->data;
drivers/net/ethernet/micrel/ksz884x.c:4764: if (skb_end_pointer(skb) -
skb->data >= 50) {
drivers/net/ethernet/netronome/nfp/ccm_mbox.c:492: undersize =
max_reply_size - (skb_end_pointer(skb) - skb->data);
drivers/net/ethernet/nvidia/forcedeth.c:2073:
(skb_end_pointer(np->rx_skb[i].skb) -
drivers/net/ethernet/nvidia/forcedeth.c:5244: (skb_end_pointer(tx_skb)
- tx_skb->data),
drivers/net/veth.c:775: frame_sz = skb_end_pointer(skb) - skb->head;

There are at least two reasons to evaluate the linear data size from skb:
1) it is difficult to access the same variable that contains a size
during skb allocation (consider skb in a queue);
2) you may not have access to an allocation size because a driver does
not allocate that skb (consider a xmit path).

Eventually you found themself in a position where you need to carry
additional info along with skb. But, on the other hand, you can simply
calculate this value from the skb pointers themselves.

1. https://lore.kernel.org/netdev/CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com/

--
Sergey
