Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C20E696AD0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjBNRIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjBNRIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:08:13 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CEC422E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:07:51 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id k3so8751503wrv.5
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:subject:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nRlRdTQfxmrCL8TNuOaNFRciO4d+cYngX0tK5MgiGhM=;
        b=R1tx1c8KBoNkxTUIJZu6bFEXeqou7WlFVKcrUFFTlEZx94PqtQoF1Z6bYQQyqJGwym
         iL2G/zU3aPshsk39ABQwzQuNkxGETXMZmhJUfpbkbZ7yTpjYDtKzvLCqCtaUluMsztY+
         St2J09k3NKLtnaW6zqi37f1esTA5+Sw5uXlIwIHHAj8GLOf7dnJStdmltqPMYCIDjfPY
         vRASQk/Tin5WM4GEXwzjHEJo6K3nR7TKOuUPPBiEBgSt+9V5dTmTkFvWNd5KD/VZdB0A
         71v+IjqYavkpr1VgsxxiJykJY+PeIhjWZGRojoN5Sx4G95JZhBc9gYmtroCIla1oJqT2
         hc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:subject:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRlRdTQfxmrCL8TNuOaNFRciO4d+cYngX0tK5MgiGhM=;
        b=aOC0l6J7EoRqShWA5i5FNVCif6HGkclsiyfRNiKR3AHcure8L/cVM1FQKyGTnX7HOQ
         8jTjrfHtP7yjgaYy8ExvTBRAxR2NFlyEJ+TCvUtymsB+s+5J2SZXKpYmD9arO4B8Cky+
         oHb+irmeKzET55GcZ45/j0vmpA3sn5nf0+mB1VJsUCcsqwbINGKcU1Fchv893nG3qCd8
         4BhIl4VER3axC+NsFeXcS2TxDlbv7PeGJPoQmCd030mF3pZ15y4H2duJzIgja8cLQq5O
         ESPtDWwHk+fEcbpWTfzb4M3gbumKrkeCBYvbYmWn4Rp3ZHCY9c4RP3YVznbJbODl1pRG
         IN3Q==
X-Gm-Message-State: AO0yUKUb/+GazmZv5UqCOzHX4ZwkisIcDoI4hB/XfavMkZ8O7OGtlpSC
        CLxmbiiYm/p/a32scSRlv6I=
X-Google-Smtp-Source: AK7set/4lL1ALlvdxyoMOqdwdFp6F7GSKbKoVqBfzyhG2bhya/sXxCgV+HLjhmpupxAzx7ZzsK/NFg==
X-Received: by 2002:a5d:4a0f:0:b0:2c5:51d7:f821 with SMTP id m15-20020a5d4a0f000000b002c551d7f821mr2769928wrq.61.1676394468978;
        Tue, 14 Feb 2023 09:07:48 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id v18-20020a05600c445200b003de77597f16sm19519008wmn.21.2023.02.14.09.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:07:48 -0800 (PST)
From:   Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
Message-ID: <b7dafeb9-4535-9fa6-fb42-d6538b7ecf10@gmail.com>
Date:   Tue, 14 Feb 2023 17:07:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/01/2023 14:06, Jamal Hadi Salim wrote:
> So what are we trying to achieve with P4TC? John, I could have done a
> better job in describing the goals in the cover letter:
> We are going for MAT sw equivalence to what is in hardware. A two-fer
> that is already provided by the existing TC infrastructure.
...
> This hammer already meets our goals.

I'd like to give a perspective from the AMD/Xilinx/Solarflare SmartNIC
 project.  Though I must stress I'm not speaking for that organisation,
 and I wasn't the one writing the P4 code; these are just my personal
 observations based on the view I had from within the project team.
We used P4 in the SN1022's datapath, but encountered a number of
 limitations that prevented a wholly P4-based implementation, in spite
 of the hardware being MAT/CAM flavoured.  Overall I would say that P4
 was not a great fit for the problem space; it was usually possible to
 get it to do what we wanted but only by bending it in unnatural ways.
 (The advantage was, of course, the strong toolchain for compiling it
 into optimised logic on the FPGA; writing the whole thing by hand in
 RTL would have taken far more effort.)
Developing a worthwhile P4-based datapath proved to be something of an
 engineer-time sink; compilation and verification weren't quick, and
 just because your P4 works in a software model doesn't necessarily
 mean it will perform well in hardware.
Thus P4 is, in my personal opinion, a poor choice for end-user/runtime
 behaviour specification, at least for FPGA-flavoured devices.  It
 works okay for a multi-month product development project, is just
 about viable for implementing something like a pipeline plugin, but
 treating it as a fully flexible software-defined datapath is not
 something that will fly.

> I would argue further that in
> the near future a lot of the stuff including transport will eventually
> have to partially or fully move to hardware (see the HOMA keynote for
> a sample space[0]).

I think HOMA is very interesting and I agree hardware doing something
 like it will eventually be needed.  But as you admit, P4TC doesn't
 address that — unsurprising, since the kind of dynamic imperative
 behaviour involved is totally outside P4's wheelhouse.  So maybe I'm
 missing your point here but I don't see why you bring it up.

Ultimately I think trying to expose the underlying hardware as a P4
 platform is the wrong abstraction layer to provide to userspace.
It's trying too hard to avoid protocol ossification, by requiring the
 entire pipeline to be user-definable at a bit level, but in the real
 world if someone wants to deploy a new low-level protocol they'll be
 better off upgrading their kernel and drivers to offload the new
 protocol-specific *feature* onto protocol-agnostic *hardware* than
 trying to develop and validate a P4 pipeline.
It is only protocol ossification in *hardware* that is a problem for
 this kind of thing (not to be confused with the ossification problem
 on a network where you can't use new proto because a middlebox
 somewhere in the path barfs on it); protocol-specific SW APIs are
 only a problem if they result in vendors designing ossified hardware
 (to implement exactly those APIs and nothing else), which hopefully
 we've all learned not to do by now.

On 30/01/2023 03:09, Singhai, Anjali wrote:
> There is also argument that is being made about using ebpf for
> implementing the SW path, may be I am missing the part as to how do
> you offload if not to another general purpose core even if it is not
> as evolved as the current day Xeon's.

I have to be a little circumspect here as I don't know how much we've
 made public, but there are good prospects for FPGA offloads of eBPF
 with high performance.  The instructions can be transformed into a
 pipeline of logic blocks which look nothing like a Von Neumann
 architecture, so can get much better perf/area and perf/power than an
 array of general-purpose cores.
My personal belief (which I don't, alas, have hard data to back up) is
 that this approach will also outperform the 'array of specialised
 packet-processor cores' that many NPU/DPU products are using.

In the situations where you do need a custom datapath (which often
 involve the kind of dynamic behaviour that's not P4-friendly), eBPF
 is, I would say, far superior to P4 as an IR.

-ed
