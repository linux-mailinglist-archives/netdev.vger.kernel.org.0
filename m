Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118DE202629
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 21:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgFTT2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 15:28:05 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:44184 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728565AbgFTT2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 15:28:04 -0400
Received: by mail-ej1-f68.google.com with SMTP id ga4so358425ejb.11;
        Sat, 20 Jun 2020 12:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mUJH12LGeW9ylYQEdpmnE0J88t7sUIOSezt8ZphdlhI=;
        b=ntaLZQiFRDVbnTDcEeJmaep8QFe8P5X4WgGS4Eo3LTzE/WmPZLunUnKGx46AH2zK5v
         ljBWj3sCov2YBpl0GnI7foLID/zGz/NiFdcS/W3KvxVJSmO/1TqTGbQpRM1lVsF0JpAi
         CnMM/jb2mhg3TXUsHxoW8imEGoD0xVO1fZh9xtK+HuJr5FC1PXq2EajvcF+ovM7A/ASg
         twTNA4hK18kdYBmfi2ObV98lVtx2An7RnTQQWRZu6HtCLAKnTQDTctWVJu6CpedJEsYK
         8taXz8a8LHiKYo39atZe9D1gs2G0c9IuW3FpftVSEmpiT9GfuMAbf+WPXNTbqeAKzQ9+
         l+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mUJH12LGeW9ylYQEdpmnE0J88t7sUIOSezt8ZphdlhI=;
        b=d6isoNwz/3d/lW2e3X+S3NTp87xKmFvEDQBCmPnmbTWtNW4rZIBze4f9QlQFPmbg6Z
         DIsfqS2nTeRpGhDlNBzR3EoJ5LA8xez6Sq4qz2BcIYInDF8cUH5iORPQUz154empo9Zd
         +oakTWyt/Ut/e7K+2pXXznFs+cEJh1S2In3pih3pKX4yT2HDK+mvXmgFu6YUqdjUdBXC
         4EtFDffAMTbWwAWoXDSmWllK7I8mSL1IWn2zFrHPC1CSc3iUkZgJSbqwkCPPHCXCtv5x
         OrdKMOye2BZik2dmyNwapVCh7VS+bfu4Q5UcWa5VJrx6dI3MuM7AiarFazKwKcGZesS4
         PcvA==
X-Gm-Message-State: AOAM531GDgQJhfTFxwZUWd74EpkTOqegcavgOlZwFt88nJc0bHR3e9Pb
        ZtZVMiO7mJBshKGAj5phbFI=
X-Google-Smtp-Source: ABdhPJxsrLJ6aA6NVzk/zX8t11cs2ETNgzWKiUMxMnSjlqyiheQL1voAGp96yx9pCHlNR3b39ESu8Q==
X-Received: by 2002:a17:906:7a19:: with SMTP id d25mr9321045ejo.333.1592681221933;
        Sat, 20 Jun 2020 12:27:01 -0700 (PDT)
Received: from localhost.localdomain (p200300f1371df700428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:371d:f700:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id gv18sm8034044ejb.113.2020.06.20.12.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 12:27:01 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/2] prepare dwmac-meson8b for G12A specific initialization
Date:   Sat, 20 Jun 2020 21:26:39 +0200
Message-Id: <20200620192641.175754-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some users are reporting that RGMII (and sometimes also RMII) Ethernet
is not working for them on G12A/G12B/SM1 boards. Upon closer inspection
of the vendor code for these SoCs new register bits are found.

It's not clear yet how these registers work. Add a new compatible string
as the first preparation step to improve Ethernet support on these SoCs.


Martin Blumenstingl (2):
  dt-bindings: net: dwmac-meson: Add a compatible string for G12A
    onwards
  net: stmmac: dwmac-meson8b: add a compatible string for G12A SoCs

 .../devicetree/bindings/net/amlogic,meson-dwmac.yaml          | 3 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c           | 4 ++++
 2 files changed, 7 insertions(+)

-- 
2.27.0

