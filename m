Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302A335493E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 01:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbhDEXdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 19:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241653AbhDEXdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 19:33:33 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7510AC06174A
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 16:33:25 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a1so11434397qkn.11
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 16:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iix/v2cJC9b8/wrwd7EH/KvNJQF53WPoD5HVyQhNhJI=;
        b=PWuWgElMYtHYjSyuGEO6ucZsbDjGBg7VQEFwyAtX2nPGC8Vq0mnFEpGdifIavZomsW
         KtYUty/PgMrBszumWX5Pd9hQlLOcqfnC4nJ/k8VozzFM3wf46mfWNmPTIWz8RVbmz7j/
         0TIOT5d5MM+uLoK/sdcUVoK6bC99T8N66r9Gb80vAkxpLFpsa7eBWKTawWBNroI9dD3H
         ol/+q4GLB7tapCPX0l6i2ApVWfZ4sSLvDRba62WcQV05+Hc8/2NVGMSxl1BqzsB4aOKy
         JK3xNkaun8XA2gHy64xxqFfD2EhkIMLAcgv+S7TgLbhzHkvdSJEIKamhFa5bSiX9UGze
         0VwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iix/v2cJC9b8/wrwd7EH/KvNJQF53WPoD5HVyQhNhJI=;
        b=X0BOLrJvOxsEBxAIxCGDDZN1wJ8+d6dh9ngQj4ZdgQPf3PGjCjIwA2erJIx4GPwPqe
         kBE433qhNWjQo6hCihDT+HGAF+46WQv8/O7AdmeBxIKce4JN4/hu+SsAfjUO2gJrw16k
         EWjSEiZzYLJ3ejpb5fUMpY4coYCLJj/oOARcsbs2s/ArP4RqsNDSgdD3F2Mr1zI3UWlB
         wDFBknP48oT5ic/+VUfub/zC/M09Fb6ESpzYrO1y0FJEKWiHLt9A5AUkPkFPrCClkRa8
         dbLYn/F0Gd15VeJSG53M4X/ZOu3aJqpsjOFpqBZs5I0laYkR0v/3R6PB+47dONOesKwF
         s1eg==
X-Gm-Message-State: AOAM532Lrp7EAyheB6wxbsHtx9LF+6jHpl10A3RMzgAOkgTIjvnOfU9e
        DZ+ZEh/G+DnWrUQfKQ4fBljQixSEB5/D49+Y6Oqu
X-Google-Smtp-Source: ABdhPJypo2nkY7qRmSPpYGVr8CAc+F+j4KKJ9X64kRJ8m77Hhve8ftYeL3Ovp7Ik4xyLMd3LH/sq+B9C27XwwHPyBDD+
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:1cb3:ad22:2ed6:7c62])
 (user=danielwinkler job=sendgmr) by 2002:ad4:5593:: with SMTP id
 e19mr14604643qvx.52.1617665604297; Mon, 05 Apr 2021 16:33:24 -0700 (PDT)
Date:   Mon,  5 Apr 2021 16:33:03 -0700
Message-Id: <20210405233305.92431-1-danielwinkler@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 0/2] Bluetooth: Avoid centralized adv handle tracking for
 extended features
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maintainers,

This series addresses a race condition where an advertisement
registration can conflict with a software rotation advertisement
refresh. I found that this issue was only occurring with the new
extended MGMT advertising interface. A bad use of the
hdev->cur_adv_instance caused every new instance to be immediately sent
to the controller rather than queued for software rotation, opening a
path for the race to occur.

This series improves the way new extended advertising hci callbacks
track the relevant adv handle, removing the need for the
cur_adv_instance use. In a separate patch, the incorrect usage of
cur_adv_instance is removed, to align the extended MGMT commands to the
original add_advertising usage. The series was tested on both extended
and non-extended bluetooth controllers to confirm that the race
condition is resolved, and that multi- and single-advertising automated
test scenarios are still successful.

Thanks in advance,
Daniel


Daniel Winkler (2):
  Bluetooth: Use ext adv handle from requests in CCs
  Bluetooth: Do not set cur_adv_instance in adv param MGMT request

 net/bluetooth/hci_event.c | 16 +++++++---------
 net/bluetooth/mgmt.c      |  1 -
 2 files changed, 7 insertions(+), 10 deletions(-)

-- 
2.31.0.208.g409f899ff0-goog

