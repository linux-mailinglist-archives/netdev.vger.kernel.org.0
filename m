Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502C922CE5D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 21:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgGXTHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 15:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXTHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 15:07:36 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31E3C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 12:07:35 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id s189so3608578iod.2
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 12:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ivwisNvqmh/RqMsemp5nX3DJVrh+sMLojdMTLOijAa4=;
        b=OSJQ4ciIgYcZXBPbtzhWRszyDoaQ6EsU9yIyHO8C/grRDTawuS+60jcVeApqYp0YhC
         M7KTkT6qJQzxEqIeQM8Ot5GkPO8gmNMk1A8hnCDcHXizjhAF8L37WagMaRraOH7VIZek
         Pcb3YzzNUjtvn7+ItYNoEx+u22AKMeI1F4vvKe0MTeYG8hUPWt+SEd0/295zCgtXN+dF
         8P4drWR3QF/Stds6FkNANQnyz2R8hbs7E7X8+blWnvNKMVDUK8uNdMQOLsyC7xJ6kGdE
         vOdADrPlB4fce4J4VJaHsj207QJgtU6FpDjAauuIdCEpo7QPFHo+S9LIoucxQDPi4A3X
         IdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ivwisNvqmh/RqMsemp5nX3DJVrh+sMLojdMTLOijAa4=;
        b=qC6eRvKAT9LxAPcvlROzrDMvmul/Xi4tlgWWl7WRgJHrIuO+qORd/8nhwxWuf4ettT
         jQ/Gsg9JHGqJaMOXxxOZV2fyfRrHAawa5dptAsDWdvZz2r8FdeeIfWuQ6XeIUN4aC71n
         DKnIk3p37MdTfsTUbPi7oHUSH9HCEeaj349V2MGqwTeShI9t/CKb9/W6ptnml/cB5QW4
         va9ax/nOglx+VY6CYszEw85mTrEjj+sz+bSCjFxPw1+kf/3Tr+USgK2PLzAVPck3v4ni
         jC00UeFZTQMt2lNDWsW/bArJSQxzwh512QIprQcO9EvsUhi4m9M+b+0IAWHLX7LYgybz
         dIuw==
X-Gm-Message-State: AOAM53175dtMJ40ooomWZ8r09AiG5FJ/IKVuBQrypfCGqskj81HCLWxu
        2I8tVh9hYu4+Gi4DvZctrGPtFvhmYJSjUpdN6rI=
X-Google-Smtp-Source: ABdhPJwz6robWWuFJ9VQicTd0cqQnLNA4AnqgTT2gf50dtjGvxf9XjZtApUYl8AMAljdbaUxAtLumbuFhAhxFy8sRU4=
X-Received: by 2002:a02:1d04:: with SMTP id 4mr12556069jaj.16.1595617655177;
 Fri, 24 Jul 2020 12:07:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ5WPnEYfJgnU2D7nA9oSX5ZqxP0hDkpBnO2D8p6YtjupRbqTw@mail.gmail.com>
In-Reply-To: <CAJ5WPnEYfJgnU2D7nA9oSX5ZqxP0hDkpBnO2D8p6YtjupRbqTw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 24 Jul 2020 12:07:23 -0700
Message-ID: <CAM_iQpWZ84uT3R4NJOcc4B9qtTda-X9ZD5F3pURdib1bUk-uKQ@mail.gmail.com>
Subject: Re: memory leak in ipv6_sock_ac_join ( 5.8.0-rc6+)
To:     "\\xcH3332\\" <ch3332xr@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: multipart/mixed; boundary="00000000000088fbf105ab34af95"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000088fbf105ab34af95
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 23, 2020 at 5:06 PM \xcH3332\ <ch3332xr@gmail.com> wrote:
>
> Hi,
>
> SYZKALLER found the following Memory Leak

Thanks for your report!

Can you test the attached patch? I only did compile test as I don't
have an environment to run syz programs.

