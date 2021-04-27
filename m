Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F317136CE99
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 00:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbhD0WhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 18:37:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235382AbhD0WhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 18:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619562999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGFj08Unt40n8F+l0vJ0DLTIC2j1a0iIF2BhodDAwAE=;
        b=As+0AVD0xnj5+ONmu+qLdZZvOP060t7ebqLN+uQcnJG9QrsRFPtEgGMOSIEFbw8WFtUdC3
        4REK6kfUXTEf7ydFbXrICgRcAdMou8xnfIsCarL7oVMvzVGh7eluLln4H8zSb1Va+tfcq7
        Cmcx4wZ42rYeFHKAQM4mX7IC/T3hBH0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-Xsaqj107MfWlUKR-VE4Vhw-1; Tue, 27 Apr 2021 18:36:28 -0400
X-MC-Unique: Xsaqj107MfWlUKR-VE4Vhw-1
Received: by mail-ed1-f71.google.com with SMTP id i17-20020a50fc110000b0290387c230e257so3564109edr.0
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 15:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XGFj08Unt40n8F+l0vJ0DLTIC2j1a0iIF2BhodDAwAE=;
        b=HrrDR7Isr1MwH1MM8mEn5CTHL9Dlr5rqisl0S+DjlLlmv6ezUbtWYEcwIt4pgEWtr4
         otQrhO7mFJrWqKSyH8oR4+NDq02Ihau62rl8MgP7ikUdmJx9tPIRO0IZO5G0XdlV97FO
         055MvAk830rTsH2Re+EEp2tqyHxHYL9/xXaCfuewcoiBxD9kGdnsOx+zRH8Wjv61FgZH
         XyIqQ8Pvvxd8/kJjSWtC9VdQ5uUGgWgKa+84uJA5q6kkq03UjspYn/vpmRftlmp87jTr
         JR5CnqmNaCztnFGZuLTyinDQvVW4Tcbv/oYgIHsusg0s9pqQJHB3ffXSsJsUFaqH20Tb
         2dgg==
X-Gm-Message-State: AOAM532WqwPbOBP/jLVWjR1X3SjJNxZBG0LzucHXFu2W+ze1rAkQFP50
        LZS9lBxPRbM/1phNxHc3OUd1dxVAlG4wrOuroxao8FMWhjIJNvrahbyN5FWbLj3e4Fm8pMEWmMN
        tPTSwQbOY8igTgcoT
X-Received: by 2002:a17:906:9381:: with SMTP id l1mr18164917ejx.45.1619562987183;
        Tue, 27 Apr 2021 15:36:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpakUQGjpnNm7/pTWpMrODwCwFYUQztlxtjtKWnMei+U66Wb54ehVVrhbGyovYaJTnDFpTHQ==
X-Received: by 2002:a17:906:9381:: with SMTP id l1mr18164897ejx.45.1619562986980;
        Tue, 27 Apr 2021 15:36:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x9sm3329522edv.22.2021.04.27.15.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 15:36:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6F8FB180615; Wed, 28 Apr 2021 00:36:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
In-Reply-To: <7a75062e-b439-68b3-afa3-44ea519624c7@iogearbox.net>
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
 <20210427180202.pepa2wdbhhap3vyg@apollo>
 <9985fe91-76ea-7c09-c285-1006168f1c27@iogearbox.net>
 <7a75062e-b439-68b3-afa3-44ea519624c7@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 28 Apr 2021 00:36:25 +0200
