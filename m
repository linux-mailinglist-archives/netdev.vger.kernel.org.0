Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680434E2410
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346194AbiCUKQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiCUKQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:16:15 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD2417A80
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:14:49 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bt26so23788060lfb.3
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=yAs7OlyCkG2IjiFXwknHCslxIjrT2hjdSTq1iF5pBus=;
        b=lxvmO/9+TUl5XGb5BMMcMts4IumRT070jTkJWH6hCdUbWlpl9SOnDaDJAacwfZ3LM5
         /k7sP7ndlfG8AyaqWXbwV4uL8uIjXqGaW5xWO5dkOlwHTXBmnTqKYfYUDd1RTMYiUGqW
         E3mp0NA1YM9cQX34sIXtqPNe/dB2I298yenNHPh0RlEXExVrehb6NmZfEi4bU7kiw51Y
         0DOgH13Bo6b5QE8O5iQ0HXaVJMGSh/zyXsXS9gPgOve8gjh+Ir4M4PmYEtMcLr3p267/
         9qQRA6EdJgTLTtWNzOkly2bC4g9G+ByKFeK9FzB4Tup3OhRAejLNbO0hJG3javRFh3Iw
         Whtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=yAs7OlyCkG2IjiFXwknHCslxIjrT2hjdSTq1iF5pBus=;
        b=II2HS+2rX40bX7JcgH/WM6DbBKgD5MOGn1tDfkK6ds5M13tbLtlv7W4Y7ZoRVFjy1J
         tMkjatEHRSnuGx5+dKlVlijGCfTSDRQspV37BOrw3+5TMHPoXYoCHhrKYgD25Mus9+Np
         f3iWYyjKPCb41yghP30vDGEMve6/0JrRGzvpCg95EENBWExqpkVNwybwWXmtbeJb8Mvn
         xTRzZiuqTdZh+vJiKa7jZKyIHrIzIqvIvy+lrZwpoH+govuuIT4Fh26n43GOjDijuHto
         Juadrmrjtww431Q1AvIUiwBvZg26i7BWVfIxK/3YigyOJyKPNNQhMEY89vvYmenXjT5s
         VSWg==
X-Gm-Message-State: AOAM533DNCIQgqA6+UWYBrNtXvzu8BaMgD62kKyqeZ0UtqWkUrZAxI1/
        1MleCqPtgkJpi1sTngLrXl0=
X-Google-Smtp-Source: ABdhPJwz1HZCsBu6Ynx51SrettvIcRf9YL/jxZs19yqytRhrGBVPEl93G573pUrLwGsaM2pEwvxtBA==
X-Received: by 2002:a05:6512:2393:b0:448:323c:cc4f with SMTP id c19-20020a056512239300b00448323ccc4fmr14295567lfv.314.1647857688149;
        Mon, 21 Mar 2022 03:14:48 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f11-20020a0565123b0b00b0044a2809c621sm361598lfv.29.2022.03.21.03.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 03:14:47 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/2] net: sparx5: Add multicast support
Date:   Mon, 21 Mar 2022 11:14:44 +0100
Message-Id: <20220321101446.2372093-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Add multicast support to Sparx5.

--
I apologies, I accidentally forgot to add the netdev
mailing list the first time I sent this. Here it comes 
to netdev as well.

Casper Andersson (2):
  net: sparx5: Add arbiter for managing PGID table
  net: sparx5: Add mdb handlers

 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../microchip/sparx5/sparx5_mactable.c        |  33 ++++--
 .../ethernet/microchip/sparx5/sparx5_main.c   |   3 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  23 ++++
 .../ethernet/microchip/sparx5/sparx5_pgid.c   |  60 ++++++++++
 .../microchip/sparx5/sparx5_switchdev.c       | 111 ++++++++++++++++++
 6 files changed, 221 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c

-- 
2.30.2

