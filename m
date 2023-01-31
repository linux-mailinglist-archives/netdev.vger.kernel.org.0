Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CB768333F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjAaRCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjAaRCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:02:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294812F7A5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675184497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2xOsXDkMN+RQ9c6xu40gw1yE8RYgDr7rjQ1xfpW2OHY=;
        b=GI1IrtLbke19gykB3d0DIaaIb4ZXHOegBx42EoJ2aQKOmJpO7LOph/YSke5kjZJWkVSsjM
        Wwu+pcNvTc/dZcrIlT+FkJobjM3Y2rnY0WGoYRzHT2vBctKH/rKwOjnB0n2YsNsfOggE8Y
        REHqdIyMJGcKWcJ7vLwYi8UgpOaR3mY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-61-RD_YGUVmM-CMs-1z8szzxg-1; Tue, 31 Jan 2023 12:01:33 -0500
X-MC-Unique: RD_YGUVmM-CMs-1z8szzxg-1
Received: by mail-ej1-f70.google.com with SMTP id d10-20020a170906640a00b008787d18c373so9041657ejm.17
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:01:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xOsXDkMN+RQ9c6xu40gw1yE8RYgDr7rjQ1xfpW2OHY=;
        b=NdTIWUj47VITUUNtyv/aK8JoMDDJV0OvxW3Aspi+lo+VrN742wDB/5ylzAZea/+xcY
         QV0XHd/a8iEpjGJGgI+XHt4lm32ikLKYA+lgM3muHshGmWSAy3ZH9T8i0k1BIXRybrUC
         H5ek7FTgZR9WlGySLG2ecWpZwDwDMo1el62kAHSywxTZtcMYzXAwPfLhy5rAwRPVSEoQ
         rnvMVW+WOhYu4ZJG4bB6cPkWTowtKFAFRij7uC5AHbl6iPFUf+zua56xy6jCwWVAtUX6
         bXYoeMhI/nslbwRJTvhpN0U/SkCmCYz34OND1ztQQO1bfy5Kg42e2aFFE+tLbi4UKjIg
         DuTw==
X-Gm-Message-State: AFqh2kq7zdNpvqEzmbPDTGsy4KN2BufJI8gWL5P8WN9P/24CwKRRrP3b
        6jhIhnkBrU2potg084I6VVwwA1W0W4g5IfyfYLzumyaPtPCzVwvJ1URrqyRIr3X4ni5hcCmhzV4
        dZfkFIUwr9Ps30jYR
X-Received: by 2002:aa7:cb01:0:b0:495:fa3d:1d72 with SMTP id s1-20020aa7cb01000000b00495fa3d1d72mr56813650edt.8.1675184489378;
        Tue, 31 Jan 2023 09:01:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuEI3K3Q+BhAArjR1EuBqsQE8LO0x4+bCa8ESNnyGJp/TaLhzFWD0WHh15zQXK5ho1SHwYvWQ==
X-Received: by 2002:aa7:cb01:0:b0:495:fa3d:1d72 with SMTP id s1-20020aa7cb01000000b00495fa3d1d72mr56813612edt.8.1675184489142;
        Tue, 31 Jan 2023 09:01:29 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n6-20020aa7d046000000b004a245d70f17sm3573728edo.54.2023.01.31.09.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 09:01:28 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3609997283A; Tue, 31 Jan 2023 18:01:27 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
In-Reply-To: <Y9kn6bh8z11xWsDh@nanopsycho>
References: <Y9eYNsklxkm8CkyP@nanopsycho> <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk> <Y9kn6bh8z11xWsDh@nanopsycho>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 31 Jan 2023 18:01:27 +0100
Message-ID: <87357qvdso.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Pirko <jiri@resnulli.us> writes:

> Tue, Jan 31, 2023 at 01:17:14PM CET, toke@redhat.com wrote:
>>Jamal Hadi Salim <jhs@mojatatu.com> writes:
>>
>>> Toke, i dont think i have managed to get across that there is an
>>> "autonomous" control built into the kernel. It is not just things that
>>> come across netlink. It's about the whole infra.
>>
>>I'm not disputing the need for the TC infra to configure the pipelines
>>and their relationship in the hardware. I'm saying that your
>>implementation *of the SW path* is the wrong approach and it would be
>>better done by using BPF (not talking about the existing TC-BPF,
>>either).
>>
>>It's a bit hard to know your thinking for sure here, since your patch
>>series doesn't include any of the offload control bits. But from the
>>slides and your hints in this series, AFAICT, the flow goes something
>>like:
>>
>>hw_pipeline_id = devlink_program_hardware(dev, p4_compiled_blob);
>>sw_pipeline_id = `tc p4template create ...` (etc, this is generated by P4C)
>>
>>tc_act = tc_act_create(hw_pipeline_id, sw_pipeline_id)
>>
>>which will turn into something like:
>>
>>struct p4_cls_offload ofl = {
>>  .classid = classid,
>>  .pipeline_id = hw_pipeline_id
>>};
>>
>>if (check_sw_and_hw_equivalence(hw_pipeline_id, sw_pipeline_id)) /* some magic check here */
>>  return -EINVAL;
>>
>>netdev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_P4, &ofl);
>>
>>
>>I.e, all that's being passed to the hardware is the ID of the
>>pre-programmed pipeline, because that programming is going to be
>>out-of-band via devlink anyway.
>>
>>In which case, you could just as well replace the above:
>>
>>sw_pipeline_id = `tc p4template create ...` (etc, this is generated by P4C)
>>
>>with
>>
>>sw_pipeline_id = bpf_prog_load(BPF_PROG_TYPE_P4TC, "my_obj_file.o"); /* my_obj_file is created by P4c */
>>
>>and achieve exactly the same.
>>
>>Having all the P4 data types and concepts exist inside the kernel
>>*might* make sense if the kernel could then translate those into the
>>hardware representations and manage their lifecycle in a uniform way.
>>But as far as I can tell from the slides and what you've been saying in
>>this thread that's not going to be possible anyway, so why do you need
>>anything more granular than the pipeline ID?
>
> Toke, I understand what what you describe above is applicable for the P4
> program instantiation (pipeline definition).
>
> What is the suggestion for the actual "rule insertions" ? Would it make
> sense to use TC iface (Jamal's or similar) to insert rules to both BPF SW
> path and offloaded HW path?

Hmm, so by "rule insertions" here you're referring to populating what P4
calls 'tables', right?

I could see a couple of ways this could be bridged between the BPF side
and the HW side:

- Create a new BPF map type that is backed by the TC-internal data
  structure, so updates from userspace go via the TC interface, but BPF
  programs access the contents via the bpf_map_*() helpers (or we could
  allow updating via the bpf() syscall as well)

- Expose the TC data structures to BPF via their own set of kfuncs,
  similar to what we did for conntrack

- Scrap the TC interface entirely and make this an offload-enabled BPF
  map type (using the BPF ndo and bpf_map_dev_ops operations to update
  it). Userspace would then populate it via the bpf() syscall like any
  other map.


I suspect the map interface is the most straight-forward to use from the
BPF side, but informing this by what existing implementations do
(thinking of the P4->XDP compiler in particular) might be a good idea?

-Toke

