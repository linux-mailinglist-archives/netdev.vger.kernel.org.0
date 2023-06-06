Return-Path: <netdev+bounces-8451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDB5724225
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF8711C20F0D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C822D258;
	Tue,  6 Jun 2023 12:31:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871802D255
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:31:28 +0000 (UTC)
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F3110C3
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:31:27 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-543c692db30so1552664a12.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 05:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686054686; x=1688646686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tnSMPv17DxTIc0EApfFv62sMiPCzQPBGurL8DNcMIjg=;
        b=ED5wHJmn8ZLA4iS49IErYUL2x+RV79G+ND9qTHeNJbgfhZx7HbbumKO2Om+e9nia4V
         yLaa3ju2IQyNwjbRagoYWRS8/l4YVdjaaw6ihstAhHGdELxqy6r+TLRL2ywnhZciz3KV
         GnAEUMWUEEL21U3AJweaap5Ejp07h7T8TlbdcFl6CRQX7Wm+mscilpdpQLlPOBqMlPo2
         MriRTlfdFH7X8ZHh1SrhCrNNIG5XlOO7DgaBK4BKLkHnI6MIfD5pNEhzYAvNO3ANhGE6
         DtvXj5S0QGMn1naH/1ZH9yW9pz5Ug+gFXZ/hzfvymwHBZWUwoCGvIUxnaDAe+7MtLYqL
         JSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686054686; x=1688646686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tnSMPv17DxTIc0EApfFv62sMiPCzQPBGurL8DNcMIjg=;
        b=hsP1vkwEJVH2ODnrq0+SQ8u4j+/jKTUdlysOjAvMMYGyuM98RbJ0JPMtoy/JLmduMa
         AMhp8R3lSApcHh0oVVbyiU5VP9YQC/ciMWAwEwoq/1HJXLXNtGdtF4YVvFv6wLaE6RYH
         +aarhSUhbqp6alSXuA2n/kOoXgqym8aEZffqvvo4wyVMdJ0uZ0qqbLeWU7cekzMi0xRG
         P3UZ25+hff0J4ycNTkeWFQE07hFtrzYFTXEIRtvtdtTM0OcUPZD4qEFCTcWGq/0WkECt
         DJHf0lQ/+jxxqSAb5a4seRMJCZmQP4LaHVAzmlBIrmfPkp4ywfhieqvvsp1JD2n7L0hZ
         VXrA==
X-Gm-Message-State: AC+VfDx26/7wpz2I+SBYukshJDLo5/XJWek/jeK5ZVMyqM+tJxzEAXEG
	F3AeN/H4eh20ICR9OENxxH+H8ph+dE1ns/vjvQ==
X-Google-Smtp-Source: ACHHUZ5LRdxhkL8Kk+RGl8CqeDCwiNOHqL0Cxwey/pXI4lj1u2B/gUi3CJwfcNE/jc4Z0yeasnVUKw==
X-Received: by 2002:a17:903:22c3:b0:1b0:3df1:c293 with SMTP id y3-20020a17090322c300b001b03df1c293mr2206016plg.45.1686054686649;
        Tue, 06 Jun 2023 05:31:26 -0700 (PDT)
Received: from localhost.localdomain ([117.202.186.178])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902c74500b001ae59169f05sm8446431plq.182.2023.06.06.05.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 05:31:26 -0700 (PDT)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loic.poulain@linaro.org,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 0/3] Add MHI Endpoint network driver
Date: Tue,  6 Jun 2023 18:01:16 +0530
Message-Id: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This series adds a network driver for the Modem Host Interface (MHI) endpoint
devices that provides network interfaces to the PCIe based Qualcomm endpoint
devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
devices to establish IP communication with the host machines (x86, ARM64) over
MHI bus.

On the host side, the existing mhi_net driver provides the network connectivity
to the host.

- Mani

Manivannan Sadhasivam (3):
  net: Add MHI Endpoint network driver
  MAINTAINERS: Add entry for MHI networking drivers under MHI bus
  net: mhi: Increase the default MTU from 16K to 32K

 MAINTAINERS              |   1 +
 drivers/net/Kconfig      |   9 ++
 drivers/net/Makefile     |   1 +
 drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
 drivers/net/mhi_net.c    |   2 +-
 5 files changed, 343 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/mhi_ep_net.c


base-commit: ae91f7e436f8b631c47e244b892ecac62a4d9430
-- 
2.25.1


