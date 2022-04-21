Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F10509DC2
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388449AbiDUKjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348260AbiDUKjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:39:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9F48252B8
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 03:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650537380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CUudNcrJ1xRNDS1+KVl4Z0t857WYmRRKh3nXvmEZfk0=;
        b=jJ0MNVfEEJoWcFRJvlKJhAPnyKB8EqCP6vBBfc8WyRRzdZwPVMR8ZkeN5l3H2FBj43kW2f
        yqqnxqS6BYFpjSuv766SgqsfcWYsGZ4lFgMW4KP94WUjiwTJnTfxU46wjpAyqfT6JjUGC7
        UQcnX8OooUh6bKefREtjhXnknvTC4kY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-nLlxoeJ0O0OU8ItYH0q6RA-1; Thu, 21 Apr 2022 06:36:16 -0400
X-MC-Unique: nLlxoeJ0O0OU8ItYH0q6RA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DF5D29DD992;
        Thu, 21 Apr 2022 10:36:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C67C140F4940;
        Thu, 21 Apr 2022 10:36:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <YlySEa6QGmIHlrdG@codewreck.org>
References: <YlySEa6QGmIHlrdG@codewreck.org> <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com> <2551609.RCmPuZc3Qn@silver> <YlwOdqVCBZKFTIfC@codewreck.org> <8420857.9FB56xACZ5@silver> <YlyFEuTY7tASl8aY@codewreck.org>
To:     asmadeus@codewreck.org
Cc:     dhowells@redhat.com,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>
Subject: Re: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected))
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1050015.1650537372.1@warthog.procyon.org.uk>
Date:   Thu, 21 Apr 2022 11:36:12 +0100
Message-ID: <1050016.1650537372@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asmadeus@codewreck.org wrote:

> 	int fd = open(argv[1], O_WRONLY|O_APPEND);
> 	if (fd < 0)
> 		return 1;
> 	if (write(fd, "test\n", 5) < 0)

I think I need to implement the ability to store writes in non-uptodate pages
without needing to read from the server as NFS does.  This may fix the
performance drop also.

David

