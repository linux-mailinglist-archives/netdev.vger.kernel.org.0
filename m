Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4793B32B3D7
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840206AbhCCEHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360748AbhCBW00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 17:26:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D234A64F1D;
        Tue,  2 Mar 2021 22:25:43 +0000 (UTC)
Date:   Tue, 2 Mar 2021 17:25:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 19/19] virtio/vsock: update trace event for
 SEQPACKET
Message-ID: <20210302172542.605b3795@gandalf.local.home>
In-Reply-To: <20210218054219.1069224-1-arseny.krasnov@kaspersky.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
        <20210218054219.1069224-1-arseny.krasnov@kaspersky.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 08:42:15 +0300
Arseny Krasnov <arseny.krasnov@kaspersky.com> wrote:

Not sure if this was pulled in yet, but I do have a small issue with this
patch.

> @@ -69,14 +82,19 @@ TRACE_EVENT(virtio_transport_alloc_pkt,
>  		__entry->type = type;
>  		__entry->op = op;
>  		__entry->flags = flags;
> +		__entry->msg_len = msg_len;
> +		__entry->msg_cnt = msg_cnt;
>  	),
> -	TP_printk("%u:%u -> %u:%u len=%u type=%s op=%s flags=%#x",
> +	TP_printk("%u:%u -> %u:%u len=%u type=%s op=%s flags=%#x "
> +		  "msg_len=%u msg_cnt=%u",

It's considered poor formatting to split strings like the above. This is
one of the exceptions for the 80 character limit. Do not break strings just
to keep it within 80 characters.

-- Steve


>  		  __entry->src_cid, __entry->src_port,
>  		  __entry->dst_cid, __entry->dst_port,
>  		  __entry->len,
>  		  show_type(__entry->type),
>  		  show_op(__entry->op),
> -		  __entry->flags)
> +		  __entry->flags,
> +		  __entry->msg_len,
> +		  __entry->msg_cnt)
>  );
