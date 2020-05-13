Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85C61D1475
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbgEMNR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:17:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27759 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387710AbgEMNR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589375877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uvCkRI/K32PIBqaQ7LcOfghe4diMRxEm5e5JsVQlwss=;
        b=QSsayEV4hsn+RkiKYSWzBlNSmpl0HhPjcwU69qH2To92aOaEnfKqOmAbQfFPtz0362nk0f
        c/tr3Z43oCSA9Aw42wwMEZKE3y4UyF2IWuNzvqU/8LKcgmGZh19Q6LeSBFj4ctdttE3gXf
        JCRArBt5F0gIfjglFgS+mYiuRSfJauM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-9T7X1SL4M7u16KqBfljjIQ-1; Wed, 13 May 2020 09:17:52 -0400
X-MC-Unique: 9T7X1SL4M7u16KqBfljjIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53C148014C0;
        Wed, 13 May 2020 13:17:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-59.rdu2.redhat.com [10.10.112.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8A53610F2;
        Wed, 13 May 2020 13:17:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200513062649.2100053-22-hch@lst.de>
References: <20200513062649.2100053-22-hch@lst.de> <20200513062649.2100053-1-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 21/33] ipv4: add ip_sock_set_mtu_discover
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3123897.1589375861.1@warthog.procyon.org.uk>
Date:   Wed, 13 May 2020 14:17:41 +0100
Message-ID: <3123898.1589375861@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> +		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
> +				IP_PMTUDISC_DONT);

Um... The socket in question could be an AF_INET6 socket, not an AF_INET4
socket - I presume it will work in that case.  If so:

Reviewed-by: David Howells <dhowells@redhat.com> [rxrpc bits]

