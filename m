Return-Path: <netdev+bounces-7312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 746C271F9C5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0257D1C210F2
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6310C1FC8;
	Fri,  2 Jun 2023 05:52:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528AE1851
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:52:21 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C15C1A2
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 22:52:19 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b039168ba0so14696405ad.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 22:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1685685139; x=1688277139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AE2xzqHFPvJyLtJ4dI+SdGtkCRUUUqd29Nrdavs8L6c=;
        b=ftfHeXNRAMYhQcolNfzeiI9JdhXWRWSgYhPaIr9WxLqd3yBpt0mr4nOoav09Gm8CW+
         cMa+fP6gJmjvjtJpLWBAS+j97NoaNa8uoNzg3fTEylxNElIUhWTwKBroyAk1SKUqW3jE
         IYecWesShL1NepJw6BYuWqk42/FrDtDowamdBxXFDmoz/kupL5dwT/qFn3ZstEqT6nvV
         tv4BTF/ol/x8nrnqZ5+jfEokGq13SpGDjX38N64yZbDEHm6BriF3H87RapLwcGqyyXyo
         QCrRUFeRbVxI5athO6QlqTk55KAGvWe3l8VwtEPtoC7FGDLqUe0yps0TXggyR2xEKG3+
         AjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685685139; x=1688277139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AE2xzqHFPvJyLtJ4dI+SdGtkCRUUUqd29Nrdavs8L6c=;
        b=TQXblY8OVuh+vD7iPfv8CpiZK4Z+MC8bqj7XtgOFErVt5Ry7me5AofLK8V0kYPxYXd
         S/6Ht/ICPLbfQPwP0mdndgBTpygqYAawH0IS1dpHzcqxWBkDeIIdaG+WxFtlwMSK7hGW
         oYKS8SCn2qCmKATZGE2G3JftTkYqD+u8giDR6lb9n47BJ5BhnKhkrQIFeJsJI90H7uQ/
         btd8Ek2VSkxO+uW02Rd3tWUH9Hy/Zkg7wD32PMvSrEOmuq/9up57RUqCeZGF2in8IDVP
         plgEtD6RBPaRZ2oY7Jf9f2OSembmaGx1cFrSETKwhqSNsK89vhQVZGEeasjstnYQOq97
         WCUg==
X-Gm-Message-State: AC+VfDxU6ixHC/wa5YHQKmvzvNuOKKlXTs3COz3+mqKTXaBWknjSPFv4
	BkYjtc9mDWqHDjOAYHP2NtFdeA==
X-Google-Smtp-Source: ACHHUZ5hYoSyNP1eBDO5vLkT94KN924ewF5hYgSdmxaV6A36IdMl7n1rKeC9tzdFIwyz0Gag9pSUOQ==
X-Received: by 2002:a17:902:ec8e:b0:1b0:4b65:79db with SMTP id x14-20020a170902ec8e00b001b04b6579dbmr1669736plg.63.1685685138776;
        Thu, 01 Jun 2023 22:52:18 -0700 (PDT)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b0019e60c645b1sm358789plg.305.2023.06.01.22.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 22:52:18 -0700 (PDT)
From: Shunsuke Mie <mie@igel.co.jp>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shunsuke Mie <mie@igel.co.jp>
Subject: [PATCH v4 0/1] Introduce a vringh accessor for IO memory
Date: Fri,  2 Jun 2023 14:52:10 +0900
Message-Id: <20230602055211.309960-1-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Vringh is a host-side implementation of virtio rings, and supports the vring
located on three kinds of memories, userspace, kernel space and a space
translated iotlb.

This patch introduces a new accessor for the vring on IO memory regions. The
accessor is used by the proposed PCIe endpoint virtio-{net[1], console[2]}
function drivers, which emulate a virtio device and access the virtio ring on
PCIe host memory mapped to the local IO memory region.

- [1] PCIe endpoint virtio-net function driver
link: https://lore.kernel.org/linux-pci/20230203100418.2981144-1-mie@igel.co.jp/
- [2] PCIe endpoint virtio-console function driver
link: https://lore.kernel.org/linux-pci/20230427104428.862643-4-mie@igel.co.jp/

Changes from:

v3: https://lore.kernel.org/virtualization/20230425102250.3847395-1-mie@igel.co.jp/
- Remove a kconfig option that is for this support
- Add comments to exported functions
- Remove duplicated newlines

rfc v2: https://lore.kernel.org/virtualization/20230202090934.549556-8-mie@igel.co.jp/
- Focus on a adding io memory APIs
- Rebase on next-20230414

rfc v1: https://lore.kernel.org/virtualization/20221227022528.609839-1-mie@igel.co.jp/
- Initial patchset

Shunsuke Mie (1):
  vringh: IOMEM support

 drivers/vhost/vringh.c | 201 +++++++++++++++++++++++++++++++++++++++++
 include/linux/vringh.h |  32 +++++++
 2 files changed, 233 insertions(+)

-- 
2.25.1


