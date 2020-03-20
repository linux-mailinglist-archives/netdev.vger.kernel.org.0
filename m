Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606A818C791
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 07:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgCTGiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 02:38:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46932 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbgCTGiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 02:38:51 -0400
Received: by mail-pl1-f193.google.com with SMTP id r3so2072775pls.13
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 23:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NRVhjjDD7XDl/ETxhVS+N5qQy7f2YR4UjmY+Va7NcIg=;
        b=k1jXwyAuASqdG4q2GMsWq8R3D3oD+CJtwwbeFsM3NNte3Tjo3tG5Fri927exJdRwAL
         Ucd1dVzBECsE31JCm+u6WELtE0af5EZDyXmEmwLTV+J2UvBNe47Ww+o2K/eXG6pypM83
         zkldNrNgDw8wplWNZKixLdMI15c0g/GPxxjyWwa/VxY/rEMRzqFx+fEKjup2+0g0cdYa
         8M/YadjWpEu5Bm+7PcGkV5I9QiMQUzDkB3KnOscWkQdVF7tQEubXcu4FhtqqjYbEAD2w
         Ip5tc0+5uOQcFmjwTov/u48CNTFF6npBneeL5Q9fX3HS+qPF82hpVWec7jf+ahf3GXOB
         6NOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NRVhjjDD7XDl/ETxhVS+N5qQy7f2YR4UjmY+Va7NcIg=;
        b=KJRG1dAN3xJMIdnAjdPjY0ybKloLu0zI9AEHmtLQiAsogpMkAUM3woC1qIyzLi/v6Q
         c1olyKm4qNnsctscpBjIMFmHB3ME5KaIwQ+qX6bB8V9rZDVYEo57w9vT8GR3yMusIRQr
         vg4+pcyh2zMHzp6JX02iewOFlYrtblx5qvmdVOYKFgcKYe96fC7Hp48uIQXV9+Sqo4XQ
         hitmmDQmXgmZA7poEidTBKG2cqUX/VwW6hIlldF9/l/oK0nvSAzX8BAMK9ptpNnJY9A2
         HsFAr4fJgi9QNj2K4WTlgXee+CtuMXrcUy7dRq8MJsTXoD7okAtrdO6YbSEPYjR0qufQ
         +s3A==
X-Gm-Message-State: ANhLgQ0aUZ4RrVt/plJnxlVat86MBsEX3P0lJNfFXBVuaqwxO+zf2ZQv
        eSj+Q5w8octOdzd8HNd6a+CR6A==
X-Google-Smtp-Source: ADFU+vuAqL4vQjKPSkB3rW0832Dll8GemgDdGRZ6ZhihE6tUalFcheR5/sWW60aa9pISP4cH2vAnDg==
X-Received: by 2002:a17:90a:240a:: with SMTP id h10mr7658748pje.123.1584686330284;
        Thu, 19 Mar 2020 23:38:50 -0700 (PDT)
Received: from localhost.localdomain (59-127-47-126.HINET-IP.hinet.net. [59.127.47.126])
        by smtp.gmail.com with ESMTPSA id y3sm4370901pfy.158.2020.03.19.23.38.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Mar 2020 23:38:49 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [PATCH v2 0/2] Feed current txrate information for mac80211
Date:   Fri, 20 Mar 2020 14:38:31 +0800
Message-Id: <20200320063833.1058-1-chiu@endlessm.com>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fills the txrate, sgi, bandwidth information
in the sta_statistics function. Then the nl80211 commands
such as 'iw link' can show the correct txrate information.

v2: make the rtl8xxxu_desc_to_mcsrate() static


Chris Chiu (2):
  rtl8xxxu: add enumeration for channel bandwidth
  rtl8xxxu: Feed current txrate information for mac80211

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  | 21 ++++-
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 77 ++++++++++++++++++-
 2 files changed, 95 insertions(+), 3 deletions(-)

-- 
2.20.1

