Return-Path: <netdev+bounces-3519-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE60E707ACB
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 681372817A6
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BB02A9E0;
	Thu, 18 May 2023 07:28:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4521417FC
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:28:02 +0000 (UTC)
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AEE2101
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:27:59 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-2533d74895bso1479895a91.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684394879; x=1686986879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B0KPsRgZkrYOqM2qiaYRx/3vo+OhEcW+JKXrMqHHRi8=;
        b=KifR2KEG+YkazDWDu+y0p8UbuCC4weUt9xdIUdiL/2Fp9jPiPoORyHkQElgFNju9WQ
         6dyXWMSpb/owFxTwZNx3zadPTdMxpuQ4YyO7/MON7qezouH8njZwDuzJisTPkP9Nbivm
         e52wQv4hQcph/C9JTH7yu67pJMbaDRXAX02GA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684394879; x=1686986879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B0KPsRgZkrYOqM2qiaYRx/3vo+OhEcW+JKXrMqHHRi8=;
        b=Qk2bDzD6E4GMpsozQJvs6Hg5j9ny4yQEeJ6yMe46DSxTZBm2mbpBjNwipeJLAmDU/z
         nWzei/WlzrK5UABB+8fef4FhA+hWo6mZwC3oDFtPgKnRgZMIVuW7GebGZEoMNi4lpbIa
         0RZEy1gvPThGgMmRwSfHqUJTee6Y0umEZFA8E+paDPwef9ji+1QhL+4FNgZLivKx/DHo
         X9zCiJkkcapoyFfTMDObX3zsXfQYwwdw7DLBiwYLop+NKuph/XK0Wt+CVbX3c1dqBmCm
         4pxvWdd56m++U4Elkgy1gr5Mij9701Zj2mrMH0VL/+ihYVnHKCM9VNHNIPLoluUaWe95
         5ngQ==
X-Gm-Message-State: AC+VfDyD/25W/BQ3voJLLLgVmPqpxTqvvFVhtu4u4jpuSWmpRD9lz5+g
	BnM2nIkNDqT7XYsPPmaEEWkpAizJO0jd8tb4XjM=
X-Google-Smtp-Source: ACHHUZ6kn57EUT67NPJLEbc98mcDOFCe/2x+n9xYSKDeif2fpTykIqyWRQD5H+dOSl2BwPpI0wT93A==
X-Received: by 2002:a17:90a:9f8d:b0:24e:4c8:3ae5 with SMTP id o13-20020a17090a9f8d00b0024e04c83ae5mr1852042pjp.28.1684394879222;
        Thu, 18 May 2023 00:27:59 -0700 (PDT)
Received: from localhost (21.160.199.104.bc.googleusercontent.com. [104.199.160.21])
        by smtp.gmail.com with UTF8SMTPSA id g8-20020a17090adb0800b0025315f7fef7sm2788601pjv.33.2023.05.18.00.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 00:27:58 -0700 (PDT)
From: Ying Hsu <yinghsu@chromium.org>
To: netdev@vger.kernel.org
Cc: grundler@chromium.org,
	Ying Hsu <yinghsu@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] igb: Fix igb_down hung on surprise removal
Date: Thu, 18 May 2023 07:26:57 +0000
Message-ID: <20230518072657.1.If9539da710217ed92e764cc0ba0f3d2d246a1aee@changeid>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a setup where a Thunderbolt hub connects to Ethernet and a display
through USB Type-C, users may experience a hung task timeout when they
remove the cable between the PC and the Thunderbolt hub.
This is because the igb_down function is called multiple times when
the Thunderbolt hub is unplugged. For example, the igb_io_error_detected
triggers the first call, and the igb_remove triggers the second call.
The second call to igb_down will block at napi_synchronize.
Here's the call trace:
    __schedule+0x3b0/0xddb
    ? __mod_timer+0x164/0x5d3
    schedule+0x44/0xa8
    schedule_timeout+0xb2/0x2a4
    ? run_local_timers+0x4e/0x4e
    msleep+0x31/0x38
    igb_down+0x12c/0x22a [igb 6615058754948bfde0bf01429257eb59f13030d4]
    __igb_close+0x6f/0x9c [igb 6615058754948bfde0bf01429257eb59f13030d4]
    igb_close+0x23/0x2b [igb 6615058754948bfde0bf01429257eb59f13030d4]
    __dev_close_many+0x95/0xec
    dev_close_many+0x6e/0x103
    unregister_netdevice_many+0x105/0x5b1
    unregister_netdevice_queue+0xc2/0x10d
    unregister_netdev+0x1c/0x23
    igb_remove+0xa7/0x11c [igb 6615058754948bfde0bf01429257eb59f13030d4]
    pci_device_remove+0x3f/0x9c
    device_release_driver_internal+0xfe/0x1b4
    pci_stop_bus_device+0x5b/0x7f
    pci_stop_bus_device+0x30/0x7f
    pci_stop_bus_device+0x30/0x7f
    pci_stop_and_remove_bus_device+0x12/0x19
    pciehp_unconfigure_device+0x76/0xe9
    pciehp_disable_slot+0x6e/0x131
    pciehp_handle_presence_or_link_change+0x7a/0x3f7
    pciehp_ist+0xbe/0x194
    irq_thread_fn+0x22/0x4d
    ? irq_thread+0x1fd/0x1fd
    irq_thread+0x17b/0x1fd
    ? irq_forced_thread_fn+0x5f/0x5f
    kthread+0x142/0x153
    ? __irq_get_irqchip_state+0x46/0x46
    ? kthread_associate_blkcg+0x71/0x71
    ret_from_fork+0x1f/0x30

In this case, igb_io_error_detected detaches the network interface
and requests a PCIE slot reset, however, the PCIE reset callback is
not being invoked and thus the Ethernet connection breaks down.
As the PCIE error in this case is a non-fatal one, requesting a
slot reset can be avoided.
This patch fixes the task hung issue and preserves Ethernet
connection by ignoring non-fatal PCIE errors.

Signed-off-by: Ying Hsu <yinghsu@chromium.org>
---
This commit has been tested on a HP Elite Dragonfly Chromebook and
a Caldigit TS3+ Thunderbolt hub. The Ethernet driver for the hub
is igb. Non-fatal PCIE errors happen when users hot-plug the cables
connected to the chromebook or to the external display.

 drivers/net/ethernet/intel/igb/igb_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 58872a4c2540..a8b217368ca1 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9581,6 +9581,11 @@ static pci_ers_result_t igb_io_error_detected(struct pci_dev *pdev,
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
+	if (state == pci_channel_io_normal) {
+		dev_warn(&pdev->dev, "Non-correctable non-fatal error reported.\n");
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	}
+
 	netif_device_detach(netdev);
 
 	if (state == pci_channel_io_perm_failure)
-- 
2.40.1.606.ga4b1b128d6-goog


