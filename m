Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A34F572FD0
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbiGMH6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiGMH6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:58:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E256DDF389;
        Wed, 13 Jul 2022 00:58:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id b8so9522781pjo.5;
        Wed, 13 Jul 2022 00:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=itk4b7NI3cUu3jWtxKH1xulHC15KgYDHmxRNmYEuEag=;
        b=cQqpDFouGoelXK+51mWiEyy4aEqiZ1PTeTmzjbIJXULZsc55Hbhisz/JLHfIreC8JU
         FlMILCQc2lWfedW7qPP+6KWG7af3vv0zWWGIKRUqeaVAhV5ZrPZCfQIQTfCoTxDxDXUo
         xyKrWQ/YoLnC1oEHX7AZmG6ZE9gEt2oX5M+aQebEF6tDkh+t+6XmViv8Fz4D+jhHVdm9
         Lna+PV31ZyBTXYOrXzvNfaZh/vmKhFYwn9/z6Emtarf0AQJ0Tx/cmEPeN7/Qq+ymVWXR
         BsfWhhogTaw4SkoBLkHTHiWmGUlOtz9I3gkHlzR+n3tRgrPERBkBCW42d830u46bfZYl
         nZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=itk4b7NI3cUu3jWtxKH1xulHC15KgYDHmxRNmYEuEag=;
        b=zKAuzrrJMRX/xhsp6Ks5Lv39dfjhlAozREaQWamtracc3Ieq1fQR+UdmPw1S31+sMT
         C3B5suS1LwqjtO0VTHMMWFAisoJVGlvbYUotIIRunxke87KkAI/U0F3MEl+mq42GLKcZ
         sulqjJsvBhUawMgHMsekyOYLq9JVn9+bOvAjvyDL7C+COOKcvO/uOB3FZS6Y9hQlIue0
         htae8gan8rc3ysWAgyVutAGgBk6OJq27SzCqlJbQDe30SCVgYGlIkK7zdE5uj4HSbJB7
         vBRt0IK4I1d8O3y8az0DYDwOjbO8TAZ9Lm+UGyfFZWAxcQ8if4Td8WBTRHsEPPTRP3FQ
         BCAA==
X-Gm-Message-State: AJIora/L7t/lhmR02cZysTWJVRraSD9TMm79eZq8rpNkiF1skR+BX+qD
        Ld5HgXESizdQA6ulDatSrqvmwAcO1wo6Bg==
X-Google-Smtp-Source: AGRyM1vEOmrtElVqUWrF6r6F+AV+U/B8Oom5YuRasbPruMxHLX3oh3h9bSstYS/cpgxpJ6B+HGc3cw==
X-Received: by 2002:a17:902:cecf:b0:16c:4a62:62ab with SMTP id d15-20020a170902cecf00b0016c4a6262abmr2005587plg.129.1657699080012;
        Wed, 13 Jul 2022 00:58:00 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:5ee1:7060:fe1d:88a2])
        by smtp.gmail.com with ESMTPSA id x16-20020aa79570000000b00528c0e516fesm8124882pfq.152.2022.07.13.00.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 00:57:59 -0700 (PDT)
Date:   Wed, 13 Jul 2022 00:57:58 -0700
From:   Binyi Han <dantengknight@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] staging: qlge: code refinement around a for loop
Message-ID: <cover.1657697683.git.dantengknight@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*	Patch 1: 
		Fix indentation according to checkpatch.
		Format the long for loop thanks to Joe's review.
*	Patch 2: 
		Optimize by avoiding the multiplication thanks to Joe's
		review.
		I agree with Joe and think it's the same logic, and it
		compiles without error.
		But I don't have the real hardware, so can't prove that
		code is still doing the same thing. So I understand if you
		don't apply this patch without the "proof".

v4:
	- Separate the code style change and "optimization" into 2 patches
v3:
	Thanks to Joe's review.
	- Align page_entries in the for loop to open parenthesis.
	- Optimize by avoiding the multiplication.
v2:
	- Change the long for loop into 3 lines

Binyi Han (2):
  staging: qlge: Fix indentation issue under long for loop
  staging: qlge: Avoid multiplication while keep the same logic

 drivers/staging/qlge/qlge_main.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

-- 
2.25.1

