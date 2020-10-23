Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4595E297409
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751792AbgJWQdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751776AbgJWQdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFpT9rw9kU+fUUj5fb7jig81eZVzobxvui7gAjawuH0=;
        b=jCYqKvBkG2GdjY1DUZF5NWtsiGLJ9YC9z4syTQqWdOsQP24r17aal+fMLECtc6M16OeA+H
        sJO1g/XAwINGnDOdywtyqoFs750it4J40vpWJkXU1aCWX1qtF/ZzR2f9esOsXxjH+N2ZKl
        6mB4s7bi6imBga23sFFsjcyTuCrAh2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-mE4iRpoaPm6zGEfodl9TZg-1; Fri, 23 Oct 2020 12:33:11 -0400
X-MC-Unique: mE4iRpoaPm6zGEfodl9TZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47449108E1B2;
        Fri, 23 Oct 2020 16:33:07 +0000 (UTC)
Received: from [10.36.114.18] (ovpn-114-18.ams2.redhat.com [10.36.114.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 139D160BFA;
        Fri, 23 Oct 2020 16:33:00 +0000 (UTC)
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
To:     'Greg KH' <gregkh@linuxfoundation.org>,
        David Laight <David.Laight@aculab.com>
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
References: <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022104805.GA1503673@kroah.com> <20201022121849.GA1664412@kroah.com>
 <98d9df88-b7ef-fdfb-7d90-2fa7a9d7bab5@redhat.com>
 <20201022125759.GA1685526@kroah.com> <20201022135036.GA1787470@kroah.com>
 <134f162d711d466ebbd88906fae35b33@AcuMS.aculab.com>
 <935f7168-c2f5-dd14-7124-412b284693a2@redhat.com>
 <999e2926-9a75-72fd-007a-1de0af341292@redhat.com>
 <35d0ec90ef4f4a35a75b9df7d791f719@AcuMS.aculab.com>
 <20201023144718.GA2525489@kroah.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <52fe0398-02be-33fb-3a64-e394cc819b60@redhat.com>
Date:   Fri, 23 Oct 2020 18:33:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201023144718.GA2525489@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.10.20 16:47, 'Greg KH' wrote:
> On Fri, Oct 23, 2020 at 02:39:24PM +0000, David Laight wrote:
>> From: David Hildenbrand
>>> Sent: 23 October 2020 15:33
>> ...
>>> I just checked against upstream code generated by clang 10 and it
>>> properly discards the upper 32bit via a mov w23 w2.
>>>
>>> So at least clang 10 indeed properly assumes we could have garbage and
>>> masks it off.
>>>
>>> Maybe the issue is somewhere else, unrelated to nr_pages ... or clang 11
>>> behaves differently.
>>
>> We'll need the disassembly from a failing kernel image.
>> It isn't that big to hand annotate.
> 
> I've worked around the merge at the moment in the android tree, but it
> is still quite reproducable, and will try to get a .o file to
> disassemble on Monday or so...

I just compiled pre and post fb041b598997d63c0f7d7305dfae70046bf66fe1 with

clang version 11.0.0 (Fedora 11.0.0-0.2.rc1.fc33)

for aarch64 with defconfig and extracted import_iovec and
rw_copy_check_uvector (skipping the compat things)

Pre fb041b598997d63c0f7d7305dfae70046bf66fe1 import_iovec
-> https://pastebin.com/LtnYMLJt
Post fb041b598997d63c0f7d7305dfae70046bf66fe1 import_iovec
-> https://pastebin.com/BWPmXrAf
Pre fb041b598997d63c0f7d7305dfae70046bf66fe1 rw_copy_check_uvector
-> https://pastebin.com/4nSBYRbf
Post fb041b598997d63c0f7d7305dfae70046bf66fe1 rw_copy_check_uvector
-> https://pastebin.com/hPtEgaEW

I'm only able to spot minor differences ... less gets inlined than I
would have expected. But there are some smaller differences.

Maybe someone wants to have a look before we have object files as used
by Greg ...

-- 
Thanks,

David / dhildenb

