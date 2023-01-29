Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C667FCE1
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 06:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjA2Fju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 00:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjA2Fjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 00:39:49 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E06212B5
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 21:39:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso8292391pjb.4
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 21:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGyrATRUvU9GIvlDF6PPZx1G53iP3970w3Da0bMqnRg=;
        b=jVjizETXUG/FBEpiVOUoCAts3tsN0vnd9MskTfWqguSe8OXqR7mittf9Z8Kh7qzIdB
         FEIzlQiolobYqf0mW7urgWUZBrhZLkd40spyuDCdT4QXkcHn7CEhQI5nJ/Sl0I70Km3X
         POMRLRt3cGcKYBJU461JBKIjCG7Nrqn6/7XQFM9uuoAqk5PC8oK5ky5AEG/jz+6cRGV8
         6wNqvv1IADdo5SklrzM7AIhlNVBDeEUbxELapSxMksUPhjtdgu6RbVEEYwGBu8WN1csn
         nYXa26m5GadYISA+cC2AdKu5xjTq00hoDV9hA5svcA8gTDHhkSgxUi5ELo1SqPxPGLy5
         RTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dGyrATRUvU9GIvlDF6PPZx1G53iP3970w3Da0bMqnRg=;
        b=R+BSocymAqYVRBxqpao/ZEXzo7hXRh/yrP6AR5d7iG9AjUPcE9h65TQ0UZKxJgk/6r
         WOO58VG4L9hLRLJ9QBBv3JKxJAkPYmDaj77G8ez9LiWnhCH37v9dQkjUDpQJkV4K7eqP
         q/PWZyjRlp7Iitu8BTHHsja0yAxnBC3FnosH2NwFJBlCm1ZdadP3Lw2f5JjnRfcf3FO+
         bPd6UfOp1BDzUVlNNR+ZEL4Yf/V55xyVREXn+03RLVNzcyVK8ZD4YdPwezO+z5heY73E
         VVd0SCBwhoBTpuJsuGXiE85zs83ex6XsOPxgDBHdsMba5KcAD77JcDyaORoqwJTBulMH
         brxQ==
X-Gm-Message-State: AFqh2kp6g63/bDIrwoWgVOEsznKTRmoey2aQp+4U6/sIBiDMDg/eNui/
        0uPKvQ40gRKfte3As5wfFjA=
X-Google-Smtp-Source: AMrXdXu3frWtzOK60hZz/pg5PTXB3EdvrMTOf6rQWsNRX6woftv+2AzTBUYEeC+rsU1EZMfEvlvyBg==
X-Received: by 2002:a17:903:1211:b0:194:d999:33f0 with SMTP id l17-20020a170903121100b00194d99933f0mr39862412plh.31.1674970787303;
        Sat, 28 Jan 2023 21:39:47 -0800 (PST)
Received: from localhost ([98.97.113.214])
        by smtp.gmail.com with ESMTPSA id z5-20020a1709027e8500b00196251ca124sm5332377pla.75.2023.01.28.21.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 21:39:46 -0800 (PST)
Date:   Sat, 28 Jan 2023 21:39:43 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Willem de Bruijn <willemb@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
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
Message-ID: <63d6069f31bab_2c3eb20844@john.notmuch>
In-Reply-To: <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
References: <20230124170346.316866-1-jhs@mojatatu.com>
 <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho>
 <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn wrote:
> On Sat, Jan 28, 2023 at 10:10 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >

[...]

> > >
> > > I would also think that if we need another programmable component in
> > > the kernel, that this would be based on BPF, and compiled outside the
> > > kernel.
> > >
> > > Is the argument for an explicit TC objects API purely that this API
> > > can be passed through to hardware, as well as implemented in the
> > > kernel directly? Something that would be lost if the datapath is
> > > implement as a single BPF program at the TC hook.
> > >
> >
> > We use the skip_sw and skip_hw knobs in tc to indicate whether a
> > policy is targeting hw or sw. Not sure if you are familiar with it but its
> > been around (and deployed) for a few years now. So a P4 program
> > policy can target either.
> 
> I know. So the only reason the kernel ABI needs to be extended with P4
> objects is to be able to pass the same commands to hardware. The whole
> kernel dataplane could be implemented as a BPF program, correct?
> 
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

Also there already exists a P4 backend that targets BPF.

 https://github.com/p4lang/p4c

So as a SW object we can just do the P4 compilation step in user
space and run it in BPF as suggested. Then for hw offload we really
would need to see some hardware to have any concrete ideas on how
to make it work.

Also P4 defines a runtime API so would be good to see how all that
works with any proposed offload.

> 
> I understand the value of PANDA as a high level declarative language
> to describe network protocols. I'm just trying to get more explicit
> why compilation from PANDA to BPF is not sufficient for your use-case.
> 
> 
> > cheers,
> > jamal
> >
> > > Can you elaborate some more why this needs yet another in-kernel
> > > parser separate from BPF? The flow dissection case is solved fine by
> > > the BPF flow dissector. (I also hope one day the kernel can load a BPF
> > > dissector by default and we avoid the majority of the unsafe C code
> > > entirely.)
> 
