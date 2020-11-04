Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D002A6B30
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbgKDQ5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbgKDQ5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:31 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D97C0613D3;
        Wed,  4 Nov 2020 08:57:29 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id p5so30754866ejj.2;
        Wed, 04 Nov 2020 08:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y+MGI74PgtXhSh9jTeawuPn6w76E8dwfz1mFXOZyHzk=;
        b=mk0j30pDf5CuX7RfZH36SadhhwGKmAYQsyXmNoh7LHOeCVxJO3ncOJIYU+qnWdtkiY
         eFoTW1+Ul66agoapoZ4VlFjqkyvDp+WGsb19/kxXumoO2cDH3pui5Wn1li7+1rwS0dhU
         JF41CT3swNdp42q86+5MB8lNIxVL5xDR1cRM4AX/05d35xCD+ead0nK/tIuKgmfmufvN
         sSE7IMkm38+PuahO7MxarDlRlMszTScul/eX4nR9JuzahT/zV/NVYNZu4UTagCMb+bA6
         ywJv2SX8xKJ8Xc/E1g6sMkBROOoly7xK9q9mDk4NTc3tLWTCqTm+F/QXXYqQT6bGQ4Xl
         NRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y+MGI74PgtXhSh9jTeawuPn6w76E8dwfz1mFXOZyHzk=;
        b=iUlo/DCVNTT1sWyW49OB75EIuFRJBgvKVclx6jWS/ni91PA6sxVvDR2qLe+DX7oJWF
         s/wYrvOs0luW+XBEd3NyDo9hqzGtNxUNOQmhHW98dH7X46AsZECzSocKI/B5LrjOTQjO
         fBDWQLhNneJqw8wlChSLoalv9FLvvRVudXqSYByI8//wowLCa82tR8R7vQN06tOwEGQt
         MymXJiIYpaLS2dUqwhFCPgzqIxJ0OTsJvpLHBeqBD+LjMDRwJMwk8isrMs6pCcHEiecB
         H6s+wiiX615a0yNszGTw80tC7O1ea2b3tstJSGEl3wyJeuXiROu39t82NPmAuAcwVyjU
         qImw==
X-Gm-Message-State: AOAM533v7XHPsay06vx/2uRVqZvKbPUAuj+OD2Zv9yBX1k4FauaMUFYR
        3VoVxAw7qVHZxa0T5K13lLY=
X-Google-Smtp-Source: ABdhPJwwbKF+gakBrvZlPsG815nctD89Ch10Wm9WHT0fg5y6G/FPWGd8uvjKmsgYquSgC/91JAy0Dg==
X-Received: by 2002:a17:906:1f42:: with SMTP id d2mr25308733ejk.407.1604509048614;
        Wed, 04 Nov 2020 08:57:28 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:27 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 0/9] staging: dpaa2-switch: add support for CPU terminated traffic
Date:   Wed,  4 Nov 2020 18:57:11 +0200
Message-Id: <20201104165720.2566399-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set adds support for Rx/Tx capabilities on DPAA2 switch port
interfaces as well as fixing up so major blunders in how we take care of
the switching domains. The netdev community considers this as a basic
features, thus it's sent against the staging tree before anything can be
moved out of it.

The control interface is comprised of 3 queues in total: Rx, Rx error
and Tx confirmation. In this patch set we only enable Rx and Tx conf.
All switch ports share the same queues when frames are redirected to the
CPU.  Information regarding the ingress switch port is passed through
frame metadata - the flow context field of the descriptor.

NAPI instances are also shared between switch net_devices and are
enabled when at least on one of the switch ports .dev_open() was called
and disabled when no switch port is still up.

Since the last version of this feature was submitted to the list, I
reworked how the switching and flooding domains are taken care of by the
driver, thus the switch is now able to also add the control port (the
queues that the CPU can dequeue from) into the flooding domains of a
port (broadcast, unknown unicast etc). With this, we are able to receive
and sent traffic from the switch interfaces.

Also, the capability to properly partition the DPSW object into multiple
switching domains was added so that when not under a bridge, the ports
are not actually capable to switch between them. This is possible by
adding a private FDB table per switch interface.  When multiple switch
interfaces are under the same bridge, they will all use the same FDB
table.

Another thing that is fixed in this patch set is how the driver handles
VLAN awareness. The DPAA2 switch is not capable to run as VLAN unaware
but this was not reflected in how the driver responded to requests to
change the VLAN awareness. In the last patch, this is fixed by
describing the switch interfaces as Rx VLAN filtering on [fixed] and
declining any request to join a VLAN unaware bridge.

I am sending this as a RFC since I would like to receive feedback on the
current capabilities of the switch driver and if they meet or not meet
the expectations, all this before I actually settle on a firmware
interface.

Ioana Ciornei (9):
  staging: dpaa2-switch: get control interface attributes
  staging: dpaa2-switch: setup buffer pool for control traffic
  staging: dpaa2-switch: setup RX path rings
  staging: dpaa2-switch: setup dpio
  staging: dpaa2-switch: handle Rx path on control interface
  staging: dpaa2-switch: add .ndo_start_xmit() callback
  staging: dpaa2-switch: enable the control interface
  staging: dpaa2-switch: properly setup switching domains
  staging: dpaa2-switch: accept only vlan-aware upper devices

 drivers/staging/fsl-dpaa2/Kconfig          |    1 +
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |   89 +-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  269 +++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  144 +++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 1131 ++++++++++++++++++--
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |   75 +-
 6 files changed, 1641 insertions(+), 68 deletions(-)

-- 
2.28.0

