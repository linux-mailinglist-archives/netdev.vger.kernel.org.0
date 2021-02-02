Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB2A30C9BF
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbhBBS1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:27:33 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10985 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238556AbhBBS0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:26:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601999190001>; Tue, 02 Feb 2021 10:25:29 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:25:27 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v2 0/5] Extend uAPI with lanes parameter
Date:   Tue, 2 Feb 2021 20:25:08 +0200
Message-ID: <20210202182513.325864-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612290329; bh=heNa+sT75JX7QZQ8tWtenmOAquBuWtQyjDID4fSnQds=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=NHJDLS04CeF95y08B+q/0FKOtsvAFAyp6NQ3ei+5OGd7/lrSqi2cJmhKumiNAZuPY
         AlesmXR0cXasElnOshv/x7BShawJMUaj8bpFBZdrKxKGkI7AAcPbC1WrAkGPUKmVIX
         yQvGeRo2K2YeNpEPhTS4r49rwQcPyJORabLCBBZKQWAoPXaAl1feYftu6ZS0LU0lxh
         StOpxiFFibeuZlkHdfIIHlVP1U7QqlCXNQExvQEx3Oj3fnTPQM+F3yCmkKrXX8WZvp
         pSoQVIWDUEJh4bGWIL18kse9c6rYSUc+YB+hg5t3qo0MKbC5yLcPqXqb+kfawEy8SW
         Ytz/A6puIlz6w==
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

Danielle Ratson (5):
  ethtool: Extend ethtool link modes settings uAPI with lanes
  netlink: settings: Add netlink support for lanes parameter
  netlink: settings: Expose the number of lanes in use
  shell-completion: Add completion for lanes
  man: Add man page for setting lanes parameter

 ethtool.8.in                  |  4 ++++
 ethtool.c                     |  1 +
 netlink/desc-ethtool.c        |  1 +
 netlink/settings.c            | 14 ++++++++++++++
 shell-completion/bash/ethtool |  4 ++++
 uapi/linux/ethtool_netlink.h  |  1 +
 6 files changed, 25 insertions(+)

--=20
2.26.2

