Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F399E6B86F9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCNAgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCNAg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:36:28 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AEE7EA24;
        Mon, 13 Mar 2023 17:36:16 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d7so15136834qtr.12;
        Mon, 13 Mar 2023 17:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678754176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XhfIn2HcwqtkizAMvb7UpCgDBNvQEGGusrAkHrnQFYk=;
        b=gazA4rmxDuGY7o1Qrj9Gb+ii3zIY2n/j4mRvZyJmNoiV/e+q/Voe7z1olpJlNmMF58
         vHGmKpj//qpkkjjKYmeCp3WdK4KYi5BQVFAdte8/7X/HBlpcJSQQVVN84XfnoNfXMGIa
         kx29is3e48zIpydD1zNs1ix7hk42Gc10XFwhEt9QldUATBT7YodcTj2JGGAQoyr5hGdp
         fIx3nUo4ziu457UfcpyqkefylhB56Pjg7t8YYVOh12hbGtdRmN2VSva7oOi8PFEZrpEd
         FVDbhsyS7BzSdhdfW94n/mv8cGkWzcQndIqI3ur4VN6Mg+fX8vs1/8poZaxBebEoGy2B
         cKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XhfIn2HcwqtkizAMvb7UpCgDBNvQEGGusrAkHrnQFYk=;
        b=4bKlzOdKnmgDQrbMHvelk1vZfHSi+JqCPM0ZvuV0Wh8fZFeD17OzD2bTbGu4MYU/K1
         1uopuzv1TW28CVEI2bfH8/7xYtPT2rBJ6iauRB/WCMUUvH1vlEmxnTJ5VDPc9ENBMlrm
         Y5g/Kvs/j4B6xcBOqwK2gMG6GUaJ0bTs63Q2IP28M5ZbxksTL9yIsr3fRPYutdIpSppD
         gEgETfHmm/rFcmL5LeWGeCIvov1S+Dj8n+T+T9SNZhmuyaOfoCp8Qt+aWfL4S+QdydfC
         K0dD4/MOVXGeakkz1O0tHTYDuis2UJptl8XAX/CWGrz6TWNmVj9hvNwz616FptrcvA5M
         TRXQ==
X-Gm-Message-State: AO0yUKUcgdNvkhWYyX49JR60pSf08kerP0NkROKJWEEFEhSf39TNZ6iU
        JeXuY3t2aJH2n7N2rJnh9hYXpUzZKciTgw==
X-Google-Smtp-Source: AK7set/HiNgJbX931LFgYaaYVLqwynKhnSSWm2Gp8Qogkh3VEwWYEme5npo5FkjQqUkcrT/rfYddTw==
X-Received: by 2002:ac8:5a55:0:b0:3b8:49bb:16c3 with SMTP id o21-20020ac85a55000000b003b849bb16c3mr55302737qta.28.1678754175889;
        Mon, 13 Mar 2023 17:36:15 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id t190-20020a37aac7000000b0071a291f0a4asm724621qke.27.2023.03.13.17.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:36:15 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        debian-sparc@lists.debian.org, rescue@sunhelp.org, sparc@gentoo.org
Subject: [PATCH net-next v3 0/9] net: sunhme: Probe/IRQ cleanups
Date:   Mon, 13 Mar 2023 20:36:04 -0400
Message-Id: <20230314003613.3874089-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Well, I've had these patches kicking around in my tree since last October, so I
guess I had better get around to posting them. This series is mainly a
cleanup/consolidation of the probe process, with some interrupt changes as well.
Some of these changes are SBUS- (AKA SPARC-) specific, so this should really get
some testing there as well to ensure nothing breaks. I've CC'd a few SPARC
mailing lists in hopes that someone there can try this out. I also have an SBUS
card I ordered by mistake if anyone has a SPARC computer but lacks this card.

I had originally planned on adding phylib support to this driver in the hopes of
being able to use real phy drivers, but I don't think I'm going to end up doing
that. I wanted to be able to use an external (homegrown) phy, but as it turns
out you can't buy MII cables in $CURRENTYEAR for under $250 a pop, and even if
you could get them you can't buy the connectors either. Oh well...

Changes in v3:
- Incorporate a fix from another series into this commit

Changes in v2:
- Move happy_meal_begin_auto_negotiation earlier and remove forward declaration
- Make some more includes common
- Clean up mac address init
- Inline error returns

Sean Anderson (9):
  net: sunhme: Just restart autonegotiation if we can't bring the link
    up
  net: sunhme: Remove residual polling code
  net: sunhme: Unify IRQ requesting
  net: sunhme: Alphabetize includes
  net: sunhme: Switch SBUS to devres
  net: sunhme: Consolidate mac address initialization
  net: sunhme: Clean up mac address init
  net: sunhme: Inline error returns
  net: sunhme: Consolidate common probe tasks

 drivers/net/ethernet/sun/sunhme.c | 1161 ++++++++++-------------------
 drivers/net/ethernet/sun/sunhme.h |    6 +-
 2 files changed, 415 insertions(+), 752 deletions(-)

-- 
2.37.1

