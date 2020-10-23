Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408D3297002
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464336AbgJWNJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S464332AbgJWNJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603458587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72dx+pFNkJMyRa7xo3pnb+kKjqXwelAsFAb2NVCNc3A=;
        b=PEXDHdyQA0G/x8om87hOPE7kIiJHqEAntNKZDDr/XgrqoK7m4dr3mho0tvSdrWtD0saFKy
        KhYCoR5Wdxuk0RProix5hlCO3y9SAVjowLtvG8rNu8jcxBbIgy+MfwDJUBf86WLNxtXENZ
        cpMPXDulcPvNc5kgldZq+SoWWMuLukM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-Oel3L5QjO_O0-RxNigaJug-1; Fri, 23 Oct 2020 09:09:43 -0400
X-MC-Unique: Oel3L5QjO_O0-RxNigaJug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20A3B1882FA0;
        Fri, 23 Oct 2020 13:09:37 +0000 (UTC)
Received: from [10.36.114.18] (ovpn-114-18.ams2.redhat.com [10.36.114.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AF0A55762;
        Fri, 23 Oct 2020 13:09:31 +0000 (UTC)
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
To:     David Laight <David.Laight@ACULAB.COM>,
        'Greg KH' <gregkh@linuxfoundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Hellwig <hch@lst.de>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
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
References: <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
 <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022104805.GA1503673@kroah.com> <20201022121849.GA1664412@kroah.com>
 <98d9df88-b7ef-fdfb-7d90-2fa7a9d7bab5@redhat.com>
 <20201022125759.GA1685526@kroah.com> <20201022135036.GA1787470@kroah.com>
 <134f162d711d466ebbd88906fae35b33@AcuMS.aculab.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <935f7168-c2f5-dd14-7124-412b284693a2@redhat.com>
Date:   Fri, 23 Oct 2020 15:09:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <134f162d711d466ebbd88906fae35b33@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.10.20 14:46, David Laight wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>> Sent: 22 October 2020 14:51
> 
> I've rammed the code into godbolt.
> 
> https://godbolt.org/z/9v5PPW
> 
> Definitely a clang bug.
> 
> Search for [wx]24 in the clang output.
> nr_segs comes in as w2 and the initial bound checks are done on w2.
> w24 is loaded from w2 - I don't believe this changes the high bits.
> There are no references to w24, just x24.
> So the kmalloc_array() is passed 'huge' and will fail.
> The iov_iter_init also gets the 64bit value.
> 
> Note that the gcc code has a sign-extend copy of w2.

Do we have a result from using "unsigned long" in the base function and
explicitly masking of the high bits? That should definitely work.

Now, I am not a compiler expert, but as I already cited, at least on
x86-64 clang expects that the high bits were cleared by the caller - in
contrast to gcc. I suspect it's the same on arm64, but again, I am no
compiler expert.

If what I said and cites for x86-64 is correct, if the function expects
an "unsigned int", it will happily use 64bit operations without further
checks where valid when assuming high bits are zero. That's why even
converting everything to "unsigned int" as proposed by me won't work on
clang - it assumes high bits are zero (as indicated by Nick).

As I am neither a compiler experts (did I mention that already? ;) ) nor
an arm64 experts, I can't tell if this is a compiler BUG or not.

Main issue seems to be garbage in high bits as originally suggested by me.

-- 
Thanks,

David / dhildenb

