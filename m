Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248F32FF4AA
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbhAUSuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbhAUIsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:48:46 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C667CC061575;
        Thu, 21 Jan 2021 00:48:04 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id r32so1321640ybd.5;
        Thu, 21 Jan 2021 00:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=DAKzWfI+WV1BtESP96vgOG0X+j7cbNfQKOeLD/qtt8U=;
        b=lC6IYS6CEA7T4L4rYYL//fUkY+d5BaIrd211d0i1qE+tLBumvZQUotP+9mIkSLAsnw
         8VSxPArB0v9HuV1mg/TpSkI07D1D/1mYYSiiVMX7JmvyIXXT6jwJt+ClBhIfgdJOZ2xi
         VQv2ceD0d1n5OoGDEURtBVW1mkhAYuY/IZR3bUsR9vIM5B+8eLnTCozsQQ8gqF3abEgK
         TGjzlpYjsXTTts8WZ/ntb/eegvKs4m7EjkD/ugOSdlv3hj74+2salZmDB0ai+LA/Y3S1
         FR8LBxhqZU1M6buyjafevU99ogljIev/r/+02i6E/4pV8IqndQ91NPKvpJKvLavFGLFf
         CsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=DAKzWfI+WV1BtESP96vgOG0X+j7cbNfQKOeLD/qtt8U=;
        b=RV3pfCRTIZFgeQDEbWUQEXwicA9RcVB3kESsl4HfNuHMnTQThLBicpisYUckHQMQ8z
         wmV76k+VR5DZ/fWjuE0KYhn4uNTJsrDoIWYf2TbHDI01AOzXNpkvRuuy4iw14+MlJgK8
         J9S9DlZ/kaCUQbyQ5a42+qnaXKSDk7cta0Cx3ClLbtLBHREvlhogESTBlKSx8gaX9rx3
         iMsTfRTjxiZ1OXwDUSJ/E1OBk/3+jop0wsSrGPZ8fLoUH9A4ZcYkt1R54tOvUOISLH5o
         rJSdLQVLTd034+NI4Yl+nNxh+IIsLDwU+kSU1gZlmxeuUkDFDSqzvl51JLZzk7XUzHb+
         vZ2Q==
X-Gm-Message-State: AOAM533F7sFjaHjc/yFGIl8NmeiZZJpsr9oZ9s/mVzQq3hwR2eJrQoH9
        iWZAlGaFIBOpAJsnTOez29zZQWPZ0uXhJszEDDQ=
X-Google-Smtp-Source: ABdhPJwVmB+bKPx06kt5BW+qCLKDzoIkZ7EZSXZVsxhLo71ZQjSmY1j3ZeSYR5zLwT5Jvz3rbpyiDJ2tG6FFdoRxa9k=
X-Received: by 2002:a25:3457:: with SMTP id b84mr18603418yba.167.1611218883982;
 Thu, 21 Jan 2021 00:48:03 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Thu, 21 Jan 2021 16:47:37 +0800
Message-ID: <CAD-N9QX=vVdiSf5UkuoYovamfw5a0e5RQJA0dQMOKmCbs-Gyiw@mail.gmail.com>
Subject: "KMSAN: uninit-value in rt2500usb_bbp_read" and "KMSAN: uninit-value
 in rt2500usb_probe_hw" should be duplicate crash reports
To:     davem@davemloft.net, helmut.schaa@googlemail.com, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stf_xl@wp.pl, Greg KH <greg@kroah.com>
Cc:     syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear kernel developers,

I found that on the syzbot dashboard, =E2=80=9CKMSAN: uninit-value in
rt2500usb_bbp_read=E2=80=9D [1] and "KMSAN: uninit-value in
rt2500usb_probe_hw" [2] should share the same root cause.

## Duplication

The reasons for the above statement:
1) The PoCs are exactly the same with each other;
2) The stack trace is almost the same except for the top 2 functions;

## Root Cause Analysis

