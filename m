Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC48124DB8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfLRQdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:33:40 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44834 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfLRQdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:33:39 -0500
Received: by mail-qt1-f195.google.com with SMTP id t3so2396710qtr.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UF3uOrepvg1COtnDxzVbIHDn0DLmcQtda4/tKhDJ/JQ=;
        b=qk9DQjSN2DYI8cbPdZrSD8bBJ9g39BXhsRzjKR3TwQcff1terCO31xJfkoSwI4uHG9
         kv5/OERhcWfqCWEiEIRoY8t1MijWlDs95/NA6cwDgqaPzVaMR0zuCfznJwc+rgJ3h2wY
         d9LP0c0w4/M86wiALQZAOP057SbJyly/gVa6wJL88LV0I/GMSJM7iEOn4wfGW0sUwenr
         bwIO9N4qxmGqIA38dVJuQgZFYc9nj1B/oy1ddpkWTuqicaInqESFnD9xyl0yjQd8SAIT
         6Vlb94vt4Tq8xaLJ65XqthO8x9FXdZjkGzhCF2l9xJj/iwrvpo7uVW6NkZD39ahsjwnO
         PimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UF3uOrepvg1COtnDxzVbIHDn0DLmcQtda4/tKhDJ/JQ=;
        b=jEPp4B8o0t7sgtyMoYODIdVa+fAEN/I8ve0RwKxmA07kYwMZwUcLc8jPTNOQhf7Pzh
         rJkJ0VMydwAwlpU/KAzo3KBIjSnVmjpbDsbo/5ghRg/irq2G/nBLJrtbif6mo4YdkaqH
         GcNIutWG2kZOaBKW+xNrBRc8eJERmEDAmo5AuaimJpUooVpSsMaDD14olkiEvOAezxa3
         vUQ/jDGUnx6CRfWH0SkoVzLF1EJm+KWU1of5BMQEWosMW6CgHnrcE9Z+hIQkRcQruptt
         DZvy8/M4KW+cKfN36nS4MwMu/RUEcrLCzqcYOT08a456zFv7ET8YjaoihkV6dA27IHlk
         Gf8Q==
X-Gm-Message-State: APjAAAXJ79125qrciOd3MtZ3pXKnAJaTVd3oKtQugTjYCVSGOyLYRmXB
        Xh3R62+XtRb5CWJUvRxO9uk=
X-Google-Smtp-Source: APXvYqwYGGUBA83FyO67DWuIiASPVF6+dDRMScsXS32vuX3l+2RrVxnWs2oAIXUm4v4Lb9pfMnh5Lg==
X-Received: by 2002:aed:24c7:: with SMTP id u7mr2902368qtc.335.1576686818452;
        Wed, 18 Dec 2019 08:33:38 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:500:94:a756:23cc? ([2601:282:800:fd80:500:94:a756:23cc])
        by smtp.googlemail.com with ESMTPSA id b35sm915405qtc.9.2019.12.18.08.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:33:37 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon> <87fthh6ehg.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <65eb61c0-61a6-02d1-6c7c-f950d1d037be@gmail.com>
Date:   Wed, 18 Dec 2019 09:33:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <87fthh6ehg.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/19 4:48 AM, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <jbrouer@redhat.com> writes:
> 
>> On Wed, 18 Dec 2019 17:10:47 +0900
>> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
>>
>>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
>>> +			 struct xdp_frame *frame)
>>> +{
>>> +	struct bpf_prog *xdp_prog;
>>> +	struct tun_page tpage;
>>> +	struct xdp_buff xdp;
>>> +	u32 act = XDP_PASS;
>>> +	int flush = 0;
>>> +
>>> +	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
>>> +	if (xdp_prog) {
>>> +		xdp.data_hard_start = frame->data - frame->headroom;
>>> +		xdp.data = frame->data;
>>> +		xdp.data_end = xdp.data + frame->len;
>>> +		xdp.data_meta = xdp.data - frame->metasize;
>>
>> You have not configured xdp.rxq, thus a BPF-prog accessing this will crash.
>>
>> For an XDP TX hook, I want us to provide/give BPF-prog access to some
>> more information about e.g. the current tx-queue length, or TC-q number.
>>
>> Question to Daniel or Alexei, can we do this and still keep BPF_PROG_TYPE_XDP?
>> Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
>> for XDP TX-hook ?
> 
> I think a new program type would make the most sense. If/when we
> introduce an XDP TX hook[0], it should have different semantics than the
> regular XDP hook. I view the XDP TX hook as a hook that executes as the
> very last thing before packets leave the interface. It should have
> access to different context data as you say, but also I don't think it
> makes sense to have XDP_TX and XDP_REDIRECT in an XDP_TX hook. And we
> may also want to have a "throttle" return code; or maybe that could be
> done via a helper?

XDP_TX does not make sense in the Tx path. Jason questioned whether
XDP_RX makes sense. There is not a clear use case just yet.

REDIRECT is another one that would be useful as you point out below.

A new program type would allow support for these to be added over time
and not hold up the ability to do XDP_DROP in the Tx path.

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
> 
> -Toke
> 
> 
> [0] We've suggested this in the past, see
> https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#xdp-hook-at-tx
> 

