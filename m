Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC43CD4A55
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 00:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfJKWcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 18:32:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54420 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfJKWcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 18:32:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so11824572wmp.4
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 15:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ekyyc0DDAeiY6WU5bnIfQMgX+Ez/P1kjean8hbE81Ao=;
        b=DorwCqmRmisgUz2NkFIhuxoaRZT2JrdW9sbzbJnVxuCtHh6ROZLihLes75gZheJCV0
         J+YHWlPSZwEVsbvF2EZAdeGqC4sTszoYPDRkchZ25pWDJ1suVEY+JFQR0xFlpnQZlWHC
         X5qK3Q0Hci8t89rLH6tcymVBar8hdTU6qPhknPiFLZ2AsHRwkTek5NC4ls1rBrCI/Yq0
         dPYLaxaBX2ZrgqrphYNRBtbRwpnFJgqJ2k9h1t9qbTYqCirj16x4LL3dcSpyvs02tzCt
         ehCsLq3I9EoI4JDM+QttTdM/YgR9INOxQQXanbyplv70MfarZgGnDRSOA2fySrYcjhU3
         r2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ekyyc0DDAeiY6WU5bnIfQMgX+Ez/P1kjean8hbE81Ao=;
        b=b6f0yOGQlc6oI73ARmLGunPUuHPjo/n2d0K41UYOC4OioGn+HX2zoorbdfEi55gTE4
         EccUVkno/gciNuh6r25myOwObsxJR3pPOPk9rHu9ojeZCiVD7/3qCVVptfQIe1u9s42i
         ndg2+X8ty6fmVt+F6pPPiSC7ooSgh6U9Klxdxp6SWnWQjT/RXLETs3+5lp4auHLYb7AE
         /Es/5d3MHqVKhfw92XUPIOm6+RGqY7iVFidAE6SdNP+4hhWuS3vi3DTtJl2/VSYDrVwp
         Q0bistlA1jqbsXKcgmFv1GREvwicVGXRkRyhKNLiveby4VtvihQPoP/3qIo0DtrwlRcs
         DDXA==
X-Gm-Message-State: APjAAAX3HIK0PjT7KXI3qNL+vQziYDkT96B7nFpV2KNlppRELkLD1Tta
        bzz8fncB1b4pNRb8dSVDRHg=
X-Google-Smtp-Source: APXvYqxwa6Rf9w4QFMUcqosBm6yjtEA3o6J2IHArVXJiiztqPr2VnjH8Bd5pOYB0Lbz2IsQlm57lNQ==
X-Received: by 2002:a1c:81d7:: with SMTP id c206mr4698982wmd.175.1570833133992;
        Fri, 11 Oct 2019 15:32:13 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id r27sm25549828wrc.55.2019.10.11.15.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 15:32:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] Scatter/gather SPI for SJA1105 DSA
Date:   Sat, 12 Oct 2019 01:31:13 +0300
Message-Id: <20191011223115.27197-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a small series that reduces the stack memory usage for the
sja1105 driver.

Vladimir Oltean (2):
  net: dsa: sja1105: Move sja1105_spi_transfer into sja1105_xfer
  net: dsa: sja1105: Switch to scatter/gather API for SPI

 drivers/net/dsa/sja1105/sja1105.h     |   2 +-
 drivers/net/dsa/sja1105/sja1105_spi.c | 182 ++++++++++++--------------
 2 files changed, 85 insertions(+), 99 deletions(-)

-- 
2.17.1

