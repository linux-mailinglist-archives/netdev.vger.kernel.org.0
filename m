Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FDE1BEC40
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgD2W6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726164AbgD2W6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 18:58:16 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368C7C03C1AE;
        Wed, 29 Apr 2020 15:58:16 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x4so3849867wmj.1;
        Wed, 29 Apr 2020 15:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UyMJQl3nI+Ci8kPvH5WG8fF8ZyspZWe6A/yt+JRO1sg=;
        b=RqrNzY9KCarY18ORnKS6AI/WE8sS4Uxz9WTgTDQp33yUePp3utITDgAe8XOK9qBJtC
         dzUQUzrhee5srCAxnaXcZOM8MXBcyVz7hmkodiExzNWU2pG15XW0x44pBUDoThwNrutx
         BOwHwWdjWdup8JasiG2Ws1J7l4iOCTGebOqo2+1t3cGOoQYBK9qfZX/Wvpo5vMByuKvC
         +vK8PXkT5pU7ItSq3S3XFMGJ7rTugspej0ruh4JCp/4MASXfPFRXMEYwdS1PvqJdtnO+
         EZ3INpTzhGUJiJtGQoSAGNA+bhWOfS5vrPOiiuPaSfzRgjlJUuh0x2U0AEQp5XUq/lnH
         Cx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UyMJQl3nI+Ci8kPvH5WG8fF8ZyspZWe6A/yt+JRO1sg=;
        b=InrjJCCI8U0vo72JjUMpwnF52pIsKGEZ8Q9LjdntlGmc9Pb1Y78ZujC7obFzp2C2je
         nV2WP5OtbHef2l0iy5kK03L0upGs9I+aX6VrzYphohPVioIjanmmXv4ramYR4iZaDAuf
         /scosnXriCCaOtxG07q9UibJ3QLf40DYN//KcV13Hdai8X0HnHrj8cesL6VNFpW6iFJn
         jv3wDcVcqaujoZ+Q6r3nDyfN7mKCRYLAZl8XatJVywNOW/UvMd/QEQpJCUx6tCAGjnLW
         pCqbNnST95ocZm9sl3I5pVwxHBongKi6KzHUJuyQ4ehMZrznZIHenCccohhfVFN0kAkl
         k2VA==
X-Gm-Message-State: AGi0PuaSrluZHRxRCb2320z/Txlpje3U/VTUFuBM8R0lEMN/37w1ZDym
        BWXd9S57g9I4uQj2b8HBmI3qb0EMNueT
X-Google-Smtp-Source: APiQypL/c/YgTJIJgEins8chkLVhwq5XZs0YLMtt6F/cqU89T/sydPViOWJmXjel75GFInjHJXTljg==
X-Received: by 2002:a05:600c:210:: with SMTP id 16mr136891wmi.57.1588201094577;
        Wed, 29 Apr 2020 15:58:14 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-195.as13285.net. [2.102.14.195])
        by smtp.gmail.com with ESMTPSA id 91sm1247675wra.37.2020.04.29.15.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 15:58:14 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 0/2] Lock warning cleanup
Date:   Wed, 29 Apr 2020 23:57:21 +0100
Message-Id: <20200429225723.31258-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <0/2>
References: <0/2>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset proposes a solution to functions that regiter context
imbalance warnin, we add annotations to fix the warnings.

Jules Irenge (2):
  cxgb4: Add missing annotation for service_ofldq()
  spi: atmel: Add missing annotation for
    atmel_spi_next_xfer_dma_submit()

 drivers/net/ethernet/chelsio/cxgb4/sge.c | 1 +
 drivers/spi/spi-atmel.c                  | 1 +
 2 files changed, 2 insertions(+)

-- 
2.26.2

