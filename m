Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA20411E626
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfLMPG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:06:26 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42410 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfLMPGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:06:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so6951009wro.9
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 07:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=BLezIInJ8uihWacc2bBVtj+SQZPMxnvC7DifZIbQJvE=;
        b=li4F/Ar7hR4Q/kwvgVzAkZj81JWDpZPSeYWgtmGLQyGyHmlYgzfrLxgz/NI3gwhVIP
         4QxLbL6h+hoDwWodW3fbNd0y2uUjb9hTRcJcCIohjAbgA1OdKviFMjWl1Pw8Pv/jM7ap
         whMYptpChW7ElPPSE+7vFM8lBhSjLPIpZSy7mBVn5Uwd5+hHxT6EZ2KFfqHszGcYgg/b
         /iVxfUY/Vbqgu6nuoevdbgS2oGjzfjAAMtoqJkIHI14kiVVNhNDSwoDyjyWPAaToLzZe
         378GS97d+sLDFXkfHVe9l8Hjs98bGOgUuZlVzdCPTxKUqapIVvqEAJe3o1dGdS6H0NrO
         3rfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BLezIInJ8uihWacc2bBVtj+SQZPMxnvC7DifZIbQJvE=;
        b=VFx9KKutE/RqgAz8gQZ63/Slb71lHU/KXu6RgKFsrM5Hv5iOKCcIstMXD7YcmsIT8A
         4bSRCMX7lypUUU2Qy9GLkAPvzDXX0zGISiFrOvt6CfUWWjUISxMvQ6UIAHCR9VlTJ9og
         OOXg3rwe0QX1oDBWZmRhW6qp0hEf19N2qGoe0DTaqCzzvu1ajsmoD7ISS0otYR1r2clD
         wZk/Si2eIC6rFON6gM2DB3inYmuEHj+7Nt/AFPXH6dlSkqGFnyTtuKPEXX1yMBK6iZ91
         9YTx0ZW7+mOlMSXNdaGTVRSUQ+M1VVWzBx+qioE0B8Gw3uFVzG9Id0t9M/5NmF10nzWN
         zfRA==
X-Gm-Message-State: APjAAAVg1xIaa73t/HA05oqQk6lyEr0l6ObOPx7TYskYxtMSngwXhHfs
        EluL3rXodVtE3E6R4CYMpqcDww==
X-Google-Smtp-Source: APXvYqzg+b2CkdS8n/yj9VSv6f3ya2EGjcaZxBnKs6Cpom4oRUIi7LBjJxlP5jrDHrDNMu6fpKbSYQ==
X-Received: by 2002:adf:f581:: with SMTP id f1mr13743624wro.264.1576249584196;
        Fri, 13 Dec 2019 07:06:24 -0800 (PST)
Received: from localhost.localdomain ([2a01:cb1d:6e7:d500:82a9:347a:43f3:d2ca])
        by smtp.gmail.com with ESMTPSA id x16sm10449403wmk.35.2019.12.13.07.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:06:23 -0800 (PST)
From:   Guillaume La Roque <glaroque@baylibre.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, nsaenzjulienne@suse.de,
        linux-kernel@vger.kernel.org, khilman@baylibre.com
Subject: [PATCH v5 0/2] add support of interrupt for host wakeup from devicetree in BCM HCI driver
Date:   Fri, 13 Dec 2019 16:06:20 +0100
Message-Id: <20191213150622.14162-1-glaroque@baylibre.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add interrupts and interrupt-names properties to set host wakeup IRQ.
actually driver find this IRQ from host-wakeup-gpios propety
but some platforms are not supported gpiod_to_irq function.
so to have possibility to use interrupt mode we need to add interrupts
field in devicetree and support it in driver.

change sinve v4 [1]:
- add patch to update Documentation
- use of_irq_get_byname to be more clear and move call in bcm_of_probe
- update commit message

change since v3:
- move on of_irq instead of platform_get_irq

change since v2:
- fix commit message

change since v1:
- rebase patch

[1] https://lore.kernel.org/linux-bluetooth/20191213105521.4290-1-glaroque@baylibre.com/

Guillaume La Roque (2):
  dt-bindings: net: bluetooth: add interrupts properties
  bluetooth: hci_bcm: enable IRQ capability from devicetree

 Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 4 +++-
 drivers/bluetooth/hci_bcm.c                                  | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.17.1