--00000000000088fbf105ab34af95
Content-Type: text/x-patch; charset="US-ASCII"; name="ipv6-anycast.diff"
Content-Disposition: attachment; filename="ipv6-anycast.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kd0lj37v0>
X-Attachment-Id: f_kd0lj37v0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2FkZHJjb25mLmggYi9pbmNsdWRlL25ldC9hZGRyY29u
Zi5oCmluZGV4IGZkYjA3MTA1Mzg0Yy4uODQxOGI3ZDM4NDY4IDEwMDY0NAotLS0gYS9pbmNsdWRl
L25ldC9hZGRyY29uZi5oCisrKyBiL2luY2x1ZGUvbmV0L2FkZHJjb25mLmgKQEAgLTI3NCw2ICsy
NzQsNyBAQCBpbnQgaXB2Nl9zb2NrX2FjX2pvaW4oc3RydWN0IHNvY2sgKnNrLCBpbnQgaWZpbmRl
eCwKIAkJICAgICAgY29uc3Qgc3RydWN0IGluNl9hZGRyICphZGRyKTsKIGludCBpcHY2X3NvY2tf
YWNfZHJvcChzdHJ1Y3Qgc29jayAqc2ssIGludCBpZmluZGV4LAogCQkgICAgICBjb25zdCBzdHJ1
Y3QgaW42X2FkZHIgKmFkZHIpOwordm9pZCBfX2lwdjZfc29ja19hY19jbG9zZShzdHJ1Y3Qgc29j
ayAqc2spOwogdm9pZCBpcHY2X3NvY2tfYWNfY2xvc2Uoc3RydWN0IHNvY2sgKnNrKTsKIAogaW50
IF9faXB2Nl9kZXZfYWNfaW5jKHN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYsIGNvbnN0IHN0cnVjdCBp
bjZfYWRkciAqYWRkcik7CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9hbnljYXN0LmMgYi9uZXQvaXB2
Ni9hbnljYXN0LmMKaW5kZXggODkzMjYxMjMwZmZjLi5kYWNkZWE3ZmNiNjIgMTAwNjQ0Ci0tLSBh
L25ldC9pcHY2L2FueWNhc3QuYworKysgYi9uZXQvaXB2Ni9hbnljYXN0LmMKQEAgLTE4Myw3ICsx
ODMsNyBAQCBpbnQgaXB2Nl9zb2NrX2FjX2Ryb3Aoc3RydWN0IHNvY2sgKnNrLCBpbnQgaWZpbmRl
eCwgY29uc3Qgc3RydWN0IGluNl9hZGRyICphZGRyKQogCXJldHVybiAwOwogfQogCi12b2lkIGlw
djZfc29ja19hY19jbG9zZShzdHJ1Y3Qgc29jayAqc2spCit2b2lkIF9faXB2Nl9zb2NrX2FjX2Ns
b3NlKHN0cnVjdCBzb2NrICpzaykKIHsKIAlzdHJ1Y3QgaXB2Nl9waW5mbyAqbnAgPSBpbmV0Nl9z
ayhzayk7CiAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IE5VTEw7CkBAIC0xOTEsMTAgKzE5MSw3
IEBAIHZvaWQgaXB2Nl9zb2NrX2FjX2Nsb3NlKHN0cnVjdCBzb2NrICpzaykKIAlzdHJ1Y3QgbmV0
ICpuZXQgPSBzb2NrX25ldChzayk7CiAJaW50CXByZXZfaW5kZXg7CiAKLQlpZiAoIW5wLT5pcHY2
X2FjX2xpc3QpCi0JCXJldHVybjsKLQotCXJ0bmxfbG9jaygpOworCUFTU0VSVF9SVE5MKCk7CiAJ
cGFjID0gbnAtPmlwdjZfYWNfbGlzdDsKIAlucC0+aXB2Nl9hY19saXN0ID0gTlVMTDsKIApAQCAt
MjExLDYgKzIwOCwxNiBAQCB2b2lkIGlwdjZfc29ja19hY19jbG9zZShzdHJ1Y3Qgc29jayAqc2sp
CiAJCXNvY2tfa2ZyZWVfcyhzaywgcGFjLCBzaXplb2YoKnBhYykpOwogCQlwYWMgPSBuZXh0Owog
CX0KK30KKwordm9pZCBpcHY2X3NvY2tfYWNfY2xvc2Uoc3RydWN0IHNvY2sgKnNrKQoreworCXN0
cnVjdCBpcHY2X3BpbmZvICpucCA9IGluZXQ2X3NrKHNrKTsKKworCWlmICghbnAtPmlwdjZfYWNf
bGlzdCkKKwkJcmV0dXJuOworCXJ0bmxfbG9jaygpOworCV9faXB2Nl9zb2NrX2FjX2Nsb3NlKHNr
KTsKIAlydG5sX3VubG9jaygpOwogfQogCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9pcHY2X3NvY2tn
bHVlLmMgYi9uZXQvaXB2Ni9pcHY2X3NvY2tnbHVlLmMKaW5kZXggMjA1NzZlODdhNWY3Li43NmY5
ZTQxODU5YTIgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L2lwdjZfc29ja2dsdWUuYworKysgYi9uZXQv
aXB2Ni9pcHY2X3NvY2tnbHVlLmMKQEAgLTI0MCw2ICsyNDAsNyBAQCBzdGF0aWMgaW50IGRvX2lw
djZfc2V0c29ja29wdChzdHJ1Y3Qgc29jayAqc2ssIGludCBsZXZlbCwgaW50IG9wdG5hbWUsCiAK
IAkJCWZsNl9mcmVlX3NvY2tsaXN0KHNrKTsKIAkJCV9faXB2Nl9zb2NrX21jX2Nsb3NlKHNrKTsK
KwkJCV9faXB2Nl9zb2NrX2FjX2Nsb3NlKHNrKTsKIAogCQkJLyoKIAkJCSAqIFNvY2sgaXMgbW92
aW5nIGZyb20gSVB2NiB0byBJUHY0IChza19wcm90KSwgc28K
--00000000000088fbf105ab34af95--
