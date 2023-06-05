Return-Path: <netdev+bounces-8032-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6DF7227E6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB9E3281129
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CC31D2B6;
	Mon,  5 Jun 2023 13:54:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289631B90C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:54:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B579C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685973244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ox7erS82/lyHsL/eQfOWPJeShFZ/k7n2in8a0PcRZw0=;
	b=VtucHz/KR5/my5jzghf9mhuxscNXOiUzG7t84jeN/pX5jqu+eutOREdtqYFYCVhc/pmLCN
	jiiAZB8QGSBLqMWVBJyS+QNRKcVh+iC6i8rmM0/JstFpgb4K5gTHePqoitRfkLIqsIcXmO
	93T61+xqr/27odyunsVyhxXh1XYCI34=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-ZsD-HhubMLeDghD-1Cx-ZQ-1; Mon, 05 Jun 2023 09:54:03 -0400
X-MC-Unique: ZsD-HhubMLeDghD-1Cx-ZQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-977d0333523so142313366b.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 06:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973242; x=1688565242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ox7erS82/lyHsL/eQfOWPJeShFZ/k7n2in8a0PcRZw0=;
        b=kmfQ31XMto1ns/sTHH4HwrU39B4p0ZcNW+wcbheu1ThNwwiqBPFzJ1x6VAb1MgSpd4
         ky18oP9jkkmYXhoE7GCWivmz/dkJQEdw7BBOVZHK5l26aHL69KvKv0wDG9pHGM0uImiY
         0ymfwPtBxpJe2r4HZnoakYX2oPk6H6DHrn3WaUb7ad+Qh8fIsM8pnpJW00d2Yd03gstP
         Hw70QmK1zLU6qFelrZdl1A2OdEwPKFQ0Fm08pZ/yI5et9gHlG4YtrPlLduG/+Gkw5gOQ
         cy4KKlN3VzaZ8aA71n391qJCvSSEkGwpnXOfA7sTn7r1cTLPVe5G0pShmzVLT2Zr0NNq
         f8qA==
X-Gm-Message-State: AC+VfDxALbSKzp1IWICM09xxBuRNzRFNSitEhPfUv/m4B0jTyq+ZTdMw
	0C29JVIXLL8u2zdh7Rzw81GKYSiXcgJPNV17CVRCiuNpfv2RBTTD/dPVyEcasGkyJSVsQPBWt8J
	2Ggc3Chpw/Q2/peRJ
X-Received: by 2002:a17:907:1ca0:b0:974:1ef1:81fb with SMTP id nb32-20020a1709071ca000b009741ef181fbmr6565612ejc.22.1685973242027;
        Mon, 05 Jun 2023 06:54:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7mFJ4L3fBpARn7bxSXHtJ4VGQnW+9hZsHbrXSEXNQrC7p9i7hGum3bp3Z+Tm1ha79SrPN3SQ==
X-Received: by 2002:a17:907:1ca0:b0:974:1ef1:81fb with SMTP id nb32-20020a1709071ca000b009741ef181fbmr6565602ejc.22.1685973241720;
        Mon, 05 Jun 2023 06:54:01 -0700 (PDT)
Received: from [10.39.194.92] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id j21-20020a170906095500b0096b20c968afsm4306051ejd.124.2023.06.05.06.54.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Jun 2023 06:54:00 -0700 (PDT)
From: Eelco Chaudron <echaudro@redhat.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org, dev@openvswitch.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: fix upcall counter access
 before allocation
Date: Mon, 05 Jun 2023 15:53:59 +0200
X-Mailer: MailMate (1.14r5964)
Message-ID: <69E863E6-89C0-4AC7-85F1-022451CAD41A@redhat.com>
In-Reply-To: <ZH3eCENbZeSJ3MZS@corigine.com>
References: <168595558535.1618839.4634246126873842766.stgit@ebuild>
 <ZH3X/lLNwfAIZfdq@corigine.com>
 <FD16AC44-E1DA-4E6A-AE3E-905D55AB1A7D@redhat.com>
 <ZH3eCENbZeSJ3MZS@corigine.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5 Jun 2023, at 15:07, Simon Horman wrote:

