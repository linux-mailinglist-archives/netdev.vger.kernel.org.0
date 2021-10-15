Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDFD42F1E4
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbhJONMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:12:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239360AbhJONMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 09:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634303427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XekzSYCurNvaJV38F/1rxWtlhzRezgq5WZFyfUv+hEo=;
        b=UkCbj1MCjluHtEDuhVbh0767TUEZyfOHtmZuDyeEpdoJPaUF6kEV4lR5pew3WMTOC2WhWN
        FkaktJwkr9ybQhhb3YT+48sxJhVtdJNjHO9PcYvxV9II5qOwzD25TqGzdi1oaL983ow0L2
        5Hsq/nDQtLMMJgZcSWU72H9uJngjHoI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-XFXW22_wOPqOykQhewS9Vw-1; Fri, 15 Oct 2021 09:10:24 -0400
X-MC-Unique: XFXW22_wOPqOykQhewS9Vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C11BDF8A0;
        Fri, 15 Oct 2021 13:10:22 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC5BE6060F;
        Fri, 15 Oct 2021 13:10:19 +0000 (UTC)
Date:   Fri, 15 Oct 2021 15:10:16 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH net-next v4 15/15] mctp: Add MCTP overview document
Message-ID: <20211015131016.GA14244@asgard.redhat.com>
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
 <20210729022053.134453-16-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729022053.134453-16-jk@codeconstruct.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 10:20:53AM +0800, Jeremy Kerr wrote:
> This change adds a brief document about the sockets API provided for
> sending and receiving MCTP messages from userspace.

[...]

> diff --git a/Documentation/networking/mctp.rst b/Documentation/networking/mctp.rst

[...]

> +``bind()`` : set local socket address
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +Sockets that receive incoming request packets will bind to a local address,
> +using the ``bind()`` syscall.
> +
> +.. code-block:: C
> +
> +    struct sockaddr_mctp addr;
> +
> +    addr.smctp_family = AF_MCTP;
> +    addr.smctp_network = MCTP_NET_ANY;
> +    addr.smctp_addr.s_addr = MCTP_ADDR_ANY;
> +    addr.smctp_type = MCTP_TYPE_PLDM;

[...]

> +``sendto()``, ``sendmsg()``, ``send()`` : transmit an MCTP message
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +An MCTP message is transmitted using one of the ``sendto()``, ``sendmsg()`` or
> +``send()`` syscalls. Using ``sendto()`` as the primary example:
> +
> +.. code-block:: C
> +
> +    struct sockaddr_mctp addr;
> +    char buf[14];
> +    ssize_t len;
> +
> +    /* set message destination */
> +    addr.smctp_family = AF_MCTP;
> +    addr.smctp_network = 0;
> +    addr.smctp_addr.s_addr = 8;
> +    addr.smctp_tag = MCTP_TAG_OWNER;
> +    addr.smctp_type = MCTP_TYPE_ECHO;

While MCTP_TYPE_PLDM and MCTP_TYPE_ECHO are mentioned
in the documentation, their definition is currently missing in the UAPI
header (or anywhere in the source tree at all).  Is that expected?

