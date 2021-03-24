Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D48348562
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhCXXiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:38:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235297AbhCXXiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 19:38:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616629093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bWsKgQX5RpEXJF2XwJsRHZ+bqYW+lEMQdkiI+AqWIgk=;
        b=Na5EwLXnNFWZkNHzwPPr7H13B2MQTuAvt+iMKDMbVvTaNssiwZC951WfPXtQTyZrNuP0N1
        1SfXf9mE1qNswE7Op4+X/GeFafODwZjtukRaTHM7nOjxKtKiQWrrdePIVCWwnYz/U667Qk
        DWE7o+9kmDRNIANb/HwExcV20FvSCqM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-RL3LeIVrOzOET9VC0xztdQ-1; Wed, 24 Mar 2021 19:38:11 -0400
X-MC-Unique: RL3LeIVrOzOET9VC0xztdQ-1
Received: by mail-ej1-f71.google.com with SMTP id sa29so1689836ejb.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 16:38:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bWsKgQX5RpEXJF2XwJsRHZ+bqYW+lEMQdkiI+AqWIgk=;
        b=jAbzp15vaYmMpqf7mR0or/XauAS27calwMzN9wc0mlTXk3pm1nbi9+l19mbVR/qE4Z
         xenv6COYWNCsw6gpPTKJY34ZIvtY4kehvOnI98nWRLBW5ZWQThK351F6pxVRmjyrazhE
         GpfSQF37PyPQLAsfBaHiFl9GiHoTvLpboiLAI/kfvhuHc30ttqiuHJJGDF5uQ0hdhYbt
         s/H2Na5FR2SyQkiMeEhKrlFxA4p/M2VHLbSBB8Eiv+gujHfMd8geOCqKKQ5bRlRaLUof
         DBO1kZX2BK8u9tyilo8y+UFOuXermW7fGH6bvIKU0x936QxlEg96Xb3fLnn1M6+ugcBP
         UMFg==
X-Gm-Message-State: AOAM53123sqmFEIeQOeKskfOda23T4BD9AXQD/z22wZEWcLPe8lzX45A
        Rf26cDsF2TVuDonTZo4WiTSqbU7HQhfhSAvghc9WGEBeHOoExW0QFGkm7g5xz00LAlGI+QGE1YX
        xLrgjLmNaMkpj/djF
X-Received: by 2002:a17:906:3b48:: with SMTP id h8mr6259197ejf.261.1616629090185;
        Wed, 24 Mar 2021 16:38:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx28324KlNDmlRF3zjuIjq/8k55ugSp4N17Mr3QyQ8ePbq2WK6hLHFgrzuk6zcL/arOOxIU8A==
X-Received: by 2002:a17:906:3b48:: with SMTP id h8mr6259183ejf.261.1616629089974;
        Wed, 24 Mar 2021 16:38:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w24sm1844647edt.44.2021.03.24.16.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 16:38:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9C99A1801A3; Thu, 25 Mar 2021 00:38:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com
Subject: Re: [PATCH v3 bpf-next 06/17] libbpf: xsk: use bpf_link
In-Reply-To: <20210324130918.GA6932@ranger.igk.intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
 <20210322205816.65159-7-maciej.fijalkowski@intel.com>
 <87wnty7teq.fsf@toke.dk> <20210324130918.GA6932@ranger.igk.intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 25 Mar 2021 00:38:07 +0100
Message-ID: <87a6qsf7hc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Mon, Mar 22, 2021 at 10:47:09PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>>=20
>> > Currently, if there are multiple xdpsock instances running on a single
>> > interface and in case one of the instances is terminated, the rest of
>> > them are left in an inoperable state due to the fact of unloaded XDP
>> > prog from interface.
>> >
>> > Consider the scenario below:
>> >
>> > // load xdp prog and xskmap and add entry to xskmap at idx 10
>> > $ sudo ./xdpsock -i ens801f0 -t -q 10
>> >
>> > // add entry to xskmap at idx 11
>> > $ sudo ./xdpsock -i ens801f0 -t -q 11
>> >
>> > terminate one of the processes and another one is unable to work due to
>> > the fact that the XDP prog was unloaded from interface.
>> >
>> > To address that, step away from setting bpf prog in favour of bpf_link.
>> > This means that refcounting of BPF resources will be done automatically
>> > by bpf_link itself.
>> >
>> > Provide backward compatibility by checking if underlying system is
>> > bpf_link capable. Do this by looking up/creating bpf_link on loopback
>> > device. If it failed in any way, stick with netlink-based XDP prog.
>> > Otherwise, use bpf_link-based logic.
>>=20
>> So how is the caller supposed to know which of the cases happened?
>> Presumably they need to do their own cleanup in that case? AFAICT you're
>> changing the code to always clobber the existing XDP program on detach
>> in the fallback case, which seems like a bit of an aggressive change? :)
>
> Sorry Toke, I was offline yesterday.
> Yeah once again I went too far and we shouldn't do:
>
> bpf_set_link_xdp_fd(xsk->ctx->ifindex, -1, 0);
>
> if xsk_lookup_bpf_maps(xsk) returned non-zero value which implies that the
> underlying prog is not AF_XDP related.
>
> closing prog_fd (and link_fd under the condition that system is bpf_link
> capable) is enough for that case.

I think the same thing goes for further down? With your patch, if the
code takes the else branch (after checking prog_id), and then ends up
going to err_set_bpf_maps, it'll now also do an unconditional
bpf_set_link_xdp_fd(), where before it was checking prog_id again and
only unloading if it previously loaded the program...

> If we agree on that and there's nothing else that I missed, I'll send
> a v4.

Apart from the above, sure!

-Toke

