Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9062E30D6BA
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhBCJwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:52:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233344AbhBCJwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612345851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HclwfajtDLHqH1lOE2YNCTzXJqSZt5W9Fo2Qx7aGUB8=;
        b=C/wcFDdK9NCrUnt5R00+nE8x02ish7zYJDecFF6Rhjvh446VYvtEcP3TA0lSn9C8IGommD
        l34qCRoOc5bhr57kZt5QxXzCZUZk4jqwjPSNTaVhfjZxY4rrYvkKA1gTKXh/+mQS6FhiZM
        8GZgKyisj7E2twfWLJj+K6fGAKfaK2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-g7fDp6fNNqqty2CNmQnidg-1; Wed, 03 Feb 2021 04:50:48 -0500
X-MC-Unique: g7fDp6fNNqqty2CNmQnidg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 424CD107ACFE;
        Wed,  3 Feb 2021 09:50:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8892E71C9C;
        Wed,  3 Feb 2021 09:50:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <2da45aee43c74c05a586a7d3c7b1f9fc48bb72f2.1612342376.git.lucien.xin@gmail.com>
References: <2da45aee43c74c05a586a7d3c7b1f9fc48bb72f2.1612342376.git.lucien.xin@gmail.com> <cover.1612342376.git.lucien.xin@gmail.com> <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com> <cover.1612342376.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     dhowells@redhat.com, network dev <netdev@vger.kernel.org>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCHv5 net-next 2/2] rxrpc: call udp_tunnel_encap_enable in rxrpc_open_socket
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <707365.1612345842.1@warthog.procyon.org.uk>
Date:   Wed, 03 Feb 2021 09:50:42 +0000
Message-ID: <707366.1612345842@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:

> When doing encap_enable/increasing encap_needed_key, up->encap_enabled
> is not set in rxrpc_open_socket(), and it will cause encap_needed_key
> not being decreased in udpv6_destroy_sock().
> 
> This patch is to improve it by just calling udp_tunnel_encap_enable()
> where it increases both UDP and UDPv6 encap_needed_key and sets
> up->encap_enabled.
> 
> v4->v5:
>   - add the missing '#include <net/udp_tunnel.h>', as David Howells
>     noticed.
> 
> Acked-and-tested-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Looks good.

David

