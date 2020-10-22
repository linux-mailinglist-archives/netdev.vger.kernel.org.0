Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76229296424
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368399AbgJVRy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504799AbgJVRyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 13:54:20 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083F6C0613DA
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:54:20 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t18so1368744plo.1
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 10:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fN98WKFQMgEXMlp8i3NGUVnGVw+6y+e2V0ke9rhUWSA=;
        b=BKV40KcFYv/RT7WI/LzYvQYye/7QuyEZeVOFKBpWDRGSNerYyXtKTvLxKg7AQQyR6a
         B6ov6UgSF+CT0yFZ5Kpm//JhG6JX+erMmrvxUD0nM2EPok7DJ1dyb0csZXVH+J57G76o
         JEKNKLPukNE3mXje8tahLR4x5JyOobyLEq7zPqSmgsU53Cxt6nYjuHUBVcdVMcbrcilK
         K/V95Mavbng7Vx66laYlk4QUwTrTI6xWi8qckIoCQ5E2cwAi2ki1g0yQJTA0k1YggZ8N
         +hx8KG1AyjINmebjC8dKCAdqeNm9iI1l37J/7olC9z6B/lTJyWVJjteE9X9SnKXuuDmh
         S8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fN98WKFQMgEXMlp8i3NGUVnGVw+6y+e2V0ke9rhUWSA=;
        b=Ne7MppC0Ret0JzI3Xo7gE3IklqE4ZAahcDUYgQzV5iNg+EFAvrDOmR8NXxIIh4kJwS
         fJjcUtAKNtlgoyljNNUDGAtfrS0uihogSpmYVQ3dHqt77RANVfScHfeqF9QDpHYHUY0m
         QGJ74SwaZjPVGR2HN5JcsB9240mKYZudI42JPz/dkEbz1Qc6rFbo+wxNwvl3qsfH4tsV
         B//BpZOD9dsYqM+KoUtpNtctJ87+xqmZglFRCGJvEr7BjAmgZJh7oaFjgLTwq8luzYl4
         PwrhQUnUGQsu6GXJZl95VMkeHvtdUsTMNS8RbHxKJwiBe64Pxhzu/4z8+ppxmpinlflH
         IkiQ==
X-Gm-Message-State: AOAM533ZhqfLgn79KFYMY43LmNg80HpQInKUFhSElvpAwbDMW5mcMU7z
        afMRdcGuMk1DjzcWEaBDp0YHqSN3mhhcJqYmkEXqAw==
X-Google-Smtp-Source: ABdhPJwKMlfWHWIfBAFNm3K11R3iXcLN/39e27pMOK/669Q9lQtbTX5Z9LF4v87HnqXK2It7QLj5rkKD4/EUsxOxOjE=
X-Received: by 2002:a17:902:c40b:b029:d3:def2:d90f with SMTP id
 k11-20020a170902c40bb02900d3def2d90fmr3352248plk.29.1603389258899; Thu, 22
 Oct 2020 10:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201021233914.GR3576660@ZenIV.linux.org.uk> <20201022082654.GA1477657@kroah.com>
 <80a2e5fa-718a-8433-1ab0-dd5b3e3b5416@redhat.com> <5d2ecb24db1e415b8ff88261435386ec@AcuMS.aculab.com>
 <df2e0758-b8ed-5aec-6adc-a18f499c0179@redhat.com> <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com> <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com> <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022132342.GB8781@lst.de> <8f1fff0c358b4b669d51cc80098dbba1@AcuMS.aculab.com>
