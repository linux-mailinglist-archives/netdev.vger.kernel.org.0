Return-Path: <netdev+bounces-8763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8407259A3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 614C5280DBE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852C08F5B;
	Wed,  7 Jun 2023 09:10:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE148F4D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:10:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875DB26B2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 02:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686129003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iz0oQxuwJ2l15hys6A0zcPwXx63ZeyNQhDjgUZCKba0=;
	b=OK7Wr54lHD5CPoXb1MVla6robKPAf9nZvOB1nFBK6yeWkT8/yU6/IOQb3Sf1x3tSai0+fE
	N+rYj7k75m7zcJtcXjXWrKI7VrcPtJrVDSR/eeap/y83vsKfbB3mjKsytEXIR3namu8tCs
	R7X5kOFbPgq9gvlFMjinXWIbCjub/KE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-f7iRWOCKMIWKPE3f_t_Ipw-1; Wed, 07 Jun 2023 05:10:02 -0400
X-MC-Unique: f7iRWOCKMIWKPE3f_t_Ipw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5161e17f374so566530a12.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 02:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686129001; x=1688721001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iz0oQxuwJ2l15hys6A0zcPwXx63ZeyNQhDjgUZCKba0=;
        b=NUR8i+e8HdOjpexBeCbX0zOcdORw7+uvOeDnvXKUrZ3vemZVo2/o4h0qLBuRbvSrkO
         IrNNAfh0Gkqwyfsh88RDu/widpGFPfG3CuGJEczkRydlUEKbZJK08x94/F0VkxvWIH3X
         1cL09GMP95pLxvn5vLRW2k24jyFXv9Mod+/iF8W7ovuWLKzwBlJokvzSglm490AotO1b
         ketdOvW47fkuw9sqtYKi2YBF8PuUsBVf9ivQGBbteW0fAjx3esAEt85MhgnMwYkxpgj0
         wcFqq7ZhFuZCwNBUBiKof6+lXtfKZrvb8kvg18hKazfNrz6/3WIwLNQAPj7dedPsdgBY
         +5iQ==
X-Gm-Message-State: AC+VfDwxGeLU+Sy5T/saW6mi72anLYcvYFoguRL3XpJfM7Gihg9SzvmG
	Dhwn1VEjoPt6Uf1BXZX3ZpMPjVEal3JMvR4zDf/2BjDKOf9f2IAgeNSpKc9spDs8AGU8AWgjhud
	eS1Fw3IPxElYWpVD0
X-Received: by 2002:a50:ee87:0:b0:514:a6a6:facb with SMTP id f7-20020a50ee87000000b00514a6a6facbmr5214834edr.13.1686129000893;
        Wed, 07 Jun 2023 02:10:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6HOMKm0qvUq7l1sHM9wzPleydoxmDvM0mKG344iuG+saeVy9FXvpYubDfpQlrac9uqA7d9cA==
X-Received: by 2002:a50:ee87:0:b0:514:a6a6:facb with SMTP id f7-20020a50ee87000000b00514a6a6facbmr5214818edr.13.1686129000583;
        Wed, 07 Jun 2023 02:10:00 -0700 (PDT)
Received: from [10.39.192.229] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id a15-20020a50e70f000000b0050d83a39e6fsm6050151edn.4.2023.06.07.02.09.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2023 02:10:00 -0700 (PDT)
From: Eelco Chaudron <echaudro@redhat.com>
To: wangchuanlei <wangchuanlei@inspur.com>
Cc: aconole@redhat.com, dev@openvswitch.org, netdev@vger.kernel.org,
 simon.horman@corigine.com, wangpeihui@inspur.com, kuba@kernel.org,
 pabeni@redhat.com, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net v2] net: openvswitch: fix upcall counter
 access before allocation
Date: Wed, 07 Jun 2023 11:09:58 +0200
X-Mailer: MailMate (1.14r5964)
Message-ID: <0E3E5A3D-E1C5-4C27-BEEB-432891F996F4@redhat.com>
In-Reply-To: <20230607010529.1085986-1-wangchuanlei@inspur.com>
References: <20230607010529.1085986-1-wangchuanlei@inspur.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 7 Jun 2023, at 3:05, wangchuanlei wrote:

