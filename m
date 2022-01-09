Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD64A488C71
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbiAIVHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiAIVHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:07:17 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219FFC061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:07:17 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id x6so37467615lfa.5
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 13:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=esg4bn7G0jMIkn6seqDEuQvZNEfKaqIXGyIwMWcVDh0=;
        b=B1de/dpBwPvfubE+v3OaTkKnDg55HGFm13nmRzKKZ4yE9ozwtfZOAkNGm4dzpB5j9c
         1DCpFubLzTK+G20mk26Z2odim8dMS2HWjpzQ6pmPUV5mGeuwgYPhIC+jN7YCykPe36UF
         qIJNSMdz7AhP8MVNWPr0qK6JvWnA7kWUROWTwl5SHoBHabURvVNETBRTXTiBgwKki1cV
         LqBsjPMxkFHhySkGCw6nvq48vLOnqkJLxThjAW1EtNbp5za3Hwh9t3LZFE3lSuxzzHjZ
         7z1wNYfglyK3+bsSgHVPtTHHkTNliWt60z3dXX1S+8AFLUlpjfRJOqU5v9kS21Cqmwxn
         peTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=esg4bn7G0jMIkn6seqDEuQvZNEfKaqIXGyIwMWcVDh0=;
        b=GPhEwzfnzgbCGnIOeRfC55eapRg/1krAw5p8OYE4CuXtgSWNQjl3ywfxZlXSxcKCN0
         kbL5e8mM1JuwfsLltQeYk6cJJN7ZzCvQWF55ZTkJpFV3T2Vm1dGgwAPM5c97CbHwnfpw
         2GzYay/DHJ3UfVFdStidIX0FzskQmt/rfplFWzNS+lkkKKKvfOzijnruwSzVIkQuO/sl
         /8jEN58hgI7QG5KbNv45LRPdESkTAtpf3Rx3718aFkW5N5kTAPSwonZYGLyAYNaXat8D
         sy5FihJ0SEYrAo+bufaLZXpW3gpJCsFpdiW4xkiNcYMxKC6lV3pV0w0pET/82qpTd4Xk
         OcTA==
X-Gm-Message-State: AOAM531xwW+ANQEZ2rr0+p1cjQVNvGHInvk4gHETxMA9ih5c4mJLaxg+
        kwZoQ4ojfNhzZaQljN0tzY/P0M61C9v4XRWm
X-Google-Smtp-Source: ABdhPJxH3Js0nW5RBZ54Ll58iBo6WDg8zPSOgnp1ipujtGCBK7qTeTiBQQjXzcujKxks1yxE5fCT/w==
X-Received: by 2002:a2e:b907:: with SMTP id b7mr46119133ljb.167.1641762435212;
        Sun, 09 Jan 2022 13:07:15 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id p17sm766129lfu.233.2022.01.09.13.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 13:07:14 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH 0/4] RSS support for VirtioNet.
Date:   Sun,  9 Jan 2022 23:06:55 +0200
Message-Id: <20220109210659.2866740-1-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Virtio-net supports "hardware" RSS with toeplitz key.
Also, it allows receiving calculated hash in vheader
that may be used with RPS.
Added ethtools callbacks to manipulate RSS.

Technically hash calculation may be set only for
SRC+DST and SRC+DST+PORTSRC+PORTDST hashflows.
The completely disabling hash calculation for TCP or UDP
would disable hash calculation for IP.

RSS/RXHASH is disabled by default.

Changes since rfc:
* code refactored
* patches reformatted
* added feature validation

Andrew Melnychenko (4):
  drivers/net/virtio_net: Fixed padded vheader to use v1 with hash.
  drivers/net/virtio_net: Added basic RSS support.
  drivers/net/virtio_net: Added RSS hash report.
  drivers/net/virtio_net: Added RSS hash report control.

 drivers/net/virtio_net.c | 404 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 390 insertions(+), 14 deletions(-)

-- 
2.34.1

