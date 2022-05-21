Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530ED52F9B0
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 09:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbiEUH1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 03:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239723AbiEUH07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 03:26:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA08C59BB1
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653118016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hSV8xdTtoZicP5dxKU003xS7Nq8DX7sZpRoZ3HyTw7k=;
        b=NV2eJ2xftOXReIHerGd+SQ9AsTbAQ6dHGRjLqhyGAo8Gv7PQgQCIQTxA0XmKVsP2lpV6JE
        cEAFZgOz/CtyhW9bXUpf0qr4c0p3PO5mS6JNaChm/xVk2fyGKSvoAfA9B0LxjRbxcwX/GU
        Hj9q8zU8wNjyALE1z0vNB7OiNig8VeA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-WWf0tMTvMImep9URp11lRg-1; Sat, 21 May 2022 03:26:52 -0400
X-MC-Unique: WWf0tMTvMImep9URp11lRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E91B1811E75;
        Sat, 21 May 2022 07:26:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CDBE7ADD;
        Sat, 21 May 2022 07:26:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220520181118.47ca2bdc@kernel.org>
References: <20220520181118.47ca2bdc@kernel.org> <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk> <165306517397.34989.14593967592142268589.stgit@warthog.procyon.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] rxrpc: Fix locking issue
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <207585.1653118010.1@warthog.procyon.org.uk>
Date:   Sat, 21 May 2022 08:26:50 +0100
Message-ID: <207586.1653118010@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> > +	lh = rcu_dereference(((struct list_head *)v)->next);
> 
> Can we use list_next_rcu() here maybe ? to avoid the sparse warning?

Sure.

David

