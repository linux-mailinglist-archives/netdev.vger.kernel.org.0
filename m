Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C14557C7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfFYTaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:30:13 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44063 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFYTaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:30:12 -0400
Received: by mail-pl1-f193.google.com with SMTP id t7so9357393plr.11
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LX55wCa/9x2ikgAs9w+hke5pKkkdyiD3y8BzsqLO/5s=;
        b=ZR6Qlz8GALSyBK5Y7e+aMXwNuC0XCPu72zfoNhbW8+cx24Cr2JTO4H88JkJhH5CASc
         83efuQeErX0A4m+rsTWvp9x5aT2nL/+1lzv3+o9pCG6xFSJD7SBj80B+BM1a9l4Wb/+Q
         LOif24bSvMSUfX6zNs+eJLM/ax336BjXKzvKQoxE3bsPdBs1b/vYRoLuUtnafUN0i/Pg
         FKWEeOZkfXi4e9LzEQw9nZleFPyRn5HaGeGPvVPMRUBJzcBlcqfYKwE62zjXXlCSvoir
         a5afhIX223FLMZXirExa5QgK72vwWPeCa6cgp9GoS26JBpAgKsv1Qk2jbg8BvsEFzdQf
         X48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LX55wCa/9x2ikgAs9w+hke5pKkkdyiD3y8BzsqLO/5s=;
        b=DKiHgC8OzMPWHYVrrNOHoUTNlBi41xJpSw2gUEp22hOIRY9ICqtNnkyoVu/Cib+68T
         qUrP4Aw5SWg4Thtw+hRjRtYY2iANYORjq3F716xoVM+M2F1nPp79zk88cJ4dg8SdvooW
         ODhatR50UZdMxtqMOj4cFZG7CIE0lb5fftRCSXloc2606IjMd7Nuxbz5PF1zNP0t0XcW
         z9pxCVQ+YumjdwSrISbAivc2SVtOFSDtB2PLJ2Mj0jnJSgqLpK7H0HGqAoYpd17ephnj
         yDOI3zB/2VIwcba8ZlAJNJ4cprRySkQJjCYod1ZkxuOZtV+IrXKWNcTA0kg37ZtabGC0
         nupw==
X-Gm-Message-State: APjAAAXXM2NqvEKF5D69lBW46sTLq8UucR0P1GMxUgKr1wc8JK7jwuft
        MVSOMdGndlrnB5pLDkPcgMR9gExJj/2wD5tQ3dc=
X-Google-Smtp-Source: APXvYqygTixIAv8vsmgP0AxtHDFbKIsCNhtBCy/nKcsPd1rPEMz350tFrMJ3PfsbdMztHR9VmtJBx1eUnYi5qySVeQo=
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr421962plr.12.1561491011919;
 Tue, 25 Jun 2019 12:30:11 -0700 (PDT)
MIME-Version: 1.0
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
 <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
 <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
 <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com>
 <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com> <CAM_iQpW_-e+duPqKVXSDn7fp3WOKfs+RgVkFkfeQJQUTP_0x1Q@mail.gmail.com>
In-Reply-To: <CAM_iQpW_-e+duPqKVXSDn7fp3WOKfs+RgVkFkfeQJQUTP_0x1Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 25 Jun 2019 12:29:59 -0700
Message-ID: <CAM_iQpXj1A05FdbD93iWQp9Tcd6aW0BQ3_xFx8bNEbqA00RGAg@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
Content-Type: multipart/mixed; boundary="000000000000164948058c2af5d9"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000164948058c2af5d9
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 25, 2019 at 11:07 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On one hand, its callers should not need to worry about details
> like overflow. On the other hand, in fact it does exactly what its
> callers tell it to do, the problematic part is actually the
> incremented id. On 64bit, it is fairly easy, we can just simply
> know 'long' is longer than 32bit and leverage this to detect overflow,
> but on 32bit this clearly doesn't work.
>
> Let me think about it.

Davide, do you mind to try the attached patch?

It should handle this overflow case more gracefully, I hope.

Thanks.

--000000000000164948058c2af5d9
Content-Type: application/octet-stream; name="idr_get_next_ul.diff"
Content-Disposition: attachment; filename="idr_get_next_ul.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_jxc7d6tt0>
X-Attachment-Id: f_jxc7d6tt0

