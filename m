Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC27316849
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 14:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhBJNuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 08:50:01 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15454 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhBJNt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 08:49:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023e45c0000>; Wed, 10 Feb 2021 05:49:16 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 13:49:15 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 13:48:52 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v3 0/5] Extend uAPI with lanes parameter
Date:   Wed, 10 Feb 2021 15:48:35 +0200
Message-ID: <20210210134840.2187696-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612964956; bh=gJsYks7T7uBqBjf4J9M+0Kp5mXFhm4R76QGvpwj1Pow=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=btrmcw6zRAFuvx0fnEjEgtVRoxoVV2rECFZKOmZLuXigY6eAVmMJLOCwtJ589vSav
         GQnvuMFzi70/eZ1Cx0dWuTVimNoBiZ57Edu+ucGQ0UhTWeGEC25Hg1dPH+3p8GK1f6
         48Rfip4afWulnf3UkJAIvhpN5dOIBPUIYy1lb5GpxqT2mvL+mBjr7Htx3M+MynmXv7
         rwWdgXwrKZoZRoBgrWJtQNxc/kFqUIEvH0rZMuJ5uQrODHAvU/d0MZVDBmknKBmyAF
         fe3W2MQo+8XVPjRi4ni9xOJlSsih+xyuihNxYZk/m2twM5FLKa0ny89lpQq5S9BHbK
         HmNrQaiIRgtfw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is no way of knowing how many lanes will be use to
achieve a wanted speed.
For example, 100G speed can be achieved using: 2X50 or 4X25.

In order to solve that, extend ethtool uAPI with lanes as a new link
mode setting so the command below, for example, will be supported:
$ ethtool -s swp5 lanes N

Patch #1: Update headers with the new parameter.
Patch #2: Support lanes in netlink.
Patch #3: Expose the number of lanes in use.
Patch #4: Add auto-completion for lanes.
Patch #5: Add lanes to man page.

v3:
	* Add a seperated patch, patch #1, for uapi headers and squash
	* the rest of it to patch #2.

Danielle Ratson (5):
  update UAPI header copies
  netlink: settings: Add netlink support for lanes parameter
  netlink: settings: Expose the number of lanes in use
  shell-completion: Add completion for lanes
  man: Add man page for setting lanes parameter

 ethtool.8.in                  |  4 ++++
 ethtool.c                     |  1 +
 netlink/desc-ethtool.c        |  1 +
 netlink/settings.c            | 13 +++++++++++++
 shell-completion/bash/ethtool |  4 ++++
 uapi/linux/ethtool.h          |  2 +-
 uapi/linux/ethtool_netlink.h  |  1 +
 uapi/linux/if_link.h          | 10 ++++++++--
 uapi/linux/netlink.h          |  2 +-
 uapi/linux/rtnetlink.h        | 20 +++++++++++++++-----
 10 files changed, 49 insertions(+), 9 deletions(-)

--=20
2.26.2

