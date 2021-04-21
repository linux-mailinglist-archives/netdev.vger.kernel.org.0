Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D23A366840
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbhDUJjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:39:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238519AbhDUJja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618997937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gSlikRZsUWJsx7Rq6CkgW2e557egJiXRO6RyE7OIcao=;
        b=Qm38YQluwhJMAEdAtWBP/e6A9EGkhfPp0mE628pJJwV8QOCfLaALm23TH4FcxENBjwonY2
        Zvbz7Z95hhSq/qc7y76nDgob+mDyNfMY7igdcCSU+QUYUX4nE7Q/s/l1ivomyus5vv+h+D
        DFaH3x32dDGa7jVSbjH1x4DyIqf8GTI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-DkPR7x8SPP66jemBMz9mbQ-1; Wed, 21 Apr 2021 05:38:56 -0400
X-MC-Unique: DkPR7x8SPP66jemBMz9mbQ-1
Received: by mail-ed1-f70.google.com with SMTP id w15-20020a056402268fb02903828f878ec5so14705568edd.5
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 02:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gSlikRZsUWJsx7Rq6CkgW2e557egJiXRO6RyE7OIcao=;
        b=mZYhlwbH8BNj+hM0jCnqh/0JtTA7FGPmMw0IBWS59XoCb2CjLoFtwH02WmrQUodzd3
         udNowNAF7v/clPb/KnOaeYFCm/WqYdBuUO4NrdB3KHqKbr55913zG0LRO5Lwft78NPmh
         ZwWcgbY1FyV4RCvNLpwvz0cs7owsV+3VoZWpTmGOWjely4z8TtsX/qEPFXOVwlywzJyV
         uCmfOsCWnZuTaPZd16zrKt0pMFu66frvO7xWCkCK2vaA5hH3FTQY28nBVfuxJrWrF27y
         C3lNcYd3PQUhg2z+y9vA9SDcMnDm6j7m3O2YvD8NnXqyNc/yBJdr2cAoVVLDkEWrY33j
         vCJA==
X-Gm-Message-State: AOAM532T7WjKEweYDntrUZC5606gJTwvDQze/T1qq/obYgWA6kBIxrCd
        Fe/OEXdOXKTL10Fv1mU1MaLMm5BYEDRLshsHhh3KlB9tLKVR72qlFKp/elu78Fa0CaCfBWnLQyT
        bv4BEHhONCaOeYla+
X-Received: by 2002:a17:907:76c5:: with SMTP id kf5mr31320937ejc.526.1618997934984;
        Wed, 21 Apr 2021 02:38:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIwbBRm7mr85h28m7cl7ow2IIb274l/KuCduv8M7TerEq2T8gyqF0loaor8I4gqRyLdgQpMw==
X-Received: by 2002:a17:907:76c5:: with SMTP id kf5mr31320915ejc.526.1618997934762;
        Wed, 21 Apr 2021 02:38:54 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id g11sm2506664edw.37.2021.04.21.02.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:38:54 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:38:51 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v8 19/19] af_vsock: serialize writes to shared socket
Message-ID: <20210421093851.36yazy5vp4uwimd6@steredhat>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124739.3408031-1-arseny.krasnov@kaspersky.com>
 <7d433ed9-8d4c-707a-9149-ff0e65d7f943@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7d433ed9-8d4c-707a-9149-ff0e65d7f943@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 01:51:17PM +0300, Arseny Krasnov wrote:
>
>On 13.04.2021 15:47, Arseny Krasnov wrote:
>> This add logic, that serializes write access to single socket
>> by multiple threads. It is implemented be adding field with TID
>> of current writer. When writer tries to send something, it checks
>> that field is -1(free), else it sleep in the same way as waiting
>> for free space at peers' side.
>>
>> This implementation is PoC and not related to SEQPACKET close, so
>> i've placed it after whole patchset.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>>  include/net/af_vsock.h   |  1 +
>>  net/vmw_vsock/af_vsock.c | 10 +++++++++-
>>  2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index 53d3f33dbdbf..786df80b9fc3 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -69,6 +69,7 @@ struct vsock_sock {
>>  	u64 buffer_size;
>>  	u64 buffer_min_size;
>>  	u64 buffer_max_size;
>> +	pid_t tid_owner;
>>
>>  	/* Private to transport. */
>>  	void *trans;
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 54bee7e643f4..d00f8c07a9d3 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1765,7 +1765,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>  		ssize_t written;
>>
>>  		add_wait_queue(sk_sleep(sk), &wait);
>> -		while (vsock_stream_has_space(vsk) == 0 &&
>> +		while ((vsock_stream_has_space(vsk) == 0 ||
>> +			(vsk->tid_owner != current->pid &&
>> +			 vsk->tid_owner != -1)) &&
>>  		       sk->sk_err == 0 &&
>>  		       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
>>  		       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
>> @@ -1796,6 +1798,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>  				goto out_err;
>>  			}
>>  		}
>> +
>> +		vsk->tid_owner = current->pid;
>>  		remove_wait_queue(sk_sleep(sk), &wait);
>>
>>  		/* These checks occur both as part of and after the loop
>> @@ -1852,7 +1856,10 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>  			err = total_written;
>>  	}
>>  out:
>> +	vsk->tid_owner = -1;
>>  	release_sock(sk);
>> +	sk->sk_write_space(sk);
>> +
>>  	return err;
>>  }
>>
>> @@ -2199,6 +2206,7 @@ static int vsock_create(struct net *net, struct socket *sock,
>>  		return -ENOMEM;
>>
>>  	vsk = vsock_sk(sk);
>> +	vsk->tid_owner = -1;
>This must be moved to '__vsock_create()'

Okay, I'll review the next version.

In order to backport this fix to stable branches I think is better to 
move at the beginning of this series or even out as a separate patch.

Thanks,
Stefano

>>
>>  	if (sock->type == SOCK_DGRAM) {
>>  		ret = vsock_assign_transport(vsk, NULL);
>

