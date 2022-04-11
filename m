Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1F84FB5A3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343571AbiDKIMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiDKIMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:12:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19BE3338AA
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649664636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WtRp4WO1lSj8PVjuXtMR8/dhv6hWnrFbyC+j6WCz6NI=;
        b=G7Etdj1WGs8dIcdO6AZcqEbLl82hTDbGEIKOlYMg4A12YRRgdnNCymkNW6EmXBNWpLtLH4
        jv2cVaGbW6SG2JmsHI7iaeucXXraTTSRDcvhj7yUUT9BL5YhZ+fMLbWNfZR6476FLEcU4E
        OU3OwURS1MGYUWRH0xxoHGRyW+UvnJ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-U124vjKGPJ6MlhOv5jORIg-1; Mon, 11 Apr 2022 04:10:35 -0400
X-MC-Unique: U124vjKGPJ6MlhOv5jORIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 600472A5954D;
        Mon, 11 Apr 2022 08:10:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B89F72166BDC;
        Mon, 11 Apr 2022 08:10:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1866935.Y7JIjT2MHT@silver>
References: <1866935.Y7JIjT2MHT@silver> <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com> <3791738.ukkqOL8KQD@silver> <YkTP/Talsy3KQBbf@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     dhowells@redhat.com, asmadeus@codewreck.org,
        David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1077759.1649664631.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 11 Apr 2022 09:10:31 +0100
Message-ID: <1077760.1649664631@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck <linux_oss@crudebyte.com> wrote:

> From looking at the sources, the call stack for emitting "FS-Cache: Dupl=
icate
> cookie detected" error messages with 9p "cache=3Dmmap" option seems to b=
e:

You might find these tracepoints useful:

echo 1 >/sys/kernel/debug/tracing/events/fscache/fscache_cookie/enable
echo 1 >/sys/kernel/debug/tracing/events/fscache/fscache_acquire/enable
echo 1 >/sys/kernel/debug/tracing/events/fscache/fscache_relinquish/enable

David

