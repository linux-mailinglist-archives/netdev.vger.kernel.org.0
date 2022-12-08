Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131CA64715D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiLHOKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLHOKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:10:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369B298553
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 06:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670508576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oZtCHUdd8tSE9c22CbF61WHR1tSh1WdmWUuf8KqltGM=;
        b=HpVDeBJWtmEVFWJ7OjfeBYTq9gRQw9u5E7AzrWjjS3sfhTPmuiUts3/7BtXGfW2MsTHsSh
        BTt+5D9gK8a6kPee2OokUAATi7oqH3+ZkYPZdZA2g6oOaGhTaPROS8ZQdsmBJxHUSMOy2m
        DKBd68DDki26qjScMNYcMJz6n4tEAxw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-4BhQb673OnSj_oPcYdxBJQ-1; Thu, 08 Dec 2022 09:09:33 -0500
X-MC-Unique: 4BhQb673OnSj_oPcYdxBJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7EC62A5955C;
        Thu,  8 Dec 2022 14:09:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CBE840C2064;
        Thu,  8 Dec 2022 14:09:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <00000000000017ace905ef2b739d@google.com>
References: <00000000000017ace905ef2b739d@google.com>
To:     syzbot <syzbot+1eb4232fca28c0a6d1c2@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in rxrpc_destroy_all_locals
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1805057.1670508568.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 08 Dec 2022 14:09:28 +0000
Message-ID: <1805058.1670508568@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-=
fs.git/ afs-testing

