Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CAB2FE64D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbhAUJZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbhAUJZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:25:13 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884D0C061575;
        Thu, 21 Jan 2021 01:24:32 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id x6so1429561ybr.1;
        Thu, 21 Jan 2021 01:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5aDb7W14bl7wAiVr1ce4T8OE9GGC14LW/8PhwVGuMuo=;
        b=sqKk91vWV5eIzVZDdvj1w4rChHj9SY0E6kNEE/dxlPMaoLnteGK9eKilpkr8dcPo6L
         4OYh7PQ5azIF7r1zV8NzFd3Tb+zl3SwaLcEbWpSN2v/v7ctMMwQ7mCqvaoF+YfP6KXA3
         5c9Se6/By+ZZzo5+QjtBPovS6/53AZT/oH/wsvEuksTuwExnvMXhVpdkikLHhLyJV1aY
         O+cdkjmBM1r5SJzJh1ZhJ58LiOdqNiTlROyjdj0C35aiEJNBXBZdUzKgt+Z5FLuuMNPT
         43qMZceBPhPhDu8cPddanrcAXZJ+1bkXRJL25oVdq3D/yAwapvIPCfWf0rnTIWjkarmr
         ua4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5aDb7W14bl7wAiVr1ce4T8OE9GGC14LW/8PhwVGuMuo=;
        b=QoYIfryOU168iRu+pYQY8OwJBt4ALKPm0B6QerKrRXhtS4bppR0eqTqlRRbeoZK+9r
         555Uj7jwWT7e33aem3QmgZlfzrz9zHS6IY0Zso2/hE6xd2FzEWu2etqaI5r5gFsepM1x
         m3ZHooNQkSrxIXyQy2y/+Sekn0pBViOCtABjOG+ujnNrSSh5kdaU/mgjG/rNXTV0ySY+
         jVeC3bjNND5lt2pbnenKFtehJrzqHz9hvjFlxaLpdLeOTWNO2XDaRMdO5pgH2WCNAwdE
         zb+/P0agJT0hf5RPtyj9Mgg77hKLQ65shpKjCtK33wkKDB+p78giMDIPsCGjH9er5hVk
         6IZQ==
X-Gm-Message-State: AOAM530hWjJVT34m+4XKAgHLfrWQHChgYPnshD0VQodv3rlzAOBzIzvu
        HK8G3nnorgVXK4CIYQvqA/TFVFXTWSO4FYTGoYA=
X-Google-Smtp-Source: ABdhPJwvcdy/GKpSDqsgWL3Qqn/BdSA6UirMTMIeWJxIURXlUYi+n0pDoqgl+88UQi4WfjkNUy85xaJJMvwoqBPNrq8=
X-Received: by 2002:a25:8c5:: with SMTP id 188mr7663135ybi.18.1611221071750;
 Thu, 21 Jan 2021 01:24:31 -0800 (PST)
MIME-Version: 1.0
References: <CAD-N9QX=vVdiSf5UkuoYovamfw5a0e5RQJA0dQMOKmCbs-Gyiw@mail.gmail.com>
 <YAlAy/tQXW0X310V@kroah.com>