Message-ID: <87sg3b8idy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 4/27/21 11:55 PM, Daniel Borkmann wrote:
>> On 4/27/21 8:02 PM, Kumar Kartikeya Dwivedi wrote:
>>> On Tue, Apr 27, 2021 at 08:34:30PM IST, Daniel Borkmann wrote:
>>>> On 4/23/21 5:05 PM, Kumar Kartikeya Dwivedi wrote:
>> [...]
>>>>> +/*
>>>>> + * @ctx: Can be NULL, if not, must point to a valid object.
>>>>> + *=C2=A0=C2=A0=C2=A0=C2=A0 If the qdisc was attached during ctx_init=
, it will be deleted if no
>>>>> + *=C2=A0=C2=A0=C2=A0=C2=A0 filters are attached to it.
>>>>> + *=C2=A0=C2=A0=C2=A0=C2=A0 When ctx =3D=3D NULL, this is a no-op.
>>>>> + */
>>>>> +LIBBPF_API int bpf_tc_ctx_destroy(struct bpf_tc_ctx *ctx);
>>>>> +/*
>>>>> + * @ctx: Cannot be NULL.
>>>>> + * @fd: Must be >=3D 0.
>>>>> + * @opts: Cannot be NULL, prog_id must be unset, all other fields ca=
n be
>>>>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 optionally set. All fields except r=
eplace=C2=A0 will be set as per created
>>>>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 filter's attributes. pa=
rent must only be set when attach_point of ctx is
>>>>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BPF_TC_CUSTOM_PARENT, o=
therwise parent must be unset.
>>>>> + *
>>>>> + * Fills the following fields in opts:
>>>>> + *=C2=A0=C2=A0=C2=A0 handle
>>>>> + *=C2=A0=C2=A0=C2=A0 parent
>>>>> + *=C2=A0=C2=A0=C2=A0 priority
>>>>> + *=C2=A0=C2=A0=C2=A0 prog_id
>>>>> + */
>>>>> +LIBBPF_API int bpf_tc_attach(struct bpf_tc_ctx *ctx, int fd,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bpf_tc_opts *opts);
>>>>> +/*
>>>>> + * @ctx: Cannot be NULL.
>>>>> + * @opts: Cannot be NULL, replace and prog_id must be unset, all oth=
er fields
>>>>> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 must be set.
>>>>> + */
>>>>> +LIBBPF_API int bpf_tc_detach(struct bpf_tc_ctx *ctx,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct bpf_tc_opts *opts);
>>>>
>>>> One thing that I find a bit odd from this API is that BPF_TC_INGRESS /=
 BPF_TC_EGRESS
>>>> needs to be set each time via bpf_tc_ctx_init(). So whenever a specifi=
c program would
>>>> be attached to both we need to 're-init' in between just to change fro=
m hook a to b,
>>>> whereas when you have BPF_TC_CUSTOM_PARENT, you could just use a diffe=
rent opts->parent
>>>> without going this detour (unless the clsact wasn't loaded there in th=
e first place).
>>>
>>> Currently I check that opts->parent is unset when BPF_TC_INGRESS or BPF=
_TC_EGRESS
>>> is set as attach point. But since both map to clsact, we could allow th=
e user to
>>> specify opts->parent as BPF_TC_INGRESS or BPF_TC_EGRESS (no need to use
>>> TC_H_MAKE, we can detect it from ctx->parent that it won't be a parent =
id). This
>>> would mean that by default attach point is what you set for ctx, but for
>>> bpf_tc_attach you can temporarily override to be some other attach poin=
t (for
>>> the same qdisc). You still won't be able to set anything other than the=
 two
