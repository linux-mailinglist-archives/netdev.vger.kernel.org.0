Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26340297011
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372847AbgJWNMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:12:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S372860AbgJWNMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603458756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jTvh5muq91KS5CpSKJexFoXC1Qp8u72sWKaaLH+BBx8=;
        b=Jo3aDhqMMpcWtLQYVz5jebmJdaCZTJg7UEX2OlXqzjjDl0DwiC7Sj1f+8xm5vlPDYcLGfR
        Q9rEfKw6+quixfepfYo1kzCbywQ01j73hhE6/jnrAJ9smTZXAwmEjYChDJakDpQsgGFQsx
        jMgiTw84h1fNoOCWeHRt3Bn01eUFkNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-YV1Nynx1P4GwePi1t-8udg-1; Fri, 23 Oct 2020 09:12:32 -0400
X-MC-Unique: YV1Nynx1P4GwePi1t-8udg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44117192CC47;
        Fri, 23 Oct 2020 13:12:29 +0000 (UTC)
Received: from [10.36.114.18] (ovpn-114-18.ams2.redhat.com [10.36.114.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55E915C1CF;
        Fri, 23 Oct 2020 13:12:24 +0000 (UTC)
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
References: <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022132342.GB8781@lst.de>
 <8f1fff0c358b4b669d51cc80098dbba1@AcuMS.aculab.com>
 <CAKwvOdnix6YGFhsmT_mY8ORNPTOsN3HwS33Dr0Ykn-pyJ6e-Bw@mail.gmail.com>
 <CAK8P3a3LjG+ZvmQrkb9zpgov8xBkQQWrkHBPgjfYSqBKGrwT4w@mail.gmail.com>
 <CAKwvOdnhONvrHLAuz_BrAuEpnF5mD9p0YPGJs=NZZ0EZNo7dFQ@mail.gmail.com>
 <20201022192458.GV3576660@ZenIV.linux.org.uk>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <e7a8f709-87b8-c328-6190-8371c6fa3ae8@redhat.com>
Date:   Fri, 23 Oct 2020 15:12:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201022192458.GV3576660@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.10.20 21:24, Al Viro wrote:
> On Thu, Oct 22, 2020 at 12:04:52PM -0700, Nick Desaulniers wrote:
> 
>> Passing an `unsigned long` as an `unsigned int` does no such
>> narrowing: https://godbolt.org/z/TvfMxe (same vice-versa, just tail
>> calls, no masking instructions).
>> So if rw_copy_check_uvector() is inlined into import_iovec() (looking
>> at the mainline@1028ae406999), then children calls of
>> `rw_copy_check_uvector()` will be interpreting the `nr_segs` register
>> unmodified, ie. garbage in the upper 32b.
> 
> FWIW,
> 
> void f(unsinged long v)
> {
> 	if (v != 1)
> 		printf("failed\n");
> }
> 
> void g(unsigned int v)
> {
> 	f(v);
> }
> 
> void h(unsigned long v)
> {
> 	g(v);
> }
> 
> main()
> {
> 	h(0x100000001);
> }
> 
> must not produce any output on a host with 32bit int and 64bit long, regardless of
> the inlining, having functions live in different compilation units, etc.
> 
> Depending upon the calling conventions, compiler might do truncation in caller or
> in a callee, but it must be done _somewhere_.

The interesting case is having g() in a separate compilation unit and
force-calling g() with 0x100000001 via inline ASM. So forcing garbage
into high bits.

I'll paly with it.

-- 
Thanks,

David / dhildenb

