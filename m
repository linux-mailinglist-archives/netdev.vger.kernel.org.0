Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322CB598182
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239973AbiHRK3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237435AbiHRK3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:29:47 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49036EF33
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:29:45 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id v10so1281928ljh.9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=I5lBklmqYc584BHmMq417kVRATy/tYqlOxjeSvPEvDw=;
        b=hqLgz//RSEG6Gk5wyV5VGl76fFt3NiBjhHh4059dwz6HVkdEROX/G+U0KzOvKbdp14
         7xhvECG03ywsolZbB2MwH38CjkkujmX6zMECR6aPFn7UOoeap+BswJsawOspg/fM6pgT
         sln5dcUbpKfevs9nDQKmGAoA0Fn7UWUO5wxDvA8kogREHt/fKTc3Sk810Xy0A9PPNCCR
         GetFZdHsFWGv3jmtQzk837GQGzG4QZIo3rZOiF9Wdjef7ym2xjvQlYkOHND0Kh3IGGfY
         51worXaFizE4sf8hrhI3fuRRZ26cH2hD3ALVZ2S/kDAfXWJ7EpuG/xn1Bg8Rb/T268o2
         P06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=I5lBklmqYc584BHmMq417kVRATy/tYqlOxjeSvPEvDw=;
        b=MjVOEQJEdFn6hFaDdv1H3PqYFJN5kjRf4E5zVVUD9bvI9hBhvdBX+nUoF3+0hW+jke
         yuWwJFKaE51WwffUaz5vVLDyAnL5ghnrE2+HTJ7FkinDPITbbBYVPtLiBfA44gEKHO0A
         7QHI5c16fT6mlTkiFTLca3kbXEW4gq9dErns6IV1Y096fH3RRvm4C8krN8UROdUxq9NK
         fsMgzSwXKRAR6jUDlGo6XdZdnEg3TkCsBO+KRZCaMTd6emsXAVAjbDhNWlOvgQ0JlFz8
         1A8mS9f18XYxVepooprIlb8//kcGhkXWe5H0le2xv42gSl26dWkn+9gz/L5o1Es/hh71
         QWgQ==
X-Gm-Message-State: ACgBeo1nNWBeWQ5ZX/M9ATSymLLXeUzA9ag30INmKSutSKejO3NFRxFj
        QloAnrptTWRep5bHa+07VXJPWEVlIY2HLQ==
X-Google-Smtp-Source: AA6agR6eDffQzTnIdYSJutaqSW1tbXGbjR14in4lVZwiQCjlFNG4kfapAxl3dH+v586nj70P4u1txw==
X-Received: by 2002:a05:651c:230c:b0:25e:7295:5cd3 with SMTP id bi12-20020a05651c230c00b0025e72955cd3mr717241ljb.158.1660818583915;
        Thu, 18 Aug 2022 03:29:43 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id z10-20020a056512370a00b0048afa5daaf3sm171035lfr.123.2022.08.18.03.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 03:29:43 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [RFC net-next PATCH 0/3] net: dsa: mv88e6xxx: Add RMU support
Date:   Thu, 18 Aug 2022 12:29:21 +0200
Message-Id: <20220818102924.287719-1-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
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

The Marvell SOHO switches have the ability to receive and transmit                                                                                                    
Remote Management Frames (Frame2Reg) to the CPU through the                                                                                                           
switch attached network interface.                                                                                                                                    
These frames is handled by the Remote Management Unit (RMU) in                                                                                                        
the switch.                                                                                                                                                           
These frames can contain different payloads:                                                                                                                          
single switch register read and writes, daisy chained switch                                                                                                          
register read and writes, RMON/MIB dump/dump clear and ATU dump.                                                                                                      
The dump functions are very costly over MDIO but it's                                                                                                                 
only a couple of network packets via the RMU. Handling these                                                                                                          
operations via RMU instead of MDIO also relieves access                                                                                                               
contention on the MDIO bus.                                                                                                                                           
                                                                                                                                                                      
This request for comment series implements RMU layer 2 and                                                                                                            
layer 3 handling and also collecting RMON counters                                                                                                                    
through the RMU.                                                                                                                                                      
                                                                                                                                                                      
Next step could be to implement single read and writes but we've                                                                                                      
found that the gain to transfer this to RMU is neglible.                                                                                                              
                                                                                                                                                                      
Regards,                                                                                                                                                              
Mattias Forsblad                                                                                                                                                      

Mattias Forsblad (3):
  dsa: Add ability to handle RMU frames.
  mv88e6xxx: Implement remote management support (RMU)
  mv88e6xxx: rmon: Use RMU to collect rmon data.

 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    |  60 +++++--
 drivers/net/dsa/mv88e6xxx/chip.h    |  20 +++
 drivers/net/dsa/mv88e6xxx/global1.c |  84 +++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |   3 +
 drivers/net/dsa/mv88e6xxx/rmu.c     | 256 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/rmu.h     |  18 ++
 include/net/dsa.h                   |   7 +
 include/uapi/linux/if_ether.h       |   1 +
 net/dsa/tag_dsa.c                   | 102 ++++++++++-
 10 files changed, 536 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/rmu.h

-- 
2.25.1

