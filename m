Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77C131C8F9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhBPKlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:41:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhBPKlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613471984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+waj5efBfu4Hzhdyq224Jwctdt3cpkb3ziUN6hb7tzM=;
        b=hiRJAzIb7yC+QmJYJqxRRGQTdMH+Dv0ygpg5iZjfCPJXwz5srOyoB7hhzzTE7Y2Cff9baL
        wRMkcWjE6INGko/Uj5ZkHyJjM+nogLAMqfxfTUjz/ml1IOPP4unRqAjEZxWIt9uzl1yjK7
        QWSJa1SuCHMgsrxE9QydiMLfFK4st9o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-rkybxXM7MeOkxYVWdDY4_Q-1; Tue, 16 Feb 2021 05:39:42 -0500
X-MC-Unique: rkybxXM7MeOkxYVWdDY4_Q-1
Received: by mail-ej1-f69.google.com with SMTP id 7so5799371ejh.10
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:39:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+waj5efBfu4Hzhdyq224Jwctdt3cpkb3ziUN6hb7tzM=;
        b=Wshmk1WUk2DMlDIsiiyJG8tF7LrCMMDAOhoBj2X3+VLIWzzex763VzcNisXakzCduS
         pOnj9GWfbtvFdk1Dvi9xBvUKCY+6gGxHFEnPmkPTIpbhSd1kwH4brsRU9isHQ2eiC5fz
         yHp1nSzN10nrMncuqiaYrfUKlzHcvX7i3zvwlS8q+gbzfaa7y58ZYyNd4lv4fD/5waCZ
         uGdDH2+AUTz9GjZwaBklU+riMF6SV8mFbtBp15gICpaMK61HmZ+e4ukEEH24AV4zjRsV
         ysm1ZxOKS5CyLae7tM5N/fzERJ1XMEPiR0affb3dEv+f5PK+8ndhLaCYfWSgddDrG4cg
         gOYQ==
X-Gm-Message-State: AOAM5322gBe3Pe3ruYHYhAq0QmsuMjfvWXSQK7jhC371Toa6lsPWTaR2
        I9kdS1hb6p8Cr0O0eNf1NNkP9DLW0apgD7HXNzZExs1nC66r26QdA0wLPUhcfjwVgezXyKOk/XG
        Ib4NPliie/A5zXkFi
X-Received: by 2002:a50:a402:: with SMTP id u2mr13739756edb.383.1613471981445;
        Tue, 16 Feb 2021 02:39:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+uOcSqQ3nQi92E2gAYBEb8oLom5+jCtZFMQXQcFgVD5JmaNvvghOLTEbOs7/Mba/ldbzTLw==
X-Received: by 2002:a50:a402:: with SMTP id u2mr13739733edb.383.1613471981285;
        Tue, 16 Feb 2021 02:39:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b17sm6640325ejj.9.2021.02.16.02.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:39:40 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A50141805FA; Tue, 16 Feb 2021 11:39:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
In-Reply-To: <4a52d09a-363b-e69e-41d3-7918f0204901@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
 <4a52d09a-363b-e69e-41d3-7918f0204901@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Feb 2021 11:39:40 +0100
Message-ID: <87mtw4b8k3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> writes:

> On 2021-02-15 21:49, John Fastabend wrote:
>> Maciej Fijalkowski wrote:
>>> Currently, if there are multiple xdpsock instances running on a single
>>> interface and in case one of the instances is terminated, the rest of
>>> them are left in an inoperable state due to the fact of unloaded XDP
>>> prog from interface.
>>>
>>> To address that, step away from setting bpf prog in favour of bpf_link.
>>> This means that refcounting of BPF resources will be done automatically
>>> by bpf_link itself.
>>>
>>> When setting up BPF resources during xsk socket creation, check whether
>>> bpf_link for a given ifindex already exists via set of calls to
>>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
>>> and comparing the ifindexes from bpf_link and xsk socket.
>>>
>>> If there's no bpf_link yet, create one for a given XDP prog and unload
>>> explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not set.
>>>
>>> If bpf_link is already at a given ifindex and underlying program is not
>>> AF-XDP one, bail out or update the bpf_link's prog given the presence of
>>> XDP_FLAGS_UPDATE_IF_NOEXIST.
>>>
>>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>> ---
>>>   tools/lib/bpf/xsk.c | 143 +++++++++++++++++++++++++++++++++++++-------
>>>   1 file changed, 122 insertions(+), 21 deletions(-)
>>=20
>> [...]
>>=20
>>> +static int xsk_create_bpf_link(struct xsk_socket *xsk)
>>> +{
>>> +	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
>>> +	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
>>> +	 */
>>> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
>>> +			    .flags =3D (xsk->config.xdp_flags & XDP_FLAGS_MODES));
>>> +	struct xsk_ctx *ctx =3D xsk->ctx;
>>> +	__u32 prog_id;
>>> +	int link_fd;
>>> +	int err;
>>> +
>>> +	/* for !XDP_FLAGS_UPDATE_IF_NOEXIST, unload the program first, if any,
>>> +	 * so that bpf_link can be attached
>>> +	 */
>>> +	if (!(xsk->config.xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
>>> +		err =3D bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_=
flags);
>>> +		if (err) {
>>> +			pr_warn("getting XDP prog id failed\n");
>>> +			return err;
>>> +		}
>>> +		if (prog_id) {
>>> +			err =3D bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
>>> +			if (err < 0) {
>>> +				pr_warn("detaching XDP prog failed\n");
>>> +				return err;
>>> +			}
>>> +		}
>>>   	}
>>>=20=20=20
>>> -	ctx->prog_fd =3D prog_fd;
>>> +	link_fd =3D bpf_link_create(ctx->prog_fd, xsk->ctx->ifindex, BPF_XDP,=
 &opts);
>>> +	if (link_fd < 0) {
>>> +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
>>> +		return link_fd;
>>> +	}
>>> +
>>=20
>> This can leave the system in a bad state where it unloaded the XDP progr=
am
>> above, but then failed to create the link. So we should somehow fix that
>> if possible or at minimum put a note somewhere so users can't claim they
>> shouldn't know this.
>>=20
>> Also related, its not good for real systems to let XDP program go missing
>> for some period of time. I didn't check but we should make
>> XDP_FLAGS_UPDATE_IF_NOEXIST the default if its not already.
>>
>
> This is the default for XDP sockets library. The
> "bpf_set_link_xdp_fd(...-1)" way is only when a user sets it explicitly.
> One could maybe argue that the "force remove" would be out of scope for
> AF_XDP; Meaning that if an XDP program is running, attached via netlink,
> the AF_XDP library simply cannot remove it. The user would need to rely
> on some other mechanism.

Yeah, I'd tend to agree with that. In general, I think the proliferation
of "just force-remove (or override) the running program" in code and
instructions has been a mistake; and application should only really be
adding and removing its own program...

-Toke

