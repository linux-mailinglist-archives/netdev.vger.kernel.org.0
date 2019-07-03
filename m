Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF7F5EA47
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfGCRVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:21:07 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36604 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCRVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:21:07 -0400
Received: by mail-lf1-f65.google.com with SMTP id q26so2342533lfc.3;
        Wed, 03 Jul 2019 10:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0XFTPdWYOAsJZjw5yIPsS6PxhrhYZh1lerKXLSiaL9U=;
        b=aEnlM23ybF02fz9G+9j5kn8MMs5iABiLI6EvenSA6cwebZvP5UmoP87eUq8+L35xQK
         86UVFSBTB2FxIxDkcGrLFE3OmMJPgugDLeifLJ9hJfDuoAfRTFFxRRue/odLBVdUKuM8
         QWHU6JxMWeRUwschlRclvGUryIhTpMjyeGaYkvc0VBPoi5uiaOpyf8Gq9L20kb24ENE5
         teS8gxvDjNFj+Id+PsTdHgUWyf89l1jyX//wIBuGPuqb0pw2Q9NoToNh0+FXGmtA8Zmy
         ThX+aS6p7SWp2BUxGt0VxINjHW3wIKEfUsJ/1VlUVmQ+lyLD5/C72MQa61aruhPZ39i3
         GkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0XFTPdWYOAsJZjw5yIPsS6PxhrhYZh1lerKXLSiaL9U=;
        b=ri1Ffo6MeawUhK6lOam4FXeRW5y+uFjHSgHCvSqfCcPjBycNElwtQG4R72X7N0Lwoe
         +bv8K1EypmmUpCNcXamFPTnuIrGYhrp65uCtBrlj7dwnXPc1IjRhLGJeEP3KBrFHPC9V
         1ETJlpT9dp/6xbwze1+uMzc3OOz2gVWBOG3OwSlDuBFV6Jq6eQsT5mGCSZEWStaayN1z
         BgL1YNK1gd61upM4h7qlvmkCi1WYJJNm8quh7fkoe26JLtqf5DQq6vSHUG+QNi3OcstO
         rkovMd3HBy5XluuBv2Tng/zABCjwb+s/MQQYxwmb137tsr47skRkATkZwlgnp3y5j6sh
         zXHw==
X-Gm-Message-State: APjAAAUZkXzXUYGfH/lEQimAT9M7w72jQTKmPiaTAuj2X0PuU1D3vxRH
        ZLJCbMin2WUQG1z+TQcdsHk=
X-Google-Smtp-Source: APXvYqyPEQUFVz+9rhu4UkRaIqlXg9DALZeMyEgpwmOWPh7ZkK4USmW3iqe24wcSm7cpDN+GAjuGmA==
X-Received: by 2002:a19:a87:: with SMTP id 129mr17824384lfk.98.1562174464828;
        Wed, 03 Jul 2019 10:21:04 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id 11sm581165ljc.66.2019.07.03.10.21.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 10:21:04 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] net: dsa: Add Vitesse VSC73xx parallel mode
Date:   Wed,  3 Jul 2019 19:19:20 +0200
Message-Id: <20190703171924.31801-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Main goal of this patch series is to add support for parallel bus in
Vitesse VSC73xx switches. Existing driver supports only SPI mode.

Second change is needed for devices in unmanaged state.

V2:
- drop changes in compatible strings
- make changes less invasive
- drop mutex in platform part and move mutex from core to spi part
- fix indentation 
- fix devm_ioremap_resource result check
- add cover letter 

Pawel Dembicki (4):
  net: dsa: Change DT bindings for Vitesse VSC73xx switches
  net: dsa: vsc73xx: Split vsc73xx driver
  net: dsa: vsc73xx: add support for parallel mode
  net: dsa: vsc73xx: Assert reset if iCPU is enabled

 .../bindings/net/dsa/vitesse,vsc73xx.txt      |  57 ++++-
 drivers/net/dsa/Kconfig                       |  19 +-
 drivers/net/dsa/Makefile                      |   4 +-
 ...tesse-vsc73xx.c => vitesse-vsc73xx-core.c} | 206 +++---------------
 drivers/net/dsa/vitesse-vsc73xx-platform.c    | 160 ++++++++++++++
 drivers/net/dsa/vitesse-vsc73xx-spi.c         | 203 +++++++++++++++++
 drivers/net/dsa/vitesse-vsc73xx.h             |  29 +++
 7 files changed, 493 insertions(+), 185 deletions(-)
 rename drivers/net/dsa/{vitesse-vsc73xx.c => vitesse-vsc73xx-core.c} (90%)
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx-platform.c
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx-spi.c
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx.h

-- 
2.20.1

