Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970D721E21
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfEQTVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 15:21:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37790 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEQTVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 15:21:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id 7so7756995wmo.2;
        Fri, 17 May 2019 12:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LrDbmdht42NHNTjhMaxI7/6/Ah2311xDAKcQ2ToODs=;
        b=LFbsId247qeWYOiJU+eivFNTE5hncHzgUl4azsXgMd2KW2oOj9MNIQfq1+rKsnfF88
         NdRkTqRRvSpxtY70lTSwyReR6B9gNWJW/Qq5iLkBRpNUvCBt97MC6ASLtC2BBv4631UK
         Co+uyTH9rxjfVeRGtcbvEvd2K/g1ZnI8C49eJjOSNLILDdvCjM3LmwzmA8mMGIAqRO7E
         1mdnpG2pkq+VFzjdP1oAy8SIz9YRIYpSYnXuqEgCZp+khba9P4o9MYgsp7YaCUq6iutk
         PMKrGNX3Ucq+niMdQ2tc2fNwiLXuuT47ymwEaUA7pXnz/6vxnm+P2bC1++P2lsyJluID
         Wg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LrDbmdht42NHNTjhMaxI7/6/Ah2311xDAKcQ2ToODs=;
        b=uKJaHZ0Usc+1CaR/ck6xQp1hodSXw6fuGsRl45sbKRHdZi7NK7kO3K2SiMRyNtGnMh
         NkQ+Le0NBycXd84jgxGwHXCxY3+yTcjEHGXNzLV/7WeN/hZO5V6NJULWxDat+FZO87tY
         LG3+bBfMghV86uegTo6Ofyu2763sC6NAnan6mwrXj0LXhlPF9Yh/py8ERnukbe1gOJ5G
         aLk9H+66/m2EOkohkUt8LRULACeF8O2lGnpPbdzyUL/sHBci9raDyylr99QHCBWB3m5v
         NNMwqP2hLlWXcpb1IUop0BU1YcaHATrk+ra105SRhQV70txujqd0lMP7Etu/iIg+6VSZ
         tlDQ==
X-Gm-Message-State: APjAAAXrPTQ9f6pafXgWvTl8wtoDH3uXwPNwbKWDr8+szlH91qC8ZUXP
        wq19m6Pgbwxlnq6Lc+lu1jQ=
X-Google-Smtp-Source: APXvYqw40gJFN+V8j4/nIi6KggbDf9c0koNIuOBrWhXH0hlqXnYtVuRbC/BrdSCUfvsIbI3uYGfQZw==
X-Received: by 2002:a1c:7ed2:: with SMTP id z201mr29436687wmc.113.1558120891918;
        Fri, 17 May 2019 12:21:31 -0700 (PDT)
Received: from debian64.daheim (p4FD09697.dip0.t-ipconnect.de. [79.208.150.151])
        by smtp.gmail.com with ESMTPSA id a4sm7088219wrr.39.2019.05.17.12.21.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 12:21:30 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hRiQ4-0001oJ-9k; Fri, 17 May 2019 21:21:28 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        kvalo@codeaurora.org, davem@davemloft.net, andreyknvl@google.com,
        syzkaller-bugs@googlegroups.com, chunkeey@googlemail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Michael Wu <flamingice@sourmilk.net>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
Date:   Fri, 17 May 2019 21:21:27 +0200
Message-ID: <5014675.0cgHOJIxtM@debian64>
In-Reply-To: <1557754110.2793.7.camel@suse.com>
References: <00000000000073512b0588c24d09@google.com> <1557754110.2793.7.camel@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, May 13, 2019 3:28:30 PM CEST Oliver Neukum wrote:
> On Mo, 2019-05-13 at 03:23 -0700, syzbot wrote:
> > syzbot has found a reproducer for the following crash on:
> > 
> > HEAD commit:    43151d6c usb-fuzzer: main usb gadget fuzzer driver
> > git tree:       https://github.com/google/kasan.git usb-fuzzer
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16b64110a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
> > dashboard link: https://syzkaller.appspot.com/bug?extid=200d4bb11b23d929335f
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1634c900a00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com
> > 
> > usb 1-1: config 0 descriptor??
> > usb 1-1: reset high-speed USB device number 2 using dummy_hcd
> > usb 1-1: device descriptor read/64, error -71
> > usb 1-1: Using ep0 maxpacket: 8
> > usb 1-1: Loading firmware file isl3887usb
> > usb 1-1: Direct firmware load for isl3887usb failed with error -2
> > usb 1-1: Firmware not found.
> > ==================================================================
> > BUG: KASAN: use-after-free in p54u_load_firmware_cb.cold+0x97/0x13a  
> > drivers/net/wireless/intersil/p54/p54usb.c:936
> > Read of size 8 at addr ffff88809803f588 by task kworker/1:0/17
> 
> Hi,
> 
> it looks to me as if refcounting is broken.
> You should have a usb_put_dev() in p54u_load_firmware_cb() or in
> p54u_disconnect(), but not both.

There's more to that refcounting that meets the eye. Do you see that
request_firmware_nowait() in the driver? That's the async firmware
request call that get's completed by the p54u_load_firmware_cb()
So what's happening here is that the driver has to be protected
against rmmod when the driver is waiting for request_firmware_nowait
to "finally" callback, which depending on the system can be up to 
60 seconds.

Now, what seems to be odd is that it's at line 936
> > BUG: KASAN: use-after-free in p54u_load_firmware_cb.cold+0x97/0x13a  
> > drivers/net/wireless/intersil/p54/p54usb.c:936

because if you put it in context:

|
|static void p54u_load_firmware_cb(const struct firmware *firmware,
|				  void *context)
|{
|	struct p54u_priv *priv = context;
|	struct usb_device *udev = priv->udev;
|	int err;
|
|	complete(&priv->fw_wait_load);
|	if (firmware) {
|		priv->fw = firmware;
|		err = p54u_start_ops(priv);
|	} else {
|		err = -ENOENT;
|		dev_err(&udev->dev, "Firmware not found.\n");
|	}
|
|	if (err) {
|>>	>>	struct device *parent = priv->udev->dev.parent; <<<<-- 936 is here
|
|		dev_err(&udev->dev, "failed to initialize device (%d)\n", err);
|
|		if (parent)
|			device_lock(parent);
|
|		device_release_driver(&udev->dev);
|		/*
|		 * At this point p54u_disconnect has already freed
|		 * the "priv" context. Do not use it anymore!
|		 */
|		priv = NULL;
|
|		if (parent)
|			device_unlock(parent);
|	}
|
|	usb_put_dev(udev);
|}

it seems very out of place, because at that line the device is still bound to
the driver! Only with device_release_driver in line 942, I could see that
something woulb be aray... !BUT! that's why we do have the extra
usb_get_dev(udev) in p54u_load_firmware() so we can do the usb_put_dev(udev) in
line 953 to ensure that nothing (like the rmmod I talked above) will interfere
until everything is done.

I've no idea what's wrong here, is gcc 9.0 aggressivly reording the put? Or is
something else going on with the sanitizers? Because this report does look
dogdy there!

(Note: p54usb has !strategic! dev_err/infos in place right around the
usb_get_dev/usb_put_dev so we can sort of tell the refvalue of the udev
and it all seems to be correct from what I can gleam) 

Regards,
Christian


