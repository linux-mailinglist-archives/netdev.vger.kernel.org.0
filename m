Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352D152A019
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbiEQLKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiEQLKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:10:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FCAFD69
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652785845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kWX72bEnjjzAU+t4++AyFmo+uTUVABf+VCDnKL48yO4=;
        b=g4jJw/LpcRImknTB0ZVkyWWtU4ljANgK+lMqllwzpkPyR2ZhMqwQS3l4sZsKVgcrUBXTke
        H/ABbPoAuATeUDBBR4adHAwUkbb/n3eDZNeAcdDNYUHDCOYO8PnaRAZ615vCX+CXbfvwYp
        YzzCjmmZmUHSC8WlN6wJ5bYu34U54T8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-049u3XrRNlGYrLauU4Aasg-1; Tue, 17 May 2022 07:10:43 -0400
X-MC-Unique: 049u3XrRNlGYrLauU4Aasg-1
Received: by mail-ed1-f70.google.com with SMTP id ay24-20020a056402203800b0042a96a76ba5so5583487edb.20
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWX72bEnjjzAU+t4++AyFmo+uTUVABf+VCDnKL48yO4=;
        b=NFPEUjaauqn5tgEBMxFmBKKFN+CngeH/AwwMPuvVIZQlzSdqA//jDRK/UkKzrtCkia
         ccZU5E7OoEI7axKx6mNc4X0yJ4QvoBt7ysO3gotMucWp2DE+f1Vsr8BNkSmGu5t5Nsqs
         bHXdcN37sVuTi/fpBgiytW4DkfFVsbo73RndQ0BUY97U9f+CiHqIN7r5wOlUpTqcl6Yz
         RhHleTqSbCRR2T0UngT1dqGt3BbY2I36MIUsc9btGhrvwLvgzKcdwPV0adu2FFsMCR6d
         ExIToab2s9LpXVtOHxZJnmn/M+vNv+MCDNiuCU+sKuGOJupdoF12rnd7ZwaOa0yE3Dt0
         Bu5w==
X-Gm-Message-State: AOAM533PHsNZ6ds99y6msKjMOqR7TxLZusnOKS5xryVCfx5c65ltogp3
        /dUHDG5hPK2NFCdzsWgzodPcBABc3+Sj7dsrRX0y4diyD4CzDEXyRRis/gsJuoFGSSJVsIDB9DU
        SRgm0UMIMNuItXnNG
X-Received: by 2002:a17:907:72d0:b0:6f5:108c:a34 with SMTP id du16-20020a17090772d000b006f5108c0a34mr19194191ejc.218.1652785842542;
        Tue, 17 May 2022 04:10:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG1VdcJkmKyShSzXvdkW6dl7PU945Qyqo6WlCpamECBV/HnypHfduiJVknMHZYrbYcikpczQ==
X-Received: by 2002:a17:907:72d0:b0:6f5:108c:a34 with SMTP id du16-20020a17090772d000b006f5108c0a34mr19194160ejc.218.1652785842212;
        Tue, 17 May 2022 04:10:42 -0700 (PDT)
Received: from [10.39.192.205] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id w26-20020aa7d29a000000b0042aae307407sm3673956edq.21.2022.05.17.04.10.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 May 2022 04:10:41 -0700 (PDT)
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
Date:   Tue, 17 May 2022 13:10:40 +0200
X-Mailer: MailMate (1.14r5895)
Message-ID: <FFBEB52B-FA8C-4989-BDC1-1F3908F024B8@redhat.com>
In-Reply-To: <87lev783k8.fsf@nvidia.com>
References: <20220309222033.3018976-1-i.maximets@ovn.org>
 <f7ty21hir5v.fsf@redhat.com>
 <44eeb550-3310-d579-91cc-ec18b59966d2@nvidia.com>
 <1a185332-3693-2750-fef2-f6938bbc8500@ovn.org> <87k0c171ml.fsf@nvidia.com>
 <9cc34fbc-3fd6-b529-7a05-554224510452@ovn.org>
 <4778B505-DBF5-4F57-90AF-87F12C1E0311@redhat.com> <87lev783k8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12 May 2022, at 12:08, Vlad Buslov wrote:

> On Thu 12 May 2022 at 12:19, Eelco Chaudron <echaudro@redhat.com> wrote=
:
>> On 7 Apr 2022, at 12:22, Ilya Maximets wrote:
>>
>>> On 4/7/22 10:02, Vlad Buslov wrote:
>>>> On Mon 14 Mar 2022 at 20:40, Ilya Maximets <i.maximets@ovn.org> wrot=
e:
>>>>> On 3/14/22 19:33, Roi Dayan wrote:
>>>>>>
>>>>>>
>>>>>> On 2022-03-10 8:44 PM, Aaron Conole wrote:
>>>>>>> Ilya Maximets <i.maximets@ovn.org> writes:
>>>>>>>
>>>>>>>> Few years ago OVS user space made a strange choice in the commit=
 [1]
>>>>>>>> to define types only valid for the user space inside the copy of=
 a
>>>>>>>> kernel uAPI header.=C2=A0 '#ifndef __KERNEL__' and another attri=
bute was
>>>>>>>> added later.
>>>>>>>>
>>>>>>>> This leads to the inevitable clash between user space and kernel=
 types
>>>>>>>> when the kernel uAPI is extended.=C2=A0 The issue was unveiled w=
ith the
>>>>>>>> addition of a new type for IPv6 extension header in kernel uAPI.=

