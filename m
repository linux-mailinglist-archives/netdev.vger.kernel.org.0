Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA499E795F
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfJ1Tvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:51:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33384 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730286AbfJ1Tvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:51:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id 6so427553wmf.0
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 12:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=MRWApwEiItkRYIG1V0fGz+2p6oujl5iqIGp28bh2XIA=;
        b=Fy1aWVtB5XbIH/l6/QlOSsW6o54J4Poe9X5m6csnyjMtiG2JIeCNiHwx6Q8uFE0+SA
         VuoK2utUtB6RJlBYAov2GWtpMaX4thGN7/0a8daGNo3L5zrPpKkMtSvw0S0+ybNX76cc
         eWo1tFTElxToPa8ax1EymtI3CPOe3AYiIVqN3l6VVn08LkkGQRZoUuOxDMlhl+AB5rte
         01MAOLnyucXV6kLKA6guObTkkgw0jxGK6LPb+UqZv+HbMGwwnxgm5RJj3666J6Kw9Hy1
         9gqSjaPLooVMPMVfK8RatTYvgDdSw1l9lm3WRflSmG7edpAKrJ+e5xw7eCdGouSz+j0r
         2Kmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=MRWApwEiItkRYIG1V0fGz+2p6oujl5iqIGp28bh2XIA=;
        b=P6Hc7F1nA12fuEF+kdpQk0a7iMa4BMUfQ8tBpF+QVZ6kHNKyuTUvE7ceyi4Arc0p5K
         YT4Um/TMNSHzvKo2DeBnRO0voWO/nDwx3tIen9bf8eOxhX7jrGZYjvMJHHD5a5jwTMgx
         9tC0Uj2caVDrofaQr/vAQpQdWrnagKDcj6uXCCAJrdsLCYIf3CmfG8efgXBronNGLWYc
         nHvYPIcgHKwownO/LmB4N0GIEiJlO9Yya/Py4tpdRLxkKC2xmS4owndwejeNWv45TmDw
         MGFH6IYJdSztayIiRx4gqS3WSbxtw/jCzjRzmVmg5DUOoTMvVWYoW51BQsua8wzj+GvQ
         8fkQ==
X-Gm-Message-State: APjAAAWT9We+FroiMvKBraa3396GJEIOo+Na7yr53RTOe92CLrTq1edV
        v19oPENTgwCF5MlLdScEMJI=
X-Google-Smtp-Source: APXvYqyDrz57YmZ4Nyr+vOvIOEHDFHZb9Yzs63myangjlYPiSuc1vSmDzU8ZKaSqF1AParPBisGXHA==
X-Received: by 2002:a05:600c:22c4:: with SMTP id 4mr849290wmg.177.1572292298982;
        Mon, 28 Oct 2019 12:51:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8? (p200300EA8F176E00957829B82CD48CD8.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8])
        by smtp.googlemail.com with ESMTPSA id o73sm678642wme.34.2019.10.28.12.51.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 12:51:38 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] net: phy: marvell: fix and extend downshift
 support
Message-ID: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Date:   Mon, 28 Oct 2019 20:51:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two fixes and two extensions for downshift support.

Heiner Kallweit (4):
  net: phy: marvell: fix typo in constant
    MII_M1011_PHY_SRC_DOWNSHIFT_MASK
  net: phy: marvell: fix downshift function naming
  net: phy: marvell: add downshift support for M88E1111
  net: phy: marvell: add PHY tunable support for more PHY versions

 drivers/net/phy/marvell.c | 112 ++++++++++++++++++++++++++++++++------
 1 file changed, 94 insertions(+), 18 deletions(-)

-- 
2.23.0

