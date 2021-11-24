Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744F645C72D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351673AbhKXO0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:26:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353576AbhKXOZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 09:25:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637763723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TLRi7BlITjjM/i+4EHGp/lwGEMw5CmrBYwLEApBpecM=;
        b=T+ykU8t46fV+xrf3SMGoh/DAA861ozWF2WywBgWnFKJUMbAXaDVzHWhSnBQxXaYMb2A90W
        kQk5kjI5fJ/xf0vwnjqOs8T/xUz5s6Ml/vYTQNKmBMpF8ZVeYI55Rk9vL3y+/RW5NTbnQG
        kqP9+55gqZbsiXFhYfnLEThPyKsZthI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-fs400FZ6MvKXrNnBYcUuyw-1; Wed, 24 Nov 2021 09:21:59 -0500
X-MC-Unique: fs400FZ6MvKXrNnBYcUuyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31BB61800D41;
        Wed, 24 Nov 2021 14:21:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A602119C46;
        Wed, 24 Nov 2021 14:21:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20211121041608.133740-1-eiichi.tsukata@nutanix.com>
References: <20211121041608.133740-1-eiichi.tsukata@nutanix.com>
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1819849.1637763715.1@warthog.procyon.org.uk>
Date:   Wed, 24 Nov 2021 14:21:55 +0000
Message-ID: <1819850.1637763715@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good, though I think a better way to do both of these cases is to
abstract out the freeing sequence into its own function.

David