>>> though.
>>=20
>> I think the assumption on auto-detecting the parent id in that case migh=
t not hold given
>> major number could very well be 0. Wrt BPF_TC_UNSPEC ... maybe it's not =
even needed, back
>> to drawing board ...
>>=20
>> Here's how the whole API could look like, usage examples below:
>>=20
>>  =C2=A0 enum bpf_tc_attach_point {
>>  =C2=A0=C2=A0=C2=A0=C2=A0BPF_TC_INGRESS =3D 1 << 0,
>>  =C2=A0=C2=A0=C2=A0=C2=A0BPF_TC_EGRESS=C2=A0 =3D 1 << 1,
>>  =C2=A0=C2=A0=C2=A0=C2=A0BPF_TC_CUSTOM=C2=A0 =3D 1 << 2,
>>  =C2=A0 };
>>=20
>>  =C2=A0 enum bpf_tc_attach_flags {
>>  =C2=A0=C2=A0=C2=A0=C2=A0BPF_TC_F_REPLACE =3D 1 << 0,
>>  =C2=A0 };
>>=20
>>  =C2=A0 struct bpf_tc_hook {
>>  =C2=A0=C2=A0=C2=A0=C2=A0size_t sz;
>>  =C2=A0=C2=A0=C2=A0=C2=A0int=C2=A0=C2=A0=C2=A0 ifindex;
>>  =C2=A0=C2=A0=C2=A0=C2=A0enum bpf_tc_attach_point which;
>>  =C2=A0=C2=A0=C2=A0=C2=A0__u32=C2=A0 parent;
>>  =C2=A0=C2=A0=C2=A0=C2=A0size_t :0;
>>  =C2=A0 };
>>=20
>>  =C2=A0 struct bpf_tc_opts {
>>  =C2=A0=C2=A0=C2=A0=C2=A0size_t sz;
>>  =C2=A0=C2=A0=C2=A0=C2=A0__u32=C2=A0 handle;
>>  =C2=A0=C2=A0=C2=A0=C2=A0__u16=C2=A0 priority;
>>  =C2=A0=C2=A0=C2=A0=C2=A0union {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int=C2=A0=C2=A0 prog_fd;
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u32 prog_id;
>>  =C2=A0=C2=A0=C2=A0=C2=A0};
>>  =C2=A0=C2=A0=C2=A0=C2=A0size_t :0;
>>  =C2=A0 };
>>=20
>>  =C2=A0 LIBBPF_API int bpf_tc_hook_create(struct bpf_tc_hook *hook);
>>  =C2=A0 LIBBPF_API int bpf_tc_hook_destroy(struct bpf_tc_hook *hook);
>>=20
>>  =C2=A0 LIBBPF_API int bpf_tc_attach(const struct bpf_tc_hook *hook, con=
st struct bpf_tc_opts *opts, int flags);
>>  =C2=A0 LIBBPF_API int bpf_tc_detach(const struct bpf_tc_hook *hook, con=
st struct bpf_tc_opts *opts);
>>  =C2=A0 LIBBPF_API int bpf_tc_query(const struct bpf_tc_hook *hook, stru=
ct bpf_tc_opts *opts);
>>=20
>> So a user could do just:
>>=20
>>  =C2=A0 DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =3D 42, .which =
=3D BPF_TC_INGRESS);
>>  =C2=A0 DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priority =
=3D 1, .prog_fd =3D fd);
>>=20
>>  =C2=A0 err =3D bpf_tc_attach(&hook, &opts, BPF_TC_F_REPLACE);
>>  =C2=A0 [...]
>>=20
>> If it's not known whether the hook exists, then a preceding call to:
>>=20
>>  =C2=A0 err =3D bpf_tc_hook_create(&hook);
>>  =C2=A0 [...]
>>=20
>> The bpf_tc_query() would look like:
>>=20
>>  =C2=A0 DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =3D 42, .which =
=3D BPF_TC_EGRESS);
>>  =C2=A0 DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priority =
=3D 1);
>>=20
>>  =C2=A0 err =3D bpf_tc_query(&hook, &opts);
>>  =C2=A0 if (!err) {
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [...]=C2=A0 // gives a=
ccess to: opts.prog_id
>>  =C2=A0 }
>>=20
>> The bpf_tc_detach():
>>=20
>>  =C2=A0 DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =3D 42, .which =
=3D BPF_TC_INGRESS);
>>  =C2=A0 DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priority =
=3D 1);
>>=20
>>  =C2=A0 err =3D bpf_tc_detach(&hook, &opts);
>>  =C2=A0 [...]
>>=20
>> The nice thing would be that hook and opts are kept semantically separat=
e, meaning with
>> hook you can iterate though a bunch of devs and ingress/egress locations=
 without changing
>> opts, whereas with opts you could iterate on the cls_bpf instance itself=
 w/o changing
>> hook. Both are kept extensible via DECLARE_LIBBPF_OPTS().
>>=20
>> Now the bpf_tc_hook_destroy() one:
>>=20
>>  =C2=A0 DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =3D 42, .which =
=3D BPF_TC_INGRESS|BPF_TC_EGRESS);
>>=20
>>  =C2=A0 err =3D bpf_tc_hook_destroy(&hook);
>>  =C2=A0 [...]
>>=20
>> For triggering a remove of the clsact qdisc on the device, both directio=
ns are passed in.
>> Combining both is only ever allowed for bpf_tc_hook_destroy().
>
> Small addendum:
>
>      DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =3D 42, .which =3D B=
PF_TC_INGRESS|BPF_TC_EGRESS);
>
>      err =3D bpf_tc_hook_create(&hook);
>      [...]
>
> ... is also possible, of course, and then both bpf_tc_hook_{create,destro=
y}() are symmetric.

It should be allowed, but it wouldn't actually make any difference which
combination of TC_INGRESS and TC_EGRESS you specify, as long as one of
them is set, right? I.e., we just attach the clsact qdisc in both
cases...

-Toke

