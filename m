Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2466877E8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjBBIwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBBIwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:52:49 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6199C728CB;
        Thu,  2 Feb 2023 00:52:48 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id eq11so1230695edb.6;
        Thu, 02 Feb 2023 00:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c8imLw2zIVWzUCeb3dVLIiXTws1/ABjEcX/MBA0oxEY=;
        b=D+4XykdwgR7Lu3xxweEqF4Qa7YM6l4oU79BeTagKMPvBMwBaLSuliZlP/zeV7a8KtD
         PWcj+PZnhTsCbZEOz+WZGFXzh19Yki+5c5jQdt7BOsduQxFhp3uV0I4s14IVddJYhpBX
         On3mtBpYEBUBj6kUg9WK90DP2EUT/u1t4k/paJOzbfYr7vP0pFvq7eYqpo4mC3f/T4jc
         cIw6LCW527FET9NxQYj0CJoF02Bj1lsWJtNTIwfpn8GWQw+frgp6m0zXQrx7fOndKfsU
         +sj7/d02LO7CG6qy7duAQofgh+txUodeWAM8B8n19gEtgo1GFh15wBIDtqGvopRFWpFd
         72zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c8imLw2zIVWzUCeb3dVLIiXTws1/ABjEcX/MBA0oxEY=;
        b=zNEl1LrmU0q+5JwuSWbipBpPKkgfjH2qpZqhqbwEhoScaeLay+OrC8QC0nzBSw3aTs
         oqxKH0XRNuVVr4vyRbx2JG4CIRJz6BDI3grGYOl4gH+yOmQzDjRd2jcCgJ+Y0ZCQFM6O
         c1yRz8muuLonZSIr+tQzrZ+6dZCzfDCDVf96rBombmr3yDOdvj5Qcx2vMt0lHbXuak8k
         NR9iySKMwJHEK8pcwdn4vEwuEXiHwYI0a3fCu1AQR3dzPnpwbzS1tD79+A2MNztD8mjm
         UMT/Kdt4pmQUhzDL5nQPSjptjZAHc7mXKv+vYmckAZQMN5qMmBq5FIJ11o/4mkYK8b1Q
         WCLw==
X-Gm-Message-State: AO0yUKXHlNqCS0B1GoUxXBfEnVMoPmlvX2jJlfit9c3Kld9HhUgGJcSu
        AVvQXGAKfVUGY0EAe9iZ0so=
X-Google-Smtp-Source: AK7set+diYGImVByaftiJ+HnGv/h78+1zmxYj8/MSsTakNiE75ydMcHB/z1RpmV7age6TNgBcmLPbA==
X-Received: by 2002:a50:d088:0:b0:4a2:3d3d:a3d9 with SMTP id v8-20020a50d088000000b004a23d3da3d9mr4652114edd.2.1675327966763;
        Thu, 02 Feb 2023 00:52:46 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id a6-20020aa7cf06000000b004a23558f01fsm6889204edy.43.2023.02.02.00.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 00:52:46 -0800 (PST)
Date:   Thu, 2 Feb 2023 09:52:46 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v5 ethtool-next 0/1] add support for PLCA RS
Message-ID: <cover.1675327734.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the IEEE802.3cg-2019 Clause 148 PLCA Reconciliation
Sublayer. Add get/set configuration and get status functions.
Additionally, shows PLCA capabilities and status when invoked
without arguments.

Piergiorgio Beruto (1):
  add support for IEEE 802.3cg-2019 Clause 148

 Makefile.am        |   1 +
 ethtool.8.in       |  83 ++++++++++++-
 ethtool.c          |  21 ++++
 netlink/extapi.h   |   6 +
 netlink/plca.c     | 296 +++++++++++++++++++++++++++++++++++++++++++++
 netlink/settings.c |  82 ++++++++++++-
 6 files changed, 486 insertions(+), 3 deletions(-)
 create mode 100644 netlink/plca.c

-- 
2.37.4

