Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C79C2A04B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404268AbfEXVTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:19:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38616 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404156AbfEXVTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:19:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so11279101wrs.5;
        Fri, 24 May 2019 14:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yChQCKBoYYD2ErUvmu70aLCopRrNaS4kVehdN9MryeQ=;
        b=bIwZkMsdQN9g2Ro0RJ63xyAWzairS1dzzOm1h2L9NxZY2KkYF+EFGj09BdsAMwwtDf
         l5KwJ5DyqQYuHwhHa0frqv72NnVBVe2dLgzigtaXCiYOqwIUD6LS6i5DAxLg5PLbSg4c
         9G8WEO8D7Y9qnXZJPvTIQ4gNqQsip6pAZkgldWKNo/7zZa4r0/aJ0o/3YdLnxh17D5PQ
         5VV/jdd9Ior9AV8zJWOFjjjgP8JhSxWXyt6t7UlrLauxJYISHNBFMyjGz9/UpDnZaiH8
         TKpuN+19/X4yNx0OEAdvWVfFAP4EHcf3r9PUSYK8Ein3MJItuIC9V3gW6n/VD8Lod7do
         2f0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yChQCKBoYYD2ErUvmu70aLCopRrNaS4kVehdN9MryeQ=;
        b=bmT4iTpCVzMIrIDuetrWF2Ahs3pIuIcyGBc2IG2+PQTKAHXLNejBXkm41+Q/vDdB78
         0NjgpEbTq9nQoBkUxSNNAwtzkcfJp5pvdHw3JNiDiaDMGogEXawB7v+up5ZVlAHCqNq1
         hVaqgK8cNODdhp/TqQ3nEIQ/oajeb+ifkL6tnHrI6FtD6pommPGlUlpcTuFI0ou01vqh
         sGUrBautXnT0ApvtEPdVog+X/YPT0IRASb2n6PCIoGKddRwUBa/vlDJZi1n4rg8V5iIu
         Iv2hnQp9ZU257FVkkH/Si/IOJPnkRrcoa1B2F2+asnA+zXDWnpx3nedC4vsplwMcloRx
         EW9g==
X-Gm-Message-State: APjAAAXMeHB9cUgBOUzkhvVnNUgZTg1B1wX5O5yYnDaqzDcFOWRufIZG
        Hv7O4A6WLSG2V815KQcsnVI=
X-Google-Smtp-Source: APXvYqymnTU9ieQWRBBGLnerP5t7LVtxI7Wi+PRWnM4/SAAy+wX1lwd0AilN1LYRoh2WAMD/VXnU2Q==
X-Received: by 2002:adf:f6ce:: with SMTP id y14mr10053787wrp.113.1558732776216;
        Fri, 24 May 2019 14:19:36 -0700 (PDT)
Received: from debian64.daheim (p4FD09F8E.dip0.t-ipconnect.de. [79.208.159.142])
        by smtp.gmail.com with ESMTPSA id c14sm4077515wrt.45.2019.05.24.14.19.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 14:19:35 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hUHbB-0004OC-Bk; Fri, 24 May 2019 23:19:34 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        kvalo@codeaurora.org, davem@davemloft.net, andreyknvl@google.com,
        syzkaller-bugs@googlegroups.com,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] network: wireless: p54u: Fix race between disconnect and firmware loading
Date:   Fri, 24 May 2019 23:19:29 +0200
Message-ID: <389698389.GL6GhM8fq4@debian64>
In-Reply-To: <Pine.LNX.4.44L0.1905201042110.1498-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1905201042110.1498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, May 20, 2019 4:44:21 PM CEST Alan Stern wrote:
> The syzbot fuzzer found a bug in the p54 USB wireless driver.  The
> issue involves a race between disconnect and the firmware-loader
> callback routine, and it has several aspects.
> 
> One big problem is that when the firmware can't be loaded, the
> callback routine tries to unbind the driver from the USB _device_ (by
> calling device_release_driver) instead of from the USB _interface_ to
> which it is actually bound (by calling usb_driver_release_interface).
> 
> The race involves access to the private data structure.  The driver's
> disconnect handler waits for a completion that is signalled by the
> firmware-loader callback routine.  As soon as the completion is
> signalled, you have to assume that the private data structure may have
> been deallocated by the disconnect handler -- even if the firmware was
> loaded without errors.  However, the callback routine does access the
> private data several times after that point.
> 
> Another problem is that, in order to ensure that the USB device
> structure hasn't been freed when the callback routine runs, the driver
> takes a reference to it.  This isn't good enough any more, because now
> that the callback routine calls usb_driver_release_interface, it has
> to ensure that the interface structure hasn't been freed.
> 
> Finally, the driver takes an unnecessary reference to the USB device
> structure in the probe function and drops the reference in the
> disconnect handler.  This extra reference doesn't accomplish anything,
> because the USB core already guarantees that a device structure won't
> be deallocated while a driver is still bound to any of its interfaces.
> 
> To fix these problems, this patch makes the following changes:
> 
> 	Call usb_driver_release_interface() rather than
> 	device_release_driver().
> 
> 	Don't signal the completion until after the important
> 	information has been copied out of the private data structure,
> 	and don't refer to the private data at all thereafter.
> 
> 	Lock udev (the interface's parent) before unbinding the driver
> 	instead of locking udev->parent.
> 
> 	During the firmware loading process, take a reference to the
> 	USB interface instead of the USB device.
> 
> 	Don't take an unnecessary reference to the device during probe
> 	(and then don't drop it during disconnect).
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-and-tested-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com
> CC: <stable@vger.kernel.org>

Finally I'm at home where I have the device. Did some test with replugging
and module unloading, all seems fine. Thanks!

Acked-by: Christian Lamparter <chunkeey@gmail.com> 


