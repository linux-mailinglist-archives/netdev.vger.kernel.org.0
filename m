Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDFC11571A
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfLFSW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:22:29 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726298AbfLFSW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:22:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575656548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9bQxPX5g7KHI64B8CGZrdlw7eiv5pMYXWRe5KxLnL5I=;
        b=BtlU3evSnvJqpteL2W0ziWWajBMY/cJmvCUd2QZwGk8G/ldc0jDkiAO91/3UC8jpLlXq50
        P9gF/Iy+L31CG3GQJa49rdprfwqG1pLoV5NQbzumFIR3rIg9Ojb9IL1H4mAyMMIrXOYfqz
        zljl73GjM9YjRWx5Kg4CpYmTp5BEthE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-5Z7ZDyyzNo6IMU7s5B0v7g-1; Fri, 06 Dec 2019 13:22:25 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 836C71005513;
        Fri,  6 Dec 2019 18:22:23 +0000 (UTC)
Received: from ovpn-117-234.ams2.redhat.com (ovpn-117-234.ams2.redhat.com [10.36.117.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E1065D9C9;
        Fri,  6 Dec 2019 18:22:21 +0000 (UTC)
Message-ID: <28a8318ed78e64213abfe85e105ee6c2a1bdb3aa.camel@redhat.com>
Subject: Re: [PATCH net] net: avoid an indirect call in ____sys_recvmsg()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@aculab.com>
Date:   Fri, 06 Dec 2019 19:22:21 +0100
In-Reply-To: <20191206173836.34294-1-edumazet@google.com>
References: <20191206173836.34294-1-edumazet@google.com>
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 5Z7ZDyyzNo6IMU7s5B0v7g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-12-06 at 09:38 -0800, Eric Dumazet wrote:
> CONFIG_RETPOLINE=y made indirect calls expensive.
> 
> gcc seems to add an indirect call in ____sys_recvmsg().
> 
> Rewriting the code slightly makes sure to avoid this indirection.
> 
> Alternative would be to not call sock_recvmsg() and instead
> use security_socket_recvmsg() and sock_recvmsg_nosec(),
> but this is less readable IMO.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: David Laight <David.Laight@aculab.com>

I'm not sure this is -net material, but the code LGTM.

Acked-by: Paolo Abeni <pabeni@redhat.com>

