Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE014F8C4
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgBAQDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:03:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29935 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726668AbgBAQDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580573009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=efwbQXImvi8eqejyT0f76KQJJWkbnJVfyc7uD6iCowg=;
        b=MGYxpEU3800IPdwn2FbHYhz4iEVwjBlkhNzuVDEzCqUBA1ld6uEECQ/r+oyD387+8WkmTC
        14RQCZGmdn3IMJh6/mYT4u0ujuPrEtEhEgzbcVQpUXYnVeb3Pj+FdxDl+ZxbrDjUrbhXYG
        7lX2bqgyCJO9wpZvs6vnkx3lKDZdySc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-0VGcesZ3PCOiW8Nc-LJStA-1; Sat, 01 Feb 2020 11:03:27 -0500
X-MC-Unique: 0VGcesZ3PCOiW8Nc-LJStA-1
Received: by mail-lf1-f71.google.com with SMTP id y23so1718448lfh.7
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:03:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=efwbQXImvi8eqejyT0f76KQJJWkbnJVfyc7uD6iCowg=;
        b=tfV0Hizqbj4E3KY78keAfhE6IodRMDYURjtBDMRtrZSStoFScgUvMa5F95mup0pWga
         aYeJWyO90hKGnxGhMiHCvnMCblz+/CGRMYMQH+9wUhns3HCWGO25svitzrljN4YAvRVP
         MplR8WQmIPs3A1UgKYoAuu41c0bFa3pwxL6nI67iwiu+6TovL0oyYVTeP/GqgMK9FSHr
         sWpE7hTmVzEOHPdZS/EIRP3h8lIHCoL5pKPBJO6IeX+MoNnBtRFSeuROuE4JI5YpsoRy
         xKBXRrGhLD2YQIGT0IA02Rmlk57qaT+cRVqpMr+yjLzvgi+pk3m53x9Gyh2JV+viJlaW
         f46w==
X-Gm-Message-State: APjAAAUDzrO7OisPj0f2gCIqmMK8vcRLJ7VeM+Y8BLHp550bkuHfln75
        4uSbneV/BKfv9CFCvf0KcBsabPiO2hzDIyOaLcgJa6MJcmHSfbUiTjmzH3KwkZTelVNpRNu4VD6
        93KXLZslQ3d7bMqrB
X-Received: by 2002:a2e:93c9:: with SMTP id p9mr8871798ljh.136.1580573006505;
        Sat, 01 Feb 2020 08:03:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3IUkYMAjiEbokEVVg7LaftvqdWRNUoLaaueul0ZUyyTMJlgXCgk/mBYxM3Klx7FzJe5yiJA==
X-Received: by 2002:a2e:93c9:: with SMTP id p9mr8871780ljh.136.1580573006326;
        Sat, 01 Feb 2020 08:03:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id h10sm6638583ljc.39.2020.02.01.08.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:03:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D7C4B1800A2; Sat,  1 Feb 2020 17:03:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200130064517.43f2064f@cakuba>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <20200126134933.2514b2ab@carbon> <20200126141701.3f27b03c@cakuba> <20200128151343.28c1537d@carbon> <20200130064517.43f2064f@cakuba>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 01 Feb 2020 17:03:19 +0100
Message-ID: <87lfpme1mg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 28 Jan 2020 15:13:43 +0100, Jesper Dangaard Brouer wrote:
>> On Sun, 26 Jan 2020 14:17:01 -0800
>> Jakub Kicinski <kuba@kernel.org> wrote:
>> 
>> > On Sun, 26 Jan 2020 13:49:33 +0100, Jesper Dangaard Brouer wrote:  
>> > > Yes, please. I want this NIC TX hook to see both SKBs and xdp_frames.    
>> > 
>> > Any pointers on what for? Unless we see actual use cases there's
>> > a justifiable concern of the entire thing just being an application of
>> > "We can solve any problem by introducing an extra level of indirection."  
>> 
>> I have two use-cases:
>> 
>> (1) For XDP easier handling of interface specific setting on egress,
>> e.g. pushing a VLAN-id, instead of having to figure this out in RX hook.
>> (I think this is also David Ahern's use-case)
>
> Is it really useful to have a hook before multi-buffer frames are
> possible and perhaps TSO? The local TCP performance is going to tank
> with XDP enabled otherwise.

For a software router (i.e., something that mostly forwards packets) it
can still be useful without multi-buffer. But yeah, that is definitely
something we need to solve, regardless of where this goes.

>> (2) I want this egress XDP hook to have the ability to signal
>> backpressure. Today we have BQL in most drivers (which is essential to
>> avoid bufferbloat). For XDP_REDIRECT we don't, which we must solve.
>> 
>> For use-case(2), we likely need a BPF-helper calling netif_tx_stop_queue(),
>> or a return code that can stop the queue towards the higher layers.
>
> Agreed, although for that use case, I'm not sure if non-XDP frames 
> have to pass trough the hook. Hard to tell as the current patches 
> don't touch on this use case.

I think it would be weird and surprising if it *doesn't* see packets
from the stack. On RX, XDP sees everything; the natural expectation
would be that this was also the case on TX, no?

-Toke

