Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A1B125EB4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfLSKP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:15:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27551 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726609AbfLSKP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576750556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQjAI6JubuoTKQgEMRmf2+97wqKzLvDzydfpYdfezXs=;
        b=Dl0jVxGEuM2CTSvluGcTTnPGDGl5MFjXXSy5eAfXtAWSzjmscwThwpVZVAXbO/JMsKncIE
        IO8VllSXwH0I+p/Np2FAB4TwW9B9j/AM+dsmGtjlpOtxU62UEgVgq/MRO20fmZxX/2UU1u
        gKLPf830ZLlPBqyiNrixJw5agzxF1pA=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-JBFAMPDnODenYJ0LOjd_5A-1; Thu, 19 Dec 2019 05:15:52 -0500
X-MC-Unique: JBFAMPDnODenYJ0LOjd_5A-1
Received: by mail-lj1-f200.google.com with SMTP id z18so1745507ljm.22
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 02:15:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=hQjAI6JubuoTKQgEMRmf2+97wqKzLvDzydfpYdfezXs=;
        b=eplQFCSfQUCrHw5kTkxzgCf5hVmvM/gOJ+Ld46D6SWytRgeACaH1B/Q+MC9982S4LR
         7W2Qj2s/2fzVcF/HjeNiDJWvB6fPwBkiR2mhOV4heBSN9oUo9UGNWVrIcZpgGguzbORP
         iK79w++2Tbhtr7+cj76iGyYG/O21kVLfRScMJZurVj8v0hrpE7hPU6+qJbwi5GLGKmzR
         2hCOnUqa3vahFjuY0M44KKDgfwzUVbdY54wMJDQFVh2FHFNSYYJG5kvMK1OYBaTRZ8eI
         Mc1ztFFMjbQ3yPH9HZlAgxAZHZePTrc+AJsrN3EJP00137Kz0zIpGN7kCHfy/zk+QSNa
         nTbg==
X-Gm-Message-State: APjAAAU+d5LQobmNkAOWdEDYsCHwDmGdfvxVdlpR90C5v1lhzZM8IfOS
        CAHJ074hIEP/ALRw0RLoNmnFAQl8ln7mBGYyPc13A/hExAnzvV0CUXhv5MS2hHFTa1ODaMJoNKD
        itiau3S8+Im1AbWI5
X-Received: by 2002:a2e:580c:: with SMTP id m12mr5402015ljb.150.1576750551361;
        Thu, 19 Dec 2019 02:15:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxRLX/uV3r0uPoNDAmKN5lQYe++bbWrGCxMJTSIxViCD/pZOvhtGAsv674uurk8OXXaLS/oRg==
X-Received: by 2002:a2e:580c:: with SMTP id m12mr5401985ljb.150.1576750551118;
        Thu, 19 Dec 2019 02:15:51 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v9sm2954197lfe.18.2019.12.19.02.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 02:15:50 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 61040180969; Thu, 19 Dec 2019 11:15:48 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
In-Reply-To: <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com> <20191218081050.10170-12-prashantbhole.linux@gmail.com> <20191218110732.33494957@carbon> <87fthh6ehg.fsf@toke.dk> <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com> <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 19 Dec 2019 11:15:48 +0100
Message-ID: <874kxw4o4r.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prashant Bhole <prashantbhole.linux@gmail.com> writes:

> On 12/19/19 3:19 AM, Alexei Starovoitov wrote:
>> On Wed, Dec 18, 2019 at 12:48:59PM +0100, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>>> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
>>>
>>>> On Wed, 18 Dec 2019 17:10:47 +0900
>>>> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>>>>
>>>>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tf=
ile,
>>>>> +			 struct xdp_frame *frame)
>>>>> +{
>>>>> +	struct bpf_prog *xdp_prog;
>>>>> +	struct tun_page tpage;
>>>>> +	struct xdp_buff xdp;
>>>>> +	u32 act =3D XDP_PASS;
>>>>> +	int flush =3D 0;
>>>>> +
>>>>> +	xdp_prog =3D rcu_dereference(tun->xdp_tx_prog);
>>>>> +	if (xdp_prog) {
>>>>> +		xdp.data_hard_start =3D frame->data - frame->headroom;
>>>>> +		xdp.data =3D frame->data;
>>>>> +		xdp.data_end =3D xdp.data + frame->len;
>>>>> +		xdp.data_meta =3D xdp.data - frame->metasize;
>>>>
>>>> You have not configured xdp.rxq, thus a BPF-prog accessing this will c=
rash.
>>>>
>>>> For an XDP TX hook, I want us to provide/give BPF-prog access to some
>>>> more information about e.g. the current tx-queue length, or TC-q numbe=
r.
>>>>
>>>> Question to Daniel or Alexei, can we do this and still keep BPF_PROG_T=
YPE_XDP?
>>>> Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
>>>> for XDP TX-hook ?
>>>
>>> I think a new program type would make the most sense. If/when we
>>> introduce an XDP TX hook[0], it should have different semantics than the
>>> regular XDP hook. I view the XDP TX hook as a hook that executes as the
>>> very last thing before packets leave the interface. It should have
>>> access to different context data as you say, but also I don't think it
>>> makes sense to have XDP_TX and XDP_REDIRECT in an XDP_TX hook. And we
>>> may also want to have a "throttle" return code; or maybe that could be
>>> done via a helper?
>>>
>>> In any case, I don't think this "emulated RX hook on the other end of a
>>> virtual device" model that this series introduces is the right semantics
>>> for an XDP TX hook. I can see what you're trying to do, and for virtual
>>> point-to-point links I think it may make sense to emulate the RX hook of
>>> the "other end" on TX. However, form a UAPI perspective, I don't think
>>> we should be calling this a TX hook; logically, it's still an RX hook
>>> on the receive end.
>>>
>>> If you guys are up for evolving this design into a "proper" TX hook (as
>>> outlined above an in [0]), that would be awesome, of course. But not
>>> sure what constraints you have on your original problem? Do you
>>> specifically need the "emulated RX hook for unmodified XDP programs"
>>> semantics, or could your problem be solved with a TX hook with different
>>> semantics?
>>=20
>> I agree with above.
>> It looks more like existing BPF_PROG_TYPE_XDP, but attached to egress
>> of veth/tap interface. I think only attachment point makes a difference.
>> May be use expected_attach_type ?
>> Then there will be no need to create new program type.
>> BPF_PROG_TYPE_XDP will be able to access different fields depending
>> on expected_attach_type. Like rx-queue length that Jesper is suggesting
>> will be available only in such case and not for all BPF_PROG_TYPE_XDP pr=
ogs.
>> It can be reduced too. Like if there is no xdp.rxq concept for egress si=
de
>> of virtual device the access to that field can disallowed by the verifie=
r.
>> Could you also call it XDP_EGRESS instead of XDP_TX?
>> I would like to reserve XDP_TX name to what Toke describes as XDP_TX.
>>=20
>
>  From the discussion over this set, it makes sense to have new type of
> program. As David suggested it will make a way for changes specific
> to egress path.
> On the other hand, XDP offload with virtio-net implementation is based
> on "emulated RX hook". How about having this special behavior with
> expected_attach_type?

Another thought I had re: this was that for these "special" virtual
point-to-point devices we could extend the API to have an ATTACH_PEER
flag. So if you have a pair of veth devices (veth0,veth1) connecting to
each other, you could do either of:

bpf_set_link_xdp_fd(ifindex(veth0), prog_fd, 0);
bpf_set_link_xdp_fd(ifindex(veth1), prog_fd, ATTACH_PEER);

to attach to veth0, and:

bpf_set_link_xdp_fd(ifindex(veth1), prog_fd, 0);
bpf_set_link_xdp_fd(ifindex(veth0), prog_fd, ATTACH_PEER);

to attach to veth0.

This would allow to attach to a device without having the "other end"
visible, and keep the "XDP runs on RX" semantics clear to userspace.
Internally in the kernel we could then turn the "attach to peer"
operation for a tun device into the "emulate on TX" thing you're already
doing?

Would this work for your use case, do you think?

-Toke