> On Mon, Jun 05, 2023 at 02:54:35PM +0200, Eelco Chaudron wrote:
>>
>>
>> On 5 Jun 2023, at 14:41, Simon Horman wrote:
>>
>>> On Mon, Jun 05, 2023 at 10:59:50AM +0200, Eelco Chaudron wrote:
>>>> Currently, the per cpu upcall counters are allocated after the vport=
 is
>>>> created and inserted into the system. This could lead to the datapat=
h
>>>> accessing the counters before they are allocated resulting in a kern=
el
>>>> Oops.
>>>>
>>>> Here is an example:
>>>>
>>>>   PID: 59693    TASK: ffff0005f4f51500  CPU: 0    COMMAND: "ovs-vswi=
tchd"
>>>>    #0 [ffff80000a39b5b0] __switch_to at ffffb70f0629f2f4
>>>>    #1 [ffff80000a39b5d0] __schedule at ffffb70f0629f5cc
>>>>    #2 [ffff80000a39b650] preempt_schedule_common at ffffb70f0629fa60=

>>>>    #3 [ffff80000a39b670] dynamic_might_resched at ffffb70f0629fb58
>>>>    #4 [ffff80000a39b680] mutex_lock_killable at ffffb70f062a1388
>>>>    #5 [ffff80000a39b6a0] pcpu_alloc at ffffb70f0594460c
>>>>    #6 [ffff80000a39b750] __alloc_percpu_gfp at ffffb70f05944e68
>>>>    #7 [ffff80000a39b760] ovs_vport_cmd_new at ffffb70ee6961b90 [open=
vswitch]
>>>>    ...
>>>>
>>>>   PID: 58682    TASK: ffff0005b2f0bf00  CPU: 0    COMMAND: "kworker/=
0:3"
>>>>    #0 [ffff80000a5d2f40] machine_kexec at ffffb70f056a0758
>>>>    #1 [ffff80000a5d2f70] __crash_kexec at ffffb70f057e2994
>>>>    #2 [ffff80000a5d3100] crash_kexec at ffffb70f057e2ad8
>>>>    #3 [ffff80000a5d3120] die at ffffb70f0628234c
>>>>    #4 [ffff80000a5d31e0] die_kernel_fault at ffffb70f062828a8
>>>>    #5 [ffff80000a5d3210] __do_kernel_fault at ffffb70f056a31f4
>>>>    #6 [ffff80000a5d3240] do_bad_area at ffffb70f056a32a4
>>>>    #7 [ffff80000a5d3260] do_translation_fault at ffffb70f062a9710
>>>>    #8 [ffff80000a5d3270] do_mem_abort at ffffb70f056a2f74
>>>>    #9 [ffff80000a5d32a0] el1_abort at ffffb70f06297dac
>>>>   #10 [ffff80000a5d32d0] el1h_64_sync_handler at ffffb70f06299b24
>>>>   #11 [ffff80000a5d3410] el1h_64_sync at ffffb70f056812dc
>>>>   #12 [ffff80000a5d3430] ovs_dp_upcall at ffffb70ee6963c84 [openvswi=
tch]
>>>>   #13 [ffff80000a5d3470] ovs_dp_process_packet at ffffb70ee6963fdc [=
openvswitch]
>>>>   #14 [ffff80000a5d34f0] ovs_vport_receive at ffffb70ee6972c78 [open=
vswitch]
>>>>   #15 [ffff80000a5d36f0] netdev_port_receive at ffffb70ee6973948 [op=
envswitch]
>>>>   #16 [ffff80000a5d3720] netdev_frame_hook at ffffb70ee6973a28 [open=
vswitch]
>>>>   #17 [ffff80000a5d3730] __netif_receive_skb_core.constprop.0 at fff=
fb70f06079f90
>>>>
>>>> We moved the per cpu upcall counter allocation to the existing vport=

