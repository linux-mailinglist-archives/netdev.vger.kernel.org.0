Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870074BFD4B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiBVPpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiBVPpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:45:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1B72CFB83
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645544674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWG5t3f2DBHLKA+C+WGd8e9AoVU4PRs2q/81tec2mF0=;
        b=A14UwxhTXHRMVfmNgpqpaYdUlRxnC5LalyKn2VGE7tRnIUkXqPbXByfTG3eiuO3dQSHE21
        BZNA2v7g2JIeNcuTdH2hOPs/pJm+kiv4IoerLp0CM9KNMI5fwiFlQ8HBgttO07CWmLgYgJ
        DR2MR7S2HgXfkQ643ZMze/EmIZxewQE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-ch2a7N-iPMmsF6ZSKb5LJw-1; Tue, 22 Feb 2022 10:44:33 -0500
X-MC-Unique: ch2a7N-iPMmsF6ZSKb5LJw-1
Received: by mail-ed1-f72.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso12166955edt.20
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PWG5t3f2DBHLKA+C+WGd8e9AoVU4PRs2q/81tec2mF0=;
        b=v+cddYHjePNopl1th0ndq+em4SAvEuub7uAIIoKhz5uHfOVSHMZZynYOMy9jozdTJp
         IBrBLkggQzLGFU498BT1hQjvNryiud5zh/JrtnYHfvCkKIURDVj3eFIiBaD1a/N8/vTC
         nmA+vMnf5DNngV5D24pTqHiKTdtJH4CsYRojMC2ZrQxNZWFQpoL4H/2tVVwn5udEnRK2
         TmrprELavOtLSJwLBUaRuQAZIvKIqr4XmSAiVJkaDKPE9bYCfBx6QvLlCa0vFgS18s1L
         F1Mqw/wUNwZ0JbkFcdQDgaY6xM6cdw/DVsifEK3WGABghDvFVnCuFrMuOSNTz0YMBit7
         S0Aw==
X-Gm-Message-State: AOAM533mC1rbkADwn8gEh6gDV8VZ94RlaqVCEMJfGCHEnsZMReGX9mIB
        +91tZC3v3iEdo6G7tksLA5b0lDkDAy8s6Iv1Oblvq/yhtXrKXkBbeWrcpXVrlCPhvvzI2KRN4QG
        XNPpbL4/5utIELWMP
X-Received: by 2002:a17:906:b201:b0:6b5:58c8:e43c with SMTP id p1-20020a170906b20100b006b558c8e43cmr19150504ejz.441.1645544672111;
        Tue, 22 Feb 2022 07:44:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxKYXtKIzrQiVNvd4CCQf9jrPF/85AOwBmOEISsHytYDuuvubP7P35AVbkxPHnqY1htRtHEw==
X-Received: by 2002:a17:906:b201:b0:6b5:58c8:e43c with SMTP id p1-20020a170906b20100b006b558c8e43cmr19150482ejz.441.1645544671802;
        Tue, 22 Feb 2022 07:44:31 -0800 (PST)
Received: from [10.39.193.15] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id d25sm6414575eje.41.2022.02.22.07.44.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Feb 2022 07:44:31 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Marcelo Leitner <mleitner@redhat.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>, dev@openvswitch.org,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        wenxu <wenxu@ucloud.cn>, netdev@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH v2 08/10] netdev-offload-tc: Check for none offloadable ct_state flag combination
Date:   Tue, 22 Feb 2022 16:44:30 +0100
X-Mailer: MailMate (1.14r5870)
Message-ID: <C786EF01-87A3-4471-80E3-CB18B7A4E572@redhat.com>
In-Reply-To: <CALnP8ZZ251hppTzAYVmKzB7WeLTniLVQ-dXePJGekvyBcGLckg@mail.gmail.com>
References: <164362511347.2824752.11751862323892747321.stgit@ebuild>
 <164362638101.2824752.17865423163106515072.stgit@ebuild>
 <b17b6504-49be-72b5-8f09-d50e4db4881b@ovn.org>
 <DE808EB4-983E-47B1-8B72-2EDEEC86FBE6@redhat.com>
 <fd03a6b9-2ccb-f6d1-038b-c23b3a7827f1@ovn.org>
 <D7348910-0483-41A7-BD96-83CB364650D1@redhat.com>
 <7977b95b-aeb2-99ab-5b12-c65d811b765d@ovn.org>
 <CALnP8ZbdEYiecU9rm3jYg4jA=ca0Os7+==6Dn_UiDRtn9-pMRg@mail.gmail.com>
 <D5709C71-4CE5-47F2-AE3E-B8D91B57DAA3@redhat.com>
 <81CEDA74-119C-48E2-89B9-E0C1CC09E95B@redhat.com>
 <CALnP8ZZ251hppTzAYVmKzB7WeLTniLVQ-dXePJGekvyBcGLckg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Feb 2022, at 12:36, Marcelo Leitner wrote:

