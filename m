Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE99D546D24
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 21:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348112AbiFJTTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 15:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346122AbiFJTTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 15:19:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEAD167DF
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 12:19:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s22-20020a252d56000000b0065d1ef35f9dso127987ybe.5
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 12:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M9u2uZrITY2ZmiHjCgQwdtv5Ky15VkyjtQ04bHL3Xio=;
        b=Jw3Ysj1F41dQlsGZWhUSX3Obz+Hib2iEiW0hh7Mijv3UwtrOyaCWrIIlSyAwUDSuos
         QtJuRKjf8bcVJGqnp/cfidbUkVLVhGWUPyepZYlwljByyeosI+xTQbv6S5qRsQE1kkjB
         4g6O3P1k53JC3+z8MSkBnQ+tMlk8IKnhgBqJjq9wIph9VR1oWmUmRqAapif8fhobzgtp
         NjALOtVVeS7QJBxHZoXGBg7u3jRXuCJbg8GnrMAcnCx1Ws4QiEAZ86bBc6y4iWbRftjK
         Hj8+vTVFtkfWGc1IAklfE0cn6e19Q/jTuGUyBhm5cY+ojFPvzxc7hI3RW6aDW66GvSD/
         MfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M9u2uZrITY2ZmiHjCgQwdtv5Ky15VkyjtQ04bHL3Xio=;
        b=3jCEZILbwHTKBT/IjooGxyeHaIDJqQ1ndbjpSbwQ2BUckqabWw6iPmt4/mhBidVXmy
         AhMt+AHXx1QA+LjoCqqlIOKszQy4Yi8DcVzGF53znfYwuEEoxjz6QqiQTA9o7ji4cMIl
         qBo0lMqOTlWUzb75T+dRCu0vO2T5VI6wlnbZ5Hc7uMwPMlyLyOAL0781C+554vF9m1TY
         Ku9roXrlAOwAvf5C/kPpW4SLZnqlOKu/pu9QhJ+yS13I1lMHJAkTDtiSpM2sqGS9P3MJ
         CtqlBkUptknUB0BR7slpyPsRC+jczTRXsnBNVsbtMrrW2bPthn/sjWTE3H09dgoTSM+Z
         RRGA==
X-Gm-Message-State: AOAM531k/FQN5nMYA5oyT5ng3XEp16034U+lSwISv67nLWw3Bnuq2Slp
        DN0IIw1f6AS8bPVF4K+xzm2ObceVCxmM
X-Google-Smtp-Source: ABdhPJz10BJgI6Y5N6hUkaEeF9P58vCfexIRfPBz3ftn2TOWtVsMcosQC2GyO1ymsmhprR40j0sGd0CvFxr0
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a81:260a:0:b0:2f4:ca82:a42f with SMTP id
 m10-20020a81260a000000b002f4ca82a42fmr50470972ywm.149.1654888789821; Fri, 10
 Jun 2022 12:19:49 -0700 (PDT)
Date:   Fri, 10 Jun 2022 12:19:33 -0700
Message-Id: <20220610191934.2723772-1-jiangzp@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [kernel PATCH v1 0/1] Fix refresh cached connection info
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Zhengping Jiang <jiangzp@google.com>,
        Brian Gix <brian.gix@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Get connection info will return error when using synchronous hci_sync
call to refresh the cached information when the data times out. This is
because the cmd->user_data was not set before the call, so it will fail
checking connection is still connected.

Changes in v1:
- Set connection data before calling hci_cmd_sync_queue

Zhengping Jiang (1):
  Bluetooth: mgmt: Fix refresh cached connection info

 net/bluetooth/mgmt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.36.1.476.g0c4daa206d-goog

