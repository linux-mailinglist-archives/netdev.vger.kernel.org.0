Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD94C2436C1
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 10:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgHMImE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 04:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgHMImD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 04:42:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12280C061383
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 01:42:02 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u10so2323952plr.7
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 01:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UbdKBrdotq83jU1QMt2IgDl1E5bjqx/qouMsGAbK12g=;
        b=OYR7BzflZ0O26S/A/8KyvAlO9i5MxabYg3uJa4lwLP/KO8VpoWe1AGRaLgoCvgILZ5
         p9+GoT6fxqwL+icHSjdQqdh2Fskcy629eO6zofQY/xX+VYwCo5TgfzB8Fop7L3jCxNb5
         +OM9N8p9615NU0FnPwJPjVhkN7i2zeP39mdaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UbdKBrdotq83jU1QMt2IgDl1E5bjqx/qouMsGAbK12g=;
        b=YRNDB5vC8w4Z20AYB/iZ9a4E64zvXq5ad8DeCTzBPgdpzuyiIj3Ji6SZvd+EuOwu4/
         UguAzjiRtN0/SlrLwUwiM1JgkbuZjF6rQDmkGm/A5hE847WMUW9Mqc7j4KOiZex+1ciH
         5Xfpo8UVQp4s6tNwDWPRQDbljQMThSkIveztOBaujFxFFpRX8KnqWujdBQaXuTWUCEHj
         3Va0tdo1sMhUmvFFTJSSiSIxeomKPOXyYxphIYcSMKe5mlb+MchSpMHGIzSrZUFl51P2
         yeIRmTuf/3TDCk3KqtMr+/u6UZjSg81GH7+keKVZwI8OIsQ7yK5SqdMKZ16Fcv2tmZV3
         m60g==
X-Gm-Message-State: AOAM533S/YfykNW8OdzCnTMN8r0L5NxvD4oDXwCnYhli/MXGFtuKRJ1G
        csYS0lTxXM6Vttqtz7vLyTONXg==
X-Google-Smtp-Source: ABdhPJz6TJ9Uw4cwCnhTlFM6qfZ5wovRm/Htuj/dUG3SzboFS8rc3aZmT9tP3vIGXe59SYYi15vlSQ==
X-Received: by 2002:a17:902:8a85:: with SMTP id p5mr2996916plo.193.1597308122498;
        Thu, 13 Aug 2020 01:42:02 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:de4a:3eff:fe7d:ff5f])
        by smtp.gmail.com with ESMTPSA id y29sm5032035pfr.11.2020.08.13.01.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 01:42:01 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     josephsih@google.com, chromeos-bluetooth-upstreaming@chromium.org,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 0/2] To support the HFP WBS, a chip vendor may choose a particular
Date:   Thu, 13 Aug 2020 16:41:27 +0800
Message-Id: <20200813084129.332730-1-josephsih@chromium.org>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB alternate seeting of which the packet size is distinct.
The patches are to expose the packet size to user space so that
the user space does not need to hard code those values.

We have verified this patch on Chromebooks which use
- Realtek 8822CE controller with USB alt setting 1
- Intel controller with USB alt setting 6
Our user space audio server, cras, can get the correct
packet length from the socket option.


Joseph Hwang (2):
  Bluetooth: btusb: define HCI packet sizes of USB Alts
  Bluetooth: sco: expose WBS packet length in socket option

 drivers/bluetooth/btusb.c         | 43 +++++++++++++++++++++++--------
 include/net/bluetooth/bluetooth.h |  2 ++
 include/net/bluetooth/hci_core.h  |  1 +
 net/bluetooth/sco.c               |  8 ++++++
 4 files changed, 43 insertions(+), 11 deletions(-)

-- 
2.28.0.236.gb10cc79966-goog

