Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6500959F133
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 04:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiHXCBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 22:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiHXCA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 22:00:59 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F215386719;
        Tue, 23 Aug 2022 19:00:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f17so8984277pfk.11;
        Tue, 23 Aug 2022 19:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=p/o0EKZzx8EC+mGZpkWcl1A0k8QHj+1nUXNJQzuAirU=;
        b=YrftdRUEaU/wBJ/Zvgi85gHQpE0stu+EM+Kr7jnr8S2DBl9HoYYe1Ve3eOdI9YeCJX
         rz+u6komwMHkh3MVITPR1tdPc0mZxOacxywuz/IIJu6+JBRKUjTtyLw1XBnyPlTfNtm1
         Daj+CeLrNS3F/BPDwiF09Gg0EhHaLj6Lc3H52EeD0Wy5HwlGMVJ6WWfex6S0hpDysu9W
         DbmR2Qk9+z3hHcxpwdwaME3piT3gvtuQOYvK4Jndb50M/kZBLN3QmXH9wchbaCSamo3I
         xQQ7j9T6vvouDnsPi7eXJ0LYJMlXoiqN92Bw8jMEe/Z1aPh8DPqWoNPft4ZUzvldLgr2
         M/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=p/o0EKZzx8EC+mGZpkWcl1A0k8QHj+1nUXNJQzuAirU=;
        b=HAR6GksrYLl/zn3iPryedzWfYFIpSWRmDane/vIqmsc+bQAPqBdfw5UJqWwETS7N+m
         9vaPQdImr498rBBGcw/kNvWl2eD58bcxj2IyaXKLn1qRrx6ucT8C4ueZS01LhfIJ5wXL
         mIvw0o35i57TkuxKnoe9SA8TctkDTu/ZPr2ScVXMF6WAZTxRJhB/I1hRDhGd/Kc9v3j6
         03n292NM9lPBiengUEja+beTfXcbceoSGpSPtgdsf2/tz7bY9nocIRQomNoIYTdaIum4
         2u5VHz3OOQPbuV9t+dtJDROWjVEN26oslcFaPzSYTNrFFKa7YpfWSlbO6tkn6roY/1zO
         UiGw==
X-Gm-Message-State: ACgBeo0yZRTNU8JCbtLyBsMTrIU567AhsLjVkO6BLBffkMuftWJnb3qv
        1m7IEP6xsMB4TMZ7c0JtUjWkRlca8rM=
X-Google-Smtp-Source: AA6agR6aoo8uJKWW/2Y9VhTiXig0RxC/cPKK1ZLsTLBzW9nZu+vQ5BwokW/XTsXyRDI4tkTFPkLJtA==
X-Received: by 2002:a63:e241:0:b0:41b:b374:caf8 with SMTP id y1-20020a63e241000000b0041bb374caf8mr23261498pgj.310.1661306457396;
        Tue, 23 Aug 2022 19:00:57 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902e75100b0016dcfedfe30sm11232782plf.90.2022.08.23.19.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 19:00:56 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn
Subject: [PATCH v2 0/3] Namespaceify two sysctls related with route
Date:   Wed, 24 Aug 2022 02:00:51 +0000
Message-Id: <20220824020051.213658-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: xu xin <xu.xin16@zte.com.cn>

With the rise of cloud native, more and more container applications are
deployed. The network namespace is one of the foundations of the container.
The sysctls of error_cost and error_burst are important knobs to control
the sending frequency of ICMP_DEST_UNREACH packet for ipv4. When different
containers has requirements on the tuning of error_cost and error_burst,
for host's security, the sysctls should exist per network namespace.

Different netns has different requirements on the setting of error_cost
and error_burst, which are related with limiting the frequency of sending
ICMP_DEST_UNREACH packets. Enable them to be configured per netns.


v1->v2:
Change the format of Signed-off-by, remove team's signoff.


*** BLURB HERE ***

xu xin (3):
  ipv4: Namespaceify route/error_cost knob
  ipv4: Namespaceify route/error_burst knob
  ipv4: add documentation of two sysctls about icmp

 Documentation/networking/ip-sysctl.rst | 17 ++++++++++
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/route.c                       | 45 ++++++++++++++------------
 3 files changed, 44 insertions(+), 20 deletions(-)

-- 
2.25.1

