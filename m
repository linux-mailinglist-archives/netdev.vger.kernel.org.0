Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FE1341A7D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhCSKxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:53:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhCSKxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 06:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616151229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZKmkfpELKOIfrrg3sipNKiMhmGIwV6YWhjJTDK8P9kc=;
        b=Xo0HyMQvlJVKjlM2xKUf2HeMRzSirbxy1LaivqJZbRDBfJIsGGg7hxtphHD1E8OuZUQxHq
        z8j/TGEypUmkEbCCzK3dqOhpKw3WzWZOvzfAHt45eeYKGM+sT5w0euKKDpcx34DqMWSy3V
        ABgmDvjj4Lcizh06cd7waPmeQbaMifE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-RFiH3Q6fM7-BFsR8kmZsmA-1; Fri, 19 Mar 2021 06:53:47 -0400
X-MC-Unique: RFiH3Q6fM7-BFsR8kmZsmA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 425025B362;
        Fri, 19 Mar 2021 10:53:46 +0000 (UTC)
Received: from ovpn-112-226.ams2.redhat.com (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB7C05D9F2;
        Fri, 19 Mar 2021 10:53:43 +0000 (UTC)
Message-ID: <1ebd301832ff86cc414dd17eee0b3dfc91ff3c08.camel@redhat.com>
Subject: Re: [PATCH net-next 2/4] gro: add combined call_gro_receive() +
 INDIRECT_CALL_INET() helper
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 19 Mar 2021 11:53:42 +0100
In-Reply-To: <20210318184157.700604-3-alobakin@pm.me>
References: <20210318184157.700604-1-alobakin@pm.me>
         <20210318184157.700604-3-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2021-03-18 at 18:42 +0000, Alexander Lobakin wrote:
> call_gro_receive() is used to limit GRO recursion, but it works only
> with callback pointers.
> There's a combined version of call_gro_receive() + INDIRECT_CALL_2()
> in <net/inet_common.h>, but it doesn't check for IPv6 modularity.

AFAICS, ip6_offload is builtin even when IPv6 is a module, so the above
should not be needed.

Cheers,

Paolo

