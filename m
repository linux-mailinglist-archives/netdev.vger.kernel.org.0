Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D116EB394
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 23:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjDUVZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 17:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjDUVZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 17:25:41 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAB5212F
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:40 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-38c0a331d3cso1529569b6e.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682112339; x=1684704339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+hXTdQ9Jr4MItfLQybJ0Eqp2vzcamZ9gkhQexjrdc+g=;
        b=nB1JNcmfD99pNyQg95BrotqGY04nyjdQqRV8nCV8kvX5WJxd1vKhknugHhU8Ky90Lm
         dz6+DzgnKURDdXTwItaZwkB9OzYY+Fo/aQG+ZE18G2FHgi9NZvHnS2f7WM5d5zbIwf+Y
         BZWFVClSQMgCyFNBpVyr/Uyii9GJthMnnKPx6SwVPdIzBUccm+FFnsh49b5m6PnxcSs8
         IMQrldacq8VIPkJOw5LxVfJnbaMP8V1BtmMTj7zmAYyMFhqcrxNusM2Awvp+Sg4ClQCZ
         v0U02bMadHiRf0rx2jucsOHvdjppN9RQjrDlLjDJw8CQWsV7XdagoPb976Ge3QMRdGuR
         ekyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682112339; x=1684704339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hXTdQ9Jr4MItfLQybJ0Eqp2vzcamZ9gkhQexjrdc+g=;
        b=Nuc/huw+hkTXXekBs8vf/TFMlhL8jJVuSATEToCBtjXh93ekMULbn3mdzL0OhB+pmV
         AURcCmZAmNOeqKBv4acCL/0h/P6uyzU5OQI5IZsVXwNG1hEBsxHoUi4KyRSiPEkZrH/P
         jJePfLVf1lNbtp+mt6SDocd7XHW7CGJe1KVOnnVYvULfD+IFPKKU2+h/C/64mz7TA7MT
         o5mgZtPNLsLaulI5aS6n4zi6sHIzjkKTRxndFOr8VTGa4mIYPxvORI65i25jBNiZXaPw
         rlX7IWD4SrqP2dj5fLZk3vTNUTpq0Q3inum1+b9A3BnFYeoNqtanovUbhgo5U63IfXG/
         nH/w==
X-Gm-Message-State: AAQBX9eGlZQNxmt/Pda6/bbm9699dSBXSVYUNVuaUtDNR2htc/IEoRO+
        q4X7ewZrWDVmha6GSS3YnmNlKlh5WJj5c0EMa/U=
X-Google-Smtp-Source: AKy350YpaPVLdm85px7LDrDF1neXY8i1eBmmFXFTQdM26b05TTy05WxvCqPqaAmoJXs6B7enLVZyuQ==
X-Received: by 2002:a54:418a:0:b0:38b:ef55:a513 with SMTP id 10-20020a54418a000000b0038bef55a513mr3505891oiy.20.1682112339254;
        Fri, 21 Apr 2023 14:25:39 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id j11-20020a4a888b000000b00524fe20aee5sm2147663ooa.34.2023.04.21.14.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 14:25:38 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 0/5] net/sched: act_pedit: minor improvements
Date:   Fri, 21 Apr 2023 18:25:12 -0300
Message-Id: <20230421212516.406726-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to improve the code and usability of act_pedit for
netlink users.

Patches 1-2 improves error reporting for extended keys parsing with extack.

Patch 3 checks the static offsets a priori on create/update. Currently,
this is done at the datapath for both static and runtime offsets.

Patch 4 removes a check from the datapath which is redundant since the
netlink parsing validates the key types.

Patch 5 changes the 'pr_info()' calls in the datapath to rate limited
versions.

v4->v5: Address suggestions by Jakub.
v3->v4: Break the old patch 1 into two patches.
v2->v3: Propagate nl_parse errors in patch 1 like the original version.
v1->v2: Added patch 3 to the series as discussed with Simon.

Pedro Tammela (5):
  net/sched: act_pedit: use NLA_POLICY for parsing 'ex' keys
  net/sched: act_pedit: use extack in 'ex' parsing errors
  net/sched: act_pedit: check static offsets a priori
  net/sched: act_pedit: remove extra check for key type
  net/sched: act_pedit: rate limit datapath messages

 net/sched/act_pedit.c | 85 ++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 45 deletions(-)

-- 
2.34.1

