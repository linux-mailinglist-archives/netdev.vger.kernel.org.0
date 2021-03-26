Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5886434AED0
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCZSw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:52:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230159AbhCZSwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616784766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mStmjSgV2Rr2281g0XQu9mK+0OcAxFBRItFc2NT/t4=;
        b=OZm6VMc2kteJ3xJEPf3apZ4yEBsiDKuuU/xSY1CxVqaUXiyedXuSMovswj5rGIyIuKG+pn
        yAe0cdmRNcxjmk8p8/FS+i1Aw8A94lA1PhIioYyk35wu98IGGJH2cub8o2edVwgMH2eXiA
        bFrl1B1Uup8smXSkEDh4XMRH4H780UA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-oeSx_tAQNkGAkChgKCCdUg-1; Fri, 26 Mar 2021 14:52:44 -0400
X-MC-Unique: oeSx_tAQNkGAkChgKCCdUg-1
Received: by mail-ed1-f69.google.com with SMTP id r6so1399905edh.7
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 11:52:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0mStmjSgV2Rr2281g0XQu9mK+0OcAxFBRItFc2NT/t4=;
        b=bFMlLfVzeE3cdxN9OEBEwFGQ1R+RlKgax7qPt4qln7FBbjYBxwhSXCZjQqwYEFJthS
         VfG13nd146PW7nDCl7Z+NL11D8i7PreIZIWNTmD3YP5GkU5BbfgqI0x9HkftAxShCyO1
         2MOMHtPI5qWqEpPbTPrcPGMHlYqQXi5Twg3BgBxKJb/zUeR6VQwZE8U0DGUBNEuAk5HV
         EhKqIrZg+OQcw5ShnoqXZhAB5mtY6IZ9svurKgpnZPmKDem6DQDAb6NZEBYzFjk4kZIg
         OELAaGgnz0R9kNgRl/4FGrkcBJvqQfXINsedYeEHv8lsDXxZnB3b0PEmucTxDReqXWwW
         zXqg==
X-Gm-Message-State: AOAM533G71wDIglxDsz1xplAxgX5UcN9a3tTNWvWf4jpjaTYbIjiCYKs
        P2JWpUytkxpoTFTBgQJOs44Q7XPnBNxa6V7nu6U6zdYAte0vBTBKd/snnJgc2UeqxfrgIlQ4yU0
        lf/kq+9eDhXTObvXf
X-Received: by 2002:a17:907:1c05:: with SMTP id nc5mr8329673ejc.320.1616784763327;
        Fri, 26 Mar 2021 11:52:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1Xo71TlF/EvM5nrC/rIt2Xq6lfE+fWs1V8BvgOSw+mvIghSEqoTO376l6Z/6b7LOg1slmMw==
X-Received: by 2002:a17:907:1c05:: with SMTP id nc5mr8329651ejc.320.1616784762967;
        Fri, 26 Mar 2021 11:52:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t6sm4543368edq.48.2021.03.26.11.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 11:52:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8B58D1801A3; Fri, 26 Mar 2021 19:52:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com
Subject: Re: [PATCH v3 bpf-next 06/17] libbpf: xsk: use bpf_link
In-Reply-To: <20210326152318.GA43356@ranger.igk.intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
 <20210322205816.65159-7-maciej.fijalkowski@intel.com>
 <87wnty7teq.fsf@toke.dk> <20210324130918.GA6932@ranger.igk.intel.com>
 <87a6qsf7hc.fsf@toke.dk> <20210326152318.GA43356@ranger.igk.intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Mar 2021 19:52:41 +0100
Message-ID: <87v99dagsm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Thu, Mar 25, 2021 at 12:38:07AM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>>=20
>> > On Mon, Mar 22, 2021 at 10:47:09PM +0100, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>> >>=20
>> >> > Currently, if there are multiple xdpsock instances running on a sin=
gle
>> >> > interface and in case one of the instances is terminated, the rest =
of
>> >> > them are left in an inoperable state due to the fact of unloaded XDP
>> >> > prog from interface.
>> >> >
>> >> > Consider the scenario below:
>> >> >
>> >> > // load xdp prog and xskmap and add entry to xskmap at idx 10
>> >> > $ sudo ./xdpsock -i ens801f0 -t -q 10
>> >> >
>> >> > // add entry to xskmap at idx 11
>> >> > $ sudo ./xdpsock -i ens801f0 -t -q 11
>> >> >
>> >> > terminate one of the processes and another one is unable to work du=
e to
>> >> > the fact that the XDP prog was unloaded from interface.
>> >> >
>> >> > To address that, step away from setting bpf prog in favour of bpf_l=
ink.
>> >> > This means that refcounting of BPF resources will be done automatic=
ally
>> >> > by bpf_link itself.
>> >> >
>> >> > Provide backward compatibility by checking if underlying system is
>> >> > bpf_link capable. Do this by looking up/creating bpf_link on loopba=
ck
>> >> > device. If it failed in any way, stick with netlink-based XDP prog.
>> >> > Otherwise, use bpf_link-based logic.
>> >>=20
>> >> So how is the caller supposed to know which of the cases happened?
>> >> Presumably they need to do their own cleanup in that case? AFAICT you=
're
>> >> changing the code to always clobber the existing XDP program on detach
>> >> in the fallback case, which seems like a bit of an aggressive change?=
 :)
>> >
>> > Sorry Toke, I was offline yesterday.
>> > Yeah once again I went too far and we shouldn't do:
>> >
>> > bpf_set_link_xdp_fd(xsk->ctx->ifindex, -1, 0);
>> >
>> > if xsk_lookup_bpf_maps(xsk) returned non-zero value which implies that=
 the
>> > underlying prog is not AF_XDP related.
>> >
>> > closing prog_fd (and link_fd under the condition that system is bpf_li=
nk
>> > capable) is enough for that case.
>>=20
>> I think the same thing goes for further down? With your patch, if the
>> code takes the else branch (after checking prog_id), and then ends up
>> going to err_set_bpf_maps, it'll now also do an unconditional
>> bpf_set_link_xdp_fd(), where before it was checking prog_id again and
>> only unloading if it previously loaded the program...
>
> Hmm it's messy, I think we need a bit of refactoring here. Note that old
> code was missing a close on ctx->xsks_map_fd if there was an error on
> xsk_set_bpf_maps(xsk) and prog_id !=3D 0 - given that
> xsk_lookup_bpf_maps(xsk) succeeded, we therefore have a valid map fd that
> we need to take care of on error path, for !prog_id case it was taken care
> of within xsk_delete_bpf_maps(xsk).
>
> So how about a diff below (on top of this patch), where we separate paths
> based on prog_id value retrieved earlier? xsk_set_bpf_maps(xsk) is
> repeated but this way I feel like it's more clear with cleanup/error
> paths.
>
> Wdyt?

Yeah, that's much easier to follow! Nice :)

-Toke

