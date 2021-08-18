Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F5A3EFDCF
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 09:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238815AbhHRHe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 03:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239102AbhHRHeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 03:34:24 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F17C061764;
        Wed, 18 Aug 2021 00:33:50 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id m193so3446046ybf.9;
        Wed, 18 Aug 2021 00:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IwHpOsEyYmw6itaXpTQjzMYxKX8h8NTahqts1AkINFA=;
        b=tgolvYfEccPL/x/zPfcZ/qILKehn6CmBOYAPkr9kTl2458DvReJ8FkIUGqVVDcT2DJ
         gnrRJ8E531g9Z1XshkyqTXMXWUlmoF82rCdvFSxl8/0P8GJoBx3yNYzvn45Lch4o2j0h
         uLiexUeEqGZdeOp/1YlIpnWYCvD4nISbDGUEcd2XcsbR21pzxlJKKfiYsvys6mUI2HY0
         VqAkrRg/dDRbV6oc6Bf6ebP50LsuSyt75JT9Awlm/X4pblq9vLK9QG30Pb6c68ts4iPW
         50Chnr2NV7WvoXjFM1Mn9XgmN0FZeRW4Jc5Zb9UNbdNrfCTFW5fwCIY9MUDmcz6Dj8Qu
         VUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IwHpOsEyYmw6itaXpTQjzMYxKX8h8NTahqts1AkINFA=;
        b=eaH5utqWWSyT3mG1ItPEhHNwMJBcTS0TX49M83TbS35Mim1VEYcCL3h1hKr6f+vgze
         LZc8Zo645pVc1KHKkRPjIRPK90/9RcrJIhD31o0JDtvBHCC3czWgn4CtCPY8/DhtZh/2
         FCG3Ok9VfhENySIC3YnTlq+L0GN9mJZBoeQ94RGt7jkMXUqXGdXbY+DKIuFpJWZSQxB5
         QiHDLE7y+qpFOM1N9gScQN793GBiHcz4ryGlLZArXQPV5PGTL694lDU3Oo4hsEj7cQ/e
         g8oPaxyQOCE1iIDCOyUp36UGFUYaFeDfrTWCYMufhe4wRWsvJZOab9zQUQhPRwoHOtkW
         /pFQ==
X-Gm-Message-State: AOAM531OSY31japlW31R3Ww6Bi6GO99G61SC+jC5boTwzLGH0kdjlT0W
        oorhX3+BCAel35EC4p8BDeJeEh/gzbtFoT/zTA4=
X-Google-Smtp-Source: ABdhPJxPpjdkIAvA8kAq7id9H/f4S9Gcqa/s2i6dovaDhO3cl0aGwDSyXzC0hcmipCRBR3vek24L2UEJWcS97xh5CM8=
X-Received: by 2002:a25:1e89:: with SMTP id e131mr9600187ybe.90.1629272029553;
 Wed, 18 Aug 2021 00:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAFcO6XOLxfHcRFVNvUTPVNiyQ4FKwZ-x9SDgL7n9EJphoxawxQ@mail.gmail.com>
In-Reply-To: <CAFcO6XOLxfHcRFVNvUTPVNiyQ4FKwZ-x9SDgL7n9EJphoxawxQ@mail.gmail.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Wed, 18 Aug 2021 15:33:38 +0800
Message-ID: <CAFcO6XOGjHzys4GywczXyePiPcEXw7P=gBPwYU5nv0f-a=eFig@mail.gmail.com>
Subject: Re: Another out-of-bound Read in qrtr_endpoint_post in net/qrtr/qrtr.c
To:     mani@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000907d8d05c9d07426"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000907d8d05c9d07426
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here I make a patch for this issue.

Regards,
 butt3rflyh4ck.
