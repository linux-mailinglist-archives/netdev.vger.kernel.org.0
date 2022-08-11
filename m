Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C54E58F749
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiHKFeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiHKFep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:34:45 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88CD89CE1
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 22:34:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso4298141pjq.4
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 22:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=hNcvjd87fRHISEzR+PfN6DBKyXXPBn0UjgRGRWq3Poc=;
        b=FKCcF9tHKfAmEIv+3eH/TeSsVC/ODfsIL65jy/R4143PJZxCEUK9D53h8FiGwP6DFu
         1cqaJDz3y5guS5EVtQs5XJuX4D8+NtaNp4WMIQe1Ev+t9G6+IUx276qmVxvpRWMb+mHn
         M0AeK4xm+KvVDYRJXXRaSbiFLqiaInIF7zKpCZjaGqcuvs0dDanp8rALmETOSH+/9HBQ
         AxsrNOsyDDxVtGFW3f+qj95Xq/rOyZ6a06peDp1v66JLbr6WBMuOy54Jf1rQ1lLwSVMI
         dZx7AcrIY08ypz91ZkUENKNu+sz+Tbeu1klVNEcEcfgV7ydqYSiNu/9n9nGBft020/5E
         ca2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=hNcvjd87fRHISEzR+PfN6DBKyXXPBn0UjgRGRWq3Poc=;
        b=2iaHg7nDL99h3ZGr8SFsmdH3+NDQ7P5II1bjXFgs9zwCHQzT/0foi/Km4NscED4VMh
         2HlXFNLT9kvmDqRRqX4ELyYj3dh1FDZGNXKQBhSeWK1Rq80tXamY23Zc3G3MCkYKsJKV
         6V6Yf+uPuMHFgm8f1QSJ7ZINulex+fL5Ak+0R3InHhRqaMmtjvEfyk5Q6eKuADkPDFL4
         9PIQhXDXWNHFBXoM5STZOQlAWhCip3XvOTfgucPGuYD8de+MlE5Yinowi9LrzwMuDyuR
         OzUh9Snby56wYk6Hr+2Z/0PsJO1jl/uOwS4U3qi3WfZaNtj0PQ9XF61xEnZauVi5kl9f
         Ep8A==
X-Gm-Message-State: ACgBeo03aFTLT8x2gkqCt3kX79PBqWUdSgUH2ApWE2wLBt/PPwYajN4M
        0a8qnaisKfy04Fl05H5uyX2vy64xxEw=
X-Google-Smtp-Source: AA6agR7jdVEBrorsGSMB2lfILB3EmvPUeuo59HZ/ryIfgC2XpTrN2niLbDEZ1fzMFmHffg2pdrpePg==
X-Received: by 2002:a17:903:40c4:b0:16d:d2a9:43ae with SMTP id t4-20020a17090340c400b0016dd2a943aemr30507929pld.57.1660196083600;
        Wed, 10 Aug 2022 22:34:43 -0700 (PDT)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9200:a0f0::9f45])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0016f196209c9sm14027157plg.123.2022.08.10.22.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 22:34:42 -0700 (PDT)
From:   Khem Raj <raj.khem@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] configure: Define _GNU_SOURCE when checking for setns
Date:   Wed, 10 Aug 2022 22:34:40 -0700
Message-Id: <20220811053440.778649-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

glibc defines this function only as gnu extention

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index 440facb..c02753b 100755
--- a/configure
+++ b/configure
@@ -191,6 +191,7 @@ check_ipt_lib_dir()
 check_setns()
 {
     cat >$TMPDIR/setnstest.c <<EOF
+#define _GNU_SOURCE
 #include <sched.h>
 int main(int argc, char **argv)
 {
-- 
2.37.1

