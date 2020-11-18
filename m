Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357562B882B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgKRXJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgKRXJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:09:34 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CECDC0613D4;
        Wed, 18 Nov 2020 15:09:51 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id j19so2411168pgg.5;
        Wed, 18 Nov 2020 15:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BFitlouLqV5WjAV4yis+SNy1ksEBkbSXVdeVWFMxCgQ=;
        b=rEThL2sa7EQ5kIQx32rvLbR/kFdz1zobSEUYn4oWYiSZ4fA73aYTdSOu4tSDHYJoMm
         T600ICRuLEf/w3lxxqIF8O2/k2boZvhWmlWC8MX+OBnC/RnG8giTFafP7Q+YW95HAbqV
         Zh+cqbqUeMs9FLz1SCwfZ4jD7b8lcgyEUlUgelSgw0eBLuSLueMKtyoE7G/YpKRS4p/y
         tB11JM1yp8XTNVQsAkHU/bDEB40dw6FVx2yrsvm+KlQcVnEEr2pBhz6MbkycbDgakMmb
         1jRj1sawhQ1dr3AWU9pmAdj7W9EmlaN+HWUnWEr7nC2hAOAjAYabbl9r5HrGC59WJztp
         wUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BFitlouLqV5WjAV4yis+SNy1ksEBkbSXVdeVWFMxCgQ=;
        b=q2XgbAfBA9tG3stRvp+QNkm6w0MCsQcW5yAjtUUk3qnmz/Wic4VbSgWeThF80Xx/ER
         WTA+2oFI2S1Rpqi7M1FWMCqVA7ZGG32jiGt4uk5VdK3/VwuXDayGlz3/PuhC1SKRCuIa
         w7gBOUiJsYaG+ThUR4Owzif4BePLZFrSzMBc0Fuh+hPkyP+qsbY4x4IHcZJvDSSgDvIh
         G9tUOpq+QgPKGdV95xjT7ljnNPJ3psrHmcfFrVTjkrZWjFk+08o8AYAkMzly6RxnB2Jc
         Q4RgHTkbagfdLOSN65nFqiw1Mcq5MVeOfN0zpUabW/+FPP5WX8URt7gMR09yXt2uUndV
         S1Fg==
X-Gm-Message-State: AOAM533gXXmGotRQGRffxn7r6sfHhHnfCRLx408u/nybho7uoeTyiWRx
        8zTPYcyOr8irSkTaWqpUwWCpCr/yEyAWq6tP
X-Google-Smtp-Source: ABdhPJzuBMVJyfNRuwEIiXq+MUjq865yCE7VpOiJ98dctqAKDL1P+66d8xBL1pFHeAegwr/cCe+HPw==
X-Received: by 2002:a63:4513:: with SMTP id s19mr10194192pga.254.1605740990817;
        Wed, 18 Nov 2020 15:09:50 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id b21sm2565304pji.24.2020.11.18.15.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 15:09:50 -0800 (PST)
From:   rentao.bupt@gmail.com
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH v2 0/2] hwmon: (max127) Add Maxim MAX127 hardware monitoring
Date:   Wed, 18 Nov 2020 15:09:27 -0800
Message-Id: <20201118230929.18147-1-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

The patch series adds hardware monitoring driver for the Maxim MAX127
chip.

Patch #1 adds the max127 hardware monitoring driver, and patch #2 adds
documentation for the driver.

Tao Ren (2):
  hwmon: (max127) Add Maxim MAX127 hardware monitoring driver
  docs: hwmon: Document max127 driver

 Documentation/hwmon/index.rst  |   1 +
 Documentation/hwmon/max127.rst |  45 +++++
 drivers/hwmon/Kconfig          |   9 +
 drivers/hwmon/Makefile         |   1 +
 drivers/hwmon/max127.c         | 346 +++++++++++++++++++++++++++++++++
 5 files changed, 402 insertions(+)
 create mode 100644 Documentation/hwmon/max127.rst
 create mode 100644 drivers/hwmon/max127.c

-- 
2.17.1

