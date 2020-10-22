Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F1B2963D5
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900769AbgJVRit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2900746AbgJVRir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 13:38:47 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87D3C0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:38:47 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id h5so1358673vsp.3
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eYefmRwbgqJTol4WaDtjkEqyLGdHQWBQtu/EopsoHeo=;
        b=J1Ggp5kogdjocTvKsil9ZgAv8W03dUb6ltL2nhHuKEbeZiumhOY6sDqH4XlUjSMNVA
         2UKWzb1j1CYBF7BCaF1VjFl+VGVxOuecK8VJBTAgNirn/mEyexrUcYwQ6apjQB87i2GL
         Ipm4O2hQ9juQ3PnokpAupVsl1PfE4LAipjOmdQFOW++8v+A+RvMY9Cj80DO0oIwCHLHS
         +rBnHhj/vvFB9Jykrb9EEHqXglmAQko3W/q60E0czLo4HmWkjsXqA2zvTSRWpjiVCrWR
         k1gS+XJzS0Q117Qcn1lMMdGEPa3i+UZjU+2Pc6GAHf4gQK1YjveKQYF3/UjadjJPfm/z
         rgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eYefmRwbgqJTol4WaDtjkEqyLGdHQWBQtu/EopsoHeo=;
        b=tz/qEg663WRzHMKJB7VTiDjwT1mEN08TdbL0D8XKovZ+ZnzrnoOD1/4FUgSXmWUtlx
         SYuxSWua0ip3ND2ns6hZkKsZR1GHEo0Wn9V9re8u7Eg7JfaEppEtKEp4xxVwPANybEBC
         lRrSn83HjpVW78QUyKEjMb6X4rCzfoUEn/E4FWHnOJwe4UaeSXaAzacjevPdf82Qy/xv
         XzSxVnr2ByINlQ6FbksprhNOzR3tFb8A5d7TfazKPOf+1RI2vWt4/9KKgDhogFehLKep
         JkNecp0s7KP7Kgh8RoIa1tDqgzcyF6qqFNfPoDh+FIZNJI7XyPKQw7//2fvCDN5daKyi
         tntw==
X-Gm-Message-State: AOAM532jhOjzzSShnJYsApVb3STjaxnrVgCuLkdPZJ29YYsMQp7rI1lN
        NwDQT/ZJPJ+prZS18sqXWoJLyUTcMdo=
X-Google-Smtp-Source: ABdhPJwWkyfNDjvEU96pAYjzm1y8QDo1Hnd7Y+PsaIFEiAMhv/nSdIuYtIQA3oOLyx5H7u0Vq/tt/A==
X-Received: by 2002:a05:6102:2266:: with SMTP id v6mr3044198vsd.0.1603388325407;
        Thu, 22 Oct 2020 10:38:45 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id y186sm321696vky.46.2020.10.22.10.38.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 10:38:44 -0700 (PDT)
Received: by mail-vs1-f44.google.com with SMTP id p25so1357946vsq.4
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:38:43 -0700 (PDT)
X-Received: by 2002:a67:fb96:: with SMTP id n22mr2983559vsr.13.1603388323259;
 Thu, 22 Oct 2020 10:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
In-Reply-To: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 22 Oct 2020 13:38:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdjL4bFYHXyH8dv2x-ZEQZSuA7R8ecttzdZMRwyPEF-=A@mail.gmail.com>
Message-ID: <CA+FuTSdjL4bFYHXyH8dv2x-ZEQZSuA7R8ecttzdZMRwyPEF-=A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] sock: Fix sock queue mapping to include device
To:     Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Herbert <tom@herbertland.com>, carolyn.wyborny@intel.com,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        amritha.nambiar@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 3:51 PM Harshitha Ramamurthy
<harshitha.ramamurthy@intel.com> wrote:
>
> In XPS, the transmit queue selected for a packet is saved in the associated
> sock for the packet and is then used to avoid recalculating the queue
> on subsequent sends. The problem is that the corresponding device is not
> also recorded so that when the queue mapping is referenced it may
> correspond to a different device than the sending one, resulting in an
> incorrect queue being used for transmit. Particularly with xps_rxqs, this
> can lead to non-deterministic behaviour as illustrated below.
>
> Consider a case where xps_rxqs is configured and there is a difference
> in number of Tx and Rx queues. Suppose we have 2 devices A and B. Device A
> has 0-7 queues and device B has 0-15 queues. Packets are transmitted from
> Device A but packets are received on B. For packets received on queue 0-7
> of Device B, xps_rxqs will be applied for reply packets to transmit on
> Device A's queues 0-7. However, when packets are received on queues
> 8-15 of Device B, normal XPS is used to reply packets when transmitting
> from Device A. This leads to non-deterministic behaviour. The case where
> there are fewer receive queues is even more insidious. Consider Device
> A, the trasmitting device has queues 0-15 and Device B, the receiver
> has queues 0-7. With xps_rxqs enabled, the packets will be received only
> on queues 0-7 of Device B, but sent only on 0-7 queues of Device A
> thereby causing a load imbalance.

So the issue is limited to xps_rxqs with multiple nics.

When do we need sk_tx_dev_and_queue_mapping (patch 3/3)? It is used in
netdev_pick_tx, but associations are reset on route change and
recomputed if queue_index would exceed the current device queue count.

> This patch set fixes the issue by recording both the device (via
> ifindex) and the queue in the sock mapping. The pair is set and
> retrieved atomically.

I guess this is the reason for the somewhat convoluted cast to u64
logic in patch 1/3. Is the assumption that 64-bit loads and stores are
atomic on all platforms? That is not correct.

Is atomicity even needed? For the purpose of load balancing it isn't.
Just adding a sk->rx_ifindex would be a lot simpler.

sk->sk_napi_id already uniquely identifies the device. Unfortunately,
dev_get_by_napi_id is not cheap (traverses a hashtable bucket). Though
purely for the purpose of load balancing this validation could be
sample based.

The rx ifindex is also already recorded for inet sockets in
rx_dst_ifindex, and the sk_rx_queue_get functions are limited to
those, so could conceivably use that. But it is derived from skb_iif,
which is overwritten with every reentry of __netif_receive_skb_core.
