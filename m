Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FCF4E74BC
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359262AbiCYOGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357854AbiCYOGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:06:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D34D8F45
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:04:57 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i67-20020a1c3b46000000b0038ce25c870dso973637wma.1
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vckEkOoUM40sBLsRBKD+06k5G/5F2rUN2WTRMVmwR2U=;
        b=d25g1hLIKXb4Dup2wBrwP2QLuR3QsJVOihcZiWNYn+/EadLJVT12CmGgGG3b/2fci2
         ywtMfQVDCnneR0aGM0f4PGUuGR9m+JVJRWfCXnbiNB7ZbmmKwUeSsngcBjEAc9msWX1U
         ONoUrHp5ajOu1wnT06GBsj8vr5nFWxqySsfHzHOp5pviTbNtl2+8TiKUb8VcbZFQuqUr
         LyMLTWCYiovDnCsROAkPOl38ouOc2r652jqAn/8WmEjZsT9GZEf1TYZf7PpcQNhGOp4F
         4MebJ9AwksDbKsguTaB2UQ2BwR7JhehffpnNilZ0lyPKmIdMzpkwaXPS3ITL9uPOSFPO
         HXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vckEkOoUM40sBLsRBKD+06k5G/5F2rUN2WTRMVmwR2U=;
        b=rjdTg0HPw6zespE9fS+ZJh3WB2YKe4O82O805+vPvBirCU+Q/DbLceJ5c1M6lggk9h
         vF4UpXnMRxgcAo+SvV/d3SPsKHokraqxX4IYIix1Ao6eVrsVQMFPSpc9LIp6ozahbN37
         0AlrvtNM6MVg9pOLJWfd0BotV1gDDHv/4Rx1Jl/HgyaOSIgWSzz8hIq2FrwqHMeKlJ+7
         x3GJ2t3j2rw9EowVXnxlNP4jm7t4LI9QMlm0CosxzIoTRCPjwrZE3G15QPZS3KZWhNtu
         2eYgYmHgMWK/dCotw05HsVwPU/2Ol9XMqQWQ/id6BIbK6p9ibsESZ7ZkaWoa3XVli1ix
         o2vQ==
X-Gm-Message-State: AOAM531b8PcbHU8Kp+SbybO2O68L/0gE66rzdG4V4DU03h2B+Kd3KYoP
        copsa184NnXTIIMDBDFtMtktMKFlWK1zqg==
X-Google-Smtp-Source: ABdhPJxdXIZrjYmzV2/wE12eeMJhvx++sUqxu7cRuAct0GwWGkoU7DI/2kUcuP6OM11gjh8WcIc2qA==
X-Received: by 2002:a05:600c:1e83:b0:38c:b028:9c44 with SMTP id be3-20020a05600c1e8300b0038cb0289c44mr19066492wmb.162.1648217095796;
        Fri, 25 Mar 2022 07:04:55 -0700 (PDT)
Received: from gojira.dev.6wind.com ([185.13.181.2])
        by smtp.gmail.com with ESMTPSA id o8-20020a5d6488000000b002051f1028f6sm6347642wri.111.2022.03.25.07.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 07:04:55 -0700 (PDT)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net 0/2] ixgbe: fix promiscuous mode on VF
Date:   Fri, 25 Mar 2022 15:02:48 +0100
Message-Id: <20220325140250.21663-1-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These 2 patches fix issues related to the promiscuous mode on VF.

Comments are welcome,
Olivier

Cc: stable@vger.kernel.org
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Olivier Matz (2):
  ixgbe: fix bcast packets Rx on VF after promisc removal
  ixgbe: fix unexpected VLAN Rx in promisc mode on VF

 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.30.2

