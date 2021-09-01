Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64EB3FD32F
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 07:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbhIAFqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 01:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhIAFqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 01:46:42 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66A2C061575;
        Tue, 31 Aug 2021 22:45:45 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id b7so2573264iob.4;
        Tue, 31 Aug 2021 22:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=V5iDUUigs59ZSwSYLJTSBXiR4YJVQbRTp8G58bosNms=;
        b=FglNKUnE9FZtnjQxZ17b3L/fmM/CTP9Vs0T7nmUTZ1Ve/7o8+cGeqXviDoTpUMEuOo
         1ZghtDGjhcuIhZd0znq5g8hpjSQgZr3RJBNpc3KlKVStzbm8eVQN1bwHx+o4KRfMf2ED
         3QQG2/7HkmspR6+x4Gz1PFHhYgmaBfdtgxdw13xGVBhHPaCsk7paRpgfZmNb5NTJ0Akn
         PeGGsWT3Zi51/LvThPTY427P7+ov8HFbqm4I5QWg4seqqdVYWOReJ5AUH6GgyWSjPk5U
         s0UkRVmmeFHWtS95pUW2OYWp5QZQ+yTB53+lytX7UxU1Azohf+0c+fvcVcvs0eubee95
         ltyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=V5iDUUigs59ZSwSYLJTSBXiR4YJVQbRTp8G58bosNms=;
        b=mgwgMYgUJ6DzQgribvMq0rZuFTLYhyPJ4xzVCH9NjSBXJgN+EfMdVAoLomCPy70mNH
         ziRr6eoAu8hU4rIfMOJ1DhIQ5E8BZxjBEFtyC1OH/fwwGKj9d6JX7LhTihLWb5lH9RDw
         SJaIsiaaysW3UhMz9zmOvEWnpXi8a5leT+ksojOgWeJKgyhkxkHt6VeYQG2eL0jIfTiR
         jIEIpUEBfjXEnYgXap3GE+rhBIWPCebtc2x3a803Jx1O78dYY5X+THQ0fZHyVrpZPqYd
         Q+todPPUld0cNlwHk+tQVUi7z1/17t0+/LPig8R935vHFH4HhGUL9oVsqm0yPaOf4AJd
         nnig==
X-Gm-Message-State: AOAM5309POC9Vo+NDNxlrQI+3xTmgdLxkEWJgGuqK2yUSWB6VHAzYFaa
        WOy7bX/kz3eaRqkIdPFhkeIL+8VRL+E=
X-Google-Smtp-Source: ABdhPJwwcNwVMrb4vyUJQumEKmw1MYR2GDOMY0VG+JP7U4+RMtmZ2+bHaEnTEoy4TGThOZ0swKDHUA==
X-Received: by 2002:a02:cacd:: with SMTP id f13mr6376401jap.94.1630475145345;
        Tue, 31 Aug 2021 22:45:45 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id s5sm11014315iol.33.2021.08.31.22.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 22:45:44 -0700 (PDT)
Date:   Tue, 31 Aug 2021 22:45:35 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Message-ID: <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > Please explain more on this.  What is currently missing
> > to make qdisc in struct_ops possible?
> 
> I think you misunderstand this point. The reason why I avoid it is
> _not_ anything is missing, quite oppositely, it is because it requires
> a lot of work to implement a Qdisc with struct_ops approach, literally
> all those struct Qdisc_ops (not to mention struct Qdisc_class_ops).
> WIth current approach, programmers only need to implement two
> eBPF programs (enqueue and dequeue).
> 
> Thanks.

Another idea. Rather than work with qdisc objects which creates all
these issues with how to work with existing interfaces, filters, etc.
Why not create an sk_buff map? Then this can be used from the existing
egress/ingress hooks independent of the actual qdisc being used.

You mention skb should not be exposed to userspace? Why? Whats the
reason for this? Anyways we can make kernel only maps if we want or
scrub the data before passing it to userspace. We do this already in
some cases.

IMO it seems cleaner and more general to allow sk_buffs
to be stored in maps and pulled back out later for enqueue/dequeue.

I think one trick might be how to trigger the dequeue event on
transition from stopped to running net_device or other events like
this, but that could be solved with another program attached to
those events to kick the dequeue logic.

.John