>>>>>>>>
>>>>>>>> When kernel provides the OVS_KEY_ATTR_IPV6_EXTHDRS attribute to =
the
>>>>>>>> older user space application, application tries to parse it as
>>>>>>>> OVS_KEY_ATTR_PACKET_TYPE and discards the whole netlink message =
as
>>>>>>>> malformed.=C2=A0 Since OVS_KEY_ATTR_IPV6_EXTHDRS is supplied alo=
ng with
>>>>>>>> every IPv6 packet that goes to the user space, IPv6 support is f=
ully
>>>>>>>> broken.
>>>>>>>>
>>>>>>>> Fixing that by bringing these user space attributes to the kerne=
l
>>>>>>>> uAPI to avoid the clash.=C2=A0 Strictly speaking this is not the=
 problem
>>>>>>>> of the kernel uAPI, but changing it is the only way to avoid bre=
akage
>>>>>>>> of the older user space applications at this point.
>>>>>>>>
>>>>>>>> These 2 types are explicitly rejected now since they should not =
be
>>>>>>>> passed to the kernel.=C2=A0 Additionally, OVS_KEY_ATTR_TUNNEL_IN=
FO moved
>>>>>>>> out from the '#ifdef __KERNEL__' as there is no good reason to h=
ide
>>>>>>>> it from the userspace.=C2=A0 And it's also explicitly rejected n=
ow, because
>>>>>>>> it's for in-kernel use only.
>>>>>>>>
>>>>>>>> Comments with warnings were added to avoid the problem coming ba=
ck.
>>>>>>>>
>>>>>>>> (1 << type) converted to (1ULL << type) to avoid integer overflo=
w on
>>>>>>>> OVS_KEY_ATTR_IPV6_EXTHDRS, since it equals 32 now.
>>>>>>>>
>>>>>>>> =C2=A0 [1] beb75a40fdc2 ("userspace: Switching of L3 packets in =
L2 pipeline")
>>>>>>>>
>>>>>>>> Fixes: 28a3f0601727 ("net: openvswitch: IPv6: Add IPv6 extension=
 header support")
>>>>>>>> Link: https://lore.kernel.org/netdev/3adf00c7-fe65-3ef4-b6d7-6d8=
a0cad8a5f@nvidia.com
>>>>>>>> Link: https://github.com/openvswitch/ovs/commit/beb75a40fdc295bf=
d6521b0068b4cd12f6de507c
>>>>>>>> Reported-by: Roi Dayan <roid@nvidia.com>
>>>>>>>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>>>>>>>> ---
>>>>>>>
>>>>>>> Acked-by: Aaron Conole <aconole@redhat.com>
>>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> I got to check traffic with the fix and I do get some traffic
>>>>>> but something is broken. I didn't investigate much but the quick
>>>>>> test shows me rules are not offloaded and dumping ovs rules gives
>>>>>> error like this
>>>>>>
>>>>>> recirc_id(0),in_port(enp8s0f0_1),ct_state(-trk),eth(),eth_type(0x8=
6dd),ipv6(frag=3Dno)(bad
>>>>>> key length 2, expected -1)(00 00/(bad mask length 2, expected -1)(=
00 00),
>>>>>> packets:2453, bytes:211594, used:0.004s, flags:S., actions:ct,reci=
rc(0x2)
>>>>>
>>>>> Such a dump is expected, because kernel parses fields that current
>>>>> userspace doesn't understand, and at the same time OVS by design is=

>>>>> using kernel provided key/mask while installing datapath rules, IIR=
C.
>>>>> It should be possible to make these dumps a bit more friendly thoug=
h.
>>>>>
>>>>> For the offloading not working, see my comment in the v2 patch emai=
l
>>>>> I sent (top email of this thread).  In short, it's a problem in use=
r
>>>>> space and it can not be fixed from the kernel side, unless we rever=
t
>>>>> IPv6 extension header support and never add any new types, which is=

>>>>> unreasonable.  I didn't test any actual offloading, but I had a
>>>>> successful run of 'make check-offloads' with my quick'n'dirty fix f=
rom
>>>>> the top email.
>>>>
>>>> Hi Ilya,
>>>>
>>>> I can confirm that with latest OvS master IPv6 rules offload still f=
ails
>>>> without your pastebin code applied.
>>>>
>>>>>
>>>>> Since we're here:
>>>>>
>>>>> Toms, do you plan to submit user space patches for this feature?
>>>>
>>>> I see there is a patch from you that is supposed to fix compatibilit=
y
>>>> issues caused by this change in OvS d96d14b14733 ("openvswitch.h: Al=
ign
>>>> uAPI definition with the kernel."), but it doesn't fix offload for m=
e
>>>> without pastebin patch.
>>>
>>> Yes.  OVS commit d96d14b14733 is intended to only fix the uAPI.
>>> Issue with offload is an OVS bug that should be fixed separately.
>>> The fix will also need to be backported to OVS stable branches.
>>>
>>>> Do you plan to merge that code into OvS or you
>>>> require some help from our side?
>>>
>>> I could do that, but I don't really have enough time.  So, if you
>>> can work on that fix, it would be great.  Note that comments inside
>>> the OVS's lib/odp-util.c:parse_key_and_mask_to_match() was blindly
>>> copied from the userspace datapath and are incorrect for the general
>>> case, so has to be fixed alongside the logic of that function.
>>
>> Tom or Vlad, are you working on this? Asking, as the release of a kern=
el with
>> Tom=E2=80=99s =E2=80=9Cnet: openvswitch: IPv6: Add IPv6 extension head=
er support=E2=80=9D patch will
>> break OVS.
>>
>> //Eelco
>
> Hi Eelco,
>
> My simple fix for OvS was rejected and I don't have time to rework it a=
t
> the moment.

That=E2=80=99s a pity, Tom do you maybe have time as your patch left OVS =
in this error state?

//Eelco

