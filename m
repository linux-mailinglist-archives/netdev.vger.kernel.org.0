Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE335A5F9E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiH3Jjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiH3JjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:39:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E312E115B
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:37:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so4215067pja.4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=/gVxyf18ax75lOvkDxhHJo9AcWNy0MsiRX2nhq2ISek=;
        b=c3L1KDg9GgX4KMw0JpEXhU8xspNqTZIHs2plKlcWjCdGzfQz24SyC2sEWlG0EgMfNd
         5h0WP/wy3cNHgl1pAsiVJn2A0FLOoZih4f/irR1G52ERoiVxVfN1jALOz/cPSn9Lbyup
         bjIcn8V88meFu8XgCvVbLzBu8xjVnpdItFzEIXp6YelbZ29W+cS7MHm+tkOhPA0I1ZGV
         lrHD8NUGW1tSOG7l9wY3bzriycZ5VnqWrMGZm/FV+PxXTct47rrjdfjI5QitJZPLHfWE
         qYB7tuVBP4TtF7sXCzH/iWfocu8B8OoB8IuhuOKLNUez8LtgUrI35+8qZMu3M9GZ474v
         7cyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=/gVxyf18ax75lOvkDxhHJo9AcWNy0MsiRX2nhq2ISek=;
        b=Zbk+fKgXKvI5UarO3LjY7vkkgJvIa/vfrmi0H6J0I4zIOyRC7TWTGG+xl+z8ol+9Ag
         v4i7ynHPfMFpe+aLwPvDgdErms5bDxee0sT4G4Co/DVZ+o65Bqkov6rHad6d1Gwn/+Dy
         xQAyQvrya2TjPtH6fxt86PbX29YGdgQvcHKqyCG7BWHyd9rr2J5XiY7qvYfFjSkn+0yN
         d4ckmethEx5UID05yqGEuHR17u2tQvD+QDUDBwty/ebMnGyf9JWBfLu/8HkdYjYhFoS/
         +/T4jCNPvJ+ozmXpYZYGB7DbDLBDwM87HTLVqanr4OrGjUxGwhk4Efjn7K9aFQEKrJ97
         1twg==
X-Gm-Message-State: ACgBeo01jkHfGbHalIoRoM7kR6BcCmapt2kaHvoodMkpoRjPkKiTYiwY
        f4b7JdQ8tl/JTLWdi370VA6J8zQBjllmkA==
X-Google-Smtp-Source: AA6agR6zEi2OemhvNGFVADms0LFDLUtShBDq/YurhunrTgdZwR+E8Tg1Yyr8UXNbYIJZGyEDIpOikw==
X-Received: by 2002:a17:903:244c:b0:16e:fa53:a54c with SMTP id l12-20020a170903244c00b0016efa53a54cmr20018021pls.46.1661852252508;
        Tue, 30 Aug 2022 02:37:32 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h187-20020a62dec4000000b0053639773ad8sm8899393pfg.119.2022.08.30.02.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:37:31 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/3] bonding: fix lladdr finding and confirmation
Date:   Tue, 30 Aug 2022 17:37:19 +0800
Message-Id: <20220830093722.153161-1-liuhangbin@gmail.com>
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

This patch set fixed 3 issues when setting lladdr as bonding IPv6 target.
Please see each patch for the details.

v2: separate the patch to 3 parts

Hangbin Liu (3):
  bonding: use unspecified address if no available link local address
  bonding: add all node mcast address when slave up
  bonding: accept unsolicited NA message

 drivers/net/bonding/bond_main.c | 20 +++++++++++++++-----
 net/ipv6/addrconf.c             |  8 ++++++--
 2 files changed, 21 insertions(+), 7 deletions(-)

-- 
2.37.1

