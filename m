Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0AE68DA59
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjBGOR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbjBGORz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:17:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3042037B57
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675779427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lpL7xLToQHaBruNrQ6jvsEn58M8HRkbgtnnVi3id2K4=;
        b=F2JJLy1tkU+vgeedReaUjjtOGq8Ja72T7xX40PqkFoGOU2gc8BAlcshy3997mwlT7c/fmM
        dxiPaJ+UNLDTxhih1sfZ6HKul0k8CHXE6PXCMi6SZ/WRfdhevAC5alYWGl1hVnO6lKV/3Q
        pdFbaxXPvZ6Z9ENN42mNIoT/8Jj4U5U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-y6inOOzKPJ-AGvu0rgAPAQ-1; Tue, 07 Feb 2023 09:17:04 -0500
X-MC-Unique: y6inOOzKPJ-AGvu0rgAPAQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C6C085A588;
        Tue,  7 Feb 2023 14:17:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23100492C3F;
        Tue,  7 Feb 2023 14:17:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000003a78a905f4049614@google.com>
References: <0000000000003a78a905f4049614@google.com>
To:     syzbot <syzbot+c0998868487c1f7e05e5@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, bpf@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, hch@lst.de,
        jhubbard@nvidia.com, kuba@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, npiggin@gmail.com, pabeni@redhat.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        will@kernel.org
Subject: Re: [syzbot] kernel BUG in process_one_work
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3151683.1675779419.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 07 Feb 2023 14:16:59 +0000
Message-ID: <3151684.1675779419@warthog.procyon.org.uk>
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

