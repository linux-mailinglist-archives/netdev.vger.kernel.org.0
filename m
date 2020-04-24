Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CEC1B7A5F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgDXPoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:44:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40759 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbgDXPoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:44:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9B4185C07D5;
        Fri, 24 Apr 2020 11:44:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 24 Apr 2020 11:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fbB08Gb66Ea8zEMWa
        8zmgM8H8wxyKwgXUErNznspfcI=; b=LSRN1o+DxRWEgYZOmg/Edo9KSA6kX75Zn
        exH8mzp0gQHXwS0zmIhQ94CGhbmFJN9tRJouQf9w95XvhgYgJuAiN/c74b2aZQgi
        RvcFGPCTNlSvOChfbH3I7xIhAA/KEuwCFS8rqC7MJ9jntOt74U8aKnrAUy6BnUWR
        qAGB9y/pLHyMjWSUPXTlCLY6p/vCcdCy/sz9o4W8xhAGuSv0DRFeIkYjQqivG53w
        Ef+C76wer50jn7jDdquGISChCCXEAJYKMBph0HfX8Ck8+7S654UuOrQKPtMqCQZJ
        Xqq8yIjkK9KSesz0Ar4d+VPCps4tNRqmYy55HbXkwsH74PWVjKGQQ==
X-ME-Sender: <xms:TAmjXqK-K1tPHPwCBtkv6Eihgq9PIWt023FnCKucSAayMQXKm4x5Ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrhedugdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:TAmjXivdLqgq_4rBLwKXEtstD6D6cLQl95BfIxWWWwjHuFm4ukD7iQ>
    <xmx:TAmjXjn87jwqMPlCUJCa7RQRH3gjh2yKSMtVgEMPtaKUKwNnNrOZ2Q>
    <xmx:TAmjXpnmMsMyeI--XCorMmBs2v6eBlRLGTML1nAke4gRpBiS3rqphQ>
    <xmx:TAmjXjk_DawE1XH2pPcQ6Pp1ZSPiG9hurM8xnndrACpjh38ub9_0dA>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 467553065D9F;
        Fri, 24 Apr 2020 11:44:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/5] mlxsw: Mirroring cleanups
Date:   Fri, 24 Apr 2020 18:43:40 +0300
Message-Id: <20200424154345.3677009-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains various cleanups in SPAN (mirroring) code
noticed by Amit and I while working on future enhancements in this area.
No functional changes intended. Tested by current mirroring selftests.

Patches #1-#2 from Amit reduce nesting in a certain function and rename
a callback to a more meaningful name.

Patch #3 removes debug prints that have little value.

Patch #4 converts a reference count to 'refcount_t' in order to catch
over/under flows.

Patch #5 replaces a zero-length array with flexible-array member in
order to get a compiler warning in case the flexible array does not
occur last in the structure.

Amit Cohen (2):
  mlxsw: spectrum_span: Reduce nesting in
    mlxsw_sp_span_entry_configure()
  mlxsw: spectrum_span: Rename parms() to parms_set()

Ido Schimmel (3):
  mlxsw: spectrum_span: Remove unnecessary debug prints
  mlxsw: spectrum_span: Use 'refcount_t' for reference counting
  mlxsw: spectrum_span: Replace zero-length array with flexible-array
    member

 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 66 ++++++++++---------
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  7 +-
 2 files changed, 39 insertions(+), 34 deletions(-)

-- 
2.24.1

