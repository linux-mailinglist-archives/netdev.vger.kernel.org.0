Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309516406FE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiLBMlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiLBMlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:41:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8DA92A3F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669984802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wJ2wgoErJDueIYp6I/hAf4m+NEXaPGfMKgQq8cz2Ew=;
        b=SOx5ZWIm02JG2jMnYvUeQrcbWY5hJ8/BopVuhL/NZ5Zhgh5zUJBMVMHsjKJOV5VXEZV850
        Xjq5sNQHwbbnoOld1jKx8fyahq6XfiIDsPlyEHXouZ6e9AMiUP/h8dfbEmfjxYlUqci3rm
        ZG7J+fNoHLDSc4NerovlhSAD9372S24=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-136-cURwZy-9Nu25ZBssMXXbgA-1; Fri, 02 Dec 2022 07:40:00 -0500
X-MC-Unique: cURwZy-9Nu25ZBssMXXbgA-1
Received: by mail-ej1-f72.google.com with SMTP id hs42-20020a1709073eaa00b007c00fb5a509so3285195ejc.17
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 04:40:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1wJ2wgoErJDueIYp6I/hAf4m+NEXaPGfMKgQq8cz2Ew=;
        b=hN0FEefQi5uueeq9b1zkYUbhAovByQ9kF52yiVQYwFdlUOl2BsO8//em9STukip6hq
         19V9pYTe+5ibrqQxNovp6kvbX9+CcJ9mR+epuP6x9MfEYEzgKMViCtti2b5UMQJmqjeE
         XGXSbl0F0K8bvYF7U/rHN09ySlnSR4LcH0WDOzSgLy1Tf/jUyVWQc622J6H6V7III7gi
         DV1t4UC1hisReEdmzsuZ5D7C+h+WSgrfid5VBw77yBG4DyVqUFgQg39P5/7/ylmG/0x3
         tCjyfyt+rOsqHZjHjmpgWq9pMoye/ZvEBA9fdv5CfYYoS/TmhbGwn9Gk8H01nE/SI19c
         njAQ==
X-Gm-Message-State: ANoB5plbL7neF2IIoYWm6qXqfqTHlQZe+SxeoPlszmPj76/uMwoGLeHX
        qGhuvyMWRcTfc3OTIvPz3tavp7qSmIzTPEDHV2Spq/4rR/9uLLasd32sa+sIyPwMm84+RAirnp1
        g+5/TrwpfBsqGvFiH
X-Received: by 2002:a17:906:314a:b0:7c0:c90a:a978 with SMTP id e10-20020a170906314a00b007c0c90aa978mr1622785eje.387.1669984799610;
        Fri, 02 Dec 2022 04:39:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7+Qeib7MZSkM6ys/7t8WsYFYt78NNrX8E7ilGfb//hg9P4I5ro0bqQz7BkSa79meFlbHVKPQ==
X-Received: by 2002:a17:906:314a:b0:7c0:c90a:a978 with SMTP id e10-20020a170906314a00b007c0c90aa978mr1622766eje.387.1669984799325;
        Fri, 02 Dec 2022 04:39:59 -0800 (PST)
Received: from [10.39.192.173] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7d64d000000b0046ac460da13sm2882467edr.53.2022.12.02.04.39.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Dec 2022 04:39:58 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Tianyu Yuan <tianyu.yuan@corigine.com>
Cc:     Marcelo Leitner <mleitner@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Date:   Fri, 02 Dec 2022 13:39:56 +0100
X-Mailer: MailMate (1.14r5929)
Message-ID: <077229AF-F32B-4147-9F3C-FED786417E61@redhat.com>
In-Reply-To: <PH0PR13MB4793ED98F9384F2CBBA0909094179@PH0PR13MB4793.namprd13.prod.outlook.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <PH0PR13MB4793DE760F60B63796BF9C5E94139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com>
 <FA3E42DF-5CA2-40D4-A448-DE7B73A1AC80@redhat.com>
 <CALnP8ZZiw9b_xOzC3FaB8dnSDU1kJkqR6CQA5oJUu_mUj8eOdQ@mail.gmail.com>
 <80007094-D864-45F2-ABD5-1D22F1E960F6@redhat.com>
 <PH0PR13MB47936B3D3C0C0345C666C87194159@PH0PR13MB4793.namprd13.prod.outlook.com>
 <A92B3AD9-296F-4B20-88AC-D9F4124C15A9@redhat.com>
 <PH0PR13MB4793ED98F9384F2CBBA0909094179@PH0PR13MB4793.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2 Dec 2022, at 13:33, Tianyu Yuan wrote:

