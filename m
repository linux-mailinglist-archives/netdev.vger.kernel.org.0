Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF3766299
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 01:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfGKXz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 19:55:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44590 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfGKXz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 19:55:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so3661982pgl.11
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 16:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dk3i8CKzR2dm/DpQG7orIk03+IAyFFKutJZInlZ+vKY=;
        b=gHw8Lc5C0ZigpDMr5eKswMfxT3IoHc3rK8qXJrlBKKz3k2DmZpX9LgQXgNSISc15Ad
         NzedRVQM8YStJP3RxM5gBLPmJM+TQbnB2i5ugIHr9YB8fBve7odVUswAxXoXpDjfcDMA
         nZr55gEva1nfVjOG7nMelvQFhtl36KsSyNU/JpKmmTQcj1WJaCv9AkMnJZ5iHiXD+k2I
         jWz1QhYNV/SoEQkJYqFM4To79T/91K23HtqoElJYlv6/FrivimU4KDXhyftn4x280Vxk
         skiCdeElOQQSkMPsiIhijtc3EeZ0H4moQweUo566I/dhVHyObE3xHd2P0D8AnJJPp1vO
         OLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dk3i8CKzR2dm/DpQG7orIk03+IAyFFKutJZInlZ+vKY=;
        b=YLt98tIZqhFzb6jOjSJSoenX+gYwf7kJ2CwGBnMoS7iIdYxN5bSTXcTZG5aXLN7olA
         ixqUeH9+We2W7nBqTXgNBO66Q2b2ABX1ruVYjO0Amy3MXUSP9PxUt8bWJIWZCYYLxOtK
         867yI+tXA2RUGQ+fw2S8cEnEJh2n/2Vu6Dzmb5HiI2JbIGOxwIBqtd5TURJzXYwqWrm7
         lwOtYSj01CcmAfm1ztw7kOZrDDzF2KkmECen9YafW8x0a200FeuaJxkyfkBY4ZRTuBOr
         0He+p3d25sSdq9cVxie9eWtD1ywZtmQwxoKvzYwLVUlNl3z86kYko9e4iq3KSjMFjJNz
         OhOQ==
X-Gm-Message-State: APjAAAUG9K9A2dKii9VZqp7xnJ3XIc/kxMH93TvcPHztfOTbhPsy0WHn
        nqL5IO003Hq3uRstFXQVw9x3Y3Mf
X-Google-Smtp-Source: APXvYqzUDfFCwcrx7aMyHfjVlE6G2qZbGPoiXITAy3pqUGRYTv34RiIBhqh3C+k44Ge0Qq9hv6m5dw==
X-Received: by 2002:a17:90a:17c4:: with SMTP id q62mr8018893pja.104.1562889324866;
        Thu, 11 Jul 2019 16:55:24 -0700 (PDT)
Received: from [192.168.0.16] ([97.115.142.179])
        by smtp.gmail.com with ESMTPSA id o3sm18954299pje.1.2019.07.11.16.55.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 16:55:24 -0700 (PDT)
Subject: Re: [ovs-dev] [PATCH net-next] net: openvswitch: do not update
 max_headroom if new headroom is equal to old headroom
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     David Miller <davem@davemloft.net>, ap420073@gmail.com,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20190705160809.5202-1-ap420073@gmail.com>
 <20190708.160804.2026506853635876959.davem@davemloft.net>
 <87bfb355-9ddf-c27b-c160-b3028a945a22@gmail.com>
 <b40f4a39-8de4-482c-2ee8-66adf5c606be@gmail.com>
 <CAOrHB_CLRYC_AFgDhzPGadXDob4hO1Q7Eorqm4bZjMJLV3cMBQ@mail.gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <715a1bc4-abd4-90bb-2e2f-1a2da8fd861d@gmail.com>
Date:   Thu, 11 Jul 2019 16:55:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAOrHB_CLRYC_AFgDhzPGadXDob4hO1Q7Eorqm4bZjMJLV3cMBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/11/2019 2:07 PM, Pravin Shelar wrote:
> I was bit busy for last couple of days. I will finish review by EOD today.
>
> Thanks,
> Pravin.

net-next is closed anyway so no rush, but thanks!

- Greg

>
> On Mon, Jul 8, 2019 at 4:22 PM Gregory Rose <gvrose8192@gmail.com> wrote:
>>
>>
>> On 7/8/2019 4:18 PM, Gregory Rose wrote:
>>> On 7/8/2019 4:08 PM, David Miller wrote:
>>>> From: Taehee Yoo <ap420073@gmail.com>
>>>> Date: Sat,  6 Jul 2019 01:08:09 +0900
>>>>
>>>>> When a vport is deleted, the maximum headroom size would be changed.
>>>>> If the vport which has the largest headroom is deleted,
>>>>> the new max_headroom would be set.
>>>>> But, if the new headroom size is equal to the old headroom size,
>>>>> updating routine is unnecessary.
>>>>>
>>>>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>>>> I'm not so sure about the logic here and I'd therefore like an OVS
>>>> expert
>>>> to review this.
>>> I'll review and test it and get back.  Pravin may have input as well.
>>>
>> Err, adding Pravin.
>>
>> - Greg
>>
>>> Thanks,
>>>
>>> - Greg
>>>
>>>> Thanks.
>>>> _______________________________________________
>>>> dev mailing list
>>>> dev@openvswitch.org
>>>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