Y29tbWl0IDY4NTkzNGY5ZWVkOWI1MGE0NmQzM2E5ZWM5NjcxODAwMzk3ZDIwY2MKQXV0aG9yOiBD
b25nIFdhbmcgPHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbT4KRGF0ZTogICBUdWUgSnVuIDI1IDEy
OjIzOjE4IDIwMTkgLTA3MDAKCiAgICBpZHI6IGZpeCBpZHJfZ2V0X25leHRfdWwoKSB1c2FnZQog
ICAgCiAgICBSZXBvcnRlZC1ieTogTGkgU2h1YW5nIDxzaHVhbGlAcmVkaGF0LmNvbT4KICAgIENj
OiBEYXZpZGUgQ2FyYXR0aSA8ZGNhcmF0dGlAcmVkaGF0LmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6
IENvbmcgV2FuZyA8eGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tPgoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3VudGVycy5jIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NvdW50ZXJzLmMKaW5kZXggYzZj
MjhmNTZhYTI5Li5jNzNmODBiZGRkZTQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9mc19jb3VudGVycy5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3VudGVycy5jCkBAIC0xMDUsMTAgKzEwNSwxMSBA
QCBzdGF0aWMgc3RydWN0IGxpc3RfaGVhZCAqbWx4NV9mY19jb3VudGVyc19sb29rdXBfbmV4dChz
dHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LAogCiAJcmN1X3JlYWRfbG9jaygpOwogCS8qIHNraXAg
Y291bnRlcnMgdGhhdCBhcmUgaW4gaWRyLCBidXQgbm90IHlldCBpbiBjb3VudGVycyBsaXN0ICov
Ci0Jd2hpbGUgKChjb3VudGVyID0gaWRyX2dldF9uZXh0X3VsKCZmY19zdGF0cy0+Y291bnRlcnNf
aWRyLAotCQkJCQkgICZuZXh0X2lkKSkgIT0gTlVMTCAmJgotCSAgICAgICBsaXN0X2VtcHR5KCZj
b3VudGVyLT5saXN0KSkKLQkJbmV4dF9pZCsrOworCWlkcl9mb3JfZWFjaF9lbnRyeV9jb250aW51
ZV91bCgmZmNfc3RhdHMtPmNvdW50ZXJzX2lkciwKKwkJCQkgICAgICAgY291bnRlciwgbmV4dF9p
ZCkgeworCQlpZiAobGlzdF9lbXB0eSgmY291bnRlci0+bGlzdCkpCisJCQljb250aW51ZTsKKwl9
CiAJcmN1X3JlYWRfdW5sb2NrKCk7CiAKIAlyZXR1cm4gY291bnRlciA/ICZjb3VudGVyLT5saXN0
IDogJmZjX3N0YXRzLT5jb3VudGVyczsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaWRyLmgg
Yi9pbmNsdWRlL2xpbnV4L2lkci5oCmluZGV4IGVlN2FiYWUxNDNkMy4uYWY3YTY3ZTY1YzFjIDEw
MDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2lkci5oCisrKyBiL2luY2x1ZGUvbGludXgvaWRyLmgK
QEAgLTE5OCw3ICsxOTgsMjEgQEAgc3RhdGljIGlubGluZSB2b2lkIGlkcl9wcmVsb2FkX2VuZCh2
b2lkKQogICogaXMgY29udmVuaWVudCBmb3IgYSAibm90IGZvdW5kIiB2YWx1ZS4KICAqLwogI2Rl
ZmluZSBpZHJfZm9yX2VhY2hfZW50cnlfdWwoaWRyLCBlbnRyeSwgaWQpCQkJXAotCWZvciAoaWQg
PSAwOyAoKGVudHJ5KSA9IGlkcl9nZXRfbmV4dF91bChpZHIsICYoaWQpKSkgIT0gTlVMTDsgKytp
ZCkKKwlmb3IgKGlkID0gMDsJCQkJCQlcCisJICAgICAodTMyKWlkICsgMSA+IGlkICYmICgoZW50
cnkpID0gaWRyX2dldF9uZXh0X3VsKGlkciwgJihpZCkpKSAhPSBOVUxMOyBcCisJICAgICArK2lk
KQorCisvKioKKyAqIGlkcl9mb3JfZWFjaF9lbnRyeV9jb250aW51ZV91bCgpIC0gQ29udGludWUg
aXRlcmF0aW9uIG92ZXIgYW4gSURSJ3MgZWxlbWVudHMgb2YgYSBnaXZlbiB0eXBlCisgKiBAaWRy
OiBJRFIgaGFuZGxlLgorICogQGVudHJ5OiBUaGUgdHlwZSAqIHRvIHVzZSBhcyBhIGN1cnNvci4K
KyAqIEBpZDogRW50cnkgSUQuCisgKgorICogQ29udGludWUgdG8gaXRlcmF0ZSBvdmVyIGVudHJp
ZXMsIGNvbnRpbnVpbmcgYWZ0ZXIgdGhlIGN1cnJlbnQgcG9zaXRpb24uCisgKi8KKyNkZWZpbmUg
aWRyX2Zvcl9lYWNoX2VudHJ5X2NvbnRpbnVlX3VsKGlkciwgZW50cnksIGlkKQkJCVwKKwlmb3Ig
KDsgKHUzMilpZCArIDEgPiBpZCAmJiAoKGVudHJ5KSA9IGlkcl9nZXRfbmV4dF91bChpZHIsICYo
aWQpKSkgIT0gTlVMTDsgXAorCSAgICAgKytpZCkKIAogLyoqCiAgKiBpZHJfZm9yX2VhY2hfZW50
cnlfY29udGludWUoKSAtIENvbnRpbnVlIGl0ZXJhdGlvbiBvdmVyIGFuIElEUidzIGVsZW1lbnRz
IG9mIGEgZ2l2ZW4gdHlwZQpkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Nsc19mbG93ZXIuYyBiL25l
dC9zY2hlZC9jbHNfZmxvd2VyLmMKaW5kZXggZWVkZDU3ODZjMDg0Li4wNjMzOGRhZGQ1ZTQgMTAw
NjQ0Ci0tLSBhL25ldC9zY2hlZC9jbHNfZmxvd2VyLmMKKysrIGIvbmV0L3NjaGVkL2Nsc19mbG93
ZXIuYwpAQCAtNTI4LDE3ICs1MjgsMTggQEAgc3RhdGljIHN0cnVjdCBjbHNfZmxfZmlsdGVyICpm
bF9nZXRfbmV4dF9maWx0ZXIoc3RydWN0IHRjZl9wcm90byAqdHAsCiAJCQkJCQl1bnNpZ25lZCBs
b25nICpoYW5kbGUpCiB7CiAJc3RydWN0IGNsc19mbF9oZWFkICpoZWFkID0gZmxfaGVhZF9kZXJl
ZmVyZW5jZSh0cCk7CisJdW5zaWduZWQgbG9uZyBpZCA9ICpoYW5kbGU7CiAJc3RydWN0IGNsc19m
bF9maWx0ZXIgKmY7CiAKIAlyY3VfcmVhZF9sb2NrKCk7Ci0Jd2hpbGUgKChmID0gaWRyX2dldF9u
ZXh0X3VsKCZoZWFkLT5oYW5kbGVfaWRyLCBoYW5kbGUpKSkgeworCWlkcl9mb3JfZWFjaF9lbnRy
eV9jb250aW51ZV91bCgmaGVhZC0+aGFuZGxlX2lkciwgZiwgaWQpIHsKIAkJLyogZG9uJ3QgcmV0
dXJuIGZpbHRlcnMgdGhhdCBhcmUgYmVpbmcgZGVsZXRlZCAqLwogCQlpZiAocmVmY291bnRfaW5j
X25vdF96ZXJvKCZmLT5yZWZjbnQpKQogCQkJYnJlYWs7Ci0JCSsrKCpoYW5kbGUpOwogCX0KIAly
Y3VfcmVhZF91bmxvY2soKTsKIAorCSpoYW5kbGUgPSBpZDsKIAlyZXR1cm4gZjsKIH0KIAo=
--000000000000164948058c2af5d9--
