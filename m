Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FDE653449
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 17:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiLUQpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 11:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiLUQpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 11:45:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00129240AF
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 08:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671641056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQSSP2hgK7QhzoTBEOr4tLIKUv+ZUyOrvkmMLjF5JNQ=;
        b=eVopJpVqTWkhOW51ew/Zd2zqX71hJiti/1zr9RJliSKneifZViXSIWjFDNhXSpy5VcWQKk
        OPH4kWU/06wQBVbZrwiEFVs74Rn0tzH3ML2GZFjAj6IZRzPJAlXe4PBpDiOOFQdx/8ZCIj
        Id+cT0JKma55jC8B369EOTNtRM3czj4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-aF8S0HHYNqGhf_-bXwlfng-1; Wed, 21 Dec 2022 11:44:10 -0500
X-MC-Unique: aF8S0HHYNqGhf_-bXwlfng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D6601818E46;
        Wed, 21 Dec 2022 16:44:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11900112132D;
        Wed, 21 Dec 2022 16:43:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000002b4a9f05ef2b616f@google.com>
References: <0000000000002b4a9f05ef2b616f@google.com>
To:     syzbot <syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel BUG in rxrpc_put_peer
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2062618.1671641039.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 21 Dec 2022 16:43:59 +0000
Message-ID: <2062619.1671641039@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-=
fs.git/ 97f46a2a6f87e97634b3179190dbb5d947f03bd6

