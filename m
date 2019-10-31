Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29926EB593
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbfJaQ64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:58:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39673 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbfJaQ64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:58:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id x28so1544271pfo.6
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 09:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=f05iF9G/ns17rw6cWJfFu0PgDfLMjLHyebXYR1Ckmlg=;
        b=DkSoRXJw1W+71GwuFvu0kD3++jlSponfDd7ClMOLNsxEwkHMn0jd8JKBqtihFBP0Fj
         8FvYmMSpvVEb3/+tgTiUHEvX8Cx8Dcc+PLviBuzmNqfs/2u5FSBWMhBF4qljZSF4wzuM
         lpx16wijqYPNnd285Yh/IqVKFoASglncCZBa0gp5eG2eExIbOFojDjadlR4v8wBcsX3Y
         8hzm0Y+ffSUK/lmDtNGVxc2IPU/QNSpC8Jhmdhmps0mM9FQL/bcD6qTh26G61dhuQnBj
         Q3jsEJWUhKP7+xgpo2g+0QDg6dB5Z7SfmK87pFAXgOxBXPXr4Mra0jLePTQv+gHOyD/+
         rf9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=f05iF9G/ns17rw6cWJfFu0PgDfLMjLHyebXYR1Ckmlg=;
        b=JDCb4DKWQ6WmK1olFBKg+b1sV/X88ZjfBl2qduAqpM2+NnvYKyVZ61tJ7EPPf/ONbt
         l0BffFvGWURiNeHBnzu1bOctuamuihvNuNNYNVSZuTD3mGGFYgFX5q6/udtnysd4Ctm0
         VTkEYdeQMWB6w6iOrWzv5qlJPE0cl5YSSg+iL8lDTuU5fU+7Sw2MPguZXeexjhDwRWcs
         nVAX7vbG0+A9bLbN57rGVxNTZaxgCmWSlPopMO6btZsXSE8z5ouA4y2/V5OWouEil/Yg
         vWJJBKqi+4JW+/ci5M3lf1ErCMEWYYEQIDqME6z0una6AFeUp+d3OIgdBYQpr5i/LaOV
         kkZg==
X-Gm-Message-State: APjAAAWeC46D+Fy5/DOUu4TPfwxHXGIx8TnQw8djsO2C32535vOIerT0
        xxR81EzXnT0SGm9xL6zSwiYHVkDv
X-Google-Smtp-Source: APXvYqwFrU1yqpKXXBPuvye6oNxNqBJVeGKNV+dW703NTSZb4ccjtQbJslh1Up020KD8f+yf0tL92A==
X-Received: by 2002:a63:3603:: with SMTP id d3mr8094466pga.208.1572541133575;
        Thu, 31 Oct 2019 09:58:53 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id h9sm4349964pfn.167.2019.10.31.09.58.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 09:58:52 -0700 (PDT)
Subject: [next-queue/net-next PATCH] e1000e: Use netdev_info instead of
 pr_info for link messages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     joe@perches.com, jeffrey.t.kirsher@intel.com, davem@davemloft.net
Cc:     zdai@linux.vnet.ibm.com, nhorman@redhat.com,
        netdev@vger.kernel.org, smorumu1@in.ibm.com,
        intel-wired-lan@lists.osuosl.org, aaron.f.brown@intel.com,
        sassmann@redhat.com
Date:   Thu, 31 Oct 2019 09:58:51 -0700
Message-ID: <20191031165537.24154.48242.stgit@localhost.localdomain>
In-Reply-To: <cf197ef61703cbaa64ac522cf5d191b4b74f64d6.camel@linux.intel.com>
References: <cf197ef61703cbaa64ac522cf5d191b4b74f64d6.camel@linux.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Replace the pr_info calls with netdev_info in all cases related to the
netdevice link state.

As a result of this patch the link messages will change as shown below.
Before:
e1000e: ens3 NIC Link is Down
e1000e: ens3 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

After:
e1000e 0000:00:03.0 ens3: NIC Link is Down
e1000e 0000:00:03.0 ens3: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---

Since Joe hasn't gotten back to me on if he wanted to do the patch or if
he wanted me to do it I just went ahead and did it. This should address the
concerns he had about the message formatting in "e1000e: Use rtnl_lock to
prevent race".

 drivers/net/ethernet/intel/e1000e/netdev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index ef8ca0c134b0..a1aa48168855 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4720,7 +4720,7 @@ int e1000e_close(struct net_device *netdev)
 		e1000_free_irq(adapter);
 
 		/* Link status message must follow this format */
-		pr_info("%s NIC Link is Down\n", netdev->name);
+		netdev_info(netdev, "NIC Link is Down\n");
 	}
 
 	napi_disable(&adapter->napi);
@@ -5070,8 +5070,9 @@ static void e1000_print_link_info(struct e1000_adapter *adapter)
 	u32 ctrl = er32(CTRL);
 
 	/* Link status message must follow this format for user tools */
-	pr_info("%s NIC Link is Up %d Mbps %s Duplex, Flow Control: %s\n",
-		adapter->netdev->name, adapter->link_speed,
+	netdev_info(adapter->netdev,
+		"NIC Link is Up %d Mbps %s Duplex, Flow Control: %s\n",
+		adapter->link_speed,
 		adapter->link_duplex == FULL_DUPLEX ? "Full" : "Half",
 		(ctrl & E1000_CTRL_TFCE) && (ctrl & E1000_CTRL_RFCE) ? "Rx/Tx" :
 		(ctrl & E1000_CTRL_RFCE) ? "Rx" :
@@ -5304,7 +5305,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 			adapter->link_speed = 0;
 			adapter->link_duplex = 0;
 			/* Link status message must follow this format */
-			pr_info("%s NIC Link is Down\n", adapter->netdev->name);
+			netdev_info(netdev, "NIC Link is Down\n");
 			netif_carrier_off(netdev);
 			netif_stop_queue(netdev);
 			if (!test_bit(__E1000_DOWN, &adapter->state))

