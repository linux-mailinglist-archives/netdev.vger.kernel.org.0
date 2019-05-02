Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F40611808
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 13:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfEBLNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 07:13:49 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43429 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfEBLNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 07:13:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F53825AA9;
        Thu,  2 May 2019 07:13:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 02 May 2019 07:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=492Z9vlXXS9RhRhjF
        +IeoAkN1wxOy1r3aToAzxgQWh8=; b=GPr6zHMwYRKAciMyhuWwMgJd0/uga+9yH
        tAX1RP4C5RGyt+/JTJ7n153pqz0VhKU1nTH75f0FgPL5aIj9x9hAoPPm4huoC2st
        u3f9SrVrFihTJTz/XO6pZ1gU2txx3PMpMMfiqsth8Vn8dfKp7ttMPLAwX+hma2no
        vXes9sAuiY/p3iXiVM/+v7ywze6h1sheGgRut1P4HhAqLSbrQ8v4uR/rKpOck+xJ
        6lc4z3ZIVIPl2CqP8uBIGrnB548W0S9Wy/vnsiB4ouY/ag8Rf6PDnXJDMIv9N4nv
        QEsqGab8O+iGSqWiXuMgAgBzKJfiNm95JPZ4KSPnw/QraVodfhyVg==
X-ME-Sender: <xms:69DKXEIwNx8hH_IRdfUlxhd_szwZb50GCkp0huYGOARIYskwt5pzkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:69DKXN_4Hw3W9MsNlLF9ozzMhwH2F9o7dFUIpyF7ebdrONsQ1xueFQ>
    <xmx:69DKXIaHhMK-KnM7wZVGDtW_6KWZJdGE82y45OWcMNlzlpuJsB09Cw>
    <xmx:69DKXMUjPrS0TCuhaz1awkktKLWHHnyhXshX80cwT9aT7MqN4ZTlOw>
    <xmx:7NDKXHTFdkXu5dCDQef2-n72hYugCpx6hp_CxY5Yf1cBjXwZqzVTvw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9474DE479B;
        Thu,  2 May 2019 07:13:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/3] mlxsw: Firmware version update
Date:   Thu,  2 May 2019 14:13:06 +0300
Message-Id: <20190502111309.6590-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset updates mlxsw to use a new firmware version and adds
support for split into two ports on Spectrum-2 based systems.

Patch #1 updates the firmware version to 13.2000.1122

Patch #2 queries new resources from the firmware.

Patch #3 makes use of these resources in order to support split into two
ports on Spectrum-2 based systems. The need for these resources is
explained by Shalom:

When splitting a port, different local ports need to be mapped on different
systems. For example:

SN3700 (local_ports_in_2x=2):
  * Without split:
      front panel 1   --> local port 1
      front panel 2   --> local port 5
  * Split to 2:
      front panel 1s0 --> local port 1
      front panel 1s1 --> local port 3
      front panel 2   --> local port 5

SN3800 (local_ports_in_2x=1):
  * Without split:
      front panel 1 --> local port 1
      front panel 2 --> local port 3
  * Split to 2:
      front panel 1s0 --> local port 1
      front panel 1s1 --> local port 2
      front panel 2   --> local port 3

The local_ports_in_{1x, 2x} resources provide the offsets from the base
local ports according to which the new local ports can be calculated.

Ido Schimmel (1):
  mlxsw: Bump firmware version to 13.2000.1122

Shalom Toledo (2):
  mlxsw: resources: Add local_ports_in_{1x, 2x}
  mlxsw: spectrum: split base on local_ports_in_{1x, 2x} resources

 .../net/ethernet/mellanox/mlxsw/resources.h   |  4 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 50 ++++++++++++++-----
 2 files changed, 41 insertions(+), 13 deletions(-)

-- 
2.20.1

