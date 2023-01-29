Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6047967FE62
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 12:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjA2LCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 06:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjA2LCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 06:02:44 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15814219
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 03:02:42 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id u72so10936563ybi.7
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 03:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mRlWaepKdbSr/rcK2kFHMbNHeWR6E+5VlCai0ss0txE=;
        b=YwGxAZ/KpgypRIvYbpQVP91IQwtaKQPEywNFiQTSFvXpjEEBX4f5HIBBB41+IiuHmF
         m1Gyg3daonZWYo2Pnkn2+Wwty24mY40kEi2UANO4nXphWR0UOhhnUwcqHvtZ+CxhFMUU
         +HgLqze41VOkMgmQIrrrgSDAPbY3Ksur3/RsFWztlIGW/1CT0SRwQMUv/Plzh9AoykKf
         EPZR+evzL6AAO3A2g6ceEA6Y1XUqQIHWSVWe5ZB2oBYddYXOCYop3eXyKM+O/SS7jz+h
         BTFJ0M92If98H6f0fSjsI2m3FFBqRFfM2P4AbP6d2aK0oOOYyMDOhsNj8lFYJOAFWAmR
         XTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mRlWaepKdbSr/rcK2kFHMbNHeWR6E+5VlCai0ss0txE=;
        b=QkRKe/YocCIadZ0ofPu/MpPtSOaKloFsd5kVm17SdpklOM/vhVUyYT8ds+uCEDeno6
         2v4CoYWlbKlpPYYpYkz2EMAzWCai2eNu6cdldLfm6q2UhYwgxV5cPUvMhGKWLiscQsNg
         P7t9Fvtd6A0nECbNJa+crYdquF6yHarYzruKNZrMBl9jIv2rkLncju2pHlJ973ntONy3
         zzQPvKuvfOvya3XnS3Yej+Q+C5cRrp7Lx2LrcYuFs4dYHd/5t2FfmCdc1z4Btcx6ZzO5
         d7q58iac6XEoaFsz8W1GNApeHdhIiJTnSKJupWlJGEJG05q/YjnCNZqp418PuG/LsUuP
         dvyA==
X-Gm-Message-State: AO0yUKVnTL2h2MqKmZ8XSNNebQeUgGyKwIYBCnUqr2dlD2YQYDV9mIiS
        J/PR7GIEMAs6dBzBT6GhsOZ12Py1aZBZUaIfxSR01A==
X-Google-Smtp-Source: AK7set/c9ZyDsD8gk2W5PQLv35qKMfY75Fu9k82HHUqd3bhLJewyblJLDZlpS8Wjtps4kzVGPW/KMD2WkFiqBBWNIwA=
X-Received: by 2002:a25:ab24:0:b0:80b:8fbc:7e68 with SMTP id
 u33-20020a25ab24000000b0080b8fbc7e68mr2323262ybi.517.1674990161953; Sun, 29
 Jan 2023 03:02:41 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com> <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
In-Reply-To: <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 29 Jan 2023 06:02:30 -0500
Message-ID: <CAM0EoMmMd9SSxCV8p5WfmOnGqF+bOrOAOdAw9JGMC-=70Y8qzA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Willem de Bruijn <willemb@google.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 28, 2023 at 10:33 AM Willem de Bruijn <willemb@google.com> wrote:
>
> On Sat, Jan 28, 2023 at 10:10 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > On Sat, Jan 28, 2023 at 8:37 AM Willem de Bruijn <willemb@google.com> wrote:
> > >
>

[..]

> > We use the skip_sw and skip_hw knobs in tc to indicate whether a
> > policy is targeting hw or sw. Not sure if you are familiar with it but its
> > been around (and deployed) for a few years now. So a P4 program
> > policy can target either.
>
> I know. So the only reason the kernel ABI needs to be extended with P4
> objects is to be able to pass the same commands to hardware. The whole
> kernel dataplane could be implemented as a BPF program, correct?
>

It's more than an ABI (although that is important as well).
It is about reuse of the infra which provides a transparent symbiosis
between hardware offload and software that has matured over time: For
example, you can take a pipeline or a table or actions (lately) and
split them between hardware and software transparently, etc. To
re-iterate, we are reusing and plugging into a proven and deployed
mechanism which enables our goal (of HW + SW scripting of arbitrary
P4-enabled datapaths which are functionally equivalent).

> > In regards to the parser - we need a scriptable parser which is offered
> > by kparser in kernel. P4 doesnt describe how to offload the parser
> > just the matches and actions; however, as Tom alluded there's nothing
> > that obstructs us offer the same tc controls to offload the parser or pieces
> > of it.
>
> And this is the only reason that the parser needs to be in the kernel.
> Because the API is at the kernel ABI level. If the P4 program is compiled
> to BPF in userspace, then the parser would be compiled in userspace
> too. A preferable option, as it would not require adding yet another
> parser in C in the kernel.
>

Kparser while based on PANDA has the important detail to note is that it is an
infra for creating arbitrary parsers. The infra sits in the kernel and
i can create
arbitrary parsers with policy scripts. The emphasis is on scriptability.

cheers,
jamal

> I understand the value of PANDA as a high level declarative language
> to describe network protocols. I'm just trying to get more explicit
> why compilation from PANDA to BPF is not sufficient for your use-case.
>
