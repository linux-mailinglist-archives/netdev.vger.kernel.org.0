Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1F94A8B1C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiBCSCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiBCSCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:02:31 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8097C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:02:31 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e16so2918076pgn.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 10:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fegx6jsHKu4fnIOhbA+RVC1oTU5fsawOdCXT0HxGqdg=;
        b=osXa+j0AJ76fah0WNHoCoAoP752AuvC2imCAJWMPAqQN0Z1IjN88NvytTnn4TC/nOA
         ngd3nOC7X/A+DG1fWe1pvBdPvpfVtjqIuZKYRkVh/NaGwhbRDNxyXv9UU49gvausdtfg
         qw9W0Fe1iNupezB23UI6ZYn0Bn7U9bsSfNIao/6QlgImDTGp36f5aHLU+qk6o3odvDgF
         uAMpAOAHzJYIWlljoRDDblga1C0FtMsX15zw20JpbX3yPUOKKUuh9JzQLqsxDBbZH5cM
         B6gB0OzxhiWD8nvFXDjeUFt/wsRdup331JlxP09c9oEGOStPLeZYefnDwGIyuCPuWYF0
         0Y+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fegx6jsHKu4fnIOhbA+RVC1oTU5fsawOdCXT0HxGqdg=;
        b=09VoOA3317cL0is1XSlLdDBD3uKP2rnyBPncSZ8qnhbalCrqJ530dEH9QNv3kGBORF
         yIdvgCMEgp5BNoAbvrROwWLWLbzPnZuolTBeIVF7CTjJqaEDurhI99EpCYu6rnBNFGoc
         wOnRXEQgJfw/LahsnsBE6Y3NmlgCDojdW9DKDpykKg8GK/9W1BCZNTjtq7kwdDq3o7ei
         d/TX43ALMkXSfktjKaXrCz0eLbBDjfmYY8k7LgATUfLEqAE5NIItgzSCMExZ8KZTptPU
         R6PYdf0NTUXLGzSZEyQ1y3rBfroXXsF+ECAvwVts/Bkb5pUGkBVBRyZ5JkAWHZkkfTiS
         3NfQ==
X-Gm-Message-State: AOAM533mz3J1s+dNYfzWRY1zfgPZeMtnaP818GxNXpv+fb2cB9MdhTDZ
        e+gIyH48lxB8lR62mTWBU8k=
X-Google-Smtp-Source: ABdhPJyKs3RaV3aB+PRik8ett6C6U3usYx9AwP7I7fU/bKqOsybATFxWEK2zcnSeXlrgaXgwx2jI+A==
X-Received: by 2002:a05:6a00:1513:: with SMTP id q19mr35072808pfu.12.1643911351350;
        Thu, 03 Feb 2022 10:02:31 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b3be:296f:182e:18d5])
        by smtp.gmail.com with ESMTPSA id ms14sm10702487pjb.15.2022.02.03.10.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:02:31 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] net: remove two MAX_SKB_FRAGS dependencies
Date:   Thu,  3 Feb 2022 10:02:25 -0800
Message-Id: <20220203180227.3751784-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

My first series for BIG TCP met two issues that various bots pointed out,
because of MAX_SKB_FRAGS going from 17 to 45.

- typhoon driver would emit a compile error if MAX_SKB_FRAGS > 32

- include/linux/skmsg.h had a similar issue when MAX_SKB_FRAGS is
slightly over BITS_PER_LONG, so the build broke on 32bit arches.

This patch series is meant to be merged before BIG TCP one,
in order to keep the latter not too big.

Eric Dumazet (2):
  net: typhoon: implement ndo_features_check method
  skmsg: convert struct sk_msg_sg::copy to a bitmap

 drivers/net/ethernet/3com/typhoon.c | 23 ++++++++++++++++++-----
 include/linux/skmsg.h               | 11 +++++------
 net/core/filter.c                   |  4 ++--
 3 files changed, 25 insertions(+), 13 deletions(-)

-- 
2.35.0.263.gb82422642f-goog