>>>> alloc and free functions to solve this.
>>>>
>>>> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on f=
ailure")
>>>> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall =
packets")
>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>> ---
>>>>  net/openvswitch/datapath.c |   19 -------------------
>>>>  net/openvswitch/vport.c    |    8 ++++++++
>>>>  2 files changed, 8 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c=

>>>> index fcee6012293b..58f530f60172 100644
>>>> --- a/net/openvswitch/datapath.c
>>>> +++ b/net/openvswitch/datapath.c
>>>> @@ -236,9 +236,6 @@ void ovs_dp_detach_port(struct vport *p)
>>>>  	/* First drop references to device. */
>>>>  	hlist_del_rcu(&p->dp_hash_node);
>>>>
>>>> -	/* Free percpu memory */
>>>> -	free_percpu(p->upcall_stats);
>>>> -
>>>>  	/* Then destroy it. */
>>>>  	ovs_vport_del(p);
>>>>  }
>>>> @@ -1858,12 +1855,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb=
, struct genl_info *info)
>>>>  		goto err_destroy_portids;
>>>>  	}
>>>>
>>>> -	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcal=
l_stats_percpu);
>>>> -	if (!vport->upcall_stats) {
>>>> -		err =3D -ENOMEM;
>>>> -		goto err_destroy_vport;
>>>> -	}
>>>> -
>>>>  	err =3D ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
>>>>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
>>>>  	BUG_ON(err < 0);
>>>> @@ -1876,8 +1867,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb,=
 struct genl_info *info)
>>>>  	ovs_notify(&dp_datapath_genl_family, reply, info);
>>>>  	return 0;
>>>>
>>>> -err_destroy_vport:
>>>> -	ovs_dp_detach_port(vport);
>>>>  err_destroy_portids:
>>>>  	kfree(rcu_dereference_raw(dp->upcall_portids));
>>>>  err_unlock_and_destroy_meters:
>>>> @@ -2322,12 +2311,6 @@ static int ovs_vport_cmd_new(struct sk_buff *=
skb, struct genl_info *info)
>>>>  		goto exit_unlock_free;
>>>>  	}
>>>>
>>>> -	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcal=
l_stats_percpu);
>>>> -	if (!vport->upcall_stats) {
>>>> -		err =3D -ENOMEM;
>>>> -		goto exit_unlock_free_vport;
>>>> -	}
>>>> -
>>>>  	err =3D ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),=

>>>>  				      info->snd_portid, info->snd_seq, 0,
>>>>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
>>>> @@ -2345,8 +2328,6 @@ static int ovs_vport_cmd_new(struct sk_buff *s=
kb, struct genl_info *info)
>>>>  	ovs_notify(&dp_vport_genl_family, reply, info);
>>>>  	return 0;
>>>>
>>>> -exit_unlock_free_vport:
>>>> -	ovs_dp_detach_port(vport);
>>>>  exit_unlock_free:
>>>>  	ovs_unlock();
>>>>  	kfree_skb(reply);
>>>> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
>>>> index 7e0f5c45b512..e91ae5dd7d22 100644
>>>> --- a/net/openvswitch/vport.c
>>>> +++ b/net/openvswitch/vport.c
>>>
>>> Hi Eelco,
>>>
>>> could we move to a more idiomatic implementation
>>> of the error path in ovs_vport_alloc() ?
>>>
>>> I know it's not strictly related to this change, but OTOH, it is.
>>
>> Thanks Simon for the review=E2=80=A6
>>
>> I decided to stick to fixing the issue, not trying to do cleanup stuff=
 while at it :) But if there are no further comments by tomorrow, I can s=
end a v2 including this change.
>
> Yeah, I see that. And I might have done the same thing.
> But, OTOH, this change is making the error path more complex
> (or at least more prone to error).
>
> In any case, the fix looks good.

Thanks, just to clarify if we get no further feedback on this patch, do y=
ou prefer a v2 with the error path changes?

> Reviewed-by: Simon Horman <simon.horman@corigine.com>


