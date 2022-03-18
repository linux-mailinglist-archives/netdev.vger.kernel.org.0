Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8BF4DDB9D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 15:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbiCRO1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 10:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiCRO1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 10:27:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01A9130192
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 07:25:43 -0700 (PDT)
From:   Benedikt Spranger <b.spranger@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647613541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gf72e0+pk6HdW4V6jGJeSynFbn3Nl77ge6E0pYHdiDg=;
        b=F2/2RRAembfntqOFViQGROnULBM32asPaB+gjUpLFZ9ePf2pLCx50FGL/HuSr65aU0sQYq
        vtcs89rSvDaScrAn7YLvrrM4RpQp5UMa1kJagwMf6Ct9uF40h9HKU6VgtnCQn3Vu6cQCeI
        TkZNiqdO2ow4stWCceri4YwYaoBPul0hCRGxBlrJrF+7ugaB8eDB2Nd5OKy4nEs40X90OE
        KFGvgadtuPS6yoXvARjZyy9TWBoRMEBWwRVP6hLRdh6EjIjbSMOtB5q/QwSPipipSwMr/t
        dAHG+bXGZmkheyVKBN7/Gt5IPbTKrCOJODpmZp+3u/eVmnELP26UjTWbuy8EvA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647613541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gf72e0+pk6HdW4V6jGJeSynFbn3Nl77ge6E0pYHdiDg=;
        b=DUp0aTOHVtYiIsPdYlCFKOOPAR3Sd4/+GDxntVW6GCBLeNLFHQm0+XVp5Mxdl+0+V+8yuT
        V2++8kMYgy7q3eBA==
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/1] net/sched: taprio: Check if sk_flags are valid
Date:   Fri, 18 Mar 2022 15:25:31 +0100
Message-Id: <20220318142532.313226-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing the software based scheduling of the taprio scheduler
new TCP connection failed to establish. Digging it down let to a missing
validity check in the enqueue function. Add the missing check.

Benedikt Spranger (1):
  net/sched: taprio: Check if socket flags are valid

 net/sched/sch_taprio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.20.1

