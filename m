Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327CD20DFDA
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbgF2UkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731710AbgF2TOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:12 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1986EC02A55A
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 06:13:52 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id b25so14360880ljp.6
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 06:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=SRRKbobNZgyffA4bPBhnBxCD9lxACtvSDQceagPHE84=;
        b=UDUql/2QDKlKEPp+Kr7bOtykcOSDbpCedX/Z1GznPFU3VbDjK/KVkaV4M3jdbgj8T9
         phRBSsUtdPXtcvFgQHupTQ899d8b48sH0VkaVV2FMuiF947qnZ0jr+rFeq44eKLI5Hfg
         +D9NLCgOAbUtPuj1yBjctQyfvcfzvq2OgeQnrqRAcB/Mo8z2lc2xbd5Lf6KX89s8Tzqs
         ZyiiDZw5zFhZFxErRX/WZdMdJB4SAUbX2iUEE6N91FLGsbZwDsQzO3VARcYYErcoKVOp
         PQyHly+bNdRlGIOBwGocUOHD21rcq5eOEMy9O0D6olxCDUstImtAFHOfDoJdr7Vg6wuF
         Avqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SRRKbobNZgyffA4bPBhnBxCD9lxACtvSDQceagPHE84=;
        b=HdsCC1ukDizqgHGc7uZdWfh40A4HgO8ydl4JSjJnC/0oz7gXqTM+hruzLvnySMnW3K
         cuJdFywqaLLTeupTDIzH0RcsqGt33Df3Y6ei1Frt+AczNFekqlD08gQuazLVFYgSKLAZ
         bt7EZ+FpXqDzlvQa44Sl4nlNVGnRJw26Z2fvdzO/pLI0kzoIeX+HHR2rvdtgzEIeh3lg
         nBK+cBtI6WjiGoV4WnmfdRQkyDTzO/SSG831yhEDgP9edFuPt+1oUq8sf9azPe02x6CZ
         gdrONDIK9elak9esK1YoqDq1R4CHGkhz/EQvfZ90aCMYJ663kYIQ+OrGiYGXKKHS3Lkw
         kzBw==
X-Gm-Message-State: AOAM531oMPmfV2tu8Irldfj5PLujwjPZJd55zUoLXmhGWiELYITXtmoZ
        7mrtnM4UnCG3w3Xer8O6asQ6PIehHMHnng==
X-Google-Smtp-Source: ABdhPJxWafELtEmdCWhuy2yrDcKO/EwiIBsVtfbd7CEfzCmSPDME25APyfp3Oi2QVl4FWxKAQ7hV4A==
X-Received: by 2002:a2e:96cb:: with SMTP id d11mr5523564ljj.140.1593436430479;
        Mon, 29 Jun 2020 06:13:50 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id 16sm647916ljw.127.2020.06.29.06.13.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 06:13:49 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v14 0/3] xen networking: add XDP support to xen-netfront
Date:   Mon, 29 Jun 2020 16:13:26 +0300
Message-Id: <1593436409-1101-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds a new extra type to enable proper synchronization
between an RX request/response pair.
The second patch implements BFP interface for xen-netfront.
The third patch enables extra space for XDP processing.

v14:
- fixed compilation warnings

v13:
- fixed compilation due to previous rename

v12:
- xen-netback: rename netfront_xdp_headroom to xdp_headroom

v11:
- add the new headroom constant to netif.h
- xenbus_scanf check
- lock a bulk of puckets in xennet_xdp_xmit()

v10:
- add a new xen_netif_extra_info type to enable proper synchronization
 between an RX request/response pair.
- order local variable declarations

v9:
- assign an xdp program before switching to Reconfiguring
- minor cleanups
- address checkpatch issues

v8:
- add PAGE_POOL config dependency
- keep the state of XDP processing in netfront_xdp_enabled
- fixed allocator type in xdp_rxq_info_reg_mem_model()
- minor cleanups in xen-netback

v7:
- use page_pool_dev_alloc_pages() on page allocation
- remove the leftover break statement from netback_changed

v6:
- added the missing SOB line
- fixed subject

v5:
- split netfront/netback changes
- added a sync point between backend/frontend on switching to XDP
- added pagepool API

v4:
- added verbose patch descriprion
- don't expose the XDP headroom offset to the domU guest
- add a modparam to netback to toggle XDP offset
- don't process jumbo frames for now

v3:
- added XDP_TX support (tested with xdping echoserver)
- added XDP_REDIRECT support (tested with modified xdp_redirect_kern)
- moved xdp negotiation to xen-netback

v2:
- avoid data copying while passing to XDP
- tell xen-netback that we need the headroom space

Denis Kirjanov (3):
  xen: netif.h: add a new extra type for XDP
  xen networking: add basic XDP support for xen-netfront
  xen networking: add XDP offset adjustment to xen-netback

 drivers/net/Kconfig                 |   1 +
 drivers/net/xen-netback/common.h    |   4 +
 drivers/net/xen-netback/interface.c |   2 +
 drivers/net/xen-netback/netback.c   |   7 +
 drivers/net/xen-netback/rx.c        |  15 +-
 drivers/net/xen-netback/xenbus.c    |  34 ++++
 drivers/net/xen-netfront.c          | 336 ++++++++++++++++++++++++++++++++++--
 include/xen/interface/io/netif.h    |  20 ++-
 8 files changed, 407 insertions(+), 12 deletions(-)

-- 
1.8.3.1

