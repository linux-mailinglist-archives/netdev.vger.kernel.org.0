Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0171C8B66
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgEGMxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726635AbgEGMxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 08:53:23 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA57DC05BD0A
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 05:53:22 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x10so2026256plr.4
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 05:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=j58IuaF2tOM1RurkMuTpHXCNmLk7/z8BIzusf87nmw4=;
        b=WYriJ/WWVBwoNsFK5/ANzj6Ty0H+3E3lGWT8zVA9rluurZstZS56Zs58ETZiotxhVA
         yOIBJIbL6WOXuibdiwn0uQoRV3J5st8K3cqT4mz47gWoruylRY6dKdoecfOLk0nhukF/
         Exv63QxZcRR6xd1jQz7CJxp4igEnG0MfQZ25E+KzZEleDAd38frGImj1UTFNfgcT8fBI
         hte6Ksw6ncnoKM+YPwepcT2OzKgVXXUuBKAs5hlnRn72y2Jj9j6LR7X7zMFl86+nso3h
         PL4HMpulQK/vmI+um2cCVD/ttQqY0RysgeB0dOXqKuRJoko6N2MRzzwfbJOMp7OZb30v
         I/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j58IuaF2tOM1RurkMuTpHXCNmLk7/z8BIzusf87nmw4=;
        b=c9YgGj+9ogn9udTIzYlMttlmP9fifDVHhzXj9Llug23Qj9oEJkwC1tX6iamhcTDyYM
         vWxPJxwjR/GKG/ssd94gbywkq62QYIHZK2cTEFGyA66Wr1TlO24S7fgTNzrDr7EJzk7B
         fq2ZdEG68Q34jHJDmmrkNmh/PyM5wrQGZZ8tfN1M71+POCfaojXjyKkPCe9iCuAPk8ST
         KrJHlBM/PVpBLMSJL9dEs9fvA9cLfFB1PNt62HRJyTYKwpjQVIRVml2FpkQwFJboL2kK
         XB2OJ/E0d03xaQalWhEAgcM1jSH3te/rgfW8LVhXhlG6LriADKYixJlG/0M54zJNGuzU
         VyUQ==
X-Gm-Message-State: AGi0PuZylIFyXmsxqOFgusdkZf+iGzcy8LQYoFURvS0RI1LIsQEi+/hG
        3yCmJ/5E+FZV9Vnx1lMDXUt2
X-Google-Smtp-Source: APiQypJArY4q500dTsUg0P6yfcpn1Ija5V/q7fY81/0xeevRZVxUK1tNC640Mq6PqRWDx9w/R8BMiw==
X-Received: by 2002:a17:902:7208:: with SMTP id ba8mr2699331plb.246.1588856002132;
        Thu, 07 May 2020 05:53:22 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:6093:7a3f:4ddc:efce:d298:c431])
        by smtp.gmail.com with ESMTPSA id q21sm4926190pfg.131.2020.05.07.05.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 05:53:21 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net
Cc:     kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clew@codeaurora.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 0/2] Add QRTR MHI client driver
Date:   Thu,  7 May 2020 18:23:04 +0530
Message-Id: <20200507125306.32157-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here is the series adding MHI client driver support to Qualcomm IPC router
protocol. MHI is a newly added bus to kernel which is used to communicate to
external modems over a physical interface like PCI-E. This driver is used to
transfer the QMI messages between the host processor and external modems over
the "IPCR" channel.

For QRTR, this driver is just another driver acting as a transport layer like
SMD.

Currently this driver is needed to control the QCA6390 WLAN device from ath11k.
The ath11k MHI controller driver will take care of booting up QCA6390 and
bringing it to operating state. Later, this driver will be used to transfer QMI
messages over the MHI-IPCR channel.

The second patch of this series removes the ARCH_QCOM dependency for QRTR. This
is needed because the QRTR driver will be used with x86 machines as well to talk
to devices like QCA6390.

Thanks,
Mani

Changes in v2:

* Added cover letter
* Removed casting of void pointer.

Manivannan Sadhasivam (2):
  net: qrtr: Add MHI transport layer
  net: qrtr: Do not depend on ARCH_QCOM

 net/qrtr/Kconfig  |   8 ++-
 net/qrtr/Makefile |   2 +
 net/qrtr/mhi.c    | 127 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 net/qrtr/mhi.c

-- 
2.17.1

