Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71ECEC94
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfJGTSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:18:31 -0400
Received: from mx5.ucr.edu ([138.23.62.67]:13169 "EHLO mx5.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbfJGTSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 15:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570475910; x=1602011910;
  h=mime-version:from:date:message-id:subject:to;
  bh=LHYtmlTgSx58sSJEN4Ghrk7oWWL9DzXHOlkqjGOMe2E=;
  b=pjb7nT62Qo4gGyoA+tbFdn9NpSI9rx+XD/tCKfrKwjMkaDKQW93A1KJ7
   EmL5JCvf8S8zUxwzmt7wFqguPyY3iYxkRaJL5nsVwMyVJLOwbb0I3CDXH
   LZ0UGND0oQ1L11hb++KNyH/qtJXT4NmH/FwrWCDVDzy9Cpzb0EEqbDErF
   CPWba3HZqK2TBlxlWzJRLsPisgOeRIwAu8gD9oEkn9lTqHUNtw+8rqs7P
   waENoVgIl5lEqU4fpDVbUGgwWOJX1tpoEwOf3tRkByVkuMvo9PcRANpIu
   g18Yraj3DN4GnmNHG85ewKV2X39JwLruHNov/P1rXqZyP5PI/rfO5molS
   A==;
IronPort-SDR: 1ioxE7rE/gtC23E5MF/CF2npBD5kLU5RjckKcv3NhJYi0U0uAQc/7cZMuIPWXOUSYv8OzDI//A
 m0IiibqU9qC8gpFElMaaq3epPvs3kOyzVoRsR0vyyFDysltO0cAvONx3zeqJ3Ry/TmZMuH0A+Y
 kAnoJu0AGOpy+7gm/zMAglzFytPKfJj0JcIBBURMy0HK5zQsEZ6JSpY83CHQUEvos5PpfpvvHW
 c+VlUv+rNFPUH7YDURBilx7LuCFZEHEC1SAz9XNr01WKpRe2kyKcho1FxJksSD/bRf2W0PSLh7
 C1A=
IronPort-PHdr: =?us-ascii?q?9a23=3AkNexxBPT/x6AlSXG5mol6mtUPXoX/o7sNwtQ0K?=
 =?us-ascii?q?IMzox0K/76oMbcNUDSrc9gkEXOFd2Cra4d0KyL7Ou5AzVIyK3CmUhKSIZLWR?=
 =?us-ascii?q?4BhJdetC0bK+nBN3fGKuX3ZTcxBsVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBx?=
 =?us-ascii?q?rwKxd+KPjrFY7OlcS30P2594HObwlSizexfL1/IA+2oAjTucUanJVuJrsswR?=
 =?us-ascii?q?bVv3VEfPhby3l1LlyJhRb84cmw/J9n8ytOvv8q6tBNX6bncakmVLJUFDspPX?=
 =?us-ascii?q?w7683trhnDUBCA5mAAXWUMkxpHGBbK4RfnVZrsqCT6t+592C6HPc3qSL0/RD?=
 =?us-ascii?q?qv47t3RBLulSwKLCAy/n3JhcNsjaJbuBOhqAJ5w47Ie4GeKf5ycrrAcd8GWW?=
 =?us-ascii?q?ZNW8BcXDFDDIyhdYsCF+UOM+ZWoYf+ulUAswexCBKwBO/z0DJEmmP60bE43u?=
 =?us-ascii?q?knDArI3BYgH9ULsHnMrtr1NaYTUeCozKnP0D7MbPNW1i386IPVdR0gofCNXb?=
 =?us-ascii?q?JqfsrQ1UUjCw3Ig06NqYP5JTOZzPoCvHWG7+d5U++klm0pqxlprzSx2sshjp?=
 =?us-ascii?q?PFi4EVx1ze6yl13IU4KcelREN/Y9OpFoZbuTuAOItsWMwiRnlluCM9yrIbp5?=
 =?us-ascii?q?G2ZDMKyJE7xx7HbPyHbpSI7grjVOmPJTd4g2poeLeliBaz9Uis0+n8Vsup3F?=
 =?us-ascii?q?pToCpJj93Bu3IX2xzc7ciHTfR9/kO/1jqVyw/T7eRELVg1lardNZEh3qY9mo?=
 =?us-ascii?q?QPvUnHBCP7m0X7gLWIekk4+eWk8fnrb7Hkq5OEMo97kAD+MqAgmsylBuQ4Nx?=
 =?us-ascii?q?ADXmia+OS8zrLj/FH1TKlEg/Atj6nWrIraKd4FqaGkHg9Zypwj5AqnDze6zN?=
 =?us-ascii?q?QYmmEKLFRbdxKbkofmJU/OLevmDfewnVusii1nx/PYMb37BJXCMHzDnK3mfb?=
 =?us-ascii?q?Zn5E4PgDY0mPJY55tSDLwaaNj+QEC54N7fDhY/NQGvhezqEtpV14UCVGbJCa?=
 =?us-ascii?q?icZueanFqN7+QyLu3ES5UIvTz0IPhts/PriHY/hFIZO6azwJ4dYXu4NvVgP0?=
 =?us-ascii?q?idJ3Hrh4FFWUMXtQN2Z+vnjF2FGWpXen2zVqQ7oDo8BYamCq/CQJyghPqK2y?=
 =?us-ascii?q?LtWtV3YHxLDhioEHH1Z827Wu0BbC+JOYc1lj0CSKi+SoEg/RCoqAL+jbFgK7?=
 =?us-ascii?q?yQsg4RsZbunOZ84+qbwRIs/DhzJ8+a32yEUntzhGpOQCU5iuQ3iF10zl7L+6?=
 =?us-ascii?q?V7juYQQdVC7vdAFA03NpPG5+18F932HAnGe4HNAG2mS9WvG3kKBvc4394Sck?=
 =?us-ascii?q?99Bp32lRDK3yOwRaRTkrWXBYAl+6LB93n3O8t5jX3B0f9lx2IvWMIHDm2vnK?=
 =?us-ascii?q?l5v1zIDpTA1V6Znrytc4wd2jLA8CGIym/Y+AlcUQhtQeDaXGoSYkbNtvzn6U?=
 =?us-ascii?q?7YCbyjE7IqNk1G08HGYq1HdtHkk31YS/r5ftfTeWS8nyG3HxnMjreNapf6Pm?=
 =?us-ascii?q?YQxiPQDGAanA0Ju3WLLw4zAmGmuW2aRA5uFEPyZQvV8OB44CepTk4l0geTR0?=
 =?us-ascii?q?Z6kae+4FgYieHKD7s43r8CtzY84w5zGln1i9nNDNyPjwF6OrhXe5Uw7EoRhk?=
 =?us-ascii?q?zDsAkoD52yL71lzmweegU/61L81xx2Ut0budUhtjUnwBckevHQ609Iaz7Nhc?=
 =?us-ascii?q?O4AbbQMGSnuUn3M6M=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FkAgAfj5tdh8XQVdFmDhABBhKFd4R?=
 =?us-ascii?q?NjmGFFwGMUIEYijQBCAEBAQ4vAQGHHyM4EwIDCQEBBQEBAQEBBQQBAQIQAQE?=
 =?us-ascii?q?BCA0JCCmFQII6KQGDVRF8DwImAiQSAQUBIgE0gwCCCwWib4EDPIsmgTKECwE?=
 =?us-ascii?q?BhFgBCQ2BSBJ6KIwOgheBEYNQh1GCWASBOAEBAZUsllQBBgKCEBSMVIhEG4I?=
 =?us-ascii?q?qAZcUjiyZSw8jgUaBezMaJX8GZ4FPTxAUgWmNcQQBViSSHAEB?=
X-IPAS-Result: =?us-ascii?q?A2FkAgAfj5tdh8XQVdFmDhABBhKFd4RNjmGFFwGMUIEYi?=
 =?us-ascii?q?jQBCAEBAQ4vAQGHHyM4EwIDCQEBBQEBAQEBBQQBAQIQAQEBCA0JCCmFQII6K?=
 =?us-ascii?q?QGDVRF8DwImAiQSAQUBIgE0gwCCCwWib4EDPIsmgTKECwEBhFgBCQ2BSBJ6K?=
 =?us-ascii?q?IwOgheBEYNQh1GCWASBOAEBAZUsllQBBgKCEBSMVIhEG4IqAZcUjiyZSw8jg?=
 =?us-ascii?q?UaBezMaJX8GZ4FPTxAUgWmNcQQBViSSHAEB?=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="81197786"
Received: from mail-lj1-f197.google.com ([209.85.208.197])
  by smtpmx5.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2019 12:18:29 -0700
Received: by mail-lj1-f197.google.com with SMTP id e3so3801810ljj.16
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 12:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=HOvGdjzdmR9zNG6ZkfBcEllkGY6GoUXzSDLht1mF2WI=;
        b=kKMe15DBfC+5bsGNCvKx9EEza1X3ReenHgaIZlr8wLQaiBvbbkSK3FbXe/q8BaW1zn
         PCO34ePhuyGdiPmxFt2MtD8S63p3cW7ec9HuyJKGQ4WXUVtOqO6BCePUpU32knJ/Ocn0
         QlWCxzwbwmBcLM07ByaEHFzFozSUQrHeycxe8GntSXapAX9pZL72LcTRcIWq6nNXhEso
         sW2UeOF3QIF919MADj0hMN4xuRygsS4SUzNn0aZRdf4Iraf56KCMTX2cTriWvyq5UDlu
         8jqNb1hLnHa3/YWKnivH/YxM9leGP5bCYtRdwTkw2sfeXzrwkQ1FshYkpckHC5pkXuoY
         9IXQ==
X-Gm-Message-State: APjAAAWL95Ogp42OpSvPxEve37CGOxW7i596CAure6kdWpni+X1y/M9L
        ZrkASfmzTB2HeBRAavE85JVO+t8COiHtTgnEhpVxoZq5/eQ8WhjkoriiuKBA2ijXBR3ojEBcpQS
        anLR8ObXqlRwpHTOWH0/G74U9JcJ+eZ7NGg==
X-Received: by 2002:ac2:44d2:: with SMTP id d18mr18369568lfm.67.1570475908314;
        Mon, 07 Oct 2019 12:18:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzDsm2ohzARraL1dLP+2VP0TkKPuqHmWeU4s0nw0vbJHVPGul4JY6lCMGPAe2OrCXzu0/jcM+Elf0wRZoMMQ8w=
X-Received: by 2002:ac2:44d2:: with SMTP id d18mr18369560lfm.67.1570475908124;
 Mon, 07 Oct 2019 12:18:28 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Mon, 7 Oct 2019 12:19:11 -0700
Message-ID: <CABvMjLRhqCAs-r3LA4nX_5tBj=hQeUfb4g5gHf8ghRdwWqKuPA@mail.gmail.com>
Subject: Potential NULL pointer deference in iwlwifi: mvm
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ayala Beker <ayala.beker@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All:

drivers/net/wireless/intel/iwlwifi/mvm/scan.c:

Inside function iwl_mvm_power_ps_disabled_iterator(),
iwl_mvm_vif_from_mac80211()
could return NULL,however, the return value of
iwl_mvm_vif_from_mac80211() is not checked and get
used. This could potentially be unsafe.

-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
