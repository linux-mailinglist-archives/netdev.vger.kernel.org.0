Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18FE5ECC65
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiI0St7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiI0Stu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:49:50 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61179752F;
        Tue, 27 Sep 2022 11:49:48 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id e18so7142174wmq.3;
        Tue, 27 Sep 2022 11:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Uy/Lr8Tfy+eWDjAiAzx45YwI3RpsjEElaf8OKPLhdUU=;
        b=CBghdfSs0ZPHWHMsOLsBnh5ZpxNT2s3g56DctsO8Mf9mTpDTB6p+jLVy8bOu2+/Gdf
         tHL+M2v6uQVCGGRhWriixY2hCCodfeT0NIK+rYSYcft3K607LdN7ljgevSDIHv+kB3Gr
         HMsq/7WpVUVStI31bLmpFEsfqmJoSciNbeX25w53xC6CZIpTPnuQqWDor1eo5aXCW7wo
         SZpbfEGfJ6MzmHDdU111Gj1BibSRBV7O+ut5u/8Y9GWObPkyxRBc09l85ScndiwvQ9n8
         YzhcWh35A87K/iIPqzydlaTmJwgvg0mI8E1jMY79EiCdwUXdWqrJ8HQb6RvUBox+QqTC
         T43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Uy/Lr8Tfy+eWDjAiAzx45YwI3RpsjEElaf8OKPLhdUU=;
        b=Zdm8lGfyPII/VkiEEvfqGQcLSFc/X3t60bCTOgVMlNE6rYukuJla1qinFeDPbvRGAe
         NsngmELu8SNoUOeag8AO7JqIdI3fz/8plDe7OE+qRydbL4hpU8C55Mg0Pd+xWD0K6+gw
         8RYTnbUQOcEzgijBMrpRIH33pGP5znbJp5zWo22WHE5A5vXWwph/da/tlkidG7+p342g
         lGQlQoLvP8iGmze4LX3Bf9+NoQIA4TzfRV99fMkq65V8zJsoeUugPLeAZSG8MqQZgihP
         /3fINtfHJX1/vqGaX+ZHP6+o8hXmpTtQfny+X+hVdSC5QuzuBWdpNaO+z05yoaL5LHhQ
         +i8A==
X-Gm-Message-State: ACrzQf1QAKQT/C0i7cyHupTb0igUBQPz5kDuVGKkC+wShHe/7Ib2Gt5h
        YhdbRc7iqoDG+lBq/Svyh6k=
X-Google-Smtp-Source: AMsMyM5I8+ROinB1laAu4ZG/L6R5Rm2MX5ZivMTsJ4uvWRtjro0IKjNXqFxx0x9bEj5jkdygW04R1g==
X-Received: by 2002:a05:600c:3cd:b0:3b4:8372:294c with SMTP id z13-20020a05600c03cd00b003b48372294cmr3852346wmd.191.1664304587170;
        Tue, 27 Sep 2022 11:49:47 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id f10-20020adff58a000000b002285f73f11dsm2848176wro.81.2022.09.27.11.49.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 11:49:46 -0700 (PDT)
Message-ID: <c06897d4-4883-2756-87f9-9b10ab495c43@gmail.com>
Date:   Tue, 27 Sep 2022 19:48:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 0/4] shrink struct ubuf_info
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <cover.1663892211.git.asml.silence@gmail.com>
 <7fef56880d40b9d83cc99317df9060c4e7cdf919.camel@redhat.com>
 <021d8ea4-891c-237d-686e-64cecc2cc842@gmail.com>
 <bbb212f6-0165-0747-d99d-b49acbb02a80@gmail.com>
 <85cccb780608e830024fc82a8e4f703031646f4e.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <85cccb780608e830024fc82a8e4f703031646f4e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/22 18:56, Paolo Abeni wrote:
