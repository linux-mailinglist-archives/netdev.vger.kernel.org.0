Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62C55164A7
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347558AbiEANr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 09:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiEANr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 09:47:56 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD045B3D4
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 06:44:29 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 16so15656703lju.13
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 06:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BV3tGIJv7cFXsfQYEsVnmGBSG8UYA5OrP4bIavH19vc=;
        b=5C9vsM9JO0foLVFVwJQY+KCxjm5dt4gLiPBDX6BnoNNpHVRiQkEzJIa/51wfrSRbQy
         zImlHIe4w97QCzLHQnZHKqs80dxh3Fr7WRTQif3OsfAwLgxMGjL2+TfT4ZFhJd/8WXCY
         mZYhAi9H4JF9aWNw9AkV1WsPThXQjbqr0xP1x7K42o5UGAFFrObxDVBAu+er2DHAVZYJ
         cSemtxMIU52D3NZiVwjNzkmb+yMqiWRGUzNLj6QMK57z5Q0pwk8JG6Oou0H+jo7PraJH
         ql1XCa+FKj7YhCfHy5WoKK8blBlojg4hJ4CN6JXmYcrE5g5Soaelo6wlUm7Ux+9CaR8D
         pV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BV3tGIJv7cFXsfQYEsVnmGBSG8UYA5OrP4bIavH19vc=;
        b=OVBNY38LrNYxcMYdRp5c/NUmggAIrwAivOlVGjcIN4SROF96XvpeGjBYuJtjcbAvrQ
         m4mDdDwnY2OYMDgNdqvEra/JKowpYzE1sjIMlGYHZjwYqcOrgmdt54DyDLq1LeDylis0
         xGzPXsDalGiK3uSV+/w6LZGisKj/MMRAH0pPG+z3+pHL9k4Y3GvgZ0f/HtauDYr/MgDP
         9gAssL92BpFI6ktcPbYEi5NNaBn88PgNtphm4ueF6pV1LTQduYSZCdadRzKxuZNk3hT6
         7uU59vaw4jv91Zibn1C7aChI91yCX58yJg8TJd8k1YeQvDKljtEoD0RzPU9ITSNCKy4E
         PG9Q==
X-Gm-Message-State: AOAM530as8N5aj3FQ5yeBVI4StN2B4eCsdLfktfP3fzcuogu3NejuuU8
        EE7PkUMTCmaapX5Nje5NvjWUOQ==
X-Google-Smtp-Source: ABdhPJwQnPuRQH4MgxkUAQ1R3/AsrnCFOu5iCQnh9aYdtBeHwFaZqbXF9rRtGGSdjAhsG0zRM4Ik8g==
X-Received: by 2002:a2e:8245:0:b0:24b:48b1:a1ab with SMTP id j5-20020a2e8245000000b0024b48b1a1abmr5456361ljh.152.1651412667957;
        Sun, 01 May 2022 06:44:27 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id z26-20020ac25dfa000000b0047255d211e2sm446882lfq.273.2022.05.01.06.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 06:44:27 -0700 (PDT)
Message-ID: <78b556f9-e57b-325d-89ce-7a482ef4ea21@openvz.org>
Date:   Sun, 1 May 2022 16:44:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks
 allocations
Content-Language: en-US
To:     Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <YmdeCqi6wmgiSiWh@carbon>
 <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
 <20220427122232.GA9823@blackbody.suse.cz>
 <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
 <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
 <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ@mail.gmail.com>
From:   Vasily Averin <vvs@openvz.org>
In-Reply-To: <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 01:47, Shakeel Butt wrote:
> On Wed, Apr 27, 2022 at 3:43 PM Vasily Averin <vvs@openvz.org> wrote:
>>
>> On 4/27/22 18:06, Shakeel Butt wrote:
>>> On Wed, Apr 27, 2022 at 5:22 AM Michal Koutný <mkoutny@suse.com> wrote:
>>>>
>>>> On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@google.com> wrote:
>>>>> [...]
>>>>>>
>>>>>> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
>>>>>> +{
>>>>>> +       struct mem_cgroup *memcg;
>>>>>> +
>>>>>
>>>>> Do we need memcg_kmem_enabled() check here or maybe
>>>>> mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
>>>>> mem_cgroup_disabled() as we can have "cgroup.memory=nokmem" boot
>>>>> param.
>>
>> Shakeel, unfortunately I'm not ready to answer this question right now.
>> I even did not noticed that memcg_kmem_enabled() and mem_cgroup_disabled()
>> have a different nature.
>> If you have no objections I'm going to keep this place as is and investigate
>> this question later.
>>
> 
> Patch is good as is. Just add the documentation to the functions in
> the next version and you can keep the ACKs.

I noticed that the kernel already has a function get_mem_cgroup_from_objcg(),
the name of which is very similar to my new function get_mem_cgroup_from_obj().
Maybe it's better to rename my function to get_mem_cgroup_from_ptr()?

Thank you,
	Vasily Averin
