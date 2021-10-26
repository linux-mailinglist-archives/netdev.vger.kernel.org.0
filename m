Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C2843B0FC
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbhJZLUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:20:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235492AbhJZLUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 07:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635247087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rGwdwajHmPeO4BJPz1S3ZGt6jC32SKD30PM7BnISZb8=;
        b=P1JnKbr6ODErY2iBpXTzLKReArxxx0ZV6OMdMXReSEa6lbEGOh1t08Ho0quMsx9r6IsgvV
        wwB5Ux8SKecPAV2RiIYQiF+aj2CDe04VVAh2erO76BzZNw1iaWTjeOWzN+zBJYS1HUS/du
        hq2iun7XQ6N17AQvxalolxjQxXvjCdk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-IDqH6U0MMPGJ9ALQ8Hp0SQ-1; Tue, 26 Oct 2021 07:18:06 -0400
X-MC-Unique: IDqH6U0MMPGJ9ALQ8Hp0SQ-1
Received: by mail-ed1-f70.google.com with SMTP id g6-20020a056402424600b003dd2b85563bso10015963edb.7
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 04:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rGwdwajHmPeO4BJPz1S3ZGt6jC32SKD30PM7BnISZb8=;
        b=NK8YGBez4lFItizdlJke2UBVw45h5Kk+541dZ245GWk/SU0yLhiymL2YYeBTMxVf7r
         ZYijfG8gsDm5nbP5Sv5gIQZYBcZTtakvrtTp1efEQH28XIHQp+K3XXeZxvQflZdzm+2b
         oHasbnpjm0smKeaN04F9EVBpRti6Wpe9zNlTmGtvpHBNX1x3Dqpkw6GVvJHQEak3y5UN
         YvljqlGORtMwsx0g0fMsBzDIv8S3Iv56zZcbOMtK7xLPjtXmLmin6YNqXPkuj2MKvomA
         T/O783ZpHH9m780bimiazfpL5oTObHPE7LI0FpuA338WmTO1E3Y7QSFfLfT1hG3JqheY
         CrGw==
X-Gm-Message-State: AOAM5322767n7UrEmKgGJjyDELk4BRK/NRyS5qwNuOuE1+ZlO3wH+gbb
        HIEmQqPnQT3pyRgHMkZpW6aj7mZCJP24gnbZQd/U+fyti/+iufkfr8Bw13yTro62A5HXoogTOo2
        uxjxxkHaXiZZS8BG+
X-Received: by 2002:a17:906:7f8e:: with SMTP id f14mr29844810ejr.267.1635247085376;
        Tue, 26 Oct 2021 04:18:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcgmc28vzIaCUk+jEbgNhCEFwvjTtlbpZ3chKtHCtz4k0ZlZ2BdshPzsog8NoCkhXBRNz1EQ==
X-Received: by 2002:a17:906:7f8e:: with SMTP id f14mr29844788ejr.267.1635247085237;
        Tue, 26 Oct 2021 04:18:05 -0700 (PDT)
Received: from steredhat (host-79-30-88-77.retail.telecomitalia.it. [79.30.88.77])
        by smtp.gmail.com with ESMTPSA id y26sm3644850edv.88.2021.10.26.04.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 04:18:04 -0700 (PDT)
Date:   Tue, 26 Oct 2021 13:18:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH 06/10] vsock: set socket peercred
Message-ID: <20211026111801.vrz4ofs42udz2n52@steredhat>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
 <20211021123714.1125384-7-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211021123714.1125384-7-marcandre.lureau@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 04:37:10PM +0400, Marc-André Lureau wrote:
>When AF_VSOCK socket is created, the peercreds are set to the current
>process values.
>
>This is how AF_UNIX listen work too, but unconnected AF_UNIX sockets
>return pid:0 & uid/gid:-1.
>
>Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
>---
> net/vmw_vsock/af_vsock.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 1925682a942a..9b211ff49b08 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -760,6 +760,7 @@ static struct sock *__vsock_create(struct net *net,
>
> 	psk = parent ? vsock_sk(parent) : NULL;
> 	if (parent) {
>+		sock_copy_peercred(sk, parent);
> 		vsk->trusted = psk->trusted;
> #if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
> 		vsk->owner = get_cred(psk->owner);
>@@ -770,6 +771,7 @@ static struct sock *__vsock_create(struct net *net,
> 		vsk->buffer_max_size = psk->buffer_max_size;
> 		security_sk_clone(parent, sk);
> 	} else {
>+		sock_init_peercred(sk);

IIUC in AF_UNIX the sock_init_peercred() is called only when the 
connection is established, so I think we should do the same.

In the single transports or in some way in the core when the transports 
call vsock_insert_connected().

Thanks,
Stefano

