Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458141896FD
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgCRI1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:27:11 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:45195 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCRI1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:27:11 -0400
Received: by mail-pg1-f171.google.com with SMTP id m15so13247335pgv.12
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5LGJ1tadBVSKcXHWmxYL9RsY79DWIeIh5wKubnO5eqk=;
        b=e8dl+UdnULDH7XYMFNjJmuLS6sr66005KzMrcl9E+V3VoFx05HjvO7RQSNdU3ghaz8
         Q33IZFKTfLuuV2UEmgENXMwlL4GJ5ZGoWgCw/rVr8Dk/OB60kYw90aArMAJPWrxFTWjb
         A9+oCSEQABtZCuvwV8fQfvNVVjG1pyk3Q274b2+QgDjyAs0z9vtEXTVKqlexteUwHjHX
         I1TD5yvw5EWCHxX6FqwK5wJC8+NPPvrzzX/gy2yZbfDSrQ1kMBFUnprUjynugofCz8gA
         KWeEH6ztWip0/HbPthW6yFu5oxajfN4xXYhrmVI4jD1N4+0K3bhN+2EhWM4DIw9AyCU2
         MC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5LGJ1tadBVSKcXHWmxYL9RsY79DWIeIh5wKubnO5eqk=;
        b=nt8gum9Ji6OFjyTdqjFsACUxIyNpS6RvvnstXX7F3UhJeSA1B9uehe1OELYSmPYEfH
         NpKto/1u7gbwETkTBmVTJZHgPoxidKQnpdd3+HaXYYxwMYuL3gM9HFdKjEM/MbBe+GjQ
         kBvRjhbwjQpjcQgl39hRsKgEXdIQzUUCBVWQZuB+MCEJfl75TbrUmaSCOUIC9AxKGMv5
         PcFqoAKYgCWZ+WPJZ6F+h+ufRjKx7mWO4YrZXPiAfpMs97tqMmYzXoV1VaSQcvQJG/x6
         hrFt0q69AuoV0hRKcHHvoWDMhc2nSfyNQtMNR4+A7r6PuVaNZdGCOuGHFeKdWE5AnT88
         mkeA==
X-Gm-Message-State: ANhLgQ1ZcOBEIyX82w+V2ejbE+vyv2nB7xSjOK6a2KfTHTvFDUheRyvp
        538FyRW5m0dhgT37Axk/bXA9kw==
X-Google-Smtp-Source: ADFU+vtzMfXeCeHxOSeg+6PKfpDdbNC5fJZ5fLgsY4UNtVtABqiqbRlsTey5zSb/YgEPIRFuWf+OLg==
X-Received: by 2002:a63:5f13:: with SMTP id t19mr3302456pgb.265.1584520029786;
        Wed, 18 Mar 2020 01:27:09 -0700 (PDT)
Received: from localhost.localdomain (59-127-47-126.HINET-IP.hinet.net. [59.127.47.126])
        by smtp.gmail.com with ESMTPSA id 18sm5492148pfj.140.2020.03.18.01.27.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Mar 2020 01:27:09 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [PATCH 0/2] Feed current txrate information for mac80211
Date:   Wed, 18 Mar 2020 16:26:58 +0800
Message-Id: <20200318082700.71875-1-chiu@endlessm.com>
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

Chris Chiu (2):
  rtl8xxxu: add enumeration for channel bandwidth
  rtl8xxxu: Feed current txrate information for nl80211 commands

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  | 21 ++++-
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 77 ++++++++++++++++++-
 2 files changed, 95 insertions(+), 3 deletions(-)

-- 
2.20.1

