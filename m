Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9611739DC5F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhFGMaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:30:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhFGMaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623068901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WRij78svS0dl3UZRgR9Pu6WvQlaTV51Ty644G95OgJI=;
        b=eR6flIbvnj3sO4ochHjg/fePwLVhSr6DxSYa+s9jrRrZJuFemf5RlL47WGBRjeo91mIyId
        z1rRL5rtFUO7T9Mf8qZDfC4bIxGTxK594/OnUzBmBVx6piJRgfJiqXIvI5H+vud0Xy3C/1
        wg0RbjpO/etg7ord2dajNhlsIw89Rjk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-W-os9HohOUODrviDaBryqA-1; Mon, 07 Jun 2021 08:28:20 -0400
X-MC-Unique: W-os9HohOUODrviDaBryqA-1
Received: by mail-ej1-f72.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso5199289ejn.10
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 05:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WRij78svS0dl3UZRgR9Pu6WvQlaTV51Ty644G95OgJI=;
        b=LmOWu8SqLjNnsZNkD4SGNb+UJeaRE80sZFUNn0wRL00WyGPIPlNmIPtx/rBR8xVWo2
         k3WR6dR2INekXgUowLLYbq437p0svA5gVmmc6i/yw3Y+QbntkNdnh71kH3a7YGfDTrW3
         vDWdpnw7NPJP0IFqIvoUgqjT6bEhLYluXDPIdDSgrY9uXyaI8XeuRNSJqrnGKLG2RVy7
         6ulBhrhlfPsV5ltZ6rOLbJ7WFUjDiHmbXWG6sO0VvSxN1olbs0UZsQNUiIFSrGm2oxGD
         oCcj4BcwUzWPWTzoK3JG2TBHrxhyDIMFO97rm3XCBYY1tQqy96kXxdsOutBfgw/AQbsX
         0bSA==
X-Gm-Message-State: AOAM532H+01UgieVoY1FCaeS5MiqGFsJL43YVCvbT9QOFtUMpE0PJdhd
        aovyoOhnO0Ak/gLDkdeV8VRp384FTUfdMpqf/TfcnoxBOBHYmcv81momhQ0zsAjvs0AFZV2eZYG
        /omxmsiHvWjmbpIOO
X-Received: by 2002:a05:6402:1e8b:: with SMTP id f11mr6855815edf.86.1623068898989;
        Mon, 07 Jun 2021 05:28:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ3ZxofwfGfhWVCp8PwP02oyvfbjO8HkBIsUJnHl308aHgTzkad+lmJfEl7kmAywsPe/MTtA==
X-Received: by 2002:a05:6402:1e8b:: with SMTP id f11mr6855790edf.86.1623068898787;
        Mon, 07 Jun 2021 05:28:18 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id w1sm6577646eds.37.2021.06.07.05.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 05:28:18 -0700 (PDT)
Date:   Mon, 7 Jun 2021 14:28:16 +0200
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
Message-ID: <20210607122816.yas4fpfmtvlrbfku@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210520191611.1271204-1-arseny.krasnov@kaspersky.com>
 <20210604150638.rmx262k4wjmp2zob@steredhat>
 <93254e99-1cf9-3135-f1c8-d60336bf41b5@kaspersky.com>
 <20210607104816.fgudxa5a6pldkqts@steredhat>
 <95a11b19-8266-7fc0-9426-edccd4512a2d@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <95a11b19-8266-7fc0-9426-edccd4512a2d@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 02:29:28PM +0300, Arseny Krasnov wrote:
