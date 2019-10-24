Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8EACE35FC
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409520AbfJXOwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:52:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42195 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409497AbfJXOwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:52:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B54F4206FC;
        Thu, 24 Oct 2019 10:52:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 24 Oct 2019 10:52:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=znKBAOkk+e/oSRCFn
        dkQgLOtrHfcO8rNO9vfSmgnYkQ=; b=KzKXnlyFalTrgu3DZZre9d81khZ5QNcoH
        gS0tAfojpzJqEXL4hR3LslR0gU6vRhT9icXemK99Ms9siWtRVBKhNCDgAt9PH4Ym
        mpg6P5nQPAYhRCil/Z4Hk9n/DWUFDq40UBWOnarzmSYSOAh3hTbcvHKHcPHF6cDq
        9FgTyHBIgdSluUeAglVLGYk3dSm0A3cmQtOnB9Lep6ebjGF2f97dGOs/yXnTfDHb
        rHFX+5fmpNsXTX2Wvjdoabn7fUkm4fFpN+yhseCNsVR9OXSojGsECUQu5IwbkPiG
        6M45kYN3nJUrAhgIePDKoZyET+ODd9lO2PTU6CRPhFEJTcFxcPKgA==
X-ME-Sender: <xms:rbqxXeF8PonY3_PpoCKgUjpoLt_Ypr8k6kQ0TWB58u8g6YOaZdq0ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrledugdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:rbqxXaBX5q_PvzyDrSzuz1T5LulA77qYLvc-0Gn1hy57DqKi0djuog>
    <xmx:rbqxXQ3Zzgz0oIfgd6MHD4P7LIFRQfCep995aLgj5RQt91YFRg2L1Q>
    <xmx:rbqxXfO6BWNliBUiNMepjWcYF7bJdGixozd9Y66ledRWG247ULBicg>
    <xmx:rbqxXXrgdO5SAE1d9vqUtO-MAsTxaOVSeeETwmnwrLHtgi7DX_TFyA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F4DC8005A;
        Thu, 24 Oct 2019 10:52:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/3] mlxsw: Update firmware version
Date:   Thu, 24 Oct 2019 17:51:46 +0300
Message-Id: <20191024145149.6417-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set updates the firmware version for Spectrum-1 and enforces
a firmware version for Spectrum-2.

The version adds support for querying port module type. It will be used
by a followup patch set from Jiri to make port split code more generic.

Patch #1 increases the size of an existing register in order to be
compatible with the new firmware version. In the future the firmware
will assign default values to fields not specified by the driver.

Patch #2 bumps the firmware version for Spectrum-1.

Patch #3 enforces a minimum firmware version for Spectrum-2.

Ido Schimmel (3):
  mlxsw: reg: Increase size of MPAR register
  mlxsw: Bump firmware version to 13.2000.2308
  mlxsw: Enforce firmware version for Spectrum-2

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 20 ++++++++++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

-- 
2.21.0

