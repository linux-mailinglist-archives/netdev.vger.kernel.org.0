Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119A21B0C53
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgDTNNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:13:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60948 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726806AbgDTNNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587388429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IYew2ybNbEYlxnWhOLAX8rprgalSjY8htLDKj7llLh0=;
        b=cT8k9C5smoLW0DSaOLLzw+VTs4gBE+1T9Rc4srv4ftYcSzdnR+Aw64zoloUkH8+/k0RuFP
        EkyrUxUDLJ+VIa9R9Hu0AQzhAGsgnhfPbPtYD10iQtc1N06UKZixShS8vSlFegtNEehV3Q
        PXJwxdFduackCjQ6YamQCcwaY7v6ozE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-8q1U0xdCNU2fff9u2tmIGQ-1; Mon, 20 Apr 2020 09:13:45 -0400
X-MC-Unique: 8q1U0xdCNU2fff9u2tmIGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80352149C1;
        Mon, 20 Apr 2020 13:13:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-129.rdu2.redhat.com [10.10.113.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BDD510013A1;
        Mon, 20 Apr 2020 13:13:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <87imhvj7m6.fsf@cjr.nz>
References: <87imhvj7m6.fsf@cjr.nz> <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com> <3865908.1586874010@warthog.procyon.org.uk> <927453.1587285472@warthog.procyon.org.uk>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, fweimer@redhat.com
Subject: Re: What's a good default TTL for DNS keys in the kernel
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1136023.1587388420.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 20 Apr 2020 14:13:40 +0100
Message-ID: <1136024.1587388420@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paulo Alcantara <pc@cjr.nz> wrote:

> >> For SMB3/CIFS mounts, Paulo added support last year for automatic
> >> reconnect if the IP address of the server changes.  It also is helpfu=
l
> >> when DFS (global name space) addresses change.
> >
> > What happens if the IP address the superblock is going to changes, the=
n
> > another mount is made back to the original IP address?  Does the secon=
d mount
> > just pick the original superblock?
> =

> It is going to transparently reconnect to the new ip address, SMB share,
> and cifs superblock is kept unchanged.  We, however, update internal
> TCP_Server_Info structure to reflect new destination ip address.
> =

> For the second mount, since the hostname (extracted out of the UNC path
> at mount time) resolves to a new ip address and that address was saved e=
arlier
> in TCP_Server_Info structure during reconnect, we will end up
> reusing same cifs superblock as per fs/cifs/connect.c:cifs_match_super()=
.

Would that be a bug?

David

