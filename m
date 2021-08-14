Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51053EC1CB
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbhHNJ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhHNJ6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 05:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CEC260F00;
        Sat, 14 Aug 2021 09:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628935057;
        bh=xWmu3S7OhqJfrbNVVEnLPn9gGWPZvZk00Od0nr+U3mE=;
        h=From:To:Cc:Subject:Date:From;
        b=exciBrD6mgJ6qsPR3T1C0+14IVEMccWVq5qMCQp1yqJq4gjOtfbEtK+eXQ9uRRhIY
         xa1fI7ITnMVcqK4CYQvf/S5sG6X8pBlcrfvIyvbqt4jIXJXsCWwUnY4z6NDIF44K2Z
         xDABUwOEWSQwEVezCoEpwANqDZHY/QrP/5Ig867OKxGhOqJxU7e9TenuCUpyVu/5cl
         h5ard2w5kzFFB/nr1fvpZdhV5nFJyHrLhCvha36h9njjAVimmnrCU1Ba49pK5GDF81
         evZG7N9v41jA4yiW+YMfTTq4Rh1KJ9bav4nsIR6vTF5QdZDLxJogQPwuWlfg/oMQtU
         IOtOEzBN+6nBA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 0/6] Devlink cleanup for delay event series
Date:   Sat, 14 Aug 2021 12:57:25 +0300
Message-Id: <cover.1628933864.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi, 

Jakub's request to make sure that devlink events are delayed and not
printed till they fully accessible [1] requires us to implement delayed
event notification system in the devlink.

In order to do it, I moved some of my patches (xarray e.t.c) from the future
series to be before "Move devlink_register to be near devlink_reload_enable" [2].

That allows us to rely on DEVLINK_REGISTERED xarray mark to decide if to print
event or not.

Other patches are simple cleanup which is needed anyway.

[1] https://lore.kernel.org/lkml/20210811071817.4af5ab34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com
[2] https://lore.kernel.org/lkml/cover.1628599239.git.leonro@nvidia.com

Next in the queue:
 * Delay event series
 * Move devlink_register to be near devlink_reload_enable"
 * Extension of devlink_ops to be set dynamically
 * devlink_reload_* delete
 * Devlink locks rework to user xarray and reference counting
 * ????

Thanks

Leon Romanovsky (6):
  devlink: Simplify devlink_pernet_pre_exit call
  devlink: Remove check of always valid devlink pointer
  devlink: Count struct devlink consumers
  devlink: Use xarray to store devlink instances
  devlink: Clear whole devlink_flash_notify struct
  net: hns3: remove always exist devlink pointer check

 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   8 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   8 +-
 include/net/devlink.h                         |   4 +-
 net/core/devlink.c                            | 391 ++++++++++++------
 4 files changed, 273 insertions(+), 138 deletions(-)

-- 
2.31.1

