Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84097379EBA
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 06:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhEKEo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 00:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhEKEo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 00:44:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ECBC06175F
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:43:21 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l14so18708354wrx.5
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r+fuEWOXQS7I9x8O8/V7V8Fp627y94Agl9rZO/rVwbM=;
        b=qrhFd3cPjwMZqof4JqMgZ2pVJfMjIk58KoCi4X28Jd57Igp9i5b6Kn2iiDX5AU5uxq
         x5gmUtUeHxnwSyf6SNM1m29mrqIA5C6P2oohNmsZYXhOHc0tY+huK8T3ZBdKBn+s+VEN
         OhYCh2+IiYXwzrEka9XcEM7qUomzyxfWJ5aZWugkqvklX/xuJCqMz2seGdy6q5mdMJwD
         LSFjfNpqfnLsis4zBJEiN8mXIuIRT22gtcqdyMBAg2R01OryoOH9GGMBp5UMfkuIgXpS
         Em+u2qNX3oEcjKWNDGAX0N1UYsEt/Ivjlo6lVOnlfhaoKxveTCDy228GdqQdGjHFAvKz
         xGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r+fuEWOXQS7I9x8O8/V7V8Fp627y94Agl9rZO/rVwbM=;
        b=AN0fYciph5t8D6hN1cxGDKNdMvpBN+2wayNpZUAk5+gdlVcw/2lQjzKYrt1xxl4YvB
         GWQYZmdQpH7ABYdObRTACKQRHvXVhbaEY8FIL/e5a8q+Kq+32BvCSvjOjgwlBNfJctxH
         XRPG8oBx4zmmgq91pdwJaFpW5lvfboUpPP24NOSVo5bdClZO4GCqUU5lVxdH7EenLExn
         Pp+EkyqbCBim6jSKoVtTcAwN94XGKVWD83++G97LnioneMmdreEJQzrSzQAMiHmD+ryl
         BvUiRPsdgH4NMoLJJsYot8U0sWxIV0iVcaTpefcjFQzAvxTBQlDKPRjUvepwjh5vfYdw
         lXPw==
X-Gm-Message-State: AOAM530YehA26x57DlSSqN36iqmukxhdg1wr8UjVM24kBabuJZI7ZAfk
        l06Si4NpLpmaO4qtnD1cKquSIw==
X-Google-Smtp-Source: ABdhPJxUhqz1WaZH/FOnhkVGUbpgaA1N+uNYZJE5IYt0YY+EuOaBPMEZo3xsZpY0faKRoNgtCX+xMw==
X-Received: by 2002:a05:6000:144:: with SMTP id r4mr34846567wrx.128.1620708200204;
        Mon, 10 May 2021 21:43:20 -0700 (PDT)
Received: from f1.Home (bzq-79-180-42-161.red.bezeqint.net. [79.180.42.161])
        by smtp.gmail.com with ESMTPSA id a9sm22360520wmj.1.2021.05.10.21.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 21:43:19 -0700 (PDT)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com
Subject: [PATCH 0/4] Add host USO support to TUN device
Date:   Tue, 11 May 2021 07:42:49 +0300
Message-Id: <20210511044253.469034-1-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for UDP segmentation offload feature=0D
in TUN device according to the VIRTIO specification

Yuri Benditovich (4):
  virtio-net: add definitions for host USO feature
  virtio-net: add support of UDP segmentation (USO) on the host
  tun: define feature bit for USO support
  tun: indicate support for USO feature

 drivers/net/tun.c               | 2 +-
 include/linux/virtio_net.h      | 5 +++++
 include/uapi/linux/if_tun.h     | 1 +
 include/uapi/linux/virtio_net.h | 2 ++
 4 files changed, 9 insertions(+), 1 deletion(-)

--=20
2.26.3

