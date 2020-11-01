Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461632A1E59
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 14:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgKANmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 08:42:51 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35821 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbgKANmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 08:42:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B7E435C00A7;
        Sun,  1 Nov 2020 08:42:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 01 Nov 2020 08:42:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RU/6tjayiABAOOpR1
        iQXLDzZYeMlpM00B/fhhQmUO6E=; b=L3LQC+sNCn4iRab7p+aL06CaJTkn3/MIR
        9Fzm9wj6dRjJG5oKICvDLlzYX2AEOx+rzwqb6Ml6VYEO0JLJ0fzWeVqz1fmcWLFI
        FV23nVaau4GONu+sgK8KAQgjEctukEDdHCBbdBnFcYqzFqRsXN8Df3arnW+FE2vX
        TJ47Sa9bHBC659kWKH9sIMPhu5s9yDiYruj9Q1PaX1IbnakA50djjxpUG8GbekLW
        u2dFj5UXvaIZaagNlgcXibUonqfpMRtZ2Z5Kt3JRlQe+bTGRJMScm+h/pEyA9Y5g
        gGuutJTYaCgsQd8zetQh67TuinsGgVt0DbLt+10jxILyYHkplAO2g==
X-ME-Sender: <xms:WbueXzGKS6TvWAz5ayQlEpbSldMWwnEmz9otXMwbLxEnD5FB0PfO2Q>
    <xme:WbueXwX5c_1yEtI5rHJGw4fR5B-XxM-mxY8uxYVpMw_VTXqz9-OGaNS1rAh2trBqK
    EMMq6j_sBpCMZM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleelgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheehrddukedvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WbueX1LdF_qPotrmZEV37KPiU5pUAifDAP5RffeCAqNbxge8yYG3WA>
    <xmx:WbueXxFUfFU_seCGcLlg6-8iCdEJCjgr_bZ3Ehi8CxLuF3_54_6nsA>
    <xmx:WbueX5XVZpNpB89NR0QcorYwuFV-YtRkRWfTH7kjE_ixVHP4r4IEJg>
    <xmx:WbueX2ggPQWyjL6kp8ZB7Uh_z5V0TbLT4DryaPcKLHzCY3pX9tyh6w>
Received: from shredder.mtl.com (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA6063064680;
        Sun,  1 Nov 2020 08:42:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/2] mlxsw: spectrum: Prepare for XM implementation - LPM trees
Date:   Sun,  1 Nov 2020 15:42:13 +0200
Message-Id: <20201101134215.713708-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Jiri says:

This is a preparation patchset for follow-up support of boards with
extended mezzanine (XM), which are going to allow extended (scale-wise)
router offload.

XM requires a separate set of PRM registers to be used to configure LPM
trees. Therefore, this patchset introduces operations that allow
different implementations of tree configuration for legacy router
offload and the XM router offload.

Jiri Pirko (2):
  mlxsw: reg: Add XRALXX Registers
  mlxsw: spectrum_router: Introduce low-level ops and implement them for
    RALXX regs

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  83 ++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 120 ++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  11 ++
 3 files changed, 173 insertions(+), 41 deletions(-)

-- 
2.26.2

