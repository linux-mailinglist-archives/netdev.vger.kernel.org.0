Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B18D2D1020
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgLGMK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:10:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726254AbgLGMK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607342940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lsXG7/+LSOoLYlIKjAEhYpKHkiPej1IzWyL2jyZvUL4=;
        b=VgjaTbyLlpBEnGm3iA4TvzIsN31DfUeuJ4uyLLQCXaH1Nffcu7me6EQNyaDaRmEhnCbXCA
        SnjFUV1Hv2b9DW+0+1SbHjq0pd15vKxv50QoR+wWvcNOVG1o5dP4NFJcnLkjhvFvOt5TfX
        ecoQ6DttNcX7t4H71UzxlaFLcqQRqik=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-Xh1hAg51Ov-38zAMfPceSA-1; Mon, 07 Dec 2020 07:08:58 -0500
X-MC-Unique: Xh1hAg51Ov-38zAMfPceSA-1
Received: by mail-wm1-f70.google.com with SMTP id q1so4122906wmq.2
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 04:08:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=lsXG7/+LSOoLYlIKjAEhYpKHkiPej1IzWyL2jyZvUL4=;
        b=SbIFlfha36RzRFLDw97uJsdGgpeDso1IfkX+HsqqMIBZTQCUgbHjslpHvx/81Xc1ic
         lBsD+dCmgnXQK3Lp7Yk54JWXlVSl+yD8A54paEF7dPlUQCWyE+xTrWG1Pu/30ivPEC0o
         LNPh1/NmKwp4HqUEqF/HdCnE+g1iewSBlrQT7/S65qiUfL73H4HMuAHU9HtHFPMleQnR
         GZAsNhX6bZCLAAw/VytIh69kMwE3WL+gvxcBBhxfWpDRMfKbPCqxsYG9hKFWebAPzjNW
         EBbhjfLGFvcluiCgTa0fLDtPzd0iq4sAZKzBbwsGA3O+ZeR70zcHv4uixcRR/vGGTM1P
         uYjg==
X-Gm-Message-State: AOAM532Z61V6YsptkK0t0JX67tbnL9HrFGWsq1Ieez6olJeOl+n+Ah6R
        vuue7x1U8c3IU8KXPyHWbgQ7L0F8KusfFaarnwxKOWNvnRyvea2MgEjHIeebSBgh4ohqedKfu4J
        G5q+7bBpAvoyZeV/T
X-Received: by 2002:adf:e704:: with SMTP id c4mr10519399wrm.355.1607342937237;
        Mon, 07 Dec 2020 04:08:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPX0srtwo8PpNZQMy8Kmk5aGS1/NvZzRKGVQMubbgTQ//setktERB2bd8/aHLgF1anPSNh4Q==
X-Received: by 2002:adf:e704:: with SMTP id c4mr10519326wrm.355.1607342936495;
        Mon, 07 Dec 2020 04:08:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q4sm13881850wmc.2.2020.12.07.04.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 04:08:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 942311843F5; Mon,  7 Dec 2020 13:08:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>, brouer@redhat.com,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
In-Reply-To: <20201207125454.3883d315@carbon>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk> <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <87pn3p7aiv.fsf@toke.dk>
 <eb305a4f-c189-6b32-f718-6e709ef0fa55@iogearbox.net>
 <20201207125454.3883d315@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 07 Dec 2020 13:08:55 +0100
Message-ID: <87r1o16co8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Fri, 4 Dec 2020 23:19:55 +0100
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>
>> On 12/4/20 6:20 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > Daniel Borkmann <daniel@iogearbox.net> writes:=20=20
>> [...]
>> >> We tried to standardize on a minimum guaranteed amount, but unfortuna=
tely not
>> >> everyone seems to implement it, but I think it would be very useful t=
o query
>> >> this from application side, for example, consider that an app inserts=
 a BPF
>> >> prog at XDP doing custom encap shortly before XDP_TX so it would be u=
seful to
>> >> know which of the different encaps it implements are realistically po=
ssible on
>> >> the underlying XDP supported dev.=20=20
>> >=20
>> > How many distinct values are there in reality? Enough to express this =
in
>> > a few flags (XDP_HEADROOM_128, XDP_HEADROOM_192, etc?), or does it need
>> > an additional field to get the exact value? If we implement the latter
>> > we also run the risk of people actually implementing all sorts of weird
>> > values, whereas if we constrain it to a few distinct values it's easier
>> > to push back against adding new values (as it'll be obvious from the
>> > addition of new flags).=20=20
>>=20
>> It's not everywhere straight forward to determine unfortunately, see als=
o [0,1]
>> as some data points where Jesper looked into in the past, so in some cas=
es it
>> might differ depending on the build/runtime config..
>>=20
>>    [0] https://lore.kernel.org/bpf/158945314698.97035.528682795122557846=
7.stgit@firesoul/
>>    [1] https://lore.kernel.org/bpf/158945346494.97035.128094004145660618=
15.stgit@firesoul/
>
> Yes, unfortunately drivers have already gotten creative in this area,
> and variations have sneaked in.  I remember that we were forced to
> allow SFC driver to use 128 bytes headroom, to avoid a memory
> corruption. I tried hard to have the minimum 192 bytes as it is 3
> cachelines, but I failed to enforce this.
>
> It might be valuable to expose info on the drivers headroom size, as
> this will allow end-users to take advantage of this (instead of having
> to use the lowest common headroom) and up-front in userspace rejecting
> to load on e.g. SFC that have this annoying limitation.
>
> BUT thinking about what the drivers headroom size MEANS to userspace,
> I'm not sure it is wise to give this info to userspace.  The
> XDP-headroom is used for several kernel internal things, that limit the
> available space for growing packet-headroom.  E.g. (1) xdp_frame is
> something that we likely need to grow (even-though I'm pushing back),
> E.g. (2) metadata area which Saeed is looking to populate from driver
> code (also reduce packet-headroom for encap-headers).  So, userspace
> cannot use the XDP-headroom size to much...

(Ah, you had already replied, sorry seems I missed that).

Can we calculate a number from the headroom that is meaningful for
userspace? I suppose that would be "total number of bytes available for
metadata+packet extension"? Even with growing data structures, any
particular kernel should be able to inform userspace of the current
value, no?

-Toke

