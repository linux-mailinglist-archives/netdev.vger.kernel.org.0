Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B983568D556
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 12:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjBGLXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 06:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjBGLXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 06:23:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEFA40D0
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 03:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675768958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lpL7xLToQHaBruNrQ6jvsEn58M8HRkbgtnnVi3id2K4=;
        b=N8v1es2o18oR1p2tb93tn7c6okT8h9lTHbEPqiy2ETZahqwLz0Ei8Ki4fE/M6ZFf4nmj+P
        7IcCMN2wHFxN6p5/B0uvXk4TthOAyDUz7oGM6QHfr5A2He/j/7oSWrgyabRjRUHeKnNlX2
        /Ug7JGoHoaaLcsgvwBOmpZdjTTRDC1Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-8KJiM5dqOcSw9QMgXaFCCA-1; Tue, 07 Feb 2023 06:22:35 -0500
X-MC-Unique: 8KJiM5dqOcSw9QMgXaFCCA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5504D101A52E;
        Tue,  7 Feb 2023 11:22:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97886492C3C;
        Tue,  7 Feb 2023 11:22:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000b0b3c005f3a09383@google.com>
References: <000000000000b0b3c005f3a09383@google.com>
To:     syzbot <syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        hch@lst.de, jhubbard@nvidia.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in skb_dequeue (3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3104640.1675768952.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 07 Feb 2023 11:22:32 +0000
Message-ID: <3104641.1675768952@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
fs.git/ iov-fixes