In-Reply-To: <8f1fff0c358b4b669d51cc80098dbba1@AcuMS.aculab.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 22 Oct 2020 10:54:06 -0700
Message-ID: <CAKwvOdnix6YGFhsmT_mY8ORNPTOsN3HwS33Dr0Ykn-pyJ6e-Bw@mail.gmail.com>
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
To:     David Laight <David.Laight@aculab.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
Content-Type: multipart/mixed; boundary="0000000000003743e505b2462753"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003743e505b2462753
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 22, 2020 at 9:35 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Christoph Hellwig
> > Sent: 22 October 2020 14:24
> >
> > On Thu, Oct 22, 2020 at 11:36:40AM +0200, David Hildenbrand wrote:
> > > My thinking: if the compiler that calls import_iovec() has garbage in
> > > the upper 32 bit
> > >
> > > a) gcc will zero it out and not rely on it being zero.
> > > b) clang will not zero it out, assuming it is zero.
> > >
> > > But
> > >
> > > a) will zero it out when calling the !inlined variant
> > > b) clang will zero it out when calling the !inlined variant
> > >
> > > When inlining, b) strikes. We access garbage. That would mean that we
> > > have calling code that's not generated by clang/gcc IIUC.
> >
> > Most callchains of import_iovec start with the assembly syscall wrappers.
>
> Wait...
> readv(2) defines:
>         ssize_t readv(int fd, const struct iovec *iov, int iovcnt);
>
> But the syscall is defined as:
>
> SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
>                 unsigned long, vlen)
> {
>         return do_readv(fd, vec, vlen, 0);
> }
>
> I'm guessing that nothing actually masks the high bits that come
> from an application that is compiled with clang?
>
> The vlen is 'unsigned long' through the first few calls.
> So unless there is a non-inlined function than takes vlen
> as 'int' the high garbage bits from userspace are kept.

Yeah, that's likely a bug: https://godbolt.org/z/KfsPKs

>
> Which makes it a bug in the kernel C syscall wrappers.
> They need to explicitly mask the high bits of 32bit
> arguments on arm64 but not x86-64.

Why not x86-64? Wouldn't it be *any* LP64 ISA?

Attaching a patch that uses the proper width, but I'm pretty sure
there's still a signedness issue .  Greg, would you mind running this
through the wringer?

>
> What does the ARM EABI say about register parameters?

AAPCS is the ABI for 64b ARM, IIUC, which is the ISA GKH is reporting
the problem against. IIUC, EABI is one of the 32b ABIs.  aarch64 is
LP64 just like x86_64.

--
Thanks,
~Nick Desaulniers

--0000000000003743e505b2462753
Content-Type: application/octet-stream; 
	name="0001-fs-fix-up-type-confusion-in-readv-writev.patch"
Content-Disposition: attachment; 
	filename="0001-fs-fix-up-type-confusion-in-readv-writev.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgl4e4rn0>
X-Attachment-Id: f_kgl4e4rn0

