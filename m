Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6EB714986A
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 02:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAZBnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 20:43:47 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43530 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgAZBnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 20:43:47 -0500
Received: by mail-oi1-f196.google.com with SMTP id p125so3421823oif.10
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 17:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dpGVg56MQMvlRXxdWtipG5OstUyFBPF+J+t1JQFM5vk=;
        b=Oz5wlrV/tMPVvINCb5//hg2scLxJOWylBUhHmrqfPUXLdTTqqReQboY5vTNl2STLTh
         MbiY4eELDx9RMOeVg1eTt1TPm5lQ2bLyfr/PGpLIhVLLIXbMnDdUCVcoHQ/GQFq8wJCT
         fp7S3rl7MhJ3F0y/Fd299bWefKDr7kJP+8AQgk1etNwkjs6WTN2e+hCIe/okF1pJ+eoR
         Fgm+2rx4iwkcvMBopB0P6ulJJL/S3n/9Ny2UmeJJCObQPWBL9tYZE/jjP9GUGnN8Xt5/
         SDBj0+baEjnu8/sQWCJT0BlC6lTS7sYkor/e2h161+afC2l4ixbQw/RfQuKywEWEYAng
         ZfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dpGVg56MQMvlRXxdWtipG5OstUyFBPF+J+t1JQFM5vk=;
        b=kaabg9e10CFCFxh6CKHNgSw9mNgRoYMEH0cjI10SKUF9oKMy4s5iyL6GtWtdV3ZmpY
         G1i9bjVjymutAV8VM2DeU9fZdfHwDoGf6Mgf7cgwNNSWedYd5bvyeIzQOsifoKXCYLJI
         tThokcWVbKZNboTajn25zjBybDH45bvZWwTKYJIoG4ZAXow81JCnuvhGR28bdEyrtjdn
         hdBH3mbR+JAU6owsGAqQLKJfKSLWzW1Q/mN5URgGYgINnF0mFbw/3TOqIXjV7apRKn7T
         6Si7OhAL8ewCE6mf64ACEaKRU4p0DJ8CVdYBuq1R+qF+nmK5alvq1WsCJ4G3I/pU0pAC
         ftyg==
X-Gm-Message-State: APjAAAUu5u+8aKeZVkMZrb40SGWRMVTiTR9IbyoxEs5Ucg10yVZVMtPX
        B2KpFrBSy4JhXcCvtRY8AMA=
X-Google-Smtp-Source: APXvYqx878N3LJTO/gB3CkaZaKcEjyWc6oVr0rQKhpGF/1UGpSfOq419RrIFiuHMkrZ7AOmLCC6/wQ==
X-Received: by 2002:a05:6808:251:: with SMTP id m17mr3747411oie.15.1580003025920;
        Sat, 25 Jan 2020 17:43:45 -0800 (PST)
Received: from [172.16.171.105] ([208.139.204.134])
        by smtp.googlemail.com with ESMTPSA id r63sm3337792oib.56.2020.01.25.17.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 17:43:45 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
Date:   Sat, 25 Jan 2020 18:43:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87o8usg92d.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 8:36 AM, Toke Høiland-Jørgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
>> On Thu, 23 Jan 2020 14:33:42 -0700, David Ahern wrote:
>>> On 1/23/20 4:35 AM, Toke Høiland-Jørgensen wrote:
>>>> David Ahern <dsahern@kernel.org> writes:
>>>>> From: David Ahern <dahern@digitalocean.com>
>>>>>
>>>>> Add IFLA_XDP_EGRESS to if_link.h uapi to handle an XDP program attached
>>>>> to the egress path of a device. Add rtnl_xdp_egress_fill and helpers as
>>>>> the egress counterpart to the existing rtnl_xdp_fill. The expectation
>>>>> is that going forward egress path will acquire the various levels of
>>>>> attach - generic, driver and hardware.  
>>>>
>>>> How would a 'hardware' attach work for this? As I said in my reply to
>>>> the previous patch, isn't this explicitly for emulating XDP on the other
>>>> end of a point-to-point link? How would that work with offloaded
>>>> programs?
>>>
>>> Nothing about this patch set is limited to point-to-point links.
>>
>> I struggle to understand of what the expected semantics of this new
>> hook are. Is this going to be run on all frames sent to the device
>> from the stack? All frames from the stack and from XDP_REDIRECT?
>>
>> A little hard to figure out the semantics when we start from a funky
>> device like tun :S
> 
> Yes, that is also why I found this a bit weird. We have discussed plans
> for an XDP TX hook before:
> https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#xdp-hook-at-tx
> 
> That TX hook would run for everything at TX, but it would be a separate
> program type with its own metadata access. Whereas the idea with this
> series (seemed to me) to be just to be able to "emulate" run a regular
> RX-side XDP program on egress for devices where this makes sense.
> 
> If this series is not meant to implement that "emulation", but rather be
> usable for all devices, I really think we should go straight for the
> full TX hook as discussed earlier...
> 

The first patch set from Jason and Prashant started from the perspective
of offloading XDP programs for a guest. Independently, I was looking at
XDP in the TX path (now referred to as egress to avoid confusion with
the XDP_TX return type). Jason and Prashant were touching some of the
same code paths in the tun driver that I needed for XDP in the Tx path,
so we decided to consolidate and have XDP egress done first and then
offload of VMs as a followup. Offload in virtio_net can be done very
similar to how it is done in nfp -- the program is passed to the host as
a hardware level attach mode, and the driver verifies the program can be
offloaded (e.g., does not contain helpers that expose host specific data
like the fib lookup helper).

At this point, you need to stop thinking solely from the perspective of
tun or tap and VM offload; think about this from the ability to run an
XDP program on egress path at an appropriate place in the NIC driver
that covers both skbs and xdp_frames (e.g., on a REDIRECT). This has
been discussed before as a need (e.g, Toke's reference above), and I am
trying to get this initial support done.

I very much wanted to avoid copy-paste-modify for the entire XDP API for
this. For the most part XDP means ebpf at the NIC driver / hardware
level (obviously with the exception of generic mode). The goal is
tempered with the need for the verifier to reject rx entries in the
xdp_md context. Hence the reason for use of an attach_type - existing
infrastructure to test and reject the accesses.

That said, Martin's comment throws a wrench in the goal: if the existing
code does not enforce expected_attach_type then that option can not be
used in which case I guess I have to go with a new program type
(BPF_PROG_TYPE_XDP_EGRESS) which takes a new context (xdp_egress_md),
has different return codes, etc.
