Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3059583315
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiG0TJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbiG0TJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:09:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC855C9D9
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:50:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s186-20020a255ec3000000b0067162ed1bd3so5686411ybb.8
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 11:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AiBYfR/5OjnWEJ/rzS2SQd7Q9eOeUYczfeAhpI6Y0m8=;
        b=DsxCrgrKilgc92vowjAYLTpdzdYTBK1W1D1m2Tjbr13ce8793EIKe7Qz8nFTRKeYJo
         toFSdGPCT84icgP70+tQan50nfrahJfickYYSe/4XK8ES47+9Yiu8EG18wcaPEmKoLPD
         vel2HggHJm831lwYuRTxqt36EjtsbzgBS4FU7MTySz/NRRViBAUnWNnQmXXaVnknHfwz
         xi2aZocXFRu+XprlyXuvXECH+uFTkdcRQjtdyNLpj6gCpKjw13KHtA9oY15OHBBvTgSN
         rERjbC+e8LJYo+0BNSLgZHtapD/AFDd4wfMIhjU66IpBJveQ5SJOku87WAHGi0hazxDt
         633g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AiBYfR/5OjnWEJ/rzS2SQd7Q9eOeUYczfeAhpI6Y0m8=;
        b=aB3TcR4rgC0M+k6+vIWbCuiz+305IJkhJYMXpDPMoDlpZBvXkC7KFRvStsTnEkRTsK
         pSN+4LuXl7l0Uu5FtOi7xHNnXgW3RwazTkrs4seQ/j5cBPMTitIxNnpEfElcIo5JK7M/
         67n/7QbSFBcenS+NTAfE4eH+juVpzmXbZXJFalO0jLt8b4OYXHKC3ZRUzOU4OIw/X9L8
         yaUvLA9EVkuYNV7trHwpnWjkA+TxKcdKt9acc5rp6cnF+U+qkVJ1HHvADfJgkIkojxdq
         3KKF+fLMoAF4JrvVGim8wY+s0sMAKXrebt3YyURSn4JNSCVu3YqOFu09o4YWc6aCQ5wb
         2WDQ==
X-Gm-Message-State: AJIora/uhjB3ERhv9cDWRBN5pgi2t+o30y9jaIjDm4lXqoliHSeYXasW
        EOzfz1TS52UGqKij3rdsMY3XqDVP/sVKlsw=
X-Google-Smtp-Source: AGRyM1sKvcEG6HTbwn4Qtdz1tPoxdsbH7tB8Cf4IytjOVrHIzaZjDHCC4u7LfK1zdY8owYb42NvLpKRQcLnTwuo=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:40ee:bae0:a4fd:c75b])
 (user=saravanak job=sendgmr) by 2002:a25:9d81:0:b0:671:7c94:4f2d with SMTP id
 v1-20020a259d81000000b006717c944f2dmr6294520ybp.215.1658947818390; Wed, 27
 Jul 2022 11:50:18 -0700 (PDT)
Date:   Wed, 27 Jul 2022 11:50:08 -0700
Message-Id: <20220727185012.3255200-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v1 0/3] Bring back driver_deferred_probe_check_state() for now
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Saravana Kannan <saravanak@google.com>, naresh.kamboju@linaro.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More fixes/changes are needed before driver_deferred_probe_check_state()
can be deleted. So, bring it back for now.

Greg,

Can we get this into 5.19? If not, it might not be worth picking up this
series. I could just do the other/more fixes in time for 5.20.

-Saravana

Cc: naresh.kamboju@linaro.org

Saravana Kannan (3):
  Revert "driver core: Delete driver_deferred_probe_check_state()"
  Revert "net: mdio: Delete usage of
    driver_deferred_probe_check_state()"
  Revert "PM: domains: Delete usage of
    driver_deferred_probe_check_state()"

 drivers/base/dd.c              | 30 ++++++++++++++++++++++++++++++
 drivers/base/power/domain.c    |  2 +-
 drivers/net/mdio/fwnode_mdio.c |  4 +++-
 include/linux/device/driver.h  |  1 +
 4 files changed, 35 insertions(+), 2 deletions(-)

-- 
2.37.1.359.gd136c6c3e2-goog