>
>On 07.06.2021 13:48, Stefano Garzarella wrote:
>> On Fri, Jun 04, 2021 at 09:00:14PM +0300, Arseny Krasnov wrote:
>>> On 04.06.2021 18:06, Stefano Garzarella wrote:
>>>> On Thu, May 20, 2021 at 10:16:08PM +0300, Arseny Krasnov wrote:
>>>>> Add receive loop for SEQPACKET. It looks like receive loop for
>>>>> STREAM, but there are differences:
>>>>> 1) It doesn't call notify callbacks.
>>>>> 2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
>>>>>   there is no sense for these values in SEQPACKET case.
>>>>> 3) It waits until whole record is received or error is found during
>>>>>   receiving.
>>>>> 4) It processes and sets 'MSG_TRUNC' flag.
>>>>>
>>>>> So to avoid extra conditions for two types of socket inside one loop, two
>>>>> independent functions were created.
>>>>>
>>>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>>>> ---
>>>>> v9 -> v10:
>>>>> 1) Use 'msg_data_left()' instead of direct access to 'msg_hdr'.
>>>>>
>>>>> include/net/af_vsock.h   |  4 +++
>>>>> net/vmw_vsock/af_vsock.c | 72 +++++++++++++++++++++++++++++++++++++++-
>>>>> 2 files changed, 75 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>>>> index b1c717286993..5175f5a52ce1 100644
>>>>> --- a/include/net/af_vsock.h
>>>>> +++ b/include/net/af_vsock.h
>>>>> @@ -135,6 +135,10 @@ struct vsock_transport {
>>>>> 	bool (*stream_is_active)(struct vsock_sock *);
>>>>> 	bool (*stream_allow)(u32 cid, u32 port);
>>>>>
>>>>> +	/* SEQ_PACKET. */
>>>>> +	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>>>>> +				     int flags, bool *msg_ready);
>>>>> +
>>>>> 	/* Notification. */
>>>>> 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
>>>>> 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
>>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>>> index c4f6bfa1e381..aede474343d1 100644
>>>>> --- a/net/vmw_vsock/af_vsock.c
>>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>>> @@ -1974,6 +1974,73 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>>>>> 	return err;
>>>>> }
>>>>>
>>>>> +static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>>>> +				     size_t len, int flags)
>>>>> +{
>>>>> +	const struct vsock_transport *transport;
>>>>> +	bool msg_ready;
>>>>> +	struct vsock_sock *vsk;
>>>>> +	ssize_t record_len;
>>>>> +	long timeout;
>>>>> +	int err = 0;
>>>>> +	DEFINE_WAIT(wait);
>>>>> +
>>>>> +	vsk = vsock_sk(sk);
>>>>> +	transport = vsk->transport;
>>>>> +
>>>>> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>>>>> +	msg_ready = false;
>>>>> +	record_len = 0;
>>>>> +
>>>>> +	while (1) {
>>>>> +		ssize_t fragment_len;
>>>>> +
>>>>> +		if (vsock_wait_data(sk, &wait, timeout, NULL, 0) <= 0) {
>>>>> +			/* In case of any loop break(timeout, signal
>>>>> +			 * interrupt or shutdown), we report user that
>>>>> +			 * nothing was copied.
>>>>> +			 */
>>>>> +			err = 0;
>>>> Why we report that nothing was copied?
>>>>
>>>> What happen to the bytes already copied in `msg`?
>>> Seems i need to return result of vsock_wait_data()...
>> I'm not sure.
>>
>> My biggest concern is if we reach timeout or get a signal while waiting
>> for the other pieces of a message.
>> I believe that we should not start copying a message if we have not
>> received all the fragments. Otherwise we have this problem.
>>
>> When we are sure that we have all the pieces, then we should copy them
>> without interrupting.
>>
>> IIRC this was done in previous versions.
>
>As i remember, previous versions also returned 0, because i thought,
>that for interrupted read we can copy piece of data to user's buffer,
>but we must return that nothing copied or error. In this way user

This can also be fine, but we should remove packet form the rx_queue 
only when we are sure that we delivered the entire message.

>
>won't read part of message, because syscall returned that there is
>nothing to copy. So as i understand, it is not enough - user's buffer
>must be touched only when whole message is copied?

The important thing is to not remove packets from the rx_queue unless we 
are sure that everything went well and we are returning the entire 
message to the user.

Stefano

