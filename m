Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151024D2414
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350625AbiCHWQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350595AbiCHWQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:16:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79F5954BE9
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 14:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646777702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=jsagWIcYjBlb0odjn78vqSEkzAg0cbRigaFdUE2Hpig=;
        b=Oyp3E45L2FkP222D3fo1+vqmMLXNoUJ1K2QUIGo4VU5SO3aeh9TVildDqU9yyocMaAoP1s
        Nye9DodaQaEDPYis+sggno2nHxH+24V2zmIhx7/Zz7ULcWyWhxUmFtztMV47bAV4bEVdvc
        yLhbtf5D9lOo5rArOP4f1gbP2KVXLcY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-91wU6teBO0WDA24RVktKuw-1; Tue, 08 Mar 2022 17:15:01 -0500
X-MC-Unique: 91wU6teBO0WDA24RVktKuw-1
Received: by mail-wm1-f72.google.com with SMTP id 14-20020a05600c028e00b003897a4056e8so293392wmk.9
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 14:15:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=jsagWIcYjBlb0odjn78vqSEkzAg0cbRigaFdUE2Hpig=;
        b=GmtkBitxmUJnybfcNWYp/zDzqvuTvGMqGHLiSOn4U/mrmJXSLmH9broIzRQq1dM4kG
         wloLwnO/xozuNaBESfWiGWrxk1C8zJU5mtrbwVrxCaaFCVfRsfAmqxuIFtCQrVIX02L0
         rqhatoaQNA1OmDKzMlml4Oz90vygzVEVeaaHmOZliYkgFdp3x824b80o97QnCqFstCPZ
         ls+K6AS6qZMw9peujTMG7NCWWVs/+jonzNxnETSVZgP7V5BYMgmb9TzKWeQ5vHSvhnsb
         IB2+GAo6+YTSIq+DqJrqtqpXcInp+FLHN5eXiYqVLT+oaKqJGeUl6Mfc/dInDtyDwZI4
         t5BA==
X-Gm-Message-State: AOAM533nnRziixVsFkPaRlyiTstlaJojc3Hh5I6HsNuHttKkfzJaz2iQ
        gLsdAAPPPkzLiHgFhveOs3Q4aHWt5H9CvWX42OF8Wc0suACdYPJGMFIfVUrESAL229aG28ZcHK9
        hxJuczfcoZNkR+5Wt
X-Received: by 2002:a05:6000:18c3:b0:1e5:82d3:e4e2 with SMTP id w3-20020a05600018c300b001e582d3e4e2mr13645280wrq.575.1646777699809;
        Tue, 08 Mar 2022 14:14:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDow23AB2HL6l37bLT+PO/3s00Fj0O0u0HhfOmL8nM5trxzYGuVjDazcaoLLM0rqwFvkfvOQ==
X-Received: by 2002:a05:6000:18c3:b0:1e5:82d3:e4e2 with SMTP id w3-20020a05600018c300b001e582d3e4e2mr13645270wrq.575.1646777699575;
        Tue, 08 Mar 2022 14:14:59 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id k10-20020adfe3ca000000b001f0329ba94csm139504wrm.18.2022.03.08.14.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 14:14:59 -0800 (PST)
Date:   Tue, 8 Mar 2022 23:14:57 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net 0/2] selftests: pmtu.sh: Fix cleanup of processes
 launched in subshell.
Message-ID: <cover.1646776561.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on the options used, pmtu.sh may launch tcpdump and nettest
processes in the background. However it fails to clean them up after
the tests complete.

Patch 1 allows the cleanup() function to read the list of PIDs launched
by the tests.
Patch 2 fixes the way the nettest PIDs are retrieved.

v2:
  * Use tcpdump's immediate mode to capture packets even in short lived
    tests.
  * Add patch 2 to fix the nettest_pids list.

Guillaume Nault (2):
  selftests: pmtu.sh: Kill tcpdump processes launched by subshell.
  selftests: pmtu.sh: Kill nettest processes launched in subshell.

 tools/testing/selftests/net/pmtu.sh | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

-- 
2.21.3

