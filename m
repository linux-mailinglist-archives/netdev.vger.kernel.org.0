Return-Path: <netdev+bounces-8912-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 429E972644B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0043280DCC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555F71ACDF;
	Wed,  7 Jun 2023 15:25:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496DA1ACB5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:25:00 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041421FC3
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:24:38 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b24ff03400so3065675ad.3
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686151476; x=1688743476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=skpFX1nvdUsEf5JIjZnFK8alGwuwceGPnoOmzX+YgHU=;
        b=cDpNvxi9FBzqVAGVY796eJbBguJemD7B5gglGpbBlKjzEMrpCL8MLun/S+UbE1FAwg
         0YfaMZK6remIZFPeAF3wh2IOQ1HYY9lv4OCzQVXJoC4iGSrBnn4BWJ8kxrwxGyDJ/u0H
         XQi7nhIzZCeg9BiWQ04ZY3uIg5t9gvyLELfidoRbPA0vWKPeGsjZiSOmaPJkSLtttqJ+
         mJu51mCuAUc/+WOI4r3nFx+nTAMYV9Y5moUC1TEel+fz+7nMm5Zplio2Z57Km3PSjFsg
         clvxdq4YKE92/QvDrPpQWDs4HRZvFrbJRol6Rz+0+RgZXGvqWXz+F2KLBeM+VBB+DfCC
         VeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151476; x=1688743476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=skpFX1nvdUsEf5JIjZnFK8alGwuwceGPnoOmzX+YgHU=;
        b=HLkgEiadYrdaBorpTWP9CvpHePrC0iZBxxKC+eVRQhG7yqNS6e/r5mLZD3LeJM4Ulx
         xUPKWOBKs2fy+ynr2zQldsHx9ho4X++hxE7M0NLYqYOTFW+KzLVnVN23oj69rTI4AWhN
         aNF8OgaIxehGVT+fwAUN872m+FGo7SvKsG83Nw7pJSG2WyELrlep3qtaMCeJYjpOTt7O
         bBT40pP65WrfKDKlhvu6gB6XI8d+sXwGJjqw2sWzNJX00JHqcTFUbB3W36rCEmT3BM4I
         bvn+0hMRp6wzdSAr596gW77ncmSBsMM/Kq40Lr3x9UEpN1ksutMB7BAo8J1LmPYUi+5K
         MYIQ==
X-Gm-Message-State: AC+VfDxxuKVs2q1/LfJME/QESL3sKd2hRJt/aDFxvUHziYx3svqRJgXT
	fQywTPAlQPehPXZkiz4D/ClG
X-Google-Smtp-Source: ACHHUZ5zf5rAv1fKEXmFsQebOWqchgQba8hRDIpdEbSVGrI6EbcLNT1CTOXSId6xmx2MKgLO+9fWMw==
X-Received: by 2002:a17:902:db0e:b0:1ad:fc06:d7c0 with SMTP id m14-20020a170902db0e00b001adfc06d7c0mr2856601plx.1.1686151476521;
        Wed, 07 Jun 2023 08:24:36 -0700 (PDT)
Received: from localhost.localdomain ([59.92.97.244])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902788500b001aaf536b1e3sm10590958pll.123.2023.06.07.08.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:24:36 -0700 (PDT)
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
Subject: [PATCH v2 0/2] Add MHI Endpoint network driver
Date: Wed,  7 Jun 2023 20:54:25 +0530
Message-Id: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
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

Changes in v2:

* Fixed kfree(skb) with kfree_skb(skb)
* Reworded the Kconfig text slightly
* Dropped the MTU increase patch as it turned out only few devices support 32K
  MTU

Manivannan Sadhasivam (2):
  net: Add MHI Endpoint network driver
  MAINTAINERS: Add entry for MHI networking drivers under MHI bus

 MAINTAINERS              |   1 +
 drivers/net/Kconfig      |   9 ++
 drivers/net/Makefile     |   1 +
 drivers/net/mhi_ep_net.c | 331 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 342 insertions(+)
 create mode 100644 drivers/net/mhi_ep_net.c


base-commit: e7214663e023be5e518e8d0d8f2dca6848731652
-- 
2.25.1


