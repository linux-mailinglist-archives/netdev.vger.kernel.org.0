Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E9B3F8CA8
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243092AbhHZREl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 13:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhHZREk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 13:04:40 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEF2C061757;
        Thu, 26 Aug 2021 10:03:53 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso4426459otp.1;
        Thu, 26 Aug 2021 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ji2l8jcg46A/WnhV2rmSUQQQmyR8YuNgsAvBjZZkXgU=;
        b=QqtVOuGeSsoKKLJCbLKp1FoCZnmv7B7IEVxL75h7iagpQfChHsJJPdIsvZQ0VQUhTO
         i+AXhEiULKUOgE3Ez6thnLtbtueW4a6jLu2tRZ5wRxJdpuwLTrxLp6ipoxKVGv4siQEH
         OIF2HrjvUA8nSwn/fhZ/G2v0w12dXo6stZVzNXF0YO9UuzoxyBs/J7NJecoQdtAcCtLJ
         44WwCZEIAtnCjTAM2kq/sx1oQEyzBKC/m8D8EjA//Xv3jUnSwZB6L/f+SNzTqNwd6zM2
         NSYL3KxqmhZcIDOrV/vjSU30MX1ag8eZrim6GkQckXo/QbAHklJie+V6LOT2HpkwJmN9
         MilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ji2l8jcg46A/WnhV2rmSUQQQmyR8YuNgsAvBjZZkXgU=;
        b=beCi4mGUvb7KzsPeDv41cMMUjqJYSTe/UXQfYgBJS+2ZjEEMo2nDLyw+YO+AlAkPzt
         0LqNzrS1NdO5ZR3CceavJ7tweuEGAAVsSg1InAPCahoeLM3dKsBAq4t+GiFl5JbHhyrT
         XTChv+MD80ycVj28jGeXNTl8eSs4cpFy7rQs5E1+Zj+JU8oCGdYVq7GbHzfFsRLDmWz0
         OQyGYPUnmVRiECWezPKqB7ZFNIARD3773c1ATKuFg1GCpE4y078QK7b6lhVtEF3mUomC
         ZiIbmEOqw67ubpgqrPqb4tFDkg75NIhGp2e3x0NivAyl6Qldmwx6EMujv/DpJyUHRr9N
         ocQw==
X-Gm-Message-State: AOAM532O8vQQBI8N0K8Er6wRZK6XeQpGh3VAyBNJ4KkP5yYMf29F/fVB
        toRL67EL+beew8T1tmCC5IiOBS36MtH9SG00l9Y=
X-Google-Smtp-Source: ABdhPJxUZ5DK2PNTHVFThXjoRu1Zj+I/cMuF/0Vdmr0TCRbDvsqhzJ7hx9tXjzYK+C0GFC7ykjVjCyiZRluM/fMzEk4=
X-Received: by 2002:a9d:75d5:: with SMTP id c21mr4084684otl.118.1629997432236;
 Thu, 26 Aug 2021 10:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210826141623.8151-1-kerneljasonxing@gmail.com>
 <00890ff4-3264-337a-19cc-521a6434d1d0@gmail.com> <860ead37-87f4-22fa-e4f3-5cadd0f2c85c@intel.com>
In-Reply-To: <860ead37-87f4-22fa-e4f3-5cadd0f2c85c@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Fri, 27 Aug 2021 01:03:16 +0800
Message-ID: <CAL+tcoCovfAQmN_c43ScmjpO9D54CKP5XFTpx6VQpwJVxZhAdg@mail.gmail.com>
Subject: Re: [PATCH v4] ixgbe: let the xdpdrv work with more than 64 cpus
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 12:41 AM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> On 8/26/2021 9:18 AM, Eric Dumazet wrote:
>
> >> +static inline int ixgbe_determine_xdp_q_idx(int cpu)
> >> +{
> >> +    if (static_key_enabled(&ixgbe_xdp_locking_key))
> >> +            return cpu % IXGBE_MAX_XDP_QS;
> >> +    else
> >> +            return cpu;
> >
> > Even if num_online_cpus() is 8, the returned cpu here could be
> >
> > 0, 32, 64, 96, 128, 161, 197, 224
> >
> > Are we sure this will still be ok ?
>
> I'm not sure about that one myself. Jason?
>
> >
> >> +}
> >> +
> >>  static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
> >>  {
> >>      switch (adapter->hw.mac.type) {
> >> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> >> index 0218f6c..884bf99 100644
> >> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> >> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> >> @@ -299,7 +299,10 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
> >>
> >>  static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
> >>  {
> >> -    return adapter->xdp_prog ? nr_cpu_ids : 0;
> >> +    int queues;
> >> +
> >> +    queues = min_t(int, IXGBE_MAX_XDP_QS, num_online_cpus());
> >
> > num_online_cpus() might change later...
>
> I saw that too, but I wonder if it doesn't matter to the driver. If a
> CPU goes offline or comes online after the driver loads, we will use
> this logic to try to pick an available TX queue. But this is a
> complicated thing that is easy to get wrong, is there a common example
> of how to get it right?
>

Honestly, I'm a little confused right now. @nr_cpu_ids is the fixed
number which means the total number of cpus the machine has.
I think, using @nr_cpu_ids is safe one way or the other regardless of
whether the cpu goes offline or not. What do you think?

> A possible problem I guess is that if the "static_key_enabled" check
> returned false in the past, we would need to update that if the number
> of CPUs changes, do we need a notifier?
>

Things get complicated. If the number decreases down to
@IXGBE_MAX_XDP_QS (which is 64), the notifier could be useful because
we wouldn't need to use the @tx_lock. I'm wondering if we really need
to implement one notifier for this kind of change?

> Also, now that I'm asking it, I dislike the global as it would apply to
> all ixgbe ports and each PF would increment and decrement it
> independently. Showing my ignorance here, but I haven't seen this
> utility in the kernel before in detail. Not sure if this is "OK" from
> multiple device (with the same driver / global namespace) perspective.
>
