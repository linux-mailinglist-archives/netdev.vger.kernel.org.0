Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99486EE97B
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbjDYVQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjDYVQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:16:44 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7021713
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:16:43 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5058181d58dso11238396a12.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1682457402; x=1685049402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=g8ldVBA8gmmw2ljyE1YJyFBN+bqDsE8on7fLjwKIEIc=;
        b=idl03Mz+0kkNNZqr+4QDz3tb3LzJ+mooseR8WFVPvKH2lnGlOYApUPy7VCxDCtu1FU
         6YluQ7vFP0sWhd3ufLLFuMjoEchM0UPBzb/YiWPT1NxbP0MJ8pB+BYqNrYczY3ZCkTY3
         1KN3wwOuZ9eCac5JCLdd4mC5End6xfn7yPeoPkqFK7Z3HxFJ53pZgEdaduQsg6j15WKb
         g/smfzxUVevK2HVg63fwy+PrPbCkOXroHwVRNUO9XZE2CRfnHHFTSaw+WdJ7XYwW9+Fg
         paQWBU9R0INCExV0f/yJcN2zbd5QcuydGSrnqi2nAsd3d3QfLpIFLc3ZIUcKEaCQcSvT
         5weg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682457402; x=1685049402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8ldVBA8gmmw2ljyE1YJyFBN+bqDsE8on7fLjwKIEIc=;
        b=f92FYKY1wwzMiluLy2jUKDQkHMthpk7HHSZnVQNK2DPq7tYYLKhl+qzc8AnM4J+qnh
         sJClzbnZqDvFW55l3qxhC3Iqf6y4pfQ8y+TiydR3ag4SPvqY/J341gsrKfgoN52IhnSO
         NI04otb253Op/4EalzBFB8N3DNvEyb+Vy9MVMGWCpKrsJ5lyvAB6q41kU5ZCEBYCjMLx
         vBvi4O1TEskemd9YndIqesTNQkbAdgYW8AVaROzqgI9qdObD/rBipDOGgeVGAStbyxIV
         60TQz9cWbxjiXe05vX4AFP0V5V7sFs/4h2ob8Q2JFn7t+zC4+kKgVKTN1k2tA4dZItSy
         fJ8w==
X-Gm-Message-State: AAQBX9d2e6FOsKi4x09CnW/gVTeeq03tebGodp2ykR1Jqb9VXr42KTC5
        Su9raf3GNjtvYrd6bSSEQwMSYwInUI32mQ==
X-Google-Smtp-Source: AKy350ZYJ7FS4VnNm1JaJBcUh9pAHNFHyURZ757HpF/kJMAaUDv9PzMPTRMG3D6QrChthU4myuOHVw==
X-Received: by 2002:a17:906:368f:b0:953:5ff7:7753 with SMTP id a15-20020a170906368f00b009535ff77753mr14019571ejc.11.1682457401727;
        Tue, 25 Apr 2023 14:16:41 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id bv7-20020a170907934700b00959c6cb82basm2302896ejc.105.2023.04.25.14.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 14:16:41 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        idosch@idosch.org, Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v4 0/3] net: flower: add cfm support
Date:   Tue, 25 Apr 2023 23:16:27 +0200
Message-Id: <20230425211630.698373-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
v3->v4
 - use correct size in memchr_inv()
 - remove md level range check and use NLA_POLICY_MAX

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
 net/sched/cls_flower.c                        | 103 ++++++++++-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 175 ++++++++++++++++++
 6 files changed, 337 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

-- 
2.40.0

