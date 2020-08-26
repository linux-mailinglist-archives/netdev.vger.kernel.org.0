Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100002525B5
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 05:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHZDEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 23:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgHZDEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 23:04:04 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5A3C061574;
        Tue, 25 Aug 2020 20:04:04 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m34so307947pgl.11;
        Tue, 25 Aug 2020 20:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tWZBSAFPB25Ix8dxJn0Apg8q5RD1rLXKwul0a9thtfs=;
        b=qeU+YGnR6JDsoGqwquHCY9zcM2jhoA3P3cgTEY8sz4dSdMJld9Q/4yAcx1Slz95rA6
         lVl34RkyDejG9atiuiQZ7BJZb96z1kCMNKamgcBMeCp0xT9rrasgdlgaYbXgpGhBwsgY
         d1F/ZSgVN/Xzy0vxJyDp521+HpbqwK/9loN8pHXCV3YklhjCLGonakXYtdcaeAh65myp
         8prbYv7Z23r1JJrcZfW5YaEoobBP60lVxM/R0C1eTHR/DUffJLfLTxju5kpSmc+JJlLv
         6VsWAssMTaVUa4lEJQkCVHbgwxdGsVqoatb5GxQcyVmDAvnrdO1pAAxLybnCwXmzHszI
         7GzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tWZBSAFPB25Ix8dxJn0Apg8q5RD1rLXKwul0a9thtfs=;
        b=QYYeYUdV3dx/OPo/zEaBikOafjXoh0SVS9VLJk1/sQvoaEul1RRHHyfA6Q4akR4Qf/
         WtjjAZlubS06jBUQGCxz+HG+BcoBm/OjQup+cC9q667SnZhDqy//6t10Pac11XPEGrom
         N/KxSmfB5fXfKABv0ADYliblQEgujMz6nww6IOdpP0eMo7J/xeB7sFfqMRKsd5xg4LMU
         XezGDuhmENbgpacADorCxV/VLZ3gQfmCMDO/jS3eW0tD2w3L7JlIBNAv3Sd6uHv33GDb
         s6ho5FhNtlytufLRF5T0pQte1d3jEz/1etxQ5i4ffH4uO0tH242lCVJgFyItyT/Pn8eT
         6jvQ==
X-Gm-Message-State: AOAM530qP8Nseb4jDGIH+f6AvTBthWoBAR+YV38EMGwWjgXKgBC1ToVr
        3Al/0xs/shMV5t0fTRorbEQ=
X-Google-Smtp-Source: ABdhPJxaloAhp6tK707mtwlbVKfSHOpsGeu3FG2FKBWoAK1Ry5aBidpHaLlK+ODw3SH6MJqvkYQTaQ==
X-Received: by 2002:a63:1523:: with SMTP id v35mr9264734pgl.317.1598411043590;
        Tue, 25 Aug 2020 20:04:03 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8880:9ae0:117e:686d:dc72:3bd8])
        by smtp.gmail.com with ESMTPSA id s10sm411776pjl.37.2020.08.25.20.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 20:04:02 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] drivers/net/wan/lapbether: Set network_header before transmitting
Date:   Tue, 25 Aug 2020 20:03:53 -0700
Message-Id: <20200826030353.75645-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the skb's network_header before it is passed to the underlying
Ethernet device for transmission.

This patch fixes the following issue:

When we use this driver with AF_PACKET sockets, there would be error
messages of:
   protocol 0805 is buggy, dev (Ethernet interface name)
printed in the system "dmesg" log.

This is because skbs passed down to the Ethernet device for transmission
don't have their network_header properly set, and the dev_queue_xmit_nit
function in net/core/dev.c complains about this.

Reason of setting the network_header to this place (at the end of the
Ethernet header, and at the beginning of the Ethernet payload):

Because when this driver receives an skb from the Ethernet device, the
network_header is also set at this place.

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index cc297ea9c6ec..e61616b0b91c 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -210,6 +210,8 @@ static void lapbeth_data_transmit(struct net_device *ndev, struct sk_buff *skb)
 
 	skb->dev = dev = lapbeth->ethdev;
 
+	skb_reset_network_header(skb);
+
 	dev_hard_header(skb, dev, ETH_P_DEC, bcast_addr, NULL, 0);
 
 	dev_queue_xmit(skb);
-- 
2.25.1

