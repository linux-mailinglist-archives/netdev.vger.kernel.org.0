Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D976E53E6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDQVcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjDQVcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:32:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EB24C3B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:46 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id xi5so67916910ejb.13
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1681767164; x=1684359164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=fJ+r+I2Yz9XcEGeDuZ1h0EMLgpcCZeatorwQT2A55fA=;
        b=X3CJnNSKMprrTEka2qfQ0nQBn7CYdIIr2V0kGa5KGBaYIdc6oK8Fv9s5Gdq0zacrH3
         Eh7KIHY4ilUOxGu8U8c9QsfB5AfIXBt9iyELkY7Oya9CeFIdqRZ8fHDkUzfWzVAM5p0J
         /Edc0AUo2U1ZDzgo2Sm2tdJn8mb2Kb5ewXGnPV6WP7TVRW/wEi0/Fos2TtC9uJ653Zr0
         MstfDsceXO+vd+kxd5gwFZe8mJQVcfe0+Eo3GT+yuZdrLRWtXKeZrusTCb75fwsaODat
         xRVGx8aj44BTP6BsyleTcZ6PtDbFJVFmocg5Jbrbkcm97yzUvlKhLjYTcRg6nhu1vlkm
         eN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681767164; x=1684359164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fJ+r+I2Yz9XcEGeDuZ1h0EMLgpcCZeatorwQT2A55fA=;
        b=PELyuL0hXNQshz7zvbssNFUlOZGI7BT1O2dSIr0257kLn3Y2aToIyhFphBMevv1K7C
         68vHosE1ks4/1USFHyjK/R3F1ZPE8sHv8BF+1zoy9JBrxQo6tQIJqFiUdP++q0EiqnLc
         eUV0pjiaIN+X5nGz9JC6Qc50enJjmyiHsGUSj6fxXe78pzITxlCTv2scGT4h2ikX9SeJ
         4g9LHUxloc+VS+3EIqtb9ZyPePQAmB8d57ogBLQo9q4XfzBMnNlJ+YY3KOZnr70FAMzq
         PtqeAhG85fikLRt0LwnfTykOP5Ctb6FPdI6FvHV+TR3L1e6p1HH95hu8WttZ4QKSZzf/
         2wxQ==
X-Gm-Message-State: AAQBX9fCU+StGoXBqHfOy1jWLtnd3/Cg2JY/PAam93SsgbFDGaNmBl4x
        7Sr/Mi9tRgK3pElKbXIDHphiUWkNm+L+cmcX
X-Google-Smtp-Source: AKy350apLFMKjMFCepRGotRMfYS/g3h4HJStrXORIvqBVY8TwKCUTAUIR9h8+A5vwPA6RSvDlBeEvA==
X-Received: by 2002:a17:907:77d5:b0:94e:f738:514f with SMTP id kz21-20020a17090777d500b0094ef738514fmr8656965ejc.13.1681767164573;
        Mon, 17 Apr 2023 14:32:44 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id k18-20020a17090632d200b0094f05fee9d3sm4670005ejk.211.2023.04.17.14.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 14:32:44 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v3 0/3] net: flower: add cfm support
Date:   Mon, 17 Apr 2023 23:32:30 +0200
Message-Id: <20230417213233.525380-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zahari Doychev <zdoychev@maxlinear.com>

The first patch adds cfm support to the flow dissector.
The second adds the flower classifier support.
The third adds a selftest for the flower cfm functionality.

iproute2 changes will come in follow up patches.

---
v2->v3
 - split the flow dissector and flower changes in separate patches
 - use bit field macros
 - copy separately each cfm key field

v1->v2:
 - add missing comments
 - improve cfm packet dissection
 - move defines to header file
 - fix code formatting
 - remove unneeded attribute defines

rfc->v1:
 - add selftest to the makefile TEST_PROGS.

Zahari Doychev (3):
  net: flow_dissector: add support for cfm packets
  net: flower: add support for matching cfm fields
  selftests: net: add tc flower cfm test

 include/net/flow_dissector.h                  |  20 ++
 include/uapi/linux/pkt_cls.h                  |   9 +
 net/core/flow_dissector.c                     |  30 +++
 net/sched/cls_flower.c                        | 109 ++++++++++-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 175 ++++++++++++++++++
 6 files changed, 343 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

-- 
2.40.0

