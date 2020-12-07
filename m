Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA762D100A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgLGME7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:04:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbgLGME6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:04:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607342612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJjkCHCo/Gql4PJ49zcGAijs+pyIju16zLADLNdbI8w=;
        b=VrpeEV1P0Am3tgUQBWwCqJOQvzEWTnqQ9MR4FuAjhPLa2ahy907h2be7Yo6Lu4fT+XJmmP
        Khqx5GHSZz3NNF5Vs09V/rmgpVkzYjOiLYDXc82djFya/SWoQTVI50xkb5O/6dQAcs4HHU
        vZBSojBRN4FciMZ6SmH9pj66vxsX7dI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-YmCTaiMZORWMnmez7keNLg-1; Mon, 07 Dec 2020 07:03:31 -0500
X-MC-Unique: YmCTaiMZORWMnmez7keNLg-1
Received: by mail-wr1-f70.google.com with SMTP id v5so4763637wrr.0
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 04:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=GJjkCHCo/Gql4PJ49zcGAijs+pyIju16zLADLNdbI8w=;
        b=Y0rg1o16xHish7LQ7athIE4pVeLeI8sAem4oOrMWn9gI//q6dCtMB2TD7bYH2B5jiS
         alxHIfjCUb3hI5Cd1bd22w1cgf0GFhLiRNoQusjzzgiTJW99kdbKosA8+1ZapByFD1Mg
         5CrpAslm2ntCotnH5QHUsfDj8w9RIn97yZ7KxXzGUyILXM7ik6lRZM2rvLULzyANBPzQ
         kGAsJq/dlqwFFWi7tkXj9B9bhG1pSYnfuyqBCV+NvjAkvZncaRv3zO0SuVMiXJNJ/+uH
         5KB1v3u8K6CR9ROrE5wr7dqURB2oEh1ZrnSP7oJeR+SHL/EMP2XDyrBNG/tw53jnNg0H
         1Gow==
X-Gm-Message-State: AOAM532VK6iCmBHd07bzOOttxKuMfK7ZP6on/YCkV62KGHG97Z8Yk+6Z
        5DH5vwDB52Lh8ShecwFv8lAVthzS0rSbK5zt/GtzPjj0RMNBqdBCEtSITcUlDjYfTHObwdgf+qX
        GFdTKS9HJR2yVWObw
X-Received: by 2002:a1c:f715:: with SMTP id v21mr18479541wmh.2.1607342609661;
        Mon, 07 Dec 2020 04:03:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJylGcoP7WlRbm8G2sWRxkZt+vYlKcGJovmzr6Hww9hY+IPCyNa85SCqV6DtKpa6MIyAdeu2tg==
X-Received: by 2002:a1c:f715:: with SMTP id v21mr18479512wmh.2.1607342609483;
        Mon, 07 Dec 2020 04:03:29 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z189sm14413663wme.23.2020.12.07.04.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 04:03:28 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6DC261843F5; Mon,  7 Dec 2020 13:03:28 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
In-Reply-To: <eb305a4f-c189-6b32-f718-6e709ef0fa55@iogearbox.net>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk> <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <87pn3p7aiv.fsf@toke.dk>
 <eb305a4f-c189-6b32-f718-6e709ef0fa55@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 07 Dec 2020 13:03:28 +0100
Message-ID: <87wnxt6cxb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 12/4/20 6:20 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
> [...]
>>> We tried to standardize on a minimum guaranteed amount, but unfortunate=
ly not
>>> everyone seems to implement it, but I think it would be very useful to =
query
>>> this from application side, for example, consider that an app inserts a=
 BPF
>>> prog at XDP doing custom encap shortly before XDP_TX so it would be use=
ful to
>>> know which of the different encaps it implements are realistically poss=
ible on
>>> the underlying XDP supported dev.
>>=20
>> How many distinct values are there in reality? Enough to express this in
>> a few flags (XDP_HEADROOM_128, XDP_HEADROOM_192, etc?), or does it need
>> an additional field to get the exact value? If we implement the latter
>> we also run the risk of people actually implementing all sorts of weird
>> values, whereas if we constrain it to a few distinct values it's easier
>> to push back against adding new values (as it'll be obvious from the
>> addition of new flags).
>
> It's not everywhere straight forward to determine unfortunately, see also=
 [0,1]
> as some data points where Jesper looked into in the past, so in some case=
s it
> might differ depending on the build/runtime config..
>
>    [0] https://lore.kernel.org/bpf/158945314698.97035.5286827951225578467=
.stgit@firesoul/
>    [1] https://lore.kernel.org/bpf/158945346494.97035.1280940041456606181=
5.stgit@firesoul/

Right, well in that case maybe we should just expose the actual headroom
as a separate netlink attribute? Although I suppose that would require
another round of driver changes since Jesper's patch you linked above
only puts this into xdp_buff at XDP program runtime.

Jesper, WDYT?

-Toke

