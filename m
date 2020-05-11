Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95C31CE6EE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732540AbgEKVE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 17:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731862AbgEKVEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 17:04:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC6BC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 14:04:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y9so1849626plk.10
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 14:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=VYxf0PVqeV6uxJip1Y5m5pzkxtTdxaIqljWZxPBwFTg=;
        b=0YPMD7TRof8xRGbpqwKaP0rMBzstLuS6CCVbM4X1f670fIZyxnuJuSeSXEMJYbpfzR
         GZqZMTHot5mtK/uWYS49taJ+DlAC7YramnrCsSXCnguWFjVoRkC8hdJy0f6o4Ng7S2Bp
         tJ4MfAAlO+NHfdz+jUzphWq2+B0esr3KW6jnbeY5Sos3BXL9hDyU01YhyR7vAnc2hpVU
         6RoatL4wVgX8EIOtNL8jgL4Sz78izBUz8+/Ue1yn38F38JFtYPnfPstoN8a5SAFxhBJA
         Gctm5I6sM+TMOQDnjhY32b1auVlxo8/MJohAPEDyZRrClKMZr9T31/wtrur9R5VR36jm
         lGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VYxf0PVqeV6uxJip1Y5m5pzkxtTdxaIqljWZxPBwFTg=;
        b=JOZojV1VLM9Y7O06t740zPVChrWzRPSuGvniC1rghbO7Swj5hqRenrg8P9HxjB963z
         rCgXqJJqvU9MyiGi/j9voakMxl1RmAcbIcMz8Cw1YwfV8ft9YzxtDg4G/jxerMvUYbSc
         SkJkZ7DMg4NtoBIbVrPYfBurdTlza+YBhJTjGtVDdegqRbhQXnqbZ5WPBBc75GUzOnBF
         oEloOU8PeyUiXzXmKa3EDxDjdHU8FOCD0v4r8ikbYzMHHMsO3drzAd59TgTxdGn4sziU
         Qt10+JyRMlcMKBBhoJALroBDmSaT/yBwkX5TgV17YmsPuDGrXhXnZhInZBhKUCATVc8d
         5yPA==
X-Gm-Message-State: AOAM533YUyYyBb5DEopmchgVYuauD9oe4i8n7zhQYvKK3Ys68LGBaMNq
        4neqblkzN2x4SScgWBzGWRs2ILKJnhM=
X-Google-Smtp-Source: ABdhPJxJYcy/XEvdTd8/0Ga2AfES+0SIwlGthJIx6qftzNFDsAFdCRgYZ0atdZnfyhArGOS1fh8yYA==
X-Received: by 2002:a17:90a:bb95:: with SMTP id v21mr773673pjr.216.1589231092425;
        Mon, 11 May 2020 14:04:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm6325048pgj.93.2020.05.11.14.04.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 14:04:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 0/2] ionic fixes
Date:   Mon, 11 May 2020 14:04:43 -0700
Message-Id: <20200511210445.2144-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a couple more fixes after more fw-upgrade testing.

Shannon Nelson (2):
  ionic: leave netdev mac alone after fw-upgrade
  ionic: call ionic_port_init after fw-upgrade

 .../net/ethernet/pensando/ionic/ionic_lif.c   | 19 ++++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_main.c  | 18 +++++++++---------
 2 files changed, 21 insertions(+), 16 deletions(-)

-- 
2.17.1

