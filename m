Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C6B4F9230
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiDHJt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiDHJt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:49:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2B615A1C
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 02:47:54 -0700 (PDT)
From:   Benedikt Spranger <b.spranger@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649411273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/anPs7rSHhstT/Y3+yxCT5OJSR9EZRc/uQbiGZi1vXE=;
        b=qYtsKTliGpS3s/ylCKwe7u/wvGxZYmGcGkhqjF1/3Qy4b7V7BSco7cqhULvg/ZDBrICRm8
        e8ylrg3pqprUAtqPxHcs+lnXfQMQNlY6dbAkoTIxOh9idBZEz4gym2ozplNmaVa3wf7uEa
        eN1ccQDWdAAmx9PhH0rkc+3Tn2/ZzEnhpHMI4QZz4guhfYotJBBzTXRrnq2zPV+KYHO+6q
        p0AYaETxDGJWNkXskShKMO3lgOc/VpjMxcDIxYt22O8aAVbzl96Asl+BsBeFHXWeRPIrSy
        BCqjUbZqDnUAMoJlKIsZMh0FbvCGbDPIX9OILIS2IlYaMrAWKz/TfX7Ob6VpVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649411273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/anPs7rSHhstT/Y3+yxCT5OJSR9EZRc/uQbiGZi1vXE=;
        b=ZPoRQau3KY6bXV88DtGCelc3FA701S7XS3Ox2Fo364wAoh4lwO59mIpC9jGYCTtYkCuL9r
        VylQNP/utIvIGFAw==
To:     netdev@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH v2 0/1]  net/sched: taprio: Check if sk_flags are valid
Date:   Fri,  8 Apr 2022 11:47:44 +0200
Message-Id: <20220408094745.3129754-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing the software based scheduling of the taprio scheduler
new TCP connection failed to establish. Digging it down let to a missing
validity check in the enqueue function. Add the missing check.

v1..v2:
Fix a typo
Add a acked-by

Benedikt Spranger (1):
  net/sched: taprio: Check if socket flags are valid

 net/sched/sch_taprio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.20.1
