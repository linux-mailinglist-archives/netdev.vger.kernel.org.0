Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1086C543061
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbiFHMal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239052AbiFHMal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:41 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8446225910D
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v19so26853255edd.4
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lDESOItU49dEk3ZLYBdDgBF968ijGeS8Ul2+YJOHfFs=;
        b=aRzu/bzMgXGZW42RiD6RjPsqi01BeybIowbL8Zk3cOwrZrjjRUoDoqPAFVhBOEvf5a
         sS1DTNeCCv8kQZYPF9BXeqOV8F/GOdgsZYY+U5jvfYYJE74U7rkeoo0Q00TOLDCXgsGB
         9XR1od3PxFtPgg0ybOxW3pq4TPYTktq7Ib644imJhmKPfUDXAzUQV787w787+pGeYlV0
         4aJmBBz4eKt6Es/wp/m4p/8cJvRicAFZNYnm8sSgONge/rnUJUwHIoFIquiWiz1Rjrp2
         kvU5rIoBiwiugrP6p4fLvDokRlMMyOpl5byVfhJDSPpiBUo3PjQ3s5Uh+9WYuwaO8b09
         TLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lDESOItU49dEk3ZLYBdDgBF968ijGeS8Ul2+YJOHfFs=;
        b=iru6Af/NjLrUvhUj4FP6/I5eMq72kag+uaLnJZwW77nP+gwedqwnwdAdsbMspMW7wi
         Ow6e0D0wi+qc90s7X9BrI34ANeBKMIBQJqWG6KF1umubZrRKHlkLwfvS0FrwNS6XT9H8
         jjKNjthdWM5jkDpGf6V72JrmteCNMZvJMT0TyZOz+K1jCcSku5pCRf0GZ2Jbb5RkDLhY
         /MlSAibNDBgF0S1UoAX0RZEFgwD7PcO5kQeJC1ay0XKpA8R+j0nUaW4/HxH2y7/5JBpr
         RwIUWv2kHQCuLmPoIm5V5Tp4aRPOBPPUHzhPZZwvaFNojhwP0TwMD+W6EQjiRrefR5v7
         3goQ==
X-Gm-Message-State: AOAM533UTxKP3qwiV+JFDiHjTHqUYSBHU5Hwya/nQHImd+6Y9fjs0QqW
        y6ph+HmovsgomTvrbuoR4AWk0z3VoHqn4ryz
X-Google-Smtp-Source: ABdhPJxn+6aBEJ9veNHqbjhq9bLBnCG+fguSkJ+8pHh+cw9iNfZ8ew83UqB6TXxWg9TelAFEJStyfg==
X-Received: by 2002:a05:6402:23a2:b0:42d:d5f1:d470 with SMTP id j34-20020a05640223a200b0042dd5f1d470mr25913274eda.365.1654691434400;
        Wed, 08 Jun 2022 05:30:34 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:33 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 00/10] bridge: fdb: add extended flush support
Date:   Wed,  8 Jun 2022 15:29:11 +0300
Message-Id: <20220608122921.3962382-1-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
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

Hi,
This set adds support for the new bulk delete flag to allow fdb flushing
for specific entries which are matched based on the supplied options.
The new bridge fdb subcommand is "flush", and as can be seen from the
commits it allows to delete entries based on many different criteria:
 - matching vlan
 - matching port
 - matching all sorts of flags (combinations are allowed)

There are also examples for each option in the respective commit messages.

Examples:
$ bridge fdb flush dev swp2 master vlan 100 dynamic
 [ delete all dynamic entries with port swp2 and vlan 100 ]
$ bridge fdb flush dev br0 vlan 1 static
 [ delete all static entries in br0's fdb table ]
$ bridge fdb flush dev swp2 master extern_learn nosticky
 [ delete all entries with port swp2 which have extern_learn set and
   don't have the sticky flag set ]
$ bridge fdb flush dev br0 brport br0 vlan 100 permanent
 [ delete all entries pointing to the bridge itself with vlan 100 ]
$ bridge fdb flush dev swp2 master nostatic nooffloaded
 [ delete all entries with port swp2 which are not static and not
   offloaded ]

If keyword is specified and after that nokeyword is specified obviously
the nokeyword would override keyword.

Thanks,
 Nik

Nikolay Aleksandrov (10):
  bridge: fdb: add new flush command
  bridge: fdb: add flush vlan matching
  bridge: fdb: add flush port matching
  bridge: fdb: add flush [no]permanent entry matching
  bridge: fdb: add flush [no]static entry matching
  bridge: fdb: add flush [no]dynamic entry matching
  bridge: fdb: add flush [no]added_by_user entry matching
  bridge: fdb: add flush [no]extern_learn entry matching
  bridge: fdb: add flush [no]sticky entry matching
  bridge: fdb: add flush [no]offloaded entry matching

 bridge/fdb.c      | 142 +++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/bridge.8 |  83 +++++++++++++++++++++++++++
 2 files changed, 224 insertions(+), 1 deletion(-)

-- 
2.35.1

