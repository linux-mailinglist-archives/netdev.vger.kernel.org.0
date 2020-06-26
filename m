Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF8920B7BD
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgFZR61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgFZR60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:58:26 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C27AC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:58:26 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id l9so9210599ilq.12
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CMr8ilHTKgkGkDPe1jYwHRZR6CaGsfJB3GgdJu2TdUw=;
        b=XKfYW37S2lTmI/EQ7OcPEHvjLMEmSUT6L9qzjanRXlbDfwOhXCdaOByIJ8kNfHKHQ3
         TKgmvRLogB0wlDS8Kc5GCkyzCqgrnZyINA56UwlZFzrHWcU/BL9CPReBDRlqAh8442T1
         hlekhG1Y7xmnh4xk6H+gpF/eA6RO/iHKh05/7MmJeDqAFJLwc0M5T0IHDvsORczFD6da
         EHuMY+iSHiRF+yDHov5JMfXoKwEfxi1jrxBUcfCpDl0v7hl/QvtKq1R1Z9m1GFXEBCJj
         x4xWkpxsMWJOnDdF434AgmMlkOrFz8cyw2q3SN8FNf08RYZRQk0O7IO9iDeQSP9Gi9JA
         IV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMr8ilHTKgkGkDPe1jYwHRZR6CaGsfJB3GgdJu2TdUw=;
        b=FlYMv4D0TKL0pajER0J8dTq4PIZ2tiGt8tgycuM22iZKIjOYVHvXxybhDJVW+yLPRG
         C0mPtFTBBnnmJRzuuD/H5gRiBhxy5PqyYD902PNAMECGY2GBITJpDPDmC/Bki9YPHh5K
         h9bwMXz5cOQjHEWqFkItQmvsQ+QfaYS5t0p1eZNqoFJnuVE5Gj6JrmS/eFpLvqovzzNR
         1HOksGUk1kVxxp96THJpMDaHb792v1LA78z6DdSs0gVocqOlqpnytpU1z19zBQME3aiR
         uL/yNDVc0098oFOBUJqJwyX8URWW6HRnfp89FtRyQqimVt2Dr977HEqRcseMdm548Ish
         tUJw==
X-Gm-Message-State: AOAM531h/VhyfOEnhPHB2vbnXFkfeUNTqm9oneBPSUI0wko7TdJfx+mL
        IeoaH2kOAzCyxX9fwvVrXg+QUDKq3rkpHFZ2hfU=
X-Google-Smtp-Source: ABdhPJwoYxdZx8pmc+A++MpDRkOzMxDmjU7STTJVAVJDuYWHdfPxLjKkVxdZF7sPnWdU7z5Y2dK9DpyI27VtcCIA2Co=
X-Received: by 2002:a92:b655:: with SMTP id s82mr1347139ili.268.1593194305547;
 Fri, 26 Jun 2020 10:58:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com> <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com> <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com> <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com> <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan> <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
In-Reply-To: <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 26 Jun 2020 10:58:14 -0700
Message-ID: <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Cameron Berkenpas <cam@neo-zeon.de>
Cc:     Roman Gushchin <guro@fb.com>, Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a4186105a9007402"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a4186105a9007402
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 25, 2020 at 10:23 PM Cameron Berkenpas <cam@neo-zeon.de> wrote:
>
> Hello,
>
> Somewhere along the way I got the impression that it generally takes
> those affected hours before their systems lock up. I'm (generally) able
> to reproduce this issue much faster than that. Regardless, I can help test.
>
> Are there any patches that need testing or is this all still pending
> discussion around the  best way to resolve the issue?

Yes. I come up with a (hopefully) much better patch in the attachment.
Can you help to test it? You need to unapply the previous patch before
applying this one.

(Just in case of any confusion: I still believe we should check NULL on
top of this refcnt fix. But it should be a separate patch.)

Thank you!

