Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAEC5F7A32
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 17:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJGPDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 11:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJGPDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 11:03:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BF8DD883
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 08:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665155010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Wy5rYDRucQUXXAJqSI7bpMrL8A4N8XBzlm2RZgr8Oo=;
        b=N1lH9nKYyDoGyNx7zug6xxY8twniUND+NRtJLWPs+SapgBNdNLVvmBmsN1E8bnhXLqMU9M
        v2UJE5h24AL3x3j7nyvCkVeinggwpjYvaPYMViAZLwB7w8DYG12aZpAe8U6/E7TycUqi0a
        T0nZ6FDB5wTG/vLNY6lsWyg3+3Rr4ew=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-C_sKx7lbOgKEGT9gn5U2ZQ-1; Fri, 07 Oct 2022 11:03:29 -0400
X-MC-Unique: C_sKx7lbOgKEGT9gn5U2ZQ-1
Received: by mail-ej1-f72.google.com with SMTP id dm10-20020a170907948a00b00781fa5e140fso2990855ejc.21
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 08:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Wy5rYDRucQUXXAJqSI7bpMrL8A4N8XBzlm2RZgr8Oo=;
        b=Kaooyb+ERox4Hw5R0NF1zayJdPYD4AbVyzScIP5MzT0v2Pxgz3Am0FhYOoqlVPRxH5
         PIQ0iLgvirFVt8VJ3uCcTQIKHCU7xesrF6gnXC5hzw1NuuJuzQ8FsCb9TWya832UxUSh
         OHV8wzfseYKw6H+HipEhGYyCcW8Hl5Ire+RgBDTy53I4gB5WrxgLy2pc4OlpRtSnmz/t
         xb0fo+5FHV3B8fwF+JDZJdt+wJ1UBZa5Rr6zodCHirW63bm2BDQ175TKfi9j+hhAQWVd
         K70/m+eYu3BVktv+P51w7A05wZAvJArsiZ+Y0HzNkl5thZHnY4ws9hUi5gtGHZdr9YD3
         WjOA==
X-Gm-Message-State: ACrzQf1WU8SeK2labq3h6GezNIvGlR46beLFUErYcwe4lxB+srBTVZdR
        ky9zlUcoT9qmjPphi00mzpH6gJFcUtZA2SsB39W/ardTuiChA9dX2pgvRqTVClQR1lty4fVAtbi
        umkcEPE8Dlkolx9I2
X-Received: by 2002:a17:906:2699:b0:781:a473:9791 with SMTP id t25-20020a170906269900b00781a4739791mr4384880ejc.644.1665155003882;
        Fri, 07 Oct 2022 08:03:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM44XXRg9gjGMupF6/axZUHUKBhm3jEa0b/lh/RXNfumdHAo77dyAYFjKmTe0Cp9AxZRma/n9A==
X-Received: by 2002:a17:906:2699:b0:781:a473:9791 with SMTP id t25-20020a170906269900b00781a4739791mr4384248ejc.644.1665154995893;
        Fri, 07 Oct 2022 08:03:15 -0700 (PDT)
Received: from [10.39.192.175] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id s24-20020a170906bc5800b007389c5a45f0sm1343284ejv.148.2022.10.07.08.03.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Oct 2022 08:03:14 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Marcelo Leitner <mleitner@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload
 stats
Date:   Fri, 07 Oct 2022 17:03:12 +0200
X-Mailer: MailMate (1.14r5918)
Message-ID: <7C59A1FE-1005-499A-A87C-4639D896F6D7@redhat.com>
In-Reply-To: <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
References: <20220914141923.1725821-1-simon.horman@corigine.com>
 <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org>
 <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org>
 <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com>
 <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7 Oct 2022, at 16:39, Davide Caratti wrote:

> On Fri, Oct 7, 2022 at 3:21 PM Marcelo Leitner <mleitner@redhat.com> wr=
ote:
>>
>> (+TC folks and netdev@)
>>
>> On Fri, Oct 07, 2022 at 02:42:56PM +0200, Ilya Maximets wrote:
>>> On 10/7/22 13:37, Eelco Chaudron wrote:
>
> [...]
>
>> I don't see how we could achieve this without breaking much of the
>> user experience.
>>
>>>
>>> - or create something like act_count - a dummy action that only
>>>   counts packets, and put it in every datapath action from OVS.
>>
>> This seems the easiest and best way forward IMHO. It's actually the
>> 3rd option below but "on demand", considering that tc will already use=

>> the stats of the first action as the flow stats (in
>> tcf_exts_dump_stats()), then we can patch ovs to add such action if a
>> meter is also being used (or perhaps even always, because other
>> actions may also drop packets, and for OVS we would really be at the
>> 3rd option below).

Guess we have to add this extra action to each datapath flow offloaded du=
e to the way flows back and forth translations are handled. Maybe we can =
do it selectively, but the code might become messier than it already is :=
(

> Correct me if I'm wrong, but actually act_gact action with "pipe"
> control action should already do this counting job.

I think we could use that, as we only use TC_ACT_GOTO_CHAIN and TC_ACT_SH=
OT. And it looks like TC_ACT_SHOT is not decoded correctly :(

