Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA33F124618
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfLRLtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:49:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30747 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726141AbfLRLtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:49:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576669746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=egYOGWy6QuGOqruF/PAxFQigclnCwZ7828zF8NwrS/w=;
        b=DlZvlPVMcA6a6SSJUDeC7qs0BVGXSrGxC38WfV46bhOWHTq8k/s4bfophshvrvhCzWFXBZ
        HsXZyvCr4NTPiuEy0H1cbar5F55864XvPBHPFgFMlPz3LSKL7kbN9H9Z8V3CChwCDy3c0R
        ljb7oSJhuTcASjai7XTh6VCnYyVFtHs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-96Sb0VSSMMe6fzg6p4pRxQ-1; Wed, 18 Dec 2019 06:49:03 -0500
X-MC-Unique: 96Sb0VSSMMe6fzg6p4pRxQ-1
Received: by mail-lj1-f199.google.com with SMTP id z17so615170ljz.2
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:49:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=egYOGWy6QuGOqruF/PAxFQigclnCwZ7828zF8NwrS/w=;
        b=ZCJSu91hwuEAIzkcy2HRRekttCJTmEaMGshPjBJVgjSf5rG7Uj/yooGiEuHWf4CvRp
         U0oo0pfwYje4x7Ilg+2eIDyjONfGoePLK9UjjUE5xDxhTKmgxEOZuuJsG6N8MQNHy3mU
         XRIUfn+WFDQrb1SryOfwnikXXr9X83d5QbZ9iH+bj3fHzBai49So7L0+qJs3WpDuo9Aw
         1bYQ9YDvMNUWgs3Tv58GH0AJbL/MH0qS3Sj+7QbPEibCxtRVvQZRaQx53GLd47GvLhi1
         QT3CON2QWBrBNfkwltj/2c18yeiXtweo6eBfaYmGLwjnthoAjWcowRl7dFWMrLlbEeNa
         dzDg==
X-Gm-Message-State: APjAAAUPw+1N3ZK/JL3jLFs31QEQpHV5g3ZfpUgV+Fm+n2q9j8J1nXCq
        cz4wr/iBtMRFgjMkbwbGSg7bif4XHi/4vFy58VkhYwmzvwAFZcgPD0wPh+aiZzDJbKaY4MgNo8i
        c/nVa+aenWVnGYA3N
X-Received: by 2002:a2e:9d9a:: with SMTP id c26mr1422772ljj.225.1576669742264;
        Wed, 18 Dec 2019 03:49:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqy1XBeaMuC/GIsbID57JHYXnBQqcoPycgnEC9PNR0ydGmsG2xu0u82SwhY9bI+GYCsO32PygA==
X-Received: by 2002:a2e:9d9a:: with SMTP id c26mr1422748ljj.225.1576669742067;
        Wed, 18 Dec 2019 03:49:02 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id l28sm998862lfk.21.2019.12.18.03.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:49:01 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BC922180969; Wed, 18 Dec 2019 12:48:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>
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
In-Reply-To: <20191218110732.33494957@carbon>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com> <20191218081050.10170-12-prashantbhole.linux@gmail.com> <20191218110732.33494957@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:48:59 +0100
Message-ID: <87fthh6ehg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <jbrouer@redhat.com> writes:

> On Wed, 18 Dec 2019 17:10:47 +0900
> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>
>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
>> +			 struct xdp_frame *frame)
>> +{
>> +	struct bpf_prog *xdp_prog;
>> +	struct tun_page tpage;
>> +	struct xdp_buff xdp;
>> +	u32 act = XDP_PASS;
>> +	int flush = 0;
>> +
>> +	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
>> +	if (xdp_prog) {
>> +		xdp.data_hard_start = frame->data - frame->headroom;
>> +		xdp.data = frame->data;
>> +		xdp.data_end = xdp.data + frame->len;
>> +		xdp.data_meta = xdp.data - frame->metasize;
>
> You have not configured xdp.rxq, thus a BPF-prog accessing this will crash.
>
> For an XDP TX hook, I want us to provide/give BPF-prog access to some
> more information about e.g. the current tx-queue length, or TC-q number.
>
> Question to Daniel or Alexei, can we do this and still keep BPF_PROG_TYPE_XDP?
> Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
> for XDP TX-hook ?

I think a new program type would make the most sense. If/when we
introduce an XDP TX hook[0], it should have different semantics than the
regular XDP hook. I view the XDP TX hook as a hook that executes as the
very last thing before packets leave the interface. It should have
access to different context data as you say, but also I don't think it
makes sense to have XDP_TX and XDP_REDIRECT in an XDP_TX hook. And we
may also want to have a "throttle" return code; or maybe that could be
done via a helper?

In any case, I don't think this "emulated RX hook on the other end of a
virtual device" model that this series introduces is the right semantics
for an XDP TX hook. I can see what you're trying to do, and for virtual
point-to-point links I think it may make sense to emulate the RX hook of
the "other end" on TX. However, form a UAPI perspective, I don't think
we should be calling this a TX hook; logically, it's still an RX hook
on the receive end.

If you guys are up for evolving this design into a "proper" TX hook (as
outlined above an in [0]), that would be awesome, of course. But not
sure what constraints you have on your original problem? Do you
specifically need the "emulated RX hook for unmodified XDP programs"
semantics, or could your problem be solved with a TX hook with different
semantics?

-Toke


[0] We've suggested this in the past, see
https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#xdp-hook-at-tx

