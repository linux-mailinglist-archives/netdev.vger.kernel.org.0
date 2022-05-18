Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6967952C5ED
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiERWFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiERWE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:04:29 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029705C35F;
        Wed, 18 May 2022 15:01:20 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id i19so6337254eja.11;
        Wed, 18 May 2022 15:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tZva3ZWB7SHIPYXbTijfnsY42exyzOkkddmZBvpg4OE=;
        b=Geucd2Stagi8+TMVEQp29NsAaxGql0+UABzJe0jAUCRr2TagcF6LqwE6bsyO/eshe+
         f+GGoD2UktjkYuEOeoLo63K+hCcAhjK9DdBbbuPS2z/hlk3kwoQfJlixQSknJF0FTvP4
         mF1FYKm/RHJXUJgoCwr97SSAsPhrcnb6cRKOzmv+AC1KkzNLxDWMZRkPyqdz3tzEF4e0
         rkMmuLZx5tf69iKPQJ+jeLshf4fY97i33sDBWrOozpcPmOYbPeYikvrupMSGTKHGLdZv
         SVpEsaEvBSfG/BFPzhtwHwC3h8vN5e17FibmgmKydY5S/I1XK2y+Ybb+i1LCB8GSuzF/
         LOSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tZva3ZWB7SHIPYXbTijfnsY42exyzOkkddmZBvpg4OE=;
        b=yGLnGmPhYvuHSBZYNdblUo/cYHk7znzN1NuaJmbs5uVSnU0VD0T5zXXaNfPU9/zrf4
         zkGkO3LbCIeFl/DULSMXRX3ga28dmJUwHzoY+C5mrCoptJGnxs8TgTjIvO9keXIr+3iz
         hc68IGBvEDmyS3aQSDh9R1lQXOpQ3fBvarzzjbvGidZZxkDia/aGSLJI6cW5hLCt1M21
         hIdJCSLq7X6jeIzgRt4dRBIGCW3B5oNSP55T1N6dXNnDDK80zxt+gm/7uQeIR1PzlLmE
         pOpyeY5HV5pD1M0OQHhA2+mB4HPUwtH8ddV/NlBXeDu6l1cwPmh6QA+Q+kmWoWPNFBmT
         oihg==
X-Gm-Message-State: AOAM530jOvlFJpFtzPb7kr+jmA2+CvFZ6/Qhh4Obvc7jWIiypTbskw2T
        Le6K4VizkiQn7E4u2DW3N3Pweu2qoqY=
X-Google-Smtp-Source: ABdhPJztw80HTJEGzuTE1SbR9NJO+jqalRvjAph0WIbZgND8Ff7n4ABSkgDCV+LbVzCY+YU81AqTdw==
X-Received: by 2002:a17:906:9c82:b0:6e1:1d6c:914c with SMTP id fj2-20020a1709069c8200b006e11d6c914cmr1431637ejc.769.1652911278233;
        Wed, 18 May 2022 15:01:18 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-118-099-170.95.118.pool.telefonica.de. [95.118.99.170])
        by smtp.googlemail.com with ESMTPSA id ot2-20020a170906ccc200b006f3ef214dd0sm1478885ejb.54.2022.05.18.15.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 15:01:17 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v2 0/2] lantiq_gswip: Two small fixes
Date:   Thu, 19 May 2022 00:00:49 +0200
Message-Id: <20220518220051.1520023-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.36.1
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

While updating the Lantiq target in OpenWrt to Linux 5.15 I came across
an FDB related error message. While that still needs to be solved I
found two other small issues on the way.

This series fixes the two minor issues found while revisiting the FDB
code in the lantiq_gswip driver:
- The first patch fixes the start index used in gswip_port_fdb() to
  find the entry with the matching bridge. The updated logic is now
  consistent with the rest of the driver.
- The second patch fixes a typo in a dev_err() message.

Hauke gave his Acked-by off-list to me before I sent the patches.

Changes since v1 at [0]:
- rebased on top of net-next as none of the patches requires backporting
  to -stable
- added Vladimir's Reviewed-by to the second patch (thank you!)


[0] https://lore.kernel.org/netdev/20220517194015.1081632-1-martin.blumenstingl@googlemail.com/


Martin Blumenstingl (2):
  net: dsa: lantiq_gswip: Fix start index in gswip_port_fdb()
  net: dsa: lantiq_gswip: Fix typo in gswip_port_fdb_dump() error print

 drivers/net/dsa/lantiq_gswip.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.36.1

