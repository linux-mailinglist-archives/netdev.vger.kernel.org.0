Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FAC231C61
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgG2J7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgG2J7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:59:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D061CC061794;
        Wed, 29 Jul 2020 02:59:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a9so1647357pjd.3;
        Wed, 29 Jul 2020 02:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T0Z6YHYdP/kQD0cMS+cNQldOhqY6T8q1pjXPvT/YgO4=;
        b=rb8/dupyCMFbBH4YZJuE/RPbByMpGQ5LAydsXv+QjPXvhSZxULUuuRV8XlGBj1j99K
         XFszBCZ2K4ch/ddu2OZLiYmUBUeRhRcbu8a3Yu8TAZA5bE2F4mG5ltCYhNeoIFUJ61ru
         dbWRev/5xq+8WUIhLulvMFFuSBNToV5Vr8YCCTuPFgOHfGo0l95lBrQH2s6enGdm98ab
         YadDobj5jWlZYvQI61D7RjMi1YuDBExT4iDSKpotJY0g8mdjfoffFRt437s530RMwJx9
         8Y+G0QWfDnEINXow8ElKpN8xnB5aVnJhiz6hciPST9mC0ScqccExXerDwCKuLEIQd1Wi
         BzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T0Z6YHYdP/kQD0cMS+cNQldOhqY6T8q1pjXPvT/YgO4=;
        b=eygxYyQgE0rASdBxf8KnqlqVstsmp/NuXP/HkjRa8zEUH2NCB0P3zorEdtFDzOZBVw
         +RKfOCz9SsGgKil5foI9Qgv812lXlU7pYSYBnZQVTTxPtQgBVN2QrLjIYpH1Pb+I50yT
         sEPMHONAa2iMIRZNvCQAK44rGZLKY2vkGoCAwhl/jYEl9BtSIz1ZtHkzZgGoCKCq2snx
         SNL3S+B9cSA98J1Opcfjfc5jFWnQHFU9LZKTPZBLYG6HBYw/az2KSy1EtuN/1+FcmFj6
         rjIEfMT9d/AyGzAGN+2UVhypMh5o76WSeerE5ypRCdENeE5DbR9Sdj+sxkZoRQIRJZFN
         Rv1w==
X-Gm-Message-State: AOAM533zwv7L9L+s2kb9GuacWAAeATXqd3NSgOoURYfrQ4vMfZRaL4kd
        8ZT60Jw7vkFc+0STQmDDslc=
X-Google-Smtp-Source: ABdhPJwlUgeMIQUydEFbTDZ99rxEoaivKlj3ebAXEwUBoUc6lmxEGQaE2R4Y9pOgdMTLv9N/en648Q==
X-Received: by 2002:a17:902:7b92:: with SMTP id w18mr27533925pll.258.1596016773345;
        Wed, 29 Jul 2020 02:59:33 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id i128sm1815776pfe.74.2020.07.29.02.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 02:59:32 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniele Venzano <venza@brownhat.org>,
        Samuel Chessman <chessman@tux.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1 0/3] net: ethernet: use generic power management
Date:   Wed, 29 Jul 2020 15:26:57 +0530
Message-Id: <20200729095700.193150-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to upgrade power management in net ethernet
drivers. This has been done by upgrading .suspend() and .resume() callbacks.

The upgrade makes sure that the involvement of PCI Core does not change the
order of operations executed in a driver. Thus, does not change its behavior.

In general, drivers with legacy PM, .suspend() and .resume() make use of PCI
helper functions like pci_enable/disable_device_mem(), pci_set_power_state(),
pci_save/restore_state(), pci_enable/disable_device(), etc. to complete
their job.

The conversion requires the removal of those function calls, change the
callbacks' definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Test tools:
    - Compiler: gcc (GCC) 10.1.0
    - allmodconfig build: make -j$(nproc) W=1 all

Vaibhav Gupta (3):
  sc92031: use generic power management
  sis900: use generic power management
  tlan: use generic power management

 drivers/net/ethernet/silan/sc92031.c | 26 ++++++++---------------
 drivers/net/ethernet/sis/sis900.c    | 23 +++++++--------------
 drivers/net/ethernet/ti/tlan.c       | 31 ++++++----------------------
 3 files changed, 22 insertions(+), 58 deletions(-)

-- 
2.27.0