> +Cc Wenxu, Paul and netdev
>
> On Tue, Feb 22, 2022 at 10:33:44AM +0100, Eelco Chaudron wrote:
>>
>>
>> On 21 Feb 2022, at 15:53, Eelco Chaudron wrote:
>>
>>> On 21 Feb 2022, at 14:33, Marcelo Leitner wrote:
>>
>> <SNIP>
>>
>>>>>> Don=E2=80=99t think this is true, it will only print if +trk and a=
ny other flags are set.
>>>>>> Guess this is where the miscommunication is.>
>>>>>>> The message also seems to be a bit aggressive, especially since i=
t will
>>>>>>> almost always be printed.
>>>>>
>>>>> Yeah.  I missed the fact that you're checking for zero and flower->=
key.ct_state
>>>>> will actually mark existence of other flags.  So, that is fine.
>>>>>
>>>>> However, I'm still not sure that the condition is fully correct.
>>>>>
>>>>> If we'll take a match on '+est' with all other flags wildcarded, th=
at will
>>>>> trigger the condition, because 'flower->key.ct_state' will contain =
the 'est' bit,
>>>>> but 'trk' bit will not be set.  The point is that even though -trk+=
est is not
>>>>
>>>> Oh ow. tc flower will reject this combination today, btw. I don't kn=
ow
>>>> about hw implications for changing that by now.
>>>>
>>>> https://elixir.bootlin.com/linux/latest/C/ident/fl_validate_ct_state=

>>>> 'state' parameter in there is the value masked already.
>>>>
>>>> We directly mapped openflow restrictions to the datapath.
>>>>
>>>>> a valid combination and +trk+est is, OVS may in theory produce the =
match with
>>>>> 'est' bit set and 'trk' bit wildcarded.  And that can be a correct =
configuration.
>>>>
>>>> I guess that means that the only possible parameter validation on
>>>> ct_state at tc level is about its length. Thoughts?
>>>>
>>>
>>> Guess I get it now also :) I was missing the wildcard bit that OVS im=
plies when not specifying any :)
>>>
>>> I think I can fix this by just adding +trk on the TC side when we get=
 the OVS wildcard for +trk. Guess this holds true as for TC there is no -=
trk +flags.
>>>
>>> I=E2=80=99m trying to replicate patch 9 all afternoon, and due to the=
 fact I did not write down which test was causing the problem, and it tak=
ing 20-30 runs, it has not happened yet :( But will do it later tomorrow,=
 see if it works in all cases ;)
>>>
>>
>> So I=E2=80=99ve been doing some experiments (and running all system-tr=
affic tests), and I think the following fix will solve the problem by jus=
t making sure the +trk flag is set in this case on the TC side.
>> This will not change the behavior compared to the kernel.
>>
>> diff --git a/lib/netdev-offload-tc.c b/lib/netdev-offload-tc.c
>> index 0105d883f..3d2c1d844 100644
>> --- a/lib/netdev-offload-tc.c
>> +++ b/lib/netdev-offload-tc.c
>> @@ -1541,6 +1541,12 @@ parse_match_ct_state_to_flower(struct tc_flower=
 *flower, struct match *match)
>>              flower->key.ct_state &=3D ~(TCA_FLOWER_KEY_CT_FLAGS_NEW);=

>>              flower->mask.ct_state &=3D ~(TCA_FLOWER_KEY_CT_FLAGS_NEW)=
;
>>          }
>> +
>> +        if (flower->key.ct_state &&
>> +            !(flower->key.ct_state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)=
) {
>> +            flower->key.ct_state |=3D TCA_FLOWER_KEY_CT_FLAGS_TRACKED=
;
>> +            flower->mask.ct_state |=3D TCA_FLOWER_KEY_CT_FLAGS_TRACKE=
D;
>> +        }
>
> I had meant to update the kernel instead. As Ilya was saying, as this
> is dealing with masks, the validation that tc is doing is not right. I
> mean, for a connection to be in +est, it needs +trk, right, but for
> matching, one could have the following value/mask:
>  value=3Dest
>  mask=3Dest
> which means: match connections in Established AND also untracked ones.

Maybe it was too late last night, but why also untracked ones?
It should only match untracked ones with the est flag set, or do I miss s=
omething?
Untracked ones can never have the est flag set, right?

> Apparently this is what the test is triggering here, and the patch
> above could lead to not match the 2nd part of the AND above.
>
> When fixing the parameter validation in flower, we went too far.
>
>   Marcelo
>
>>      }
>>
>> I will send out a v3 of this set soon with this change included.
>>
>> //Eelco
>>
>> <SNIP>
>>

