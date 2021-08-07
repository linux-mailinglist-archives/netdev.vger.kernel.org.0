Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9888F3E353C
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 14:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhHGMH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 08:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhHGMH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 08:07:56 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67633C0613CF;
        Sat,  7 Aug 2021 05:07:39 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id k2so10815375plk.13;
        Sat, 07 Aug 2021 05:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jAVoldUheEUiD6b/stC75KzqDH8ZrnpNCAaWf03y9zA=;
        b=iYmKbO3O5hTxp4cRkETOl7U8CipmFi2HVhVGYLITh4AHzS5OP8fv8u6rge0ppFanlv
         kIH9+esi9Htlv9SrsChkOZkOZmzkVlBT9r+jrGnzNeCqJOpEyX+0qazw35zQcvF6lxvm
         kzp47MiRs8QnZ/VjLnZ/3LH+OaYVgBAsIBjRZvbNaRCFjlJL8XPv4k/5AX0bzsgXAtl+
         IGG7uB4kMeJYOx22PFSe3KynHJ1lB7gZVh5zT8mVYZhf14mLfhZ3rKTK/2mod2iWdxeL
         JT+buAwMI7U1OKXswSBJy32OETAVoojOwPTHGX8REoA7FF9KQaq44pyDbjV3PSaulj3L
         LbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jAVoldUheEUiD6b/stC75KzqDH8ZrnpNCAaWf03y9zA=;
        b=ZWAERNaQ5eMujIvOYeblJy9O0F1yQAeP/suzekScpxBh3EcMRNnZBwf07MSgoSXKod
         OEI78eruB5/2jaeQ7+bLXg02OBySMJgJ9LBCEsPMlX3iN9mTtLfr6+FKKD2UqweG3XRb
         bdojKjMsTt6R/G6N+yUy/gLp9PqkW5Ndmi2as7bKpkCMoiStb/Cx0l9gtAxI/ldz4d1N
         PbyEGpi+N0lQEWi78E0yMSIbVEJ/Q9HIRAoOwHbnU/kzeL7QG5dA5uyz4iaB/f794GBG
         E2DRMKWOagbG0s+tTk8u1Y8cLozkF+tKc4g5DJyA0dcwDP7PtaP7AnCs3HzPQBy5JnFX
         cyPQ==
X-Gm-Message-State: AOAM531iAUzxuZ/tjWga5lsFbjlcqvMZifx6IfjOoRvODGGFG271/rUW
        1MDxfXplUVizlVXNCKxwTR8=
X-Google-Smtp-Source: ABdhPJyj6aDc+HR4Lokm9MmRKnrdFb+3EIvYKk59LbzgXHie5uJFiK1MAplCBLxEFhNmEYYxFo9zTA==
X-Received: by 2002:a65:5ace:: with SMTP id d14mr451586pgt.235.1628338058942;
        Sat, 07 Aug 2021 05:07:38 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id b15sm16471035pgj.60.2021.08.07.05.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 05:07:38 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <vokac.m@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Xiaofei Shen <xiaofeis@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Hannu Nyman <hannu.nyman@iki.fi>,
        Imran Khan <gururug@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Nick Lowe <nick.lowe@gmail.com>,
        =?UTF-8?q?Andr=C3=A9=20Valentin?= <avalentin@vmh.kalnet.hooya.de>
Subject: [RFC net-next 0/3] qca8k bridge flags offload
Date:   Sat,  7 Aug 2021 20:07:23 +0800
Message-Id: <20210807120726.1063225-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bridge flags support for qca8k.

RFC: This is only compile-tested. Anyone who has the hardware, please
test this and provide Tested-by tags. Thanks.

DENG Qingfang (3):
  net: dsa: qca8k: offload bridge flags
  net: dsa: qca8k: enable assisted learning on CPU port
  net: dsa: tag_qca: set offload_fwd_mark

 drivers/net/dsa/qca8k.c | 62 +++++++++++++++++++++++++++++++++++------
 net/dsa/tag_qca.c       | 11 +++++++-
 2 files changed, 64 insertions(+), 9 deletions(-)

-- 
2.25.1

