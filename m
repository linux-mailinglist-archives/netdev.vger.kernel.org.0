Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EF367FE72
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 12:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjA2LL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 06:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjA2LL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 06:11:57 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B86A1BAF0
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 03:11:56 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-50660e2d2ffso125167437b3.1
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 03:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jDPlFKJbJQ4LwPabgS/syG/2kHqRejH4qRCAmYatKHs=;
        b=0V4hKqTGDQ8IEztojBUlgo3jiBoL8eUXJ3Cm4u9ethDhxYcfNjYr+q33GTZydpFB36
         +P6dYi9W88jpD6OdQHFYqw6PPlnEok/Trrt5Jb9v1vB8ovbNFVUCffyTzGI4ZYcN9pax
         e5JiDjZMiBonrx8XoU0imY33a18gT7eiijv2ev9QEddoLlivUz3ELhEkf4PNobLSNlwJ
         dTD12yQ1RGLCy6Z4jJLYtCGDCnYnZP/4/7SbkXZjuhZv8r6T1JSafKEs5PY7i1i6vplF
         PBduTkZkz0Swx9waLYPpL4O/LQhuXObGhkQ/U8BAEc1cBh29Q7UKGQNTd0nRv4ToJ3Zj
         vQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jDPlFKJbJQ4LwPabgS/syG/2kHqRejH4qRCAmYatKHs=;
        b=oIjCi0AVB1/LprWFuXcmfpaQ3gHgREYUp0tvbTGWqFu6lz0cboxF1PIBTXKMnHY0er
         OsaJkFYH52r4K0Aio1MgH8zIE9nSxYYwkUo9iNKWbLVSKLL3K8d/clHENrVc/6OWN7ZA
         PGkPW9sf0GmKSuvrKjUlM/po2tOQqhLb2OpCWw6KSa3rTibm0MAIh17Mmn9iK+bYF1B9
         b3csuLt2vx12SxvhB3jujx/SJnHmM5L+XEoSkCo+R93HxAYXMZ3Q1vH+XoW0aGiuE+pP
         DKEEKaM8LlYcul+V1pf30ZwZNltmUP/QNUuRL2c4zXh1w5ph8C1R4WNZz1InWrNDD0Bp
         uoOQ==
X-Gm-Message-State: AFqh2kpUSy3HBCoq58+Ajwe4ir/ciP3JRjlQP1KnwkyaA73uzluUcdB2
        oBJCkEYZpzerhiY5vOq1gBRsdVlm/1fguCtHCnQqsA==
X-Google-Smtp-Source: AMrXdXv6OT3GJJSwIOueHiSO9ae8hbSDUovhyv3mnich1SxczH1Vr3c6IJxFDfvDsyb/y/cabYMgeamOPxB5eMlkPOI=
X-Received: by 2002:a81:5a86:0:b0:4dd:4477:47b6 with SMTP id
 o128-20020a815a86000000b004dd447747b6mr5370519ywb.395.1674990715496; Sun, 29
 Jan 2023 03:11:55 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com> <63d6069f31bab_2c3eb20844@john.notmuch>
In-Reply-To: <63d6069f31bab_2c3eb20844@john.notmuch>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 29 Jan 2023 06:11:43 -0500
Message-ID: <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
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

On Sun, Jan 29, 2023 at 12:39 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Willem de Bruijn wrote:
> > On Sat, Jan 28, 2023 at 10:10 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > >
>
> [...]
>
>
> Also there already exists a P4 backend that targets BPF.
>
>  https://github.com/p4lang/p4c

There's also one based on rust - does that mean we should rewrite our
code in rust?
Joking aside - rust was a suggestion made at a talk i did. I ended up
adding a slide for the next talk which read:

Title: So... how is this better than KDE?
  Attributed to Rusty Russell
     Who attributes it to Cort Dougan
      s/KDE/[rust/ebpf/dpdk/vpp/ovs]/g

We have very specific goals - of which the most important is met by
what works today and we are reusing that.

cheers,
jamal

> So as a SW object we can just do the P4 compilation step in user
> space and run it in BPF as suggested. Then for hw offload we really
> would need to see some hardware to have any concrete ideas on how
> to make it work.
>


> Also P4 defines a runtime API so would be good to see how all that
> works with any proposed offload.
