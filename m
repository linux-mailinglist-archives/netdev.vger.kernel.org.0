Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8F1443FDD
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhKCKQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhKCKQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 06:16:32 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F234AC061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 03:13:55 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id j9so2448824qvm.10
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 03:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8bs+WoVIfqfMEybZ2ykdFz5yPEomc/Sd27NrojyxX8g=;
        b=GzV+gpGLVD9Srfo4kSxCfnNl5MnSTzW8AsEOTMusJjdEVDwbYUZE+YRj1f9ymv2VAd
         UrV6114DLFfO5Wp3d/7McmMr5k+luWn1s1vj+oTFL4Rs4AkJQQFrSsnMvbEiOSYvHOgF
         rMLH2XHrsTsMxSlkGZjhsncmfef6BtxZz0HhIw3+uQZ2XZdJXqPdSbqK2s3SaMem4FHx
         V9K6SwQTK66GIlyUmnqSL2Cir9/4+Tog3m8ksjDD0N5tEXiwLLyDDNBrL/ANDZYc30/J
         F2fVg1RlhclWkDCM4sma8gOGemByOF2UrN4W7hRBZzTZrvoJB2Il/u+QbTrThNUOCdQN
         ujjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8bs+WoVIfqfMEybZ2ykdFz5yPEomc/Sd27NrojyxX8g=;
        b=E3/LLzUNK9ozLFLS1gMhhXH5ztzgu4ISHECZ1UcWIExyMms0Sw5MsKqS0xeIP7ScIv
         It1cBTYwMhYhwbES80+FNnzPyCvkxwFm7gAL7KrA0DtUI4ajRSB86t5f4IMX/1JPYvEf
         fXg9KnB86EZWiL1gGlB1YmPhHOVBLY+vkvOik/ht2SZeRLomuwrYiYKScvI8gYP1Oeh4
         ilLk7bjqtfCTulLQIGB0+ejN/Z2/m2OeiiTtXe0dWLJjFgX65KMGqSInHFofx7+y+tVl
         2SQGDI9EB/PLQBTMtiuPt8M4Z5VSM3rlz6JULa2PRTWKNie9ZTiuJSDa0wk+L10QX5hA
         3bYA==
X-Gm-Message-State: AOAM531dk7daF4zrps+kWjiyyDMlkLrsZ2qGaQ5Zzp62j0hsHGaU+JFP
        Hgp8ua3UCKmjYNbW94zcI7dhWA==
X-Google-Smtp-Source: ABdhPJww4bhr+PHELJ8jPm3IzD7+vVkfkBEJh+7ruJ5tVskw8TuWe0xYlF87q5EyZjBivFk7vPlmQg==
X-Received: by 2002:a05:6214:27e1:: with SMTP id jt1mr347250qvb.34.1635934435047;
        Wed, 03 Nov 2021 03:13:55 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id y8sm1329637qtx.0.2021.11.03.03.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 03:13:53 -0700 (PDT)
Message-ID: <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
Date:   Wed, 3 Nov 2021 06:13:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-03 03:57, Baowen Zheng wrote:
> On November 2, 2021 8:40 PM, Simon Horman wrote:
>> On Mon, Nov 01, 2021 at 09:38:34AM +0200, Vlad Buslov wrote:
>>> On Mon 01 Nov 2021 at 05:29, Baowen Zheng

[..]
>>>
>>> My suggestion was to forgo the skip_sw flag for shared action offload
>>> and, consecutively, remove the validation code, not to add even more
>>> checks. I still don't see a practical case where skip_sw shared action
>>> is useful. But I don't have any strong feelings about this flag, so if
>>> Jamal thinks it is necessary, then fine by me.
>>
>> FWIIW, my feelings are the same as Vlad's.
>>
>> I think these flags add complexity that would be nice to avoid.
>> But if Jamal thinks its necessary, then including the flags implementation is
>> fine by me.
> Thanks Simon. Jamal, do you think it is necessary to keep the skip_sw flag for user to specify
> the action should not run in software?
> 

Just catching up with discussion...
IMO, we need the flag. Oz indicated with requirement to be able to
identify the action with an index. So if a specific action is added
for skip_sw (as standalone or alongside a filter) then it cant be
used for skip_hw. To illustrate using extended example:

#filter 1, skip_sw
tc filter add dev $DEV1 proto ip parent ffff: flower \
     skip_sw ip_proto tcp action police blah index 10

#filter 2, skip_hw
tc filter add dev $DEV1 proto ip parent ffff: flower \
     skip_hw ip_proto udp action police index 10

Filter2 should be illegal.
And when i dump the actions as so:
tc actions ls action police

For debugability, I should see index 10 clearly marked with
the flag as skip_sw

The other example i gave earlier which showed the sharing
of actions:

#add a policer action and offload it
tc actions add action police skip_sw rate ... index 20
#now add filter1 which is offloaded using offloaded policer
tc filter add dev $DEV1 proto ip parent ffff: flower \
     skip_sw ip_proto tcp action police index 20
#add filter2 likewise offloaded
tc filter add dev $DEV1 proto ip parent ffff: flower \
     skip_sw ip_proto udp action police index 20

All good and filter 1 and 2 are sharing policer instance with
index 20.

#Now add a filter3 which is s/w only
tc filter add dev $DEV1 proto ip parent ffff: flower \
     skip_hw ip_proto icmp action police index 20

filter3 should not be allowed.

cheers,
jamal
