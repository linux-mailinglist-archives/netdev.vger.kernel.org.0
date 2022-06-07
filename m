Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D684553F436
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 04:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiFGC6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 22:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiFGC54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 22:57:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E237663BE5
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 19:57:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a68-20020a25ca47000000b006605f788ff1so10611273ybg.16
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 19:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+HcB4uPeOC6EVrYwffcFKbWoUNRid7a6jmVL5oHbCWA=;
        b=fVQnjXkZlZzMnw0UgP084/Ik9g0PoTulGhE5guPKmDo8C6FpH5tXgJVQHxDFX7d7MZ
         1FQHbjQIolpi/m2j3m2V6aggDUIvDTjHsb8foqJS+2LOpAA98O19mlCKzwmDf0Y5G/fa
         xdtgGEz2YBZGipjxyk3QPdJLG6BJFXJsRkkIXLgeHe36CVhC8qAYJ93+F2vGbpqI+Ua4
         9xsS8fqGhIKEJfpCq1zcT5pSaYKjf4649QcZjBtDORCNaR+hs3uyIbBIGit7+Ja09gn4
         tfeFAkttjBdjojYKHVgTCDYxp6MqpIdaokSDsHPstH5FEblsIw09J1AQigdZwZu7E0XJ
         J34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+HcB4uPeOC6EVrYwffcFKbWoUNRid7a6jmVL5oHbCWA=;
        b=Ctzh2qrn+mCyqhf7HW0gMkRfouEY6HDm+zLZ11grcflylQAEd40ZcIghOqCMgUFmp8
         h9CUz94XgfS5CXkMAK5V/t0+cdWaEG6DxrvUWkBsri0BaDBCUPzpkbQOEHk116+fa241
         O1e6MQ89FP8QIZ6HaeoMa8yijKWOu/r0EsQRwEJaw+KmU5s1+5Uuyo38pwR/qK6xLIue
         Rddrcm6UrZ6khphZSYqxjJfxGooB5PZXK30Y5/m00cz5iW2BN1zpYb2NgHJ1VVm44hnB
         JlIoMm9jtT2XgNSr8e3qKYKM9X9zxTnPwwX6VxPoZwej8l7K+Irwbev+Z4QSxlWfGeR1
         mjPA==
X-Gm-Message-State: AOAM530bWKQYHFE5/5vJouNxjnRdL+8Q9+Gya+wyX8zqzS1pYIkQByq6
        N/U7kJJFDY9r2qU6IMh3c9kVAzK+33RCYPQ=
X-Google-Smtp-Source: ABdhPJyd/zmCuD3lSgiH8JAmQqehXcKAp8WOolwYM6cJ13TelB2udPjq5qRPUESpSulOoDrsZWc57FihK4ErICs=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a5b:f87:0:b0:64a:9aa6:e181 with SMTP id
 q7-20020a5b0f87000000b0064a9aa6e181mr28193802ybh.157.1654570674162; Mon, 06
 Jun 2022 19:57:54 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:57:26 -0500
Message-Id: <20220607025729.1673212-1-mfaltesek@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH net v3 0/3] Split "nfc: st21nfca: Refactor EVT_TRANSACTION"
 into 3
From:   Martin Faltesek <mfaltesek@google.com>
To:     kuba@kernel.org, krzysztof.kozlowski@linaro.org
Cc:     christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        mfaltesek@google.com, martin.faltesek@gmail.com,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        sameo@linux.intel.com, wklin@google.com, theflamefire89@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change log:

v2 -> v3:

1. v2 review comment: modified sender email to match SoB line.

2. v2 review comment: threading emails by using git send-email as
   recommended.

3. v2 review comment: added linux-nfc@lists.01.org. Tried to join
   list but no reply so not sure if this messages makes it through.

4. v1 review comment: use net style multi-line comments.
   This affected two multi-line comments in:
   1/3
   nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

5. added Cc: stable@vger.kernel.org in signoff area of each patch.

v1 -> v2:

   Split the original patch into 3 patches, so that each one solves
   a single issue. The original patch indicated 4 bugs, but two are
   so closely related that I feel it makes sense to keep them
   together.

   1/3
   nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION

   This is mentioned in v1 as #1.  It just changes logical AND to
   logical OR. The AND was rendering the check useless.

   2/3
   nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling

   This is from v1 #3.

   3/3
   nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

   This is from v1 #2 and #4
   Both are derived from the same bug, which is the incorrect calculation
   that buffer allocation size is skb->len - 2, so both should be combined.

   After these 3 patches are applied, the end result is the same as v1
   except:

   1. minor comment rewording.
   2. removed comments which felt superfluous explanations of obvious code.


v2: https://lore.kernel.org/netdev/20220401180939.2025819-1-mfaltesek@google.com/

v1: https://lore.kernel.org/netdev/20220329175431.3175472-1-mfaltesek@google.com/

Martin Faltesek (3):
  nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
  nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
  nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

 drivers/nfc/st21nfca/se.c | 53 ++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 23 deletions(-)


base-commit: b8d91399775c55162073bb2aca061ec42e3d4bc1
-- 
2.36.1.255.ge46751e96f-goog

