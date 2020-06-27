Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F35E20C39B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 20:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgF0Szf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 14:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgF0Sze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 14:55:34 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A060C061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 11:55:34 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id c4so13201546iot.4
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 11:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/a6EXA5eshXsIGumFQq8UqppBfxlulH+ZWY6Hat+Xbw=;
        b=B8hE2VE3k7JiLZj8Ds03MYpbgDWSys6Q7KYp1Ox0fn62LjxgvIGIvCkJ66mjOx0Qm1
         RngBWbSLwzlpwY6xr9ueuft4HutI4HlMMSBLlyXkOersUUJZegiPZQNWAmH8JIUl96rk
         OrNxYnSmYDBCwAsHcp1rybqDyD0J2seZ84N64uzlSA2MpflL2a0p+JEFMlXS+weM/IUk
         N2Zb6EFQTksj59aKg1U6yVuVXfxSSxTyXYzK5ORNjIuNCjzbxaSs/Dubit71a+PGxd24
         7C5i4DjhBdXgx+MIhtDbZAeTBfdppXPivgWA+n7AIPEEKgmU4GKZPg3lVjn8b9O0bKD8
         G4uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/a6EXA5eshXsIGumFQq8UqppBfxlulH+ZWY6Hat+Xbw=;
        b=TYTdpGgn4eqGpLNY+SgwDUMhuoaoyKQflrcFfpqlTbEFgCtvFBbRWBkbtVf80ceexM
         Qeo/PEgqwdynnjhjYTT1l14Bmfs2dF1O/H8O5hSmyb9xRHKJjxi1av0OsF1BbyN6ZGMa
         6X7Jm81PselXAcVphg5w72Ay3nANgw2FJ6yezJylGOKNcohr/Da0rAveLtQ3eX/IL+Yx
         QieuUsr6dHyOAn+aLzDrkIcCaebRwDu4QqpTQHSBrLeD64m02DuT9HIUqfAiNmsKwS2W
         v/ids9Ru5fLhsBWQlaUpFpy6+8J3nbBYgocY9fru/hB3Be9+6kdcEdquc3f9PggDeQY1
         DUig==
X-Gm-Message-State: AOAM533JRlNUX8nxn/ZXXH5oD7Xe2j1xrn4yE1Svgq09JrfYxIiPbYRS
        kkS4k4TP6VXT+hdQLWKsoA/HAFN1ue2e/MgszEi5mxDvCcM=
X-Google-Smtp-Source: ABdhPJxoD+AIeGjJzHp/HB1ve7x660poZBi7dCcR/ROkq1FuRQd8XDcpxpT1jQl+FQVbnqj5lF9bHfxYtgduyXXYoXE=
X-Received: by 2002:a05:6602:2f0a:: with SMTP id q10mr9401173iow.134.1593284133130;
 Sat, 27 Jun 2020 11:55:33 -0700 (PDT)
MIME-Version: 1.0
References: <1593217863-2964-1-git-send-email-stranche@codeaurora.org>
In-Reply-To: <1593217863-2964-1-git-send-email-stranche@codeaurora.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 27 Jun 2020 11:55:21 -0700
Message-ID: <CAM_iQpXXdpdKvVY4G=y8=R4TsYE0ovac=OCNfiaMmD=Rgn2utQ@mail.gmail.com>
Subject: Re: [PATCH net] genetlink: take netlink table lock when (un)registering
To:     Sean Tranchetti <stranche@codeaurora.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: multipart/mixed; boundary="000000000000c833db05a9155e58"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c833db05a9155e58
Content-Type: text/plain; charset="UTF-8"

On Fri, Jun 26, 2020 at 5:32 PM Sean Tranchetti <stranche@codeaurora.org> wrote:
>
> A potential deadlock can occur during registering or unregistering a new
> generic netlink family between the main nl_table_lock and the cb_lock where
> each thread wants the lock held by the other, as demonstrated below.
>
> 1) Thread 1 is performing a netlink_bind() operation on a socket. As part
>    of this call, it will call netlink_lock_table(), incrementing the
>    nl_table_users count to 1.
> 2) Thread 2 is registering (or unregistering) a genl_family via the
>    genl_(un)register_family() API. The cb_lock semaphore will be taken for
>    writing.
> 3) Thread 1 will call genl_bind() as part of the bind operation to handle
>    subscribing to GENL multicast groups at the request of the user. It will
>    attempt to take the cb_lock semaphore for reading, but it will fail and
>    be scheduled away, waiting for Thread 2 to finish the write.
> 4) Thread 2 will call netlink_table_grab() during the (un)registration
>    call. However, as Thread 1 has incremented nl_table_users, it will not
>    be able to proceed, and both threads will be stuck waiting for the
>    other.
>
> To avoid this scenario, the locks should be acquired in the same order by
> both threads. Since both the register and unregister functions need to take
> the nl_table_lock in their processing, it makes sense to explicitly acquire
> them before they lock the genl_mutex and the cb_lock. In unregistering, no
> other change is needed aside from this locking change.

