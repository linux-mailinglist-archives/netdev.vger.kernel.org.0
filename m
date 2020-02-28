Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF271734F8
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgB1KH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:07:29 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726400AbgB1KH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 05:07:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582884448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x3nIZYyHRwjgVCN0fRIt/epG5+cWjuMEZR17KuclG0Q=;
        b=DHKE7mCOgqg93FOz0z9uAiAJLxN4ronj3SbO+l4yGPnJT7+hqiepsNaUZhn807kh6AUUb7
        xDQ70tSe/KWS3XCbEiovfv/Xvx2UhO8qJR+zbBhiUdsMR5QQF/JEvKj1REqbRJzDGvqP6h
        J+7+GlKXtZZiVg50jCr4dfD02apea8A=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-56bIGKHaMnSoH4nsNX0idw-1; Fri, 28 Feb 2020 05:07:26 -0500
X-MC-Unique: 56bIGKHaMnSoH4nsNX0idw-1
Received: by mail-lf1-f71.google.com with SMTP id r24so335421lfi.23
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 02:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x3nIZYyHRwjgVCN0fRIt/epG5+cWjuMEZR17KuclG0Q=;
        b=OR+XXGXoob/Sh1A13h51YgH9cxeDwfbeoEG+9VyU71ff2k7B/attrlmJ5ly3fwtlJC
         JnXZZ+kJ6fYxW2xGZqob5PSFcGPAUUxlRvbIgUqp1+8xuxy9DQ1zTyjYl3/9LxXLcr7i
         NVC+kX9KSVmujiIemSqjoXK/+uTWoQrouuilWYNya6uThnoqoy12SHivYNgI88KJ61Vz
         PRc+oipezlpVJQijfMnA/hNZxmr1ON2B4tJZwnsPZ1Ryo7d/XjyNocWmfPx4eeAhbj8a
         x2K4fjYfUGx/HC1Y03FK8pFdlQsk4bQtxeQmD5fjOws6qgrJkFGgxwT9Id7aU+7aQybo
         Wwqg==
X-Gm-Message-State: ANhLgQ1MBw/Xuf9R7iXPBctx/wni1jyrLR1gQmr4dI4Hf7B7d1D5pjn4
        Q6AK6pkyxAwiD5nd7M6uI6ogIfanoIgI7Z5SHnctwIIBv9f/7kWuvIbZFYoQ234spZzM3/pmIjj
        2U6zwz7O0gN3AB1Gr
X-Received: by 2002:ac2:4199:: with SMTP id z25mr2316383lfh.26.1582884445471;
        Fri, 28 Feb 2020 02:07:25 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvo8zspabqgGUbifWUIBjEzbI4/IzZyInyem7IRlU19R4VWXWHEEqcvBWwPPZ4StjeC7NDAew==
X-Received: by 2002:ac2:4199:: with SMTP id z25mr2316362lfh.26.1582884445226;
        Fri, 28 Feb 2020 02:07:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k1sm5243889lji.43.2020.02.28.02.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 02:07:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 89142180362; Fri, 28 Feb 2020 11:07:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dahern@digitalocean.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH RFC v4 bpf-next 03/11] xdp: Add xdp_txq_info to xdp_buff
In-Reply-To: <423dd8d6-6e84-01d4-c529-ce85d84fa24b@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org> <20200227032013.12385-4-dsahern@kernel.org> <20200227090046.3e3177b3@carbon> <423dd8d6-6e84-01d4-c529-ce85d84fa24b@digitalocean.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Feb 2020 11:07:23 +0100
Message-ID: <87o8tjuisk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dahern@digitalocean.com> writes:

> On 2/27/20 1:00 AM, Jesper Dangaard Brouer wrote:
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 7850f8683b81..5e3f8aefad41 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -3334,8 +3334,10 @@ struct xdp_md {
>>>  	__u32 data;
>>>  	__u32 data_end;
>>>  	__u32 data_meta;
>>> -	/* Below access go through struct xdp_rxq_info */
>>> -	__u32 ingress_ifindex; /* rxq->dev->ifindex */
>>> +	union {
>>> +		__u32 ingress_ifindex; /* rxq->dev->ifindex */
>>> +		__u32 egress_ifindex;  /* txq->dev->ifindex */
>>> +	};
>> 
>> Are we sure it is wise to "union share" (struct) xdp_md as the
>> XDP-context in the XDP programs, with different expected_attach_type?
>> As this allows the XDP-programmer to code an EGRESS program that access
>> ctx->ingress_ifindex, this will under the hood be translated to
>> ctx->egress_ifindex, because from the compilers-PoV this will just be an
>> offset.
>> 
>> We are setting up the XDP-programmer for a long debugging session, as
>> she will be expecting to read 'ingress_ifindex', but will be getting
>> 'egress_ifindex'.  (As the compiler cannot warn her, and it is also
>> correct seen from the verifier).
>
> It both cases it means the device handling the packet. ingress_ifindex
> == device handling the Rx, egress_ifindex == device handling the Tx.
> Really, it is syntactic sugar for program writers. It would have been
> better had xdp_md only called it ifindex from the beginning.

Telling users that they are doing it wrong is not going to make their
debugging session any less frustrating :)

If we keep rx_ifindex a separate field we can unambiguously reject a TX
program that tries to access it, *and* we keep the option of allowing
access to it later if it does turn out to be useful. IMO that is worth
the four extra bytes.

-Toke

