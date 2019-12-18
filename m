Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54238125073
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfLRSTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:19:49 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35812 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfLRSTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:19:49 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so1341235plt.2
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=lkjrXxS3UvYdf4v+FMPOl4XZbSny6eGo+1ICAxogePI=;
        b=K1zDcB7HcjqueENh4dN/1a8K/fZdSgqTERo/VT6jdVV5rOKgd/vrcUA30twb8gP9L1
         XTkuCy3aCgsZmihMetlOy2Jj5OGGXMEVP5PTlR9PdWaHkt8+Wqfr8MNIV6keuU7mabi7
         O0Prp6Jypwg+tTcnav4f8AxGSU8mEleOW0u0/Eg5g887mNBfYhfFkzXkZCYSNcV1yYHh
         eyhdviGNELu9qzsAJdQEzf+xeqzLSaunsDzCLsK6DUPILSaZPpKWTZ6JGIONrM5zuCda
         PoIEo8LUxw9IWujoRgKW813h0TY6P3WgIv0pOWlEKlFv9zESRJBpBTqFd2BAMaQbAIo7
         2A6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=lkjrXxS3UvYdf4v+FMPOl4XZbSny6eGo+1ICAxogePI=;
        b=Aby/8oriyJQJJbOdCvRnCQ82PQ8pp9942yw8BHzl2C4lEVvYleAiRBh9s4YtMPDrQk
         Q/hwl/WBeUK5+XZmW8k77ap85H6OqKZvQgeraVTbS31NBzpjsj0mb+xlpsD7JZgHbKtQ
         IHQpQQADK3SPv1HoPLUpR0Livj2dphXIrjdeOgczPtgnQwh7Qk83HaKQgJGFk/jnwAdJ
         JuElchx/199r666Bi8aLYGNIu23KgYjlXVWmoLAOosYeY59HNOOE1c2YQnn/dIw+9sw1
         FCBWDWOimt72UQ3f6Vpkxa0nE5DssoipMqNv40eY618VQmNRylEVfgg3mDn18FYrIz1y
         Ne8g==
X-Gm-Message-State: APjAAAWWPSqNEU/RoidNPfLhSe9XYMouxEiIoke6fZ1ZZKk1lct8EPT1
        jxHmY/+zU922exFzsTIVHOc=
X-Google-Smtp-Source: APXvYqy+DKsylonAMUV6ExU2zSyXICtoLtxFfAefJBb4IRZToMWJ4NonMVHXeH6xobqq6x/gEuUR3g==
X-Received: by 2002:a17:902:7207:: with SMTP id ba7mr4351093plb.254.1576693188068;
        Wed, 18 Dec 2019 10:19:48 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::4108])
        by smtp.gmail.com with ESMTPSA id a19sm4165580pfn.50.2019.12.18.10.19.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 10:19:47 -0800 (PST)
Date:   Wed, 18 Dec 2019 10:19:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
Message-ID: <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon>
 <87fthh6ehg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fthh6ehg.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 12:48:59PM +0100, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
> 
> > On Wed, 18 Dec 2019 17:10:47 +0900
> > Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
> >
> >> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
> >> +			 struct xdp_frame *frame)
> >> +{
> >> +	struct bpf_prog *xdp_prog;
> >> +	struct tun_page tpage;
> >> +	struct xdp_buff xdp;
> >> +	u32 act = XDP_PASS;
> >> +	int flush = 0;
> >> +
> >> +	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
> >> +	if (xdp_prog) {
> >> +		xdp.data_hard_start = frame->data - frame->headroom;
> >> +		xdp.data = frame->data;
> >> +		xdp.data_end = xdp.data + frame->len;
> >> +		xdp.data_meta = xdp.data - frame->metasize;
> >
> > You have not configured xdp.rxq, thus a BPF-prog accessing this will crash.
> >
> > For an XDP TX hook, I want us to provide/give BPF-prog access to some
> > more information about e.g. the current tx-queue length, or TC-q number.
> >
> > Question to Daniel or Alexei, can we do this and still keep BPF_PROG_TYPE_XDP?
> > Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
> > for XDP TX-hook ?
> 
> I think a new program type would make the most sense. If/when we
> introduce an XDP TX hook[0], it should have different semantics than the
> regular XDP hook. I view the XDP TX hook as a hook that executes as the
> very last thing before packets leave the interface. It should have
> access to different context data as you say, but also I don't think it
> makes sense to have XDP_TX and XDP_REDIRECT in an XDP_TX hook. And we
> may also want to have a "throttle" return code; or maybe that could be
> done via a helper?
> 
> In any case, I don't think this "emulated RX hook on the other end of a
> virtual device" model that this series introduces is the right semantics
> for an XDP TX hook. I can see what you're trying to do, and for virtual
> point-to-point links I think it may make sense to emulate the RX hook of
> the "other end" on TX. However, form a UAPI perspective, I don't think
> we should be calling this a TX hook; logically, it's still an RX hook
> on the receive end.
> 
> If you guys are up for evolving this design into a "proper" TX hook (as
> outlined above an in [0]), that would be awesome, of course. But not
> sure what constraints you have on your original problem? Do you
> specifically need the "emulated RX hook for unmodified XDP programs"
> semantics, or could your problem be solved with a TX hook with different
> semantics?

I agree with above.
It looks more like existing BPF_PROG_TYPE_XDP, but attached to egress
of veth/tap interface. I think only attachment point makes a difference.
May be use expected_attach_type ?
Then there will be no need to create new program type.
BPF_PROG_TYPE_XDP will be able to access different fields depending
on expected_attach_type. Like rx-queue length that Jesper is suggesting
will be available only in such case and not for all BPF_PROG_TYPE_XDP progs.
It can be reduced too. Like if there is no xdp.rxq concept for egress side
of virtual device the access to that field can disallowed by the verifier.
Could you also call it XDP_EGRESS instead of XDP_TX?
I would like to reserve XDP_TX name to what Toke describes as XDP_TX.

