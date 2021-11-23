Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF400459D2F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 08:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhKWH5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 02:57:06 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40375 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233578AbhKWH5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 02:57:05 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C434F5C0175;
        Tue, 23 Nov 2021 02:53:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Nov 2021 02:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=r5qJFaZ6EfZghqN1Y
        ayP5iPYpe6X/RzMfNziGhcvbpk=; b=Asj6sfDDv1X63kwpu6Le6retOZ6fqxfHQ
        Tc/SsAiPNw85tH3yTS3BRnSofC7kbK/qJbsHQQEF7hTyEwA2C4ejOO8LsHyA0NNh
        nLSOoz+hm8Gz9VTh64O8ErR5Z6JwrtubTBp8xsQpDPBFOLshfMEsqOLfwo7aWGR+
        K+92cNtRjx737+bbptOUqksGayLYvcUKlLgSUINoHDl84nRN5+k3wKMzy/ulb0jY
        xIFacEukDeBTeGS0IV7n7x/M17AJX1q2m7sk5MLZItn26LEAwNtmwxUonLons/Jb
        W72e41LaoDkxlWSc70n6MdLwZatAUJxNwwBF7oXsCjslLr/xKW34w==
X-ME-Sender: <xms:FZ6cYe-IQbYxKc2A47NFuCvABcbHFeQgIJuNe5Sh_YR9ElvH6a63Gg>
    <xme:FZ6cYesjOEEAZsSRGHQliQjLPFIdoJQa03hMkmDfeNQBDKP8bKlKgTvwgH7bCTHK8
    MzUWI-0ZpQH7uc>
X-ME-Received: <xmr:FZ6cYUDFMBOQZNjYDIvk8Wp8UuPTY1YZurdh59tXCU1TI2SJKNmBPHYqCnCYvTzKBbWVf9ttCpIzpEToRDOsM3nd1Yj3UmSXbWSQLHqcu0behA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FZ6cYWfo3phpw-izwYmxBxyUTvY9flG_ol2U6cvalodxVitRwj5kLw>
    <xmx:FZ6cYTNC7ShCpEu6-BERs6_MJEVRzK1YhW5pgzOK20DJ7u3pwLU5LA>
    <xmx:FZ6cYQmeaVg0wId96L5sDyvGF3upDpt9cMsdJDTW55VVx7W4HEqyiA>
    <xmx:FZ6cYcpbulL6aMJ6ZCaKuYPOzDAMoWhxDPovPdAK82K0Xlrhmg-CFg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 02:53:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] mlxsw: Two small fixes
Date:   Tue, 23 Nov 2021 09:52:54 +0200
Message-Id: <20211123075256.3083281-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 fixes a recent regression that prevents the driver from loading
with old firmware versions.

Patch #2 protects the driver from a NULL pointer dereference when
working on top of a buggy firmware. This was never observed in an actual
system, only on top of an emulator during development.

Amit Cohen (1):
  mlxsw: spectrum: Protect driver from buggy firmware

Danielle Ratson (1):
  mlxsw: spectrum: Allow driver to load with old firmware versions

 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.31.1

