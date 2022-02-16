Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A233D4B8297
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiBPIJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:09:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiBPIJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:09:02 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F572409E8
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:08:51 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id w20so1400359plq.12
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hblX4Vb8VssuOD9tn70AJboqbVUteFmw42map15Ebgs=;
        b=deM9oaDsPTUyT3xKr6hyFXch6FApBWjb9aNhncBc9OWl+b3rHRNBVD0dFxjSwMMmye
         2KzHkCQUUtjFlQnLVTDtl0DtWwhNN7/GuBhXzf8Bh4Tuo6ITuoA5AsuiT/0dflv1J9dM
         DzMqO0JJJ/pBI3fAgo/yo2SVXr9ZTtNqijP0X5H3wvd+MEte6ll4jVUnj4VgPhQk0hdh
         CbWbpYPflmUfPSDYmrJhd5rRpX5vVtAbc20mF+zFh9TIjrXHjS2D0QBjB9PpZdzDlbOS
         8YgFxJkcEwsG3SXLEr23Umy5fU/1aBuDJ4xXdFBTQ9PInYHRJxB7Xgy6/SZ81ctjssC5
         ldtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hblX4Vb8VssuOD9tn70AJboqbVUteFmw42map15Ebgs=;
        b=ht7BgDVRgnL/Q6uaSZciKdVhJespR3b6RX01HRdJi+bPx+Gu/IubU8mVZbQEgOcD/C
         Sy2+WHxAygzX15UWdKqPQMdncugXOqXbiE1HprUOlZ6m2iB/KYLq6qDlLXX247d6tn5+
         w5YxomkzhlZOwpSlBqF27motnBOA7JpEr8X4bTVUIWDkohdCYI+F7GKvzrM0quo3Jpnj
         9FPao2DxnEk+xzV3/+XVY3vLIXd/e+nzfXOkYGKCoiwhrO/50mhkN941VRN+TGOPhiof
         QRfBofayjk80xA8eGtFhSrgo8JQkWNiWXVm6revjWKmIj5uceHRYsZzLxnni4PXy9ths
         WhAg==
X-Gm-Message-State: AOAM53237cnstP62K4TA8LA9rp7RvsndbJc1PzhKPKKzqyFbz4Yp47KU
        78qAjNVLOAeG1GDgIuQjJHS3LaMiqOU=
X-Google-Smtp-Source: ABdhPJwYtkGGGhnY+PB+sGfEiIohOZXatuZyfxcLAFOVz72jg+ukeUZZ28OF7KoolbgCnq/BAwWvwQ==
X-Received: by 2002:a17:902:ecc6:b0:14e:ca1e:8509 with SMTP id a6-20020a170902ecc600b0014eca1e8509mr1288864plh.140.1644998930271;
        Wed, 16 Feb 2022 00:08:50 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm4635662pgn.30.2022.02.16.00.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:08:49 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 0/5] bonding: add IPv6 NS/NA monitor support
Date:   Wed, 16 Feb 2022 16:08:33 +0800
Message-Id: <20220216080838.158054-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

This patch is for adding IPv6 NS/NA monitor support for bonding. I
posted a RFC patch before[1]. And the iproute2 patch is here [2].
Based on Nikolay's suggestion on RFC patch, I did

1. define BOND_MAX_ND_TARGETS as BOND_MAX_ARP_TARGETS
2. adjust for reverse xmas tree ordering of local variables
3. remove bond_do_ns_validate()
4. add extra field for bond_opt_value
5. set IS_ENABLED(CONFIG_IPV6) for IPv6 codes

---

This patch add bond IPv6 NS/NA monitor support. A new option
ns_ip6_target is added, which is similar with arp_ip_target.
The IPv6 NS/NA monitor will take effect when there is a valid IPv6
address. Both ARP monitor and NS monitor will working at the same time.

A new extra storage field is added to struct bond_opt_value for IPv6 support.

Function bond_handle_vlan() is split from bond_arp_send() for both
IPv4/IPv6 usage.

To alloc NS message and send out. ndisc_ns_create() and ndisc_send_skb()
are exported.

[1] https://lore.kernel.org/netdev/20220126073521.1313870-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/netdev/20211124071854.1400032-2-liuhangbin@gmail.com

Hangbin Liu (5):
  ipv6: separate ndisc_ns_create() from ndisc_send_ns()
  Bonding: split bond_handle_vlan from bond_arp_send
  bonding: add extra field for bond_opt_value
  bonding: add new parameter ns_targets
  bonding: add new option ns_ip6_target

 Documentation/networking/bonding.rst |  11 +
 drivers/net/bonding/bond_main.c      | 295 +++++++++++++++++++++++----
 drivers/net/bonding/bond_netlink.c   |  59 ++++++
 drivers/net/bonding/bond_options.c   | 140 ++++++++++++-
 drivers/net/bonding/bond_sysfs.c     |  26 +++
 include/net/bond_options.h           |  31 ++-
 include/net/bonding.h                |  26 ++-
 include/net/ndisc.h                  |   5 +
 include/uapi/linux/if_link.h         |   1 +
 net/ipv6/ndisc.c                     |  49 +++--
 tools/include/uapi/linux/if_link.h   |   1 +
 11 files changed, 573 insertions(+), 71 deletions(-)

-- 
2.31.1