> Thanks for fix this, in common enviroment, it's a
> small probability event.

Well, on ARM, they could replicate it a couple of times, but I guess the =
system was under memory pressure and has a lot of cores.

>> Eelco Chaudron <echaudro@redhat.com> writes:
>
>> Currently, the per cpu upcall counters are allocated after the vport
>> is created and inserted into the system. This could lead to the
>> datapath accessing the counters before they are allocated resulting in=

>> a kernel Oops.
>>
>> Here is an example:
>>
>>   PID: 59693    TASK: ffff0005f4f51500  CPU: 0    COMMAND: "ovs-vswitc=
hd"
>>    #0 [ffff80000a39b5b0] __switch_to at ffffb70f0629f2f4
>>    #1 [ffff80000a39b5d0] __schedule at ffffb70f0629f5cc
>>    #2 [ffff80000a39b650] preempt_schedule_common at ffffb70f0629fa60
>>    #3 [ffff80000a39b670] dynamic_might_resched at ffffb70f0629fb58
>>    #4 [ffff80000a39b680] mutex_lock_killable at ffffb70f062a1388
>>    #5 [ffff80000a39b6a0] pcpu_alloc at ffffb70f0594460c
>>    #6 [ffff80000a39b750] __alloc_percpu_gfp at ffffb70f05944e68
>>    #7 [ffff80000a39b760] ovs_vport_cmd_new at ffffb70ee6961b90 [openvs=
witch]
>>    ...
>>
>>   PID: 58682    TASK: ffff0005b2f0bf00  CPU: 0    COMMAND: "kworker/0:=
3"
>>    #0 [ffff80000a5d2f40] machine_kexec at ffffb70f056a0758
>>    #1 [ffff80000a5d2f70] __crash_kexec at ffffb70f057e2994
>>    #2 [ffff80000a5d3100] crash_kexec at ffffb70f057e2ad8
>>    #3 [ffff80000a5d3120] die at ffffb70f0628234c
>>    #4 [ffff80000a5d31e0] die_kernel_fault at ffffb70f062828a8
>>    #5 [ffff80000a5d3210] __do_kernel_fault at ffffb70f056a31f4
>>    #6 [ffff80000a5d3240] do_bad_area at ffffb70f056a32a4
>>    #7 [ffff80000a5d3260] do_translation_fault at ffffb70f062a9710
>>    #8 [ffff80000a5d3270] do_mem_abort at ffffb70f056a2f74
>>    #9 [ffff80000a5d32a0] el1_abort at ffffb70f06297dac
>>   #10 [ffff80000a5d32d0] el1h_64_sync_handler at ffffb70f06299b24
>>   #11 [ffff80000a5d3410] el1h_64_sync at ffffb70f056812dc
>>   #12 [ffff80000a5d3430] ovs_dp_upcall at ffffb70ee6963c84 [openvswitc=
h]
>>   #13 [ffff80000a5d3470] ovs_dp_process_packet at ffffb70ee6963fdc [op=
envswitch]
>>   #14 [ffff80000a5d34f0] ovs_vport_receive at ffffb70ee6972c78 [openvs=
witch]
>>   #15 [ffff80000a5d36f0] netdev_port_receive at ffffb70ee6973948 [open=
vswitch]
>>   #16 [ffff80000a5d3720] netdev_frame_hook at ffffb70ee6973a28 [openvs=
witch]
>>   #17 [ffff80000a5d3730] __netif_receive_skb_core.constprop.0 at
>> ffffb70f06079f90
>>
>> We moved the per cpu upcall counter allocation to the existing vport
>> alloc and free functions to solve this.
>>
>> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on
>> failure")
>> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall
>> packets")
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>
> Acked-by: Aaron Conole <aconole@redhat.com>

Were you intentionally ACKing this on Aaron=E2=80=99s behalf? Or just a c=
ut/paste error ;)

> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev


