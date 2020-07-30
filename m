Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9112232C06
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgG3GoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3GoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 02:44:14 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D34C061794;
        Wed, 29 Jul 2020 23:44:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id r4so2602681pls.2;
        Wed, 29 Jul 2020 23:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T0Z6YHYdP/kQD0cMS+cNQldOhqY6T8q1pjXPvT/YgO4=;
        b=OiRstPhmDEM9j1YxieKFDsmisl0va0TTs8SAgeCbQrA9AWLamk4R9MGSsK4v6bndhB
         RLewfarih1eCgV3Iputcsb8Fikf0Ts4i1DzVjx+N38MZOsWuNZkJbnGWYYRBMLzi/QnS
         gWLNvJwgGfa9pyvyYFGPfrF6suBPHMvAA8Pp+dAgRwz7pEIvIVwPBboizcmAW1ewhGnw
         oyNfRbmQAbZmpzaktT4Tx0ON8SY7SRP9rtF+afdlUt1d0G0UQIhpYsUI4FmTbgULbQSr
         QN5TpBwhN21MUhS84sWBvKcg/78IQrktg/pOpWQICx27YFOfDNq88Ez46QtYgrlndHW+
         F7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T0Z6YHYdP/kQD0cMS+cNQldOhqY6T8q1pjXPvT/YgO4=;
        b=OGsm1z4+TV9Q8RRpg5P7iD33t/H5RuY0O0rUS7C2hEhTSpPcIh55zUddfTo5KT815d
         vGPgqj8jx1aIDu3sqJWeuCSOGqqv2/SOrWow6QUny7DCKyNylqOdpcrpXvz3LDQhxiXq
         GWAYjtZUnBmDhOOzCnMZRElW/N/pfyjxgEb994BY+ToZT5JXk8WmXnLOqDMfQda39yma
         MOgtFX0LqsAplXN79L85Kk9MgT2DdfzwNA7hLS8YXtuejqRdd2rr7te0xUHlMl3f6SMg
         vf0y60lFwljAZ7j511x6MsMU8VVEpnRys/3mXbL+jtdh10IEznsGQt5U/wnjf/zYv9Oj
         trYA==
X-Gm-Message-State: AOAM531IOL5hEDWG+nTcuzRom//OFe3n5ZtEAqSW68mcK1mJfdndtZ9o
        tk6nynk7x+gck8pfz7G5Xd0=
X-Google-Smtp-Source: ABdhPJw9O6djxb55ZNdBVxjrgHGcCupOaAemxFpYzSxNl58AoVv0WDFvfO70K4EdqKqtCV1QzKsN3w==
X-Received: by 2002:a17:902:c405:: with SMTP id k5mr30039309plk.202.1596091453251;
        Wed, 29 Jul 2020 23:44:13 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id t19sm4456942pgg.19.2020.07.29.23.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 23:44:12 -0700 (PDT)
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
Date:   Thu, 30 Jul 2020 12:12:26 +0530
Message-Id: <20200730064229.174933-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200730051733.113652-1-vaibhavgupta40@gmail.com>
References: <20200730051733.113652-1-vaibhavgupta40@gmail.com>
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

