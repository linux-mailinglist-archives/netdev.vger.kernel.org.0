Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A055169717
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388087AbfGOPIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 11:08:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34044 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733203AbfGOPIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 11:08:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so7559529pfo.1;
        Mon, 15 Jul 2019 08:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HvGFiXKIMoJHRgRPv+CNGx82/V4N9NKuA2a2k2xvyEI=;
        b=SNM/YzFIofldJvXGWAsN2gKzBBedbJuHXOK2bg8FuKyDmVMINV9tWuGaOU6IWVavL2
         1UVVsFWjaS+FxTXEI/r2C81HaGqZApODK2QkrBTs2GFeADPqMO6XVJ390ilEF9fX9OwR
         g0x6GT4nvvt5AQiiaFvEBDFSYIPQi2VWOVILJ6Irpc1NnuADpqMyO3tnYBIDwd4FIYon
         WCE9046IBxjH3Uj+vy3olu6Zn66GP6E7Q26p1i7shDmBhnh9MoVoCcoXZgTVhqdgwcG5
         fjqviZbtLeGPaQ/XbWVLvnQKR2S3qdg+Z2/X87fhnwaua/2+6k2ATsW09NjIV7guMQxh
         GtGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HvGFiXKIMoJHRgRPv+CNGx82/V4N9NKuA2a2k2xvyEI=;
        b=FDemJw+be0Kg65wU67pPs0ql0DbU44QqbGwJA+Zd5dMgMsSdvLMfEM2dCU8gmjo6dj
         Y7oFyb4jxdNIyRZZJZLqFbdNtJWpmr29zBptDxwQ6dyb+xEegUOSYUkLMc1jSU3I8HVx
         91LAg0+fJwI8ML5L8j/D2xxrzLKccfklqLIh/1HhrzNKA7+PiafJ1jP+AxvI+pD+Ad6c
         0yby2OCKiGWNpxclOmGMh51EXzl1mV40x4tIZChnXljUTtCzQZusDggO6otOERIosASj
         w/jfA73k1ae0CpKWKk7WznONN0TrRy3Q4+xZ8uO5npqZhp9TyErNaVcC8HILtnDL8d7E
         Va0w==
X-Gm-Message-State: APjAAAVwvc/LFbSbeH4gijGEeMah6EB0tnzP8Pb19fyJ1jXd9dg46w3E
        wx9PFEaQMVs+YeUlYE9SN/c=
X-Google-Smtp-Source: APXvYqwhh1jY/TQpZyLTr7OKyrCoZOc6rJCUkSPPoEOkGW73rwzgzUaZc6OeiL+iMEX9bVsQi8AIeA==
X-Received: by 2002:a63:10a:: with SMTP id 10mr27855904pgb.281.1563203310244;
        Mon, 15 Jul 2019 08:08:30 -0700 (PDT)
Received: from debian.net.fpt ([2405:4800:58c7:392e:98e4:a492:ad40:d86e])
        by smtp.gmail.com with ESMTPSA id b37sm33284969pjc.15.2019.07.15.08.08.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 08:08:29 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     syzbot+8750abbc3a46ef47d509@syzkaller.appspotmail.com
Cc:     isdn@linux-pingi.de, davem@davemloft.net,
        gregkh@linuxfoundation.org, andreyknvl@google.com,
        bigeasy@linutronix.de, gustavo@embeddedor.com, pakki001@umn.edu,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH] ISDN: hfcsusb: checking idx of ep configuration
Date:   Mon, 15 Jul 2019 22:08:14 +0700
Message-Id: <20190715150814.20022-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <000000000000f2b23d05868310f9@google.com>
References: <000000000000f2b23d05868310f9@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The syzbot test with random endpoint address which made the idx is
overflow in the table of endpoint configuations.

this adds the checking for fixing the error report from
syzbot

KASAN: stack-out-of-bounds Read in hfcsusb_probe [1]
The patch tested by syzbot [2]

Reported-by: syzbot+8750abbc3a46ef47d509@syzkaller.appspotmail.com

[1]:
https://syzkaller.appspot.com/bug?id=30a04378dac680c5d521304a00a86156bb913522
[2]:
https://groups.google.com/d/msg/syzkaller-bugs/_6HBdge8F3E/OJn7wVNpBAAJ

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 4c99739b937e..0e224232f746 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1955,6 +1955,9 @@ hfcsusb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 				/* get endpoint base */
 				idx = ((ep_addr & 0x7f) - 1) * 2;
+				if (idx > 15)
+					return -EIO;
+
 				if (ep_addr & 0x80)
 					idx++;
 				attr = ep->desc.bmAttributes;
-- 
2.11.0

