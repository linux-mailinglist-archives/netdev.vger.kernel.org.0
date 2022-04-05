Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071484F214F
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiDECpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 22:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiDECpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 22:45:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CA0E15754A
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 19:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649125981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wbRs4pePotq0ekCmOToPh7VLTR/XeKpZKgeTS698bkk=;
        b=ShjVhwRBTo4tT0Id8LY/6rGPFWZy+wsC5Z4aQPdCaK6mYYArRwxv/0b+vGBimfxryHSuZ4
        EWKv1vYOW41HmRf0vDrudLys+oJyakKaQQswITu6Scjn89/psrooN+pWnKHmJJwHUdq8Or
        9m38f7qkSbiD4zLRUD871gSqyaApn2E=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-zQn9ggtjOvqLzzq60wNZSQ-1; Mon, 04 Apr 2022 20:15:34 -0400
X-MC-Unique: zQn9ggtjOvqLzzq60wNZSQ-1
Received: by mail-pl1-f198.google.com with SMTP id s5-20020a170902b18500b00155d6fbf4d4so4046144plr.18
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 17:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wbRs4pePotq0ekCmOToPh7VLTR/XeKpZKgeTS698bkk=;
        b=MzT8QgUzQaF0cMF0+5qW63WASBPQ9KqEZEaKboiCt4y5nWVEQ2CKZ0ka3VPe1TSkcH
         rCDJ5qhKOnmciu2+CeVfurXL9sRHBGn+hOkaItrhNSAnJOp1RcXrYEq1KGlw3tgoNDyP
         3KTZXYJAdaZvrQ3CN3+/6Vwe01UjhSnsqtxrH7WrBmWfUFhmxr774Ulk1vMBqTl+mXPw
         sK+k2/VPd1COF4wt0xav9eLXOJ2ll7aa8+DUgVQ+VNegWFEtI80V/tHOesDyMHogzChT
         Hrx9BCTGe07YS5EiIpcZe5JIf1ERZtqDbSEL/OYlNGGVYrEJK5v5ctcyJgwS2cGp5oqU
         brGw==
X-Gm-Message-State: AOAM531s/6l13DAg64R5bFP10Pp71jOmYV2qLKDea7ze9y7Fln+CIWJ8
        VKUqojuDMoXcStOkl5W7hr661KkIa0oRZAyfrwplecYgL/pNuNaXLXtRXj6yQVdFMQ0RyJxNp3f
        Wmi7UJ7aYaFZ0V20ZIJRHob4/Ypa4mxwiMzBsxG8bgFLJpuvo0FfxpFFE6uTEAJiZI4HE
X-Received: by 2002:a17:902:a981:b0:156:229d:6834 with SMTP id bh1-20020a170902a98100b00156229d6834mr666924plb.128.1649117732976;
        Mon, 04 Apr 2022 17:15:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyt23vGXvUjKmHD0vUDHPCxNCsQxV4fCMFvR7jrSimof6iIKcSA2fyMIvkqH3tAnC1fnLJQSQ==
X-Received: by 2002:a17:902:a981:b0:156:229d:6834 with SMTP id bh1-20020a170902a98100b00156229d6834mr666892plb.128.1649117732576;
        Mon, 04 Apr 2022 17:15:32 -0700 (PDT)
Received: from fedora19.redhat.com (2403-5804-6c4-aa-7079-8927-5a0f-bb55.ip6.aussiebb.net. [2403:5804:6c4:aa:7079:8927:5a0f:bb55])
        by smtp.gmail.com with ESMTPSA id p18-20020a17090ad31200b001cab747e864sm246404pju.43.2022.04.04.17.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 17:15:31 -0700 (PDT)
From:   Ian Wienand <iwienand@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Ian Wienand <iwienand@redhat.com>
Subject: [PATCH v2] net/ethernet : set default assignment identifier to NET_NAME_ENUM
Date:   Tue,  5 Apr 2022 10:15:00 +1000
Message-Id: <20220405001500.1485242-1-iwienand@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As noted in the original commit 685343fc3ba6 ("net: add
name_assign_type netdev attribute")

  ... when the kernel has given the interface a name using global
  device enumeration based on order of discovery (ethX, wlanY, etc)
  ... are labelled NET_NAME_ENUM.

That describes this case, so set the default for the devices here to
NET_NAME_ENUM to better help userspace tools to know if they might
like to rename them.

This is inspired by inconsistent interface renaming between both
distributions and within different releases of distributions;
particularly with Xen's xen-netfront driver which gets it's device
from here and is not renamed under CentOS 8, but is under CentOS 9.
Of course it is ultimately up to userspace (systemd/udev) what happens
to interfaces marked with with this flag, but providing the naming
info brings it inline with other common interfaces such as virtio, and
should ensure better general consistency of renaming behaviour into
the future.

Signed-off-by: Ian Wienand <iwienand@redhat.com>
---
 net/ethernet/eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index ebcc812735a4..62b89d6f54fd 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -391,7 +391,7 @@ EXPORT_SYMBOL(ether_setup);
 struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
 				      unsigned int rxqs)
 {
-	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
+	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_ENUM,
 				ether_setup, txqs, rxqs);
 }
 EXPORT_SYMBOL(alloc_etherdev_mqs);
-- 
2.35.1

