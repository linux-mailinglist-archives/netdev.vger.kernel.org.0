Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F224EB9D
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFUPOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:14:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32793 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfFUPOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:14:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id x15so3780090pfq.0;
        Fri, 21 Jun 2019 08:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1L+5OgsoCs/Y5oa5UVHHnNtdt7om2AYqhwfcRpZ5cw=;
        b=gH08pGvtNsQ+WQcRdl6g0glrNBW2WH4cfDf3/RJtRPKt0u2ujl3NLToFiq7QuUd0mQ
         +lNYvRSrCDz1YsxH7bhjMKeotLSmgnfH7YwsDE7wAIunMTk8Zvj50MiGX/vFuriJKk2U
         AOP7806mzxJl+G7rZkOg66yygnYbLLRxmHKhB0HxJlJYteGGb0FIy/DzTf4pk9yH95bA
         7IcU7n7uIx8p7zbOgKpnQhX8FLzs38W6UzAEZ92ybuaF34ySQ88fGjdEO+ccoRtSA/CC
         TP0wIz0wwH94V4JVyudpbjm/p9LMWcfP3HGKzNZrgjsCG1zGuPi8eqX6TcwKB8OVlOl5
         E9tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1L+5OgsoCs/Y5oa5UVHHnNtdt7om2AYqhwfcRpZ5cw=;
        b=RUPHYSXBCAR410kn6HzXBQ7a8QBFgkO/qLwALGShVO6eDkDz1O4u9mI30wNLNw4kew
         Vnf65vEG8QhD8iVY6eNgzxS71X1fTjTtBjppEV84X1XlmhTGi62/wp0CbWr+l9s5RRFe
         deBMgq5cSkSvx/5AGGlR6vuCHJOLaRG7RalvTKKEXlx6zn+7aGziI6ctajkSKBzsaVbO
         fdzbrO9+I5ihus7bwJq836JxJRPiEdxnuClX7+uYhwAd/1vHT328+x47Aap9+TdZyayO
         vsHtDycUIZ5yNnpHBzeT90lSuTqhrQP7wv0jN+BHGW+DmdY0kdBoeBZee9ptwxryl5Dm
         fVDw==
X-Gm-Message-State: APjAAAVF3S8Akh4RWDh8jqZ0F7nYgeG+ldnH0q1D6vTFTEaxcNyCojeg
        myyjL9k1AECIILkhU93Kdis=
X-Google-Smtp-Source: APXvYqx+GcHnmwXxnOFv2807/Y9KuYoypP+swKOyCcZEjg1XrPM9jhbRCTujayUWU2SN003YufEL7Q==
X-Received: by 2002:a65:56cc:: with SMTP id w12mr5892499pgs.382.1561130074417;
        Fri, 21 Jun 2019 08:14:34 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id 25sm3254465pfp.76.2019.06.21.08.14.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 08:14:33 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 0/3] net: fddi: skfp: Use PCI generic definitions instead of private duplicates
Date:   Fri, 21 Jun 2019 20:44:12 +0530
Message-Id: <20190621151415.10795-1-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series removes the private duplicates of PCI definitions in
favour of generic definitions defined in pci_regs.h.

This driver only uses some of the generic PCI definitons,
which are included from pci_regs.h and thier private versions
are removed from skfbi.h with all other private defines.

The skfbi.h defines PCI_REV_ID and other private defines with different
names, these are renamed to Generic PCI names to make them
compatible with defines in pci_regs.h.

All unused defines are removed from skfbi.h.

Changes in v4:
Removed unused PCI definitions which were left in v3

Changes in v3:
Renamed all local PCI definitions to Generic names.
Corrected coding style mistakes.

Changes in v2:
Converted individual patches to a series.
Made sure that individual patches build correctly

Puranjay Mohan (3):
  net: fddi: skfp: Rename local PCI defines to match generic PCI defines
  net: fddi: skfp: Include generic PCI definitions
  net: fddi: skfp: Remove unused private PCI definitions

 drivers/net/fddi/skfp/drvfbi.c  |   3 +-
 drivers/net/fddi/skfp/h/skfbi.h | 217 +-------------------------------
 2 files changed, 6 insertions(+), 214 deletions(-)

-- 
2.21.0

