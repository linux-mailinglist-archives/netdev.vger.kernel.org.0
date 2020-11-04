Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAB52A6049
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgKDJG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDJGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:25 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAD4C061A4D
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:24 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 33so10384157wrl.7
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVySsFYAxVyvKjZwFTKaFMnVATseHBsi4tJ0dIp9TLE=;
        b=K1+Rdz5ogf/5T2jMdF3v9m88jLY/gNqsMKJm061QdgaEQGjK4st39GT4kTZK6c7eAv
         3cJicgPoZBh9YEvxLFGZcZyHE0XnNqBy1XOiWQuoMPDL9faO4RhxQ9VP++HCtvthQR9S
         799P3oQD3ZEWTAn8Z+1PDWW2WOSIRjZ/YNizWauRHAov45YgSsQGFvDCGkpGdXI1KiOg
         QyMiZ+qAf84rNKlDHGrCMb3Z298LfBhK4STT2/MKrClXtDUj1+DxmNn50j9f2xT6h0lS
         2FLRla4Vx5B06Pb85+k62n0XQr8agXXsfRziu37OjAXEKgzSYzjV1kzmZ4S3HLfgeg3X
         jRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVySsFYAxVyvKjZwFTKaFMnVATseHBsi4tJ0dIp9TLE=;
        b=PWH3qPwbwOXHX4LeoG5Nf5m4fyeTZ7T12X7hUfnkoOaV/JwdA1SLtw0uvuWXU/PylK
         1weYTzjJFBpfKYBJDCiZ1xfWz18LwDzWVd5Q6AKnr5CJiMakX9yy/zT/JmTLKpsugPvl
         zIjndeMMYhmmyL2QnPuFXEwk7VFai+yZv8vgudVyvAnskm4YQccG4oOxSL2lokqIgbVy
         l4N4a7itgKcIW5EPxorHvGfAvSm+eMp7Ppex2Rq415sDGghb2X2rVB4CkE8BUoO7bV32
         Q1F4Zx1rqPcOkuAnvdnhoB8947HzZRSxbNkx9h+tHdcv+5ndxF9yrmME9deVK+2Ho/al
         h8zg==
X-Gm-Message-State: AOAM531vwBGb2+pyrn60Ws4KsooNgivNWaSwjNTbWeRLUhSNgvVosqDZ
        nfmbix6jU/LkxUIHAmFg+2cKxQ==
X-Google-Smtp-Source: ABdhPJzn8d8Abh2QVS+FdXToKUqdpB6TwiMSAYlD5+ls0hMcq+h/pWmcBsJhdaEKInesWzdpNiQxsw==
X-Received: by 2002:adf:e384:: with SMTP id e4mr31089426wrm.227.1604480782887;
        Wed, 04 Nov 2020 01:06:22 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:22 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Dany Madden <drt@linux.ibm.com>,
        Daris A Nevil <dnevil@snmc.com>,
        Dustin McIntire <dustin@sensoria.com>,
        Erik Stahlman <erik@vt.edu>,
        Geoff Levand <geoff@infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Allen <jallen@linux.vnet.ibm.com>,
        John Fastabend <john.fastabend@gmail.com>,
        John Williams <john.williams@xilinx.com>,
        Juergen Gross <jgross@suse.com>,
        KP Singh <kpsingh@chromium.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Lijun Pan <ljp@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-usb@vger.kernel.org, Martin Habets <mhabets@solarflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Paul Durrant <paul@xen.org>, Paul Mackerras <paulus@samba.org>,
        Peter Cammaert <pc@denkart.be>,
        Russell King <rmk@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Santiago Leon <santi_leon@yahoo.com>,
        Shannon Nelson <snelson@pensando.io>,
        Song Liu <songliubraving@fb.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Wei Liu <wei.liu@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        xen-devel@lists.xenproject.org, Yonghong Song <yhs@fb.com>
Subject: [PATCH 00/12] [Set 2] Rid W=1 warnings in Net
Date:   Wed,  4 Nov 2020 09:05:58 +0000
Message-Id: <20201104090610.1446616-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

This is the last set.

Lee Jones (12):
  net: usb: lan78xx: Remove lots of set but unused 'ret' variables
  net: ethernet: smsc: smc911x: Mark 'status' as __maybe_unused
  net: ethernet: xilinx: xilinx_emaclite: Document 'txqueue' even if it
    is unused
  net: ethernet: smsc: smc91x: Demote non-conformant kernel function
    header
  net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
  net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function
    header
  net: ethernet: ti: am65-cpts: Document am65_cpts_rx_enable()'s 'en'
    parameter
  net: xen-netfront: Demote non-kernel-doc headers to standard comment
    blocks
  net: ethernet: ibm: ibmvnic: Fix some kernel-doc misdemeanours
  net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc
    misdemeanours
  net: ethernet: toshiba: spider_net: Document a whole bunch of function
    parameters
  net: ethernet: ibm: ibmvnic: Fix some kernel-doc issues

 drivers/net/ethernet/ibm/ibmvnic.c            |  27 ++-
 drivers/net/ethernet/smsc/smc911x.c           |   6 +-
 drivers/net/ethernet/smsc/smc91x.c            |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c       |   2 +-
 drivers/net/ethernet/ti/am65-cpts.c           |   2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |   9 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  18 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |   1 +
 drivers/net/usb/lan78xx.c                     | 212 +++++++++---------
 drivers/net/xen-netback/xenbus.c              |   4 +-
 drivers/net/xen-netfront.c                    |   6 +-
 11 files changed, 141 insertions(+), 148 deletions(-)

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: bpf@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dany Madden <drt@linux.ibm.com>
Cc: Daris A Nevil <dnevil@snmc.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dustin McIntire <dustin@sensoria.com>
Cc: Erik Stahlman <erik@vt.edu>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: John Williams <john.williams@xilinx.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: KP Singh <kpsingh@chromium.org>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: Lijun Pan <ljp@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-usb@vger.kernel.org
Cc: Martin Habets <mhabets@solarflare.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: netdev@vger.kernel.org
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Paul Durrant <paul@xen.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Cammaert <pc@denkart.be>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Santiago Leon <santi_leon@yahoo.com>
Cc: Shannon Nelson <snelson@pensando.io>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc: Thomas Falcon <tlfalcon@linux.vnet.ibm.com>
Cc: Utz Bacher <utz.bacher@de.ibm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: xen-devel@lists.xenproject.org
Cc: Yonghong Song <yhs@fb.com>
-- 
2.25.1

