Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9032357E6CA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbiGVSpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiGVSpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:45:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEB387C36
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:45:01 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h12-20020a170902748c00b0016d29671bf7so3062918pll.9
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=3qqLBm0xV4mGiZiGED2yL3VCWOwhq7//Y+5w9DIVSJI=;
        b=io+OBpMGgliqn5b9xs9McUXAdcOR15jmgf3SbyuZYnVDFS8ZIpX0LqD7igItbqorGq
         +3/WJ6Bl3ItdBxn9CJ2961CIVCXupwiGrZ8IOW+VaAyJQl5wXeiEnjgxX2gSljfnrA5+
         5F0WWja4vsTmzVE0QIDeTs7zkbUd8phCHLQLc4DlTMrlxcMYu6GLKqJWAvwAzHiVWABT
         R7gPl+0yUBrtJMi13Wj/8oUGZ1N+QPfSDuTO8kL+34AskPfU8Bl6zmeybYfuhaRaaSJj
         zn9Vz023Y5Y2w/DpIpwdBqQz4JgtZ5QWOO3/URJD2gQviYmlFP5+ypSYDhtPMr93y9qs
         eqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=3qqLBm0xV4mGiZiGED2yL3VCWOwhq7//Y+5w9DIVSJI=;
        b=JEED8YNhnwVULL9V/eJBEtKQy6AU/XZg9Mf3N5j5PH9bAaFn9MhY2tzL+EIpXDHDZR
         jIkPMhQnaSbCpNEidwVFyuD613ht+/zH6QbGKkeFy4kPWw7EFytCIR45PrMmgfyKFNjN
         +0M/rmnOZCNJsoYzQ/eIY+BEtR5lTdFH8tQmtLNyQJelKJQ9t0YkTI+AaYmAhRBiDtPr
         MMEMJ5KZnMEFfHsTprLzJHnAHUEqzDKnW8+B8gv6eWoCtM3mjoaWWaSR3fEd2iE3gpIJ
         UJ42amMu19TilZi8Mai+tB/kHkHj5untYUIrhXyECF1bhKabRXDH04hFRCvezrKUwsa1
         FaeA==
X-Gm-Message-State: AJIora9UZIkq29igrWv/4d3znZEZ3ZTujcoyiMA98KaF+XeqeXH2gVxY
        lsN9FF1RLr1ixcZxzPdMS+LRn/1R5Oyh
X-Google-Smtp-Source: AGRyM1uZdQcBK6hty151dQMWVvCDDhnb4BKYuP5NQXINp9lg2nYuagDD1EdnHpKZhALTM7g/t8iBQvOpY2zB
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a17:90a:2a0d:b0:1f2:aed:ce18 with SMTP id
 i13-20020a17090a2a0d00b001f20aedce18mr999590pjd.91.1658515501311; Fri, 22 Jul
 2022 11:45:01 -0700 (PDT)
Date:   Fri, 22 Jul 2022 11:44:54 -0700
Message-Id: <20220722184455.3926696-1-jiangzp@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [kernel PATCH v1 0/1] Bluetooth: Return error if controller not
 support ll privacy
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Return proper error message if the controller does not support ll
privacy.


Changes in v1:
- Return proper mgmt error if controller does not support ll privacy

Zhengping Jiang (1):
  Bluetooth: Return error if controller not support ll privacy

 net/bluetooth/mgmt.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.37.1.359.gd136c6c3e2-goog

