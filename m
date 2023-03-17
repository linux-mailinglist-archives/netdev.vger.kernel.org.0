Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2149A6BF219
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCQUGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCQUGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:06:04 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DD2C9C94
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:00 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-17aeb49429eso6587350fac.6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679083559;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mUa8r2T4GjEcVXNKxTZoelOg1vCQoZfOI92HN/7lmeI=;
        b=6S2Bd7fC0ufdE6cKCeQaCecEJ1vgWLkTpr0aeTfB7OWY7A1yPwsrLGPwLTk23Xaz/n
         9r5lMcetNoUP5pePKSwmhahKtFaNkBP+36lV9FmI4lMObvEBmPmhKO9OqyNt2KD+8Whf
         Z8RRJogBIoJbfPCO0OuyN9UCmzaas12rSC4dJ0Q4JPJqbv3sKwmm+Rya0p+MtI00zGhV
         oeon5aB41/9tmy6vIO1hb3DRYixqFPzG78R6/t6gjJlwdxDv7SLiTZmCmi55CyU2a9Eg
         hfWzYl5iVKnXDwcV20NSuSLq2KxoEeWAUCMeqXKN0JVhoBjIUzlJTx4qohEdXSaoAtxB
         WBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679083559;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mUa8r2T4GjEcVXNKxTZoelOg1vCQoZfOI92HN/7lmeI=;
        b=0EvtgeWlLM6vK2KXqcKxGY55ldQuqyca8MeJIPGxl+SeqjiSg08Fwk4z/qA0rWuYty
         lNgh3718Fmgq0F4kOxXfaLIkFqy+i2wA7hcrEDOy/Jvng/f7q7q0dWR0bICsXeFAtfOF
         BhuCnmN503RhrttzvwcQTv4eud80K4pGcIQ9jARvK6zEPW9VB2oAHXbD4nUCvHC5KYjE
         3oD6x/Lg1WgGTwpVtHJ1D8aieYQ1lufD1G3xWYw4ZBv/GKBjXIupHqONjUUAeQ7AYDGY
         TVAlghbue6YzhIaFZZw2Ys+jhfTbxobKvdn0EojILbfrsl9hx5e/FaafK7UKZzo6+E/j
         K3Rg==
X-Gm-Message-State: AO0yUKXi/fd6GBDq+g+/9lPUoZaSV3d9gjoivUrGcfop2CJtQHqRc4aT
        hcP5pRCkQ63Vc1kM/sp9Ff8atiVhXtPdWeGHclQ=
X-Google-Smtp-Source: AK7set8X4E8THFevvztf6iApRSeMHKwtgxXaBYFY+t/K0ITPyrDeDQZBkBeniI+ehI5abyeC7PRKIQ==
X-Received: by 2002:a05:6870:5705:b0:177:dfdb:63 with SMTP id k5-20020a056870570500b00177dfdb0063mr528703oap.44.1679083559727;
        Fri, 17 Mar 2023 13:05:59 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:10c1:4b9b:b369:bda2])
        by smtp.gmail.com with ESMTPSA id z8-20020a056830128800b00698a88cfad1sm1304209otp.68.2023.03.17.13.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 13:05:59 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 0/4] net/sched: act_pedit: minor improvements
Date:   Fri, 17 Mar 2023 16:51:31 -0300
Message-Id: <20230317195135.1142050-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to improve the code and usability of act_pedit for
netlink users.

Patch 1 improves error reporting for extended keys parsing with extack.
While at it, do a minor refactor on error handling.

Patch 2 checks the static offsets a priori on create/update. Currently,
this is done at the datapath for both static and runtime offsets.

Patch 3 removes a check from the datapath which is redundant since the
netlink parsing validates the key types.

Patch 4 changes the 'pr_info()' calls in the datapath to rate limited
versions.

v2->v3: Propagate nl_parse errors in patch 1 like the original version.
v1->v2: Added patch 3 to the series as discussed with Simon.

Pedro Tammela (4):
  net/sched: act_pedit: use extack in 'ex' parsing errors
  net/sched: act_pedit: check static offsets a priori
  net/sched: act_pedit: remove extra check for key type
  net/sched: act_pedit: rate limit datapath messages

 net/sched/act_pedit.c | 75 ++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 43 deletions(-)

-- 
2.34.1

