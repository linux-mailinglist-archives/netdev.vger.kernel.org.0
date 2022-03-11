Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95054D64A0
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349255AbiCKPcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349173AbiCKPcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:32:07 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9A11BBF75
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:31:03 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id r41-20020a4a966c000000b0031bf85a4124so10954082ooi.0
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0CRypE66Ic2bA5wEHhuI+xUM4ooUD3StqTBoSCC4hUM=;
        b=Az1+r/CFiUCrLyaDdnpnhkB5RzFXNiMxqlY731p/seqv44OTgttmcpkG/wqn1jec12
         wpBUY4ez23PgNao9esU0utloQ9gTQCDZVKwk6kwQ64Cal/8G9u/EepESOQh7JKPwaene
         /dL8q/e5OB9FdcVsU/e9AFltRroApk3EgaGzrzpKcF6ePMgP7Fi7TOI1sFv5fZQCcz6p
         QqB4A2ZM7R84Ls6wpe/Zq0cdMD6/j+cM4z9tV3kCseYtuweSWX0JYpfe7pbxlxLgQDhD
         sc+SbmI11VeraAnIanquKOHrlUzRuveW/m9VDrZ0MPGbepTAC1mtnBmt/76rgJm0n9gr
         xq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0CRypE66Ic2bA5wEHhuI+xUM4ooUD3StqTBoSCC4hUM=;
        b=JSuL+vMdn59Fw6PUYVjsb40amJTTUDFZU7fTlq2Z5lxSKRiyBjd8z3ULYe7OtrTuF0
         GVuDZLVx9FzvhaQCH4XePElnwec2nxGKvqLYsJbhBuUDE1bjwI62Lyiwi0nIB+MC+UZB
         wgrOm9fobm6pDBBmUKiBnIvGr798ZndMLNq547GNcLeosOw3Szpxa2nXKZ3WFs0Rn6dK
         DNEZ7i8KERZxK8FmMRKqfWQRVwQVOiMrQdwiYeYxL1e5LtFTSEsmAccJV6nNNHJoNOa/
         eetC4fxlB3Gvcvi8iZb4stwrduXLRsYZY2seSuQZoeL5IU5gD8mhDU2H4Z+Xyc/9UtJz
         IucA==
X-Gm-Message-State: AOAM531acz7kktnwB1z6ezWJAXUEbTMSHQGJ3aRJ15622qguJa4h/+zg
        qoI5Gj0mUld1EZb6rsyWFbX+tegZikonPQ==
X-Google-Smtp-Source: ABdhPJyti5ccjjopr0ZYJ10s7iwJ97OymZOq0eRGn156N3v8E+ypB+Rqh/iVQ9pMmv/XNoK+F8qHPw==
X-Received: by 2002:a05:6870:581d:b0:d7:540d:525e with SMTP id r29-20020a056870581d00b000d7540d525emr11251519oap.163.1647012662932;
        Fri, 11 Mar 2022 07:31:02 -0800 (PST)
Received: from localhost.localdomain (179.176.50.102.dynamic.adsl.gvt.net.br. [179.176.50.102])
        by smtp.gmail.com with ESMTPSA id 22-20020a056870111600b000dabbb6380csm1565409oaf.56.2022.03.11.07.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 07:31:02 -0800 (PST)
From:   Victor Nogueira <victor@mojatatu.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, vladbu@nvidia.com,
        marcelo.leitner@gmail.com, kernel@mojatatu.com,
        Victor Nogueira <victor@mojatatu.com>
Subject: [RESEND PATCH net-next] selftests: tc-testing: Increase timeout in tdc config file
Date:   Fri, 11 Mar 2022 12:29:42 -0300
Message-Id: <20220311152942.2935-1-victor@mojatatu.com>
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

Some tests, such as Test d052: Add 1M filters with the same action, may
not work with a small timeout value.

Increase timeout to 24 seconds.

Signed-off-by: Victor Nogueira <victor@mojatatu.com> 
Acked-by: Davide Caratti <dcaratti@redhat.com>
---
 tools/testing/selftests/tc-testing/tdc_config.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tdc_config.py b/tools/testing/selftests/tc-testing/tdc_config.py
index b1ffa1c932ec..100a3df464db 100644
--- a/tools/testing/selftests/tc-testing/tdc_config.py
+++ b/tools/testing/selftests/tc-testing/tdc_config.py
@@ -21,7 +21,7 @@ NAMES = {
           'BATCH_FILE': './batch.txt',
           'BATCH_DIR': 'tmp',
           # Length of time in seconds to wait before terminating a command
-          'TIMEOUT': 12,
+          'TIMEOUT': 24,
           # Name of the namespace to use
           'NS': 'tcut',
           # Directory containing eBPF test programs
-- 
2.34.1

