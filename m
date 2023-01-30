Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFC96819C9
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbjA3TCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjA3TCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:02:17 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFB93757F
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:02:16 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id z2so4972161ilq.2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MObKdtB/642OvQzP9kbwNH1AL7OjKfokTpZKrJE6x5U=;
        b=wZBg/VSGZmz2qARMnu60hL0eFygjuOyvrnGbqOzTODTB23pXgBj79tMageS3aBJOOp
         wA5yOT+LircpXGwE41K8i+9I2VUY3JPocXunrwy/GuRqGQVpCogCzcm5VBVPSFfxXhD4
         2Q2VXO96M7eQvX3/kIW8plnywERXXAq3x0Ziz+VYYQ29grahpgVD6P7X/aBSPaG7VQw8
         G8sY90FEDEk3eeIBNvFSu0aD4QpUYIVImgzvwyLKP0JCospYn/tT+zV/q1hju+lLFByP
         jxcxOrtkcVSXnNXSPhlFq2+A9ChJS+GMRhDZMSHUejNjb9eB63FSmdUkcFcOCffcSeUW
         T0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MObKdtB/642OvQzP9kbwNH1AL7OjKfokTpZKrJE6x5U=;
        b=4bDS7GJz1bS/xmw+ItN7y5eHMPkJ/1Lw5TN5ySBiqm3NSoZouyzN0rbjrLw2DpwpjI
         jU4h8QBNw1H4Juxa2u0s2FEVTEM9h3jFjAIv3BfluBHzHOTiyNEk7otdYcLcQ5N0f/w1
         oeO1b5a5miaC8p5AbNN5onUIZpc1wNXnjCP8tJCy+KVlCtF38nRbNuiWzCm3CM3Mi22Q
         i3zilbNuRJ26TIznH8CFfqq4Qdqr7jOCygJPa6TFrxjMmOMsu7di5eC6vZp8ZIq14IiV
         VzL1jcv6nrTJF+GY+8XhRzufUlscL8aheS5BXvtrMj2Up5SnKqQP4LminSyRJrUlUF8x
         zJvA==
X-Gm-Message-State: AFqh2kr9YPyOluCT9igRKp/QhNq7q9+5yEFAVw9WKSS6FRdRPx5LGOlp
        0n/YkmQIqF5GX7NpRQ8h4t8/iMBn9Au9ZgC0gb5pMw==
X-Google-Smtp-Source: AMrXdXsQJfSHis9hfCt1tf4xVR4+4iLB+h9FCu30vu+pBTPOZbISQ3uOa5Up7g1OXsVbtRRM1W34bLPBZ7vAPHjSQJg=
X-Received: by 2002:a92:3646:0:b0:30e:f629:7db8 with SMTP id
 d6-20020a923646000000b0030ef6297db8mr6152909ilf.3.1675105335861; Mon, 30 Jan
 2023 11:02:15 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
In-Reply-To: <878rhkx8bd.fsf@toke.dk>
From:   Jamal Hadi Salim <hadi@mojatatu.com>
Date:   Mon, 30 Jan 2023 14:02:04 -0500
Message-ID: <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 12:04 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>
> > So i dont have to respond to each email individually, I will respond
> > here in no particular order. First let me provide some context, if
> > that was already clear please skip it. Hopefully providing the context
> > will help us to focus otherwise that bikeshed's color and shape will
> > take forever to settle on.
> >
> > __Context__
> >
> > I hope we all agree that when you have 2x100G NIC (and i have seen
> > people asking for 2x800G NICs) no XDP or DPDK is going to save you. To
> > visualize: one 25G port is 35Mpps unidirectional. So "software stack"
> > is not the answer. You need to offload.
>
> I'm not disputing the need to offload, and I'm personally delighted that
> P4 is breaking open the vendor black boxes to provide a standardised
> interface for this.
>
> However, while it's true that software can't keep up at the high end,
> not everything runs at the high end, and today's high end is tomorrow's
> mid end, in which XDP can very much play a role. So being able to move
> smoothly between the two, and even implement functions that split
> processing between them, is an essential feature of a programmable
> networking path in Linux. Which is why I'm objecting to implementing the
> P4 bits as something that's hanging off the side of the stack in its own
> thing and is not integrated with the rest of the stack. You were touting
> this as a feature ("being self-contained"). I consider it a bug.
>
> > Scriptability is not a new idea in TC (see u32 and pedit and others in
> > TC).
>
> u32 is notoriously hard to use. The others are neat, but obviously
> limited to particular use cases.

Despite my love for u32, I admit its user interface is cryptic. I just
wanted to point out to existing samples of scriptable and offloadable
TC objects.

> Do you actually expect anyone to use P4
> by manually entering TC commands to build a pipeline? I really find that
> hard to believe...

You dont have to manually hand code anything - its the compilers job.
But of course for simple P4 programs, yes i think you can handcode
something if you understand the templating syntax.

> > IOW, we are reusing and plugging into a proven and deployed mechanism
> > with a built-in policy driven, transparent symbiosis between hardware
> > offload and software that has matured over time. You can take a
> > pipeline or a table or actions and split them between hardware and
> > software transparently, etc.
>
> That's a control plane feature though, it's not an argument for adding
> another interpreter to the kernel.

I am not sure what you mean by control, but what i described is kernel buil=
t in.
Of course i could do more complex things from user space (if that is
what you mean as control).

> > This hammer already meets our goals.
>
> That 60k+ line patch submission of yours says otherwise...

This is pretty much covered in the cover letter and a few responses in
the thread since.

> > It's about using the appropriate tool for the right problem. We are
> > not going to rewrite that infra in rust or ebpf just because.
>
> "The right tool for the job" also means something that integrates well
> with the wider ecosystem. For better or worse, in the kernel that
> ecosystem (of datapath programmability) is BPF-based. Dismissing request
> to integrate with that as, essentially, empty fanboyism, comes across as
> incredibly arrogant.
> > Toke, I labelled that one option as IMpossible as a parody - it is
> > what the vendors are saying today and my play on words is "even
> > impossible says IM possible".
>
> Side note: I think it would be helpful if you dropped all the sarcasm
> and snide remarks when communicating this stuff in writing, especially
> to a new audience. It just confuses things, and doesn't exactly help
> with the perception of arrogance either...

I apologize if i offended you - you quoted a slide i did and I was
describing what that slide was supposed to relay.

cheers,
jamal

> -Toke
>
