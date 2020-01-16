Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAF213FC00
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 23:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389753AbgAPWIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 17:08:44 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38809 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAPWIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 17:08:44 -0500
Received: by mail-qk1-f196.google.com with SMTP id k6so20794780qki.5
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 14:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6BPPs+aLi7Nz8lIEdK8O8Pavh4KOBT4UHAytpKVgPtA=;
        b=tUe9HXy2o07PLSiVxga070dw7AF2velfjpH3YuJ5VG40MJan2UT+mr+6s39k4pPeG1
         3MkhHRO3RvS2DsLrA0tVTWFikCksOBe663qBVeK1ykT0rTtMWQsiv5ElX0z4S+uSLu+C
         8IdKW6sBmzXW/xqw7xyetfLuJC6lDxQssG3eCQQ3yzOmgznHr9TEtl9l9XKD3kN6nV38
         6zvpLAGfpZ6ggCr7eZ9NNFM3KuEKhTpx2NcbWPhG/fKEgSSJcNhFYh/dcwoobyc0mk63
         yP/kvGrETWl0AXPrQ5VWfrsx/iDfNI32PSVPVCRnhM7jWpFse1XnnMj+2ejYzrhb4wap
         /ZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6BPPs+aLi7Nz8lIEdK8O8Pavh4KOBT4UHAytpKVgPtA=;
        b=Mq3QqzXIxM1XW4nwSHumTyGPC49oqZhuuh19rZs4VZyAuyIabEMJc4LGTnj7LEGmsy
         saBvLwmlQzdSC1ubLSlyj7DoMsEXpGnYkfbzmgjkIdNFHearTRZS3Fk+EE0X+hUAy7FQ
         hckDDHcFoUmw6RQVOYoqRaLhBXFd9VuEvYyUEzUPdsfLgEkqBe/BxRpxwu+bRHi5B8R2
         ss7QQ7UpqTa+pGdNCWU0BR/OlGD1tAjDgoopAMTICKg6hQH3pnqsC8ohSjaS8haGFdU6
         uZAVlOERC7tEkDO/mOhrVxlAJDoBuRXCzb6Za75zCtTQNG31XhQwdECqRFBjkR0B8Q0R
         xTXQ==
X-Gm-Message-State: APjAAAWPBCbSpFhTUZ+igfc0ANuaXNpY4oQNOoD7J4tdiqekufdIc/9D
        N00KNVv+UjnB2wUraiXEN+SN+qZ7WonZ8s8pslop8yfe
X-Google-Smtp-Source: APXvYqy0G+/R9LjdCGhxYsgNRZfjIrCCqQOZwZ5YGcjOJ2wwK5OJ6xVxRgr7hmiXK7ZKbYDazbjIY1VCxNznvDLK9SI=
X-Received: by 2002:a05:620a:1fa:: with SMTP id x26mr30828633qkn.311.1579212522896;
 Thu, 16 Jan 2020 14:08:42 -0800 (PST)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Thu, 16 Jan 2020 17:08:31 -0500
Message-ID: <CAH6h+hczhYdCebrXHnVy4tE6bXGhSJg4GZkfJVYEQtjjb-A-EQ@mail.gmail.com>
Subject: 5.4.12 bnxt_en: Unable do read adapter's DSN
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm using the 'bnxt_en' driver with vanilla Linux 5.4.12. I have a
Broadcom P225p 10/25 GbE adapter. I previously used this adapter with
Linux 4.14.120 with no issues. Now with 5.4.12 I observe the following
kernel messages during initialization:
...
[    2.605878] Broadcom NetXtreme-C/E driver bnxt_en v1.10.0
[    2.618302] bnxt_en 0000:00:03.0 (unnamed net_device)
(uninitialized): Unable do read adapter's DSN
[    2.622295] bnxt_en: probe of 0000:00:03.0 failed with error -95
[    2.632808] bnxt_en 0000:00:0a.0 (unnamed net_device)
(uninitialized): Unable do read adapter's DSN
[    2.637043] bnxt_en: probe of 0000:00:0a.0 failed with error -95
...

Looks like this comes from bnxt_pcie_dsn_get() in
drivers/net/ethernet/broadcom/bnxt/bnxt.c:
...
        int pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
        u32 dw;

        if (!pos) {
                netdev_info(bp->dev, "Unable do read adapter's DSN");
                return -EOPNOTSUPP;
        }
...

And this appears to be related to newer functionality that was not
present in Linux 4.14.x. I am using the P225p via PCI passthrough from
a QEMU/KVM host. I do not have SR-IOV enabled on the card, so not
passing VF's through to the VM (only the PF's).

The card works in the host platform / hypervisor OS (CentOS 7) but
that of course is using the RHEL 3.10.x variant.


I guess my question is:
- Is it expected that a DSN (device serial number) should be available
(fetched via "pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN)) when
the card is passed through into a QEMU/KVM (PCI pass through)? In
other words, is there a problem with my setup/card where the driver
should expect to read a DSN from inside of a virtual machine?
- Or is it normal for a DSN to not be available inside of the virtual
machine guest OS, and the 'bnxt_en' driver needs to be modified to
handle this case? I noticed in the upstream driver (direct from
Broadcom, bnxt_1.10.0-214.0.253.1) that bnxt_pcie_dsn_get() now
resides in bnxt_vfr.c and is called from bnxt_vf_reps_create() (rather
than bnxt_init_one() in 5.4.12).

Any help/advice would be greatly appreciated, thanks in advance.


--Marc
