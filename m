Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1584D530F12
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbiEWMyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiEWMyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:54:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05B774D269
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 05:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653310455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POK+VClUkGIpFVtebvY1AJ0GHRBBNCyyP6V/9eIz3lw=;
        b=M67lY1xvYP+otQyYICoIw0g0o243NT4lcE7PR3t0f/ad1lEE+jm3Yo1O+Jks8hmJgkB8xC
        a/mmv43IRbUzymPBjBVjb1iQ6AqBs3JdapwcHTKpLO48pR8hhiSnGynmzJfdejd7thidEZ
        lKtg5uaWrk3b8NQpBkZLe6KiM9N6X1E=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-1cuvy06aORGb3KnQhq0lNQ-1; Mon, 23 May 2022 08:54:14 -0400
X-MC-Unique: 1cuvy06aORGb3KnQhq0lNQ-1
Received: by mail-ej1-f69.google.com with SMTP id gf24-20020a170906e21800b006fe8e7f8783so5602832ejb.2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 05:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=POK+VClUkGIpFVtebvY1AJ0GHRBBNCyyP6V/9eIz3lw=;
        b=0B6ZRhaQkWtpe6M+8OeUv6lzL6Gbh41kcLUEhxdAhMr5Xw9WvXPWvfKnjS5DiU2tmY
         FbAiovWS1t20c9ZF8dFO0/0jlGcfa3YwY0PNB3Iv81It95tDdhyDkZO6caGtSAMccg1C
         2GIfvvT5s3dwzeSUUj3lXqEpW436RxLnOtpdqNyl0frV2LKl06NAZxfGK4IZBm+Q+IkW
         b4wrQfjgaZ0RCe3Z7y1+m28Poe8Rzr/kmInChFjiDuTfpfrMS9+aMsSa060l+zks47T3
         0oV6LOJqbbccWsB8Y8aGqM2ZryG+bQ3G3XONsELtWWhzvfz7YBVOBBGtsgqMrWEMNabF
         daWw==
X-Gm-Message-State: AOAM531tLzI6oC57HF/jkU0ZhvTrI6dDC8xiNzywwGvTZCKYnDuBM1RO
        rpd9u6AU9jDzFwEhzSL+C/2Bd2RPmygTLCnTTZGkKdWAUurHtrcgPIwloW3Lg7PNyjCiwCz9RBu
        vYw5GcW+9q//LMReQ
X-Received: by 2002:a17:907:2d26:b0:6fe:deb2:6de with SMTP id gs38-20020a1709072d2600b006fedeb206demr4935093ejc.108.1653310453495;
        Mon, 23 May 2022 05:54:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdXO0MmncCTtuv2WEIoCzW0TsJeQs6uavBZFtN5Y8kf1AVuCk1/BrVRMSkDIyHPCwiUX4d3Q==
X-Received: by 2002:a17:907:2d26:b0:6fe:deb2:6de with SMTP id gs38-20020a1709072d2600b006fedeb206demr4935064ejc.108.1653310453217;
        Mon, 23 May 2022 05:54:13 -0700 (PDT)
Received: from [192.168.242.1] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id k16-20020a1709067ad000b006fed8dfcf78sm1422446ejo.225.2022.05.23.05.54.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 May 2022 05:54:12 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Vlad Buslov <vladbu@nvidia.com>,
        Toms Atteka <cpp.code.lv@gmail.com>
Cc:     Roi Dayan <roid@nvidia.com>, Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility
 with existing user space
Date:   Mon, 23 May 2022 14:54:09 +0200
X-Mailer: MailMate (1.14r5895)
Message-ID: <CD6F1EAA-7A32-46D2-9806-98CDB98DC537@redhat.com>
In-Reply-To: <FFBEB52B-FA8C-4989-BDC1-1F3908F024B8@redhat.com>
References: <20220309222033.3018976-1-i.maximets@ovn.org>
 <f7ty21hir5v.fsf@redhat.com>
 <44eeb550-3310-d579-91cc-ec18b59966d2@nvidia.com>
 <1a185332-3693-2750-fef2-f6938bbc8500@ovn.org> <87k0c171ml.fsf@nvidia.com>
 <9cc34fbc-3fd6-b529-7a05-554224510452@ovn.org>
 <4778B505-DBF5-4F57-90AF-87F12C1E0311@redhat.com> <87lev783k8.fsf@nvidia.com>
 <FFBEB52B-FA8C-4989-BDC1-1F3908F024B8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17 May 2022, at 13:10, Eelco Chaudron wrote:

> On 12 May 2022, at 12:08, Vlad Buslov wrote:
>
>> On Thu 12 May 2022 at 12:19, Eelco Chaudron <echaudro@redhat.com> wrot=
e:
>>> On 7 Apr 2022, at 12:22, Ilya Maximets wrote:
>>>
>>>> On 4/7/22 10:02, Vlad Buslov wrote:
>>>>> On Mon 14 Mar 2022 at 20:40, Ilya Maximets <i.maximets@ovn.org> wro=
te:
>>>>>> On 3/14/22 19:33, Roi Dayan wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 2022-03-10 8:44 PM, Aaron Conole wrote:
>>>>>>>> Ilya Maximets <i.maximets@ovn.org> writes:
>>>>>>>>
>>>>>>>>> Few years ago OVS user space made a strange choice in the commi=
t [1]
>>>>>>>>> to define types only valid for the user space inside the copy o=
f a
>>>>>>>>> kernel uAPI header.=C2=A0 '#ifndef __KERNEL__' and another attr=
ibute was
>>>>>>>>> added later.
>>>>>>>>>
>>>>>>>>> This leads to the inevitable clash between user space and kerne=
l types
>>>>>>>>> when the kernel uAPI is extended.=C2=A0 The issue was unveiled =
with the
>>>>>>>>> addition of a new type for IPv6 extension header in kernel uAPI=
=2E
>>>>>>>>>
>>>>>>>>> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to=
 the
