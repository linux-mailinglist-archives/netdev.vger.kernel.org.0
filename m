Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45D7262B80
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgIIJOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgIIJO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 05:14:26 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330F0C061573;
        Wed,  9 Sep 2020 02:14:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k18so1572583wmj.5;
        Wed, 09 Sep 2020 02:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uGe9wXJ3Bd6sgUOcwqPvqoXTxaWG5mofYiPNXsQ6p44=;
        b=Ay8+wIbCiWsJ3UCSJJcnSuJu038TaXpKb+KBuMJWsKFa9oOBSzXdvXWmgcbc5NPWsS
         G3R3z75Fz+SuBzjzrpkFsbtV18oeqM3ggi9yo92b1tCVOuZkjWUVqfJcOqr1f+jgWPg6
         u6g5+3r9xeuU6WoqjevwsCVtzvtPdw7HkupQYKcFfFX4Z11amiIMx6d6umeylKw+HkPZ
         FCWb1pzljY19ZsHQutV/heMGrQt84a2aybaAVo01PRvyaS0gLlY1AgwvgpGGwtsFqGxl
         7PpnXymfFGBxNDxkBbNO8hn5TNgSOtk4tunG2KhPz4hsfzTTlxbfH5g5mc9ZIs6agAzV
         OUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uGe9wXJ3Bd6sgUOcwqPvqoXTxaWG5mofYiPNXsQ6p44=;
        b=ZzIGQzYDHENfBTe7YIb9prTRQ7Mfgqesu082YwRfJlWlksSX4EXbxZoDX2Wyz+Oj0b
         UCgO5RjBnHcRTkb2zL2WXAXrzJvp+qkSDFeyAMFm3XvIJHtkxE5QkZLt02d9qeE5Ix7t
         W0dm7yGY+35mAbCaI4NWxcbVwWZFvm0NHEfjk6mts7JrKTbw9CLMjhBohO+JuPGR3OgH
         Vu+jxKapt3g1xjkK0bpN8kQ7BNbZ6da7XT75uUvATWYPN8crp+YJ12P0wf3W5YJYTsTj
         L3Ff0I+Iv0w6YGPa+yshD/b1gGSEPYDSXHMohhOBZYavM7yExEzX2/6rwt0hgeXxd+YS
         wOyw==
X-Gm-Message-State: AOAM532sK2m7Au1iHlyZOTRNcc6HeaDtb4euz394R0hzwbH7snsDfWmY
        krP4PItucY0Ndl/Xqbmy2nc=
X-Google-Smtp-Source: ABdhPJznARw/K0qOtNWyxtB+ajrykx9LRmwii9MsgbCxW4/Gm52PvQfL7YlriejjtH2TxPqNhHH43A==
X-Received: by 2002:a7b:cd8b:: with SMTP id y11mr2608495wmj.172.1599642863733;
        Wed, 09 Sep 2020 02:14:23 -0700 (PDT)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id y5sm3128206wrh.6.2020.09.09.02.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 02:14:23 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        Paul Gildea <paul.gildea@gmail.com>,
        Carl Yin <carl.yin@quectel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
Date:   Wed,  9 Sep 2020 11:13:02 +0200
Message-Id: <20200909091302.20992-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add default rx_urb_size to support QMAP download data aggregation
without needing additional setup steps in userspace.

The value chosen is the current highest one seen in available modems.

The patch has the side-effect of fixing a babble issue in raw-ip mode
reported by multiple users.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
Resending with mailing lists added: sorry for the noise.

Hi Bjørn and all,

this patch tries to address the issue reported in the following threads

https://www.spinics.net/lists/netdev/msg635944.html
https://www.spinics.net/lists/linux-usb/msg198846.html
https://www.spinics.net/lists/linux-usb/msg198025.html

so I'm adding the people involved, maybe you can give it a try to
double check if this is good for you.

On my side, I performed tests with different QC chipsets without
experiencing problems.

Thanks,
Daniele
---
 drivers/net/usb/qmi_wwan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 07c42c0719f5..92d568f982b6 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -815,6 +815,10 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 	dev->net->netdev_ops = &qmi_wwan_netdev_ops;
 	dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
+
+	/* Set rx_urb_size to allow QMAP rx data aggregation */
+	dev->rx_urb_size = 32768;
+
 err:
 	return status;
 }
-- 
2.17.1