> On Fri, Dec 2, 2022 at 8:18 PM , Eelco Chaudron wrote:
>>
>> On 30 Nov 2022, at 4:36, Tianyu Yuan wrote:
>>
>>> On Mon, Nov 29, 2022 at 8:35 PM , Eelco Chaudron wrote:
>>>>
>>>> On 28 Nov 2022, at 14:33, Marcelo Leitner wrote:
>>>>
>>>>> On Mon, Nov 28, 2022 at 02:17:40PM +0100, Eelco Chaudron wrote:
>>>>>>
>>>>>>
>>>>>> On 28 Nov 2022, at 14:11, Marcelo Leitner wrote:
>>>>>>
>>>>>>> On Mon, Nov 28, 2022 at 07:11:05AM +0000, Tianyu Yuan wrote:
>>>>> ...
>>>>>>>>
>>>>>>>> Furthermore, I think the current stats for each action mentioned=

>>>>>>>> in
>>>>>>>> 2) cannot represent the real hw stats and this is why [ RFC
>>>>>>>> net-next v2 0/2] (net: flow_offload: add support for per action
>>>>>>>> hw stats)
>>>> will come up.
>>>>>>>
>>>>>>> Exactly. Then, when this patchset (or similar) come up, it won't
>>>>>>> update all actions with the same stats anymore. It will require a=

>>>>>>> set of stats from hw for the gact with PIPE action here. But if
>>>>>>> drivers are ignoring this action, they can't have specific stats
>>>>>>> for it. Or am I missing something?
>>>>>>>
>>>>>>> So it is better for the drivers to reject the whole flow instead
>>>>>>> of simply ignoring it, and let vswitchd probe if it should or
>>>>>>> should not use this action.
>>>>>>
>>>>>> Please note that OVS does not probe features per interface, but
>>>>>> does it
>>>> per datapath. So if it=E2=80=99s supported in pipe in tc software, w=
e will
>>>> use it. If the driver rejects it, we will probably end up with the t=
c software
>> rule only.
>>>>>
>>>>> Ah right. I remember it will pick 1 interface for testing and use
>>>>> those results everywhere, which then I don't know if it may or may
>>>>> not be a representor port or not. Anyhow, then it should use
>>>>> skip_sw, to try to probe for the offloading part. Otherwise I'm
>>>>> afraid tc sw will always accept this flow and trick the probing, ye=
s.
>>>>
>>>> Well, it depends on how you look at it. In theory, we should be
>>>> hardware agnostic, meaning what if you have different hardware in
>>>> your system? OVS only supports global offload enablement.
>>>>
>>>> Tianyu how are you planning to support this from the OVS side? How
>>>> would you probe kernel and/or hardware support for this change?
>>>
>>> Currently in the test demo, I just extend gact with PIPE (previously
>>> only SHOT as default and GOTO_CHAIN when chain exists), and then put
>>> such a gact with PIPE at the first place of each filter which will be=
 transacted
>> with kernel tc.
>>>
>>> About the tc sw datapath mentioned, we don't have to make changes
>>> because gact with PIPE has already been supported in current tc
>>> implementation and it could act like a 'counter' And for the hardware=

>>> we just need to ignore this PIPE and the stats of this action will st=
ill be
>> updated in kernel side and sent to userspace.
>>
>> I know it=E2=80=99s supported now, but if we implement it, it might fa=
il in existing
>> environments. So from an OVS userspace perspective, you need to
>> implement something like:
>
> I've got your point now, sorry for my misunderstanding previously.

No problem, there are quite some emails around this patch.

>> - Probe the kernel to see if this patch is applied, if not use the old=
 method so
>> we do not break existing deployments when upgrading OVS but not the
>> kernel.
>> - If we do have this newer kernel, do we assume all drivers that worke=
d
>> before, now also work?
>>   - If this is not the case, how will you determine what approach to u=
se? We
>> do not have a per-interface layer, but a per-datapath one, i.e. the ke=
rnel. We
>> do not know at initialization time what NICs will be added later and w=
e can
>> not decide on the strategy to use.
>>
>> Thought? Maybe this should be discussed outside of the netdev mailing =
list,
>> but what I want to highlight is that there should be a runtime way to
>> determine if this patch is applied to the kernel (without using any ac=
tual hw
>> driver).
>
> I agree that whether the patch is applied in kernel should be checked a=
t runtime rather than
> compiling (for the demo I made this check inacinlude.m4). I think I nee=
d some time to investigate
> how to implement it. We may discuss it later in an OVS mailing list.

No problem, but just want to make sure that if it needs changes to this p=
atch to be able to do it, now is the time ;)


>>> I agree with that the unsupported actions should be rejected by
>>> drivers, so may another approach could work without ignoring PIPE in
>>> all the related drivers, that we directly make put the flower stats
>>> from driver into the socket which is used to transact with userspace =
and
>> userspace(e.g. OVS) update the flow stats using this stats instead of =
the
>> parsing the action stats. How do you think of this?

