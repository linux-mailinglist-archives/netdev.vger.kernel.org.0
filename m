Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E621E53A430
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352825AbiFALbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352791AbiFALb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:31:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81E470374;
        Wed,  1 Jun 2022 04:31:26 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id e25so1908607wra.11;
        Wed, 01 Jun 2022 04:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hfPINrYhvYPzSe5dC73Zg6XZ5fnCO9KHDS5ptHQcdIw=;
        b=CNZFgHy8hQsxXrFNCAzxtpiy/7DATavkiHF+VNFobS5/r9wK4TF680Y13drcqYz6kh
         IJfPoXbo8UwhHKo+CsyVh3ZXJ5P7e/YiQRW5cQdqHI9o1HRgUsuwX6tJCPI3IeO+S/dR
         fyBEb4ZFR39z7/zu4GDvEj1M62+T0geuycyDu66LkzhnhpCDnOVwPPT27L2g+LQqTFZF
         A1Stpl2NNKcA0QRo9/HF1I8VpK6fxqZUE86KeKWZbZaB65TmqzY9HwE4H3kEJRRxzNqK
         wkopTFr8FQIKKFGQR7A0DVD9FKYsorlyucmXBo4DG3zC//BuSoJ6PvWKx+dW+vrYZLAO
         +zCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hfPINrYhvYPzSe5dC73Zg6XZ5fnCO9KHDS5ptHQcdIw=;
        b=YVBIXdx753m5Q9Uu8d7Cu+Qj0DBEoUmNSni6mS7PUZVh3o3A2RK2lgxMxNUzisEhRM
         uEp4TZwKsPIQ1Rr6MXmLH42O8SGDOl3AjkcZbKOCacsXXyWfgGUyF1TrKx7QXoWDZI2A
         FKIu8rqMlfNQm0RneJ1X7hurjh3LQg/mc6kBqGHfQS3EuVJ8N1sZ8gGI6V/u9RhAcOjj
         U/Q+DjJdWTBJqHW0HmsPTpA6clGfPLIB4FxnpemPEVHP8uEFqmoX+HEXskAz0D1xczFY
         SWbs9taA3cCdvCTb9zgQaAqL1QqzoZvSKl7i+58xvx995BQ0t8oX4I61gpw5RmqyAPiA
         NTVg==
X-Gm-Message-State: AOAM530D4I+tq9UkpL4IeOF2yIc2ABj7MgNfV/MSEUAcRsuP7eBX6eQ2
        GcF7Xe2V+j0sbU9ziCifs5Q=
X-Google-Smtp-Source: ABdhPJxIo6KwrEjIXKL4eJYY41MxNmp4qMEctffWP6iVSneq+6eGIt44JdeCeg6/J4oOwQ3GrvJbYg==
X-Received: by 2002:a5d:51c6:0:b0:210:422:f7c9 with SMTP id n6-20020a5d51c6000000b002100422f7c9mr28209068wrv.69.1654083085321;
        Wed, 01 Jun 2022 04:31:25 -0700 (PDT)
Received: from baligh-ThinkCentre-M720q.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.googlemail.com with ESMTPSA id j14-20020a05600c190e00b00397381a7ae8sm6196724wmq.30.2022.06.01.04.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 04:31:24 -0700 (PDT)
From:   Baligh Gasmi <gasmibal@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Baligh Gasmi <gasmibal@gmail.com>
Subject: [RFC PATCH v4 0/3] expected throughput from AQL airtime
Date:   Wed,  1 Jun 2022 13:29:00 +0200
Message-Id: <20220601112903.2346319-1-gasmibal@gmail.com>
X-Mailer: git-send-email 2.36.1
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

v4:
- Fix compilation error
- Take into acount channel busy time

v3:
- Update to new MLO sta struct

v2:
- Total size overflow, use u64 instead of u32

v1:
- Make one div after at least 100ms rather than one div each skb

Baligh Gasmi (3):
  mac80211: use AQL airtime for expected throughput.
  mac80211: add periodic monitor for channel busy time
  mac80211: add busy time factor into expected throughput

 net/mac80211/driver-ops.h  |  2 ++
 net/mac80211/ieee80211_i.h |  6 ++++
 net/mac80211/iface.c       | 65 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.c    | 46 +++++++++++++++++++++++++++
 net/mac80211/sta_info.h    | 11 +++++++
 net/mac80211/status.c      |  2 ++
 net/mac80211/tx.c          |  8 ++++-
 7 files changed, 139 insertions(+), 1 deletion(-)

-- 
2.36.1

