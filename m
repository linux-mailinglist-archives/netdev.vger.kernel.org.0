Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED471341CFF
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 13:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhCSMgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 08:36:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229766AbhCSMfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 08:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616157349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sswxe4rRhgVUvSlq2Qd1m3JvsgJC65o2sDRzUfVqiS4=;
        b=PjSU4CfUPhf3W8Mt4cGNKkEEjDJw/XOGnXrDwOVoQfTLC+zDkRAfZSLmwGxaMFFB3ztn/A
        btJb+HHgMmuAW9+zBTCFy5YpSGW/ufixQV+pzzVJyPEdAGvVcln4bu9a8YJuFOuL+ZzYXI
        Hvm1nCuRSHBaukbs06VUmJd9WZLuCEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-aXZNWhFAN62xOshD1dqoig-1; Fri, 19 Mar 2021 08:35:47 -0400
X-MC-Unique: aXZNWhFAN62xOshD1dqoig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7671F87A83A;
        Fri, 19 Mar 2021 12:35:45 +0000 (UTC)
Received: from ovpn-112-226.ams2.redhat.com (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E436C5D9C6;
        Fri, 19 Mar 2021 12:35:42 +0000 (UTC)
Message-ID: <5c1fce37033e98e483728ea9879c3cf4ae83aa28.camel@redhat.com>
Subject: Re: [PATCH net-next 2/4] gro: add combined call_gro_receive() +
 INDIRECT_CALL_INET() helper
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 19 Mar 2021 13:35:41 +0100
In-Reply-To: <20210319114300.108808-1-alobakin@pm.me>
References: <20210318184157.700604-1-alobakin@pm.me>
         <20210318184157.700604-3-alobakin@pm.me>
         <1ebd301832ff86cc414dd17eee0b3dfc91ff3c08.camel@redhat.com>
         <20210319111315.3069-1-alobakin@pm.me>
         <20210319114300.108808-1-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-03-19 at 11:43 +0000, Alexander Lobakin wrote:
> I'm not sure if you did it on purpose in commit aaa5d90b395a7
> ("net: use indirect call wrappers at GRO network layer").
> Was that intentional 

I must admit that 2y+ later my own intentions are not so clear to me
too;)

> for the sake of more optimized path for the
> kernels with moduled IPv6, 

Uhm... no I guess that was more an underlook on my side.

> or I can replace INDIRECT_CALL_INET()
> with INDIRECT_CALL_2() here too? 

If that build with IPV6=nmy, I would say yes.

> I want to keep GRO callbacks that
> make use of indirect call wrappers unified.

L4 will still need some special handling as ipv6 udp gro callbacks are
not builtin with CONFIG_IPV6=m :(

Cheers,

Paolo

