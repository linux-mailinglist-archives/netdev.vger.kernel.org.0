Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC763375252
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 12:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhEFKas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 06:30:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231839AbhEFKar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 06:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620296989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=48mMAlWqAlDpvr6IGBZlhqtlJjFXukDl8kbwsgyRNtU=;
        b=WJ6wCrUFGMH4srOus5DjdnMRq7LgSut171Jq653WSCwLjuN44xLWCb3ISbULJkjOrFC14u
        QMIhlEvqp5a4y/2jD95eYjvlP70t8aUL23mlzt0TL/WOLlnl2IUxYVpAkxQZb2JHseGENt
        XkEaxnyT3q2Dlfm0GREZGTDZ4d9I6Y4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-1GHZQjKcPCGk44yJRRirbA-1; Thu, 06 May 2021 06:29:43 -0400
X-MC-Unique: 1GHZQjKcPCGk44yJRRirbA-1
Received: by mail-ej1-f72.google.com with SMTP id p25-20020a1709061419b0290378364a6464so1514727ejc.15
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 03:29:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=48mMAlWqAlDpvr6IGBZlhqtlJjFXukDl8kbwsgyRNtU=;
        b=e6ZzIf9zXWuy+B6aNmNScCegbH/b3hfmWlo1jtd27BY939fjTDiM9iPJi0hKHu6puG
         qU69z5TdAUtoI7TflL2Zx1g9KXLK4J+DPrUVyECj8qPg2yQTEEbPmlbb62Lps1dutc/K
         hvJu1iRKaC91W/U74O0OZj80Z2kZe7I/wuoZs6ir3zZrxaTo/iwBBGLcm2uqA1PQedzp
         6L2L/fSR1bM0c+MvXwnZzCu+Q7z+apNzM+s4aV5kRW3hNR+F21tJ1tyEfSgSYkpj3x6R
         gl+4/vBtVMf1GSlhw6G+A4uVL0EGza/+Micu+DX/ECCNY59Sa5ennbw3DegH1nHl65Do
         DkSw==
X-Gm-Message-State: AOAM532vrVUlFX6bhqjCz/2upmnqM2dFDOR/U9vh8gnh7Ez+D3m3XmIa
        4EwgMp1t/cnVOU5ofedLa6dTZ9SnusBt3c2AUMjbA794dXf7WxoPG6zwI/IrRYIxY56nSW2pZf2
        UfUigEwHz1w+k0ZwT
X-Received: by 2002:a50:ab1d:: with SMTP id s29mr4160660edc.203.1620296981990;
        Thu, 06 May 2021 03:29:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6fVlItbLAqyrXNap4QiGr3AMUkLTOAb30KXyqVk5LCBDr4V+bO/xFJ5uDxxezLDoSTpgf7A==
X-Received: by 2002:a50:ab1d:: with SMTP id s29mr4160616edc.203.1620296981541;
        Thu, 06 May 2021 03:29:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t9sm1324407edf.70.2021.05.06.03.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 03:29:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4C448180707; Thu,  6 May 2021 12:29:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Zvi Effron <zeffron@riotgames.com>,
        T K Sourabh <sourabhtk37@gmail.com>,
        Xdp <xdp-newbies@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, kuba@kernel.org
Subject: Re: Dropped packets mapping IRQs for adjusted queue counts on i40e
In-Reply-To: <20210505212157.GA63266@ranger.igk.intel.com>
References: <CAC1LvL1NHj6n+RNYRmja2YDhkcCwREuhjaBz_k255rU1jdO8Sw@mail.gmail.com>
 <CADS2XXpjasmJKP__oHsrvv3EG8n-FjB6sqHwgQfh7QgeJ8GrrQ@mail.gmail.com>
 <CAC1LvL2Q=s8pmwKAh2615fsTFEETKp96jpoLJS+75=0ztwuLFQ@mail.gmail.com>
 <CADS2XXptoyPTBObKgp3gcRZnWzoVyZrC26tDpLWhC9YrGMSefw@mail.gmail.com>
 <CAC1LvL2zmO1ntKeAoUMkJSarJBgxNhnTva3Di4047MTKqo8rPA@mail.gmail.com>
 <CAC1LvL1Kd-TCuPk0BEQyGvEiLzgUqkZHOKQNOUnxXSY6NjFMmw@mail.gmail.com>
 <20210505130128.00006720@intel.com>
 <20210505212157.GA63266@ranger.igk.intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 06 May 2021 12:29:40 +0200
