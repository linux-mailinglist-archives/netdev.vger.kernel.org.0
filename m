Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD39295C0D
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2510009AbgJVJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:36:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2509545AbgJVJg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603359415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DC+3OwmtjhrVCpfk4sXvCEkgbYjM3Mk+x26MXzYFx48=;
        b=VMLvYiWBWMQ8BdmpBnQeU65MkER6Womd4xJdO54glA3t/92ZkYXsTYq1nUygAYE8r7fHoJ
        VgCH5M1VDUAcntGU/mdWH31g0jLaaceEeQfPMxf0koDQMbNQ9meQSM/seFb5+cOHaUP3NR
        yWNVcXHNeqU07Xr7fsFTmP86uBEG6MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-oXTdLQjNMMegK_tfwCZIGg-1; Thu, 22 Oct 2020 05:36:50 -0400
X-MC-Unique: oXTdLQjNMMegK_tfwCZIGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A2D364152;
        Thu, 22 Oct 2020 09:36:46 +0000 (UTC)
Received: from [10.36.113.152] (ovpn-113-152.ams2.redhat.com [10.36.113.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E9B810013D0;
        Thu, 22 Oct 2020 09:36:41 +0000 (UTC)
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
To:     David Laight <David.Laight@ACULAB.COM>,
        Greg KH <gregkh@linuxfoundation.org>
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
References: <20200925045146.1283714-1-hch@lst.de>
 <20200925045146.1283714-3-hch@lst.de> <20201021161301.GA1196312@kroah.com>
 <20201021233914.GR3576660@ZenIV.linux.org.uk>
 <20201022082654.GA1477657@kroah.com>
 <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com>
 <5d2ecb24db1e415b8ff88261435386ec@AcuMS.aculab.com>
 <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
 <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
Date:   Thu, 22 Oct 2020 11:36:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.10.20 11:32, David Laight wrote:
> From: David Hildenbrand
>> Sent: 22 October 2020 10:25
> ...
>> ... especially because I recall that clang and gcc behave slightly
>> differently:
>>
>> https://github.com/hjl-tools/x86-psABI/issues/2
>>
>> "Function args are different: narrow types are sign or zero extended to
>> 32 bits, depending on their type. clang depends on this for incoming
>> args, but gcc doesn't make that assumption. But both compilers do it
>> when calling, so gcc code can call clang code.
> 
> It really is best to use 'int' (or even 'long') for all numeric
> arguments (and results) regardless of the domain of the value.
> 
> Related, I've always worried about 'bool'....
> 
>> The upper 32 bits of registers are always undefined garbage for types
>> smaller than 64 bits."
> 
> On x86-64 the high bits are zeroed by all 32bit loads.

Yeah, but does not help here.


My thinking: if the compiler that calls import_iovec() has garbage in
the upper 32 bit

a) gcc will zero it out and not rely on it being zero.
b) clang will not zero it out, assuming it is zero.

But

a) will zero it out when calling the !inlined variant
b) clang will zero it out when calling the !inlined variant

When inlining, b) strikes. We access garbage. That would mean that we
have calling code that's not generated by clang/gcc IIUC.

We can test easily by changing the parameters instead of adding an "inline".

-- 
Thanks,

David / dhildenb