In-Reply-To: <YAlAy/tQXW0X310V@kroah.com>
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Thu, 21 Jan 2021 17:24:05 +0800
Message-ID: <CAD-N9QVz23ihqfCAY1VocPDhXO97oXoranP9M9Lw9Dqr9feSMQ@mail.gmail.com>
Subject: Re: "KMSAN: uninit-value in rt2500usb_bbp_read" and "KMSAN:
 uninit-value in rt2500usb_probe_hw" should be duplicate crash reports
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, helmut.schaa@googlemail.com, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stf_xl@wp.pl, syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 4:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jan 21, 2021 at 04:47:37PM +0800, =E6=85=95=E5=86=AC=E4=BA=AE wro=
te:
> > Dear kernel developers,
> >
> > I found that on the syzbot dashboard, =E2=80=9CKMSAN: uninit-value in
> > rt2500usb_bbp_read=E2=80=9D [1] and "KMSAN: uninit-value in
> > rt2500usb_probe_hw" [2] should share the same root cause.
> >
> > ## Duplication
> >
> > The reasons for the above statement:
> > 1) The PoCs are exactly the same with each other;
> > 2) The stack trace is almost the same except for the top 2 functions;
> >
> > ## Root Cause Analysis
> >
> > After looking at the difference between the two stack traces, we found
> > they diverge at the function - rt2500usb_probe_hw.
> > -----------------------------------------------------------------------=
-------------------------------------------------
> > static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
> > {
> >         ......
> >         // rt2500usb_validate_eeprom->rt2500usb_bbp_read->rt2500usb_reg=
busy_read->rt2500usb_register_read_lock
> > from KMSAN
> >         retval =3D rt2500usb_validate_eeprom(rt2x00dev);
> >         if (retval)
> >                 return retval;
> >         // rt2500usb_init_eeprom-> rt2500usb_register_read from KMSAN
> >         retval =3D rt2500usb_init_eeprom(rt2x00dev);
> >         if (retval)
> >                 return retval;
> > -----------------------------------------------------------------------=
-------------------------------------------------
> > >From the implementation of rt2500usb_register_read and
> > rt2500usb_register_read_lock, we know that, in some situation, reg is
> > not initialized in the function invocation
> > (rt2x00usb_vendor_request_buff/rt2x00usb_vendor_req_buff_lock), and
> > KMSAN reports uninit-value at its first memory access.
> > -----------------------------------------------------------------------=
-------------------------------------------------
> > static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
> >                                    const unsigned int offset)
> > {
> >         __le16 reg;
> >         // reg is not initialized during the following function all
> >         rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
> >                                       USB_VENDOR_REQUEST_IN, offset,
> >                                       &reg, sizeof(reg));
> >         return le16_to_cpu(reg);
> > }
> > static u16 rt2500usb_register_read_lock(struct rt2x00_dev *rt2x00dev,
> >                                         const unsigned int offset)
> > {
> >         __le16 reg;
> >         // reg is not initialized during the following function all
> >         rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
> >                                        USB_VENDOR_REQUEST_IN, offset,
> >                                        &reg, sizeof(reg), REGISTER_TIME=
OUT);
> >         return le16_to_cpu(reg);
> > }
> > -----------------------------------------------------------------------=
-------------------------------------------------
> > Take rt2x00usb_vendor_req_buff_lock as an example, let me illustrate
> > the issue when the "reg" variable is uninitialized. No matter the CSR
> > cache is unavailable or the status is not right, the buffer or reg
> > will be not initialized.
> > And all those issues are probabilistic events. If they occur in
> > rt2500usb_register_read, KMSAN reports "uninit-value in
> > rt2500usb_probe_hw"; Otherwise, it reports "uninit-value in
> > rt2500usb_bbp_read".
> > -----------------------------------------------------------------------=
-------------------------------------------------
> > int rt2x00usb_vendor_req_buff_lock(struct rt2x00_dev *rt2x00dev,
> >                                    const u8 request, const u8 requestty=
pe,
> >                                    const u16 offset, void *buffer,
> >                                    const u16 buffer_length, const int t=
imeout)
> > {
> >         if (unlikely(!rt2x00dev->csr.cache || buffer_length > CSR_CACHE=
_SIZE)) {
> >                 rt2x00_err(rt2x00dev, "CSR cache not available\n");
> >                 return -ENOMEM;
> >         }
> >
> >         if (requesttype =3D=3D USB_VENDOR_REQUEST_OUT)
> >                 memcpy(rt2x00dev->csr.cache, buffer, buffer_length);
> >
> >         status =3D rt2x00usb_vendor_request(rt2x00dev, request, request=
type,
> >                                           offset, 0, rt2x00dev->csr.cac=
he,
> >                                           buffer_length, timeout);
> >
> >         if (!status && requesttype =3D=3D USB_VENDOR_REQUEST_IN)
> >                 memcpy(buffer, rt2x00dev->csr.cache, buffer_length);
> >
> >         return status;
> > }
> > -----------------------------------------------------------------------=
-------------------------------------------------
> >
> > ## Patch
> >
> > I propose to memset reg variable before invoking
> > rt2x00usb_vendor_req_buff_lock/rt2x00usb_vendor_request_buff.
> >
> > -----------------------------------------------------------------------=
-------------------------------------------------
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > index fce05fc88aaf..f6c93a25b18c 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > @@ -48,6 +48,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev
> > *rt2x00dev,
> >                                    const unsigned int offset)
> >  {
> >         __le16 reg;
> > +       memset(&reg, 0, sizeof(reg));
> >         rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_READ,
> >                                       USB_VENDOR_REQUEST_IN, offset,
> >                                       &reg, sizeof(reg));
> > @@ -58,6 +59,7 @@ static u16 rt2500usb_register_read_lock(struct
> > rt2x00_dev *rt2x00dev,
> >                                         const unsigned int offset)
> >  {
> >         __le16 reg;
> > +       memset(&reg, 0, sizeof(reg));
> >         rt2x00usb_vendor_req_buff_lock(rt2x00dev, USB_MULTI_READ,
> >                                        USB_VENDOR_REQUEST_IN, offset,
> >                                        &reg, sizeof(reg), REGISTER_TIME=
OUT);
> > -----------------------------------------------------------------------=
-------------------------------------------------
> >
> > If you can have any issues with this statement or our information is
> > useful to you, please let us know. Thanks very much.
> >
> > [1] =E2=80=9CKMSAN: uninit-value in rt2500usb_bbp_read=E2=80=9D -
> > https://syzkaller.appspot.com/bug?id=3Df35d123de7d393019c1ed4d4e60dc665=
96ed62cd
> > [2] =E2=80=9CKMSAN: uninit-value in rt2500usb_probe_hw=E2=80=9D -
> > https://syzkaller.appspot.com/bug?id=3D5402df7259c74e15a12992e739b5ac54=
c9b8a4ce
> >
>
> Can you please resend this in a form in which we can apply it?  Full
> details on how to do this can be found in
> Documentation/SubmittingPatches.

I have sent a patch to the corresponding maintainers. We can take it
as a base to discuss the corresponding bug.

>
> thanks,
>
> greg k-h