After looking at the difference between the two stack traces, we found
they diverge at the function - rt2500usb_probe_hw.
---------------------------------------------------------------------------=
---------------------------------------------
static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
{
        ......
        // rt2500usb_validate_eeprom->rt2500usb_bbp_read->rt2500usb_regbusy=
_read->rt2500usb_register_read_lock
from KMSAN
        retval =3D rt2500usb_validate_eeprom(rt2x00dev);
        if (retval)
                return retval;
        // rt2500usb_init_eeprom-> rt2500usb_register_read from KMSAN
        retval =3D rt2500usb_init_eeprom(rt2x00dev);
        if (retval)
                return retval;
---------------------------------------------------------------------------=
---------------------------------------------
From the implementation of rt2500usb_register_read and
rt2500usb_register_read_lock, we know that, in some situation, reg is
not initialized in the function invocation
(rt2x00usb_vendor_request_buff/rt2x00usb_vendor_req_buff_lock), and
KMSAN reports uninit-value at its first memory access.
---------------------------------------------------------------------------=
---------------------------------------------
static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
                                   const unsigned int offset)
{
        __le16 reg;
        // reg is not initialized during the following function all
        rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
                                      USB_VENDOR_REQUEST_IN, offset,
                                      &reg, sizeof(reg));
        return le16_to_cpu(reg);
}
static u16 rt2500usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
                                        const unsigned int offset)
{
        __le16 reg;
        // reg is not initialized during the following function all
        rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
                                       USB_VENDOR_REQUEST_IN, offset,
                                       &reg, sizeof(reg), REGISTER_TIMEOUT)=
;
        return le16_to_cpu(reg);
}
---------------------------------------------------------------------------=
---------------------------------------------
Take rt2x00usb_vendor_req_buff_lock as an example, let me illustrate
the issue when the "reg" variable is uninitialized. No matter the CSR
cache is unavailable or the status is not right, the buffer or reg
will be not initialized.
And all those issues are probabilistic events. If they occur in
rt2500usb_register_read, KMSAN reports "uninit-value in
rt2500usb_probe_hw"; Otherwise, it reports "uninit-value in
rt2500usb_bbp_read".
---------------------------------------------------------------------------=
---------------------------------------------
int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
                                   const u8 request, const u8 requesttype,
                                   const u16 offset, void *buffer,
                                   const u16 buffer_length, const int timeo=
ut)
{
        if (unlikely(!rt2x00dev->csr.cache || buffer_length > CSR_CACHE_SIZ=
E)) {
                rt2x00_err(rt2x00dev, "CSR cache not available\n");
                return -ENOMEM;
        }

        if (requesttype =3D=3D USB_VENDOR_REQUEST_OUT)
                memcpy(rt2x00dev->csr.cache, buffer, buffer_length);

        status =3D rt2x00usb_vendor_request(rt2x00dev, request, requesttype=
,
                                          offset, 0, rt2x00dev->csr.cache,
                                          buffer_length, timeout);

        if (!status && requesttype =3D=3D USB_VENDOR_REQUEST_IN)
                memcpy(buffer, rt2x00dev->csr.cache, buffer_length);

        return status;
}
---------------------------------------------------------------------------=
---------------------------------------------

## Patch

I propose to memset reg variable before invoking
rt2x00usb_vendor_req_buff_lock/rt2x00usb_vendor_request_buff.

---------------------------------------------------------------------------=
---------------------------------------------
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index fce05fc88aaf..f6c93a25b18c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -48,6 +48,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev
*rt2x00dev,
                                   const unsigned int offset)
 {
        __le16 reg;
+       memset(&reg, 0, sizeof(reg));
        rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
                                      USB_VENDOR_REQUEST_IN, offset,
                                      &reg, sizeof(reg));
@@ -58,6 +59,7 @@ static u16 rt2500usb_register_read_lock(struct
rt2x00_dev *rt2x00dev,
                                        const unsigned int offset)
 {
        __le16 reg;
+       memset(&reg, 0, sizeof(reg));
        rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
                                       USB_VENDOR_REQUEST_IN, offset,
                                       &reg, sizeof(reg), REGISTER_TIMEOUT)=
;
---------------------------------------------------------------------------=
---------------------------------------------

If you can have any issues with this statement or our information is
useful to you, please let us know. Thanks very much.

[1] =E2=80=9CKMSAN: uninit-value in rt2500usb_bbp_read=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3Df35d123de7d393019c1ed4d4e60dc66596ed=
62cd
[2] =E2=80=9CKMSAN: uninit-value in rt2500usb_probe_hw=E2=80=9D -
https://syzkaller.appspot.com/bug?id=3D5402df7259c74e15a12992e739b5ac54c9b8=
a4ce


--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
