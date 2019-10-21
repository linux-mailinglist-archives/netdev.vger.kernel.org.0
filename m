Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A04DF575
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfJUSyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:54:55 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:36533 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUSyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:54:54 -0400
Received: by mail-wm1-f48.google.com with SMTP id c22so4730368wmd.1;
        Mon, 21 Oct 2019 11:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=mo6gx15jA1X6JoHj1nOdlxgncVVbt4VeDL6mDNmRTXU=;
        b=ilzFTL7VXWACHOrpPzx7h/cPrHCpAF8opuD6Aiph68B6BBNVydfIuH5W3qKurE110X
         iHOXNHqgs8ExTsaJ+WPS2V5ZaJcVn8RoX5IHTVlR0T7aClm6GhT+kqPQP+V54pGBojM9
         zpmxidNs87QtsUrNVBM1XqFMWd2KsoavubR6QTTBHDueU27Lp8hJchzWMAMAMGa4BLU5
         Yo1fyI4YfdQqFWJ02alyJ0z9Yd6R1SmSJlsUGbM6lNb5euwodCADLXq4hyDXAe8ArL8Q
         r+F9KFrLsGTLEZJrcFBtf57EskOERhxw+wXkucQoxHTBfvsDJnqsyF3ZxkYHmwLnyH31
         atxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=mo6gx15jA1X6JoHj1nOdlxgncVVbt4VeDL6mDNmRTXU=;
        b=WXxREcxKDXNeZhhcljEtsBRZC29gF1zjf0Sc3ChglyaWnFWTBFXCLvCYDkKsC7Vi5+
         9n7l2S4kyeYWzL0HvmMFUI0pZskhEeKY/v5w9hT9PWkUdf1IHgtbQoDw1kSnSO6hyKsz
         0rhsrcj12YhiZI3eqYKRUwIU0uJn0x/q1cNHjwJl2NJUroaDL2umETXY77sWYdDy5LyT
         EPX1xQ+Wd6VJ+DvSWxy1ZwkEDjbvY66547VWs6C4049k5W4Lhvdvx2lM+Zvm2/JDCZ5y
         jqg5BpvcNDtdE30vM4EyefjnWU3bOabsTzbtH0entyPAWrJcb2vUr/x/7+5hk3ABwYZi
         z3pg==
X-Gm-Message-State: APjAAAVbRg23DJ93AF9O1ST8JyxwkZ5+igLd0kRSYAU8wK0SOXQJ9w+m
        iE7KM9pGEq0fKqr8bluVJw3pN9qI
X-Google-Smtp-Source: APXvYqwDCx9WAOSFV2HqU3uujWpgJfD+MqoDq8J8YxWr2OHsraD0L3B6rHApg8NgDeBDFSLmPssHPQ==
X-Received: by 2002:a7b:cd19:: with SMTP id f25mr21521197wmj.154.1571684092528;
        Mon, 21 Oct 2019 11:54:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1cea:5bb:1373:bc70? (p200300EA8F2664001CEA05BB1373BC70.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1cea:5bb:1373:bc70])
        by smtp.googlemail.com with ESMTPSA id 36sm10635054wrj.42.2019.10.21.11.54.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 11:54:52 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: r8169: enable ASPM states via sysfs
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <d172e31d-c17a-c01e-8cfc-7a38cc7932b1@gmail.com>
Date:   Mon, 21 Oct 2019 20:54:41 +0200
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

So far ASPM is disabled in the r8169 driver due to issues on several
chip version / BIOS version combinations. Commit ad46fe1c7336
("PCI/ASPM: Add sysfs attributes for controlling ASPM link states")
adds the option to enable ASPM states for a device via sysfs
(provided that BIOS allows the OS to control ASPM).
This commit is included in latest linux-next and may be useful for
notebook users to benefit from ASPM power saving.

Heiner