> On Tue, 2022-09-27 at 18:16 +0100, Pavel Begunkov wrote:
>> On 9/27/22 15:28, Pavel Begunkov wrote:
>>> Hello Paolo,
>>>
>>> On 9/27/22 14:49, Paolo Abeni wrote:
>>>> Hello,
>>>>
>>>> On Fri, 2022-09-23 at 17:39 +0100, Pavel Begunkov wrote:
>>>>> struct ubuf_info is large but not all fields are needed for all
>>>>> cases. We have limited space in io_uring for it and large ubuf_info
>>>>> prevents some struct embedding, even though we use only a subset
>>>>> of the fields. It's also not very clean trying to use this typeless
>>>>> extra space.
>>>>>
>>>>> Shrink struct ubuf_info to only necessary fields used in generic paths,
>>>>> namely ->callback, ->refcnt and ->flags, which take only 16 bytes. And
>>>>> make MSG_ZEROCOPY and some other users to embed it into a larger struct
>>>>> ubuf_info_msgzc mimicking the former ubuf_info.
>>>>>
>>>>> Note, xen/vhost may also have some cleaning on top by creating
>>>>> new structs containing ubuf_info but with proper types.
>>>>
>>>> That sounds a bit scaring to me. If I read correctly, every uarg user
>>>> should check 'uarg->callback == msg_zerocopy_callback' before accessing
>>>> any 'extend' fields.
>>>
>>> Providers of ubuf_info access those fields via callbacks and so already
>>> know the actual structure used. The net core, on the opposite, should
>>> keep it encapsulated and not touch them at all.
>>>
>>> The series lists all places where we use extended fields just on the
>>> merit of stripping the structure of those fields and successfully
>>> building it. The only user in net/ipv{4,6}/* is MSG_ZEROCOPY, which
>>> again uses callbacks.
>>>
>>> Sounds like the right direction for me. There is a couple of
>>> places where it might get type safer, i.e. adding types instead
>>> of void* in for struct tun_msg_ctl and getting rid of one macro
>>> hiding types in xen. But seems more like TODO for later.
>>>
>>>> AFAICS the current code sometimes don't do the
>>>> explicit test because the condition is somewhat implied, which in turn
>>>> is quite hard to track.
>>>>
>>>> clearing uarg->zerocopy for the 'wrong' uarg was armless and undetected
>>>> before this series, and after will trigger an oops..
>>>
>>> And now we don't have this field at all to access, considering that
>>> nobody blindly casts it.
>>>
>>>> There is some noise due to uarg -> uarg_zc renaming which make the
>>>> series harder to review. Have you considered instead keeping the old
>>>> name and introducing a smaller 'struct ubuf_info_common'? the overall
>>>> code should be mostly the same, but it will avoid the above mentioned
>>>> noise.
>>>
>>> I don't think there will be less noise this way, but let me try
>>> and see if I can get rid of some churn.
>>
>> It doesn't look any better for me
>>
>> TL;DR; This series converts only 3 users: tap, xen and MSG_ZEROCOPY
>> and doesn't touch core code. If we do ubuf_info_common though I'd need
>> to convert lots of places in skbuff.c and multiple places across
>> tcp/udp, which is much worse.
> 
> Uhmm... I underlook the fact we must preserve the current accessors for
> the common fields.
> 
> I guess something like the following could do (completely untested,
> hopefully should illustrate the idea):
> 
> struct ubuf_info {
> 	struct_group_tagged(ubuf_info_common, common,
> 		void (*callback)(struct sk_buff *, struct ubuf_info *,
>                           bool zerocopy_success);
> 		refcount_t refcnt;
> 	        u8 flags;
> 	);
> 
> 	union {
>                  struct {
>                          unsigned long desc;
>                          void *ctx;
>                  };
>                  struct {
>                          u32 id;
>                          u16 len;
>                          u16 zerocopy:1;
>                          u32 bytelen;
>                  };
>          };
> 
>          struct mmpin {
>                  struct user_struct *user;
>                  unsigned int num_pg;
>          } mmp;
> };
> 
> Then you should be able to:
> - access ubuf_info->callback,
> - access the same field via ubuf_info->common.callback
> - declare variables as 'struct ubuf_info_commom' with appropriate
> contents.
> 
> WDYT?

Interesting, I didn't think about struct_group, this would
let to split patches better and would limit non-core changes.
But if the plan is to convert the core helpers to
ubuf_info_common, than I think it's still messier than changing
ubuf providers only.

I can do the exercise, but I don't really see what is the goal.
Let me ask this, if we forget for a second how diffs look,
do you care about which pair is going to be in the end?
ubuf_info_common/ubuf_info vs ubuf_info/ubuf_info_msgzc?
Are there you concerned about naming or is there more to it?

-- 
Pavel Begunkov
