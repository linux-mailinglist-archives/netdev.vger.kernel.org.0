Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D942035FA
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgFVLoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgFVLoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:44:04 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2059BC061794;
        Mon, 22 Jun 2020 04:44:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q22so5181821pgk.2;
        Mon, 22 Jun 2020 04:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZPn01r6wkXnMIHGh/thIPTlSxs28rdWp4NIXuzwx0oQ=;
        b=FTA7ISWLI4A9wg3ouOgx4YNdJh6le0da9LW3IxYp8AUgvV84ghq39qDPNlErkkjgkS
         6n7yR++UXq0RhCO0bGYxDcWQroLp4MJjinLXikt6ktxSaHE/xdx5pw/9+UsYUCPzzmFX
         T6OMMHt1MG63b9lVgOhZOhTtk32Q5L9/wy1Exz6sY/Qyatk2ZF19UdaVS/buFpsSwc7k
         aXe2ikHii5w35iVohD4NaSMTeNPAlrs8BVKDEu9exIIN8KCozhA/23oWq/xoD8NMLQ84
         3IeJMkoPknDdeGaM0E04h/LLzw9sYnbt7+O7iONBdNFqdMti8nPM0+NtuJlulUrRX1sM
         vGuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZPn01r6wkXnMIHGh/thIPTlSxs28rdWp4NIXuzwx0oQ=;
        b=amQfkCQm789lwhXUWBjEHLwWxmdl72oNUTVCi9RXgbdhgCiojzOtUjwCeKHKk78D33
         fERu5M9Vy/OILP+4rb11sSq4RvqY5W8mqDdnU/FK7c1P8D7CbbwtvKEy23EEN48BV/QT
         NPTRPXzwsz/Boh26WapaJN3yhzyhgqkbDLxpGgI2tBEtTghmNjq09ni+/bNXgaSNYuNe
         u7K1xpTPUuPp21txK4j9toi3HMxk5zwMUfLFpNsuCDmdEa6kKxitw1wcyd4q2cDzVB90
         rSBS8nQsSdKVhvN2VyaskmeaQLVUmVw/nuN1w2MFEE3way3WjVTxNo9iN1Z8C4x1qEIv
         yJpw==
X-Gm-Message-State: AOAM5328MWziSqhcijB+ZiMf3vDGQieYlgS/q4nzREtNmTV/l0nVYtLx
        uzY0RQGUlinU1Aj3igaHIWg=
X-Google-Smtp-Source: ABdhPJyMdkCLlkB48Di9E70YagohvSIbysJTGd9ixEwryDW489vir8n7x1GTRBGyvbi/fqwswBpNbQ==
X-Received: by 2002:a62:ee08:: with SMTP id e8mr18838245pfi.93.1592826243593;
        Mon, 22 Jun 2020 04:44:03 -0700 (PDT)
Received: from varodek.localdomain ([2401:4900:b8b:123e:d7ae:5602:b3d:9c0])
        by smtp.gmail.com with ESMTPSA id j17sm14081032pjy.22.2020.06.22.04.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:44:02 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/5] ethernet: dec: tulip: use generic power management
Date:   Mon, 22 Jun 2020 17:12:23 +0530
Message-Id: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management
callbacks and invocation of PCI helper functions, from tulip ethernet drivers.

With legacy PM, drivers themselves are responsible for handling the device's
power states. And they do this with the help of PCI helper functions like
pci_enable/disable_device(), pci_set/restore_state(), pci_set_powr_state(), etc.
which is not recommended.

In generic PM, all the required tasks are handled by PCI core and drivers need
to perform device-specific operations only.

All patches are compile-tested only.

Vaibhav Gupta (5):
  tulip: dmfe: use generic power management
  tulip: windbond-840: use generic power management
  tulip: de2104x: use generic power management
  tulip: tulip_core: use generic power management
  tulip: uli526x: use generic power management

 drivers/net/ethernet/dec/tulip/de2104x.c     | 25 +++-------
 drivers/net/ethernet/dec/tulip/dmfe.c        | 49 ++++---------------
 drivers/net/ethernet/dec/tulip/tulip_core.c  | 51 +++++---------------
 drivers/net/ethernet/dec/tulip/uli526x.c     | 48 +++---------------
 drivers/net/ethernet/dec/tulip/winbond-840.c | 26 +++-------
 5 files changed, 45 insertions(+), 154 deletions(-)

-- 
2.27.0

