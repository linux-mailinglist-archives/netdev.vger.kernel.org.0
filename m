Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973182EC589
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbhAFVLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:11:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726195AbhAFVLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 16:11:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609967374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VKVUOawYF30jYDz4k0cRErL4TxXYOHoXtZs0psgjgU8=;
        b=ZS8fJKzL38l6YXTFzM1MNTmHRmFQtHG/inY3kH4yqs9qDT6BhuhVMZYOtRv1GKe3kzmGwI
        4Gt6uiq+IOT2vNtmcOoQ54JsYJOV3UObHlEKuFr7W4Oe9pWD/R92QAJaNJW8TSDjci6AfU
        pcw18WKWF19X9IbRN+hY9Jqo0OZnrpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187--sLbtU6GPVWn4laxrJ3vSQ-1; Wed, 06 Jan 2021 16:09:33 -0500
X-MC-Unique: -sLbtU6GPVWn4laxrJ3vSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 286DA195D560;
        Wed,  6 Jan 2021 21:09:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CA6A5C26D;
        Wed,  6 Jan 2021 21:09:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <07564e3e-35d4-c5d4-fc1a-8a0e8659604e@redhat.com>
References: <07564e3e-35d4-c5d4-fc1a-8a0e8659604e@redhat.com> <f02bdada-355c-97cd-bc32-f84516ddd93f@redhat.com> <548097.1609952225@warthog.procyon.org.uk> <c2cc898d-171a-25da-c565-48f57d407777@redhat.com> <20201229173916.1459499-1-trix@redhat.com> <259549.1609764646@warthog.procyon.org.uk> <675150.1609954812@warthog.procyon.org.uk> <697467.1609962267@warthog.procyon.org.uk>
To:     Tom Rix <trix@redhat.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] rxrpc: fix handling of an unsupported token type in rxrpc_read()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <706520.1609967368.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 06 Jan 2021 21:09:28 +0000
Message-ID: <706521.1609967368@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> On 1/6/21 11:44 AM, David Howells wrote:
> > Tom Rix <trix@redhat.com> wrote:
> >
> >> These two loops iterate over the same data, i believe returning here =
is all
> >> that is needed.
> > But if the first loop is made to support a new type, but the second lo=
op is
> > missed, it will then likely oops.  Besides, the compiler should optimi=
se both
> > paths together.
> =

> You are right, I was only considering the existing cases.

Thanks.  Can I put that down as a Reviewed-by?

David

