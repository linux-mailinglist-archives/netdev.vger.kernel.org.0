Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1CB39DA16
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 12:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhFGKuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 06:50:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230215AbhFGKuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 06:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623062902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jct5jDPBwVGouvEG6T9uxDTmUAeintJpH2Ni5SzlADU=;
        b=Xg70oxEoKxfY7hRgCQxPLZb0GSGGxb8g0f5kIwjRd3DF5oNJnq4SWz/7z3D5E44MiLVQEI
        mWrxPzAVA674IdFx91YwTPm9Pyz2DSXWS0eRNMJ1iS4GEAPSxeg09nCHCvUamHEimdOkZx
        mfaVGBEEbHYmgZ1q1ANzvXusohcRE/k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-JdXUxe25P2C43wSEnJuJdw-1; Mon, 07 Jun 2021 06:48:21 -0400
X-MC-Unique: JdXUxe25P2C43wSEnJuJdw-1
Received: by mail-ed1-f72.google.com with SMTP id y7-20020aa7ce870000b029038fd7cdcf3bso9071498edv.15
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 03:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jct5jDPBwVGouvEG6T9uxDTmUAeintJpH2Ni5SzlADU=;
        b=l7riruYZAfj5SjazbZLvPYM5yT2n6KEE5Or84/q5CTuo2n4QINzmoQ9m8M9VF0aQs5
         FW+9k2apg1e3iSH+gI07zKJf8TOkLuC0bePy2bgGtvELLD1XC2/WOQcY0gGx6yiw5kAY
         l6hKUh38zHZkvfcDf+zLbbmE/xGbk+ytLZvUjKMDSOxOQ21HYOnHY5cbgKdvAXTCYWos
         nrher8xknx8Vi68hQ8OBV6ZlSQbTPzoO0GUa25weTVN1QtAvQFVzd7jzhSkHnICEqFbD
         B3Nvxh9tpmv/EAmun+KN/FpMjpIsvo0A1SSE4ZI9Ex6jR+v3EtgmjxsoLoqTsj+Y+VVB
         ftIQ==
X-Gm-Message-State: AOAM532gw5MLRN7cXK2Z9GVTrZZEp9uZEUuTYL5d7Iu5awxeYHJPgIX/
        OBIit7Re7dxobAoGPffJIumjoN3avUbhrVzxP1L1sy+T62smhQwPggJ5AAWzWOSQMqAmtK+RQ79
        0m5V+bZSDMwxaldRU
X-Received: by 2002:a17:906:4483:: with SMTP id y3mr12066334ejo.92.1623062900058;
        Mon, 07 Jun 2021 03:48:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwizncCzZX0wXobce1qloNdamnSpU1qN9Pao+WfbZkPsVt7Cu+4dW5Cnsjng8anwUO8txGDTw==
X-Received: by 2002:a17:906:4483:: with SMTP id y3mr12066316ejo.92.1623062899816;
        Mon, 07 Jun 2021 03:48:19 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id bc4sm7385200edb.63.2021.06.07.03.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 03:48:19 -0700 (PDT)
Date:   Mon, 7 Jun 2021 12:48:16 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [MASSMAIL KLMS] Re: [PATCH v10 04/18] af_vsock: implement
 SEQPACKET receive loop
Message-ID: <20210607104816.fgudxa5a6pldkqts@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191611.1271204-1-arseny.krasnov@kaspersky.com>
 <20210604150638.rmx262k4wjmp2zob@steredhat>
 <93254e99-1cf9-3135-f1c8-d60336bf41b5@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <93254e99-1cf9-3135-f1c8-d60336bf41b5@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 09:00:14PM +0300, Arseny Krasnov wrote:
>
>On 04.06.2021 18:06, Stefano Garzarella wrote:
>> On Thu, May 20, 2021 at 10:16:08PM +0300, Arseny Krasnov wrote:
>>> Add receive loop for SEQPACKET. It looks like receive loop for
>>> STREAM, but there are differences:
>>> 1) It doesn't call notify callbacks.
>>> 2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>>>   there is no sense for these values in SEQPACKET case.
>>> 3) It waits until whole record is received or error is found during
>>>   receiving.
>>> 4) It processes and sets 'MSG_TRUNC' flag.
>>>
>>> So to avoid extra conditions for two types of socket inside one loop, two
>>> independent functions were created.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>> v9 -> v10:
>>> 1) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>>>
>>> include/net/af_vsock.h   |  4 +++
>>> net/vmw_vsock/af_vsock.c | 72 +++++++++++++++++++++++++++++++++++++++-
>>> 2 files changed, 75 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>> index b1c717286993..5175f5a52ce1 100644
>>> --- a/include/net/af_vsock.h
>>> +++ b/include/net/af_vsock.h
>>> @@ -135,6 +135,10 @@ struct vsock_transport {
>>> 	bool (*stream_is_active)(struct vsock_sock *);
>>> 	bool (*stream_allow)(u32 cid, u32 port);
>>>
>>> +	/* SEQ_PACKET. */
>>> +	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>>> +				     int flags, bool *msg_ready);
>>> +
>>> 	/* Notification. */
>>> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>>> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index c4f6bfa1e381..aede474343d1 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -1974,6 +1974,73 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>>> 	return err;
>>> }
>>>
>>> +static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>> +				     size_t len, int flags)
>>> +{
>>> +	const struct vsock_transport *transport;
>>> +	bool msg_ready;
>>> +	struct vsock_sock *vsk;
>>> +	ssize_t record_len;
>>> +	long timeout;
>>> +	int err = 0;
>>> +	DEFINE_WAIT(wait);
>>> +
>>> +	vsk = vsock_sk(sk);
>>> +	transport = vsk->transport;
>>> +
>>> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>>> +	msg_ready = false;
>>> +	record_len = 0;
>>> +
>>> +	while (1) {
>>> +		ssize_t fragment_len;
>>> +
>>> +		if (vsock_wait_data(sk, &wait, timeout, NULL, 0) <= 0) {
>>> +			/* In case of any loop break(timeout, signal
>>> +			 * interrupt or shutdown), we report user that
>>> +			 * nothing was copied.
>>> +			 */
>>> +			err = 0;
>> Why we report that nothing was copied?
>>
>> What happen to the bytes already copied in `msg`?
>Seems i need to return result of vsock_wait_data()...

I'm not sure.

My biggest concern is if we reach timeout or get a signal while waiting 
for the other pieces of a message.
I believe that we should not start copying a message if we have not 
received all the fragments. Otherwise we have this problem.

When we are sure that we have all the pieces, then we should copy them 
without interrupting.

IIRC this was done in previous versions.

Stefano

