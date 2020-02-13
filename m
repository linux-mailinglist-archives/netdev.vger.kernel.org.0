Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4EF15BBD7
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgBMJlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:41:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29894 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729440AbgBMJlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 04:41:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581586896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5JKRWnfxJugcu55fA9SxnrV0qMAm2JbONQMP0djwNMY=;
        b=dTMm1XG8VTgoEfiK+50+OJhdOM8DOQ28BLJhZfyU6uPJkxtVpw/gon1CLQ3e7shbKFNI7m
        XnlOP6LfEm+npSkFsKstqq5oJsuAQruvHgNrBtUBeXZVspGEo0GAi48tChHr6DLklXHJzS
        T1oxuzX22ymOQQvF6OBiMs455z0io/k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-CRKrmgYNM4ml87qihqcVfg-1; Thu, 13 Feb 2020 04:41:34 -0500
X-MC-Unique: CRKrmgYNM4ml87qihqcVfg-1
Received: by mail-wm1-f69.google.com with SMTP id p2so1776350wmi.8
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 01:41:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5JKRWnfxJugcu55fA9SxnrV0qMAm2JbONQMP0djwNMY=;
        b=fNZFbdXZGsnhhz7Gp+W0BfQG8hE/rCY9blaAItutm62+cZ0x3zkLKrLY41g5kZ+vn8
         rcjvPWqRcHIbDbvrZLRh9ed9SF1uqrlfbel7IIN3WilNuXpIEf3eJcUk/eINeTFwjvg4
         s6IDIFA2JHQfgth93jwapMPapJ1dTKv7wS23VkWI04KcO540MkWWrmcrg48ezsaCKF8z
         AOU2/hMuTsGzBqYKoGm49YpFpxXT+a6xarnSDgbBMDyYwYQ4la0KB6IU7MCV2zwAf8gc
         83wks8TyYic3vsX+8lRelwxyijhCuue7ALtwpqf6UHwhuLDFQI2qqhngnuklx/72lpJk
         yGpQ==
X-Gm-Message-State: APjAAAVqbwu8Dv/AS6nPvPeQgU/QW4paD2bp9h56gtHLjtLir2usoqxZ
        jFn4HWIEa5/wJd5Liq/R7P4Z12tk94bLFwDQw3jqLk+vDuxysuRJgf1qRs61Wqec3B/y/2h8LRi
        3ZR7/hFixuNH+wyQD
X-Received: by 2002:adf:cd11:: with SMTP id w17mr21917774wrm.66.1581586893438;
        Thu, 13 Feb 2020 01:41:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqwEg5COjDKYMTaHlUQGIXaFgNKrIH/GS5nzVma9zpDJqzgM8iTUlVitR2VHHCwpIFRZ7pS6iw==
X-Received: by 2002:adf:cd11:: with SMTP id w17mr21917736wrm.66.1581586893160;
        Thu, 13 Feb 2020 01:41:33 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id 18sm2323659wmf.1.2020.02.13.01.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 01:41:32 -0800 (PST)
Date:   Thu, 13 Feb 2020 10:41:30 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] net: virtio_vsock: Fix race condition between bind and
 listen
Message-ID: <20200213094130.vehzkr4a3pnoiogr@steredhat>
References: <668b0eda8823564cd604b1663dc53fbaece0cd4e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <668b0eda8823564cd604b1663dc53fbaece0cd4e.camel@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sebastien,

On Thu, Feb 13, 2020 at 09:16:11AM +0000, Boeuf, Sebastien wrote:
> From 2f1276d02f5a12d85aec5adc11dfe1eab7e160d6 Mon Sep 17 00:00:00 2001
> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Date: Thu, 13 Feb 2020 08:50:38 +0100
> Subject: [PATCH] net: virtio_vsock: Fix race condition between bind and listen
> 
> Whenever the vsock backend on the host sends a packet through the RX
> queue, it expects an answer on the TX queue. Unfortunately, there is one
> case where the host side will hang waiting for the answer and will
> effectively never recover.

Do you have a test case?

In the host, the af_vsock.c:vsock_stream_connect() set a timeout, so if
the host try to connect before the guest starts listening, the connect()
should return ETIMEDOUT if the guest does not answer anything.

Anyway, maybe the patch make sense anyway, changing a bit the description
(if the host connect() receive the ETIMEDOUT).
I'm just concerned that this code is common between guest and host. If a
malicious guest starts sending us wrong requests, we spend time sending
a reset packet. But we already do that if we can't find the bound socket,
so it might make sense.

Thanks,
Stefano

> 
> This issue happens when the guest side starts binding to the socket,
> which insert a new bound socket into the list of already bound sockets.
> At this time, we expect the guest to also start listening, which will
> trigger the sk_state to move from TCP_CLOSE to TCP_LISTEN. The problem
> occurs if the host side queued a RX packet and triggered an interrupt
> right between the end of the binding process and the beginning of the
> listening process. In this specific case, the function processing the
> packet virtio_transport_recv_pkt() will find a bound socket, which means
> it will hit the switch statement checking for the sk_state, but the
> state won't be changed into TCP_LISTEN yet, which leads the code to pick
> the default statement. This default statement will only free the buffer,
> while it should also respond to the host side, by sending a packet on
> its TX queue.
> 
> In order to simply fix this unfortunate chain of events, it is important
> that in case the default statement is entered, and because at this stage
> we know the host side is waiting for an answer, we must send back a
> packet containing the operation VIRTIO_VSOCK_OP_RST.
> 
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index e5ea29c6bca7..909334d58328 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1143,6 +1143,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>  		virtio_transport_free_pkt(pkt);
>  		break;
>  	default:
> +		(void)virtio_transport_reset_no_sock(t, pkt);
>  		virtio_transport_free_pkt(pkt);
>  		break;
>  	}
> -- 
> 2.20.1
> 
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris, 
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

