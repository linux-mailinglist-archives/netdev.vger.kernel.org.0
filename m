Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105D82D275F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgLHJTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:19:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728527AbgLHJTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607419093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Af9UgpwqHoabg6xVM1FDF5VpKj0YXv9xZDctidosARM=;
        b=WoFZb7Q2VXJrh3hN1fRpB35HFSBLCp7xbNwiiU7Bwvo9GEo7LRyUEtBBByU2zuQs30ncdR
        qUjhb2AvXLKIQgYnzxbT6T672XksNzuDEaZUEFYQnrbTWNXZ5kwHggN3AxdVK/r8EKvXEP
        1POysRiMopOixpdwh1VaIGF/ivpblH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-j3_6w5N1NCam5W3BvH8aNA-1; Tue, 08 Dec 2020 04:18:09 -0500
X-MC-Unique: j3_6w5N1NCam5W3BvH8aNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 422CE9CDA0;
        Tue,  8 Dec 2020 09:18:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9719219C78;
        Tue,  8 Dec 2020 09:18:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAMj1kXG5_ePTr7KCxE-m6g9xNHr72-xPMoED7Jmx38uNt6bzoQ@mail.gmail.com>
References: <CAMj1kXG5_ePTr7KCxE-m6g9xNHr72-xPMoED7Jmx38uNt6bzoQ@mail.gmail.com> <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk> <122997.1607097713@warthog.procyon.org.uk> <20201204160347.GA26933@fieldses.org> <125709.1607100601@warthog.procyon.org.uk> <CAMj1kXEOm_yh478i+dqPiz0eoBxp4eag3j2qHm5eBLe+2kihoQ@mail.gmail.com> <127458.1607102368@warthog.procyon.org.uk> <CAMj1kXFe50HvZLxG6Kh-oYBCf5uu51hhuh7mW5UQ62ZSqmu_xA@mail.gmail.com> <468625.1607342512@warthog.procyon.org.uk> <CAMj1kXH_gEjgZKx=8uQgv=ckBqTVoh3vrHj=O-nY-nm5VMgLaA@mail.gmail.com> <482243.1607350500@warthog.procyon.org.uk>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     dhowells@redhat.com, Bruce Fields <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <931124.1607419082.1@warthog.procyon.org.uk>
Date:   Tue, 08 Dec 2020 09:18:02 +0000
Message-ID: <931125.1607419082@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ard Biesheuvel <ardb@kernel.org> wrote:

Ard Biesheuvel <ardb@kernel.org> wrote:

> > > > I wonder if it would help if the input buffer and output buffer didn't
> > > > have to correspond exactly in usage - ie. the output buffer could be
> > > > used at a slower rate than the input to allow for buffering inside the
> > > > crypto algorithm.
> > >
> > > I don't follow - how could one be used at a slower rate?
> >
> > I mean that the crypto algorithm might need to buffer the last part of the
> > input until it has a block's worth before it can write to the output.
> 
> This is what is typically handled transparently by the driver. When
> you populate a scatterlist, it doesn't matter how misaligned the
> individual elements are, the scatterlist walker will always present
> the data in chunks that the crypto algorithm can manage. This is why
> using a single scatterlist for the entire input is preferable in
> general.

Yep - but the assumption currently on the part of the callers is that they
provide the input buffer and corresponding output buffer - and that the
algorithm will transfer data from one to the other, such that the same amount
of input and output bufferage will be used.

However, if we start pushing data in progressively, this would no longer hold
true unless we also require the caller to only present in block-size chunks.

For example, if I gave the encryption function 120 bytes of data and a 120
byte output buffer, but the algorithm has a 16-byte blocksize, it will,
presumably, consume 120 bytes of input, but it can only write 112 bytes of
output at this time.  So the current interface would need to evolve to
indicate separately how much input has been consumed and how much output has
been produced - in which case it can't be handled transparently.

For krb5, it's actually worse than that, since we want to be able to
insert/remove a header and a trailer (and might need to go back and update the
header after) - but I think in the krb5 case, we need to treat the header and
trailer specially and update them after the fact in the wrapping case
(unwrapping is not a problem, since we can just cache the header).

David

