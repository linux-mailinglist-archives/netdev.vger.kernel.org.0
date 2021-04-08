Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A868359090
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 01:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhDHXqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 19:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhDHXqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 19:46:13 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3615C061761
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 16:46:01 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j7so1851195plx.2
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 16:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DxyRoQ5Ujuq/qKST3/Nby+CZta3m7oASwyoeouT8epU=;
        b=vTyV9E9tVWKxSxw1bstzwnnTK0MZL0NLEwkLxmTFK9+szP/aovP5toYLxSluisEnxb
         KuYkKZc2Rmh3JMGpeACXvA/TzvhF7Uf/wTj6cg0N9UcFHrAL0PMkzqfuwAuX3mcK8W73
         d7zZQFQCPijid/mS1Y/XS2+aeQ5mb56zCa5O6/lHY2Nhnx8JFX5dQPxPpvbaR4CFcCL0
         KRRBJ1rKr8x6BbwgMFfozRRx0lEnFHcddlciu6b9AS2VpWb3IGttrvfUvdtSi9zBXOj7
         1+46CrxgDIKaQJUIWNTdrvLG5v98eVOWhw/Voj6Od3K7Gh4YQBuXKpzSP4pFn1UB2nAV
         YEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DxyRoQ5Ujuq/qKST3/Nby+CZta3m7oASwyoeouT8epU=;
        b=d/TWCPDFhOrieBwYbdDmftqZEKtGGxGztBID1CSz3CR6VeHtkPX/Qb01COH6+4lDqj
         atzO+lbsl570ws60jjqCn0aVvwfutnd5aEfdn/yWswzDVUxhIxfcyhbCXNdEz08TVary
         E1cq4viSKYrSGgRLxB63q2FscA0wTIaswJz770fhJ/TRbYaENMKn7TzpKul3f7XdiFWN
         RZ0EHNz2YhKBb7J3uYkUmtMzSZtYhC7hJY0LUpUH8FiAfUJE8Qlnxg1j4brB/HrIdCPa
         XUYSvmXAZVCb1Gn2abkOPsHNKoK0fE3P5O8M3Jrid/uOC7EK7oz9sjam9nk/N6CSEMPQ
         EQYg==
X-Gm-Message-State: AOAM532BzRmVJOHuEcmKEL9/SfDtzZLps5Ovos2Z8UoAvLj7B0s8JQ5p
        ROhIdFciltD8MTvZ7YHPbT23R0KQZdjj2g==
X-Google-Smtp-Source: ABdhPJxycwIE2oGL8bTeh9yzauKUg9824duZ1hP9pYlvxkfBk0D2u15yhvPB+K+XJk24OtWfUP7uIw==
X-Received: by 2002:a17:90a:d3d8:: with SMTP id d24mr10530147pjw.166.1617925561416;
        Thu, 08 Apr 2021 16:46:01 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id l1sm410489pgt.29.2021.04.08.16.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 16:46:01 -0700 (PDT)
Date:   Thu, 8 Apr 2021 16:45:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org, leon@kernel.org,
        andrew@lunn.ch, bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210408164552.2d67f7b1@hermes.local>
In-Reply-To: <20210408225840.26304-1-decui@microsoft.com>
References: <20210408225840.26304-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Apr 2021 15:58:40 -0700
Dexuan Cui <decui@microsoft.com> wrote:

> Add a VF driver for Microsoft Azure Network Adapter (MANA) that will be
> available in the future.
> 
> Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  MAINTAINERS                                   |    4 +-
>  drivers/net/ethernet/Kconfig                  |    1 +
>  drivers/net/ethernet/Makefile                 |    1 +
>  drivers/net/ethernet/microsoft/Kconfig        |   29 +
>  drivers/net/ethernet/microsoft/Makefile       |    5 +
>  drivers/net/ethernet/microsoft/mana/Makefile  |    6 +
>  drivers/net/ethernet/microsoft/mana/gdma.h    |  728 +++++++
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 1515 ++++++++++++++
>  .../net/ethernet/microsoft/mana/hw_channel.c  |  859 ++++++++
>  .../net/ethernet/microsoft/mana/hw_channel.h  |  186 ++
>  drivers/net/ethernet/microsoft/mana/mana.h    |  531 +++++
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 1827 +++++++++++++++++
>  .../ethernet/microsoft/mana/mana_ethtool.c    |  278 +++
>  .../net/ethernet/microsoft/mana/shm_channel.c |  292 +++
>  .../net/ethernet/microsoft/mana/shm_channel.h |   21 +
>  15 files changed, 6282 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/microsoft/Kconfig
>  create mode 100644 drivers/net/ethernet/microsoft/Makefile
>  create mode 100644 drivers/net/ethernet/microsoft/mana/Makefile
>  create mode 100644 drivers/net/ethernet/microsoft/mana/gdma.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_main.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana_en.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana_ethtool.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.h

Linux kernel doesn't do namespaces in the code, so every new driver needs
to worry about global symbols clashing

Please make sure there are not name conflicts with other drivers around variable or
functions name "gdma_". Noticed there is one driver in staging using similar
names (drivers/staging/ralink-gdma/ralink-gdma.c). Granted that is in the staging
doghouse so probably not important but might show up as a name conflict
with something like the randconfig testing.

