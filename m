Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036A236CAF7
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 20:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbhD0SQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 14:16:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236279AbhD0SQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 14:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619547348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tBv0uUVPXgndSKwcI/R1EYyP8Vi9i5g8yF8CVU5/x80=;
        b=MVZanwX7Mn3GoLvFWFvIe4Expp0pLN7xFOw2xO/aHtZ9Cl0TE4ELu/d1FV4McO4WwG8LZ7
        edDoITzvoPP54gm1XFpJ/Z5fewfqH3AXLXxtba/GhKgvNKBNxlTODRirUQniWFj4RI+9lq
        vh8tHWnM2CfnXMAWFrFLFifW7Lb/2I4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-5pXl1nYlOf2Axj-yy6sHzQ-1; Tue, 27 Apr 2021 14:15:46 -0400
X-MC-Unique: 5pXl1nYlOf2Axj-yy6sHzQ-1
Received: by mail-ej1-f72.google.com with SMTP id gb17-20020a1709079611b029038c058a504cso2426873ejc.7
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 11:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tBv0uUVPXgndSKwcI/R1EYyP8Vi9i5g8yF8CVU5/x80=;
        b=s0/okhoT22wwjsOoYC8tLCJ9eJOJwxnjaMjZcbhExwuJ6zY6dKKi+yo/hZ/4LX0iWf
         qO09Fuw+rYbsuHI0gsgoR5Q6ipjpX2cHOE7gc9TpnORCXWgzOYj9YJdXdLznjekez0P6
         N1bL2Sqt01M3Hxf75iiSkXaWwwI2XqBJzAq3TjOxtNnLpTFI0VsGrL584YtUm7AVdfhC
         kZbADvok6rekowWbbaXb5zcNv1v1AKatuZso50eHAPfaSasfGs8kLuIGyitxwVlD4O2x
         WEcpJ164LMfOBxsxbcYmhnwyH88IqZJis4thEl9LQo6RTi59K3+bWsSUCdh7zj8y6c7g
         9GpQ==
X-Gm-Message-State: AOAM533Lx4mUC585I+93mSW4mlkSoy019jMImqiHAzTiNrvvRP8f3v5z
        KpI7Ik/cCYXjw4bTXMqeLdf7ibyzbU/CT96kpMVi7vUsqVuUWqEo9c45dBF/0QNoFEzEqtQjJXy
        KEzwzy0aqEiOnCPXt
X-Received: by 2002:a17:906:6b89:: with SMTP id l9mr24220371ejr.249.1619547345087;
        Tue, 27 Apr 2021 11:15:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyn9fTqS18DCoCBMGZsR0vbk8EoFLp4CL4/Yk8hpfKhrBVt3NA+6igTuf6REozJLYJCOdMpkA==
X-Received: by 2002:a17:906:6b89:: with SMTP id l9mr24220340ejr.249.1619547344857;
        Tue, 27 Apr 2021 11:15:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z14sm2915754edc.62.2021.04.27.11.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 11:15:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 82ED4180615; Tue, 27 Apr 2021 20:15:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
In-Reply-To: <20210427180202.pepa2wdbhhap3vyg@apollo>
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
 <20210427180202.pepa2wdbhhap3vyg@apollo>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 27 Apr 2021 20:15:43 +0200
Message-ID: <87fszba90w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Tue, Apr 27, 2021 at 08:34:30PM IST, Daniel Borkmann wrote:
>> On 4/23/21 5:05 PM, Kumar Kartikeya Dwivedi wrote:
>> [...]
>> >   tools/lib/bpf/libbpf.h   |  92 ++++++++
>> >   tools/lib/bpf/libbpf.map |   5 +
>> >   tools/lib/bpf/netlink.c  | 478 ++++++++++++++++++++++++++++++++++++++-
>> >   3 files changed, 574 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> > index bec4e6a6e31d..1c717c07b66e 100644
>> > --- a/tools/lib/bpf/libbpf.h
>> > +++ b/tools/lib/bpf/libbpf.h
>> > @@ -775,6 +775,98 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>> >   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>> >   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>> >
>> > +enum bpf_tc_attach_point {
>> > +	BPF_TC_INGRESS,
>> > +	BPF_TC_EGRESS,
>> > +	BPF_TC_CUSTOM_PARENT,
>> > +	_BPF_TC_PARENT_MAX,
>>
>> I don't think we need to expose _BPF_TC_PARENT_MAX as part of the API, I would drop
>> the latter.
>>
>
> Ok, will drop.
>
>> > +};
>> > +
>> > +/* The opts structure is also used to return the created filters attributes
>> > + * (e.g. in case the user left them unset). Some of the options that were left
>> > + * out default to a reasonable value, documented below.
>> > + *
>> > + *	protocol - ETH_P_ALL
>> > + *	chain index - 0
>> > + *	class_id - 0 (can be set by bpf program using skb->tc_classid)
>> > + *	bpf_flags - TCA_BPF_FLAG_ACT_DIRECT (direct action mode)
>> > + *	bpf_flags_gen - 0
>> > + *
>> > + *	The user must fulfill documented requirements for each function.
>>
>> Not sure if this is overly relevant as part of the bpf_tc_opts in here. For the
>> 2nd part, I would probably just mention that libbpf internally attaches the bpf
>> programs with direct action mode. The hw offload may be future todo, and the other
>> bits are little used anyway; mentioning them here, what value does it have to
>> libbpf users? I'd rather just drop the 2nd part and/or simplify this paragraph
>> just stating that the progs are attached in direct action mode.
>>
>
> The goal was to just document whatever attributes were set to by default, but I can see
> your point. I'll trim it.
>
>> > + */
>> > +struct bpf_tc_opts {
>> > +	size_t sz;
>> > +	__u32 handle;
>> > +	__u32 parent;
>> > +	__u16 priority;
>> > +	__u32 prog_id;
>> > +	bool replace;
>> > +	size_t :0;
>> > +};
>> > +
>> > +#define bpf_tc_opts__last_field replace
>> > +
>> > +struct bpf_tc_ctx;
>> > +
>> > +struct bpf_tc_ctx_opts {
>> > +	size_t sz;
>> > +};
>> > +
>> > +#define bpf_tc_ctx_opts__last_field sz
>> > +
>> > +/* Requirements */
>> > +/*
>> > + * @ifindex: Must be > 0.
>> > + * @parent: Must be one of the enum constants < _BPF_TC_PARENT_MAX
>> > + * @opts: Can be NULL, currently no options are supported.
>> > + */
>>
>> Up to Andrii, but we don't have such API doc in general inside libbpf.h, I
>> would drop it for the time being to be consistent with the rest (same for
>> others below).
>>
>
> I think we need to keep this somewhere. We dropped bpf_tc_info since it wasn't
> really serving any purpose, but that meant we would put the only extra thing it
> returned (prog_id) into bpf_tc_opts. That means we also need to take care that
> it is unset (along with replace) in functions where it isn't used, to allow for
> reuse for some future purpose. If we don't document that the user needs to unset
> them whenever working with bpf_tc_query and bpf_tc_detach, how are they supposed
> to know?
>
> Maybe a man page and/or a blog post would be better? Just putting it above the
> function seemed best for now.

You could document it together with the struct definition instead of for
each function? See the inline comments in bpf_object_open_opts for instance...

-Toke

