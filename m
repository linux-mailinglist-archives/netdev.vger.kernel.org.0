Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D613B18781C
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgCQDW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:22:27 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38380 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgCQDW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:22:26 -0400
Received: by mail-pf1-f194.google.com with SMTP id z5so11136215pfn.5
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 20:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GmuvMAkQR5qf4H9cOLMLTH69ypb51d7NGMtlc4BhmnU=;
        b=JKj5XtqYkzSrvhJiVJqw5mYcCiWzoWaPKIV3a8GgDlenH2BeQfi0NnSO6HzrTZoPtz
         vx5NeRjWvEyBJ20eduwukejFlVJnzkrW5BvZUNu9wIaCg9lC4KXSzFddSqMF8Pn/acP1
         z1EFtrdFtWoIPghBxtrFR7gAAdBonKlYhujPfMP+lHwxC6zGeD6/sgPWKpmCJEqn1kin
         xyEbvWvwi4ISsTNTG5eLvzzfgb7IW2E+Om1av4gi3XB4VyRsRVcyjD7P+ZhWeetyQP4F
         9IDOx+DaVIVsW01oRrZi6w6no36bWPFsRD6IVXemfUcuRw/jKiWRyrRic975Ou559Tlf
         5aGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GmuvMAkQR5qf4H9cOLMLTH69ypb51d7NGMtlc4BhmnU=;
        b=NjIY8MwyNXHJbArjf3dcQaoYZzKi8ZZCMOHGgwcviQHi/0dsz5K2NFR6lE2two7rOR
         ibR+27884tqWEqDUwwRN+e97Ut+xYLe6AqCbQjDyKZ1ub2tyaiwnSdm8EBoY1lH+lHY1
         3nG9asU+wzFM7XG6emcCLikAleBfHxEd13tpj6/VaC4XHoktVeEu1MgN7EpnnuDkDdbZ
         noLwRBUv1KqVxdM5F6pWyTJpddRnyn2EI0d2Blz3LHisp6O4f4ahvvQSaK9moTw5LDXs
         Tb8gdQ2WKlkAPZffvE91Hd8U72gi2PGJjRgniEb4koQkRSOmHytvwX7+KaxyUEDuKJ0E
         jbgg==
X-Gm-Message-State: ANhLgQ1zp0zJT4tzGDDySc5wEab//CNfk9FH180vHipt7j6GYRmOZPJz
        K1ihPHgLunpUk03sRWbsQ8TmK5kb/sQ=
X-Google-Smtp-Source: ADFU+vvrQlNrPxa0ZwR7ChQoRq8FrKoEo5Jy74Mrsiib60DxmAUmXDwFYNrJM1uyG9DInXNJc2zHKQ==
X-Received: by 2002:a63:24a:: with SMTP id 71mr3065398pgc.119.1584415343679;
        Mon, 16 Mar 2020 20:22:23 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f8sm1185639pfq.178.2020.03.16.20.22.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 20:22:23 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 0/5] ionic bits and bytes
Date:   Mon, 16 Mar 2020 20:22:05 -0700
Message-Id: <20200317032210.7996-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few little updates to the ionic driver while we are in between
other feature work.  While these are mostly Fixes, they are almost all low
priority and needn't be promoted to net.  The one higher need is patch 1,
but it is fixing something that hasn't made it out of net-next yet.

v3: allow decode of unknown transciever and use type
    codes from sfp.h
v2: add Fixes tags to patches 1-4, and a little
    description for patch 5

Shannon Nelson (5):
  ionic: stop devlink warn on mgmt device
  ionic: deinit rss only if selected
  ionic: remove adminq napi instance
  ionic: print data for unknown xcvr type
  ionic: add decode for IONIC_RC_ENOSUPP

 drivers/net/ethernet/pensando/ionic/ionic_devlink.c |  9 +++++++--
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 13 +++++++++----
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |  4 +++-
 drivers/net/ethernet/pensando/ionic/ionic_main.c    |  3 +++
 4 files changed, 22 insertions(+), 7 deletions(-)

-- 
2.17.1