Message-ID: <87fsz0w3xn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Wed, May 05, 2021 at 01:01:28PM -0700, Jesse Brandeburg wrote:
>> Zvi Effron wrote:
>> 
>> > On Tue, May 4, 2021 at 4:07 PM Zvi Effron <zeffron@riotgames.com> wrote:
>> > > I'm suspecting it's something with how XDP_REDIRECT is implemented in
>> > > the i40e driver, but I don't know if this is a) cross driver behavior,
>> > > b) expected behavior, or c) a bug.
>> > I think I've found the issue, and it appears to be specific to i40e
>> > (and maybe other drivers, too, but not XDP itself).
>> > 
>> > When performing the XDP xmit, i40e uses the smp_processor_id() to
>> > select the tx queue (see
>> > https://elixir.bootlin.com/linux/v5.12.1/source/drivers/net/ethernet/intel/i40e/i40e_txrx.c#L3846).
>> > I'm not 100% clear on how the CPU is selected (since we don't use
>> > cores 0 and 1), we end up on a core whose id is higher than any
>> > available queue.
>> > 
>> > I'm going to try to modify our IRQ mappings to test this.
>> > 
>> > If I'm correct, this feels like a bug to me, since it requires a user
>> > to understand low level driver details to do IRQ remapping, which is a
>> > bit higher level. But if it's intended, we'll just have to figure out
>> > how to work around this. (Unfortunately, using split tx and rx queues
>> > is not possible with i40e, so that easy solution is unavailable.)
>> > 
>> > --Zvi
>
> Hey Zvi, sorry for the lack of assistance, there has been statutory free
> time in Poland and today i'm in the birthday mode, but we managed to
> discuss the issue with Magnus and we feel like we could have a solution
> for that, more below.
>
>> 
>> 
>> It seems like for Intel drivers, igc, ixgbe, i40e, ice all have
>> this problem.
>> 
>> Notably, igb, fixes it like I would expect.
>
> igb is correct but I think that we would like to avoid the introduction of
> locking for higher speed NICs in XDP data path.
>
> We talked with Magnus that for i40e and ice that have lots of HW
> resources, we could always create the xdp_rings array of num_online_cpus()
> size and use smp_processor_id() for accesses, regardless of the user's
> changes to queue count.

What is "lots"? Systems with hundreds of CPUs exist (and I seem to
recall an issue with just such a system on Intel hardware(?)). Also,
what if num_online_cpus() changes?

> This way the smp_processor_id() provides the serialization by itself as
> we're under napi on a given cpu, so there's no need for locking
> introduction - there is a per-cpu XDP ring provided. If we would stick to
> the approach where you adjust the size of xdp_rings down to the shrinked
> Rx queue count and use a smp_processor_id() % vsi->num_queue_pairs formula
> then we could have a resource contention. Say that you did on a 16 core
> system:
> $ ethtool -L eth0 combined 2
>
> and then mapped the q0 to cpu1 and q1 to cpu 11. Both queues will grab the
> xdp_rings[1], so we would have to introduce the locking.
>
> Proposed approach would just result with more Tx queues packed onto Tx
> ring container of queue vector.
>
> Thoughts? Any concerns? Should we have a 'fallback' mode if we would be
> out of queues?

Yes, please :)

-Toke