>>>>>>>>> older user space application, application tries to parse it as
>>>>>>>>> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message=
 as
>>>>>>>>> malformed.=C2=A0 Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied al=
ong with
>>>>>>>>> every IPv6 packet that goes to the user space, IPv6 support is =
fully
>>>>>>>>> broken.
>>>>>>>>>
>>>>>>>>> Fixing that by bringing these user space attributes to the kern=
el
>>>>>>>>> uAPI to avoid the clash.=C2=A0 Strictly speaking this is not th=
e problem
>>>>>>>>> of the kernel uAPI, but changing it is the only way to avoid br=
eakage
>>>>>>>>> of the older user space applications at this point.
>>>>>>>>>
>>>>>>>>> These 2 types are explicitly rejected now since they should not=
 be
>>>>>>>>> passed to the kernel.=C2=A0 Additionally, OVS_KEY_ATTR_TUNNEL_I=
NFO moved
>>>>>>>>> out from the '#ifdef __KERNEL__' as there is no good reason to =
hide
>>>>>>>>> it from the userspace.=C2=A0 And it's also explicitly rejected =
now, because
>>>>>>>>> it's for in-kernel use only.
>>>>>>>>>
>>>>>>>>> Comments with warnings were added to avoid the problem coming b=
ack.
>>>>>>>>>
>>>>>>>>> (1 << type) converted to (1ULL << type) to avoid integer overfl=
ow on
>>>>>>>>> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
>>>>>>>>>
>>>>>>>>> =C2=A0 [1] beb75a40fdc2 ("userspace: Switching of L3 packets in=
 L2 pipeline")
>>>>>>>>>
>>>>>>>>> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extensio=
n header support")
>>>>>>>>> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d=
8a0cad8a5f@nvidia.com
>>>>>>>>> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295b=
fd6521b0068b4cd12f6de507c
>>>>>>>>> Reported-by: Roi Dayan <roid@nvidia.com>
>>>>>>>>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>>>>>>>>> ---
>>>>>>>>
>>>>>>>> Acked-by: Aaron Conole <aconole@redhat.com>
>>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> I got to check traffic with the fix and I do get some traffic
>>>>>>> but something is broken. I didn't investigate much but the quick
>>>>>>> test shows me rules are not offloaded and dumping ovs rules gives=

>>>>>>> error like this
>>>>>>>
>>>>>>> recirc_id(0),in_port(enp8s0f0_1),ct_state(-trk),eth(),eth_type(0x=
86dd),ipv6(frag=3Dno)(bad
>>>>>>> key length 2, expected -1)(00 00/(bad mask length 2, expected -1)=
(00 00),
>>>>>>> packets:2453, bytes:211594, used:0.004s, flags:S., actions:ct,rec=
irc(0x2)
>>>>>>
>>>>>> Such a dump is expected, because kernel parses fields that current=

>>>>>> userspace doesn't understand, and at the same time OVS by design i=
s
>>>>>> using kernel provided key/mask while installing datapath rules, II=
RC.
>>>>>> It should be possible to make these dumps a bit more friendly thou=
gh.
>>>>>>
>>>>>> For the offloading not working, see my comment in the v2 patch ema=
il
>>>>>> I sent (top email of this thread).  In short, it's a problem in us=
er
>>>>>> space and it can not be fixed from the kernel side, unless we reve=
rt
>>>>>> IPv6 extension header support and never add any new types, which i=
s
>>>>>> unreasonable.  I didn't test any actual offloading, but I had a
>>>>>> successful run of 'make check-offloads' with my quick'n'dirty fix =
from
>>>>>> the top email.
>>>>>
>>>>> Hi Ilya,
>>>>>
>>>>> I can confirm that with latest OvS master IPv6 rules offload still =
fails
>>>>> without your pastebin code applied.
>>>>>
>>>>>>
>>>>>> Since we're here:
>>>>>>
>>>>>> Toms, do you plan to submit user space patches for this feature?
>>>>>
>>>>> I see there is a patch from you that is supposed to fix compatibili=
ty
>>>>> issues caused by this change in OvS d96d14b14733 ("openvswitch.h: A=
lign
>>>>> uAPI definition with the kernel."), but it doesn't fix offload for =
me
>>>>> without pastebin patch.
>>>>
>>>> Yes.  OVS commit d96d14b14733 is intended to only fix the uAPI.
>>>> Issue with offload is an OVS bug that should be fixed separately.
>>>> The fix will also need to be backported to OVS stable branches.
>>>>
>>>>> Do you plan to merge that code into OvS or you
>>>>> require some help from our side?
>>>>
>>>> I could do that, but I don't really have enough time.  So, if you
>>>> can work on that fix, it would be great.  Note that comments inside
>>>> the OVS's lib/odp-util.c:parse_key_and_mask_to_match() was blindly
>>>> copied from the userspace datapath and are incorrect for the general=

>>>> case, so has to be fixed alongside the logic of that function.
>>>
>>> Tom or Vlad, are you working on this? Asking, as the release of a ker=
nel with
>>> Tom=E2=80=99s =E2=80=9Cnet: openvswitch: IPv6: Add IPv6 extension hea=
der support=E2=80=9D patch will
>>> break OVS.
>>>
>>> //Eelco
>>
>> Hi Eelco,
>>
>> My simple fix for OvS was rejected and I don't have time to rework it =
at
>> the moment.
>
> That=E2=80=99s a pity, Tom do you maybe have time as your patch left OV=
S in this error state?

Looks like everybody is busy, and as the patched kernel is now available,=
 let me try to fix this on the OVS side.

//Eelco

