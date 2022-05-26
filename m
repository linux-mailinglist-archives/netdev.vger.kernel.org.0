Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BEF534EB6
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbiEZMBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238628AbiEZMBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:01:20 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3470BCC173;
        Thu, 26 May 2022 05:01:19 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id bo5so1531557pfb.4;
        Thu, 26 May 2022 05:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=olJVsa+imhZbIKfwYfCiwIDRYc9xg1wbsCc3f7jqMns=;
        b=hGhiTVMQrBdxXb+ebcEPGyBOUj6LNRR2pUIBaSCjRGYIrixAojVkDf20FUVeLG7Pjv
         ontXkDMXnlq5vvhr/MhbJ4XqqvK+dlMP0YkcJhMaS5ampadi9hkjjB3g5+U8Ciw29N0D
         i8WWZUqBhodFqu+qMoRUObdw8UF+sj0caBvrcVjRkBeLarmTKWfVRNAs7NrCAAYr0Edj
         P766cBKxM03M3G9Lx8YLfKGnIjHv42GUBI05180y5oYrKkZZtSxZ0yThNrmlrm5mOkzo
         CTFZz6xBNovdU65JpD48KL8Jj4PtJ97r9RPypzfsxmn5mf3abn9LSPRYlVUotJromWno
         Tfcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=olJVsa+imhZbIKfwYfCiwIDRYc9xg1wbsCc3f7jqMns=;
        b=n53+DfSZuPXs5VZtJeyGJfiRNKLvenFLrDQpRLUKBAATS31MVOugHteLy97P6yuPZ/
         TgCmv4PcGJP2CMRESJGbZwge7IGujFDlnUwmqj6Ec18dAmEJKHCfv5lhjD/Njkik6xRZ
         xHtLE+iwIfzIcKFFM65zZK+ivl6ToOZMPq1ufD5Z8di4Sf3WlKRSed6MZRz5nfJgmbp8
         43NCykReQ36ZJf59fTZn1pE3TZMpXiUe3oMrsGUAy2NHrNKjwduGeV0It78ZLI9q8JLb
         ZmJ8vOqGUpKwrY80GPx5/Z2ywDBwjz+oUanzOGHjfq0eOoF6WDJHeNcENZtK+eLZStAl
         +2Sw==
X-Gm-Message-State: AOAM532iKUCCZf6BeN3LRUu8SnX9D03nSD+8Fe2xhs7urgnxATQGb+h3
        VK85GR8OTl06DOVh7MUCNdHdvbjQvBQPzMkp
X-Google-Smtp-Source: ABdhPJzLzAuPjPrbmsZkr4fRsgdboaUdZStwLpGgpVUvkhrmLbOYM8puX8iCU21k1NPJPwOUvEJZFg==
X-Received: by 2002:a05:6a02:105:b0:381:fd01:330f with SMTP id bg5-20020a056a02010500b00381fd01330fmr32208794pgb.483.1653566478613;
        Thu, 26 May 2022 05:01:18 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:1:45c7:d5e2:7b45:3336])
        by smtp.gmail.com with ESMTPSA id bi7-20020a170902bf0700b0015e8d4eb282sm1328190plb.204.2022.05.26.05.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 05:01:18 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        parri.andrea@gmail.com, thomas.lendacky@amd.com,
        andi.kleen@intel.com, kirill.shutemov@intel.com
Subject: [RFC PATCH V3 0/2] swiotlb: Add child io tlb mem support
Date:   Thu, 26 May 2022 08:01:10 -0400
Message-Id: <20220526120113.971512-1-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Traditionally swiotlb was not performance critical because it was only
used for slow devices. But in some setups, like TDX/SEV confidential
guests, all IO has to go through swiotlb. Currently swiotlb only has a
single lock. Under high IO load with multiple CPUs this can lead to
significant lock contention on the swiotlb lock.

This patch adds child IO TLB mem support to resolve spinlock overhead
among device's queues. Each device may allocate IO tlb mem and setup
child IO TLB mem according to queue number. The number child IO tlb
mem maybe set up equal with device queue number and this helps to resolve
swiotlb spinlock overhead among devices and queues.

introduces IO TLB Block concepts and swiotlb_device_allocate()
API to allocate per-device swiotlb bounce buffer. The new API Accepts
queue number as the number of child IO TLB mem to set up device's IO
TLB mem.

Patch 2 calls new allocation function in the netvsc driver to resolve
global spin lock issue.

Tianyu Lan (2):
  swiotlb: Add Child IO TLB mem support
  net: netvsc: Allocate per-device swiotlb bounce buffer for netvsc

 drivers/net/hyperv/netvsc.c |  10 ++
 include/linux/swiotlb.h     |  38 +++++
 kernel/dma/swiotlb.c        | 299 ++++++++++++++++++++++++++++++++++--
 3 files changed, 334 insertions(+), 13 deletions(-)

-- 
2.25.1