RnJvbSBhYWUyNmIxM2ZmYjllMzhiYjQ2YjhjODU5ODU3NjFiNWYxOTZiNmY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogVGh1LCAyMiBPY3QgMjAyMCAxMDoyMzo0NyAtMDcwMApTdWJqZWN0OiBbUEFU
Q0hdIGZzOiBmaXggdXAgdHlwZSBjb25mdXNpb24gaW4gcmVhZHYvd3JpdGV2CgpUaGUgc3lzY2Fs
bCBpbnRlcmZhY2UgZG9lc24ndCBtYXRjaCB1cCB3aXRoIHRoZSBpbnRlcmZhY2UgbGliYyBpcyB1
c2luZwpvciB0aGF0J3MgZGVmaW5lZCBpbiB0aGUgbWFudWFsIHBhZ2VzLgoKc3NpemVfdCByZWFk
dihpbnQgZmQsIGNvbnN0IHN0cnVjdCBpb3ZlYyAqaW92LCBpbnQgaW92Y250KTsKc3NpemVfdCB3
cml0ZXYoaW50IGZkLCBjb25zdCBzdHJ1Y3QgaW92ZWMgKmlvdiwgaW50IGlvdmNudCk7CgpUaGUg
a2VybmVsIHdhcyBkZWZpbmluZyBgaW92Y250YCBhcyBgdW5zaWduZWQgbG9uZ2Agd2hpY2ggaXMg
YSBwcm9ibGVtCndoZW4gdXNlcnNwYWNlIHVuZGVyc3RhbmRzIHRoaXMgdG8gYmUgYGludGAuCgoo
VGhlcmUncyBzdGlsbCBsaWtlbHkgYSBzaWduZWRuZXNzIGJ1ZyBoZXJlLCBidXQgdXNlIHRoZSBw
cm9wZXIgd2lkdGhzCnRoYXQgaW1wb3J0X2lvdmVjKCkgZXhwZWN0cy4pCgpTaWduZWQtb2ZmLWJ5
OiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xlLmNvbT4KLS0tCiBmcy9yZWFk
X3dyaXRlLmMgICAgfCAxMCArKysrKy0tLS0tCiBmcy9zcGxpY2UuYyAgICAgICAgfCAgMiArLQog
aW5jbHVkZS9saW51eC9mcy5oIHwgIDIgKy0KIGxpYi9pb3ZfaXRlci5jICAgICB8ICA0ICsrLS0K
IDQgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL3JlYWRfd3JpdGUuYyBiL2ZzL3JlYWRfd3JpdGUuYwppbmRleCAxOWY1YzRiZjc1
YWEuLmI4NThmMzlhNDQ3NSAxMDA2NDQKLS0tIGEvZnMvcmVhZF93cml0ZS5jCisrKyBiL2ZzL3Jl
YWRfd3JpdGUuYwpAQCAtODkwLDcgKzg5MCw3IEBAIHNzaXplX3QgdmZzX2l0ZXJfd3JpdGUoc3Ry
dWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBpb3ZfaXRlciAqaXRlciwgbG9mZl90ICpwcG9zLAogRVhQ
T1JUX1NZTUJPTCh2ZnNfaXRlcl93cml0ZSk7CiAKIHNzaXplX3QgdmZzX3JlYWR2KHN0cnVjdCBm
aWxlICpmaWxlLCBjb25zdCBzdHJ1Y3QgaW92ZWMgX191c2VyICp2ZWMsCi0JCSAgdW5zaWduZWQg
bG9uZyB2bGVuLCBsb2ZmX3QgKnBvcywgcndmX3QgZmxhZ3MpCisJCSAgdW5zaWduZWQgaW50IHZs
ZW4sIGxvZmZfdCAqcG9zLCByd2ZfdCBmbGFncykKIHsKIAlzdHJ1Y3QgaW92ZWMgaW92c3RhY2tb
VUlPX0ZBU1RJT1ZdOwogCXN0cnVjdCBpb3ZlYyAqaW92ID0gaW92c3RhY2s7CkBAIC05MDcsNyAr
OTA3LDcgQEAgc3NpemVfdCB2ZnNfcmVhZHYoc3RydWN0IGZpbGUgKmZpbGUsIGNvbnN0IHN0cnVj
dCBpb3ZlYyBfX3VzZXIgKnZlYywKIH0KIAogc3RhdGljIHNzaXplX3QgdmZzX3dyaXRldihzdHJ1
Y3QgZmlsZSAqZmlsZSwgY29uc3Qgc3RydWN0IGlvdmVjIF9fdXNlciAqdmVjLAotCQkgICB1bnNp
Z25lZCBsb25nIHZsZW4sIGxvZmZfdCAqcG9zLCByd2ZfdCBmbGFncykKKwkJICAgdW5zaWduZWQg
aW50IHZsZW4sIGxvZmZfdCAqcG9zLCByd2ZfdCBmbGFncykKIHsKIAlzdHJ1Y3QgaW92ZWMgaW92
c3RhY2tbVUlPX0ZBU1RJT1ZdOwogCXN0cnVjdCBpb3ZlYyAqaW92ID0gaW92c3RhY2s7CkBAIC05
MjUsNyArOTI1LDcgQEAgc3RhdGljIHNzaXplX3QgdmZzX3dyaXRldihzdHJ1Y3QgZmlsZSAqZmls
ZSwgY29uc3Qgc3RydWN0IGlvdmVjIF9fdXNlciAqdmVjLAogfQogCiBzdGF0aWMgc3NpemVfdCBk
b19yZWFkdih1bnNpZ25lZCBsb25nIGZkLCBjb25zdCBzdHJ1Y3QgaW92ZWMgX191c2VyICp2ZWMs
Ci0JCQl1bnNpZ25lZCBsb25nIHZsZW4sIHJ3Zl90IGZsYWdzKQorCQkJdW5zaWduZWQgaW50IHZs
ZW4sIHJ3Zl90IGZsYWdzKQogewogCXN0cnVjdCBmZCBmID0gZmRnZXRfcG9zKGZkKTsKIAlzc2l6
ZV90IHJldCA9IC1FQkFERjsKQEAgLTEwMjUsMTMgKzEwMjUsMTMgQEAgc3RhdGljIHNzaXplX3Qg
ZG9fcHdyaXRldih1bnNpZ25lZCBsb25nIGZkLCBjb25zdCBzdHJ1Y3QgaW92ZWMgX191c2VyICp2
ZWMsCiB9CiAKIFNZU0NBTExfREVGSU5FMyhyZWFkdiwgdW5zaWduZWQgbG9uZywgZmQsIGNvbnN0
IHN0cnVjdCBpb3ZlYyBfX3VzZXIgKiwgdmVjLAotCQl1bnNpZ25lZCBsb25nLCB2bGVuKQorCQl1
bnNpZ25lZCBpbnQsIHZsZW4pCiB7CiAJcmV0dXJuIGRvX3JlYWR2KGZkLCB2ZWMsIHZsZW4sIDAp
OwogfQogCiBTWVNDQUxMX0RFRklORTMod3JpdGV2LCB1bnNpZ25lZCBsb25nLCBmZCwgY29uc3Qg
c3RydWN0IGlvdmVjIF9fdXNlciAqLCB2ZWMsCi0JCXVuc2lnbmVkIGxvbmcsIHZsZW4pCisJCXVu
c2lnbmVkIGludCwgdmxlbikKIHsKIAlyZXR1cm4gZG9fd3JpdGV2KGZkLCB2ZWMsIHZsZW4sIDAp
OwogfQpkaWZmIC0tZ2l0IGEvZnMvc3BsaWNlLmMgYi9mcy9zcGxpY2UuYwppbmRleCA3MGNjNTJh
Zjc4MGIuLjc1MDhlY2NmYTE0MyAxMDA2NDQKLS0tIGEvZnMvc3BsaWNlLmMKKysrIGIvZnMvc3Bs
aWNlLmMKQEAgLTM0Miw3ICszNDIsNyBAQCBjb25zdCBzdHJ1Y3QgcGlwZV9idWZfb3BlcmF0aW9u
cyBub3N0ZWFsX3BpcGVfYnVmX29wcyA9IHsKIEVYUE9SVF9TWU1CT0wobm9zdGVhbF9waXBlX2J1
Zl9vcHMpOwogCiBzdGF0aWMgc3NpemVfdCBrZXJuZWxfcmVhZHYoc3RydWN0IGZpbGUgKmZpbGUs
IGNvbnN0IHN0cnVjdCBrdmVjICp2ZWMsCi0JCQkgICAgdW5zaWduZWQgbG9uZyB2bGVuLCBsb2Zm
X3Qgb2Zmc2V0KQorCQkJICAgIHVuc2lnbmVkIGludCB2bGVuLCBsb2ZmX3Qgb2Zmc2V0KQogewog
CW1tX3NlZ21lbnRfdCBvbGRfZnM7CiAJbG9mZl90IHBvcyA9IG9mZnNldDsKZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvZnMuaCBiL2luY2x1ZGUvbGludXgvZnMuaAppbmRleCBjNGFlOWNhZmJi
YmEuLjIxMWJjZTVlNmU2MCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9mcy5oCisrKyBiL2lu
Y2x1ZGUvbGludXgvZnMuaApAQCAtMTg5NSw3ICsxODk1LDcgQEAgc3RhdGljIGlubGluZSBpbnQg
Y2FsbF9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSkK
IGV4dGVybiBzc2l6ZV90IHZmc19yZWFkKHN0cnVjdCBmaWxlICosIGNoYXIgX191c2VyICosIHNp
emVfdCwgbG9mZl90ICopOwogZXh0ZXJuIHNzaXplX3QgdmZzX3dyaXRlKHN0cnVjdCBmaWxlICos
IGNvbnN0IGNoYXIgX191c2VyICosIHNpemVfdCwgbG9mZl90ICopOwogZXh0ZXJuIHNzaXplX3Qg
dmZzX3JlYWR2KHN0cnVjdCBmaWxlICosIGNvbnN0IHN0cnVjdCBpb3ZlYyBfX3VzZXIgKiwKLQkJ
dW5zaWduZWQgbG9uZywgbG9mZl90ICosIHJ3Zl90KTsKKwkJdW5zaWduZWQgaW50LCBsb2ZmX3Qg
KiwgcndmX3QpOwogZXh0ZXJuIHNzaXplX3QgdmZzX2NvcHlfZmlsZV9yYW5nZShzdHJ1Y3QgZmls
ZSAqLCBsb2ZmX3QgLCBzdHJ1Y3QgZmlsZSAqLAogCQkJCSAgIGxvZmZfdCwgc2l6ZV90LCB1bnNp
Z25lZCBpbnQpOwogZXh0ZXJuIHNzaXplX3QgZ2VuZXJpY19jb3B5X2ZpbGVfcmFuZ2Uoc3RydWN0
IGZpbGUgKmZpbGVfaW4sIGxvZmZfdCBwb3NfaW4sCmRpZmYgLS1naXQgYS9saWIvaW92X2l0ZXIu
YyBiL2xpYi9pb3ZfaXRlci5jCmluZGV4IDE2MzUxMTFjNWJkMi4uZGVkOWQ5YzRlYjI4IDEwMDY0
NAotLS0gYS9saWIvaW92X2l0ZXIuYworKysgYi9saWIvaW92X2l0ZXIuYwpAQCAtMTczNCw3ICsx
NzM0LDcgQEAgc3RydWN0IGlvdmVjICppb3ZlY19mcm9tX3VzZXIoY29uc3Qgc3RydWN0IGlvdmVj
IF9fdXNlciAqdXZlYywKIH0KIAogc3NpemVfdCBfX2ltcG9ydF9pb3ZlYyhpbnQgdHlwZSwgY29u
c3Qgc3RydWN0IGlvdmVjIF9fdXNlciAqdXZlYywKLQkJIHVuc2lnbmVkIG5yX3NlZ3MsIHVuc2ln
bmVkIGZhc3Rfc2Vncywgc3RydWN0IGlvdmVjICoqaW92cCwKKwkJIHVuc2lnbmVkIGludCBucl9z
ZWdzLCB1bnNpZ25lZCBpbnQgZmFzdF9zZWdzLCBzdHJ1Y3QgaW92ZWMgKippb3ZwLAogCQkgc3Ry
dWN0IGlvdl9pdGVyICppLCBib29sIGNvbXBhdCkKIHsKIAlzc2l6ZV90IHRvdGFsX2xlbiA9IDA7
CkBAIC0xODAzLDcgKzE4MDMsNyBAQCBzc2l6ZV90IF9faW1wb3J0X2lvdmVjKGludCB0eXBlLCBj
b25zdCBzdHJ1Y3QgaW92ZWMgX191c2VyICp1dmVjLAogICogUmV0dXJuOiBOZWdhdGl2ZSBlcnJv
ciBjb2RlIG9uIGVycm9yLCBieXRlcyBpbXBvcnRlZCBvbiBzdWNjZXNzCiAgKi8KIHNzaXplX3Qg
aW1wb3J0X2lvdmVjKGludCB0eXBlLCBjb25zdCBzdHJ1Y3QgaW92ZWMgX191c2VyICp1dmVjLAot
CQkgdW5zaWduZWQgbnJfc2VncywgdW5zaWduZWQgZmFzdF9zZWdzLAorCQkgdW5zaWduZWQgaW50
IG5yX3NlZ3MsIHVuc2lnbmVkIGludCBmYXN0X3NlZ3MsCiAJCSBzdHJ1Y3QgaW92ZWMgKippb3Zw
LCBzdHJ1Y3QgaW92X2l0ZXIgKmkpCiB7CiAJcmV0dXJuIF9faW1wb3J0X2lvdmVjKHR5cGUsIHV2
ZWMsIG5yX3NlZ3MsIGZhc3Rfc2VncywgaW92cCwgaSwKLS0gCjIuMjkuMC5yYzEuMjk3LmdmYTk3
NDNlNTAxLWdvb2cKCg==
--0000000000003743e505b2462753--
