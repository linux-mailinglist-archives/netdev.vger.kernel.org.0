Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC04D826
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 20:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfFTSIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 14:08:35 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34854 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbfFTSId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 14:08:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so1714179plo.2;
        Thu, 20 Jun 2019 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m48O7FRi8r+gWyNb3X9q+djqhmJvKoGCXjsAReJFTG8=;
        b=oOdnCN4kibi8UdpRROgkAuatPNdLADRR5vMRpA6WbXvPjlpFyAcbAvd+0xqxUgV0h4
         SPHGlofI0JU1zboGi/T4cSFHDikLE4dLIa+UrDbLWwGfBNsXb0EIBv3OXMhrHideSCX8
         Kb/QgY2rEsAhiBZ36H5UvnIllETIYM2WsQ6jjCfaq24hyHxENTBazYfnFpMVCOdIMGTd
         O6siub7W7CNaF82pTIdXx19jyJQuKAIwIIOiXiKYK9G6ZN1WO5ZbTl5XEoYVRDtKBFqH
         BGtOYJDCygj5v/Z6yrMKy2PPJ5KhcAaQSYwIuSsEKZZRbTn1JMWpLHCSCJVjA7iczOQe
         AcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m48O7FRi8r+gWyNb3X9q+djqhmJvKoGCXjsAReJFTG8=;
        b=m7MoS/svtJEZO0SM70Ig6QTVW/3udszz9J7XmKHyD2FHlz5E5rKIkT0fRtViyTyDx3
         CUNrXFQVsTFGTd4DDOivw4fldX8ObRYh9hFNAMM3u/nhNkZqdFAXhO/rvzvVpnOxlTML
         wGLfsKXYfcB5RFmHuu/9t/ADPPffV49k3vbeFTqRiKlxtPy9vMDwsOrOu4uL4ovinQyd
         ETtpspNezdI6iqRGYFw+2nhCaCkfoIGbGNrY2ZUANxLrMjF40LW2IGrx81/A3WZq3e3r
         2O/rmKEEfepUlu2aSoKdiCdf333EbYiZuU2bwKWg78fPLblAbwb0shynaczRbzKp4HZR
         A+CA==
X-Gm-Message-State: APjAAAUhpVIKdYKVCKaPIepvxqs3sBWsusRPw4HJcY/RI/8xk5vDOCsL
        DLImU6ts/4QZboIjlK5MLNA=
X-Google-Smtp-Source: APXvYqyqnqQIhs6j31ORV6H+CICacUP1ugT9/edQHjN+VwobCmftwnkoxQ+fW2POJwSWWxlAl1DhFQ==
X-Received: by 2002:a17:902:7883:: with SMTP id q3mr124656755pll.89.1561054112215;
        Thu, 20 Jun 2019 11:08:32 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id 85sm289016pgb.52.2019.06.20.11.08.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 11:08:31 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 0/3] net: fddi: skfp: Use PCI generic definitions instead of private duplicates
Date:   Thu, 20 Jun 2019 23:37:51 +0530
Message-Id: <20190620180754.15413-1-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series removes the private duplicates of PCI definitions in
favour of generic definitions defined in pci_regs.h.

This driver only uses one of the generic PCI definitons, i.e.
PCI_REVISION_ID, which is included from pci_regs.h and its private
version is removed from skfbi.h with all other private defines.

The skfbi.h defines PCI_REV_ID which is renamed to PCI_REVISION_ID in
drvfbi.c to make it compatible with the generic define in pci_regs.h.

Puranjay Mohan (3):
  net: fddi: skfp: Rename PCI_REV_ID to PCI_REVISION_ID
  net: fddi: skfp: Include generic PCI definitions
  net: fddi: skfp: Remove unused private PCI definitions

 drivers/net/fddi/skfp/drvfbi.c  |   4 +-
 drivers/net/fddi/skfp/h/skfbi.h | 207 +-------------------------------
 2 files changed, 3 insertions(+), 208 deletions(-)

-- 
2.21.0