On Tue, Aug 17, 2021 at 7:52 PM butt3rflyh4ck
<butterflyhuangxx@gmail.com> wrote:
>
> Hi, there is another out-of-bound read in qrtr_endpoint_post in
> net/qrtr/qrtr.c in 5.14.0-rc6+ and reproduced.
>
> #analyze
> In qrtr_endpoint_post, it would post incoming data from the user, the
> =E2=80=98len=E2=80=99 is the size of data, the problem is in 'size'.
> ```
> case QRTR_PROTO_VER_1:
> if (len < sizeof(*v1))   // just  judge len < sizeof(*v1)
> goto err;
> v1 =3D data;
> hdrlen =3D sizeof(*v1);
> [...]
> size =3D le32_to_cpu(v1->size);
> break;
> ```
> If the version of qrtr proto  is QRTR_PROTO_VER_1, hdrlen is
> sizeof(qrtr_hdr_v1) and size is le32_to_cpu(v1->size).
> ```
> if (len < sizeof(*v2))  // just judge len < sizeof(*v2)
> goto err;
> v2 =3D data;
> hdrlen =3D sizeof(*v2) + v2->optlen;
> [...]
> size =3D le32_to_cpu(v2->size);
> break;
> ```
> if version of qrtr proto is QRTR_PROTO_VER_2, hdrlen is
> sizeof(qrtr_hdr_v2) and size is le32_to_cpu(v2->size).
>
> the code as below can be bypassed.
> ```
> if (len !=3D ALIGN(size, 4) + hdrlen)
> goto err;
> ```
> if we set size zero and  make 'len' equal to 'hdrlen', the judgement
> is bypassed.
>
> ```
> if (cb->type =3D=3D QRTR_TYPE_NEW_SERVER) {
> /* Remote node endpoint can bridge other distant nodes */
> const struct qrtr_ctrl_pkt *pkt =3D data + hdrlen;
>
> qrtr_node_assign(node, le32_to_cpu(pkt->server.node)); //[1]
> }
> ```
> *pkt =3D data + hdrlen =3D data + len, so pkt pointer the end of data.
> [1]le32_to_cpu(pkt->server.node) could read out of bound.
>
> #crash log:
> [ 2436.657182][ T8433]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 2436.658615][ T8433] BUG: KASAN: slab-out-of-bounds in
> qrtr_endpoint_post+0x478/0x5b0
> [ 2436.659971][ T8433] Read of size 4 at addr ffff88800ef30a2c by task
> qrtr_endpoint_p/8433
> [ 2436.661476][ T8433]
> [ 2436.661964][ T8433] CPU: 1 PID: 8433 Comm: qrtr_endpoint_p Not
> tainted 5.14.0-rc6+ #7
> [ 2436.663431][ T8433] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> [ 2436.665220][ T8433] Call Trace:
> [ 2436.665870][ T8433]  dump_stack_lvl+0x57/0x7d
> [ 2436.666748][ T8433]  print_address_description.constprop.0.cold+0x93/0=
x334
> [ 2436.668054][ T8433]  ? qrtr_endpoint_post+0x478/0x5b0
> [ 2436.669072][ T8433]  ? qrtr_endpoint_post+0x478/0x5b0
> [ 2436.669957][ T8433]  kasan_report.cold+0x83/0xdf
> [ 2436.670833][ T8433]  ? qrtr_endpoint_post+0x478/0x5b0
> [ 2436.671780][ T8433]  kasan_check_range+0x14e/0x1b0
> [ 2436.672707][ T8433]  qrtr_endpoint_post+0x478/0x5b0
> [ 2436.673646][ T8433]  qrtr_tun_write_iter+0x8b/0xe0
> [ 2436.674587][ T8433]  new_sync_write+0x245/0x360
> [ 2436.675462][ T8433]  ? new_sync_read+0x350/0x350
> [ 2436.676353][ T8433]  ? policy_view_capable+0x3b0/0x6d0
> [ 2436.677266][ T8433]  ? apparmor_task_setrlimit+0x4d0/0x4d0
> [ 2436.678251][ T8433]  vfs_write+0x344/0x4e0
> [ 2436.679024][ T8433]  ksys_write+0xc4/0x160
> [ 2436.679758][ T8433]  ? __ia32_sys_read+0x40/0x40
> [ 2436.680605][ T8433]  ? syscall_enter_from_user_mode+0x21/0x70
> [ 2436.681661][ T8433]  do_syscall_64+0x35/0xb0
> [ 2436.682445][ T8433]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> #fix suggestion
> 'size' should not be zero, it is length of packet, excluding this
> header or (excluding this header and optlen).
>
>
> Regards,
>  butt3rflyh4ck.
> --
> Active Defense Lab of Venustech



--=20
Active Defense Lab of Venustech

--000000000000907d8d05c9d07426
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-net-qrtr-fix-another-OOB-Read-in-qrtr_endpoint_post.patch"
Content-Disposition: attachment; 
	filename="0001-net-qrtr-fix-another-OOB-Read-in-qrtr_endpoint_post.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksh6hndg0>
X-Attachment-Id: f_ksh6hndg0

