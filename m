Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9462E2113F5
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgGAT66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAT65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:58:57 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C587EC08C5C1;
        Wed,  1 Jul 2020 12:58:57 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a12so26392718ion.13;
        Wed, 01 Jul 2020 12:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bgOCQsr6d/GZzDpvOsl/yAEb7rk5djdIwXlqwf6AR/k=;
        b=Cv7dtvn4VUC33V6cM1F136mbPfJ171Ek+deRUhAQB5+jSyXjFLBP1zE/Kt16Fwz+1q
         3HVC9SzpRFTBlZ3PKrFH79Rs1yMoARXHsdStHqd9D/MXlM1izkunHAyh9uC/8pgqct1J
         M8s/+bB+xSuDyptbwOlr8F0pp9sKJwxLVdJ5Pbwir9lrAF713fRAUXJhRWtPU7ryX9df
         s6xzYXcBeNfOEplcwx/AsDs1X5pCbc7DLfE4FjLNQ01iQMoJxvglg9L6MbrL0YVYyu+Y
         sE4Cc37KPQWYYpbOaN2KDvXs8PfbV3a4KpTVMvKh8yXPhsHvNdBEeg93m8VzmH9xdDIJ
         xo9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bgOCQsr6d/GZzDpvOsl/yAEb7rk5djdIwXlqwf6AR/k=;
        b=R/aHIkQCvA4eEZ5IMXaaJErIrYyAWNOKCU2KPVSMNVT4a0HmbStpGnnphZHMsa9wRD
         rJMJgJ9JLgAL8knpZ8SwvX4OGrHcOqR7SauYffIx+JDeuXJQwYTgVlKOphm4DXQ3LqjM
         6oi4DZZZlK5ZzLIQPVRvp5VrJkXZfwOmGrwZZgHT4jKE1gWuUDP2NuP9ksJFmrUPT0OY
         4tkhRWuX2I2JBPHfX5wsqEYAx4/16gmbbVRJ3WUpD7d3IvD3Byfm2pd8UBCowGd1f9r+
         qkHf8wS7zKEnH9ds9+9xwLs7vXm7LEOF6fgODaN7RQV0mU0DJ4ry9g+uYMjxjlsebfMv
         niCQ==
X-Gm-Message-State: AOAM530/Qm0UITqYRyQU0yn1Hr8/YdFGljVlQnwqacLoUGTGodu+jCaS
        g67QDaQ2eT4/gGKeMnzJT3OIKznFx6C5WH/dLa4=
X-Google-Smtp-Source: ABdhPJzJBZT+Cx1mgX1VH3IcIKaN3oqhU2MBGfat7O/osa8Xh/ABlnD2RYgQNojSq0b8dYDfJWq4S/CSbuBzLZBLORA=
X-Received: by 2002:a05:6638:14b:: with SMTP id y11mr30822598jao.49.1593633536951;
 Wed, 01 Jul 2020 12:58:56 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
In-Reply-To: <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 1 Jul 2020 12:58:45 -0700
Message-ID: <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Josh Hunt <johunt@akamai.com>
Cc:     jonas.bonn@netrounds.com, Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000df77dd05a966b86c"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000df77dd05a966b86c
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 1, 2020 at 9:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Jun 30, 2020 at 2:08 PM Josh Hunt <johunt@akamai.com> wrote:
> > Do either of you know if there's been any development on a fix for this
> > issue? If not we can propose something.
>
> If you have a reproducer, I can look into this.

Does the attached patch fix this bug completely?

Thanks.

--000000000000df77dd05a966b86c
Content-Type: text/x-patch; charset="US-ASCII"; name="qdisc_run.diff"
Content-Disposition: attachment; filename="qdisc_run.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kc3s8mkg0>
X-Attachment-Id: f_kc3s8mkg0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3BrdF9zY2hlZC5oIGIvaW5jbHVkZS9uZXQvcGt0X3Nj
aGVkLmgKaW5kZXggOTA5MmU2OTcwNTllLi41YTAzY2RlZDMwNTQgMTAwNjQ0Ci0tLSBhL2luY2x1
ZGUvbmV0L3BrdF9zY2hlZC5oCisrKyBiL2luY2x1ZGUvbmV0L3BrdF9zY2hlZC5oCkBAIC0xMjMs
NyArMTIzLDcgQEAgYm9vbCBzY2hfZGlyZWN0X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3Ry
dWN0IFFkaXNjICpxLAogCiB2b2lkIF9fcWRpc2NfcnVuKHN0cnVjdCBRZGlzYyAqcSk7CiAKLXN0
YXRpYyBpbmxpbmUgdm9pZCBxZGlzY19ydW4oc3RydWN0IFFkaXNjICpxKQorc3RhdGljIGlubGlu
ZSBib29sIHFkaXNjX3J1bihzdHJ1Y3QgUWRpc2MgKnEpCiB7CiAJaWYgKHFkaXNjX3J1bl9iZWdp
bihxKSkgewogCQkvKiBOT0xPQ0sgcWRpc2MgbXVzdCBjaGVjayAnc3RhdGUnIHVuZGVyIHRoZSBx
ZGlzYyBzZXFsb2NrCkBAIC0xMzMsNyArMTMzLDkgQEAgc3RhdGljIGlubGluZSB2b2lkIHFkaXNj
X3J1bihzdHJ1Y3QgUWRpc2MgKnEpCiAJCSAgICBsaWtlbHkoIXRlc3RfYml0KF9fUURJU0NfU1RB
VEVfREVBQ1RJVkFURUQsICZxLT5zdGF0ZSkpKQogCQkJX19xZGlzY19ydW4ocSk7CiAJCXFkaXNj
X3J1bl9lbmQocSk7CisJCXJldHVybiB0cnVlOwogCX0KKwlyZXR1cm4gZmFsc2U7CiB9CiAKIHN0
YXRpYyBpbmxpbmUgX19iZTE2IHRjX3NrYl9wcm90b2NvbChjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAq
c2tiKQpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZGV2LmMgYi9uZXQvY29yZS9kZXYuYwppbmRleCA5
MGI1OWZjNTBkYzkuLmM3ZTQ4MzU2MTMyYSAxMDA2NDQKLS0tIGEvbmV0L2NvcmUvZGV2LmMKKysr
IGIvbmV0L2NvcmUvZGV2LmMKQEAgLTM3NDQsNyArMzc0NCw4IEBAIHN0YXRpYyBpbmxpbmUgaW50
IF9fZGV2X3htaXRfc2tiKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBRZGlzYyAqcSwKIAog
CWlmIChxLT5mbGFncyAmIFRDUV9GX05PTE9DSykgewogCQlyYyA9IHEtPmVucXVldWUoc2tiLCBx
LCAmdG9fZnJlZSkgJiBORVRfWE1JVF9NQVNLOwotCQlxZGlzY19ydW4ocSk7CisJCWlmICghcWRp
c2NfcnVuKHEpICYmIHJjID09IE5FVF9YTUlUX1NVQ0NFU1MpCisJCQlfX25ldGlmX3NjaGVkdWxl
KHEpOwogCiAJCWlmICh1bmxpa2VseSh0b19mcmVlKSkKIAkJCWtmcmVlX3NrYl9saXN0KHRvX2Zy
ZWUpOwo=
--000000000000df77dd05a966b86c--
