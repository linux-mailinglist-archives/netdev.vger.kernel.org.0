Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35894295EC3
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 14:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505395AbgJVMml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 08:42:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505403AbgJVMmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 08:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603370558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D8NfRDK57IWkyMuy8F79W605svkUQv4zH8HJOm5hlKE=;
        b=LEbVq+ZrJke0vg13llK+BZqC/21rsoTGDFUIHWT46+6ySArRdcDRbUXXXumnwxYUL+pUNZ
        zRL+HSSLigXyqpbqe1YKAzgf9HLAZOmaMKoeNM/Ot83vDL8JMgridaAskzEW8//dGytvKY
        p2HZswBjeWhgB6psIAc4Gm4CHDTZK8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-JAg57F3NO6i2Qkw59bI5bQ-1; Thu, 22 Oct 2020 08:42:34 -0400
X-MC-Unique: JAg57F3NO6i2Qkw59bI5bQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90D1C81C9AF;
        Thu, 22 Oct 2020 12:42:30 +0000 (UTC)
Received: from [10.36.113.152] (ovpn-113-152.ams2.redhat.com [10.36.113.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05FBF6EF62;
        Thu, 22 Oct 2020 12:42:24 +0000 (UTC)
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
References: <20201022082654.GA1477657@kroah.com>
 <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com>
 <5d2ecb24db1e415b8ff88261435386ec@AcuMS.aculab.com>
 <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com>
 <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022104805.GA1503673@kroah.com> <20201022121849.GA1664412@kroah.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <98d9df88-b7ef-fdfb-7d90-2fa7a9d7bab5@redhat.com>
Date:   Thu, 22 Oct 2020 14:42:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201022121849.GA1664412@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.10.20 14:18, Greg KH wrote:
> On Thu, Oct 22, 2020 at 12:48:05PM +0200, Greg KH wrote:
>> On Thu, Oct 22, 2020 at 11:36:40AM +0200, David Hildenbrand wrote:
>>> On 22.10.20 11:32, David Laight wrote:
>>>> From: David Hildenbrand
>>>>> Sent: 22 October 2020 10:25
>>>> ...
>>>>> ... especially because I recall that clang and gcc behave slightly
>>>>> differently:
>>>>>
>>>>> https://github.com/hjl-tools/x86-psABI/issues/2
>>>>>
>>>>> "Function args are different: narrow types are sign or zero extended to
>>>>> 32 bits, depending on their type. clang depends on this for incoming
>>>>> args, but gcc doesn't make that assumption. But both compilers do it
>>>>> when calling, so gcc code can call clang code.
>>>>
>>>> It really is best to use 'int' (or even 'long') for all numeric
>>>> arguments (and results) regardless of the domain of the value.
>>>>
>>>> Related, I've always worried about 'bool'....
>>>>
>>>>> The upper 32 bits of registers are always undefined garbage for types
>>>>> smaller than 64 bits."
>>>>
>>>> On x86-64 the high bits are zeroed by all 32bit loads.
>>>
>>> Yeah, but does not help here.
>>>
>>>
>>> My thinking: if the compiler that calls import_iovec() has garbage in
>>> the upper 32 bit
>>>
>>> a) gcc will zero it out and not rely on it being zero.
>>> b) clang will not zero it out, assuming it is zero.
>>>
>>> But
>>>
>>> a) will zero it out when calling the !inlined variant
>>> b) clang will zero it out when calling the !inlined variant
>>>
>>> When inlining, b) strikes. We access garbage. That would mean that we
>>> have calling code that's not generated by clang/gcc IIUC.
>>>
>>> We can test easily by changing the parameters instead of adding an "inline".
>>
>> Let me try that as well, as I seem to have a good reproducer, but it
>> takes a while to run...
> 
> Ok, that didn't work.
> 
> And I can't seem to "fix" this by adding noinline to patches further
> along in the patch series (because this commit's function is no longer
> present due to later patches.)

We might have the same issues with iovec_from_user() and friends now.

> 
> Will keep digging...
> 
> greg k-h
> 


Might be worth to give this a try, just to see if it's related to
garbage in upper 32 bit and the way clang is handling it (might be a BUG
in clang, though):


diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..7527298c6b56 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -267,7 +267,7 @@ size_t hash_and_copy_to_iter(const void *addr,
size_t bytes, void *hashp,
                struct iov_iter *i);

 struct iovec *iovec_from_user(const struct iovec __user *uvector,
-               unsigned long nr_segs, unsigned long fast_segs,
+               unsigned nr_segs, unsigned fast_segs,
                struct iovec *fast_iov, bool compat);
 ssize_t import_iovec(int type, const struct iovec __user *uvec,
                 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 1635111c5bd2..58417f1916dc 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1652,7 +1652,7 @@ const void *dup_iter(struct iov_iter *new, struct
iov_iter *old, gfp_t flags)
 EXPORT_SYMBOL(dup_iter);

 static int copy_compat_iovec_from_user(struct iovec *iov,
-               const struct iovec __user *uvec, unsigned long nr_segs)
+               const struct iovec __user *uvec, unsigned nr_segs)
 {
        const struct compat_iovec __user *uiov =
                (const struct compat_iovec __user *)uvec;
@@ -1684,7 +1684,7 @@ static int copy_compat_iovec_from_user(struct
iovec *iov,
 }

 static int copy_iovec_from_user(struct iovec *iov,
-               const struct iovec __user *uvec, unsigned long nr_segs)
+               const struct iovec __user *uvec, unsigned nr_segs)
 {
        unsigned long seg;

@@ -1699,7 +1699,7 @@ static int copy_iovec_from_user(struct iovec *iov,
 }

 struct iovec *iovec_from_user(const struct iovec __user *uvec,
-               unsigned long nr_segs, unsigned long fast_segs,
+               unsigned nr_segs, unsigned fast_segs,
                struct iovec *fast_iov, bool compat)
 {
        struct iovec *iov = fast_iov;
@@ -1738,7 +1738,7 @@ ssize_t __import_iovec(int type, const struct
iovec __user *uvec,
                 struct iov_iter *i, bool compat)
 {
        ssize_t total_len = 0;
-       unsigned long seg;
+       unsigned seg;
        struct iovec *iov;

        iov = iovec_from_user(uvec, nr_segs, fast_segs, *iovp, compat);


-- 
Thanks,

David / dhildenb