RnJvbSAxOGQ5ZjgzZjE3Mzc1Nzg1YmVhZGJlNmEwZDBlZTU5NTAzZjY1OTI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBidXR0M3JmbHloNGNrIDxidXR0ZXJmbHloaHVhbmd4eEBnbWFp
bC5jb20+CkRhdGU6IFdlZCwgMTggQXVnIDIwMjEgMTQ6MTk6MzggKzA4MDAKU3ViamVjdDogW1BB
VENIXSBuZXQ6IHFydHI6IGZpeCBhbm90aGVyIE9PQiBSZWFkIGluIHFydHJfZW5kcG9pbnRfcG9z
dAoKVGhpcyBjaGVjayB3YXMgaW5jb21wbGV0ZSwgZGlkIG5vdCBjb25zaWRlciBzaXplIGlzIDA6
CgoJaWYgKGxlbiAhPSBBTElHTihzaXplLCA0KSArIGhkcmxlbikKICAgICAgICAgICAgICAgICAg
ICBnb3RvIGVycjsKCmlmIHNpemUgZnJvbSBxcnRyX2hkciBpcyAwLCB0aGUgcmVzdWx0IG9mIEFM
SUdOKHNpemUsIDQpCndpbGwgYmUgMCwgSW4gY2FzZSBvZiBsZW4gPT0gaGRybGVuIGFuZCBzaXpl
ID09IDAKaW4gaGVhZGVyIHRoaXMgY2hlY2sgd29uJ3QgZmFpbCBhbmQKCglpZiAoY2ItPnR5cGUg
PT0gUVJUUl9UWVBFX05FV19TRVJWRVIpIHsKICAgICAgICAgICAgICAgIC8qIFJlbW90ZSBub2Rl
IGVuZHBvaW50IGNhbiBicmlkZ2Ugb3RoZXIgZGlzdGFudCBub2RlcyAqLwogICAgICAgICAgICAg
ICAgY29uc3Qgc3RydWN0IHFydHJfY3RybF9wa3QgKnBrdCA9IGRhdGEgKyBoZHJsZW47CgogICAg
ICAgICAgICAgICAgcXJ0cl9ub2RlX2Fzc2lnbihub2RlLCBsZTMyX3RvX2NwdShwa3QtPnNlcnZl
ci5ub2RlKSk7CiAgICAgICAgfQoKd2lsbCBhbHNvIHJlYWQgb3V0IG9mIGJvdW5kIGZyb20gZGF0
YSwgd2hpY2ggaXMgaGRybGVuIGFsbG9jYXRlZCBibG9jay4KCkZpeGVzOiAxOTRjY2M4ODI5N2Eg
KCJuZXQ6IHFydHI6IFN1cHBvcnQgZGVjb2RpbmcgaW5jb21pbmcgdjIgcGFja2V0cyIpCkZpeGVz
OiBhZDlkMjRjOTQyOWUgKCJuZXQ6IHFydHI6IGZpeCBPT0IgUmVhZCBpbiBxcnRyX2VuZHBvaW50
X3Bvc3QiKQpTaWduZWQtb2ZmLWJ5OiBidXR0M3JmbHloNGNrIDxidXR0ZXJmbHloaHVhbmd4eEBn
bWFpbC5jb20+Ci0tLQogbmV0L3FydHIvcXJ0ci5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L3FydHIvcXJ0ci5j
IGIvbmV0L3FydHIvcXJ0ci5jCmluZGV4IDE3MWI3ZjNiZTZlZi4uMGMzMDkwODYyOGJhIDEwMDY0
NAotLS0gYS9uZXQvcXJ0ci9xcnRyLmMKKysrIGIvbmV0L3FydHIvcXJ0ci5jCkBAIC00OTMsNyAr
NDkzLDcgQEAgaW50IHFydHJfZW5kcG9pbnRfcG9zdChzdHJ1Y3QgcXJ0cl9lbmRwb2ludCAqZXAs
IGNvbnN0IHZvaWQgKmRhdGEsIHNpemVfdCBsZW4pCiAJCWdvdG8gZXJyOwogCX0KIAotCWlmIChs
ZW4gIT0gQUxJR04oc2l6ZSwgNCkgKyBoZHJsZW4pCisJaWYgKCFzaXplIHx8IGxlbiAhPSBBTElH
TihzaXplLCA0KSArIGhkcmxlbikKIAkJZ290byBlcnI7CiAKIAlpZiAoY2ItPmRzdF9wb3J0ICE9
IFFSVFJfUE9SVF9DVFJMICYmIGNiLT50eXBlICE9IFFSVFJfVFlQRV9EQVRBICYmCi0tIAoyLjI1
LjEKCg==
--000000000000907d8d05c9d07426--
