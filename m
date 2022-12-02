Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83796406A1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiLBMTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiLBMTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:19:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C7183E8A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669983483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/B0lmYV5uhn+XUDFep5m866izYSlWklJzvI1E7AlKsI=;
        b=O9BE30yfFcZ406s1Yitu2RsPP7T6NwSnBFV/7pwXaMyBDKVgL1Q/zE5/5EQtiJ2EtfstXf
        +DFuSblKce7+S5U+bNXIDocB/ir9ZuKgkkexED6hYw1RosSv3ljJyfcNTxVtJjqKgYD0Xf
        vgNFOEFNmb1sdEIuzM2LNr6oLOFgmCM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-5KECtv1VOwW5M0hyxFpPEQ-1; Fri, 02 Dec 2022 07:18:02 -0500
X-MC-Unique: 5KECtv1VOwW5M0hyxFpPEQ-1
Received: by mail-ej1-f72.google.com with SMTP id qw20-20020a1709066a1400b007af13652c92so3281059ejc.20
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 04:18:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/B0lmYV5uhn+XUDFep5m866izYSlWklJzvI1E7AlKsI=;
        b=M8aQaVg10Ygb0Jwpf05ja/YXsT3XPzqOmfqDV2ceVdyCvfX9mO8sqi1iRH45Yspqne
         TFi7HLOyJ/ym7HHRqUHJnvxDLUhbZbkv4CJk/pj1uWxPnkETDS9Kffix5wNZCSeYFjbF
         uwtEoShR0jMbIPSOuD8Iwl8mjUxclCV8krMGzPpT1BweZVrkho/vkdCfcWK8JYCTfLjC
         6yqByO2Kc7swq9slJSv37xuTj5VYKKrTxfp0rA8ob5TwPALNf6c4urTRhx42xtsLOsR2
         +w/8ief/UqXJycYEU1Goblwtt+O10M/z8w0Cfvdmnm2Gei58Wco7t6wYe/BdFPIdLTQg
         t3aQ==
X-Gm-Message-State: ANoB5pmK0jQBuj4G0fnuEOzHBDpTqcErrhNCgBDz8h5uPwtpCxz1gBV4
        4cvD61Q8KMZb32W3kSNFIsBf29sBgyA3fgt4KH+HF3amp6rsq/yMlGhygI5ljN622JtJj8GzSlZ
        BOBrUREa5WKxSN1Vo
X-Received: by 2002:a17:906:6153:b0:7ad:b51d:39d0 with SMTP id p19-20020a170906615300b007adb51d39d0mr58352435ejl.571.1669983481084;
        Fri, 02 Dec 2022 04:18:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf51KK4qd80RbpKYlHvI+1pPIT6JwTM6kc1rK8Rcg4dETqyKQMtr17XFyfzwF118DBuD1RbLnw==
X-Received: by 2002:a17:906:6153:b0:7ad:b51d:39d0 with SMTP id p19-20020a170906615300b007adb51d39d0mr58352411ejl.571.1669983480773;
        Fri, 02 Dec 2022 04:18:00 -0800 (PST)
Received: from [10.39.192.173] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id eu7-20020a170907298700b007be2687186fsm2934246ejc.21.2022.12.02.04.17.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Dec 2022 04:17:59 -0800 (PST)
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
Date:   Fri, 02 Dec 2022 13:17:59 +0100
X-Mailer: MailMate (1.14r5929)
Message-ID: <A92B3AD9-296F-4B20-88AC-D9F4124C15A9@redhat.com>
In-Reply-To: <PH0PR13MB47936B3D3C0C0345C666C87194159@PH0PR13MB4793.namprd13.prod.outlook.com>
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



On 30 Nov 2022, at 4:36, Tianyu Yuan wrote:

> On Mon, Nov 29, 2022 at 8:35 PM , Eelco Chaudron wrote:
>>
>> On 28 Nov 2022, at 14:33, Marcelo Leitner wrote:
>>
>>> On Mon, Nov 28, 2022 at 02:17:40PM +0100, Eelco Chaudron wrote:
>>>>
>>>>
>>>> On 28 Nov 2022, at 14:11, Marcelo Leitner wrote:
>>>>
>>>>> On Mon, Nov 28, 2022 at 07:11:05AM +0000, Tianyu Yuan wrote:
>>> ...
>>>>>>
>>>>>> Furthermore, I think the current stats for each action mentioned i=
n
>>>>>> 2) cannot represent the real hw stats and this is why [ RFC
>>>>>> net-next v2 0/2] (net: flow_offload: add support for per action hw=
 stats)
>> will come up.
>>>>>
>>>>> Exactly. Then, when this patchset (or similar) come up, it won't
>>>>> update all actions with the same stats anymore. It will require a
>>>>> set of stats from hw for the gact with PIPE action here. But if
>>>>> drivers are ignoring this action, they can't have specific stats fo=
r
>>>>> it. Or am I missing something?
>>>>>
>>>>> So it is better for the drivers to reject the whole flow instead of=

>>>>> simply ignoring it, and let vswitchd probe if it should or should
>>>>> not use this action.
>>>>
>>>> Please note that OVS does not probe features per interface, but does=
 it
>> per datapath. So if it=E2=80=99s supported in pipe in tc software, we =
will use it. If the
>> driver rejects it, we will probably end up with the tc software rule o=
nly.
>>>
>>> Ah right. I remember it will pick 1 interface for testing and use
>>> those results everywhere, which then I don't know if it may or may no=
t
>>> be a representor port or not. Anyhow, then it should use skip_sw, to
>>> try to probe for the offloading part. Otherwise I'm afraid tc sw will=

>>> always accept this flow and trick the probing, yes.
>>
>> Well, it depends on how you look at it. In theory, we should be hardwa=
re
>> agnostic, meaning what if you have different hardware in your system? =
OVS
>> only supports global offload enablement.
>>
>> Tianyu how are you planning to support this from the OVS side? How wou=
ld
>> you probe kernel and/or hardware support for this change?
>
> Currently in the test demo, I just extend gact with PIPE (previously on=
ly SHOT as default and
> GOTO_CHAIN when chain exists), and then put such a gact with PIPE at th=
e first place of each
> filter which will be transacted with kernel tc.
>
> About the tc sw datapath mentioned, we don't have to make changes becau=
se gact with PIPE
> has already been supported in current tc implementation and it could ac=
t like a 'counter' And
> for the hardware we just need to ignore this PIPE and the stats of this=
 action will still be updated
> in kernel side and sent to userspace.

I know it=E2=80=99s supported now, but if we implement it, it might fail =
in existing environments. So from an OVS userspace perspective, you need =
to implement something like:

- Probe the kernel to see if this patch is applied, if not use the old me=
thod so we do not break existing deployments when upgrading OVS but not t=
he kernel.
- If we do have this newer kernel, do we assume all drivers that worked b=
efore, now also work?
  - If this is not the case, how will you determine what approach to use?=
 We do not have a per-interface layer, but a per-datapath one, i.e. the k=
ernel. We do not know at initialization time what NICs will be added late=
r and we can not decide on the strategy to use.

Thought? Maybe this should be discussed outside of the netdev mailing lis=
t, but what I want to highlight is that there should be a runtime way to =
determine if this patch is applied to the kernel (without using any actua=
l hw driver).

//Eelco

> I agree with that the unsupported actions should be rejected by drivers=
, so may another approach
> could work without ignoring PIPE in all the related drivers, that we di=
rectly make put the flower stats
> from driver into the socket which is used to transact with userspace an=
d userspace(e.g. OVS) update
> the flow stats using this stats instead of the parsing the action stats=
=2E How do you think of this?

