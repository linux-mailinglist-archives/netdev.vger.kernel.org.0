Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861314C43D7
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbiBYLqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbiBYLqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:46:48 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E8B1E149B;
        Fri, 25 Feb 2022 03:46:16 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id d23so8906772lfv.13;
        Fri, 25 Feb 2022 03:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=7bAU6OW5WZdNkadr0RsuhVpr6+vDWzdc54BoxnojpCk=;
        b=WnNnH2bNBx0UFGX9fwWjbhEHj3Q4ximEgZDZQqSJcGAUti2ZlGfn8S6G/ceffJxqVQ
         u3SMfefDopDk1kQaY/hbmm3ZjLkN71GKnfBqDBiO8lANOsEfdmCKPKdNlN0nOxTXRjlc
         nVUaoEKgYKPNjUGhIhu5MnbiXM08FLw64PeXmX/wJ/13BEljXfkSQmg8VWjqpXazrs6M
         kHNrdrObIuGYmE8nTZiizDEG9iVUNA4GRF9wv47leIrx2zE+NgbD5yZeLO98t4+IEoQM
         NXm/QtTw6BIafaMqRIJeC5iAiXqaWiHB6id0INibrc9jXZi2sBnXXkWeDqbckCgqkLor
         HJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=7bAU6OW5WZdNkadr0RsuhVpr6+vDWzdc54BoxnojpCk=;
        b=MUUxjDHU4sRvfckESRR2sWFa+jl3ytI1rRxFkBKHDv+9dSC94G9NbImwaNld8NCNkF
         5iO2gzu60xfU8HwojhxUyrWp9YaJjuaosAvP71Ah1eGhYIpaKfXY3LiOXSylggBLsqmH
         Ox8X6vOpW8uKBovocZjLRPt1JWuRRARU3d64Ldd3IUwZeLTZ24WPftwh2Hnl9n7RMowL
         nwjixWjy4F4JezF7LmoIYfMZvhTRPj57sj04pT+Qck4h+D8NGH3OcL9HWAZ8u6z1ynAu
         rhmgDiP5DNcLpVdFX5Br1iJ+I3Ftej0EMO07PIZPp3ka69Irus4u4+764ujCmgH32Cyu
         4AqQ==
X-Gm-Message-State: AOAM532MZmzQl9FQKICceqIDohb52pdu2hDq7BXsv2kcm/4mvyV4pJSG
        P/u4NAFYUNq/OlU0wkCDH/dvl0TBUwTXSKB0
X-Google-Smtp-Source: ABdhPJytaNv527bU1A5HJWtn+Q6koaojjpqaa6Q8UpXacLfroBuMI0B4S1i33usmNwuWZ2Ui2d3ijw==
X-Received: by 2002:a05:6512:304a:b0:445:9d7:dad4 with SMTP id b10-20020a056512304a00b0044509d7dad4mr4685783lfb.261.1645789574426;
        Fri, 25 Feb 2022 03:46:14 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id g7-20020a19e047000000b0044395c894d2sm184177lfj.163.2022.02.25.03.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 03:46:13 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH iproute2-next 0/1] Add support for locked bridge ports (for 802.1X)
Date:   Fri, 25 Feb 2022 12:44:56 +0100
Message-Id: <20220225114457.2386149-1-schultz.hans+netdev@gmail.com>
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

This patch set is to complement the kernel locked port patches, such
that iproute2 can be used to lock/unlock a port and check if a port
is locked or not. To lock or unlock a port use the command:

bridge link set dev DEV locked {on | off}


To show the detailed setting of a port, including if the locked flag is
enabled for the port(s), use the command:

bridge -d link show [dev DEV]


Hans Schultz (1):
  bridge: link: Add command to set port in locked mode

 bridge/link.c                | 13 +++++++++++++
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 14 insertions(+)

-- 
2.30.2

