Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7491D14A3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgEMNYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:24:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22197 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387426AbgEMNYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589376285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rZ+0Q6w2JhCJ+YHhCDkagX+ViVcqBNbrqtWBcPXjIKM=;
        b=Ev93lhdyc2zNzKYRGRHveb7cPXBOMpyh3+6zQ5kZVGjzCBPH2GA/HnqKQ4oHRkbeEK1RQ3
        gs490AEmDsH+AHqetq9z5uhQxi4GgQpxKydB3R5Ewk0Xb9fwl1JDr1TL62aniwmKtadV3T
        o2MjuFii2mdXMEL11MOgogdxtzo7s7M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-DCqVM_IQOQWxrXa72KBQkg-1; Wed, 13 May 2020 09:24:43 -0400
X-MC-Unique: DCqVM_IQOQWxrXa72KBQkg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54B0D8015CF;
        Wed, 13 May 2020 13:24:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-59.rdu2.redhat.com [10.10.112.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FF671001920;
        Wed, 13 May 2020 13:24:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200513062649.2100053-21-hch@lst.de>
References: <20200513062649.2100053-21-hch@lst.de> <20200513062649.2100053-1-hch@lst.de>
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
Subject: Re: [PATCH 20/33] ipv4: add ip_sock_set_recverr
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3124488.1589376266.1@warthog.procyon.org.uk>
Date:   Wed, 13 May 2020 14:24:26 +0100
Message-ID: <3124489.1589376266@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Add a helper to directly set the IP_RECVERR sockopt from kernel space
> without going through a fake uaccess.

It looks like if this is an AF_INET6 socket, it will just pass the message
straight through to AF_INET4, so:

Reviewed-by: David Howells <dhowells@redhat.com>

