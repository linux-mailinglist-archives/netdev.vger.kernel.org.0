Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E834EF98A
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350398AbiDASLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiDASLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:11:33 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5478612D0BC
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:09:43 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id g21so4066040iom.13
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 11:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8BasHDJmeArzjSMC9kKCeGI8h7iYn9uLf8jNh9tS/tc=;
        b=XfMUYgsccnpWJD1BwGNUd6DXhbyEe1nVARfYRAlju98Ec2yFNh87p46/kStzbr5R6J
         /FMTFCq0LqS8uVZ5DZLdIvwBxq+D4RyaJq364KxC4g0gxNP2OeckxIC8YbaERkT5xwCt
         eh9dsOJhatmhra5WtXna87+2DcM6eXFJsjLDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8BasHDJmeArzjSMC9kKCeGI8h7iYn9uLf8jNh9tS/tc=;
        b=nSVioWUpi6yHr5kBF5484dFYEX6Q7+7ISu8rNiTc/3l7vHo/Y8+IB0xsQNkeSK81n4
         AR6TCrBxN3oNsbPrlypGA7SP4qWDRMKyyi3WhUNUGH+5OUOaNZLfqq+tOiNyX2OiB/ZP
         18tzDKqsXg9Xw6t4DmYAxZs4r97yMn8RuT98Gh18miEvSeW9XoEW8bLem2Pg/j7q99x9
         mBR02Eg2MCsBh3qrxae8mFtQAcViC6luatpYbIC+Eh1vXhImuj6tB8ztdhiDE/hD91Vl
         10c9gTrkk4UJdRh8/1OHCW8VypeYKpuutVgd5rIBsqeXOpRncjgbLRnWgQ/2DtN3o3GS
         Pa8w==
X-Gm-Message-State: AOAM532jmttIjss/0OXuJK4FKsqRs0VrcwcBn9BwYxRfFWdshQx9KsMC
        aQpQH91ANCZfeJXHod6lgVKpw5ZI9MDUbA==
X-Google-Smtp-Source: ABdhPJxhEFKlRxRulh+73VjHzVIdvpe1RQrxtSKHDKJ2UG0UQYaWyeTjApBY2WNilIxR/X4q43MLZQ==
X-Received: by 2002:a02:ce91:0:b0:323:6d4a:484a with SMTP id y17-20020a02ce91000000b003236d4a484amr6425972jaq.311.1648836582606;
        Fri, 01 Apr 2022 11:09:42 -0700 (PDT)
Received: from sunset.corp.google.com (110.41.72.34.bc.googleusercontent.com. [34.72.41.110])
        by smtp.gmail.com with ESMTPSA id s10-20020a6b740a000000b006413d13477dsm1770656iog.33.2022.04.01.11.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 11:09:42 -0700 (PDT)
From:   Martin Faltesek <mfaltesek@chromium.org>
X-Google-Original-From: Martin Faltesek <mfaltesek@google.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, krzk@kernel.org,
        christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 0/3] Split "nfc: st21nfca: Refactor EVT_TRANSACTION" into 3
Date:   Fri,  1 Apr 2022 13:09:39 -0500
Message-Id: <20220401180939.2025819-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
        -- Split the original patch into 3 patches, so that each one solves
           a single issue. The original patch indicated 4 bugs, but two are
           so closely related that I feel it makes sense to keep them
           together.

        -- 1/3
           nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION

           This is mentioned in v1 as #1.  It just changes logical AND to
           logical OR. The AND was rendering the check useless.

        -- 2/3
           nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling

           This is from v1 #3.

        -- 3/3
           nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

           This is from v1 #2 and #4
           Both are derived from the same bug, which is the incorrect calculation
           that buffer allocation size is skb->len - 2, so both should be combined.

        After these 3 patches are applied, the end result is the same as v1
        except:

        -- minor comment rewording.
        -- removed some comments which felt superfluous explanations of
           obvious code.

Martin Faltesek (3):
  nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
  nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
  nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

 drivers/nfc/st21nfca/se.c | 51 +++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 21 deletions(-)


base-commit: e8b767f5e04097aaedcd6e06e2270f9fe5282696
-- 
2.35.1.1094.g7c7d902a7c-goog

