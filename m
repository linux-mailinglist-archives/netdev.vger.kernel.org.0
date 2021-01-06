Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075952EC41D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 20:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbhAFTqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 14:46:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbhAFTp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 14:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609962273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1lr4fQnCHk4FF9AJMacMIxp8d7Bz3v3LWs69ph+6fLo=;
        b=M5XZesfsQ242iGdP8lwUN4v4UU700lr7G6BSGv9qO5qmQqobIeBZLj20ly1aQ90mmy5xbu
        Usd8kwEkujgkMzGQNzAjHFdYjBKdkDjih4K4zeiDkiUsQmzPIVPOTqtESeamf5f+pjDon3
        qF6w8640dCfJ5islYJy4QhyP76SaH5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-sX2NYikEPwyWBe0XD4g2og-1; Wed, 06 Jan 2021 14:44:32 -0500
X-MC-Unique: sX2NYikEPwyWBe0XD4g2og-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D98910054FF;
        Wed,  6 Jan 2021 19:44:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D54860BFA;
        Wed,  6 Jan 2021 19:44:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <f02bdada-355c-97cd-bc32-f84516ddd93f@redhat.com>
References: <f02bdada-355c-97cd-bc32-f84516ddd93f@redhat.com> <548097.1609952225@warthog.procyon.org.uk> <c2cc898d-171a-25da-c565-48f57d407777@redhat.com> <20201229173916.1459499-1-trix@redhat.com> <259549.1609764646@warthog.procyon.org.uk> <675150.1609954812@warthog.procyon.org.uk>
To:     Tom Rix <trix@redhat.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] rxrpc: fix handling of an unsupported token type in rxrpc_read()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <697466.1609962267.1@warthog.procyon.org.uk>
Date:   Wed, 06 Jan 2021 19:44:27 +0000
Message-ID: <697467.1609962267@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:

> These two loops iterate over the same data, i believe returning here is all
> that is needed.

But if the first loop is made to support a new type, but the second loop is
missed, it will then likely oops.  Besides, the compiler should optimise both
paths together.

David

