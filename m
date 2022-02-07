Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81F24AB887
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358339AbiBGKNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244055AbiBGKH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:07:57 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48F9C043181
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 02:07:55 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id u6so25701094lfm.10
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 02:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=3524Ewc82K1gUEuqKd1kctSzRzq0QQ6e60wt0GXFslA=;
        b=CmqnynXmKfcot6krUZ5RqiF9YjNIJ/24pGySP1oKw5XHtqie7+Dt8QZOkbqCDkyhQ6
         LQKFoLBeZIaDIVO8UkeLzVSmbNPyCT2CQgVPxAWuFMIsvtg7RzgWXPGjMsQgoPDJUapE
         aCFK3chc27uzJZdwm4CIC7DS0TRR3/4xDR8/rHcJZ7UKHsLFJ8mu5mR2BwDTIVCNKqpW
         8F/NlplVFsCdWbYByMz6G+++H/0hzK7bCv1V+gD7eyG3ZKwrtAWlsdzHaEo+hhyatu8B
         8q/YSABK5BPAOfMqSUH4CVjT3eF90GIip741PHbzbJ8jb5jWscuJC2j+c4oWr6pjD4Qn
         LTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=3524Ewc82K1gUEuqKd1kctSzRzq0QQ6e60wt0GXFslA=;
        b=36mZpyljO1aTq7N1/lTHSZLXlzHskmXKzq3f6+c9y3q6RuigzueCwcPUQH0QILp/zV
         54WTMDtWBYHRUQWzHL2868g6PmODtb1Kmkv8jTc3SK9H8IZ+YIRPHrEO4/EW5Pl4TFZQ
         rDrWxxNKuPBLw3HeAQAFngWaoPbCIrdJiGlT+o4ZB4kHZqvBxwblOtoy8rjAVsXHu/xW
         XRsLOtI6yLEURukIkXMb6vfsqdIrDaVrRIwmFitNkw+MkzcNzxMi4nZPtjIvNpMUj2iY
         Wm3MvNqNuTl2mVs1yRo3D8YO9wXzJlKcB9urmdorL/oRgeXEQaOwJ6RyZDoFRFSgB8R4
         uUqQ==
X-Gm-Message-State: AOAM533kRyNtnuMAIXQVHgZMYYWMVhA6DK7SNDw2/Zhu9IB5+JNEXNZe
        EvXoAAiyOcVS7dFUeoS8ZHfDTl1lI+ue9+9GfnI25nIi
X-Google-Smtp-Source: ABdhPJwN9eP73oIx6+B00xYIRm545JQxw2aPe1wZ/RMjJ3jfKrEITlIjmP9G/8KNtiRqxyVWVKXyyg==
X-Received: by 2002:a05:6512:308e:: with SMTP id z14mr7761371lfd.104.1644228473883;
        Mon, 07 Feb 2022 02:07:53 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k12sm1546034ljh.45.2022.02.07.02.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 02:07:53 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>
Subject: [PATCH net-next 0/4] Add support for locked bridge ports (for 802.1X)
Date:   Mon,  7 Feb 2022 11:07:38 +0100
Message-Id: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

This series starts by adding support for SA filtering to the bridge,
which is then allowed to be offloaded to switchdev devices. Furthermore
an offloading implementation is supplied for the mv88e6xxx driver.

Public Local Area Networks are often deployed such that there is a
risk of unauthorized or unattended clients getting access to the LAN.
To prevent such access we introduce SA filtering, such that ports
designated as secure ports are set in locked mode, so that only
authorized source MAC addresses are given access by adding them to
the bridges forwarding database. Incoming packets with source MAC
addresses that are not in the forwarding database of the bridge are
discarded. It is then the task of user space daemons to populate the
bridge's forwarding database with static entries of authorized entities.

The most common approach is to use the IEEE 802.1X protocol to take
care of the authorization of allowed users to gain access by opening
for the source address of the authorized host.

With the current use of the bridge parameter in hostapd, there is
a limitation in using this for IEEE 802.1X port authentication. It
depends on hostapd attaching the port on which it has a successful
authentication to the bridge, but that only allows for a single
authentication per port. This patch set allows for the use of
IEEE 802.1X port authentication in a more general network context with
multiple 802.1X aware hosts behind a single port as depicted, which is
a commonly used commercial use-case, as it is only the number of
available entries in the forwarding database that limits the number of
authenticated clients.

      +--------------------------------+
      |                                |
      |      Bridge/Authenticator      |
      |                                |
      +-------------+------------------+
       802.1X port  |
                    |
                    |
             +------+-------+
             |              |
             |  Hub/Switch  |
             |              |
             +-+----------+-+
               |          |
            +--+--+    +--+--+
            |     |    |     |
    Hosts   |  a  |    |  b  |   . . .
            |     |    |     |
            +-----+    +-----+

The 802.1X standard involves three different components, a Supplicant
(Host), an Authenticator (Network Access Point) and an Authentication
Server which is typically a Radius server. This patch set thus enables
the bridge module together with an authenticator application to serve
as an Authenticator on designated ports.


For the bridge to become an IEEE 802.1X Authenticator, a solution using
hostapd with the bridge driver can be found at
https://github.com/westermo/hostapd/tree/bridge_driver .


The relevant components work transparently in relation to if it is the
bridge module or the offloaded switchcore case that is in use.

Hans Schultz (4):
  net: bridge: Add support for bridge port in locked mode
  net: bridge: dsa: Add support for offloading of locked port flag
  net: dsa: mv88e6xxx: Add support for bridge port locked feature
  net: bridge: Refactor bridge port in locked mode to use jump labels

 drivers/net/dsa/mv88e6xxx/chip.c |  9 ++++++++-
 drivers/net/dsa/mv88e6xxx/port.c | 33 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  3 +++
 include/linux/if_bridge.h        |  1 +
 include/uapi/linux/if_link.h     |  1 +
 net/bridge/br_input.c            | 24 ++++++++++++++++++++++-
 net/bridge/br_netlink.c          | 12 +++++++++++-
 net/bridge/br_private.h          |  2 ++
 net/bridge/br_switchdev.c        |  2 +-
 net/dsa/port.c                   |  4 ++--
 10 files changed, 85 insertions(+), 6 deletions(-)

-- 
2.30.2

