Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ACC2CC303
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgLBRFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbgLBRFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:05:24 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2182CC0617A7
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 09:04:44 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id f11so1872154qth.23
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 09:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=fhMyhnnNKEJ49XIgzEQBRBGObFetYBnzrC8zuUBillQ=;
        b=mCFGoaqy0YtGQpgCyBFLhVshQDjMsEZyqbtMmywjZSDzevQhZaSBiE54QbOBPcUDE5
         tcnirweVwezwz1SrbeoMHQd63MJpmOBkTN2WZFU9rvxHM5C40XZi+tS/ThYzdm2Vx24A
         TQKh3X8wSg49sNhc/MGwpCu1B3EmotJcbBgTrjoLgfi5QwX1OMYD82Ua9pbbsNoL+Rbr
         36myGDRRugLmX2MU8PedLDKjTBMrawWGKEx2tGkemiNBOkhKA/lkRI1JNxthUS8AaATE
         4xA0CMymFQwldECukh4Lyh0bgebOoQg4GNVmiYip7tA1ugZfwu3KAfUANqPOOhRHWs2i
         cNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fhMyhnnNKEJ49XIgzEQBRBGObFetYBnzrC8zuUBillQ=;
        b=lj0pnt1hPVDTELuWGhDmiXYx0J8YSb8vS/hvBqsIXFpHWfT+WG+o8rxCQifsqbuj9E
         E7JbOYS52n1sDKSMfuILvrG2EaWo6s2IDkXFvkOrIjxBqLt5+b90L3ZXUGZeXroZKt7D
         VW9XH9IUgNitqeSxbdEwLqGR4lMt0OXtVUHrgb71IY0CojfxwmS+aq0jpUQ8BjEWgHqG
         W2tS22mKICMUWNOCQpjQ42OaueV5VycZLCn07DvSfukiZ6IoXxTSYiRXy2ENoMdnC0mK
         xbtiAfleIQ881LwvO4EJmRgqCf6IEyo4hEaxCA6MfoKZEfvEPkU2+qXCNJ1Xl114q7PV
         k0mA==
X-Gm-Message-State: AOAM532Ibt/ORNj5YekwwSsAPbJufFA1IWM2l9SK4mzYMkA5JcyJRYK8
        9nNudNTr4plOtSzuY5v8/SCK9mY=
X-Google-Smtp-Source: ABdhPJzLSsJa6w2KaEmRmS7vrSTVfu0Jl+EREPxUfXxG22VNZzQJpjIAt0yioLN4UIhKTt5W8ipuh3U=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6214:29:: with SMTP id b9mr3748555qvr.18.1606928683263;
 Wed, 02 Dec 2020 09:04:43 -0800 (PST)
Date:   Wed, 2 Dec 2020 09:04:41 -0800
In-Reply-To: <CAEf4BzaQGJCAdbh3CYPK=z1XPBpqbWkXJLgHaEJc+O7R5dt9vw@mail.gmail.com>
Message-Id: <20201202170441.GC553169@google.com>
Mime-Version: 1.0
References: <20201118001742.85005-1-sdf@google.com> <20201118001742.85005-2-sdf@google.com>
 <CAEf4BzaQGJCAdbh3CYPK=z1XPBpqbWkXJLgHaEJc+O7R5dt9vw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: rewrite test_sock_addr bind
 bpf into C
From:   sdf@google.com
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/01, Andrii Nakryiko wrote:
> On Tue, Nov 17, 2020 at 4:20 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > I'm planning to extend it in the next patches. It's much easier to
> > work with C than BPF assembly.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---

> With nits below:

> Acked-by: Andrii Nakryiko <andrii@kernel.org>
Thank you for the review! Will respin shortly with the nits addressed.