--000000000000a4186105a9007402
Content-Type: text/x-patch; charset="UTF-8"; name="cgroup-bpf-ref.patch"
Content-Disposition: attachment; filename="cgroup-bpf-ref.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kbwipyi70>
X-Attachment-Id: f_kbwipyi70

Y29tbWl0IDI1OTE1MDYwNGMwYjc3YzcxN2ZkYWFiMDU3ZGE1NzIyZTJkZmQ5MjIKQXV0aG9yOiBD
b25nIFdhbmcgPHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbT4KRGF0ZTogICBTYXQgSnVuIDEzIDEy
OjM0OjQwIDIwMjAgLTA3MDAKCiAgICBjZ3JvdXA6IGZpeCBjZ3JvdXBfc2tfYWxsb2MoKSBmb3Ig
c2tfY2xvbmVfbG9jaygpCiAgICAKICAgIFdoZW4gd2UgY2xvbmUgYSBzb2NrZXQgaW4gc2tfY2xv
bmVfbG9jaygpLCBpdHMgc2tfY2dycF9kYXRhIGlzCiAgICBjb3BpZWQsIHNvIHRoZSBjZ3JvdXAg
cmVmY250IG11c3QgYmUgdGFrZW4gdG9vLiBBbmQsIHVubGlrZSB0aGUKICAgIHNrX2FsbG9jKCkg
cGF0aCwgc29ja191cGRhdGVfbmV0cHJpb2lkeCgpIGlzIG5vdCBjYWxsZWQgaGVyZS4KICAgIFRo
ZXJlZm9yZSwgaXQgaXMgc2FmZSBhbmQgbmVjZXNzYXJ5IHRvIGdyYWIgdGhlIGNncm91cCByZWZj
bnQKICAgIGV2ZW4gd2hlbiBjZ3JvdXBfc2tfYWxsb2MgaXMgZGlzYWJsZWQuCiAgICAKICAgIHNr
X2Nsb25lX2xvY2soKSBpcyBpbiBCSCBjb250ZXh0IGFueXdheSwgdGhlIGluX2ludGVycnVwdCgp
CiAgICB3b3VsZCB0ZXJtaW5hdGUgdGhpcyBmdW5jdGlvbiBpZiBjYWxsZWQgdGhlcmUuIEFuZCBm
b3Igc2tfYWxsb2MoKQogICAgc2tjZC0+dmFsIGlzIGFsd2F5cyB6ZXJvLiBTbyBpdCdzIHNhZmUg
dG8gZmFjdG9yIG91dCB0aGUgY29kZQogICAgdG8gbWFrZSBpdCBtb3JlIHJlYWRhYmxlLgogICAg
CiAgICBGaXhlczogNGJmYzBiYjJjNjBlICgiYnBmOiBkZWNvdXBsZSB0aGUgbGlmZXRpbWUgb2Yg
Y2dyb3VwX2JwZiBmcm9tIGNncm91cCBpdHNlbGYiKQogICAgUmVwb3J0ZWQtYnk6IENhbWVyb24g
QmVya2VucGFzIDxjYW1AbmVvLXplb24uZGU+CiAgICBSZXBvcnRlZC1ieTogUGV0ZXIgR2VpcyA8
cGd3aXBlb3V0QGdtYWlsLmNvbT4KICAgIFJlcG9ydGVkLWJ5OiBMdSBGZW5ncWkgPGx1ZnEuZm5z
dEBjbi5mdWppdHN1LmNvbT4KICAgIFJlcG9ydGVkLWJ5OiBEYW5pw6tsIFNvbmNrIDxkc29uY2s5
MkBnbWFpbC5jb20+CiAgICBUZXN0ZWQtYnk6IENhbWVyb24gQmVya2VucGFzIDxjYW1AbmVvLXpl
b24uZGU+CiAgICBDYzogRGFuaWVsIEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4KICAg
IENjOiBaZWZhbiBMaSA8bGl6ZWZhbkBodWF3ZWkuY29tPgogICAgQ2M6IFRlanVuIEhlbyA8dGpA
a2VybmVsLm9yZz4KICAgIFNpZ25lZC1vZmYtYnk6IENvbmcgV2FuZyA8eGl5b3Uud2FuZ2NvbmdA
Z21haWwuY29tPgoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvY2dyb3VwLWRlZnMuaCBiL2lu
Y2x1ZGUvbGludXgvY2dyb3VwLWRlZnMuaAppbmRleCA1MjY2MTE1NWY4NWYuLjRmMWNkMGVkYzU3
ZCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9jZ3JvdXAtZGVmcy5oCisrKyBiL2luY2x1ZGUv
bGludXgvY2dyb3VwLWRlZnMuaApAQCAtNzkwLDcgKzc5MCw4IEBAIHN0cnVjdCBzb2NrX2Nncm91
cF9kYXRhIHsKIAl1bmlvbiB7CiAjaWZkZWYgX19MSVRUTEVfRU5ESUFOCiAJCXN0cnVjdCB7Ci0J
CQl1OAlpc19kYXRhOworCQkJdTgJaXNfZGF0YSA6IDE7CisJCQl1OAlub19yZWZjbnQgOiAxOwog
CQkJdTgJcGFkZGluZzsKIAkJCXUxNglwcmlvaWR4OwogCQkJdTMyCWNsYXNzaWQ7CkBAIC04MDAs
NyArODAxLDggQEAgc3RydWN0IHNvY2tfY2dyb3VwX2RhdGEgewogCQkJdTMyCWNsYXNzaWQ7CiAJ
CQl1MTYJcHJpb2lkeDsKIAkJCXU4CXBhZGRpbmc7Ci0JCQl1OAlpc19kYXRhOworCQkJdTgJbm9f
cmVmY250IDogMTsKKwkJCXU4CWlzX2RhdGEgOiAxOwogCQl9IF9fcGFja2VkOwogI2VuZGlmCiAJ
CXU2NAkJdmFsOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jZ3JvdXAuaCBiL2luY2x1ZGUv
bGludXgvY2dyb3VwLmgKaW5kZXggNDU5OGU0ZGE2YjFiLi42MTg4MzhjNDgzMTMgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUvbGludXgvY2dyb3VwLmgKKysrIGIvaW5jbHVkZS9saW51eC9jZ3JvdXAuaApA
QCAtODIyLDYgKzgyMiw3IEBAIGV4dGVybiBzcGlubG9ja190IGNncm91cF9za191cGRhdGVfbG9j
azsKIAogdm9pZCBjZ3JvdXBfc2tfYWxsb2NfZGlzYWJsZSh2b2lkKTsKIHZvaWQgY2dyb3VwX3Nr
X2FsbG9jKHN0cnVjdCBzb2NrX2Nncm91cF9kYXRhICpza2NkKTsKK3ZvaWQgY2dyb3VwX3NrX2Ns
b25lKHN0cnVjdCBzb2NrX2Nncm91cF9kYXRhICpza2NkKTsKIHZvaWQgY2dyb3VwX3NrX2ZyZWUo
c3RydWN0IHNvY2tfY2dyb3VwX2RhdGEgKnNrY2QpOwogCiBzdGF0aWMgaW5saW5lIHN0cnVjdCBj
Z3JvdXAgKnNvY2tfY2dyb3VwX3B0cihzdHJ1Y3Qgc29ja19jZ3JvdXBfZGF0YSAqc2tjZCkKQEAg
LTgzNSw3ICs4MzYsNyBAQCBzdGF0aWMgaW5saW5lIHN0cnVjdCBjZ3JvdXAgKnNvY2tfY2dyb3Vw
X3B0cihzdHJ1Y3Qgc29ja19jZ3JvdXBfZGF0YSAqc2tjZCkKIAkgKi8KIAl2ID0gUkVBRF9PTkNF
KHNrY2QtPnZhbCk7CiAKLQlpZiAodiAmIDEpCisJaWYgKHYgJiAzKQogCQlyZXR1cm4gJmNncnBf
ZGZsX3Jvb3QuY2dycDsKIAogCXJldHVybiAoc3RydWN0IGNncm91cCAqKSh1bnNpZ25lZCBsb25n
KXYgPzogJmNncnBfZGZsX3Jvb3QuY2dycDsKQEAgLTg0Nyw2ICs4NDgsNyBAQCBzdGF0aWMgaW5s
aW5lIHN0cnVjdCBjZ3JvdXAgKnNvY2tfY2dyb3VwX3B0cihzdHJ1Y3Qgc29ja19jZ3JvdXBfZGF0
YSAqc2tjZCkKICNlbHNlCS8qIENPTkZJR19DR1JPVVBfREFUQSAqLwogCiBzdGF0aWMgaW5saW5l
IHZvaWQgY2dyb3VwX3NrX2FsbG9jKHN0cnVjdCBzb2NrX2Nncm91cF9kYXRhICpza2NkKSB7fQor
c3RhdGljIGlubGluZSB2b2lkIGNncm91cF9za19jbG9uZShzdHJ1Y3Qgc29ja19jZ3JvdXBfZGF0
YSAqc2tjZCkge30KIHN0YXRpYyBpbmxpbmUgdm9pZCBjZ3JvdXBfc2tfZnJlZShzdHJ1Y3Qgc29j
a19jZ3JvdXBfZGF0YSAqc2tjZCkge30KIAogI2VuZGlmCS8qIENPTkZJR19DR1JPVVBfREFUQSAq
LwpkaWZmIC0tZ2l0IGEva2VybmVsL2Nncm91cC9jZ3JvdXAuYyBiL2tlcm5lbC9jZ3JvdXAvY2dy
b3VwLmMKaW5kZXggMWVhMTgxYTU4NDY1Li5kZDI0Nzc0N2VjMTQgMTAwNjQ0Ci0tLSBhL2tlcm5l
bC9jZ3JvdXAvY2dyb3VwLmMKKysrIGIva2VybmVsL2Nncm91cC9jZ3JvdXAuYwpAQCAtNjQzOSwx
OCArNjQzOSw4IEBAIHZvaWQgY2dyb3VwX3NrX2FsbG9jX2Rpc2FibGUodm9pZCkKIAogdm9pZCBj
Z3JvdXBfc2tfYWxsb2Moc3RydWN0IHNvY2tfY2dyb3VwX2RhdGEgKnNrY2QpCiB7Ci0JaWYgKGNn
cm91cF9za19hbGxvY19kaXNhYmxlZCkKLQkJcmV0dXJuOwotCi0JLyogU29ja2V0IGNsb25lIHBh
dGggKi8KLQlpZiAoc2tjZC0+dmFsKSB7Ci0JCS8qCi0JCSAqIFdlIG1pZ2h0IGJlIGNsb25pbmcg
YSBzb2NrZXQgd2hpY2ggaXMgbGVmdCBpbiBhbiBlbXB0eQotCQkgKiBjZ3JvdXAgYW5kIHRoZSBj
Z3JvdXAgbWlnaHQgaGF2ZSBhbHJlYWR5IGJlZW4gcm1kaXInZC4KLQkJICogRG9uJ3QgdXNlIGNn
cm91cF9nZXRfbGl2ZSgpLgotCQkgKi8KLQkJY2dyb3VwX2dldChzb2NrX2Nncm91cF9wdHIoc2tj
ZCkpOwotCQljZ3JvdXBfYnBmX2dldChzb2NrX2Nncm91cF9wdHIoc2tjZCkpOworCWlmIChjZ3Jv
dXBfc2tfYWxsb2NfZGlzYWJsZWQpIHsKKwkJc2tjZC0+bm9fcmVmY250ID0gMTsKIAkJcmV0dXJu
OwogCX0KIApAQCAtNjQ3NSwxMCArNjQ2NSwyNyBAQCB2b2lkIGNncm91cF9za19hbGxvYyhzdHJ1
Y3Qgc29ja19jZ3JvdXBfZGF0YSAqc2tjZCkKIAlyY3VfcmVhZF91bmxvY2soKTsKIH0KIAordm9p
ZCBjZ3JvdXBfc2tfY2xvbmUoc3RydWN0IHNvY2tfY2dyb3VwX2RhdGEgKnNrY2QpCit7CisJaWYg
KHNrY2QtPnZhbCkgeworCQlpZiAoc2tjZC0+bm9fcmVmY250KQorCQkJcmV0dXJuOworCQkvKgor
CQkgKiBXZSBtaWdodCBiZSBjbG9uaW5nIGEgc29ja2V0IHdoaWNoIGlzIGxlZnQgaW4gYW4gZW1w
dHkKKwkJICogY2dyb3VwIGFuZCB0aGUgY2dyb3VwIG1pZ2h0IGhhdmUgYWxyZWFkeSBiZWVuIHJt
ZGlyJ2QuCisJCSAqIERvbid0IHVzZSBjZ3JvdXBfZ2V0X2xpdmUoKS4KKwkJICovCisJCWNncm91
cF9nZXQoc29ja19jZ3JvdXBfcHRyKHNrY2QpKTsKKwkJY2dyb3VwX2JwZl9nZXQoc29ja19jZ3Jv
dXBfcHRyKHNrY2QpKTsKKwl9Cit9CisKIHZvaWQgY2dyb3VwX3NrX2ZyZWUoc3RydWN0IHNvY2tf
Y2dyb3VwX2RhdGEgKnNrY2QpCiB7CiAJc3RydWN0IGNncm91cCAqY2dycCA9IHNvY2tfY2dyb3Vw
X3B0cihza2NkKTsKIAorCWlmIChza2NkLT5ub19yZWZjbnQpCisJCXJldHVybjsKIAljZ3JvdXBf
YnBmX3B1dChjZ3JwKTsKIAljZ3JvdXBfcHV0KGNncnApOwogfQpkaWZmIC0tZ2l0IGEvbmV0L2Nv
cmUvc29jay5jIGIvbmV0L2NvcmUvc29jay5jCmluZGV4IGQ4MzJjNjUwMjg3Yy4uMmU1Yjc4NzBl
NWQzIDEwMDY0NAotLS0gYS9uZXQvY29yZS9zb2NrLmMKKysrIGIvbmV0L2NvcmUvc29jay5jCkBA
IC0xOTI2LDcgKzE5MjYsNyBAQCBzdHJ1Y3Qgc29jayAqc2tfY2xvbmVfbG9jayhjb25zdCBzdHJ1
Y3Qgc29jayAqc2ssIGNvbnN0IGdmcF90IHByaW9yaXR5KQogCQkvKiBzay0+c2tfbWVtY2cgd2ls
bCBiZSBwb3B1bGF0ZWQgYXQgYWNjZXB0KCkgdGltZSAqLwogCQluZXdzay0+c2tfbWVtY2cgPSBO
VUxMOwogCi0JCWNncm91cF9za19hbGxvYygmbmV3c2stPnNrX2NncnBfZGF0YSk7CisJCWNncm91
cF9za19jbG9uZSgmbmV3c2stPnNrX2NncnBfZGF0YSk7CiAKIAkJcmN1X3JlYWRfbG9jaygpOwog
CQlmaWx0ZXIgPSByY3VfZGVyZWZlcmVuY2Uoc2stPnNrX2ZpbHRlcik7Cg==
--000000000000a4186105a9007402--
