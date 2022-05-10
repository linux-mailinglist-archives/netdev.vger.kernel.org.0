Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2F4521A2F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243266AbiEJNyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244863AbiEJNv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:51:28 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A252992E0;
        Tue, 10 May 2022 06:38:01 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id v139so16951915vsv.0;
        Tue, 10 May 2022 06:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uXD5HXNUod0mBIkBRdBmA7bHDMqJzOA6s/MfATu+hnk=;
        b=SegKPMXGJsu35m9U4yUiHeOUzS/sH+WXB5E3PD2KQPE6yv+v+qCv0hn/B3e4tuFp2M
         6gztQp5dxYOoRDOPq2sXW5z1Om/Qz+DtDuIVkDvhVrRW86o0AkpQ0zM8xBjEYPac7cXM
         hi5ZWnqzQSmxTaGozGG89GTsh8waZ0YNVWrIzmpBl4NR9NrgD3AKNI8+uG/IndON5whk
         2QwOiPtHY1j//ChNul9Lr2Wv0dq+8kqLKHs3WcLv5rSA3Cmeio+KSNlRKNTATgakEnu3
         mpYk1PQ2ZVZGkiI8fhmQAzIli7pEneF4xd9o2W3mSNsWzm7kHfY81sVVieMGr2VPgRSB
         Yb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uXD5HXNUod0mBIkBRdBmA7bHDMqJzOA6s/MfATu+hnk=;
        b=ZtJaGIx2G8jxhQx4gPXNkaxa6ICK3RiNvvChoXptyW4SIJjmt/sglv6lr8tO1Yo1O5
         6iipnjDp2r8xK6kYI00kfe6p9Cn4udzhowAwD7LgFE9JmjyipSocszQnlbyH4lqdZq9Z
         n2piU5Yu3dqN97L9Cf5dR2LooQSUQSeWPE7aGAiUHbvC0UlzbXQEQra9bCgPzgcLzY0D
         RwDoAJT4gIRiLToZYDEJjcuD257ohmIo2l3sQIQ7k/bzYPaLMslvtNnKv6VJxNOuXDG/
         NKEYOP0BiIT7gqTspTzgHBQhNrWX5SuFK5OQuQn8ERJ/hn7U/fmltjxXfvxnLC8afc1K
         VUYQ==
X-Gm-Message-State: AOAM533NUdpLs68e+m6wtgjptHYLmVS24b+H5dlSN47XM3yGzgSM4QxJ
        ZklPxddffJcgjV95T5B1qecJJRbYDjxXL8meEkY=
X-Google-Smtp-Source: ABdhPJzImfnbfbDCyKpsDDf5PL4yQju5oSXHEfqRQTuvKZDFsi5awPkXufsKwtoEhUIRupDUz245EuxDx1bNiV+t4yg=
X-Received: by 2002:a05:6102:358f:b0:32d:3e44:f070 with SMTP id
 h15-20020a056102358f00b0032d3e44f070mr11081918vsu.39.1652189848983; Tue, 10
 May 2022 06:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
 <20220506181310.2183829-3-ricardo.martinez@linux.intel.com>
 <20220509094930.6d5db0f8@kernel.org> <CAHNKnsSZ-Sf=5f3puLUiRRysz80b2CS3tVMXds_Ugur-Dga2aQ@mail.gmail.com>
 <20220509125008.6d1c3b9b@kernel.org>
In-Reply-To: <20220509125008.6d1c3b9b@kernel.org>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 10 May 2022 16:37:27 +0300
Message-ID: <CAHNKnsTmH-rGgWi3jtyC=ktM1DW2W1VJkYoTMJV2Z_Bt498bsg@mail.gmail.com>
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
        =?UTF-8?B?SGFpanVuIExpdSAoIOWImOa1t+WGmyk=?= 
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

On Mon, May 9, 2022 at 10:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 9 May 2022 21:34:58 +0300 Sergey Ryazanov wrote:
>>>> +static inline unsigned int skb_data_area_size(struct sk_buff *skb)
>>>> +{
>>>> +     return skb_end_pointer(skb) - skb->data;
>>>> +}
>>>
>>> Not a great name, skb->data_len is the length of paged data.
>>> There is no such thing as "data area", data is just a pointer
>>> somewhere into skb->head.
>>
> > What name would you recommend for this helper?
>
> We are assuming that skb->data is where we want to start to write
> to so we own the skb. If it's a fresh skb skb->data == skb->tail.
> If it's not fresh but recycled - skb->data is presumably reset
> correctly, and then skb_reset_tail_pointer() has to be called. Either
> way we give HW empty skbs, tailroom is an existing concept we can use.
>
>>> Why do you need this? Why can't you use the size you passed
>>> to the dev_alloc_skb() like everyone else?
>>
>> It was I who suggested to Ricardo to make this helper a common
>> function [1]. So let me begin the discussion, perhaps Ricardo will add
>> to my thoughts as the driver author.
>>
>> There are many other places where authors do the same but without a
>> helper function:
>>
>> [...]
>>
>> There are at least two reasons to evaluate the linear data size from skb:
>> 1) it is difficult to access the same variable that contains a size
>> during skb allocation (consider skb in a queue);
>
> Usually all the Rx skbs on the queue are equally sized so no need to
> save the length per buffer, but perhaps that's not universally true.
>
>> 2) you may not have access to an allocation size because a driver does
>> not allocate that skb (consider a xmit path).
>
> On Tx you should only map the data that's actually populated, for that
> we have skb_headlen().
>
>> Eventually you found themself in a position where you need to carry
>> additional info along with skb. But, on the other hand, you can simply
>> calculate this value from the skb pointers themselves.
>>
>> 1. https://lore.kernel.org/netdev/CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com/
>
> Fair enough, I didn't know more drivers are doing this.
>
> We have two cases:
>  - for Tx - drivers should use skb_headlen();
>  - for Rx - I presume we are either dealing with fresh or correctly
>    reset skbs, so we can use skb_tailroom().

Make sense! Especially your remark that on Tx we should only map
populated data. This short API usage guide even answers my wonder why
the kernel still does not have something like skb_data_area_size().
Thank you for this short and clear clarification.

-- 
Sergey