Like the kernel test robot reported, you can not call genl_lock_all while
holding netlink_table_grab() which is effectively a write lock.

To me, it seems genl_bind() can be just removed as there is no one
in-tree uses family->mcast_bind(). Can you test the attached patch?
It seems sufficient to fix this deadlock.

Thanks.

--000000000000c833db05a9155e58
Content-Type: text/x-patch; charset="US-ASCII"; name="genetlink-mcast-bind.diff"
Content-Disposition: attachment; filename="genetlink-mcast-bind.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kby05kgm0>
X-Attachment-Id: f_kby05kgm0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2dlbmV0bGluay5oIGIvaW5jbHVkZS9uZXQvZ2VuZXRs
aW5rLmgKaW5kZXggYWQ3MWVkNGY1NWZmLi42ZTVmMWUxYWE4MjIgMTAwNjQ0Ci0tLSBhL2luY2x1
ZGUvbmV0L2dlbmV0bGluay5oCisrKyBiL2luY2x1ZGUvbmV0L2dlbmV0bGluay5oCkBAIC0zNSwx
MiArMzUsNiBAQCBzdHJ1Y3QgZ2VubF9pbmZvOwogICoJZG8gYWRkaXRpb25hbCwgY29tbW9uLCBm
aWx0ZXJpbmcgYW5kIHJldHVybiBhbiBlcnJvcgogICogQHBvc3RfZG9pdDogY2FsbGVkIGFmdGVy
IGFuIG9wZXJhdGlvbidzIGRvaXQgY2FsbGJhY2ssIGl0IG1heQogICoJdW5kbyBvcGVyYXRpb25z
IGRvbmUgYnkgcHJlX2RvaXQsIGZvciBleGFtcGxlIHJlbGVhc2UgbG9ja3MKLSAqIEBtY2FzdF9i
aW5kOiBhIHNvY2tldCBib3VuZCB0byB0aGUgZ2l2ZW4gbXVsdGljYXN0IGdyb3VwICh3aGljaAot
ICoJaXMgZ2l2ZW4gYXMgdGhlIG9mZnNldCBpbnRvIHRoZSBncm91cHMgYXJyYXkpCi0gKiBAbWNh
c3RfdW5iaW5kOiBhIHNvY2tldCB3YXMgdW5ib3VuZCBmcm9tIHRoZSBnaXZlbiBtdWx0aWNhc3Qg
Z3JvdXAuCi0gKglOb3RlIHRoYXQgdW5iaW5kKCkgd2lsbCBub3QgYmUgY2FsbGVkIHN5bW1ldHJp
Y2FsbHkgaWYgdGhlCi0gKglnZW5lcmljIG5ldGxpbmsgZmFtaWx5IGlzIHJlbW92ZWQgd2hpbGUg
dGhlcmUgYXJlIHN0aWxsIG9wZW4KLSAqCXNvY2tldHMuCiAgKiBAbWNncnBzOiBtdWx0aWNhc3Qg
Z3JvdXBzIHVzZWQgYnkgdGhpcyBmYW1pbHkKICAqIEBuX21jZ3JwczogbnVtYmVyIG9mIG11bHRp
Y2FzdCBncm91cHMKICAqIEBtY2dycF9vZmZzZXQ6IHN0YXJ0aW5nIG51bWJlciBvZiBtdWx0aWNh
c3QgZ3JvdXAgSURzIGluIHRoaXMgZmFtaWx5CkBAIC02Myw4ICs1Nyw2IEBAIHN0cnVjdCBnZW5s
X2ZhbWlseSB7CiAJdm9pZAkJCSgqcG9zdF9kb2l0KShjb25zdCBzdHJ1Y3QgZ2VubF9vcHMgKm9w
cywKIAkJCQkJICAgICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCQkJCQkgICAgIHN0cnVjdCBnZW5s
X2luZm8gKmluZm8pOwotCWludAkJCSgqbWNhc3RfYmluZCkoc3RydWN0IG5ldCAqbmV0LCBpbnQg
Z3JvdXApOwotCXZvaWQJCQkoKm1jYXN0X3VuYmluZCkoc3RydWN0IG5ldCAqbmV0LCBpbnQgZ3Jv
dXApOwogCWNvbnN0IHN0cnVjdCBnZW5sX29wcyAqCW9wczsKIAljb25zdCBzdHJ1Y3QgZ2VubF9t
dWx0aWNhc3RfZ3JvdXAgKm1jZ3JwczsKIAl1bnNpZ25lZCBpbnQJCW5fb3BzOwpkaWZmIC0tZ2l0
IGEvbmV0L25ldGxpbmsvZ2VuZXRsaW5rLmMgYi9uZXQvbmV0bGluay9nZW5ldGxpbmsuYwppbmRl
eCBhOTE0YjkzNjVhNDYuLjkzOTVlZThhODY4ZCAxMDA2NDQKLS0tIGEvbmV0L25ldGxpbmsvZ2Vu
ZXRsaW5rLmMKKysrIGIvbmV0L25ldGxpbmsvZ2VuZXRsaW5rLmMKQEAgLTExNDQsNjAgKzExNDQs
MTEgQEAgc3RhdGljIHN0cnVjdCBnZW5sX2ZhbWlseSBnZW5sX2N0cmwgX19yb19hZnRlcl9pbml0
ID0gewogCS5uZXRuc29rID0gdHJ1ZSwKIH07CiAKLXN0YXRpYyBpbnQgZ2VubF9iaW5kKHN0cnVj
dCBuZXQgKm5ldCwgaW50IGdyb3VwKQotewotCXN0cnVjdCBnZW5sX2ZhbWlseSAqZjsKLQlpbnQg
ZXJyID0gLUVOT0VOVDsKLQl1bnNpZ25lZCBpbnQgaWQ7Ci0KLQlkb3duX3JlYWQoJmNiX2xvY2sp
OwotCi0JaWRyX2Zvcl9lYWNoX2VudHJ5KCZnZW5sX2ZhbV9pZHIsIGYsIGlkKSB7Ci0JCWlmIChn
cm91cCA+PSBmLT5tY2dycF9vZmZzZXQgJiYKLQkJICAgIGdyb3VwIDwgZi0+bWNncnBfb2Zmc2V0
ICsgZi0+bl9tY2dycHMpIHsKLQkJCWludCBmYW1fZ3JwID0gZ3JvdXAgLSBmLT5tY2dycF9vZmZz
ZXQ7Ci0KLQkJCWlmICghZi0+bmV0bnNvayAmJiBuZXQgIT0gJmluaXRfbmV0KQotCQkJCWVyciA9
IC1FTk9FTlQ7Ci0JCQllbHNlIGlmIChmLT5tY2FzdF9iaW5kKQotCQkJCWVyciA9IGYtPm1jYXN0
X2JpbmQobmV0LCBmYW1fZ3JwKTsKLQkJCWVsc2UKLQkJCQllcnIgPSAwOwotCQkJYnJlYWs7Ci0J
CX0KLQl9Ci0JdXBfcmVhZCgmY2JfbG9jayk7Ci0KLQlyZXR1cm4gZXJyOwotfQotCi1zdGF0aWMg
dm9pZCBnZW5sX3VuYmluZChzdHJ1Y3QgbmV0ICpuZXQsIGludCBncm91cCkKLXsKLQlzdHJ1Y3Qg
Z2VubF9mYW1pbHkgKmY7Ci0JdW5zaWduZWQgaW50IGlkOwotCi0JZG93bl9yZWFkKCZjYl9sb2Nr
KTsKLQotCWlkcl9mb3JfZWFjaF9lbnRyeSgmZ2VubF9mYW1faWRyLCBmLCBpZCkgewotCQlpZiAo
Z3JvdXAgPj0gZi0+bWNncnBfb2Zmc2V0ICYmCi0JCSAgICBncm91cCA8IGYtPm1jZ3JwX29mZnNl
dCArIGYtPm5fbWNncnBzKSB7Ci0JCQlpbnQgZmFtX2dycCA9IGdyb3VwIC0gZi0+bWNncnBfb2Zm
c2V0OwotCi0JCQlpZiAoZi0+bWNhc3RfdW5iaW5kKQotCQkJCWYtPm1jYXN0X3VuYmluZChuZXQs
IGZhbV9ncnApOwotCQkJYnJlYWs7Ci0JCX0KLQl9Ci0JdXBfcmVhZCgmY2JfbG9jayk7Ci19Ci0K
IHN0YXRpYyBpbnQgX19uZXRfaW5pdCBnZW5sX3Blcm5ldF9pbml0KHN0cnVjdCBuZXQgKm5ldCkK
IHsKIAlzdHJ1Y3QgbmV0bGlua19rZXJuZWxfY2ZnIGNmZyA9IHsKIAkJLmlucHV0CQk9IGdlbmxf
cmN2LAogCQkuZmxhZ3MJCT0gTkxfQ0ZHX0ZfTk9OUk9PVF9SRUNWLAotCQkuYmluZAkJPSBnZW5s
X2JpbmQsCi0JCS51bmJpbmQJCT0gZ2VubF91bmJpbmQsCiAJfTsKIAogCS8qIHdlJ2xsIGJ1bXAg
dGhlIGdyb3VwIG51bWJlciByaWdodCBhZnRlcndhcmRzICovCg==
--000000000000c833db05a9155e58--
