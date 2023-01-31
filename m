Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7DD682CAD
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjAaMhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjAaMhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:37:19 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D144B74C
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:37:15 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id mf7so22440189ejc.6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QtyZHRudbgz5Qd4a4/Imr124YZGFT3m03anE2cLypgM=;
        b=eUvvWpztzp0o2MroS+6gN4b4D/YQoJdHnl7URZjRJqbBlIoWoh309RDMhZy7N4extS
         1c3x7m4/ivoiIUlGKpK9LPOyr1GKOuTn8mBna/zb2ff2rIojZ6puUY9VpRE9jRUh+uXb
         vlppFvCDxeesgwhxB+MS2ZCqgh52GABOQfQj0H4r7VWXhpxN8v4SZh/5HcUZ0EFDFaTm
         A0sCHxaclwKVqO7qPTtbQvZ/3LJ+siF8Z4/ja50Ort0Or9ecuSxJ0tQ8yvUDuoh+FrM4
         bm4bMN88eX102+vciXXQDb2Q7apBvFW1uYE5dqdsamoB4qoR0OLlC+JKyFDNB9TdDUF/
         Rn0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtyZHRudbgz5Qd4a4/Imr124YZGFT3m03anE2cLypgM=;
        b=JNcyWTDUNdCVIWAq2pMKStwh+nBsQbHeYN6Sw2tmAXDNnTrQSxpAe5ZU8YppU++r7q
         WCDsY58nT1Pays2Jm7xLI4UUxEV1rqz3ziMEAtEooth3coiXOVweUiu6KAG/3P1NgRJ3
         htER2OVBFuacjBuY0Qx+GtwCyhqBs7Byk/KnbV6EFqD1b+ZBIID/xNZAT9EpF7okXz/z
         vidKpGey7wn7P5xQFzq1cHpZuas3XRRt6u65/JA0fwRPBpa8qTlHjyI0gcle6mpI4ShT
         DdxSda8wb7SncDfoGC/sqTR2stbl92bhjvcE006mEwt7T9lEQ4zXKa1y49wR8171A1Mk
         uGxA==
X-Gm-Message-State: AO0yUKULMX7WxqcYdl24DMtxy7magPMfbSLNWvwha6HUYJMtLIdtSSFm
        zGxpmhnxxv2S8vtPIPjidKhxzQ==
X-Google-Smtp-Source: AK7set/FMuH2wFCk8kfcHaq2w3i5e6KSAkeEjr5OEq0DqKRiMW9MbD919p/bco20Aayz/1ckQUpTLw==
X-Received: by 2002:a17:906:a2d0:b0:883:c829:fc5e with SMTP id by16-20020a170906a2d000b00883c829fc5emr12428407ejb.68.1675168633935;
        Tue, 31 Jan 2023 04:37:13 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906218100b008720c458bd4sm8314863eju.3.2023.01.31.04.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 04:37:13 -0800 (PST)
Date:   Tue, 31 Jan 2023 13:37:12 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
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
Message-ID: <Y9kLeGs0JmIJV0Ch@nanopsycho>
References: <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk>
 <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6w6vqyd.fsf@toke.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 31, 2023 at 01:17:14PM CET, toke@redhat.com wrote:
>Jamal Hadi Salim <jhs@mojatatu.com> writes:
>
>> Toke, i dont think i have managed to get across that there is an
>> "autonomous" control built into the kernel. It is not just things that
>> come across netlink. It's about the whole infra.
>
>I'm not disputing the need for the TC infra to configure the pipelines
>and their relationship in the hardware. I'm saying that your
>implementation *of the SW path* is the wrong approach and it would be
>better done by using BPF (not talking about the existing TC-BPF,
>either).
>
>It's a bit hard to know your thinking for sure here, since your patch
>series doesn't include any of the offload control bits. But from the
>slides and your hints in this series, AFAICT, the flow goes something
>like:
>
>hw_pipeline_id = devlink_program_hardware(dev, p4_compiled_blob);

I don't think that devlink is the correct iface for this. If you want to
tight it together with the SW pipeline configurable by TC, use TC as you
do for the BPF binary in this example. If you have the TC-block shared
among many netdevs, the HW needs to know that for binding the P4 input.

Btw, you can have multiple netdevs of different vendors sharing the same
TC-block, then you need to upload multiple HW binary blobs here.

What it eventually might result with is that the userspace would upload
a list of binaries with indication what is the target:
"BPF" -> xxx.o
"DRIVERNAMEX" -> aaa.bin
"DRIVERNAMEY" -> bbb.bin
In theory, there might be a HW to accept the BPF binary :) My point is,
userspace provides a list of binaries, individual kernel parts take what
they like.


>sw_pipeline_id = `tc p4template create ...` (etc, this is generated by P4C)
>
>tc_act = tc_act_create(hw_pipeline_id, sw_pipeline_id)
>
>which will turn into something like:
>
>struct p4_cls_offload ofl = {
>  .classid = classid,
>  .pipeline_id = hw_pipeline_id
>};
>
>if (check_sw_and_hw_equivalence(hw_pipeline_id, sw_pipeline_id)) /* some magic check here */

Ha! I would like to see this magic here :)


>  return -EINVAL;
>
>netdev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_P4, &ofl);
>
>
>I.e, all that's being passed to the hardware is the ID of the
>pre-programmed pipeline, because that programming is going to be
>out-of-band via devlink anyway.
>
>In which case, you could just as well replace the above:
>
>sw_pipeline_id = `tc p4template create ...` (etc, this is generated by P4C)
>
>with
>
>sw_pipeline_id = bpf_prog_load(BPF_PROG_TYPE_P4TC, "my_obj_file.o"); /* my_obj_file is created by P4c */
>
>and achieve exactly the same.
>
>Having all the P4 data types and concepts exist inside the kernel
>*might* make sense if the kernel could then translate those into the
>hardware representations and manage their lifecycle in a uniform way.
>But as far as I can tell from the slides and what you've been saying in
>this thread that's not going to be possible anyway, so why do you need
>anything more granular than the pipeline ID?
>
>-Toke
>
