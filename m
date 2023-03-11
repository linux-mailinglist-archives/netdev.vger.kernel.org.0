Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957D36B5F9E
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCKSTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCKSTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:19:09 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0061F49F;
        Sat, 11 Mar 2023 10:19:08 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id jl13so1818862qvb.10;
        Sat, 11 Mar 2023 10:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RMZGrPODSIOb3921q/lDe96unBuatGCSfhF0skqfLCg=;
        b=DK1XCJ4DSITOVUXNY4MHm9kg2df/23r3G0dqcCpIJCs7C1bgM8xRMz9W8odLAQ9GLE
         PdOQQmgo6dxtc0LNA4sDLtszDbQSpDZNOSptpTUamz/6slaL9g1/8mtHJX+yMSiifV5D
         uzRvdJyJBxFTrIJ2rRALApsC8lCwgoPvt5omakiq13nTyV2Giuhi5Ct0k6f7RUpnraoN
         hIStM8rBOP676sHwPykmvFSd3lfG6ROwlqtVzF2kVEt8q1g4qS7BZ/aYOJHUC8gLqaeR
         E1mjtizBd0iQ7V7EwossZvxZEGAEwcrgTz8Bc0utVI5sVJHj+hPeFdT3O+HF2JpQcgrR
         Wnhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RMZGrPODSIOb3921q/lDe96unBuatGCSfhF0skqfLCg=;
        b=kQiD/tcK4hDGITJDsth8sqTivYeRUOr2klNHGGrM5mFVHZwdrSZoB11ja0TCRVZ06q
         Btk9acW1YnjfaO/WE39dIGYmI7A7z6ocuU6tYbuEw64B2vJYm7WeqhIfl0P0I151jU+E
         dnXKbhFPp8tQdq3FZpwtCw/IK9f9iM7wGMydymTPVpgDQU16LZdo0YeHl2rbys+AIZV4
         UMR+21AZlCTZsvQ6rUTVMZ2cP1/GOexxqVkVLSramwPz0E54bKSk44t/F1q3SjmePS4r
         nhpbLOcMfRL1E9QTYoXagAX0XgI0NOitmPPzOUTqe63XBRVFG3RBSO88ffWLv6vFqG/d
         iI/Q==
X-Gm-Message-State: AO0yUKUuxql2dJkOLUgWwJiXdLht6Jso9ijwlhWnfDKetHDaf94DDLdk
        3eMZznw924ndS/NZ/oMkpi8=
X-Google-Smtp-Source: AK7set8VvXNhLFG2eOwSj7Rs9IMZ0cmazwVrYEdiElYGeQZqGHlmW9u8j906MKFKfug4azZTVa7iOw==
X-Received: by 2002:ad4:5962:0:b0:56e:9c11:651e with SMTP id eq2-20020ad45962000000b0056e9c11651emr5955058qvb.27.1678558747979;
        Sat, 11 Mar 2023 10:19:07 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id 127-20020a370485000000b00741b312c899sm1945360qke.6.2023.03.11.10.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:19:07 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Sean Anderson <seanga2@gmail.com>,
        debian-sparc@lists.debian.org, rescue@sunhelp.org, sparc@gentoo.org
Subject: [PATCH net-next v2 0/9] net: sunhme: Probe/IRQ cleanups
Date:   Sat, 11 Mar 2023 13:18:56 -0500
Message-Id: <20230311181905.3593904-1-seanga2@gmail.com>
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

 drivers/net/ethernet/sun/sunhme.c | 1162 ++++++++++-------------------
 drivers/net/ethernet/sun/sunhme.h |    6 +-
 2 files changed, 415 insertions(+), 753 deletions(-)

-- 
2.37.1

