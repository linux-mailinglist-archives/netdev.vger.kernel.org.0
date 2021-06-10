Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446633A366D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhFJVrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:47:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230422AbhFJVra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623361533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSv9PvVn6D8P1hr2HASl5EPE56aRrWalXa3WhtLcjzQ=;
        b=OrjM82GG+FcncTeXamTf4IPrgobNSvwaVkSHOTsXi5o+cttpPK5zSc51a/m963OOl+zU9z
        2gFXw8k9xcyNHQdB6X0wb2/h9j4xjywJd/b4bwAjlIgFqJrLyWH1MR3nVWd22HfgqFZWwR
        quLOezsuXOXX0Px5ILTS+k1sYXaZQrI=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-v5NGj7Y-PPeXpepaexIh9Q-1; Thu, 10 Jun 2021 17:45:32 -0400
X-MC-Unique: v5NGj7Y-PPeXpepaexIh9Q-1
Received: by mail-oi1-f197.google.com with SMTP id l123-20020acad4810000b02901f1fb44dca7so1886225oig.15
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 14:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TSv9PvVn6D8P1hr2HASl5EPE56aRrWalXa3WhtLcjzQ=;
        b=ehYrRz97+bO6/7+fARSqCOa5/ak/tAX/rnxDZ7eyDSvdgBJwBqnQgOrewVnmCvFpjg
         oiZDw5lBCyOWzIFEfE+xl5LLUNHjIxktm1PbY9KIqFouyvvKOzN2gNabeb2ib2QC00Bq
         8o9c9xaJo/TgxaGxfKTEwIe1FzaxRW5wE837RXXAdR3LlPKj01yLtFP+D12Nc1epuG52
         2yt36VdFP0280l1jdG1KjbHNSx+V7r/4lbLdAKYZSe4+oneCINLImMcTi9/586lZYd1h
         u89byDQz9z128TcKBQHFe2Pqa5ZIt8GCC90IHRBBnoaoCGCDjIYWhphJSZPHPklvpr7s
         mZQQ==
X-Gm-Message-State: AOAM532AwwgRNZK0/eVGUpnIvyTMopwjFygCuHdOhQYcTEGpeDEEmob9
        qyHncOGXmG/W8guAMigHWqqosUwcGR/jmzFDDuereJe1icyr+u5OOOZxUTISLpRJAQe0I9yFobT
        ZEct/OhKpddX+iOZX
X-Received: by 2002:aca:b506:: with SMTP id e6mr361780oif.178.1623361531509;
        Thu, 10 Jun 2021 14:45:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLkOYqEPHROAavZ+GqUoBa88evwWu8hew7OzFYwlCFApTMasrs2l9HZneVNx3WKlokSV6LKQ==
X-Received: by 2002:aca:b506:: with SMTP id e6mr361752oif.178.1623361531370;
        Thu, 10 Jun 2021 14:45:31 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id i15sm881839ots.39.2021.06.10.14.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 14:45:31 -0700 (PDT)
From:   trix@redhat.com
To:     robh+dt@kernel.org, tsbogend@alpha.franken.de, jic23@kernel.org,
        lars@metafoo.de, tomas.winkler@intel.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, apw@canonical.com, joe@perches.com,
        dwaipayanray1@gmail.com, lukas.bulwahn@gmail.com,
        chenhuacai@kernel.org, jiaxun.yang@flygoat.com,
        zhangqing@loongson.cn, jbhayana@google.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, Soul.Huang@mediatek.com,
        shorne@gmail.com, gsomlo@gmail.com,
        pczarnecki@internships.antmicro.com, mholenko@antmicro.com,
        davidgow@google.com
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, Tom Rix <trix@redhat.com>
Subject: [PATCH 2/7] mei: hdcp: SPDX tag should be the first line
Date:   Thu, 10 Jun 2021 14:44:33 -0700
Message-Id: <20210610214438.3161140-4-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210610214438.3161140-1-trix@redhat.com>
References: <20210610214438.3161140-1-trix@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

checkpatch looks for the tag on the first line.
So delete empty first line

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/misc/mei/hdcp/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/mei/hdcp/Kconfig b/drivers/misc/mei/hdcp/Kconfig
index 95b2d6d37f102..54e1c95269096 100644
--- a/drivers/misc/mei/hdcp/Kconfig
+++ b/drivers/misc/mei/hdcp/Kconfig
@@ -1,4 +1,3 @@
-
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (c) 2019, Intel Corporation. All rights reserved.
 #
-- 
2.26.3

