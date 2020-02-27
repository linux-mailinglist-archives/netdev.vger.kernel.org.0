Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F09171682
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 12:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgB0L6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 06:58:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59239 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728856AbgB0L6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 06:58:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582804697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QztQ88wOWQTVVeka2DWOfrjJ2vaSyJD2GkM2TLVhNgo=;
        b=KZeP1ZoDuwLjzZH7ICU0PTmni3BkmXSuFPjw0thMdHTXjU93EPWJs4A3UEnpfCPu2hzb5r
        UXpBuIBbOTqNK6/MRihcMQS4/53THWXR3gxGb0xGC5mb6DO9NIzmuCVMXc8+HHADDOh4Ee
        7jZCyL+erCz3RMbT7NYdwl3Jhqxh1Hg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-_ouCKjiDMm6bfNFe6PN8_g-1; Thu, 27 Feb 2020 06:58:15 -0500
X-MC-Unique: _ouCKjiDMm6bfNFe6PN8_g-1
Received: by mail-lf1-f72.google.com with SMTP id q2so334167lfo.5
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 03:58:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QztQ88wOWQTVVeka2DWOfrjJ2vaSyJD2GkM2TLVhNgo=;
        b=LA9r34HOnSppiV7BO8rFv5xS1e7COSsS/bYeUZaZ9sobHLu/ksE9eTBTt74RQkTiBS
         S8DOMz5It0vEJZrvoSQAwHHQM0seQk9sjrPgSTG0EjYvVM81U7gBGmzfCUujCvaSPpo0
         p8LQwMu3lpqU9k3ys4DjRdleSDQi88d4isqtwVF6V4UtcoPELxKpdtP13WwwvzVZYpjn
         npDlx3ixMpKVyBfU2ls8V1DHQlImMleVMemo+MH47AAVA4xzHtPpLIXFdWYVsc1SeNvb
         wh0xPNo7Upfu2igmsy00r93+/9uMLBuOlPLuFYWqpOpOR0VqqHUaH4+lCWLPoHUDIydQ
         KaRQ==
X-Gm-Message-State: ANhLgQ2S7DZQKqSqgN6r6fp5HG3dWINesMyAOxtf88wW+KKRCZiFpPB4
        u62PgA7I66zgotT/PmBIH2mfvMxMa3hAZAGsYlS+EQiYzgH0VR/UyvGY+boj6m1dT36j0rproUL
        sx757nnZdTwdvE3Aa
X-Received: by 2002:a2e:98ca:: with SMTP id s10mr2688109ljj.160.1582804693023;
        Thu, 27 Feb 2020 03:58:13 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtiJt/uaOnk6dKNkgScp5OTEvb2L16f3vHJlaE/iA26dxdEeGCfj+x5gBU6jvgvIbyqi0zGFA==
X-Received: by 2002:a2e:98ca:: with SMTP id s10mr2688084ljj.160.1582804692640;
        Thu, 27 Feb 2020 03:58:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o7sm3009814ljp.95.2020.02.27.03.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 03:58:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D85FE180362; Thu, 27 Feb 2020 12:58:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com
Subject: Re: [PATCH RFC v4 bpf-next 03/11] xdp: Add xdp_txq_info to xdp_buff
In-Reply-To: <20200227090046.3e3177b3@carbon>
References: <20200227032013.12385-1-dsahern@kernel.org> <20200227032013.12385-4-dsahern@kernel.org> <20200227090046.3e3177b3@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 27 Feb 2020 12:58:10 +0100
Message-ID: <877e08w8bx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Wed, 26 Feb 2020 20:20:05 -0700
> David Ahern <dsahern@kernel.org> wrote:
>
>> From: David Ahern <dahern@digitalocean.com>
>> 
>> Add xdp_txq_info as the Tx counterpart to xdp_rxq_info. At the
>> moment only the device is added. Other fields (queue_index)
>> can be added as use cases arise.
>> 
>> From a UAPI perspective, egress_ifindex is a union with ingress_ifindex
>> since only one applies based on where the program is attached.
>> 
>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>> ---
>>  include/net/xdp.h        |  5 +++++
>>  include/uapi/linux/bpf.h |  6 ++++--
>>  net/core/filter.c        | 27 +++++++++++++++++++--------
>>  3 files changed, 28 insertions(+), 10 deletions(-)
>> 
>> diff --git a/include/net/xdp.h b/include/net/xdp.h
>> index 40c6d3398458..5584b9db86fe 100644
>> --- a/include/net/xdp.h
>> +++ b/include/net/xdp.h
>> @@ -63,6 +63,10 @@ struct xdp_rxq_info {
>>  	struct xdp_mem_info mem;
>>  } ____cacheline_aligned; /* perf critical, avoid false-sharing */
>>  
>> +struct xdp_txq_info {
>> +	struct net_device *dev;
>> +};
>> +
>>  struct xdp_buff {
>>  	void *data;
>>  	void *data_end;
>> @@ -70,6 +74,7 @@ struct xdp_buff {
>>  	void *data_hard_start;
>>  	unsigned long handle;
>>  	struct xdp_rxq_info *rxq;
>> +	struct xdp_txq_info *txq;
>>  };
>>  
>>  struct xdp_frame {
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 7850f8683b81..5e3f8aefad41 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3334,8 +3334,10 @@ struct xdp_md {
>>  	__u32 data;
>>  	__u32 data_end;
>>  	__u32 data_meta;
>> -	/* Below access go through struct xdp_rxq_info */
>> -	__u32 ingress_ifindex; /* rxq->dev->ifindex */
>> +	union {
>> +		__u32 ingress_ifindex; /* rxq->dev->ifindex */
>> +		__u32 egress_ifindex;  /* txq->dev->ifindex */
>> +	};
>
> Are we sure it is wise to "union share" (struct) xdp_md as the
> XDP-context in the XDP programs, with different expected_attach_type?
> As this allows the XDP-programmer to code an EGRESS program that access
> ctx->ingress_ifindex, this will under the hood be translated to
> ctx->egress_ifindex, because from the compilers-PoV this will just be an
> offset.
>
> We are setting up the XDP-programmer for a long debugging session, as
> she will be expecting to read 'ingress_ifindex', but will be getting
> 'egress_ifindex'.  (As the compiler cannot warn her, and it is also
> correct seen from the verifier).

+1 on this; also, an egress program may want to actually know which
ingress iface the packet was first received on. So why not just keep
both fields? Since ifindex 0 is invalid anyway, the field could just be
0 when it isn't known (e.g., egress ifindex on RX, or ingress ifindex if
it comes from the stack)?

>>  	__u32 rx_queue_index;  /* rxq->queue_index  */
>
> So, the TX program can still read 'rx_queue_index', is this wise?

Why shouldn't it be able to (as well as ingress ifindex)?

-Toke

